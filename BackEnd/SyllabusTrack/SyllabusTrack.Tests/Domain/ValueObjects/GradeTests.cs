using FluentAssertions;
using SyllabusTrack.Domain.ValueObjects;
using Xunit;

namespace SyllabusTrack.Tests.Domain.ValueObjects;

public sealed class GradeTests
{
    [Theory]
    [InlineData(0)]
    [InlineData(5)]
    [InlineData(7.5)]
    [InlineData(10)]
    public void Create_WithValidGrade_ShouldSucceed(decimal value)
    {
        var result = Grade.Create(value);

        result.IsSuccess.Should().BeTrue();
        result.Value.Value.Should().Be(value);
    }

    [Theory]
    [InlineData(-0.01)]
    [InlineData(-1)]
    [InlineData(10.01)]
    [InlineData(100)]
    public void Create_WithOutOfRangeGrade_ShouldFail(decimal value)
    {
        var result = Grade.Create(value);

        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("Grade.Invalid");
    }

    [Fact]
    public void TwoGrades_WithSameValue_ShouldBeEqual()
    {
        var grade1 = Grade.Create(7.5m).Value;
        var grade2 = Grade.Create(7.5m).Value;

        grade1.Should().Be(grade2);
    }

    [Fact]
    public void TwoGrades_WithDifferentValue_ShouldNotBeEqual()
    {
        var grade1 = Grade.Create(5m).Value;
        var grade2 = Grade.Create(8m).Value;

        grade1.Should().NotBe(grade2);
    }

    [Fact]
    public void Create_WithMinBoundary_ShouldSucceed()
    {
        var result = Grade.Create(0m);

        result.IsSuccess.Should().BeTrue();
        result.Value.Value.Should().Be(0m);
    }

    [Fact]
    public void Create_WithMaxBoundary_ShouldSucceed()
    {
        var result = Grade.Create(10m);

        result.IsSuccess.Should().BeTrue();
        result.Value.Value.Should().Be(10m);
    }
}
