using SyllabusTrack.Application.Abstractions.Messaging;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.Application.Features.MultiplePlanning;

internal sealed class GetMultiplePlanQueryHandler(
    IMultiplePlanningRepository repository)
    : IQueryHandler<GetMultiplePlanQuery, MultiplePlanningResponse>
{
    public async Task<Result<MultiplePlanningResponse>> Handle(
        GetMultiplePlanQuery request,
        CancellationToken cancellationToken)
    {
        if (request.SourceProgramIds is null || request.SourceProgramIds.Count == 0)
            return Result.Failure<MultiplePlanningResponse>(
                new Error("MultiplePlanning.NoSource",
                    "Informe ao menos um curso de referência."));

        if (request.SourceProgramIds.Any(id => id <= 0) || request.TargetProgramId <= 0)
            return Result.Failure<MultiplePlanningResponse>(
                new Error("MultiplePlanning.InvalidIds",
                    "Todos os IDs de curso devem ser positivos."));

        if (request.SourceProgramIds.Contains(request.TargetProgramId))
            return Result.Failure<MultiplePlanningResponse>(
                new Error("MultiplePlanning.SameProgram",
                    "O curso-alvo não pode ser um dos cursos de referência."));

        var plan = await repository.GetMultiplePlanAsync(
            request.SourceProgramIds,
            request.TargetProgramId,
            cancellationToken);

        if (plan is null)
            return Result.Failure<MultiplePlanningResponse>(
                new Error("MultiplePlanning.NotFound",
                    "Um ou mais cursos informados não foram encontrados."));

        return Result.Success(plan);
    }
}
