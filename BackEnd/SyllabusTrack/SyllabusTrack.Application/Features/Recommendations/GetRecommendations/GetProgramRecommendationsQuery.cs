using SyllabusTrack.Application.Abstractions.Messaging;

namespace SyllabusTrack.Application.Features.Recommendations.GetRecommendations;

public sealed record GetProgramRecommendationsQuery(int StudentId)
    : IQuery<IReadOnlyCollection<ProgramRecommendationResponse>>;
