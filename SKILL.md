# SyllabusTrack — Padrões de Arquitetura e Desenvolvimento

## Propósito

Você é um arquiteto fullstack especialista neste projeto. Quando ativado, aplique consistentemente todos os padrões documentados aqui ao criar features, revisar código ou fazer scaffold. **Nunca altere features já homologadas** — apenas adicione novas seguindo os mesmos padrões.

---

## Stack Tecnológico

| Camada | Tecnologia |
|---|---|
| Runtime | .NET 9 / C# 13 |
| Web API | ASP.NET Core Web API |
| ORM | EF Core 9 (SQL Server) |
| Mensageria | MediatR 12 |
| Validação | FluentValidation 11 |
| Auth | JWT Bearer + BCrypt (workFactor 12) |
| Testes unitários | xUnit + FluentAssertions + NSubstitute |
| Testes BDD | Reqnroll (Gherkin) + Moq |
| Testes arquitetura | NetArchTest.Rules 1.3.2 |
| Frontend | React 19, TypeScript, Vite, Tailwind CSS |
| Estado servidor | TanStack React Query 5 |
| Estado cliente | Zustand 5 (auth) |
| Formulários | React Hook Form + Zod |
| HTTP Client | Axios (singleton com interceptors JWT) |
| Roteamento | React Router DOM 7 |

---

## 1. Estrutura da Solução

```
SyllabusTrack/
├── Sql/
│   ├── MasterScript.sql              # DDL completo
│   ├── SeedData.sql                  # UnirG Medicina + 19 cursos FAM EAD
│   ├── Seed_FAM_Psicologia_Farmacia.sql
│   ├── Seed_RodrigoMadeira.sql
│   └── Cleanup_All.sql
├── FrontEnd/
│   └── src/
│       ├── core/
│       │   ├── api/client.ts         # Axios singleton
│       │   ├── auth/authStore.ts     # Zustand
│       │   └── router/AppRouter.tsx
│       ├── features/                 # Feature-folder pattern
│       │   ├── auth/
│       │   ├── dashboard/
│       │   ├── curriculum/
│       │   ├── progress/
│       │   ├── recommendations/
│       │   ├── comparison/
│       │   ├── planning/
│       │   ├── multipleplanning/
│       │   └── multipletargetsplanning/
│       └── shared/components/        # NavBar, Layout
└── BackEnd/
    └── SyllabusTrack/
        ├── SyllabusTrack.Domain
        ├── SyllabusTrack.Application
        ├── SyllabusTrack.Infrastructure
        ├── SyllabusTrack.API
        ├── SyllabusTrack.Tests         # 126 testes unitários
        ├── SyllabusTrack.Specs         # 52 specs BDD / Gherkin
        └── SyllabusTrack.ArchTests     # 31 testes de arquitetura (NetArchTest)
```

**Regra de dependência (Clean Architecture):**
```
API → Application → Domain
Infrastructure implementa interfaces do Domain
```
Domain: **zero** dependências externas.

---

## 2. Banco de Dados

### 2.1 Esquema

```
EducationalInstitution   (InstitutionId PK)
  └── DegreeProgram      (ProgramId PK, InstitutionId FK)
        └── AcademicTerm (TermId PK, ProgramId FK)
              └── CourseModule    (ModuleId PK, TermId FK)
                    └── AcademicSubject     (SubjectId PK, ModuleId FK)
                          └── SubjectPrerequisite

StudentAccount           (StudentId PK)
  └── StudentEnrollment  (EnrollmentId PK, StudentId FK, ProgramId FK)
        └── StudentProgress (ProgressId PK, EnrollmentId FK, SubjectId FK)
```

**Campos universais:** `IsActive BIT DEFAULT 1`, `CreatedAt DATETIME`, `UpdatedAt DATETIME`.

**Soft delete:** nunca `DELETE` físico — sempre `UPDATE IsActive = 0`.

### 2.2 Entidades C# × Banco

| Entidade C# | Tipo |
|---|---|
| `EducationalInstitution` | `AggregateRoot` |
| `DegreeProgram` | `AggregateRoot` |
| `AcademicSubject` | `Entity` |
| `StudentAccount` | `AggregateRoot` |
| `StudentEnrollment` | `AggregateRoot` |
| `StudentProgress` | `Entity` |

> **`AcademicTerm` e `CourseModule` NÃO têm entidade C#.** São gerenciados via SQL/seed. `AcademicSubject` referencia `ModuleId` como `int` simples, sem navegação EF.

