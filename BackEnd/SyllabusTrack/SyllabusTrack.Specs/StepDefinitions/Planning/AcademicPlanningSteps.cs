using FluentAssertions;
using Moq;
using Reqnroll;
using SyllabusTrack.Application.Features.AcademicPlanning;
using SyllabusTrack.Specs.Support;

namespace SyllabusTrack.Specs.StepDefinitions.Planning;

[Binding]
public sealed class AcademicPlanningSteps(PlanningContext ctx)
{
    // ── Given ─────────────────────────────────────────────────────────────────

    [Given("a source program with ID {int} and a target program with ID {int}")]
    public void GivenSourceAndTargetPrograms(int sourceId, int targetId)
    {
        ctx.SourceProgramId = sourceId;
        ctx.TargetProgramId = targetId;
    }

    [Given("the repository returns a valid academic plan")]
    public void GivenValidAcademicPlan()
    {
        var plan = BuildPlan(ctx.SourceProgramId, ctx.TargetProgramId, 50m, 1m, 2m, 1m);
        ctx.AcademicPlanRepo
           .Setup(r => r.GetPlanAsync(ctx.SourceProgramId, ctx.TargetProgramId, It.IsAny<CancellationToken>()))
           .ReturnsAsync(plan);
    }

    [Given("the repository returns a plan with {int} matched subjects")]
    public void GivenPlanWithMatchedSubjects(int matched)
    {
        var plan = matched == 0
            ? BuildPlan(ctx.SourceProgramId, ctx.TargetProgramId, 0m, 2m, 2m, 0m)
            : BuildPlan(ctx.SourceProgramId, ctx.TargetProgramId, 100m, 0m, 2m, 2m);

        ctx.AcademicPlanRepo
           .Setup(r => r.GetPlanAsync(ctx.SourceProgramId, ctx.TargetProgramId, It.IsAny<CancellationToken>()))
           .ReturnsAsync(plan);
    }

    [Given("the repository returns null for the academic plan")]
    public void GivenNullAcademicPlan()
    {
        ctx.AcademicPlanRepo
           .Setup(r => r.GetPlanAsync(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<CancellationToken>()))
           .ReturnsAsync((AcademicPlanningResponse?)null);
    }

    [Given("the repository returns a plan with {int}% match")]
    public void GivenPlanWithMatchPercentage(int pct)
    {
        var plan = BuildPlan(ctx.SourceProgramId, ctx.TargetProgramId, pct, 0m, 2m, 2m);
        ctx.AcademicPlanRepo
           .Setup(r => r.GetPlanAsync(ctx.SourceProgramId, ctx.TargetProgramId, It.IsAny<CancellationToken>()))
           .ReturnsAsync(plan);
    }

    // ── When ──────────────────────────────────────────────────────────────────

    [When("I request the academic plan")]
    public async Task WhenRequestAcademicPlan()
    {
        var handler = new GetAcademicPlanQueryHandler(ctx.AcademicPlanRepo.Object);
        ctx.AcademicPlanResult = await handler.Handle(
            new GetAcademicPlanQuery(ctx.SourceProgramId, ctx.TargetProgramId),
            CancellationToken.None);
    }

    // ── Then ──────────────────────────────────────────────────────────────────

    [Then("the academic plan query should succeed")]
    public void ThenAcademicPlanSucceeds()
    {
        ctx.AcademicPlanResult.Should().NotBeNull();
        ctx.AcademicPlanResult!.IsSuccess.Should().BeTrue();
    }

    [Then("the plan should contain semester details")]
    public void ThenPlanContainsSemesterDetails()
    {
        ctx.AcademicPlanResult!.Value.SemesterPlans.Should().NotBeNull();
    }

    [Then("the match percentage should be {int}")]
    public void ThenMatchPercentageShouldBe(int pct)
    {
        ctx.AcademicPlanResult!.Value.SubjectMatchPercentage.Should().Be(pct);
    }

    [Then("the years saved should be greater than {int}")]
    public void ThenYearsSavedGreaterThan(int minimum)
    {
        ctx.AcademicPlanResult!.Value.YearsSaved.Should().BeGreaterThan(minimum);
    }

    [Then("the academic plan query should fail with error code {string}")]
    public void ThenAcademicPlanFails(string errorCode)
    {
        ctx.AcademicPlanResult.Should().NotBeNull();
        ctx.AcademicPlanResult!.IsFailure.Should().BeTrue();
        ctx.AcademicPlanResult.Error.Code.Should().Be(errorCode);
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private static AcademicPlanningResponse BuildPlan(
        int sourceId, int targetId,
        decimal matchPct, decimal estimatedYears, decimal originalYears, decimal yearsSaved) =>
        new(
            SourceProgramId: sourceId,
            SourceProgramName: "ADS",
            SourceInstitutionName: "FAM",
            TargetProgramId: targetId,
            TargetProgramName: "SI",
            TargetInstitutionName: "FAM",
            TargetTotalSemesters: 4,
            TargetTotalSubjects: 40,
            TargetTotalHours: 3200,
            MatchedSubjects: matchPct == 100 ? 40 : (int)(40 * matchPct / 100),
            MatchedHours: matchPct == 100 ? 3200 : (int)(3200 * matchPct / 100),
            RemainingSubjects: matchPct == 100 ? 0 : 40 - (int)(40 * matchPct / 100),
            RemainingHours: matchPct == 100 ? 0 : 3200 - (int)(3200 * matchPct / 100),
            SubjectMatchPercentage: matchPct,
            HoursMatchPercentage: matchPct,
            EffectiveSemestersNeeded: (int)(estimatedYears * 2),
            SemestersFullyCreditable: matchPct == 100 ? 4 : 0,
            EstimatedYears: estimatedYears,
            OriginalYears: originalYears,
            YearsSaved: yearsSaved,
            SemesterPlans: Array.Empty<SemesterPlanItem>());
}
