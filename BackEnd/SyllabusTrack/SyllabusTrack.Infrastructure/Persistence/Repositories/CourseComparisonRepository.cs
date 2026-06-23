using Microsoft.EntityFrameworkCore;
using SyllabusTrack.Application.Features.CourseComparison;

namespace SyllabusTrack.Infrastructure.Persistence.Repositories;

/// <summary>
/// Compara as disciplinas de dois cursos pelo nome (case-insensitive, trim).
///
/// Algoritmo:
///   1. CTE SourceSubjects: nomes únicos (lower/trim) de todas as disciplinas
///      ativas com carga horária > 0 do curso de referência.
///   2. Para cada disciplina ativa do curso-alvo (CH > 0), verifica se o nome
///      existe no CTE via LEFT JOIN → IsMatched.
///   3. Duas queries auxiliares trazem o nome do programa e instituição.
/// </summary>
internal sealed class CourseComparisonRepository(AppDbContext dbContext)
    : ICourseComparisonRepository
{
    // -------------------------------------------------------------------------
    // Tipos internos para projeção do SQL
    // -------------------------------------------------------------------------
    private sealed record ProgramInfoRow(
        int    ProgramId,
        string ProgramName,
        string InstitutionName);

    private sealed record SubjectRow(
        string SubjectName,
        int    Hours,
        int    TermNumber,
        bool   IsMatched);

    // -------------------------------------------------------------------------

    public async Task<CourseComparisonResponse?> CompareAsync(
        int sourceProgramId,
        int targetProgramId,
        CancellationToken cancellationToken = default)
    {
        // 1. Info do curso de referência
        var sourceInfo = await dbContext.Database
            .SqlQuery<ProgramInfoRow>($"""
                SELECT p.ProgramId, p.ProgramName, i.InstitutionName
                FROM   DegreeProgram            p
                JOIN   EducationalInstitution   i ON i.InstitutionId = p.InstitutionId
                WHERE  p.ProgramId = {sourceProgramId} AND p.IsActive = 1
                """)
            .FirstOrDefaultAsync(cancellationToken);

        if (sourceInfo is null) return null;

        // 2. Info do curso-alvo
        var targetInfo = await dbContext.Database
            .SqlQuery<ProgramInfoRow>($"""
                SELECT p.ProgramId, p.ProgramName, i.InstitutionName
                FROM   DegreeProgram            p
                JOIN   EducationalInstitution   i ON i.InstitutionId = p.InstitutionId
                WHERE  p.ProgramId = {targetProgramId} AND p.IsActive = 1
                """)
            .FirstOrDefaultAsync(cancellationToken);

        if (targetInfo is null) return null;

        // 3. Comparação de disciplinas (CTE + LEFT JOIN)
        var subjects = await dbContext.Database
            .SqlQuery<SubjectRow>($"""
                WITH SourceSubjects AS (
                    SELECT DISTINCT LOWER(LTRIM(RTRIM(s.SubjectName))) AS SubjectName
                    FROM   AcademicTerm     t
                    JOIN   CourseModule     m  ON m.TermId   = t.TermId
                    JOIN   AcademicSubject  s  ON s.ModuleId = m.ModuleId
                    WHERE  t.ProgramId            = {sourceProgramId}
                      AND  s.IsActive             = 1
                      AND  s.TotalSubjectHours    > 0
                )
                SELECT
                    s.SubjectName,
                    s.TotalSubjectHours                                             AS Hours,
                    t.TermNumber,
                    CASE WHEN ss.SubjectName IS NOT NULL THEN CAST(1 AS BIT)
                         ELSE                                CAST(0 AS BIT)
                    END                                                             AS IsMatched
                FROM   AcademicTerm     t
                JOIN   CourseModule     m   ON m.TermId   = t.TermId
                JOIN   AcademicSubject  s   ON s.ModuleId = m.ModuleId
                LEFT JOIN SourceSubjects ss ON ss.SubjectName = LOWER(LTRIM(RTRIM(s.SubjectName)))
                WHERE  t.ProgramId         = {targetProgramId}
                  AND  s.IsActive          = 1
                  AND  s.TotalSubjectHours > 0
                ORDER BY t.TermNumber, s.SubjectName
                """)
            .ToListAsync(cancellationToken);

        // 4. Cálculo dos totais
        var totalSubjects   = subjects.Count;
        var totalHours      = subjects.Sum(s => s.Hours);
        var matchedSubjects = subjects.Count(s => s.IsMatched);
        var matchedHours    = subjects.Where(s => s.IsMatched).Sum(s => s.Hours);
        var remaining       = totalSubjects - matchedSubjects;
        var remainingHours  = totalHours - matchedHours;

        var subjectPct = totalSubjects > 0
            ? Math.Round((decimal)matchedSubjects / totalSubjects * 100, 1)
            : 0m;

        var hoursPct = totalHours > 0
            ? Math.Round((decimal)matchedHours / totalHours * 100, 1)
            : 0m;

        var items = subjects
            .Select(s => new ComparedSubjectItem(s.SubjectName, s.Hours, s.TermNumber, s.IsMatched))
            .ToList()
            .AsReadOnly();

        return new CourseComparisonResponse(
            sourceProgramId,
            sourceInfo.ProgramName,
            sourceInfo.InstitutionName,
            targetProgramId,
            targetInfo.ProgramName,
            targetInfo.InstitutionName,
            totalSubjects,
            totalHours,
            matchedSubjects,
            matchedHours,
            remaining,
            remainingHours,
            subjectPct,
            hoursPct,
            items);
    }
}
