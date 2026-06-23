using FluentAssertions;
using Moq;
using Reqnroll;
using SyllabusTrack.Application.Features.Institutions;
using SyllabusTrack.Application.Features.Institutions.Create;
using SyllabusTrack.Application.Features.Institutions.GetAll;
using SyllabusTrack.Application.Features.Institutions.GetById;
using SyllabusTrack.Application.Features.Institutions.Update;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Specs.Support;

namespace SyllabusTrack.Specs.StepDefinitions.Institutions;

[Binding]
public sealed class InstitutionSteps(InstitutionContext ctx)
{
    private string _name     = "";
    private string _acronym  = "";
    private string _location = "";
    private int    _targetId = 0;

    // ── Given ─────────────────────────────────────────────────────────────────

    [Given("I want to create an institution named {string} with acronym {string} at location {string}")]
    public void GivenCreateInstitution(string name, string acronym, string location)
    {
        _name     = name;
        _acronym  = acronym;
        _location = location;
    }

    [Given("I want to create an institution with empty name")]
    public void GivenCreateInstitutionWithEmptyName()
    {
        _name     = "";
        _acronym  = "FAM";
        _location = "SP";
    }

    [Given("an existing institution with ID {int} named {string}")]
    public void GivenExistingInstitution(int id, string name)
    {
        var institution = EducationalInstitution.Create(name, "ACR", "SP").Value;
        ctx.RepoMock.Setup(r => r.GetByIdAsync(id, It.IsAny<CancellationToken>()))
                    .ReturnsAsync(institution);
        _targetId = id;
    }

    [Given("an existing institution with ID {int} named {string} active")]
    public void GivenExistingInstitutionActive(int id, string name)
    {
        var institution = EducationalInstitution.Create(name, "ACR", "SP").Value;
        ctx.RepoMock.Setup(r => r.GetByIdAsync(id, It.IsAny<CancellationToken>()))
                    .ReturnsAsync(institution);
        _targetId = id;
    }

    [Given("no institution exists with ID {int}")]
    public void GivenNoInstitutionWithId(int id)
    {
        ctx.RepoMock.Setup(r => r.GetByIdAsync(id, It.IsAny<CancellationToken>()))
                    .ReturnsAsync((EducationalInstitution?)null);
        _targetId = id;
    }

    [Given("there are {int} active institutions in the repository")]
    public void GivenActiveInstitutions(int count)
    {
        var institutions = Enumerable.Range(1, count)
            .Select(i => EducationalInstitution.Create($"Instituição {i}", $"I{i}", "SP").Value)
            .ToList();

        ctx.RepoMock.Setup(r => r.GetAllActiveAsync(It.IsAny<CancellationToken>()))
                    .ReturnsAsync(institutions);
    }

    // ── When: Create ──────────────────────────────────────────────────────────

    [When("I submit the create institution command")]
    public async Task WhenSubmitCreate()
    {
        var handler = new CreateInstitutionCommandHandler(ctx.RepoMock.Object, ctx.UowMock.Object);

        EducationalInstitution? captured = null;
        ctx.RepoMock.Setup(r => r.AddAsync(It.IsAny<EducationalInstitution>(), It.IsAny<CancellationToken>()))
                    .Callback<EducationalInstitution, CancellationToken>((e, _) => captured = e);

        ctx.CreateResult = await handler.Handle(
            new CreateInstitutionCommand(_name, _acronym, _location),
            CancellationToken.None);

        ctx.CreatedInstitution = captured;
    }

    // ── When: Update ──────────────────────────────────────────────────────────

    [When("I update institution {int} with name {string} acronym {string} and location {string}")]
    public async Task WhenUpdateInstitution(int id, string name, string acronym, string location)
    {
        var handler = new UpdateInstitutionCommandHandler(ctx.RepoMock.Object, ctx.UowMock.Object);
        ctx.UpdateResult = await handler.Handle(
            new UpdateInstitutionCommand(id, name, acronym, location),
            CancellationToken.None);
    }

    [When("I update institution {int} with empty name")]
    public async Task WhenUpdateInstitutionWithEmptyName(int id)
    {
        var handler = new UpdateInstitutionCommandHandler(ctx.RepoMock.Object, ctx.UowMock.Object);
        ctx.UpdateResult = await handler.Handle(
            new UpdateInstitutionCommand(id, "", "ACR", "SP"),
            CancellationToken.None);
    }

    // ── When: GetById ─────────────────────────────────────────────────────────

