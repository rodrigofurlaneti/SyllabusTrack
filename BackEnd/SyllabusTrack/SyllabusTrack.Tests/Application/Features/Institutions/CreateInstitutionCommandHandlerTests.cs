using FluentAssertions;
using Moq;
using SyllabusTrack.Application.Features.Institutions.Create;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.Repositories; // IEducationalInstitutionRepository, IUnitOfWork
using Xunit;

namespace SyllabusTrack.Tests.Application.Features.Institutions;

public sealed class CreateInstitutionCommandHandlerTests
{
    private readonly Mock<IEducationalInstitutionRepository> _repoMock = new();
    private readonly Mock<IUnitOfWork> _uowMock = new();
    private readonly CreateInstitutionCommandHandler _handler;

    public CreateInstitutionCommandHandlerTests()
    {
        _handler = new CreateInstitutionCommandHandler(_repoMock.Object, _uowMock.Object);
    }

    [Fact]
    public async Task Handle_WithValidCommand_ShouldSucceedAndCommit()
    {
        var cmd = new CreateInstitutionCommand("FAM Faculdade", "FAM", "São Paulo - SP");

        var result = await _handler.Handle(cmd, CancellationToken.None);

        result.IsSuccess.Should().BeTrue();
        _repoMock.Verify(r => r.AddAsync(It.IsAny<EducationalInstitution>(), It.IsAny<CancellationToken>()), Times.Once);
        _uowMock.Verify(u => u.CommitAsync(It.IsAny<CancellationToken>()), Times.Once);
    }

    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    public async Task Handle_WithEmptyName_ShouldFail(string name)
    {
        var cmd = new CreateInstitutionCommand(name, "FAM", "São Paulo - SP");

        var result = await _handler.Handle(cmd, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("Institution.EmptyName");
        _repoMock.Verify(r => r.AddAsync(It.IsAny<EducationalInstitution>(), It.IsAny<CancellationToken>()), Times.Never);
        _uowMock.Verify(u => u.CommitAsync(It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task Handle_WithOptionalFieldsEmpty_ShouldSucceed()
    {
        var cmd = new CreateInstitutionCommand("Universidade X", "", "");

        var result = await _handler.Handle(cmd, CancellationToken.None);

        result.IsSuccess.Should().BeTrue();
    }
}
