using FluentAssertions;
using Moq;
using Reqnroll;
using SyllabusTrack.Application.Features.AcademicPlanning;
using SyllabusTrack.Application.Features.MultiplePlanning;
using SyllabusTrack.Application.Features.MultipleTargetsPlanning;
using SyllabusTrack.Specs.Support;

namespace SyllabusTrack.Specs.StepDefinitions.Planning;

[Binding]
public sealed class MultipleTargetsPlanningSteps(PlanningContext ctx)
{
    // ── Given: source/target IDs ──────────────────────────────────────────────

    [Given(@"^source program IDs \[(.*)\] and target program IDs \[(.*)\]$")]
    public void GivenSourceAndTargetIds(string sourceRaw, string targetRaw)
    {
        ctx.SourceProgramIds = ParseIds(sourceRaw);
        ctx.TargetProgramIds = ParseIds(targetRaw);
    }

    [Given(@"^source program IDs are null and target program IDs \[(.*)\]$")]
    public void GivenNullSourceAndTargetIds(string targetRaw)
    {
        ctx.SourceProgramIds = null!;
        ctx.TargetProgramIds = ParseIds(targetRaw);
    }

    [Given(@"^source program IDs \[(.*)\] and target program IDs are null$")]
    public void GivenSourceAndNullTargetIds(string sourceRaw)
    {
        ctx.SourceProgramIds = ParseIds(sourceRaw);
        ctx.TargetProgramIds = null!;
    }

    // ── Given: repository stubs ───────────────────────────────────────────────

    [Given("the multiple targets repository returns a valid response")]
    public void GivenValidMultipleTargetsResponse()
    {
        var response = BuildResponse();
        ctx.MultipleTargetsRepo
           .Setup(r => r.GetMultipleTargetsPlanAsync(
               It.IsAny<IReadOnlyCollection<int>>(),
               It.IsAny<IReadOnlyCollection<int>>(),
               It.IsAny<CancellationToken>()))
           .ReturnsAsync(response);
    }

    [Given("the multiple targets repository returns null \\(courses not found\\)")]
    public void GivenMultipleTargetsRepositoryNull()
    {
        ctx.MultipleTargetsRepo
           .Setup(r => r.GetMultipleTargetsPlanAsync(
               It.IsAny<IReadOnlyCollection<int>>(),
               It.IsAny<IReadOnlyCollection<int>>(),
               It.IsAny<CancellationToken>()))
           .ReturnsAsync((MultipleTargetsPlanningResponse?)null);
    }

    // ── When ──────────────────────────────────────────────────────────────────

    [When("I request the multiple targets plan")]
    public async Task WhenRequestMultipleTargetsPlan()
    {
        var handler = new GetMultipleTargetsPlanQueryHandler(ctx.MultipleTargetsRepo.Object);
        ctx.MultipleTargetsResult = await handler.Handle(
            new GetMultipleTargetsPlanQuery(ctx.SourceProgramIds, ctx.TargetProgramIds),
            CancellationToken.None);
    }

    // ── Then ──────────────────────────────────────────────────────────────────

    [Then("the multiple targets query should succeed")]
    public void ThenMultipleTargetsSucceeds()
    {
        ctx.MultipleTargetsResult.Should().NotBeNull();
        ctx.MultipleTargetsResult!.IsSuccess.Should().BeTrue();
    }

    [Then("the response should contain target results")]
    public void ThenResponseContainsTargetResults()
    {
        ctx.MultipleTargetsResult!.Value.TargetResults.Should().NotBeNull();
    }

    [Then("the multiple targets query should fail with error code {string}")]
    public void ThenMultipleTargetsFails(string errorCode)
    {
        ctx.MultipleTargetsResult.Should().NotBeNull();
        ctx.MultipleTargetsResult!.IsFailure.Should().BeTrue();
        ctx.MultipleTargetsResult.Error.Code.Should().Be(errorCode);
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private static IReadOnlyCollection<int> ParseIds(string raw)
    {
        if (string.IsNullOrWhiteSpace(raw)) return Array.Empty<int>();
        return raw.Split(',', StringSplitOptions.RemoveEmptyEntries)
                  .Select(s => int.Parse(s.Trim()))
                  .ToArray();
    }

    private static MultipleTargetsPlanningResponse BuildResponse() =>
        new(
            SourcePrograms: Array.Empty<SourceProgramSummary>(),
            TargetResults: new[]
            {
                new TargetProgramResult(
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
                    SemesterPlans: Array.Empty<SemesterPlanItem>())
            });
}
