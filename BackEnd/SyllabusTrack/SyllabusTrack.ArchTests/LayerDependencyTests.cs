using FluentAssertions;
using NetArchTest.Rules;
using Xunit;

namespace SyllabusTrack.ArchTests;

/// <summary>
/// Valida o isolamento entre camadas da Clean Architecture / DDD.
///
/// Hierarquia obrigatória:
///   Domain ← Application ← Infrastructure
///                       ← API (via Infrastructure)
///
/// Violações detectadas aqui significam acoplamento invertido (dependência
/// para "cima" na hierarquia), que quebra o princípio de inversão de dependências.
/// </summary>
public sealed class LayerDependencyTests : ArchTestBase
{
    // ── Domain ────────────────────────────────────────────────────────────────

    [Fact(DisplayName = "Domain não deve depender de Application")]
    public void Domain_ShouldNot_DependOn_Application()
    {
        var result = Types.InAssembly(DomainAssembly)
            .ShouldNot()
            .HaveDependencyOn(ApplicationNs)
            .GetResult();

        result.IsSuccessful.Should().BeTrue(
            because: $"o Domain não pode referenciar Application. Violações: " +
                     FormatViolations(result));
    }

    [Fact(DisplayName = "Domain não deve depender de Infrastructure")]
    public void Domain_ShouldNot_DependOn_Infrastructure()
    {
        var result = Types.InAssembly(DomainAssembly)
            .ShouldNot()
            .HaveDependencyOn(InfrastructureNs)
            .GetResult();

        result.IsSuccessful.Should().BeTrue(
            because: $"o Domain não pode referenciar Infrastructure. Violações: " +
                     FormatViolations(result));
    }

    [Fact(DisplayName = "Domain não deve depender de API")]
    public void Domain_ShouldNot_DependOn_Api()
    {
        var result = Types.InAssembly(DomainAssembly)
            .ShouldNot()
            .HaveDependencyOn(ApiNs)
            .GetResult();

        result.IsSuccessful.Should().BeTrue(
            because: $"o Domain não pode referenciar a API. Violações: " +
                     FormatViolations(result));
    }

    // ── Application ───────────────────────────────────────────────────────────

    [Fact(DisplayName = "Application não deve depender de Infrastructure")]
    public void Application_ShouldNot_DependOn_Infrastructure()
    {
        var result = Types.InAssembly(ApplicationAssembly)
            .ShouldNot()
            .HaveDependencyOn(InfrastructureNs)
            .GetResult();

        result.IsSuccessful.Should().BeTrue(
            because: "Application não pode referenciar Infrastructure — a inversão " +
                     "é feita via interfaces injetadas. Violações: " +
                     FormatViolations(result));
    }

    [Fact(DisplayName = "Application não deve depender de API")]
    public void Application_ShouldNot_DependOn_Api()
    {
        var result = Types.InAssembly(ApplicationAssembly)
            .ShouldNot()
            .HaveDependencyOn(ApiNs)
            .GetResult();

        result.IsSuccessful.Should().BeTrue(
            because: $"Application não pode referenciar a API. Violações: " +
                     FormatViolations(result));
    }

    // ── Infrastructure ────────────────────────────────────────────────────────

    [Fact(DisplayName = "Infrastructure não deve depender de API")]
    public void Infrastructure_ShouldNot_DependOn_Api()
    {
        var result = Types.InAssembly(InfrastructureAssembly)
            .ShouldNot()
            .HaveDependencyOn(ApiNs)
            .GetResult();

        result.IsSuccessful.Should().BeTrue(
            because: $"Infrastructure não pode referenciar a API. Violações: " +
                     FormatViolations(result));
    }

    // ── Helper ────────────────────────────────────────────────────────────────

    private static string FormatViolations(TestResult result) =>
        result.FailingTypes is { Count: > 0 }
            ? string.Join(", ", result.FailingTypes.Select(t => t.FullName))
            : "nenhuma";
}
