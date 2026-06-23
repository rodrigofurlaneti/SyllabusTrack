using FluentAssertions;
using Moq;
using SyllabusTrack.Application.Features.Recommendations;
using SyllabusTrack.Application.Features.Recommendations.GetRecommendations;
using Xunit;

namespace SyllabusTrack.Tests.Application.Features.Recommendations;

public sealed class GetProgramRecommendationsQueryHandlerTests
{
    private readonly Mock<IProgramRecommendationRepository> _repoMock = new();
    private readonly GetProgramRecommendationsQueryHandler _handler;

    public GetProgramRecommendationsQueryHandlerTests()
    {
        _handler = new GetProgramRecommendationsQueryHandler(_repoMock.Object);
    }

    private static IReadOnlyCollection<ProgramRecommendationResponse> FakeRecommendations() =>
        new[]
        {
            new ProgramRecommendationResponse(
                ProgramId: 1,
                ProgramName: "SI",
                CurriculumVersion: "2024.1",
                TotalSemesters: 4,
                InstitutionName: "FAM",
                InstitutionAcronym: "FAM",
                TotalSubjects: 40,
                MatchedSubjects: 30,
                RemainingSubjects: 10,
                MatchPercentage: 75m),
        };

    [Fact]
    public async Task Handle_ShouldAlwaysSucceedEvenWithEmptyList()
    {
        _repoMock.Setup(r => r.GetRecommendationsAsync(1, It.IsAny<CancellationToken>()))
                 .ReturnsAsync(Array.Empty<ProgramRecommendationResponse>());

        var query = new GetProgramRecommendationsQuery(StudentId: 1);
        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsSuccess.Should().BeTrue();
        result.Value.Should().BeEmpty();
    }

    [Fact]
    public async Task Handle_ShouldReturnRecommendationsFromRepository()
    {
        var recommendations = FakeRecommendations();
        _repoMock.Setup(r => r.GetRecommendationsAsync(5, It.IsAny<CancellationToken>()))
                 .ReturnsAsync(recommendations);

        var query = new GetProgramRecommendationsQuery(StudentId: 5);
        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsSuccess.Should().BeTrue();
        result.Value.Should().HaveCount(1);
        result.Value.First().ProgramName.Should().Be("SI");
    }

    [Fact]
    public async Task Handle_ShouldPassStudentIdToRepository()
    {
        _repoMock.Setup(r => r.GetRecommendationsAsync(It.IsAny<int>(), It.IsAny<CancellationToken>()))
                 .ReturnsAsync(Array.Empty<ProgramRecommendationResponse>());

        var query = new GetProgramRecommendationsQuery(StudentId: 42);
        await _handler.Handle(query, CancellationToken.None);

        _repoMock.Verify(r => r.GetRecommendationsAsync(42, It.IsAny<CancellationToken>()), Times.Once);
    }
}
