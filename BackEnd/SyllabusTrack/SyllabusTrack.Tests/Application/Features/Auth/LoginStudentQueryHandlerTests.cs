using FluentAssertions;
using Moq;
using SyllabusTrack.Application.Abstractions.Authentication;
using SyllabusTrack.Application.Features.Auth.Login;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Domain.ValueObjects;
using Xunit;

namespace SyllabusTrack.Tests.Application.Features.Auth;

public sealed class LoginStudentQueryHandlerTests
{
    private readonly Mock<IStudentAccountRepository> _repoMock = new();
    private readonly Mock<IPasswordHasher> _hasherMock = new();
    private readonly Mock<IJwtProvider> _jwtMock = new();
    private readonly LoginStudentQueryHandler _handler;

    public LoginStudentQueryHandlerTests()
    {
        _handler = new LoginStudentQueryHandler(
            _repoMock.Object,
            _hasherMock.Object,
            _jwtMock.Object);
    }

    private static StudentAccount BuildStudent()
    {
        var email = Email.Create("rodrigo@gmail.com").Value;
        return StudentAccount.Create("Rodrigo", "rodrigof", email, "11999990000", "$bcrypt$hash").Value;
    }

    [Fact]
    public async Task Handle_WithValidCredentials_ShouldReturnToken()
    {
        var student = BuildStudent();
        _repoMock.Setup(r => r.GetByEmailOrUsernameAsync("rodrigo@gmail.com", It.IsAny<CancellationToken>()))
                 .ReturnsAsync(student);
        _hasherMock.Setup(h => h.Verify("senha123", "$bcrypt$hash")).Returns(true);
        _jwtMock.Setup(j => j.Generate(student)).Returns("jwt.token.here");

        var query = new LoginStudentQuery("rodrigo@gmail.com", "senha123");
        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsSuccess.Should().BeTrue();
        result.Value.Should().Be("jwt.token.here");
    }

    [Fact]
    public async Task Handle_WhenStudentNotFound_ShouldFail()
    {
        _repoMock.Setup(r => r.GetByEmailOrUsernameAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()))
                 .ReturnsAsync((StudentAccount?)null);

        var query = new LoginStudentQuery("unknown@gmail.com", "senha123");
        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("Auth.InvalidCredentials");
    }

    [Fact]
    public async Task Handle_WhenPasswordIsWrong_ShouldFail()
    {
        var student = BuildStudent();
        _repoMock.Setup(r => r.GetByEmailOrUsernameAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()))
                 .ReturnsAsync(student);
        _hasherMock.Setup(h => h.Verify(It.IsAny<string>(), It.IsAny<string>())).Returns(false);

        var query = new LoginStudentQuery("rodrigo@gmail.com", "wrong_password");
        var result = await _handler.Handle(query, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("Auth.InvalidCredentials");
    }

    [Fact]
    public async Task Handle_WhenPasswordIsWrong_ShouldNotCallJwtProvider()
    {
        var student = BuildStudent();
        _repoMock.Setup(r => r.GetByEmailOrUsernameAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()))
                 .ReturnsAsync(student);
        _hasherMock.Setup(h => h.Verify(It.IsAny<string>(), It.IsAny<string>())).Returns(false);

        var query = new LoginStudentQuery("rodrigo@gmail.com", "wrong");
        await _handler.Handle(query, CancellationToken.None);

        _jwtMock.Verify(j => j.Generate(It.IsAny<StudentAccount>()), Times.Never);
    }

    [Fact]
    public async Task Handle_WithUsername_ShouldCallRepoWithThatIdentifier()
    {
        _repoMock.Setup(r => r.GetByEmailOrUsernameAsync("rodrigof", It.IsAny<CancellationToken>()))
                 .ReturnsAsync((StudentAccount?)null);

        var query = new LoginStudentQuery("rodrigof", "senha123");
        await _handler.Handle(query, CancellationToken.None);

        _repoMock.Verify(r => r.GetByEmailOrUsernameAsync("rodrigof", It.IsAny<CancellationToken>()), Times.Once);
    }
}
