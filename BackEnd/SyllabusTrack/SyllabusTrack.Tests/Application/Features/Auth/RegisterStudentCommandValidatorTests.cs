using FluentAssertions;
using FluentValidation.TestHelper;
using SyllabusTrack.Application.Features.Auth.Register;
using Xunit;

namespace SyllabusTrack.Tests.Application.Features.Auth;

public sealed class RegisterStudentCommandValidatorTests
{
    private readonly RegisterStudentCommandValidator _validator = new();

    private static RegisterStudentCommand ValidCommand() => new(
        FullName: "Rodrigo Furlaneti",
        Username: "rodrigof",
        Email: "rodrigo@gmail.com",
        PhoneNumber: "11999990000",
        Password: "senha123");

    [Fact]
    public void Validate_WithValidCommand_ShouldHaveNoErrors()
    {
        var result = _validator.TestValidate(ValidCommand());
        result.ShouldNotHaveAnyValidationErrors();
    }

    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    public void Validate_WithEmptyFullName_ShouldHaveError(string name)
    {
        var result = _validator.TestValidate(ValidCommand() with { FullName = name });
        result.ShouldHaveValidationErrorFor(c => c.FullName);
    }

    [Fact]
    public void Validate_WithFullNameExceedingMaxLength_ShouldHaveError()
    {
        var longName = new string('A', 256);
        var result = _validator.TestValidate(ValidCommand() with { FullName = longName });
        result.ShouldHaveValidationErrorFor(c => c.FullName);
    }

    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    public void Validate_WithEmptyUsername_ShouldHaveError(string username)
    {
        var result = _validator.TestValidate(ValidCommand() with { Username = username });
        result.ShouldHaveValidationErrorFor(c => c.Username);
    }

    [Fact]
    public void Validate_WithUsernameExceedingMaxLength_ShouldHaveError()
    {
        var longUsername = new string('a', 51);
        var result = _validator.TestValidate(ValidCommand() with { Username = longUsername });
        result.ShouldHaveValidationErrorFor(c => c.Username);
    }

    [Theory]
    [InlineData("")]
    [InlineData("not-an-email")]
    [InlineData("missing-at.com")]
    public void Validate_WithInvalidEmail_ShouldHaveError(string email)
    {
        var result = _validator.TestValidate(ValidCommand() with { Email = email });
        result.ShouldHaveValidationErrorFor(c => c.Email);
    }

    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    public void Validate_WithEmptyPhoneNumber_ShouldHaveError(string phone)
    {
        var result = _validator.TestValidate(ValidCommand() with { PhoneNumber = phone });
        result.ShouldHaveValidationErrorFor(c => c.PhoneNumber);
    }

    [Fact]
    public void Validate_WithPhoneExceedingMaxLength_ShouldHaveError()
    {
        var longPhone = new string('1', 21);
        var result = _validator.TestValidate(ValidCommand() with { PhoneNumber = longPhone });
        result.ShouldHaveValidationErrorFor(c => c.PhoneNumber);
    }

    [Theory]
    [InlineData("")]
    [InlineData("12345")] // less than 6
    public void Validate_WithShortOrEmptyPassword_ShouldHaveError(string password)
    {
        var result = _validator.TestValidate(ValidCommand() with { Password = password });
        result.ShouldHaveValidationErrorFor(c => c.Password);
    }

    [Fact]
    public void Validate_WithPasswordExactlyMinLength_ShouldHaveNoError()
    {
        var result = _validator.TestValidate(ValidCommand() with { Password = "123456" });
        result.ShouldNotHaveValidationErrorFor(c => c.Password);
    }
}
