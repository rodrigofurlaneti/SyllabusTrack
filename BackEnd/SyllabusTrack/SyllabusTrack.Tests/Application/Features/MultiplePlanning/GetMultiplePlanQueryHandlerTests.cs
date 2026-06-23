using FluentAssertions;
using Moq;
using SyllabusTrack.Application.Features.MultiplePlanning;
using SyllabusTrack.Application.Features.AcademicPlanning;  // SemesterPlanItem
using Xunit;

namespace SyllabusTrack.Tests.Application.Features.MultiplePlanning;

public sealed class GetMultiplePlanQueryHandlerTests
{
    private readonly Mock<IMultiplePlanningRepository> _repoMock = new();
    private readonly GetMultiplePlanQueryHandler _handler;

    public GetMultiplePlanQueryHandlerTests()
    {
        _handler = new GetMultiplePlanQueryHandler(_repoMock.Object);
    }

    private static MultiplePlanningResponse FakeResponse() =>
        new(
            SourcePrograms: Array.Empty<SourceProgramSummary>(),
            TargetProgramId: 2,
            TargetProgramName: "Sistema para Internet",
            TargetInstitutionName: "FAM",
            TargetTotalSemesters: 4,
            TargetTotalSubjects: 40,
            TargetTotalHours: 3200,
            MatchedSubjects: 20,
            MatchedHours: 1600,
            RemainingSubjects: 20,
            RemainingHours: 1600,
            SubjectMatchPercentage: 50,
            HoursMatchPercentage: 50,
            EffectiveSemestersNeeded: 2,
            SemestersFullyCreditable: 2,
            EstimatedYears: 1,
            OriginalYears: 2,
            YearsSaved: 1,
            SemesterPlans: Array.Empty<SemesterPlanItem>());

    [Fact]
    public async Task Handle_WithValidQuery_ShouldSucceed()
    {
        _repoMock.Setup(r => r.GetMultiplePlanAsync(
                    It.IsAny<IReadOnlyCollection<int>>(),
                    It.IsAny<int>(),
                    It.IsAny<CancellationToken>()))
                 .ReturnsAsync(FakeResponse());

        var query = new GetMultiplePlanQuery(SourceProgramIds: new[] { 1 }, TargetProgramId: 2);
        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsSuccess.Should().BeTrue();
    }

    [Fact]
    public async Task Handle_WithEmptySourceList_ShouldFail()
    {
        var query = new GetMultiplePlanQuery(SourceProgramIds: Array.Empty<int>(), TargetProgramId: 2);
        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("MultiplePlanning.NoSource");
    }

    [Fact]
    public async Task Handle_WithNullSourceList_ShouldFail()
    {
        var query = new GetMultiplePlanQuery(SourceProgramIds: null!, TargetProgramId: 2);
        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("MultiplePlanning.NoSource");
    }

    [Fact]
    public async Task Handle_WithNegativeSourceId_ShouldFail()
    {
        var query = new GetMultiplePlanQuery(SourceProgramIds: new[] { -1 }, TargetProgramId: 2);
        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("MultiplePlanning.InvalidIds");
    }

    [Fact]
    public async Task Handle_WithZeroTargetId_ShouldFail()
    {
        var query = new GetMultiplePlanQuery(SourceProgramIds: new[] { 1 }, TargetProgramId: 0);
        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("MultiplePlanning.InvalidIds");
    }

    [Fact]
    public async Task Handle_WhenTargetIsAlsoSource_ShouldFail()
    {
        var query = new GetMultiplePlanQuery(SourceProgramIds: new[] { 1, 2 }, TargetProgramId: 1);
        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("MultiplePlanning.SameProgram");
    }

    [Fact]
    public async Task Handle_WhenRepositoryReturnsNull_ShouldFail()
    {
        _repoMock.Setup(r => r.GetMultiplePlanAsync(
                    It.IsAny<IReadOnlyCollection<int>>(),
                    It.IsAny<int>(),
                    It.IsAny<CancellationToken>()))
                 .ReturnsAsync((MultiplePlanningResponse?)null);

        var query = new GetMultiplePlanQuery(SourceProgramIds: new[] { 1 }, TargetProgramId: 99);
        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("MultiplePlanning.NotFound");
    }
}
