using FluentAssertions;
using Moq;
using SyllabusTrack.Application.Features.CourseComparison;
using Xunit;

namespace SyllabusTrack.Tests.Application.Features.CourseComparison;

public sealed class CompareProgramsQueryHandlerTests
{
    private readonly Mock<ICourseComparisonRepository> _repoMock = new();
    private readonly CompareProgramsQueryHandler _handler;

    public CompareProgramsQueryHandlerTests()
    {
        _handler = new CompareProgramsQueryHandler(_repoMock.Object);
    }

    private static CourseComparisonResponse FakeResponse() => new(
        SourceProgramId: 1,
        SourceProgramName: "ADS",
        SourceInstitutionName: "FAM",
        TargetProgramId: 2,
        TargetProgramName: "SI",
        TargetInstitutionName: "FAM",
        TargetTotalSubjects: 40,
        TargetTotalHours: 3200,
        MatchedSubjects: 20,
        MatchedHours: 1600,
        RemainingSubjects: 20,
        RemainingHours: 1600,
        SubjectMatchPercentage: 50m,
        HoursMatchPercentage: 50m,
        Subjects: Array.Empty<ComparedSubjectItem>());

    [Fact]
    public async Task Handle_WhenBothCoursesExist_ShouldReturnComparisonResult()
    {
        var response = FakeResponse();
        _repoMock.Setup(r => r.CompareAsync(1, 2, It.IsAny<CancellationToken>()))
                 .ReturnsAsync(response);

        var query = new CompareProgramsQuery(SourceProgramId: 1, TargetProgramId: 2);
        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsSuccess.Should().BeTrue();
        result.Value.Should().Be(response);
    }

    [Fact]
    public async Task Handle_WhenRepositoryReturnsNull_ShouldFail()
    {
        _repoMock.Setup(r => r.CompareAsync(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<CancellationToken>()))
                 .ReturnsAsync((CourseComparisonResponse?)null);

        var query = new CompareProgramsQuery(SourceProgramId: 1, TargetProgramId: 99);
        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("Comparison.NotFound");
    }

    [Fact]
    public async Task Handle_ShouldPassCorrectIdsToRepository()
    {
        _repoMock.Setup(r => r.CompareAsync(5, 10, It.IsAny<CancellationToken>()))
                 .ReturnsAsync(FakeResponse());

        var query = new CompareProgramsQuery(SourceProgramId: 5, TargetProgramId: 10);
        await _handler.Handle(query, CancellationToken.None);

        _repoMock.Verify(r => r.CompareAsync(5, 10, It.IsAny<CancellationToken>()), Times.Once);
    }
}
