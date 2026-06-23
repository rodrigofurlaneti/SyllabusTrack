using FluentValidation.TestHelper;
using SyllabusTrack.Application.Features.Institutions.Create;
using Xunit;

namespace SyllabusTrack.Tests.Application.Features.Institutions;

public sealed class CreateInstitutionCommandValidatorTests
{
    private readonly CreateInstitutionCommandValidator _validator = new();

    private static CreateInstitutionCommand Valid() => new("FAM Faculdade", "FAM", "São Paulo - SP");

    [Fact]
    public void Validate_WithValidCommand_ShouldHaveNoErrors()
    {
        _validator.TestValidate(Valid()).ShouldNotHaveAnyValidationErrors();
    }

    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    public void Validate_WithEmptyName_ShouldHaveError(string name)
    {
        _validator.TestValidate(Valid() with { Name = name })
                  .ShouldHaveValidationErrorFor(c => c.Name);
    }

    [Fact]
    public void Validate_WithNameExceedingMaxLength_ShouldHaveError()
    {
        _validator.TestValidate(Valid() with { Name = new string('X', 256) })
                  .ShouldHaveValidationErrorFor(c => c.Name);
    }

    [Fact]
    public void Validate_WithAcronymExceedingMaxLength_ShouldHaveError()
    {
        _validator.TestValidate(Valid() with { Acronym = new string('A', 51) })
                  .ShouldHaveValidationErrorFor(c => c.Acronym);
    }

    [Fact]
    public void Validate_WithLocationExceedingMaxLength_ShouldHaveError()
    {
        _validator.TestValidate(Valid() with { Location = new string('L', 256) })
                  .ShouldHaveValidationErrorFor(c => c.Location);
    }

    [Fact]
    public void Validate_WithEmptyAcronymAndLocation_ShouldHaveNoErrors()
    {
        // Acronym e Location são opcionais
        _validator.TestValidate(Valid() with { Acronym = "", Location = "" })
                  .ShouldNotHaveAnyValidationErrors();
    }
}