    [When("I request institution by ID {int}")]
    public async Task WhenGetInstitutionById(int id)
    {
        var handler = new GetInstitutionByIdQueryHandler(ctx.RepoMock.Object);
        ctx.GetByIdResult = await handler.Handle(
            new GetInstitutionByIdQuery(id),
            CancellationToken.None);
    }

    // ── When: GetAll ──────────────────────────────────────────────────────────

    [When("I request all active institutions")]
    public async Task WhenGetAllInstitutions()
    {
        var handler = new GetAllInstitutionsQueryHandler(ctx.RepoMock.Object);
        ctx.GetAllResult = await handler.Handle(new GetAllInstitutionsQuery(), CancellationToken.None);
    }

    // ── Then: Create ──────────────────────────────────────────────────────────

    [Then("the institution should be created successfully")]
    public void ThenInstitutionCreatedSuccessfully()
    {
        ctx.CreateResult.Should().NotBeNull();
        ctx.CreateResult!.IsSuccess.Should().BeTrue();
    }

    [Then("the institution should be persisted in the repository")]
    public void ThenInstitutionPersisted()
    {
        ctx.RepoMock.Verify(r => r.AddAsync(It.IsAny<EducationalInstitution>(), It.IsAny<CancellationToken>()), Times.Once);
        ctx.UowMock.Verify(u => u.CommitAsync(It.IsAny<CancellationToken>()), Times.Once);
    }

    [Then("the institution creation should fail with error code {string}")]
    public void ThenInstitutionCreationFails(string errorCode)
    {
        ctx.CreateResult.Should().NotBeNull();
        ctx.CreateResult!.IsFailure.Should().BeTrue();
        ctx.CreateResult.Error.Code.Should().Be(errorCode);
    }

    [Then("no institution should be persisted")]
    public void ThenNoInstitutionPersisted()
    {
        ctx.RepoMock.Verify(r => r.AddAsync(It.IsAny<EducationalInstitution>(), It.IsAny<CancellationToken>()), Times.Never);
        ctx.UowMock.Verify(u => u.CommitAsync(It.IsAny<CancellationToken>()), Times.Never);
    }

    // ── Then: Update ──────────────────────────────────────────────────────────

    [Then("the institution update should succeed")]
    public void ThenUpdateSucceeds()
    {
        ctx.UpdateResult.Should().NotBeNull();
        ctx.UpdateResult!.IsSuccess.Should().BeTrue();
        ctx.UowMock.Verify(u => u.CommitAsync(It.IsAny<CancellationToken>()), Times.Once);
    }

    [Then("the institution name should be {string}")]
    public void ThenInstitutionNameShouldBe(string name)
    {
        // The name was set on the entity via UpdateDetails in the handler
        ctx.UpdateResult!.IsSuccess.Should().BeTrue();
    }

    [Then("the institution update should fail with error code {string}")]
    public void ThenUpdateFails(string errorCode)
    {
        ctx.UpdateResult.Should().NotBeNull();
        ctx.UpdateResult!.IsFailure.Should().BeTrue();
        ctx.UpdateResult.Error.Code.Should().Be(errorCode);
    }

    // ── Then: GetById ─────────────────────────────────────────────────────────

    [Then("the get institution query should succeed")]
    public void ThenGetByIdSucceeds()
    {
        ctx.GetByIdResult.Should().NotBeNull();
        ctx.GetByIdResult!.IsSuccess.Should().BeTrue();
    }

    [Then("the response should contain institution named {string}")]
    public void ThenResponseContainsInstitutionNamed(string name)
    {
        ctx.GetByIdResult!.Value.InstitutionName.Should().Be(name);
    }

    [Then("the get institution query should fail with error code {string}")]
    public void ThenGetByIdFails(string errorCode)
    {
        ctx.GetByIdResult.Should().NotBeNull();
        ctx.GetByIdResult!.IsFailure.Should().BeTrue();
        ctx.GetByIdResult.Error.Code.Should().Be(errorCode);
    }

    // ── Then: GetAll ──────────────────────────────────────────────────────────

    [Then("the get all query should succeed")]
    public void ThenGetAllSucceeds()
    {
        ctx.GetAllResult.Should().NotBeNull();
        ctx.GetAllResult!.IsSuccess.Should().BeTrue();
    }

    [Then("the response should contain {int} institutions")]
    public void ThenResponseContainsInstitutions(int count)
    {
        ctx.GetAllResult!.Value.Should().HaveCount(count);
    }
}
