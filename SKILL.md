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
| Testes | Reqnroll (BDD/Gherkin) + xUnit + NSubstitute + FluentAssertions |
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
        └── SyllabusTrack.API
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
    public string InstitutionName { get; private set; }
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
| `Email` | não vazio, contém `@`, máx 255 chars |
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
    CreateXxxCommandHandler.cs   ← sealed class : ICommandHandler<Cmd, int>
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

### 4.3 Features de Análise (sem entidade EF)

Para `CourseComparison`, `AcademicPlanning`, `MultiplePlanning`, `MultipleTargetsPlanning`:

```
Application/Features/{Feature}/
  {Feature}Request.cs            ← sealed record (DTO de entrada — body do POST)
  {Feature}Response.cs           ← sealed record (DTO de saída)
  Get{Feature}Query.cs           ← sealed record : IQuery<{Feature}Response>
  Get{Feature}QueryHandler.cs    ← sealed class : IQueryHandler<Query, Response>
  I{Feature}Repository.cs        ← interface com método GetXxxAsync(...)
```

```csharp
// Handler de feature de análise — padrão
internal sealed class GetMultiplePlanQueryHandler(
    IMultiplePlanningRepository repository)
    : IQueryHandler<GetMultiplePlanQuery, MultiplePlanningResponse>
{
    public async Task<Result<MultiplePlanningResponse>> Handle(
        GetMultiplePlanQuery request, CancellationToken ct)
    {
        // 1. Validações de negócio
        if (request.SourceProgramIds.Count == 0)
            return Result.Failure<MultiplePlanningResponse>(
                new Error("MultiplePlanning.NoSource", "Informe ao menos um curso de referência."));

        // 2. Delegar para o repositório
        var plan = await repository.GetMultiplePlanAsync(
            request.SourceProgramIds, request.TargetProgramId, ct);

        if (plan is null)
            return Result.Failure<MultiplePlanningResponse>(
                new Error("MultiplePlanning.NotFound", "Curso não encontrado."));

        return Result.Success(plan);
    }
}
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

// Match O(1)
bool isMatched = unionNames.Contains(subjectName.Trim().ToLowerInvariant());
```

### 5.5 Segurança

- `BCrypt.Net.BCrypt.HashPassword(password, workFactor: 12)` / `Verify(password, hash)`
- `usp_AuthenticateStudent` retorna o usuário pelo identificador. **Nunca** compara senha no SQL — verificação do hash BCrypt é feita em C# via `IPasswordHasher.Verify()`.

### 5.6 DependencyInjection.cs — Registro de Repositórios

```csharp
// CRUD repositories
services.AddScoped<IEducationalInstitutionRepository, EducationalInstitutionRepository>();
services.AddScoped<IDegreeProgramRepository, DegreeProgramRepository>();
// ...

// Analysis repositories (sem entidade EF)
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
    // GET simples → HandleResult
    [HttpGet]
    public async Task<IActionResult> GetAll(CancellationToken ct)
        => HandleResult(await sender.Send(new GetAllProgramsQuery(), ct));

    // GET com parâmetro → NotFound explícito
    [HttpGet("{id:int}", Name = "GetProgramById")]
    public async Task<IActionResult> GetById(int id, CancellationToken ct)
    {
        var result = await sender.Send(new GetProgramByIdQuery(id), ct);
        if (result.IsFailure)
            return NotFound(new ProblemDetails { Detail = result.Error.Message,
                Extensions = { ["code"] = result.Error.Code } });
        return Ok(result.Value);
    }

    // POST → CreatedAtRoute
    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateProgramCommand command, CancellationToken ct)
    {
        var result = await sender.Send(command, ct);
        if (result.IsFailure) return BadRequest(...);
        return CreatedAtRoute("GetProgramById", new { id = result.Value }, new { programId = result.Value });
    }

    // POST de análise → Ok ou 400/404
    [HttpPost("planning/multiple")]
    public async Task<IActionResult> GetMultiplePlanning(
        [FromBody] MultiplePlanningRequest request, CancellationToken ct)
    {
        var result = await sender.Send(
            new GetMultiplePlanQuery(request.SourceProgramIds, request.TargetProgramId), ct);

        if (result.IsFailure)
        {
            if (result.Error.Code.Contains("NotFound"))
                return NotFound(new ProblemDetails { Detail = result.Error.Message,
                    Extensions = { ["code"] = result.Error.Code } });
            return BadRequest(new ProblemDetails { Detail = result.Error.Message,
                Extensions = { ["code"] = result.Error.Code } });
        }
        return Ok(result.Value);
    }
}

// Request body separado do Command quando há parâmetro de rota
public sealed record UpdateProgramRequest(string ProgramName, string CurriculumVersion, int TotalSemesters);
```

