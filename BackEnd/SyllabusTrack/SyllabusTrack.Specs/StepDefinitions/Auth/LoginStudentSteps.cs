using FluentAssertions;
using Moq;
using Reqnroll;
using SyllabusTrack.Application.Features.Auth.Login;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.ValueObjects;
using SyllabusTrack.Specs.Support;

namespace SyllabusTrack.Specs.StepDefinitions.Auth;

[Binding]
public sealed class LoginStudentSteps(AuthContext ctx)
{
    private static StudentAccount BuildStudent(string email, string hashedPw)
    {
        var emailVo = Email.Create(email).Value;
        return StudentAccount.Create("Rodrigo", "rodrigof", emailVo, "11999990000", hashedPw).Value;
    }

    // ── Given ─────────────────────────────────────────────────────────────────

    [Given("a registered student with email {string} and password {string}")]
    public void GivenStudentWithEmailAndPassword(string email, string password)
    {
        var hashedPw = "$bcrypt$hashed_" + password;
        var student  = BuildStudent(email, hashedPw);

        ctx.RepoMock.Setup(r => r.GetByEmailOrUsernameAsync(email, It.IsAny<CancellationToken>()))
                    .ReturnsAsync(student);
        ctx.HasherMock.Setup(h => h.Verify(password, hashedPw)).Returns(true);
        ctx.HasherMock.Setup(h => h.Verify(It.IsNotIn(password), hashedPw)).Returns(false);
        ctx.JwtMock.Setup(j => j.Generate(It.IsAny<StudentAccount>())).Returns("jwt.access.token");
    }

    [Given("a registered student with username {string} and password {string}")]
    public void GivenStudentWithUsernameAndPassword(string username, string password)
    {
        var hashedPw = "$bcrypt$hashed_" + password;
        var email    = Email.Create("rodrigo@gmail.com").Value;
        var student  = StudentAccount.Create("Rodrigo", username, email, "11999990000", hashedPw).Value;

        ctx.RepoMock.Setup(r => r.GetByEmailOrUsernameAsync(username, It.IsAny<CancellationToken>()))
                    .ReturnsAsync(student);
        ctx.HasherMock.Setup(h => h.Verify(password, hashedPw)).Returns(true);
        ctx.JwtMock.Setup(j => j.Generate(It.IsAny<StudentAccount>())).Returns("jwt.access.token");
    }

    [Given("no student exists with identifier {string}")]
    public void GivenNoStudentWithIdentifier(string identifier)
    {
        ctx.RepoMock.Setup(r => r.GetByEmailOrUsernameAsync(identifier, It.IsAny<CancellationToken>()))
                    .ReturnsAsync((StudentAccount?)null);
    }

    // ── When ──────────────────────────────────────────────────────────────────

    [When("I log in with identifier {string} and password {string}")]
    public async Task WhenLoginWithIdentifierAndPassword(string identifier, string password)
    {
        var handler = new LoginStudentQueryHandler(
            ctx.RepoMock.Object,
            ctx.HasherMock.Object,
            ctx.JwtMock.Object);

        ctx.LoginResult = await handler.Handle(
            new LoginStudentQuery(identifier, password),
            CancellationToken.None);
    }

    // ── Then ──────────────────────────────────────────────────────────────────

    [Then("the login should succeed")]
    public void ThenLoginSucceeds()
    {
        ctx.LoginResult.Should().NotBeNull();
        ctx.LoginResult!.IsSuccess.Should().BeTrue();
    }

    [Then("I should receive a JWT token")]
    public void ThenShouldReceiveJwtToken()
    {
        ctx.LoginResult!.Value.Should().NotBeNullOrWhiteSpace();
        ctx.JwtMock.Verify(j => j.Generate(It.IsAny<StudentAccount>()), Times.Once);
    }

    [Then("the login should fail with error code {string}")]
    public void ThenLoginFailsWithCode(string errorCode)
    {
        ctx.LoginResult.Should().NotBeNull();
        ctx.LoginResult!.IsFailure.Should().BeTrue();
        ctx.LoginResult.Error.Code.Should().Be(errorCode);
    }

    [Then("no JWT token should be generated")]
    public void ThenNoJwtTokenGenerated()
    {
        ctx.JwtMock.Verify(j => j.Generate(It.IsAny<StudentAccount>()), Times.Never);
    }
}
