using FluentAssertions;
using SyllabusTrack.Domain.Entities;
using Xunit;

namespace SyllabusTrack.Tests.Domain.Entities;

public sealed class EducationalInstitutionTests
{
    // ── Create ────────────────────────────────────────────────────────────────

    [Fact]
    public void Create_WithValidData_ShouldSucceed()
    {
        var result = EducationalInstitution.Create("Universidade Anhanguera", "ANHANGUERA", "São Paulo - SP");

        result.IsSuccess.Should().BeTrue();
        result.Value.InstitutionName.Should().Be("Universidade Anhanguera");
        result.Value.InstitutionAcronym.Should().Be("ANHANGUERA");
        result.Value.CampusLocation.Should().Be("São Paulo - SP");
        result.Value.IsActive.Should().BeTrue();
    }

    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    [InlineData(null!)]
    public void Create_WithEmptyName_ShouldFail(string? name)
    {
        var result = EducationalInstitution.Create(name!, "FAM", "São Paulo - SP");

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("Institution.EmptyName");
    }

    [Fact]
    public void Create_WithEmptyAcronymAndLocation_ShouldSucceed()
    {
        // Acronym e Location podem ser vazios — apenas Name é obrigatório
        var result = EducationalInstitution.Create("Nome Válido", "", "");

        result.IsSuccess.Should().BeTrue();
    }

    // ── UpdateDetails ─────────────────────────────────────────────────────────

    [Fact]
    public void UpdateDetails_WithValidData_ShouldSucceed()
    {
        var institution = EducationalInstitution.Create("FAM", "FAM", "SP").Value;

        var updateResult = institution.UpdateDetails("FAM Faculdade", "FAM-EDU", "São Paulo - SP");

        updateResult.IsSuccess.Should().BeTrue();
        institution.InstitutionName.Should().Be("FAM Faculdade");
        institution.InstitutionAcronym.Should().Be("FAM-EDU");
        institution.CampusLocation.Should().Be("São Paulo - SP");
    }

    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    [InlineData(null!)]
    public void UpdateDetails_WithEmptyName_ShouldFail(string? name)
    {
        var institution = EducationalInstitution.Create("FAM", "FAM", "SP").Value;

        var updateResult = institution.UpdateDetails(name!, "FAM", "SP");

        updateResult.IsFailure.Should().BeTrue();
        updateResult.Error.Code.Should().Be("Institution.EmptyName");
    }

    // ── Deactivate ────────────────────────────────────────────────────────────

    [Fact]
    public void Deactivate_ShouldSetIsActiveToFalse()
    {
        var institution = EducationalInstitution.Create("FAM", "FAM", "SP").Value;
        institution.IsActive.Should().BeTrue();

        institution.Deactivate();

        institution.IsActive.Should().BeFalse();
    }
}
