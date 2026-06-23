using System.Reflection;

namespace SyllabusTrack.ArchTests;

/// <summary>
/// Classe base com referências de assembly e constantes de namespace
/// compartilhadas por todos os testes de arquitetura.
/// </summary>
public abstract class ArchTestBase
{
    // ── Assembly anchors ──────────────────────────────────────────────────────

    /// <summary>Domain — âncora: Entity (primitiva base de todas as entidades)</summary>
    protected static readonly Assembly DomainAssembly =
        typeof(SyllabusTrack.Domain.Primitives.Entity).Assembly;

    /// <summary>Application — âncora: DependencyInjection (ponto de entrada público)</summary>
    protected static readonly Assembly ApplicationAssembly =
        typeof(SyllabusTrack.Application.DependencyInjection).Assembly;

    /// <summary>Infrastructure — âncora: DependencyInjection (extensão de IServiceCollection)</summary>
    protected static readonly Assembly InfrastructureAssembly =
        typeof(SyllabusTrack.Infrastructure.DependencyInjection).Assembly;

    /// <summary>API — âncora: ApiController (base abstrata de todos os controllers)</summary>
    protected static readonly Assembly ApiAssembly =
        typeof(SyllabusTrack.API.Controllers.ApiController).Assembly;

    // ── Namespace root constants ───────────────────────────────────────────────
    protected const string DomainNs         = "SyllabusTrack.Domain";
    protected const string ApplicationNs    = "SyllabusTrack.Application";
    protected const string InfrastructureNs = "SyllabusTrack.Infrastructure";
    protected const string ApiNs            = "SyllabusTrack.API";

    // ── Namespace leaf constants ───────────────────────────────────────────────
    protected const string DomainEntitiesNs       = "SyllabusTrack.Domain.Entities";
    protected const string DomainValueObjectsNs   = "SyllabusTrack.Domain.ValueObjects";
    protected const string DomainRepositoriesNs   = "SyllabusTrack.Domain.Repositories";
    protected const string InfraReposNs           = "SyllabusTrack.Infrastructure.Persistence.Repositories";
    protected const string InfraConfigurationsNs  = "SyllabusTrack.Infrastructure.Persistence.Configurations";
    protected const string ApiControllersNs       = "SyllabusTrack.API.Controllers";
}
