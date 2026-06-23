using FluentAssertions;
using Moq;
using Reqnroll;
using SyllabusTrack.Application.Features.CourseComparison;
using SyllabusTrack.Specs.Support;

namespace SyllabusTrack.Specs.StepDefinitions.Planning;

[Binding]
public sealed class CourseComparisonSteps(PlanningContext ctx)
{
    // ── Given ─────────────────────────────────────────────────────────────────

    [Given("a source program with ID {int} named {string} and a target program with ID {int} named {string}")]
    public void GivenSourceAndTargetPrograms(int sourceId, string sourceName, int targetId, string targetName)
    {
        ctx.SourceProgramId = sourceId;
        ctx.TargetProgramId = targetId;
    }

    [Given("the comparison repository returns a valid result with {int}% match")]
    public void GivenComparisonWithMatch(int pct)
    {
        var response = BuildComparison(ctx.SourceProgramId, ctx.TargetProgramId, pct);
        ctx.ComparisonRepo
           .Setup(r => r.CompareAsync(ctx.SourceProgramId, ctx.TargetProgramId, It.IsAny<CancellationToken>()))
           .ReturnsAsync(response);
    }

    [Given("the comparison repository returns a result with {int}% match")]
    public void GivenComparisonRepositoryReturnsPct(int pct)
        => GivenComparisonWithMatch(pct);

    [Given("the comparison repository returns null (programs not found)")]
    public void GivenComparisonRepositoryNull()
    {
        ctx.ComparisonRepo
           .Setup(r => r.CompareAsync(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<CancellationToken>()))
           .ReturnsAsync((CourseComparisonResponse?)null);
    }

    [Given("a source program with ID {int} and a target program with ID {int}")]
    public void GivenSourceAndTargetProgramIds(int sourceId, int targetId)
    {
        ctx.SourceProgramId = sourceId;
        ctx.TargetProgramId = targetId;
    }

    // ── When ──────────────────────────────────────────────────────────────────

    [When("I request the course comparison")]
    public async Task WhenRequestCourseComparison()
    {
        var handler = new CompareProgramsQueryHandler(ctx.ComparisonRepo.Object);
        ctx.ComparisonResult = await handler.Handle(
            new CompareProgramsQuery(ctx.SourceProgramId, ctx.TargetProgramId),
            CancellationToken.None);
    }

    // ── Then ──────────────────────────────────────────────────────────────────

    [Then("the comparison should succeed")]
    public void ThenComparisonSucceeds()
    {
        ctx.ComparisonResult.Should().NotBeNull();
        ctx.ComparisonResult!.IsSuccess.Should().BeTrue();
    }

    [Then("the comparison should fail with error code {string}")]
    public void ThenComparisonFails(string errorCode)
    {
        ctx.ComparisonResult.Should().NotBeNull();
        ctx.ComparisonResult!.IsFailure.Should().BeTrue();
        ctx.ComparisonResult.Error.Code.Should().Be(errorCode);
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private static CourseComparisonResponse BuildComparison(int sourceId, int targetId, int matchPct) =>
        new(
            SourceProgramId: sourceId,
            SourceProgramName: "ADS",
            SourceInstitutionName: "FAM",
            TargetProgramId: targetId,
            TargetProgramName: "SI",
            TargetInstitutionName: "FAM",
            TargetTotalSubjects: 40,
            TargetTotalHours: 3200,
            MatchedSubjects: (int)(40 * matchPct / 100),
            MatchedHours: (int)(3200 * matchPct / 100),
            RemainingSubjects: 40 - (int)(40 * matchPct / 100),
            RemainingHours: 3200 - (int)(3200 * matchPct / 100),
            SubjectMatchPercentage: matchPct,
            HoursMatchPercentage: matchPct,
            Subjects: Array.Empty<ComparedSubjectItem>());
}
