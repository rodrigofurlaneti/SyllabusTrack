using FluentAssertions;
using SyllabusTrack.Domain.ValueObjects;
using Xunit;

namespace SyllabusTrack.Tests.Domain.ValueObjects;

public sealed class EmailTests
{
    [Theory]
    [InlineData("user@example.com")]
    [InlineData("rodrigo@gmail.com")]
    [InlineData("test.name+tag@domain.org")]
    public void Create_WithValidEmail_ShouldSucceed(string email)
    {
        var result = Email.Create(email);

        result.IsSuccess.Should().BeTrue();
        result.Value.Value.Should().Be(email);
    }

    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    [InlineData(null!)]
    public void Create_WithEmptyEmail_ShouldFail(string? email)
    {
        var result = Email.Create(email!);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("Email.Empty");
    }

    [Fact]
    public void Create_WithoutAtSign_ShouldFail()
    {
        var result = Email.Create("invalidemail.com");

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("Email.Invalid");
    }

    [Fact]
    public void Create_WithEmailExceedingMaxLength_ShouldFail()
    {
        var longEmail = new string('a', 248) + "@b.com"; // > 255 chars
        var result = Email.Create(longEmail);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("Email.TooLong");
    }

    [Fact]
    public void Create_WithEmailAtMaxLength_ShouldSucceed()
    {
        // 255 chars exactly: 249 'a' + '@' + 'b' + '.' + 'cc'
        var email = new string('a', 249) + "@b.cc";
        email.Length.Should().Be(255);

        var result = Email.Create(email);

        result.IsSuccess.Should().BeTrue();
    }

    [Fact]
    public void TwoEmails_WithSameValue_ShouldBeEqual()
    {
        var email1 = Email.Create("same@email.com").Value;
        var email2 = Email.Create("same@email.com").Value;

        email1.Should().Be(email2);
    }

    [Fact]
    public void TwoEmails_WithDifferentValue_ShouldNotBeEqual()
    {
        var email1 = Email.Create("a@email.com").Value;
        var email2 = Email.Create("b@email.com").Value;

        email1.Should().NotBe(email2);
    }
}
