using SyllabusTrack.Application.Abstractions.Messaging;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.Application.Features.AcademicPlanning;

internal sealed class GetAcademicPlanQueryHandler(
    IAcademicPlanningRepository repository)
    : IQueryHandler<GetAcademicPlanQuery, AcademicPlanningResponse>
{
    public async Task<Result<AcademicPlanningResponse>> Handle(
        GetAcademicPlanQuery request,
        CancellationToken cancellationToken)
    {
        var plan = await repository.GetPlanAsync(
            request.SourceProgramId,
            request.TargetProgramId,
            cancellationToken);

        if (plan is null)
            return Result.Failure<AcademicPlanningResponse>(
                new Error("Planning.NotFound",
                    "Um ou ambos os cursos informados não foram encontrados."));

        return Result.Success(plan);
    }
}
