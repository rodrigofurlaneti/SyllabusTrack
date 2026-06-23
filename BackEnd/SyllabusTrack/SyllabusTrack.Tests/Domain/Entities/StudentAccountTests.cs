using FluentAssertions;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.ValueObjects;
using Xunit;

namespace SyllabusTrack.Tests.Domain.Entities;

public sealed class StudentAccountTests
{
    private static Email ValidEmail() => Email.Create("rodrigo@gmail.com").Value;

    // ── Create ────────────────────────────────────────────────────────────────

    [Fact]
    public void Create_WithValidData_ShouldSucceed()
    {
        var result = StudentAccount.Create(
            "Rodrigo Furlaneti",
            "rodrigof",
            ValidEmail(),
            "11999990000",
            "hashed_password_123");

        result.IsSuccess.Should().BeTrue();
        result.Value.StudentFullName.Should().Be("Rodrigo Furlaneti");
        result.Value.LoginUsername.Should().Be("rodrigof");
        result.Value.EmailAddress.Value.Should().Be("rodrigo@gmail.com");
        result.Value.CellPhoneNumber.Should().Be("11999990000");
        result.Value.IsActive.Should().BeTrue();
        result.Value.CreatedAt.Should().BeCloseTo(DateTime.UtcNow, TimeSpan.FromSeconds(5));
    }

    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    [InlineData(null!)]
    public void Create_WithEmptyFullName_ShouldFail(string? name)
    {
        var result = StudentAccount.Create(
            name!,
            "rodrigof",
            ValidEmail(),
            "11999990000",
            "password");

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("Student.EmptyName");
    }

    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    [InlineData(null!)]
    public void Create_WithEmptyUsername_ShouldFail(string? username)
    {
        var result = StudentAccount.Create(
            "Rodrigo",
            username!,
            ValidEmail(),
            "11999990000",
            "password");

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("Student.EmptyUsername");
    }

    [Fact]
    public void Create_ShouldSetCreatedAtToUtcNow()
    {
        var before = DateTime.UtcNow;

        var result = StudentAccount.Create(
            "Rodrigo",
            "rodrigof",
            ValidEmail(),
            "11999990000",
            "password");

        var after = DateTime.UtcNow;

        result.Value.CreatedAt.Should().BeOnOrAfter(before).And.BeOnOrBefore(after);
        result.Value.UpdatedAt.Should().BeOnOrAfter(before).And.BeOnOrBefore(after);
    }
}
