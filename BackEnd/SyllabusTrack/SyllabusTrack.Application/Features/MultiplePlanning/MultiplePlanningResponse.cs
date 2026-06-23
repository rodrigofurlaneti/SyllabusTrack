using SyllabusTrack.Application.Features.AcademicPlanning;

namespace SyllabusTrack.Application.Features.MultiplePlanning;

/// <summary>
/// Planejamento acadêmico com múltiplos cursos de referência.
/// O aproveitamento é calculado com a UNIÃO de todas as disciplinas
/// dos cursos-fonte, eliminando duplicatas por nome.
/// </summary>
public sealed record MultiplePlanningResponse(
    // Cursos-fonte (N cursos já concluídos)
    IReadOnlyCollection<SourceProgramSummary> SourcePrograms,

    // Curso-alvo
    int     TargetProgramId,
    string  TargetProgramName,
    string  TargetInstitutionName,

    // Totais do curso-alvo
    int     TargetTotalSemesters,
    int     TargetTotalSubjects,
    int     TargetTotalHours,

    // Aproveitamento global (união dos fontes)
    int     MatchedSubjects,
    int     MatchedHours,
    int     RemainingSubjects,
    int     RemainingHours,
    decimal SubjectMatchPercentage,
    decimal HoursMatchPercentage,

    // Estimativa de tempo
    int     EffectiveSemestersNeeded,
    int     SemestersFullyCreditable,
    decimal EstimatedYears,
    decimal OriginalYears,
    decimal YearsSaved,

    // Detalhamento por semestre (reusa SemesterPlanItem do planejamento simples)
    IReadOnlyCollection<SemesterPlanItem> SemesterPlans
);

/// <summary>Informações resumidas de um curso-fonte.</summary>
public sealed record SourceProgramSummary(
    int    ProgramId,
    string ProgramName,
    string InstitutionName
);