**Regras:**
- `AuthController` **não** tem `[Authorize]`. Todos os demais têm.
- Todo `HttpGet("{id:int}")` deve ter `Name = "GetXxxById"` para `CreatedAtRoute` funcionar.

---

## 7. Frontend — Padrões

### 7.1 Feature Folder

Cada feature tem estrutura consistente:

```
features/{featureName}/
  api/{featureName}Api.ts        ← Função que chama apiClient
  hooks/use{FeatureName}.ts      ← useQuery ou useMutation
  pages/{FeatureName}Page.tsx    ← Página principal
  types/{featureName}.types.ts   ← Tipos TypeScript (opcional)
```

### 7.2 useQuery vs useMutation

```typescript
// ✅ useQuery — para GET (disparo automático, cache gerenciado)
export function usePlanning(sourceId: number, targetId: number) {
  return useQuery({
    queryKey: ['planning', sourceId, targetId],
    queryFn: () => planningApi.getPlan(sourceId, targetId),
    enabled: sourceId > 0 && targetId > 0,
  })
}

// ✅ useMutation — para POST de análise (disparo manual, sem cache automático)
// Planejamento múltiplo usa POST (body complexo) mas retorna dados — usar useMutation
export function useMultiplePlanning() {
  return useMutation({
    mutationFn: ({ sourceProgramIds, targetProgramId }: {
      sourceProgramIds: number[]
      targetProgramId: number
    }) => multiplePlanningApi.getMultiplePlan(sourceProgramIds, targetProgramId),
  })
}

// Uso do useMutation na página
const { mutate, data, isPending, isError, reset } = useMultiplePlanning()
mutate({ sourceProgramIds: [1, 2], targetProgramId: 3 })
```

### 7.3 Axios Client

```typescript
// core/api/client.ts
export const apiClient = axios.create({ baseURL: import.meta.env.VITE_API_URL })

// Interceptor JWT — adiciona Authorization header automaticamente
apiClient.interceptors.request.use((config) => {
  const token = useAuthStore.getState().token
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})
```

### 7.4 Tipos Compartilhados Entre Features

Tipos de uma feature podem ser importados por outra sem copiar:

```typescript
// planning/api/planningApi.ts define os tipos base
export interface SemesterPlanItem { ... }
export interface PlannedSubjectItem { ... }

// multipleplanning/api/multiplePlanningApi.ts reutiliza
import type { SemesterPlanItem } from '../../planning/api/planningApi'

// multipleTargetsPlanning reutiliza o SourceProgramSummary do multipleplanning
import type { SourceProgramSummary } from '../../multipleplanning/api/multiplePlanningApi'
```

### 7.5 Rotas e NavBar

```typescript
// AppRouter.tsx — adicionar rota dentro do ProtectedRoute > Layout
<Route path="/minha-feature" element={<MinhaFeaturePage />} />

// NavBar.tsx — adicionar item no array navItems
{ to: '/minha-feature', label: 'Minha Feature' }
```

### 7.6 Plano Consolidado (deduplicação frontend)

Quando múltiplos resultados chegam da API e precisam de deduplicação, a consolidação é feita em memória no frontend — sem round-trip extra ao backend:

```typescript
// Padrão usado em MultipleTargetsPlanningPage
const seen = new Map<string, ConsolidatedSubject>()

for (const target of targetResults) {
  for (const sem of target.semesterPlans) {
    for (const s of sem.subjects) {
      if (s.isMatched) continue
      const key = s.subjectName.trim().toLowerCase()
      if (!seen.has(key)) {
        seen.set(key, { subjectName: s.subjectName, hours: s.hours, targetNames: [] })
      }
      const entry = seen.get(key)!
      if (!entry.targetNames.includes(target.targetProgramName))
        entry.targetNames.push(target.targetProgramName)
    }
  }
}
```

---

## 8. SQL — Scripts e Padrões

### 8.1 Stored Procedures

```sql
-- Padrão: @Action CHAR(1) com 'I', 'U', 'D', 'S'
CREATE PROCEDURE usp_ManageEducationalInstitution
    @Action CHAR(1), @InstitutionId INT = NULL, ...

-- usp_AuthenticateStudent: retorna usuário SEM verificar senha
-- A verificação BCrypt é feita no C# (IPasswordHasher.Verify)
```

