using FluentAssertions;
using Moq;
using Reqnroll;
using SyllabusTrack.Application.Features.Recommendations;
using SyllabusTrack.Application.Features.Recommendations.GetRecommendations;
using SyllabusTrack.Specs.Support;

namespace SyllabusTrack.Specs.StepDefinitions.Recommendations;

[Binding]
public sealed class RecommendationSteps(RecommendationContext ctx)
{
    // ── Given ─────────────────────────────────────────────────────────────────

    [Given("a student with ID {int} has completed subjects that match other programs")]
    public void GivenStudentWithMatchingPrograms(int studentId)
    {
        // Stub is set in the next step
    }

    [Given("a student with ID {int} has no matching programs")]
    public void GivenStudentWithNoMatchingPrograms(int studentId)
    {
        // Stub is set in the next step
    }

    [Given("the recommendation repository returns {int} recommendations for student {int}")]
    public void GivenRecommendationsForStudent(int count, int studentId)
    {
        var recs = Enumerable.Range(1, count)
            .Select(i => new ProgramRecommendationResponse(
                ProgramId: i,
                ProgramName: $"Curso {i}",
                CurriculumVersion: "2024.1",
                TotalSemesters: 4,
                InstitutionName: "FAM",
                InstitutionAcronym: "FAM",
                TotalSubjects: 40,
                MatchedSubjects: 30,
                RemainingSubjects: 10,
                MatchPercentage: 75m))
            .ToArray();

        ctx.RepoMock
           .Setup(r => r.GetRecommendationsAsync(studentId, It.IsAny<CancellationToken>()))
           .ReturnsAsync((IReadOnlyCollection<ProgramRecommendationResponse>)recs);
    }

    [Given("the recommendation repository returns an empty list for student {int}")]
    public void GivenEmptyRecommendationsForStudent(int studentId)
    {
        ctx.RepoMock
           .Setup(r => r.GetRecommendationsAsync(studentId, It.IsAny<CancellationToken>()))
           .ReturnsAsync(Array.Empty<ProgramRecommendationResponse>());
    }

    // ── When ──────────────────────────────────────────────────────────────────

    [When("I request recommendations for student {int}")]
    public async Task WhenRequestRecommendations(int studentId)
    {
        ctx.CalledWithStudentId = studentId;
        var handler = new GetProgramRecommendationsQueryHandler(ctx.RepoMock.Object);
        ctx.Result = await handler.Handle(
            new GetProgramRecommendationsQuery(studentId),
            CancellationToken.None);
    }

    // ── Then ──────────────────────────────────────────────────────────────────

    [Then("the recommendations query should succeed")]
    public void ThenRecommendationsSucceed()
    {
        ctx.Result.Should().NotBeNull();
        ctx.Result!.IsSuccess.Should().BeTrue();
    }

    [Then("the response should contain {int} recommendations")]
    public void ThenResponseContainsRecommendations(int count)
    {
        ctx.Result!.Value.Should().HaveCount(count);
    }

    [Then("the response should be empty")]
    public void ThenResponseIsEmpty()
    {
        ctx.Result!.Value.Should().BeEmpty();
    }

    [Then("the repository should have been called with student ID {int}")]
    public void ThenRepositoryCalledWithStudentId(int studentId)
    {
        ctx.RepoMock.Verify(
            r => r.GetRecommendationsAsync(studentId, It.IsAny<CancellationToken>()),
            Times.Once);
    }
}
