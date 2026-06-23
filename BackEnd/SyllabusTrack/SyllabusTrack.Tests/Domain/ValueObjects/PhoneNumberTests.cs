using FluentAssertions;
using SyllabusTrack.Domain.ValueObjects;
using Xunit;

namespace SyllabusTrack.Tests.Domain.ValueObjects;

public sealed class PhoneNumberTests
{
    [Theory]
    [InlineData("11999990000")]
    [InlineData("+55 (11) 99999-0000")]
    [InlineData("(11) 9876-5432")]
    public void Create_WithValidPhone_ShouldSucceed(string phone)
    {
        var result = PhoneNumber.Create(phone);

        result.IsSuccess.Should().BeTrue();
        result.Value.Value.Should().Be(phone);
    }

    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    [InlineData(null!)]
    public void Create_WithEmptyPhone_ShouldFail(string? phone)
    {
        var result = PhoneNumber.Create(phone!);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("PhoneNumber.Empty");
    }

    [Fact]
    public void Create_WithPhoneExceedingMaxLength_ShouldFail()
    {
        var longPhone = new string('1', 21); // > 20 chars
        var result = PhoneNumber.Create(longPhone);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("PhoneNumber.TooLong");
    }

    [Fact]
    public void Create_WithPhoneAtMaxLength_ShouldSucceed()
    {
        var phone = new string('1', 20); // exactly 20 chars
        var result = PhoneNumber.Create(phone);

        result.IsSuccess.Should().BeTrue();
    }

    [Fact]
    public void TwoPhones_WithSameValue_ShouldBeEqual()
    {
        var p1 = PhoneNumber.Create("11999990000").Value;
        var p2 = PhoneNumber.Create("11999990000").Value;

        p1.Should().Be(p2);
    }

    [Fact]
    public void TwoPhones_WithDifferentValue_ShouldNotBeEqual()
    {
        var p1 = PhoneNumber.Create("11999990000").Value;
        var p2 = PhoneNumber.Create("11888880000").Value;

        p1.Should().NotBe(p2);
    }
}
