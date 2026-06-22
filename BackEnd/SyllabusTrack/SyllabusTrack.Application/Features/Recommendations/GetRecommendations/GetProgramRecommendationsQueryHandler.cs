using SyllabusTrack.Application.Abstractions.Messaging;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.Application.Features.Recommendations.GetRecommendations;

internal sealed class GetProgramRecommendationsQueryHandler(
    IProgramRecommendationRepository repository)
    : IQueryHandler<GetProgramRecommendationsQuery, IReadOnlyCollection<ProgramRecommendationResponse>>
{
    public async Task<Result<IReadOnlyCollection<ProgramRecommendationResponse>>> Handle(
        GetProgramRecommendationsQuery request,
        CancellationToken cancellationToken)
    {
        var recommendations = await repository.GetRecommendationsAsync(
            request.StudentId,
            cancellationToken);

        return Result.Success(recommendations);
    }
}
