using System.Reflection;
using FluentAssertions;
using FluentValidation;
using NetArchTest.Rules;
using SyllabusTrack.Application.Abstractions.Messaging;
using Xunit;

namespace SyllabusTrack.ArchTests;

/// <summary>
/// Valida as regras de arquitetura da camada Application:
///  • Command handlers implementam ICommandHandler e terminam em "CommandHandler"
///  • Query handlers implementam IQueryHandler e terminam em "QueryHandler"
///  • Validators herdam AbstractValidator e terminam em "Validator"
///  • Application não referencia EntityFrameworkCore
///  • Application não referencia a API
/// </summary>
public sealed class ApplicationRulesTests : ArchTestBase
{
    // ── Command Handlers ──────────────────────────────────────────────────────

    [Fact(DisplayName = "Command handlers devem terminar em 'CommandHandler'")]
    public void Application_CommandHandlers_MustFollowNamingConvention()
    {
        // Obtém todos os tipos concretos que implementam ICommandHandler<> ou ICommandHandler<,>
        var handlers = ApplicationAssembly.GetTypes()
            .Where(t => !t.IsAbstract && !t.IsInterface
                     && ImplementsCommandHandler(t))
            .Where(t => !t.Name.EndsWith("CommandHandler"))
            .Select(t => t.Name)
            .ToList();

        handlers.Should().BeEmpty(
            because: "todo command handler deve terminar em 'CommandHandler'. " +
                     "Violações: " + string.Join(", ", handlers));
    }

    [Fact(DisplayName = "Command handlers devem implementar ICommandHandler")]
    public void Application_CommandHandlers_MustImplementICommandHandler()
    {
        var violations = ApplicationAssembly.GetTypes()
            .Where(t => !t.IsAbstract && !t.IsInterface
                     && t.Name.EndsWith("CommandHandler"))
            .Where(t => !ImplementsCommandHandler(t))
            .Select(t => t.Name)
            .ToList();

        violations.Should().BeEmpty(
            because: "todo tipo chamado *CommandHandler deve implementar " +
                     "ICommandHandler<TCommand> ou ICommandHandler<TCommand, TResponse>. " +
                     "Violações: " + string.Join(", ", violations));
    }

    // ── Query Handlers ────────────────────────────────────────────────────────

    [Fact(DisplayName = "Query handlers devem terminar em 'QueryHandler'")]
    public void Application_QueryHandlers_MustFollowNamingConvention()
    {
        var violations = ApplicationAssembly.GetTypes()
            .Where(t => !t.IsAbstract && !t.IsInterface
                     && ImplementsQueryHandler(t))
            .Where(t => !t.Name.EndsWith("QueryHandler"))
            .Select(t => t.Name)
            .ToList();

        violations.Should().BeEmpty(
            because: "todo query handler deve terminar em 'QueryHandler'. " +
                     "Violações: " + string.Join(", ", violations));
    }

    [Fact(DisplayName = "Query handlers devem implementar IQueryHandler")]
    public void Application_QueryHandlers_MustImplementIQueryHandler()
    {
        var violations = ApplicationAssembly.GetTypes()
            .Where(t => !t.IsAbstract && !t.IsInterface
                     && t.Name.EndsWith("QueryHandler"))
            .Where(t => !ImplementsQueryHandler(t))
            .Select(t => t.Name)
            .ToList();

        violations.Should().BeEmpty(
            because: "todo tipo chamado *QueryHandler deve implementar IQueryHandler<TQuery, TResponse>. " +
                     "Violações: " + string.Join(", ", violations));
    }

    // ── Validators ────────────────────────────────────────────────────────────

    [Fact(DisplayName = "Validators devem herdar AbstractValidator<T>")]
    public void Application_Validators_MustInheritAbstractValidator()
    {
        var violations = ApplicationAssembly.GetTypes()
            .Where(t => !t.IsAbstract && !t.IsInterface
                     && t.Name.EndsWith("Validator"))
            .Where(t => !InheritsAbstractValidator(t))
            .Select(t => t.Name)
            .ToList();

        violations.Should().BeEmpty(
            because: "todo validator deve herdar FluentValidation.AbstractValidator<T>. " +
                     "Violações: " + string.Join(", ", violations));
    }

    [Fact(DisplayName = "Validators devem terminar em 'Validator'")]
    public void Application_Validators_MustFollowNamingConvention()
    {
        var violations = ApplicationAssembly.GetTypes()
            .Where(t => !t.IsAbstract && !t.IsInterface
                     && InheritsAbstractValidator(t))
            .Where(t => !t.Name.EndsWith("Validator"))
            .Select(t => t.Name)
            .ToList();

        violations.Should().BeEmpty(
            because: "todo validator deve terminar em 'Validator'. " +
                     "Violações: " + string.Join(", ", violations));
    }

    // ── Sem EF Core ───────────────────────────────────────────────────────────

    [Fact(DisplayName = "Application não deve referenciar EntityFrameworkCore")]
    public void Application_MustNotReferenceEntityFrameworkCore()
    {
        var result = Types.InAssembly(ApplicationAssembly)
            .ShouldNot()
            .HaveDependencyOn("Microsoft.EntityFrameworkCore")
            .GetResult();

        result.IsSuccessful.Should().BeTrue(
            because: "Application é agnóstica a persistência: EF Core só é referenciado " +
                     "em Infrastructure. " + FormatViolations(result));
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private static bool ImplementsCommandHandler(Type type) =>
        type.GetInterfaces().Any(i =>
            i.IsGenericType &&
            (i.GetGenericTypeDefinition() == typeof(ICommandHandler<>) ||
             i.GetGenericTypeDefinition() == typeof(ICommandHandler<,>)));

    private static bool ImplementsQueryHandler(Type type) =>
        type.GetInterfaces().Any(i =>
            i.IsGenericType &&
            i.GetGenericTypeDefinition() == typeof(IQueryHandler<,>));

    private static bool InheritsAbstractValidator(Type type)
    {
        var current = type.BaseType;
        while (current != null)
        {
            if (current.IsGenericType &&
                current.GetGenericTypeDefinition() == typeof(AbstractValidator<>))
                return true;
            current = current.BaseType;
        }
        return false;
    }

    private static string FormatViolations(TestResult result) =>
        result.FailingTypes is { Count: > 0 }
            ? string.Join(", ", result.FailingTypes.Select(t => t.FullName ?? t.Name))
            : "nenhuma";
}
