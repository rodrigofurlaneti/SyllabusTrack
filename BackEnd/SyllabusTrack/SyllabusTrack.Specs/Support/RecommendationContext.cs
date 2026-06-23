using Moq;
using SyllabusTrack.Application.Features.Recommendations;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.Specs.Support;

/// <summary>
/// Shared state for Recommendation scenarios.
/// </summary>
public sealed class RecommendationContext
{
    public Mock<IProgramRecommendationRepository>                         RepoMock { get; } = new();
    public Result<IReadOnlyCollection<ProgramRecommendationResponse>>? Result   { get; set; }
    public int CalledWithStudentId { get; set; }
}
