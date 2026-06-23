using System.Reflection;
using FluentAssertions;
using NetArchTest.Rules;
using SyllabusTrack.Domain.Primitives;
using Xunit;

namespace SyllabusTrack.ArchTests;

/// <summary>
/// Valida as regras DDD obrigatórias da camada Domain:
///  • Entidades herdam Entity ou AggregateRoot e são sealed
///  • Entidades não expõem setters públicos (encapsulamento)
///  • Value Objects herdam ValueObject e são sealed
///  • Interfaces de repositório residem em Domain.Repositories
///  • Domain não referencia EntityFrameworkCore
/// </summary>
public sealed class DomainRulesTests : ArchTestBase
{
    // ── Entidades: herança ────────────────────────────────────────────────────

    [Fact(DisplayName = "Entidades devem herdar Entity (ou AggregateRoot)")]
    public void Domain_Entities_MustInheritEntity()
    {
        var result = Types.InAssembly(DomainAssembly)
            .That().ResideInNamespace(DomainEntitiesNs)
            .Should().Inherit(typeof(Entity))
            .GetResult();

        result.IsSuccessful.Should().BeTrue(
            because: "toda entidade de domínio deve herdar Entity ou AggregateRoot. " +
                     FormatViolations(result));
    }

    // ── Entidades: sealed ─────────────────────────────────────────────────────

    [Fact(DisplayName = "Entidades devem ser sealed (sem herança externa)")]
    public void Domain_Entities_MustBeSealed()
    {
        var result = Types.InAssembly(DomainAssembly)
            .That().ResideInNamespace(DomainEntitiesNs)
            .Should().BeSealed()
            .GetResult();

        result.IsSuccessful.Should().BeTrue(
            because: "entidades concretas devem ser sealed para proteger invariantes. " +
                     FormatViolations(result));
    }

    // ── Entidades: setters privados ───────────────────────────────────────────

    [Fact(DisplayName = "Entidades não devem ter setters públicos")]
    public void Domain_Entities_MustNotHavePublicSetters()
    {
        var violations = DomainAssembly.GetTypes()
            .Where(t => t.Namespace?.StartsWith(DomainEntitiesNs) == true
                     && !t.IsAbstract
                     && !t.IsInterface)
            .SelectMany(t => t
                .GetProperties(BindingFlags.Public | BindingFlags.Instance | BindingFlags.DeclaredOnly)
                .Where(p => p.GetSetMethod(nonPublic: false) is { IsPublic: true })
                .Select(p => $"{t.Name}.{p.Name}"))
            .ToList();

        violations.Should().BeEmpty(
            because: "entidades de domínio devem ter apenas setters privados ou protected " +
                     "para garantir mutação controlada. Violações: " +
                     string.Join(", ", violations));
    }

    // ── Value Objects: herança ────────────────────────────────────────────────

    [Fact(DisplayName = "Value Objects devem herdar ValueObject")]
    public void Domain_ValueObjects_MustInheritValueObject()
    {
        var result = Types.InAssembly(DomainAssembly)
            .That().ResideInNamespace(DomainValueObjectsNs)
            .And().AreNotAbstract()
            .Should().Inherit(typeof(ValueObject))
            .GetResult();

        result.IsSuccessful.Should().BeTrue(
            because: "todo Value Object deve herdar ValueObject para garantir igualdade por valor. " +
                     FormatViolations(result));
    }

    // ── Value Objects: sealed ─────────────────────────────────────────────────

    [Fact(DisplayName = "Value Objects devem ser sealed")]
    public void Domain_ValueObjects_MustBeSealed()
    {
        var result = Types.InAssembly(DomainAssembly)
            .That().ResideInNamespace(DomainValueObjectsNs)
            .And().AreNotAbstract()
            .Should().BeSealed()
            .GetResult();

        result.IsSuccessful.Should().BeTrue(
            because: "Value Objects devem ser sealed para evitar herança que quebre a igualdade. " +
                     FormatViolations(result));
    }

    // ── Repositórios: devem ser interfaces ────────────────────────────────────

    [Fact(DisplayName = "Contratos de repositório devem ser interfaces")]
    public void Domain_Repositories_MustBeInterfaces()
    {
        var result = Types.InAssembly(DomainAssembly)
            .That().ResideInNamespace(DomainRepositoriesNs)
            .Should().BeInterfaces()
            .GetResult();

        result.IsSuccessful.Should().BeTrue(
            because: "Domain.Repositories deve conter apenas interfaces (contratos), " +
                     "nunca implementações concretas. " + FormatViolations(result));
    }

    [Fact(DisplayName = "Interfaces de repositório devem começar com 'I'")]
    public void Domain_Repositories_MustFollowInterfaceNamingConvention()
    {
        var violations = DomainAssembly.GetTypes()
            .Where(t => t.Namespace?.StartsWith(DomainRepositoriesNs) == true)
            .Where(t => !t.Name.StartsWith("I"))
            .Select(t => t.Name)
            .ToList();

        violations.Should().BeEmpty(
            because: "interfaces de repositório devem seguir a convenção 'IXxxRepository'. " +
                     "Violações: " + string.Join(", ", violations));
    }

    // ── Domain sem EF Core ────────────────────────────────────────────────────

    [Fact(DisplayName = "Domain não deve referenciar EntityFrameworkCore")]
    public void Domain_MustNotReferenceEntityFrameworkCore()
    {
        var result = Types.InAssembly(DomainAssembly)
            .ShouldNot()
            .HaveDependencyOn("Microsoft.EntityFrameworkCore")
            .GetResult();

        result.IsSuccessful.Should().BeTrue(
            because: "o Domain é agnóstico a persistência e não pode depender de EF Core. " +
                     FormatViolations(result));
    }

    // ── Helper ────────────────────────────────────────────────────────────────

    private static string FormatViolations(TestResult result) =>
        result.FailingTypes is { Count: > 0 }
            ? string.Join(", ", result.FailingTypes.Select(t => t.FullName ?? t.Name))
            : "nenhuma";
}
