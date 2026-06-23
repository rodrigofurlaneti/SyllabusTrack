namespace SyllabusTrack.Application.Features.MultiplePlanning;

/// <summary>Request body para o endpoint POST /programs/planning/multiple.</summary>
public sealed record MultiplePlanningRequest(
    IReadOnlyCollection<int> SourceProgramIds,
    int TargetProgramId
);
