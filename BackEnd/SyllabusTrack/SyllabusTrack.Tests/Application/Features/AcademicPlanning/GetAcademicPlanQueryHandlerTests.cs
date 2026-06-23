using FluentAssertions;
using Moq;
using SyllabusTrack.Application.Features.AcademicPlanning;
using Xunit;

namespace SyllabusTrack.Tests.Application.Features.AcademicPlanning;

public sealed class GetAcademicPlanQueryHandlerTests
{
    private readonly Mock<IAcademicPlanningRepository> _repoMock = new();
    private readonly GetAcademicPlanQueryHandler _handler;

    public GetAcademicPlanQueryHandlerTests()
    {
        _handler = new GetAcademicPlanQueryHandler(_repoMock.Object);
    }

    private static AcademicPlanningResponse FakeResponse() => new(
        SourceProgramId: 1,
        SourceProgramName: "ADS",
        SourceInstitutionName: "FAM",
        TargetProgramId: 2,
        TargetProgramName: "SI",
        TargetInstitutionName: "FAM",
        TargetTotalSemesters: 4,
        TargetTotalSubjects: 40,
        TargetTotalHours: 3200,
        MatchedSubjects: 20,
        MatchedHours: 1600,
        RemainingSubjects: 20,
        RemainingHours: 1600,
        SubjectMatchPercentage: 50m,
        HoursMatchPercentage: 50m,
        EffectiveSemestersNeeded: 2,
        SemestersFullyCreditable: 2,
        EstimatedYears: 1m,
        OriginalYears: 2m,
        YearsSaved: 1m,
        SemesterPlans: Array.Empty<SemesterPlanItem>());

    [Fact]
    public async Task Handle_WhenBothCoursesExist_ShouldReturnPlan()
    {
        var response = FakeResponse();
        _repoMock.Setup(r => r.GetPlanAsync(1, 2, It.IsAny<CancellationToken>()))
                 .ReturnsAsync(response);

        var query = new GetAcademicPlanQuery(SourceProgramId: 1, TargetProgramId: 2);
        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsSuccess.Should().BeTrue();
        result.Value.Should().Be(response);
    }

    [Fact]
    public async Task Handle_WhenRepositoryReturnsNull_ShouldFail()
    {
        _repoMock.Setup(r => r.GetPlanAsync(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<CancellationToken>()))
                 .ReturnsAsync((AcademicPlanningResponse?)null);

        var query = new GetAcademicPlanQuery(SourceProgramId: 1, TargetProgramId: 99);
        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("Planning.NotFound");
    }

    [Fact]
    public async Task Handle_ShouldPassCorrectIdsToRepository()
    {
        _repoMock.Setup(r => r.GetPlanAsync(3, 7, It.IsAny<CancellationToken>()))
                 .ReturnsAsync(FakeResponse());

        var query = new GetAcademicPlanQuery(SourceProgramId: 3, TargetProgramId: 7);
        await _handler.Handle(query, CancellationToken.None);

        _repoMock.Verify(r => r.GetPlanAsync(3, 7, It.IsAny<CancellationToken>()), Times.Once);
    }
}
