using FluentAssertions;
using Moq;
using Reqnroll;
using SyllabusTrack.Application.Features.AcademicPlanning;
using SyllabusTrack.Application.Features.MultiplePlanning;
using SyllabusTrack.Specs.Support;

namespace SyllabusTrack.Specs.StepDefinitions.Planning;

[Binding]
public sealed class MultiplePlanningSteps(PlanningContext ctx)
{
    // ── Given ─────────────────────────────────────────────────────────────────

    [Given(@"^source programs with IDs \[(.*)\] and target program with ID (\d+)$")]
    public void GivenSourceProgramIdsAndTarget(string idsRaw, int targetId)
    {
        ctx.SourceProgramIds = ParseIds(idsRaw);
        ctx.TargetProgramId  = targetId;
    }

    [Given("the multiple planning repository returns a valid plan")]
    public void GivenValidMultiplePlan()
    {
        var plan = BuildPlan(ctx.TargetProgramId);
        ctx.MultiplePlanRepo
           .Setup(r => r.GetMultiplePlanAsync(
               It.IsAny<IReadOnlyCollection<int>>(),
               ctx.TargetProgramId,
               It.IsAny<CancellationToken>()))
           .ReturnsAsync(plan);
    }

    [Given("the multiple planning repository returns null \\(courses not found\\)")]
    public void GivenMultiplePlanRepositoryNull()
    {
        ctx.MultiplePlanRepo
           .Setup(r => r.GetMultiplePlanAsync(
               It.IsAny<IReadOnlyCollection<int>>(),
               It.IsAny<int>(),
               It.IsAny<CancellationToken>()))
           .ReturnsAsync((MultiplePlanningResponse?)null);
    }

    // ── When ──────────────────────────────────────────────────────────────────

    [When("I request the multiple source plan")]
    public async Task WhenRequestMultiplePlan()
    {
        var handler = new GetMultiplePlanQueryHandler(ctx.MultiplePlanRepo.Object);
        ctx.MultiplePlanResult = await handler.Handle(
            new GetMultiplePlanQuery(ctx.SourceProgramIds, ctx.TargetProgramId),
            CancellationToken.None);
    }

    // ── Then ──────────────────────────────────────────────────────────────────

    [Then("the multiple plan query should succeed")]
    public void ThenMultiplePlanSucceeds()
    {
        ctx.MultiplePlanResult.Should().NotBeNull();
        ctx.MultiplePlanResult!.IsSuccess.Should().BeTrue();
    }

    [Then("the multiple plan query should fail with error code {string}")]
    public void ThenMultiplePlanFails(string errorCode)
    {
        ctx.MultiplePlanResult.Should().NotBeNull();
        ctx.MultiplePlanResult!.IsFailure.Should().BeTrue();
        ctx.MultiplePlanResult.Error.Code.Should().Be(errorCode);
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private static IReadOnlyCollection<int> ParseIds(string raw)
    {
        if (string.IsNullOrWhiteSpace(raw)) return Array.Empty<int>();
        return raw.Split(',', StringSplitOptions.RemoveEmptyEntries)
                  .Select(s => int.Parse(s.Trim()))
                  .ToArray();
    }

    private static MultiplePlanningResponse BuildPlan(int targetId) =>
        new(
            SourcePrograms: Array.Empty<SourceProgramSummary>(),
            TargetProgramId: targetId,
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
}
