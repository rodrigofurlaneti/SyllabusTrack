using FluentAssertions;
using Moq;
using SyllabusTrack.Application.Features.Institutions.Update;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.Repositories;
using Xunit;

namespace SyllabusTrack.Tests.Application.Features.Institutions;

public sealed class UpdateInstitutionCommandHandlerTests
{
    private readonly Mock<IEducationalInstitutionRepository> _repoMock = new();
    private readonly Mock<IUnitOfWork> _uowMock = new();
    private readonly UpdateInstitutionCommandHandler _handler;

    public UpdateInstitutionCommandHandlerTests()
    {
        _handler = new UpdateInstitutionCommandHandler(_repoMock.Object, _uowMock.Object);
    }

    [Fact]
    public async Task Handle_WhenInstitutionExists_ShouldSucceedAndCommit()
    {
        var institution = EducationalInstitution.Create("FAM", "FAM", "SP").Value;
        _repoMock.Setup(r => r.GetByIdAsync(1, It.IsAny<CancellationToken>()))
                 .ReturnsAsync(institution);

        var cmd = new UpdateInstitutionCommand(1, "FAM Atualizado", "FAM2", "São Paulo - SP");
        var result = await _handler.Handle(cmd, CancellationToken.None);

        result.IsSuccess.Should().BeTrue();
        institution.InstitutionName.Should().Be("FAM Atualizado");
        _uowMock.Verify(u => u.CommitAsync(It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task Handle_WhenInstitutionDoesNotExist_ShouldFail()
    {
        _repoMock.Setup(r => r.GetByIdAsync(99, It.IsAny<CancellationToken>()))
                 .ReturnsAsync((EducationalInstitution?)null);

        var cmd = new UpdateInstitutionCommand(99, "Nome", "ACR", "Local");
        var result = await _handler.Handle(cmd, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("Institution.NotFound");
        _uowMock.Verify(u => u.CommitAsync(It.IsAny<CancellationToken>()), Times.Never);
    }

    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    public async Task Handle_WhenNameIsEmpty_ShouldFail(string name)
    {
        var institution = EducationalInstitution.Create("FAM", "FAM", "SP").Value;
        _repoMock.Setup(r => r.GetByIdAsync(1, It.IsAny<CancellationToken>()))
                 .ReturnsAsync(institution);

        var cmd = new UpdateInstitutionCommand(1, name, "FAM", "SP");
        var result = await _handler.Handle(cmd, CancellationToken.None);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("Institution.EmptyName");
        _uowMock.Verify(u => u.CommitAsync(It.IsAny<CancellationToken>()), Times.Never);
    }
}
