using Microsoft.EntityFrameworkCore;
using SyllabusTrack.Application.Features.AcademicPlanning;
using SyllabusTrack.Application.Features.MultiplePlanning;
using SyllabusTrack.Application.Features.MultipleTargetsPlanning;

namespace SyllabusTrack.Infrastructure.Persistence.Repositories;

/// <summary>
/// Planejamento com N cursos de referência comparados contra N cursos-alvo.
///
/// Algoritmo:
///   1. Para cada curso-fonte coleta os nomes de disciplinas (lower/trim, CH > 0).
///   2. Faz a UNIÃO em memória em um HashSet — elimina duplicatas automaticamente.
///   3. Para cada curso-alvo repete o match em memória (reutilizando o mesmo HashSet).
///   4. Retorna um TargetProgramResult por alvo, com estatísticas e plano por semestre.
/// </summary>
internal sealed class MultipleTargetsPlanningRepository(AppDbContext dbContext)
    : IMultipleTargetsPlanningRepository
{
    // ── Tipos de projeção ────────────────────────────────────────────────────
    private sealed record ProgramInfoRow(
        int    ProgramId,
        string ProgramName,
        string InstitutionName,
        int    TotalSemesters);

    private sealed record SubjectNameRow(string SubjectName);

    private sealed record TargetSubjectRow(
        string SubjectName,
        int    Hours,
        int    TermNumber);

    // ────────────────────────────────────────────────────────────────────────

    public async Task<MultipleTargetsPlanningResponse?> GetMultipleTargetsPlanAsync(
        IReadOnlyCollection<int> sourceProgramIds,
        IReadOnlyCollection<int> targetProgramIds,
        CancellationToken cancellationToken = default)
    {
        // 1. Valida e carrega info de cada curso-fonte
        var sourceInfos = new List<ProgramInfoRow>();
        foreach (var srcId in sourceProgramIds)
        {
            var info = await dbContext.Database
                .SqlQuery<ProgramInfoRow>($"""
                    SELECT p.ProgramId, p.ProgramName, i.InstitutionName, p.TotalSemesters
                    FROM   DegreeProgram           p
                    JOIN   EducationalInstitution  i ON i.InstitutionId = p.InstitutionId
                    WHERE  p.ProgramId = {srcId} AND p.IsActive = 1
                    """)
                .FirstOrDefaultAsync(cancellationToken);

            if (info is null) return null;   // fonte não encontrada → 404
            sourceInfos.Add(info);
        }

        // 2. UNIÃO dos nomes de disciplinas de todos os cursos-fonte
        //    Cada query é parametrizada individualmente pelo EF Core (seguro, sem risco de injection).
        var unionNames = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        foreach (var srcId in sourceProgramIds)
        {
            var names = await dbContext.Database
                .SqlQuery<SubjectNameRow>($"""
                    SELECT DISTINCT LOWER(LTRIM(RTRIM(s.SubjectName))) AS SubjectName
                    FROM   AcademicTerm     t
                    JOIN   CourseModule     m  ON m.TermId   = t.TermId
                    JOIN   AcademicSubject  s  ON s.ModuleId = m.ModuleId
                    WHERE  t.ProgramId         = {srcId}
                      AND  s.IsActive          = 1
                      AND  s.TotalSubjectHours > 0
                    """)
                .ToListAsync(cancellationToken);

            foreach (var n in names)
                unionNames.Add(n.SubjectName);
        }

        // 3. Para cada curso-alvo: busca disciplinas e aplica o match com o HashSet acima
        var targetResults = new List<TargetProgramResult>();

        foreach (var tgtId in targetProgramIds)
        {
            var targetInfo = await dbContext.Database
                .SqlQuery<ProgramInfoRow>($"""
                    SELECT p.ProgramId, p.ProgramName, i.InstitutionName, p.TotalSemesters
                    FROM   DegreeProgram           p
                    JOIN   EducationalInstitution  i ON i.InstitutionId = p.InstitutionId
                    WHERE  p.ProgramId = {tgtId} AND p.IsActive = 1
                    """)
                .FirstOrDefaultAsync(cancellationToken);

            if (targetInfo is null) return null;   // alvo não encontrado → 404

            // Sem ORDER BY — EF Core 9 envolve SqlQuery em subquery e SQL Server rejeita ORDER BY dentro
            var targetSubjects = await dbContext.Database
                .SqlQuery<TargetSubjectRow>($"""
                    SELECT s.SubjectName, s.TotalSubjectHours AS Hours, t.TermNumber
                    FROM   AcademicTerm     t
                    JOIN   CourseModule     m  ON m.TermId   = t.TermId
                    JOIN   AcademicSubject  s  ON s.ModuleId = m.ModuleId
                    WHERE  t.ProgramId         = {tgtId}
                      AND  s.IsActive          = 1
                      AND  s.TotalSubjectHours > 0
                    """)
                .ToListAsync(cancellationToken);

            // Match em memória — O(1) por HashSet
            var semesterPlans = targetSubjects
                .GroupBy(r => r.TermNumber)
                .OrderBy(g => g.Key)
                .Select(g =>
                {
                    var subjects    = g.ToList();
                    var totalSubj   = subjects.Count;
                    var totalHrs    = subjects.Sum(s => s.Hours);
                    var matchedSubj = subjects.Count(s =>
                        unionNames.Contains(s.SubjectName.Trim().ToLowerInvariant()));
                    var matchedHrs  = subjects
                        .Where(s => unionNames.Contains(s.SubjectName.Trim().ToLowerInvariant()))
                        .Sum(s => s.Hours);
                    var remainSubj  = totalSubj - matchedSubj;
                    var remainHrs   = totalHrs  - matchedHrs;
                    var subjPct     = totalSubj > 0
                        ? Math.Round((decimal)matchedSubj / totalSubj * 100, 1) : 0m;
                    var isFullyCred = remainSubj == 0;

                    var items = subjects
                        .Select(s => new PlannedSubjectItem(
                            s.SubjectName,
                            s.Hours,
                            unionNames.Contains(s.SubjectName.Trim().ToLowerInvariant())))
                        .ToList()
                        .AsReadOnly();

                    return new SemesterPlanItem(
                        g.Key,
                        totalSubj, totalHrs,
                        matchedSubj, matchedHrs,
                        remainSubj, remainHrs,
                        subjPct, isFullyCred, items);
                })
                .ToList()
                .AsReadOnly();

            // Totais globais do alvo
            var totalSubjects   = semesterPlans.Sum(s => s.TotalSubjects);
            var totalHours      = semesterPlans.Sum(s => s.TotalHours);
            var matchedSubjects = semesterPlans.Sum(s => s.MatchedSubjects);
            var matchedHours    = semesterPlans.Sum(s => s.MatchedHours);
            var remaining       = totalSubjects - matchedSubjects;
            var remainHours     = totalHours    - matchedHours;

            var subjPctGlobal  = totalSubjects > 0
                ? Math.Round((decimal)matchedSubjects / totalSubjects * 100, 1) : 0m;
            var hoursPctGlobal = totalHours > 0
                ? Math.Round((decimal)matchedHours / totalHours * 100, 1) : 0m;

            var effectiveSemesters = semesterPlans.Count(s => s.RemainingSubjects > 0);
            var fullyCreditableSem = semesterPlans.Count(s => s.IsFullyCreditable);
            var originalYears      = Math.Round((decimal)targetInfo.TotalSemesters / 2, 1);
            var estimatedYears     = Math.Round((decimal)effectiveSemesters / 2, 1);
            var yearsSaved         = Math.Round(originalYears - estimatedYears, 1);

            targetResults.Add(new TargetProgramResult(
                tgtId,
                targetInfo.ProgramName,
                targetInfo.InstitutionName,
                targetInfo.TotalSemesters,
                totalSubjects, totalHours,
                matchedSubjects, matchedHours,
                remaining, remainHours,
                subjPctGlobal, hoursPctGlobal,
                effectiveSemesters, fullyCreditableSem,
                estimatedYears, originalYears, yearsSaved,
                semesterPlans));
        }

        var sourceSummaries = sourceInfos
            .Select(s => new SourceProgramSummary(s.ProgramId, s.ProgramName, s.InstitutionName))
            .ToList()
            .AsReadOnly();

        return new MultipleTargetsPlanningResponse(
            sourceSummaries,
            targetResults.AsReadOnly());
    }
}
