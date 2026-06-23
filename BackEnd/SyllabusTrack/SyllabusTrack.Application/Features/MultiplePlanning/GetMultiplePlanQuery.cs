using SyllabusTrack.Application.Abstractions.Messaging;

namespace SyllabusTrack.Application.Features.MultiplePlanning;

/// <param name="SourceProgramIds">IDs dos cursos já concluídos (referência — mínimo 1).</param>
/// <param name="TargetProgramId">ID do curso que deseja ingressar.</param>
public sealed record GetMultiplePlanQuery(
    IReadOnlyCollection<int> SourceProgramIds,
    int TargetProgramId
) : IQuery<MultiplePlanningResponse>;
