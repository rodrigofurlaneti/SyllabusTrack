using SyllabusTrack.Application.Abstractions.Messaging;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.Application.Features.MultipleTargetsPlanning;

internal sealed class GetMultipleTargetsPlanQueryHandler(
    IMultipleTargetsPlanningRepository repository)
    : IQueryHandler<GetMultipleTargetsPlanQuery, MultipleTargetsPlanningResponse>
{
    public async Task<Result<MultipleTargetsPlanningResponse>> Handle(
        GetMultipleTargetsPlanQuery request,
        CancellationToken cancellationToken)
    {
        if (request.SourceProgramIds is null || request.SourceProgramIds.Count == 0)
            return Result.Failure<MultipleTargetsPlanningResponse>(
                new Error("MultipleTargetsPlanning.NoSource",
                    "Informe ao menos um curso de referência."));

        if (request.TargetProgramIds is null || request.TargetProgramIds.Count == 0)
            return Result.Failure<MultipleTargetsPlanningResponse>(
                new Error("MultipleTargetsPlanning.NoTarget",
                    "Informe ao menos um curso-alvo."));

        if (request.SourceProgramIds.Any(id => id <= 0) ||
            request.TargetProgramIds.Any(id => id <= 0))
            return Result.Failure<MultipleTargetsPlanningResponse>(
                new Error("MultipleTargetsPlanning.InvalidIds",
                    "Todos os IDs de curso devem ser positivos."));

        // Um curso não pode ser fonte e alvo ao mesmo tempo
        var overlap = request.SourceProgramIds.Intersect(request.TargetProgramIds).ToList();
        if (overlap.Count > 0)
            return Result.Failure<MultipleTargetsPlanningResponse>(
                new Error("MultipleTargetsPlanning.Overlap",
                    "Um curso não pode ser referência e alvo ao mesmo tempo."));

        var plan = await repository.GetMultipleTargetsPlanAsync(
            request.SourceProgramIds,
            request.TargetProgramIds,
            cancellationToken);

        if (plan is null)
            return Result.Failure<MultipleTargetsPlanningResponse>(
                new Error("MultipleTargetsPlanning.NotFound",
                    "Um ou mais cursos informados não foram encontrados."));

        return Result.Success(plan);
    }
}
