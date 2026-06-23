using FluentAssertions;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using NetArchTest.Rules;
using Xunit;

namespace SyllabusTrack.ArchTests;

/// <summary>
/// Valida as regras de arquitetura da camada Infrastructure:
///  • Repositórios concretos terminam em "Repository" e são sealed
///  • Configurations terminam em "Configuration" e são sealed
///  • Persistence não expõe classes abstratas/parciais desnecessárias
/// </summary>
public sealed class InfrastructureRulesTests : ArchTestBase
{
    // ── Repositórios concretos ────────────────────────────────────────────────

    [Fact(DisplayName = "Repositórios concretos devem terminar em 'Repository'")]
    public void Infrastructure_Repositories_MustFollowNamingConvention()
    {
        var result = Types.InAssembly(InfrastructureAssembly)
            .That().ResideInNamespace(InfraReposNs)
            .Should().HaveNameEndingWith("Repository")
            .GetResult();

        result.IsSuccessful.Should().BeTrue(
            because: "implementações de repositório devem terminar em 'Repository'. " +
                     FormatViolations(result));
    }

    [Fact(DisplayName = "Repositórios concretos devem ser sealed")]
    public void Infrastructure_Repositories_MustBeSealed()
    {
        var result = Types.InAssembly(InfrastructureAssembly)
            .That().ResideInNamespace(InfraReposNs)
            .And().AreNotAbstract()
            .Should().BeSealed()
            .GetResult();

        result.IsSuccessful.Should().BeTrue(
            because: "repositórios concretos devem ser sealed para evitar herança acidental. " +
                     FormatViolations(result));
    }

    // ── Entity Configurations ─────────────────────────────────────────────────

    [Fact(DisplayName = "Entity configurations devem terminar em 'Configuration'")]
    public void Infrastructure_Configurations_MustFollowNamingConvention()
    {
        var result = Types.InAssembly(InfrastructureAssembly)
            .That().ResideInNamespace(InfraConfigurationsNs)
            .Should().HaveNameEndingWith("Configuration")
            .GetResult();

        result.IsSuccessful.Should().BeTrue(
            because: "configurations do EF Core devem terminar em 'Configuration'. " +
                     FormatViolations(result));
    }

    [Fact(DisplayName = "Entity configurations devem ser sealed")]
    public void Infrastructure_Configurations_MustBeSealed()
    {
        var result = Types.InAssembly(InfrastructureAssembly)
            .That().ResideInNamespace(InfraConfigurationsNs)
            .And().AreNotAbstract()
            .Should().BeSealed()
            .GetResult();

        result.IsSuccessful.Should().BeTrue(
            because: "entity configurations devem ser sealed. " + FormatViolations(result));
    }

    [Fact(DisplayName = "Entity configurations devem implementar IEntityTypeConfiguration<T>")]
    public void Infrastructure_Configurations_MustImplementIEntityTypeConfiguration()
    {
        var violations = InfrastructureAssembly.GetTypes()
            .Where(t => t.Namespace?.StartsWith(InfraConfigurationsNs) == true
                     && !t.IsAbstract && !t.IsInterface)
            .Where(t => !t.GetInterfaces().Any(i =>
                i.IsGenericType &&
                i.GetGenericTypeDefinition() == typeof(IEntityTypeConfiguration<>)))
            .Select(t => t.Name)
            .ToList();

        violations.Should().BeEmpty(
            because: "toda classe em Persistence.Configurations deve implementar " +
                     "IEntityTypeConfiguration<TEntity>. " +
                     "Violações: " + string.Join(", ", violations));
    }

    // ── Helper ────────────────────────────────────────────────────────────────

    private static string FormatViolations(TestResult result) =>
        result.FailingTypes is { Count: > 0 }
            ? string.Join(", ", result.FailingTypes.Select(t => t.FullName ?? t.Name))
            : "nenhuma";
}