### 8.2 Seeds — Padrão de Script

```sql
-- Sempre usar DECLARE @Id INT e SCOPE_IDENTITY() para capturar IDs
DECLARE @InstId INT, @ProgId INT, @T1 INT

-- Filtrar sempre por ProgramId em subqueries de TermId e ModuleId
SELECT @T1 = TermId FROM AcademicTerm
WHERE ProgramId = @ProgId AND TermNumber = 1   -- ← SEMPRE com ProgramId

SELECT ModuleId FROM CourseModule
WHERE TermId = @T1 AND ModuleCode = 'ADS-1A'   -- ← SEMPRE com TermId

-- Separar batches com GO entre blocos que reutilizam variáveis com mesmo nome
GO
```

### 8.3 Cleanup_All.sql — Ordem de FK

```sql
-- Ordem obrigatória: mais dependente primeiro
1. SubjectPrerequisite
2. StudentProgress
3. StudentEnrollment
4. AcademicSubject
5. CourseModule (com TermId) → CourseModule órfãos (TermId NULL)
6. AcademicTerm
7. DegreeProgram
8. EducationalInstitution
```

---

## 9. Checklist — Nova Feature de CRUD

- [ ] **Domain:** entidade extends `Entity`/`AggregateRoot`; construtor `private` vazio `base(0)`; factory `static Result<T> Create(...)`; `UpdateDetails(...)` retorna `Result`; `Deactivate()`; interface em `Domain/Repositories/`
- [ ] **EF Config:** `IEntityTypeConfiguration<T>`; Value Objects via `HasConversion`; `UsePropertyAccessMode(Field)` para coleções privadas; `OnDelete(Cascade)` apenas para coleções próprias; `Restrict` entre aggregates; `DbSet<T>` no `AppDbContext`
- [ ] **Repository:** em `Infrastructure/Persistence/Repositories/`; sem `AsNoTracking()` nos métodos de update
- [ ] **DI:** `services.AddScoped<IXxxRepository, XxxRepository>()` em `DependencyInjection.cs`
- [ ] **Commands:** `using SyllabusTrack.Application.Abstractions.Messaging;`; handler + `unitOfWork.CommitAsync()`; validator
- [ ] **Queries:** `AsNoTracking()`; `XxxResponse.cs` como `sealed record`
- [ ] **Controller:** extends `ApiController`; `[Authorize]`; `HandleResult()`; request body separado do command quando há parâmetro de rota; named route no `HttpGet("{id:int}")`
- [ ] **SQL:** tabela com `IsActive`, `CreatedAt`, `UpdatedAt`; FK com índice explícito; soft delete
- [ ] **Testes:** Feature file + binding NSubstitute + FluentAssertions

## 10. Checklist — Nova Feature de Análise (sem entidade EF)

- [ ] **Application:** `{Feature}Request.cs`, `{Feature}Response.cs`, `Get{Feature}Query.cs`, `Get{Feature}QueryHandler.cs`, `I{Feature}Repository.cs`
- [ ] **Infrastructure:** `{Feature}Repository.cs` com `SqlQuery<TRow>` — **sem `ORDER BY` no SQL** (EF Core 9); ordenação em C#
- [ ] **DI:** registrar `IXxxRepository` em `DependencyInjection.cs`
- [ ] **API:** novo endpoint no `ProgramsController` (ou controller adequado); POST para queries com body complexo; 400 para erros de validação, 404 para not found
- [ ] **Frontend:** `{feature}Api.ts` → `{feature}Api.{método}()`; `use{Feature}.ts` → `useMutation` (POST) ou `useQuery` (GET); `{Feature}Page.tsx`; rota em `AppRouter.tsx`; item em `NavBar.tsx`

---

## 11. Restrições Absolutas

1. **Não alterar o esquema SQL** (`MasterScript.sql`) — sem confirmação explícita do usuário.
2. **Não alterar features já homologadas** — apenas adicionar novas.
3. **Nunca `ORDER BY` dentro de `SqlQuery<T>`** — EF Core 9 quebra com SQL Server.
4. **Nunca construir `IN (id1,id2,id3)` por concatenação de string** — usar uma query por ID com interpolação segura.
5. **Nunca comparar senha no SQL** — hash BCrypt verificado sempre em C# via `IPasswordHasher.Verify()`.
6. **Nunca `DELETE` físico** — sempre soft delete (`IsActive = 0`).
7. **Nunca `AsNoTracking()` em repositório usado para update**.
