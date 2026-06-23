using FluentAssertions;
using SyllabusTrack.Domain.Shared;
using Xunit;

namespace SyllabusTrack.Tests.Domain.Shared;

public sealed class ResultTests
{
    // ── Result (non-generic) ──────────────────────────────────────────────────

    [Fact]
    public void Success_ShouldBeSuccessful()
    {
        var result = Result.Success();

        result.IsSuccess.Should().BeTrue();
        result.IsFailure.Should().BeFalse();
        result.Error.Should().Be(Error.None);
    }

    [Fact]
    public void Failure_ShouldNotBeSuccessful()
    {
        var error = new Error("Test.Error", "Test message");
        var result = Result.Failure(error);

        result.IsSuccess.Should().BeFalse();
        result.IsFailure.Should().BeTrue();
        result.Error.Should().Be(error);
    }

    [Fact]
    public void Constructor_WhenSuccessWithNonNoneError_ShouldThrow()
    {
        var action = () => new ConcreteResult(true, new Error("X", "Y"));
        action.Should().Throw<InvalidOperationException>();
    }

    [Fact]
    public void Constructor_WhenFailureWithNoneError_ShouldThrow()
    {
        var action = () => new ConcreteResult(false, Error.None);
        action.Should().Throw<InvalidOperationException>();
    }

    // ── Result<TValue> ────────────────────────────────────────────────────────

    [Fact]
    public void SuccessGeneric_ShouldExposeValue()
    {
        var result = Result.Success(42);

        result.IsSuccess.Should().BeTrue();
        result.Value.Should().Be(42);
    }

    [Fact]
    public void FailureGeneric_ShouldNotExposeValue()
    {
        var error = new Error("Test.Error", "Test message");
        var result = Result.Failure<int>(error);

        result.IsFailure.Should().BeTrue();
        result.Error.Should().Be(error);
        var access = () => result.Value;
        access.Should().Throw<InvalidOperationException>();
    }

    [Fact]
    public void SuccessGeneric_WithReferenceType_ShouldExposeValue()
    {
        var result = Result.Success("hello");

        result.IsSuccess.Should().BeTrue();
        result.Value.Should().Be("hello");
    }

    // Helper to access protected constructor
    private sealed class ConcreteResult : Result
    {
        public ConcreteResult(bool isSuccess, Error error) : base(isSuccess, error) { }
    }
}
