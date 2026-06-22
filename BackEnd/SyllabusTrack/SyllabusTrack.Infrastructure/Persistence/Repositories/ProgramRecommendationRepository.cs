using Microsoft.EntityFrameworkCore;
using SyllabusTrack.Application.Features.Recommendations;

namespace SyllabusTrack.Infrastructure.Persistence.Repositories;

/// <summary>
/// Implementação do repositório de recomendações usando raw SQL para performance.
///
/// Algoritmo:
///   1. Coleta os nomes (lower/trim) de TODAS as disciplinas concluídas pelo aluno
///      em QUALQUER matrícula ativa.
///   2. Para cada curso que o aluno NÃO está matriculado, conta quantas disciplinas
///      (com CH > 0, excluindo Projetos Interdisciplinares) têm nome que bate com
///      as concluídas.
///   3. Ordena por % de aproveitamento (matchedSubjects / totalSubjects) decrescente,
///      desempate por menor quantidade de disciplinas restantes.
/// </summary>
internal sealed class ProgramRecommendationRepository(AppDbContext dbContext)
    : IProgramRecommendationRepository
{
    // EF Core 8+ materializa POCOs via Database.SqlQuery<T>(FormattableString)
    private sealed record RecommendationRow(
        int     ProgramId,
        string  ProgramName,
        string  CurriculumVersion,
        int     TotalSemesters,
        string  InstitutionName,
        string  InstitutionAcronym,
        int     TotalSubjects,
        int     MatchedSubjects
    );

    public async Task<IReadOnlyCollection<ProgramRecommendationResponse>> GetRecommendationsAsync(
        int studentId,
        CancellationToken cancellationToken = default)
    {
        // studentId aparece duas vezes → EF Core cria @p0 e @p1 com o mesmo valor
        var rows = await dbContext.Database
            .SqlQuery<RecommendationRow>($"""
                SELECT
                    p.ProgramId,
                    p.ProgramName,
                    p.CurriculumVersion,
                    p.TotalSemesters,
                    i.InstitutionName,
                    i.InstitutionAcronym,
                    COUNT(DISTINCT s.SubjectId)  AS TotalSubjects,
                    COUNT(DISTINCT CASE
                        WHEN LOWER(LTRIM(RTRIM(s.SubjectName))) IN (
                            SELECT DISTINCT LOWER(LTRIM(RTRIM(s2.SubjectName)))
                            FROM   StudentProgress  sp2
                            JOIN   AcademicSubject  s2  ON s2.SubjectId  = sp2.SubjectId
                            JOIN   StudentEnrollment se2 ON se2.EnrollmentId = sp2.EnrollmentId
                            WHERE  se2.StudentId          = {studentId}
                              AND  se2.IsActive           = 1
                              AND  sp2.IsActive           = 1
                              AND  sp2.CompletionStatus   = 'Completed'
                        )
                        THEN s.SubjectId
                    END) AS MatchedSubjects
                FROM DegreeProgram        p
                JOIN EducationalInstitution i ON i.InstitutionId = p.InstitutionId
                JOIN AcademicTerm           t ON t.ProgramId     = p.ProgramId
                JOIN CourseModule            m ON m.TermId        = t.TermId
                JOIN AcademicSubject         s ON s.ModuleId      = m.ModuleId
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
                var remaining   = r.TotalSubjects - r.MatchedSubjects;
                var matchPct    = r.TotalSubjects > 0
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
