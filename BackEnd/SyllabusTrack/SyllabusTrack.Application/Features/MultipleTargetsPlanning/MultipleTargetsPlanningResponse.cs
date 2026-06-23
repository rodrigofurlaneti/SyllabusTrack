using SyllabusTrack.Application.Features.AcademicPlanning;
using SyllabusTrack.Application.Features.MultiplePlanning;

namespace SyllabusTrack.Application.Features.MultipleTargetsPlanning;

/// <summary>
/// Resultado do planejamento múltiplo com N fontes e N alvos.
/// A UNIÃO de disciplinas dos cursos-fonte é calculada uma única vez
/// e aplicada contra cada curso-alvo individualmente.
/// </summary>
public sealed record MultipleTargetsPlanningResponse(
    /// <summary>Cursos já concluídos usados como referência.</summary>
    IReadOnlyCollection<SourceProgramSummary> SourcePrograms,

    /// <summary>Plano individual para cada curso-alvo.</summary>
    IReadOnlyCollection<TargetProgramResult> TargetResults
);

/// <summary>Plano de aproveitamento para um único curso-alvo.</summary>
public sealed record TargetProgramResult(
    int     TargetProgramId,
    string  TargetProgramName,
    string  TargetInstitutionName,

    int     TargetTotalSemesters,
    int     TargetTotalSubjects,
    int     TargetTotalHours,

    int     MatchedSubjects,
    int     MatchedHours,
    int     RemainingSubjects,
    int     RemainingHours,
    decimal SubjectMatchPercentage,
    decimal HoursMatchPercentage,

    int     EffectiveSemestersNeeded,
    int     SemestersFullyCreditable,
    decimal EstimatedYears,
    decimal OriginalYears,
    decimal YearsSaved,

    IReadOnlyCollection<SemesterPlanItem> SemesterPlans
);