### 2.3 CompletionStatus válidos

`'Pending'` | `'InProgress'` | `'Completed'` | `'Failed'`

### 2.4 EnrollmentStatus válido

`'Active'`

---

## 3. Domain Layer

### 3.1 Classes Base

```csharp
// Entity
public abstract class Entity : IEquatable<Entity>
{
    public int Id { get; protected set; }
    protected Entity(int id) => Id = id;
}

// AggregateRoot
public abstract class AggregateRoot : Entity
{
    private readonly List<IDomainEvent> _domainEvents = [];
    protected void RaiseDomainEvent(IDomainEvent e) => _domainEvents.Add(e);
}

// ValueObject
public abstract class ValueObject : IEquatable<ValueObject>
{
    public abstract IEnumerable<object> GetAtomicValues();
}
```

### 3.2 Padrão de Entidade

```csharp
public sealed class EducationalInstitution : AggregateRoot
{
    public string InstitutionName { get; private set; } = null!;
    public bool IsActive { get; private set; }

    private EducationalInstitution() : base(0) { }  // EF Core — OBRIGATÓRIO

    private EducationalInstitution(string name, ...) : base(0)
    {
        InstitutionName = name;
        IsActive = true;
    }

    public static Result<EducationalInstitution> Create(string name, ...)
    {
        if (string.IsNullOrWhiteSpace(name))
            return Result.Failure<EducationalInstitution>(
                new Error("Institution.EmptyName", "Institution name is required."));
        return Result.Success(new EducationalInstitution(name, ...));
    }

    public Result UpdateDetails(string name, ...) { ... }
    public void Deactivate() => IsActive = false;
}
```

**Regras fixas:**
- Classe `sealed`.
- Propriedades com `private set` — **nunca** `public set`.
- Strings não anuláveis com `= null!` (resolve CS8618 do EF Core).
- Construtor `private` vazio para EF Core com `base(0)`.
- Construtor `private` com parâmetros.
- Factory `static Result<T> Create(...)`.
- Método `UpdateDetails(...)` retorna `Result`.
- Método `Deactivate()` para soft delete.

### 3.3 Result Pattern

```csharp
// Sucesso
Result.Success()
Result.Success<T>(value)

// Falha
Result.Failure(new Error("Code", "Message"))
Result.Failure<T>(new Error("Code", "Message"))

// Verificação
if (result.IsFailure)
    return Result.Failure<int>(result.Error);
```

**Nunca lance exceções para erros de negócio dentro de handlers.**

### 3.4 Value Objects existentes

| VO | Regras |
|---|---|
| `Email` | não vazio, contém `@`, `@` não pode ser na posição 0 ou última, máx 255 chars |
| `Grade` | `decimal` entre 0.00 e 10.00 |
| `PhoneNumber` | validação básica |

---

## 4. Application Layer — CQRS

### 4.1 Interfaces de Messaging

```csharp
public interface ICommand : IRequest<Result> { }
public interface ICommand<TResponse> : IRequest<Result<TResponse>> { }
public interface ICommandHandler<TCommand> : IRequestHandler<TCommand, Result>
    where TCommand : ICommand { }
public interface ICommandHandler<TCommand, TResponse> : IRequestHandler<TCommand, Result<TResponse>>
    where TCommand : ICommand<TResponse> { }
public interface IQuery<TResponse> : IRequest<Result<TResponse>> { }
public interface IQueryHandler<TQuery, TResponse> : IRequestHandler<TQuery, Result<TResponse>>
    where TQuery : IQuery<TResponse> { }
```

> **SEMPRE** adicionar `using SyllabusTrack.Application.Abstractions.Messaging;` em todo arquivo de Command/Query. Sem ele, `ICommand` e `IQuery` não são resolvidos.

### 4.2 Estrutura por Feature (CRUD padrão)

```
Application/Features/{Aggregate}/
  Create/
    CreateXxxCommand.cs          ← sealed record : ICommand<int>
    CreateXxxCommandHandler.cs   ← internal sealed class : ICommandHandler<Cmd, int>
    CreateXxxCommandValidator.cs ← sealed class : AbstractValidator<Cmd>
  Update/
    UpdateXxxCommand.cs          ← sealed record : ICommand
    UpdateXxxCommandHandler.cs
    UpdateXxxCommandValidator.cs
  GetAll/
    GetAllXxxQuery.cs            ← sealed record : IQuery<IReadOnlyCollection<XxxResponse>>
    GetAllXxxQueryHandler.cs
  GetById/
    GetXxxByIdQuery.cs           ← sealed record : IQuery<XxxResponse>
    GetXxxByIdQueryHandler.cs
  XxxResponse.cs                 ← sealed record (DTO de leitura)
```

