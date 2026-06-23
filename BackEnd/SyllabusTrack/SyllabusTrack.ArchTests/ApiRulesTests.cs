using FluentAssertions;
using Microsoft.AspNetCore.Mvc;
using NetArchTest.Rules;
using SyllabusTrack.API.Controllers;
using Xunit;

namespace SyllabusTrack.ArchTests;

/// <summary>
/// Valida as regras de arquitetura da camada API:
///  • Controllers terminam em "Controller" e residem em SyllabusTrack.API.Controllers
///  • Controllers concretos herdam ApiController (base abstrata interna)
///  • Controllers possuem o atributo [ApiController]
///  • Middleware termina em "Middleware"
/// </summary>
public sealed class ApiRulesTests : ArchTestBase
{
    // ── Controllers: naming e namespace ───────────────────────────────────────

    [Fact(DisplayName = "Controllers devem residir em SyllabusTrack.API.Controllers")]
    public void Api_Controllers_MustResideInControllersNamespace()
    {
        // Toda classe que herda ControllerBase deve estar no namespace correto
        var violations = ApiAssembly.GetTypes()
            .Where(t => !t.IsAbstract && !t.IsInterface
                     && InheritsType(t, typeof(ControllerBase)))
            .Where(t => t.Namespace != ApiControllersNs)
            .Select(t => $"{t.Name} (namespace atual: {t.Namespace})")
            .ToList();

        violations.Should().BeEmpty(
            because: "controllers devem residir em SyllabusTrack.API.Controllers. " +
                     "Violações: " + string.Join(", ", violations));
    }

    [Fact(DisplayName = "Controllers devem terminar em 'Controller'")]
    public void Api_Controllers_MustFollowNamingConvention()
    {
        // Filtra apenas tipos que herdam ControllerBase (controllers reais),
        // excluindo DTOs e records de request que residem no mesmo namespace.
        var violations = ApiAssembly.GetTypes()
            .Where(t => !t.IsAbstract && !t.IsInterface
                     && t.Namespace == ApiControllersNs
                     && InheritsType(t, typeof(ControllerBase)))
            .Where(t => !t.Name.EndsWith("Controller"))
            .Select(t => t.Name)
            .ToList();

        violations.Should().BeEmpty(
            because: "controllers devem terminar em 'Controller'. " +
                     "Violações: " + string.Join(", ", violations));
    }

    // ── Controllers: herança da base ──────────────────────────────────────────

    [Fact(DisplayName = "Controllers concretos devem herdar ApiController (base interna)")]
    public void Api_Controllers_MustInheritApiController()
    {
        // Filtra apenas tipos que herdam ControllerBase (controllers reais),
        // excluindo DTOs e records de request que residem no mesmo namespace.
        var violations = ApiAssembly.GetTypes()
            .Where(t => !t.IsAbstract && !t.IsInterface
                     && t.Namespace == ApiControllersNs
                     && InheritsType(t, typeof(ControllerBase)))
            .Where(t => !InheritsType(t, typeof(ApiController)))
            .Select(t => t.Name)
            .ToList();

        violations.Should().BeEmpty(
            because: "todo controller concreto deve herdar ApiController para " +
                     "centralizar tratamento de erros e padrão Result. " +
                     "Violações: " + string.Join(", ", violations));
    }

    // ── Controllers: atributo [ApiController] ─────────────────────────────────

    [Fact(DisplayName = "Controllers concretos devem ter o atributo [ApiController]")]
    public void Api_Controllers_MustHaveApiControllerAttribute()
    {
        // O atributo é herdado de ApiController via [ApiController] declarado lá,
        // mas validamos explicitamente que nenhum controller remove/ignora isso.
        var violations = ApiAssembly.GetTypes()
            .Where(t => !t.IsAbstract && !t.IsInterface
                     && t.Namespace == ApiControllersNs
                     && t.Name.EndsWith("Controller"))
            .Where(t => !HasApiControllerAttribute(t))
            .Select(t => t.Name)
            .ToList();

        violations.Should().BeEmpty(
            because: "controllers devem ser decorados com [ApiController] (diretamente " +
                     "ou via herança da base). Violações: " + string.Join(", ", violations));
    }

    // ── Middleware ────────────────────────────────────────────────────────────

    [Fact(DisplayName = "Classes de middleware devem terminar em 'Middleware'")]
    public void Api_Middleware_MustFollowNamingConvention()
    {
        // Identifica middleware pelo método Invoke/InvokeAsync que recebe HttpContext
        var violations = ApiAssembly.GetTypes()
            .Where(t => !t.IsAbstract && !t.IsInterface
                     && HasMiddlewareInvokeSignature(t))
            .Where(t => !t.Name.EndsWith("Middleware"))
            .Select(t => t.Name)
            .ToList();

        violations.Should().BeEmpty(
            because: "classes de middleware devem terminar em 'Middleware'. " +
                     "Violações: " + string.Join(", ", violations));
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    /// <summary>Verifica se <paramref name="type"/> herda <paramref name="baseType"/> em qualquer nível.</summary>
    private static bool InheritsType(Type type, Type baseType)
    {
        var current = type.BaseType;
        while (current != null)
        {
            if (current == baseType) return true;
            current = current.BaseType;
        }
        return false;
    }

    private static bool HasApiControllerAttribute(Type type) =>
        type.GetCustomAttributes(inherit: true)
            .Any(a => a.GetType() == typeof(ApiControllerAttribute));

    private static bool HasMiddlewareInvokeSignature(Type type) =>
        type.GetMethod("Invoke") != null || type.GetMethod("InvokeAsync") != null;

    private static string FormatViolations(TestResult result) =>
        result.FailingTypes is { Count: > 0 }
            ? string.Join(", ", result.FailingTypes.Select(t => t.FullName ?? t.Name))
            : "nenhuma";
}
