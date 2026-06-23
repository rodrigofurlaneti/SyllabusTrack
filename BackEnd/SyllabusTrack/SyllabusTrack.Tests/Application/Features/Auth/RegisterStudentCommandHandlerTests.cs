using FluentAssertions;
using Moq;
using SyllabusTrack.Application.Abstractions.Authentication;
using SyllabusTrack.Application.Features.Auth.Register;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Domain.ValueObjects;
using Xunit;

namespace SyllabusTrack.Tests.Application.Features.Auth;

public sealed class RegisterStudentCommandHandlerTests
{
    private readonly Mock<IStudentAccountRepository> _repoMock = new();
    private readonly Mock<IPasswordHasher> _hasherMock = new();
    private readonly Mock<IUnitOfWork> _uowMock = new();
    private readonly RegisterStudentCommandHandler _handler;

    public RegisterStudentCommandHandlerTests()
    {
        _handler = new RegisterStudentCommandHandler(
            _repoMock.Object,
            _hasherMock.Object,
            _uowMock.Object);
    }

    private RegisterStudentCommand ValidCommand() => new(
        FullName: "Rodrigo Furlaneti",
        Username: "rodrigof",
        Email: "rodrigo@gmail.com",
        PhoneNumber: "11999990000",
        Password: "senha123");

    [Fact]
    public async Task Handle_WithValidCommand_ShouldSucceedAndCommit()
    {
        _repoMock.Setup(r => r.IsEmailUniqueAsync(It.IsAny<Email>(), It.IsAny<CancellationToken>()))
                 .ReturnsAsync(true);
        _repoMock.Setup(r => r.IsUsernameUniqueAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()))
                 .ReturnsAsync(true);
        _hasherMock.Setup(h => h.Hash(It.IsAny<string>())).Returns("hashed_pw");

        var result = await _handler.Handle(ValidCommand(), CancellationToken.None);

        result.IsSuccess.Should().BeTrue();
        _repoMock.Verify(r => r.AddAsync(It.IsAny<StudentAccount>(), It.IsAny<CancellationToken>()), Times.Once);
        _uowMock.Verify(u => u.CommitAsync(It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task Handle_WithInvalidEmail_ShouldFailBeforeHittingRepo()
    {
        var cmd = ValidCommand() with { Email = "not-an-email" };

        var result = await _handler.Handle(cmd, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("Email.Invalid");
        _repoMock.Verify(r => r.AddAsync(It.IsAny<StudentAccount>(), It.IsAny<CancellationToken>()), Times.Never);
        _uowMock.Verify(u => u.CommitAsync(It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task Handle_WhenEmailAlreadyTaken_ShouldFail()
    {
        _repoMock.Setup(r => r.IsEmailUniqueAsync(It.IsAny<Email>(), It.IsAny<CancellationToken>()))
                 .ReturnsAsync(false);

        var result = await _handler.Handle(ValidCommand(), CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("Auth.EmailTaken");
    }

    [Fact]
    public async Task Handle_WhenUsernameAlreadyTaken_ShouldFail()
    {
        _repoMock.Setup(r => r.IsEmailUniqueAsync(It.IsAny<Email>(), It.IsAny<CancellationToken>()))
                 .ReturnsAsync(true);
        _repoMock.Setup(r => r.IsUsernameUniqueAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()))
                 .ReturnsAsync(false);

        var result = await _handler.Handle(ValidCommand(), CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("Auth.UsernameTaken");
    }

    [Fact]
    public async Task Handle_WithEmptyFullName_ShouldFailWithStudentEmptyName()
    {
        _repoMock.Setup(r => r.IsEmailUniqueAsync(It.IsAny<Email>(), It.IsAny<CancellationToken>()))
                 .ReturnsAsync(true);
        _repoMock.Setup(r => r.IsUsernameUniqueAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()))
                 .ReturnsAsync(true);
        _hasherMock.Setup(h => h.Hash(It.IsAny<string>())).Returns("hashed_pw");

        var cmd = ValidCommand() with { FullName = "" };

        var result = await _handler.Handle(cmd, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("Student.EmptyName");
    }

    [Fact]
    public async Task Handle_WithEmptyUsername_ShouldFailWithStudentEmptyUsername()
    {
        _repoMock.Setup(r => r.IsEmailUniqueAsync(It.IsAny<Email>(), It.IsAny<CancellationToken>()))
                 .ReturnsAsync(true);
        _repoMock.Setup(r => r.IsUsernameUniqueAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()))
                 .ReturnsAsync(true);
        _hasherMock.Setup(h => h.Hash(It.IsAny<string>())).Returns("hashed_pw");

        var cmd = ValidCommand() with { Username = "" };

        var result = await _handler.Handle(cmd, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("Student.EmptyUsername");
    }

    [Fact]
    public async Task Handle_ShouldHashPasswordBeforeStoringStudent()
    {
        _repoMock.Setup(r => r.IsEmailUniqueAsync(It.IsAny<Email>(), It.IsAny<CancellationToken>()))
                 .ReturnsAsync(true);
        _repoMock.Setup(r => r.IsUsernameUniqueAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()))
                 .ReturnsAsync(true);
        _hasherMock.Setup(h => h.Hash("senha123")).Returns("$bcrypt$hashed");

        StudentAccount? captured = null;
        _repoMock.Setup(r => r.AddAsync(It.IsAny<StudentAccount>(), It.IsAny<CancellationToken>()))
                 .Callback<StudentAccount, CancellationToken>((s, _) => captured = s);

        await _handler.Handle(ValidCommand(), CancellationToken.None);

        captured.Should().NotBeNull();
        captured!.AccountPassword.Should().Be("$bcrypt$hashed");
    }
}