**Regra:** handlers são `internal sealed class` (não expostos fora da camada Application).

### 4.3 Features de Análise (sem entidade EF)

Para `CourseComparison`, `AcademicPlanning`, `MultiplePlanning`, `MultipleTargetsPlanning`:

```
Application/Features/{Feature}/
  {Feature}Request.cs            ← sealed record (DTO de entrada — body do POST)
  {Feature}Response.cs           ← sealed record (DTO de saída)
  Get{Feature}Query.cs           ← sealed record : IQuery<{Feature}Response>
  Get{Feature}QueryHandler.cs    ← internal sealed class : IQueryHandler<Query, Response>
  I{Feature}Repository.cs        ← interface com método GetXxxAsync(...)
```

### 4.4 FluentValidation

```csharp
public sealed class CreateInstitutionCommandValidator : AbstractValidator<CreateInstitutionCommand>
{
    public CreateInstitutionCommandValidator()
    {
        RuleFor(x => x.Name).NotEmpty().MaximumLength(255);
        RuleFor(x => x.Acronym).MaximumLength(50);
    }
}
```

**Regra:** validações de formato/tamanho → FluentValidation. Regras de negócio complexas → entity factory ou handler.

---

## 5. Infrastructure Layer

### 5.1 EF Core — Regra de Tracking

```
❌ AsNoTracking()  →  NUNCA em métodos chamados para UPDATE
✅ AsNoTracking()  →  SEMPRE em consultas puras (leitura)
```

### 5.2 EF Core — Configurações

```csharp
// Value Object simples
builder.Property(s => s.EmailAddress)
    .HasConversion(
        email => email.Value,
        value => Email.Create(value).Value);

// Value Object nullable
builder.Property(p => p.FinalGrade)
    .HasConversion(
        grade => grade != null ? (decimal?)grade.Value : null,
        value => value.HasValue ? Grade.Create(value.Value).Value : null);

// Coleção privada
builder.HasMany(e => e.Progresses)
    .WithOne().HasForeignKey(p => p.EnrollmentId)
    .OnDelete(DeleteBehavior.Cascade);
builder.Navigation(e => e.Progresses)
    .UsePropertyAccessMode(PropertyAccessMode.Field);

// FK entre aggregates → sempre Restrict
builder.HasOne<EducationalInstitution>()
    .WithMany().HasForeignKey(p => p.InstitutionId)
    .OnDelete(DeleteBehavior.Restrict);
```

**Regras de configuração:**
- Toda configuration é `sealed` e implementa `IEntityTypeConfiguration<TEntity>`.
- Reside em `SyllabusTrack.Infrastructure.Persistence.Configurations`.
- Termina com "Configuration" (ex: `EducationalInstitutionConfiguration`).

### 5.3 SqlQuery\<T\> — Repositórios de Análise

Repositórios de planejamento/comparação usam `dbContext.Database.SqlQuery<TRow>($"...")` com strings interpoladas (EF Core parametriza automaticamente — seguro contra SQL injection).

**CRÍTICO — EF Core 9:** `SqlQuery<T>` envolve o SQL em uma subquery. SQL Server **rejeita `ORDER BY`** dentro de subqueries sem `TOP`/`OFFSET`. **Nunca use `ORDER BY` dentro de `SqlQuery<T>`**. Ordene sempre em C# após `ToListAsync()`.

```csharp
// ✅ CORRETO
private sealed record SubjectRow(string SubjectName, int Hours, int TermNumber);

var rows = await dbContext.Database
    .SqlQuery<SubjectRow>($"""
        SELECT s.SubjectName, s.TotalSubjectHours AS Hours, t.TermNumber
        FROM   AcademicTerm t
        JOIN   CourseModule m ON m.TermId = t.TermId
        JOIN   AcademicSubject s ON s.ModuleId = m.ModuleId
        WHERE  t.ProgramId = {programId}
          AND  s.IsActive = 1
          AND  s.TotalSubjectHours > 0
        """)
    .ToListAsync(ct);

// Ordenação em C# — nunca no SQL
var ordered = rows.GroupBy(r => r.TermNumber).OrderBy(g => g.Key);

// ❌ ERRADO — causa HTTP 500
// ORDER BY t.TermNumber  ← dentro do SqlQuery
```

