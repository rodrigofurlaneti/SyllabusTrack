using Microsoft.EntityFrameworkCore;
using SyllabusTrack.Application.Features.AcademicPlanning;

namespace SyllabusTrack.Infrastructure.Persistence.Repositories;

/// <summary>
/// Gera o planejamento acadêmico comparando disciplinas por semestre.
///
/// Algoritmo:
///   1. CTE SourceSubjects: nomes únicos (lower/trim, CH > 0) do curso de referência.
///   2. Para cada disciplina ativa do curso-alvo (CH > 0), verifica match por nome.
///   3. Em C#: agrupa por semestre → calcula aproveitamento por semestre → estima tempo.
///
/// Estimativa de tempo:
///   - EffectiveSemestersNeeded = semestres do alvo com ≥1 disciplina restante.
///   - EstimatedYears           = EffectiveSemestersNeeded / 2 (2 semestres/ano).
///   - YearsSaved               = OriginalYears - EstimatedYears.
/// </summary>
internal sealed class AcademicPlanningRepository(AppDbContext dbContext)
    : IAcademicPlanningRepository
{
    // ── projeções SQL ────────────────────────────────────────────────────────
    private sealed record ProgramInfoRow(
        int    ProgramId,
        string ProgramName,
        string InstitutionName,
        int    TotalSemesters);

    private sealed record SubjectRow(
        string SubjectName,
        int    Hours,
        int    TermNumber,
        bool   IsMatched);

    // ────────────────────────────────────────────────────────────────────────

    public async Task<AcademicPlanningResponse?> GetPlanAsync(
        int sourceProgramId,
        int targetProgramId,
        CancellationToken cancellationToken = default)
    {
        // 1. Info do curso de referência
        var sourceInfo = await dbContext.Database
            .SqlQuery<ProgramInfoRow>($"""
                SELECT p.ProgramId, p.ProgramName, i.InstitutionName, p.TotalSemesters
                FROM   DegreeProgram            p
                JOIN   EducationalInstitution   i ON i.InstitutionId = p.InstitutionId
                WHERE  p.ProgramId = {sourceProgramId} AND p.IsActive = 1
                """)
            .FirstOrDefaultAsync(cancellationToken);

        if (sourceInfo is null) return null;

        // 2. Info do curso-alvo
        var targetInfo = await dbContext.Database
            .SqlQuery<ProgramInfoRow>($"""
                SELECT p.ProgramId, p.ProgramName, i.InstitutionName, p.TotalSemesters
                FROM   DegreeProgram            p
                JOIN   EducationalInstitution   i ON i.InstitutionId = p.InstitutionId
                WHERE  p.ProgramId = {targetProgramId} AND p.IsActive = 1
                """)
            .FirstOrDefaultAsync(cancellationToken);

        if (targetInfo is null) return null;

        // 3. Disciplinas do curso-alvo com flag de aproveitamento
        var rows = await dbContext.Database
            .SqlQuery<SubjectRow>($"""
                WITH SourceSubjects AS (
                    SELECT DISTINCT LOWER(LTRIM(RTRIM(s.SubjectName))) AS SubjectName
                    FROM   AcademicTerm     t
                    JOIN   CourseModule     m  ON m.TermId   = t.TermId
                    JOIN   AcademicSubject  s  ON s.ModuleId = m.ModuleId
                    WHERE  t.ProgramId         = {sourceProgramId}
                      AND  s.IsActive          = 1
                      AND  s.TotalSubjectHours > 0
                )
                SELECT
                    s.SubjectName,
                    s.TotalSubjectHours                                              AS Hours,
                    t.TermNumber,
                    CASE WHEN ss.SubjectName IS NOT NULL THEN CAST(1 AS BIT)
                         ELSE                                CAST(0 AS BIT)
                    END                                                              AS IsMatched
                FROM   AcademicTerm     t
                JOIN   CourseModule     m   ON m.TermId   = t.TermId
                JOIN   AcademicSubject  s   ON s.ModuleId = m.ModuleId
                LEFT JOIN SourceSubjects ss ON ss.SubjectName = LOWER(LTRIM(RTRIM(s.SubjectName)))
                WHERE  t.ProgramId         = {targetProgramId}
                  AND  s.IsActive          = 1
                  AND  s.TotalSubjectHours > 0
                """)
            .ToListAsync(cancellationToken);

        // 4. Agrupa por semestre e constrói SemesterPlanItems
        var semesterPlans = rows
            .GroupBy(r => r.TermNumber)
            .OrderBy(g => g.Key)
            .Select(g =>
            {
                var subjects       = g.ToList();
                var totalSubj      = subjects.Count;
                var totalHrs       = subjects.Sum(s => s.Hours);
                var matchedSubj    = subjects.Count(s => s.IsMatched);
                var matchedHrs     = subjects.Where(s => s.IsMatched).Sum(s => s.Hours);
                var remainSubj     = totalSubj - matchedSubj;
                var remainHrs      = totalHrs  - matchedHrs;
                var subjPct        = totalSubj > 0
                    ? Math.Round((decimal)matchedSubj / totalSubj * 100, 1) : 0m;
                var isFullyCred    = remainSubj == 0;

                var items = subjects
                    .Select(s => new PlannedSubjectItem(s.SubjectName, s.Hours, s.IsMatched))
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

        // 5. Totais globais
        var totalSubjects   = semesterPlans.Sum(s => s.TotalSubjects);
        var totalHours      = semesterPlans.Sum(s => s.TotalHours);
        var matchedSubjects = semesterPlans.Sum(s => s.MatchedSubjects);
        var matchedHours    = semesterPlans.Sum(s => s.MatchedHours);
        var remaining       = totalSubjects - matchedSubjects;
        var remainHours     = totalHours    - matchedHours;

        var subjPctGlobal = totalSubjects > 0
            ? Math.Round((decimal)matchedSubjects / totalSubjects * 100, 1) : 0m;
        var hoursPctGlobal = totalHours > 0
            ? Math.Round((decimal)matchedHours / totalHours * 100, 1) : 0m;

        // 6. Estimativa de tempo
        var effectiveSemesters   = semesterPlans.Count(s => s.RemainingSubjects > 0);
        var fullyCreditableSem   = semesterPlans.Count(s => s.IsFullyCreditable);
        var originalYears        = Math.Round((decimal)targetInfo.TotalSemesters / 2, 1);
        var estimatedYears       = Math.Round((decimal)effectiveSemesters / 2, 1);
        var yearsSaved           = Math.Round(originalYears - estimatedYears, 1);

        return new AcademicPlanningResponse(
            sourceProgramId,  sourceInfo.ProgramName, sourceInfo.InstitutionName,
            targetProgramId,  targetInfo.ProgramName, targetInfo.InstitutionName,
            targetInfo.TotalSemesters, totalSubjects, totalHours,
            matchedSubjects, matchedHours, remaining, remainHours,
            subjPctGlobal, hoursPctGlobal,
            effectiveSemesters, fullyCreditableSem,
            estimatedYears, originalYears, yearsSaved,
            semesterPlans);
    }
}
