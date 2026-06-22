using Microsoft.EntityFrameworkCore;
using SyllabusTrack.Application.Features.Recommendations;

namespace SyllabusTrack.Infrastructure.Persistence.Repositories;

/// <summary>
/// Recomenda cursos ordenados pelo aproveitamento das disciplinas já concluídas.
///
/// Algoritmo:
///   1. CTE CompletedNames: nomes (lower/trim) de todas as disciplinas com status
///      Completed em qualquer matrícula ativa do aluno.
///   2. Para cada curso que o aluno NÃO está matriculado, conta total de disciplinas
///      (CH > 0) e quantas têm nome presente no CTE (LEFT JOIN).
///   3. Ordena por % de aproveitamento DESC, desempate por restantes ASC.
///
/// SQL Server não aceita subquery dentro de COUNT(DISTINCT CASE WHEN ... IN (subquery)).
/// Solução: CTE + LEFT JOIN.
/// </summary>
internal sealed class ProgramRecommendationRepository(AppDbContext dbContext)
    : IProgramRecommendationRepository
{
    private sealed record RecommendationRow(
        int    ProgramId,
        string ProgramName,
        string CurriculumVersion,
        int    TotalSemesters,
        string InstitutionName,
        string InstitutionAcronym,
        int    TotalSubjects,
        int    MatchedSubjects
    );

    public async Task<IReadOnlyCollection<ProgramRecommendationResponse>> GetRecommendationsAsync(
        int studentId,
        CancellationToken cancellationToken = default)
    {
        var rows = await dbContext.Database
            .SqlQuery<RecommendationRow>($"""
                WITH CompletedNames AS (
                    SELECT DISTINCT LOWER(LTRIM(RTRIM(s2.SubjectName))) AS SubjectName
                    FROM   StudentProgress   sp2
                    JOIN   AcademicSubject   s2  ON s2.SubjectId    = sp2.SubjectId
                    JOIN   StudentEnrollment se2 ON se2.EnrollmentId = sp2.EnrollmentId
                    WHERE  se2.StudentId         = {studentId}
                      AND  se2.IsActive          = 1
                      AND  sp2.IsActive          = 1
                      AND  sp2.CompletionStatus  = 'Completed'
                )
                SELECT
                    p.ProgramId,
                    p.ProgramName,
                    p.CurriculumVersion,
                    p.TotalSemesters,
                    i.InstitutionName,
                    i.InstitutionAcronym,
                    COUNT(DISTINCT s.SubjectId) AS TotalSubjects,
                    COUNT(DISTINCT CASE WHEN cn.SubjectName IS NOT NULL THEN s.SubjectId END) AS MatchedSubjects
                FROM DegreeProgram         p
                JOIN EducationalInstitution i  ON i.InstitutionId = p.InstitutionId
                JOIN AcademicTerm           t  ON t.ProgramId     = p.ProgramId
                JOIN CourseModule            m  ON m.TermId        = t.TermId
                JOIN AcademicSubject         s  ON s.ModuleId      = m.ModuleId
                LEFT JOIN CompletedNames    cn  ON cn.SubjectName  = LOWER(LTRIM(RTRIM(s.SubjectName)))
                WHERE p.ProgramId NOT IN (
                    SELECT ProgramId
                    FROM   StudentEnrollment
                    WHERE  StudentId = {studentId} AND IsActive = 1
                )
                  AND s.IsActive          = 1
                  AND s.TotalSubjectHours > 0
                GROUP BY
                    p.ProgramId, p.ProgramName, p.CurriculumVersion, p.TotalSemesters,
                    i.InstitutionName, i.InstitutionAcronym
                """)
            .ToListAsync(cancellationToken);

        return rows
            .Select(r =>
            {
                var remaining = r.TotalSubjects - r.MatchedSubjects;
                var matchPct  = r.TotalSubjects > 0
                    ? Math.Round((decimal)r.MatchedSubjects / r.TotalSubjects * 100, 1)
                    : 0m;

                return new ProgramRecommendationResponse(
                    r.ProgramId,
                    r.ProgramName,
                    r.CurriculumVersion,
                    r.TotalSemesters,
                    r.InstitutionName,
                    r.InstitutionAcronym,
                    r.TotalSubjects,
                    r.MatchedSubjects,
                    remaining,
                    matchPct);
            })
            .OrderByDescending(r => r.MatchPercentage)
            .ThenBy(r => r.RemainingSubjects)
            .ToList()
            .AsReadOnly();
    }
}