### 5.4 Padrão HashSet para UNION de Disciplinas (Planejamento Múltiplo)

```csharp
// NUNCA construa IN (1,2,3) via interpolação de lista — use uma query por ID
var unionNames = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

foreach (var srcId in sourceProgramIds)
{
    var names = await dbContext.Database
        .SqlQuery<SubjectNameRow>($"""
            SELECT DISTINCT LOWER(LTRIM(RTRIM(s.SubjectName))) AS SubjectName
            FROM   AcademicTerm t
            JOIN   CourseModule m  ON m.TermId   = t.TermId
            JOIN   AcademicSubject s ON s.ModuleId = m.ModuleId
            WHERE  t.ProgramId = {srcId}
              AND  s.IsActive = 1
              AND  s.TotalSubjectHours > 0
            """)
        .ToListAsync(ct);

    foreach (var n in names)
        unionNames.Add(n.SubjectName);
}
```

### 5.5 Regras de Repositório Concreto

- Classe `sealed` e termina com "Repository".
- Reside em `SyllabusTrack.Infrastructure.Persistence.Repositories`.
- Nested types internos (ex: `private record ProgramInfoRow`) são aceitáveis para mapeamento de SQL.

### 5.6 DependencyInjection.cs — Registro de Repositórios

```csharp
services.AddScoped<IEducationalInstitutionRepository, EducationalInstitutionRepository>();
services.AddScoped<ICourseComparisonRepository, CourseComparisonRepository>();
services.AddScoped<IAcademicPlanningRepository, AcademicPlanningRepository>();
services.AddScoped<IMultiplePlanningRepository, MultiplePlanningRepository>();
services.AddScoped<IMultipleTargetsPlanningRepository, MultipleTargetsPlanningRepository>();
```

---

## 6. API Layer

### 6.1 ApiController Base

```csharp
[ApiController]
[Route("api/[controller]")]
[Produces("application/json")]
public abstract class ApiController : ControllerBase
{
    protected IActionResult HandleResult(Result result)
        => result.IsSuccess ? NoContent() : BadRequest(ProblemFrom(result.Error));

    protected IActionResult HandleResult<T>(Result<T> result)
        => result.IsSuccess ? Ok(result.Value) : BadRequest(ProblemFrom(result.Error));
}
```

### 6.2 Padrão de Controller

```csharp
[Authorize]
public sealed class ProgramsController(ISender sender) : ApiController
{
    [HttpGet]
    public async Task<IActionResult> GetAll(CancellationToken ct)
        => HandleResult(await sender.Send(new GetAllProgramsQuery(), ct));

    [HttpGet("{id:int}", Name = "GetProgramById")]
    public async Task<IActionResult> GetById(int id, CancellationToken ct)
    {
        var result = await sender.Send(new GetProgramByIdQuery(id), ct);
        if (result.IsFailure)
            return NotFound(new ProblemDetails { Detail = result.Error.Message,
                Extensions = { ["code"] = result.Error.Code } });
        return Ok(result.Value);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateProgramCommand command, CancellationToken ct)
    {
        var result = await sender.Send(command, ct);
        if (result.IsFailure) return BadRequest(...);
        return CreatedAtRoute("GetProgramById", new { id = result.Value }, new { programId = result.Value });
    }
}

// Request body separado do Command quando há parâmetro de rota
public sealed record UpdateProgramRequest(string ProgramName, string CurriculumVersion, int TotalSemesters);
```

**Regras:**
- Classe `sealed`, herda `ApiController`, tem `[Authorize]` (exceto `AuthController`).
- Termina com "Controller" e reside em `SyllabusTrack.API.Controllers`.
- Todo `HttpGet("{id:int}")` deve ter `Name = "GetXxxById"` para `CreatedAtRoute` funcionar.
- DTOs de request (`XxxRequest`) são records separados — **não são controllers** mesmo que residam no mesmo namespace.

---

## 7. Camadas de Teste

### 7.1 SyllabusTrack.Tests — Testes Unitários (126 testes)

xUnit + FluentAssertions + NSubstitute. Cobre Domain (entidades, Value Objects, Result) e Application (handlers, validators).

### 7.2 SyllabusTrack.Specs — BDD / Gherkin (52 specs)

Reqnroll + Moq. Features `.feature` com step definitions em `StepDefinitions/`. Cada feature tem sua pasta isolada.

