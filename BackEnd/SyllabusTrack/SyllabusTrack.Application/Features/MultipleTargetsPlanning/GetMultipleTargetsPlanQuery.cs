using SyllabusTrack.Application.Abstractions.Messaging;

namespace SyllabusTrack.Application.Features.MultipleTargetsPlanning;

/// <param name="SourceProgramIds">IDs dos cursos já concluídos (mínimo 1).</param>
/// <param name="TargetProgramIds">IDs dos cursos que deseja ingressar (mínimo 1).</param>
public sealed record GetMultipleTargetsPlanQuery(
    IReadOnlyCollection<int> SourceProgramIds,
    IReadOnlyCollection<int> TargetProgramIds
) : IQuery<MultipleTargetsPlanningResponse>;
