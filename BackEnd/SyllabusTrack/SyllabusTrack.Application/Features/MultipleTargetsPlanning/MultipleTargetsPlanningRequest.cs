namespace SyllabusTrack.Application.Features.MultipleTargetsPlanning;

/// <summary>
/// Corpo do POST /programs/planning/multiple-targets
/// </summary>
public sealed record MultipleTargetsPlanningRequest(
    /// <summary>IDs dos cursos já concluídos (referência — mínimo 1).</summary>
    IReadOnlyCollection<int> SourceProgramIds,

    /// <summary>IDs dos cursos que deseja ingressar (mínimo 1).</summary>
    IReadOnlyCollection<int> TargetProgramIds
);