**Regras críticas de Reqnroll:**
- Parênteses em step patterns devem ser escapados: `\\(texto\\)` (Cucumber Expression trata `(texto)` como opcional).
- Remover step bindings duplicados entre classes — um step pattern só pode ter um binding em todo o projeto.
- Steps que checam `ctx.ComparisonResult` e `ctx.AcademicPlanResult` devem ter guard null: checar qual contexto está preenchido.

### 7.3 SyllabusTrack.ArchTests — Testes de Arquitetura (31 testes)

NetArchTest.Rules 1.3.2. Verifica automaticamente as fronteiras DDD. Qualquer violação quebra o CI.

```
ArchTestBase.cs               ← assembly anchors e constantes de namespace
LayerDependencyTests.cs       ← 6 testes — isolamento de camadas
DomainRulesTests.cs           ← 7 testes — regras DDD do Domain
ApplicationRulesTests.cs      ← 6 testes — CQRS e validators
InfrastructureRulesTests.cs   ← 5 testes — repositórios e configurations
ApiRulesTests.cs              ← 7 testes — controllers e middleware
```

**Regras de varredura de tipos:**
- Excluir tipos aninhados: `t.DeclaringType == null`.
- Excluir tipos gerados pelo compilador: `!t.Name.StartsWith("<")`.
- Filtrar controllers por herança de `ControllerBase`, não por namespace.

**Fronteiras verificadas:**
```
Domain        → não depende de Application / Infrastructure / API
Application   → não depende de Infrastructure / API / EF Core
Domain        → não depende de EF Core
Entidades     → sealed, setters private, herdam Entity ou AggregateRoot
Value Objects → sealed, herdam ValueObject
Repos Domain  → interfaces com prefixo I
Repos Infra   → sealed, terminam em "Repository"
Configurations → sealed, terminam em "Configuration", implementam IEntityTypeConfiguration<T>
Controllers   → herdam ApiController, terminam em "Controller", têm [ApiController]
Middleware    → termina em "Middleware"
```

---

## 8. CI/CD Pipeline

`.github/workflows/ci.yml` — executado em push/PR para `main` e `develop`:

```
Backend — Build & Test
  ├── dotnet restore (0 warnings)
  ├── dotnet build  (0 warnings, 0 errors)
  ├── Run Unit Tests     (SyllabusTrack.Tests)     → unit-tests.trx
  ├── Run BDD Specs      (SyllabusTrack.Specs)     → bdd-specs.trx
  └── Run Architecture Tests (SyllabusTrack.ArchTests) → arch-tests.trx

Frontend — Build & Lint
  ├── npm ci
  ├── tsc --noEmit
  └── npm run build

Docker — Build & Push (push para main apenas)
  ├── API → ghcr.io/.../syllabustrack-api
  └── Frontend → ghcr.io/.../syllabustrack-frontend
```

---

## 9. SQL — Scripts e Padrões

### 9.1 Stored Procedures

```sql
-- Padrão: @Action CHAR(1) com 'I', 'U', 'D', 'S'
CREATE PROCEDURE usp_ManageEducationalInstitution
    @Action CHAR(1), @InstitutionId INT = NULL, ...

-- usp_AuthenticateStudent: retorna usuário SEM verificar senha
-- A verificação BCrypt é feita no C# (IPasswordHasher.Verify)
```

### 9.2 Seeds — Padrão de Script

```sql
DECLARE @InstId INT, @ProgId INT, @T1 INT

SELECT @T1 = TermId FROM AcademicTerm
WHERE ProgramId = @ProgId AND TermNumber = 1   -- SEMPRE com ProgramId

SELECT ModuleId FROM CourseModule
WHERE TermId = @T1 AND ModuleCode = 'ADS-1A'   -- SEMPRE com TermId

-- Separar batches com GO
GO
```

### 9.3 Cleanup_All.sql — Ordem de FK

```sql
1. SubjectPrerequisite
2. StudentProgress
3. StudentEnrollment
4. AcademicSubject
5. CourseModule
6. AcademicTerm
7. DegreeProgram
8. EducationalInstitution
```

---

## 10. Frontend — Padrões

### 10.1 Feature Folder

```
features/{featureName}/
  api/{featureName}Api.ts
  hooks/use{FeatureName}.ts
  pages/{FeatureName}Page.tsx
  types/{featureName}.types.ts   (opcional)
```

### 10.2 useQuery vs useMutation

- `useQuery` → GET (disparo automático, cache gerenciado).
- `useMutation` → POST de análise (body complexo, disparo manual).

### 10.3 Plano Consolidado (deduplicação frontend)

