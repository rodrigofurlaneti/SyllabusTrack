using FluentAssertions;
using Moq;
using Reqnroll;
using SyllabusTrack.Application.Features.Auth.Register;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.ValueObjects;
using SyllabusTrack.Specs.Support;

namespace SyllabusTrack.Specs.StepDefinitions.Auth;

[Binding]
public sealed class RegisterStudentSteps(AuthContext ctx)
{
    private string _fullName    = "Rodrigo Furlaneti";
    private string _username    = "rodrigof";
    private string _email       = "rodrigo@gmail.com";
    private string _phoneNumber = "11999990000";
    private string _password    = "senha123";

    // ── Background / Given ────────────────────────────────────────────────────

    [Given("the email {string} is available")]
    public void GivenEmailIsAvailable(string email)
    {
        var emailVo = Email.Create(email).Value;
        ctx.RepoMock
           .Setup(r => r.IsEmailUniqueAsync(It.Is<Email>(e => e.Value == email), It.IsAny<CancellationToken>()))
           .ReturnsAsync(true);
        _email = email;
    }

    [Given("the username {string} is available")]
    public void GivenUsernameIsAvailable(string username)
    {
        ctx.RepoMock
           .Setup(r => r.IsUsernameUniqueAsync(username, It.IsAny<CancellationToken>()))
           .ReturnsAsync(true);
        _username = username;
    }

    [Given("the email {string} is already taken")]
    public void GivenEmailIsAlreadyTaken(string email)
    {
        ctx.RepoMock
           .Setup(r => r.IsEmailUniqueAsync(It.IsAny<Email>(), It.IsAny<CancellationToken>()))
           .ReturnsAsync(false);
        _email = email;
    }

    [Given("the username {string} is already taken")]
    public void GivenUsernameIsAlreadyTaken(string username)
    {
        ctx.RepoMock
           .Setup(r => r.IsEmailUniqueAsync(It.IsAny<Email>(), It.IsAny<CancellationToken>()))
           .ReturnsAsync(true);
        ctx.RepoMock
           .Setup(r => r.IsUsernameUniqueAsync(username, It.IsAny<CancellationToken>()))
           .ReturnsAsync(false);
        _username = username;
    }

    [Given("the username is empty")]
    public void GivenUsernameIsEmpty() => _username = "";

    [Given("I want to register with the following data:")]
    public void GivenRegistrationData(DataTable table)
    {
        _fullName    = table.Rows.First(r => r["Field"] == "FullName")["Value"];
        _username    = table.Rows.First(r => r["Field"] == "Username")["Value"];
        _email       = table.Rows.First(r => r["Field"] == "Email")["Value"];
        _phoneNumber = table.Rows.First(r => r["Field"] == "PhoneNumber")["Value"];
        _password    = table.Rows.First(r => r["Field"] == "Password")["Value"];

        ctx.HasherMock.Setup(h => h.Hash(_password)).Returns("$bcrypt$hashed");
    }

    // ── When ──────────────────────────────────────────────────────────────────

    [When("I submit the registration")]
    public async Task WhenSubmitRegistration()
    {
        ctx.HasherMock.Setup(h => h.Hash(It.IsAny<string>())).Returns("$bcrypt$hashed");
        var handler = new RegisterStudentCommandHandler(
            ctx.RepoMock.Object,
            ctx.HasherMock.Object,
            ctx.UowMock.Object);

        ctx.RegisterResult = await handler.Handle(
            new RegisterStudentCommand(_fullName, _username, _email, _phoneNumber, _password),
            CancellationToken.None);
    }

    [When("I submit the registration with email {string} and username {string}")]
    public async Task WhenSubmitRegistrationWithEmailAndUsername(string email, string username)
    {
        _email    = email;
        _username = username;
        ctx.HasherMock.Setup(h => h.Hash(It.IsAny<string>())).Returns("$bcrypt$hashed");

        var handler = new RegisterStudentCommandHandler(
            ctx.RepoMock.Object,
            ctx.HasherMock.Object,
            ctx.UowMock.Object);

        ctx.RegisterResult = await handler.Handle(
            new RegisterStudentCommand(_fullName, _username, _email, _phoneNumber, _password),
            CancellationToken.None);
    }

    [When("I submit a registration with empty full name")]
    public async Task WhenSubmitWithEmptyFullName()
    {
        ctx.HasherMock.Setup(h => h.Hash(It.IsAny<string>())).Returns("$bcrypt$hashed");
        var handler = new RegisterStudentCommandHandler(
            ctx.RepoMock.Object,
            ctx.HasherMock.Object,
            ctx.UowMock.Object);

        ctx.RegisterResult = await handler.Handle(
            new RegisterStudentCommand("", _username, _email, _phoneNumber, _password),
            CancellationToken.None);
    }

    [When("I submit a registration with empty username")]
    public async Task WhenSubmitWithEmptyUsername()
    {
        ctx.HasherMock.Setup(h => h.Hash(It.IsAny<string>())).Returns("$bcrypt$hashed");
        var handler = new RegisterStudentCommandHandler(
            ctx.RepoMock.Object,
            ctx.HasherMock.Object,
            ctx.UowMock.Object);

        ctx.RegisterResult = await handler.Handle(
            new RegisterStudentCommand(_fullName, "", _email, _phoneNumber, _password),
            CancellationToken.None);
    }

    // ── Then ──────────────────────────────────────────────────────────────────

    [Then("the registration should succeed")]
    public void ThenRegistrationSucceeds()
    {
        ctx.RegisterResult.Should().NotBeNull();
        ctx.RegisterResult!.IsSuccess.Should().BeTrue();
    }

    [Then("the new student account should be persisted")]
    public void ThenStudentShouldBePersisted()
    {
        ctx.RepoMock.Verify(r => r.AddAsync(It.IsAny<StudentAccount>(), It.IsAny<CancellationToken>()), Times.Once);
        ctx.UowMock.Verify(u => u.CommitAsync(It.IsAny<CancellationToken>()), Times.Once);
    }

    [Then("the registration should fail with error code {string}")]
    public void ThenRegistrationFailsWithCode(string errorCode)
    {
        ctx.RegisterResult.Should().NotBeNull();
        ctx.RegisterResult!.IsFailure.Should().BeTrue();
        ctx.RegisterResult.Error.Code.Should().Be(errorCode);
    }
}
