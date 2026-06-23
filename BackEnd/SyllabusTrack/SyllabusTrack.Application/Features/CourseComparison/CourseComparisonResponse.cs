namespace SyllabusTrack.Application.Features.CourseComparison;

/// <summary>
/// Resultado da comparação entre dois cursos.
/// Indica quantas disciplinas/horas do curso-alvo já existem no curso de referência.
/// </summary>
public sealed record CourseComparisonResponse(
    int     SourceProgramId,
    string  SourceProgramName,
    string  SourceInstitutionName,
    int     TargetProgramId,
    string  TargetProgramName,
    string  TargetInstitutionName,
    int     TargetTotalSubjects,
    int     TargetTotalHours,
    int     MatchedSubjects,
    int     MatchedHours,
    int     RemainingSubjects,
    int     RemainingHours,
    decimal SubjectMatchPercentage,
    decimal HoursMatchPercentage,
    IReadOnlyCollection<ComparedSubjectItem> Subjects
);

/// <summary>
/// Representa uma disciplina do curso-alvo com indicação se ela existe no curso de referência.
/// </summary>
public sealed record ComparedSubjectItem(
    string SubjectName,
    int    Hours,
    int    TermNumber,
    bool   IsMatched
);