```typescript
const seen = new Map<string, ConsolidatedSubject>()
for (const target of targetResults) {
  for (const sem of target.semesterPlans) {
    for (const s of sem.subjects) {
      if (s.isMatched) continue
      const key = s.subjectName.trim().toLowerCase()
      if (!seen.has(key))
        seen.set(key, { subjectName: s.subjectName, hours: s.hours, targetNames: [] })
      seen.get(key)!.targetNames.push(target.targetProgramName)
    }
  }
}
```

---

## 11. Checklist — Nova Feature de CRUD

- [ ] **Domain:** entidade `sealed`; `private set` + `= null!`; construtor `private` vazio `base(0)`; factory `static Result<T> Create(...)`; `UpdateDetails(...)` retorna `Result`; `Deactivate()`; interface `IXxxRepository` em `Domain/Repositories/`
- [ ] **EF Config:** `sealed`, `IEntityTypeConfiguration<T>`; termina em "Configuration"; Value Objects via `HasConversion`; `UsePropertyAccessMode(Field)` para coleções privadas; `OnDelete(Cascade)` apenas para coleções próprias; `Restrict` entre aggregates; `DbSet<T>` no `AppDbContext`
- [ ] **Repository:** `sealed`, termina em "Repository", em `Infrastructure/Persistence/Repositories/`; sem `AsNoTracking()` nos métodos de update
- [ ] **DI:** `services.AddScoped<IXxxRepository, XxxRepository>()` em `DependencyInjection.cs`
- [ ] **Commands:** `using SyllabusTrack.Application.Abstractions.Messaging;`; handler `internal sealed`; `unitOfWork.CommitAsync()`; validator `sealed : AbstractValidator<>`
- [ ] **Queries:** `AsNoTracking()`; `XxxResponse.cs` como `sealed record`
- [ ] **Controller:** `sealed`, herda `ApiController`, `[Authorize]`, `HandleResult()`; request body separado do command quando há parâmetro de rota; named route no `HttpGet("{id:int}")`
- [ ] **SQL:** tabela com `IsActive`, `CreatedAt`, `UpdatedAt`; FK com índice explícito; soft delete
- [ ] **Testes:** Feature file + binding + FluentAssertions; unit tests para handler + validator; **confirmar que testes de arquitetura ainda passam** (31/31)

## 12. Checklist — Nova Feature de Análise (sem entidade EF)

- [ ] **Application:** `{Feature}Request.cs`, `{Feature}Response.cs`, `Get{Feature}Query.cs`, `Get{Feature}QueryHandler.cs` (`internal sealed`), `I{Feature}Repository.cs`
- [ ] **Infrastructure:** `{Feature}Repository.cs` `sealed`, termina em "Repository"; `SqlQuery<TRow>` — **sem `ORDER BY` no SQL**; ordenação em C#
- [ ] **DI:** registrar `IXxxRepository` em `DependencyInjection.cs`
- [ ] **API:** novo endpoint; POST para queries com body complexo; 400 para erros de validação, 404 para not found
- [ ] **Frontend:** `{feature}Api.ts`, `use{Feature}.ts` (`useMutation`), `{Feature}Page.tsx`; rota em `AppRouter.tsx`; item em `NavBar.tsx`
- [ ] **Confirmar:** 31 testes de arquitetura ainda passam

---

## 13. Restrições Absolutas

1. **Não alterar o esquema SQL** (`MasterScript.sql`) — sem confirmação explícita do usuário.
2. **Não alterar features já homologadas** — apenas adicionar novas.
3. **Nunca `ORDER BY` dentro de `SqlQuery<T>`** — EF Core 9 quebra com SQL Server.
4. **Nunca construir `IN (id1,id2,id3)` por concatenação de string** — usar uma query por ID com interpolação segura.
5. **Nunca comparar senha no SQL** — hash BCrypt verificado sempre em C# via `IPasswordHasher.Verify()`.
6. **Nunca `DELETE` físico** — sempre soft delete (`IsActive = 0`).
7. **Nunca `AsNoTracking()` em repositório usado para update**.
8. **Nunca criar entidade sem `private set` nas propriedades** — viola os testes de arquitetura (`Domain_Entities_MustNotHavePublicSetters`).
9. **Nunca criar entidade sem `sealed`** — viola os testes de arquitetura (`Domain_Entities_MustBeSealed`).
10. **Nunca referenciar EF Core no Domain ou Application** — viola os testes de arquitetura.
11. **Nunca criar handler sem sufixo "CommandHandler" ou "QueryHandler"** — viola os testes de arquitetura.
