using FluentAssertions;
using Moq;
using SyllabusTrack.Application.Features.MultipleTargetsPlanning;
using SyllabusTrack.Application.Features.MultiplePlanning;  // SourceProgramSummary
using SyllabusTrack.Application.Features.AcademicPlanning;  // SemesterPlanItem
using Xunit;

namespace SyllabusTrack.Tests.Application.Features.MultipleTargetsPlanning;

public sealed class GetMultipleTargetsPlanQueryHandlerTests
{
    private readonly Mock<IMultipleTargetsPlanningRepository> _repoMock = new();
    private readonly GetMultipleTargetsPlanQueryHandler _handler;

    public GetMultipleTargetsPlanQueryHandlerTests()
    {
        _handler = new GetMultipleTargetsPlanQueryHandler(_repoMock.Object);
    }

    private static MultipleTargetsPlanningResponse FakeResponse() =>
        new(
            SourcePrograms: Array.Empty<SourceProgramSummary>(),
            TargetResults: Array.Empty<TargetProgramResult>());

    [Fact]
    public async Task Handle_WithValidQuery_ShouldSucceed()
    {
        var response = FakeResponse();
        _repoMock.Setup(r => r.GetMultipleTargetsPlanAsync(
                    It.IsAny<IReadOnlyCollection<int>>(),
                    It.IsAny<IReadOnlyCollection<int>>(),
                    It.IsAny<CancellationToken>()))
                 .ReturnsAsync(response);

        var query = new GetMultipleTargetsPlanQuery(
            SourceProgramIds: new[] { 1 },
            TargetProgramIds: new[] { 2 });

        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsSuccess.Should().BeTrue();
        result.Value.Should().Be(response);
    }

    [Fact]
    public async Task Handle_WithEmptySourceList_ShouldFail()
    {
        var query = new GetMultipleTargetsPlanQuery(
            SourceProgramIds: Array.Empty<int>(),
            TargetProgramIds: new[] { 2 });

        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("MultipleTargetsPlanning.NoSource");
    }

    [Fact]
    public async Task Handle_WithNullSourceList_ShouldFail()
    {
        var query = new GetMultipleTargetsPlanQuery(
            SourceProgramIds: null!,
            TargetProgramIds: new[] { 2 });

        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("MultipleTargetsPlanning.NoSource");
    }

    [Fact]
    public async Task Handle_WithEmptyTargetList_ShouldFail()
    {
        var query = new GetMultipleTargetsPlanQuery(
            SourceProgramIds: new[] { 1 },
            TargetProgramIds: Array.Empty<int>());

        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("MultipleTargetsPlanning.NoTarget");
    }

    [Fact]
    public async Task Handle_WithNegativeSourceId_ShouldFail()
    {
        var query = new GetMultipleTargetsPlanQuery(
            SourceProgramIds: new[] { -1 },
            TargetProgramIds: new[] { 2 });

        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("MultipleTargetsPlanning.InvalidIds");
    }

    [Fact]
    public async Task Handle_WithNegativeTargetId_ShouldFail()
    {
        var query = new GetMultipleTargetsPlanQuery(
            SourceProgramIds: new[] { 1 },
            TargetProgramIds: new[] { -5 });

        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("MultipleTargetsPlanning.InvalidIds");
    }

    [Fact]
    public async Task Handle_WhenSourceAndTargetOverlap_ShouldFail()
    {
        // Course 1 appears in both source and target
        var query = new GetMultipleTargetsPlanQuery(
            SourceProgramIds: new[] { 1, 2 },
            TargetProgramIds: new[] { 2, 3 });

        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("MultipleTargetsPlanning.Overlap");
    }

    [Fact]
    public async Task Handle_WhenRepositoryReturnsNull_ShouldFail()
    {
        _repoMock.Setup(r => r.GetMultipleTargetsPlanAsync(
                    It.IsAny<IReadOnlyCollection<int>>(),
                    It.IsAny<IReadOnlyCollection<int>>(),
                    It.IsAny<CancellationToken>()))
                 .ReturnsAsync((MultipleTargetsPlanningResponse?)null);

        var query = new GetMultipleTargetsPlanQuery(
            SourceProgramIds: new[] { 1 },
            TargetProgramIds: new[] { 99 });

        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("MultipleTargetsPlanning.NotFound");
    }

    [Fact]
    public async Task Handle_WithMultipleValidSourcesAndTargets_ShouldSucceed()
    {
        _repoMock.Setup(r => r.GetMultipleTargetsPlanAsync(
                    It.IsAny<IReadOnlyCollection<int>>(),
                    It.IsAny<IReadOnlyCollection<int>>(),
                    It.IsAny<CancellationToken>()))
                 .ReturnsAsync(FakeResponse());

        var query = new GetMultipleTargetsPlanQuery(
            SourceProgramIds: new[] { 1, 2 },
            TargetProgramIds: new[] { 3, 4, 5 });

        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsSuccess.Should().BeTrue();
    }
}
