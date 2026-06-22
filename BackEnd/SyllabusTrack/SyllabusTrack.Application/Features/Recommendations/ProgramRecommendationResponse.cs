namespace SyllabusTrack.Application.Features.Recommendations;

/// <summary>
/// Representa um curso rankeado pelo aproveitamento de disciplinas já concluídas pelo aluno.
/// </summary>
public sealed record ProgramRecommendationResponse(
    int    ProgramId,
    string ProgramName,
    string CurriculumVersion,
    int    TotalSemesters,
    string InstitutionName,
    string InstitutionAcronym,
    int    TotalSubjects,
    int    MatchedSubjects,
    int    RemainingSubjects,
    decimal MatchPercentage
);
