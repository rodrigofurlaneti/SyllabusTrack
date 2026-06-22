# SyllabusTrack — Arquitetura e Padrões

## Propósito

Você é um arquiteto fullstack especialista neste projeto. Quando ativado, aplique consistentemente todos os padrões de arquitetura, modelagem e nomenclatura documentados aqui — ao criar features, revisar código ou fazer scaffold.

---

## Stack Tecnológico

| Camada | Tecnologia |
|---|---|
| Runtime | .NET 9 / C# 13 |
| Web API | ASP.NET Core Web API |
| ORM | EF Core 9 (SQL Server) |
| Mensageria | MediatR 12 |
| Validação | FluentValidation 11 |
| Auth | JWT Bearer (BCrypt + System.IdentityModel.Tokens.Jwt) |
| Testes | Reqnroll (Gherkin/BDD) + xUnit + NSubstitute + FluentAssertions |
| Frontend | React 19, TypeScript, Vite |
| Estado | Zustand (auth) + TanStack React Query (server state) |
| Formulários | React Hook Form + Zod |
| HTTP Client | Axios (singleton com interceptors) |
| Roteamento | React Router DOM 7 |

---

## 1. Estrutura da Solução

```
SyllabusTrack/
├── Sql/
│   ├── MasterScript.sql      # DDL: tabelas, índices, stored procedures
│   └── SeedData.sql          # Dados reais do curso de Medicina (UnirG)
├── FrontEnd/                 # React + TypeScript SPA
└── BackEnd/
    └── SyllabusTrack/
        ├── SyllabusTrack.Domain          # Entidades, VOs, interfaces, eventos
        ├── SyllabusTrack.Application     # CQRS: commands/queries, validators, DTOs
        ├── SyllabusTrack.Infrastructure  # EF Core, repositórios, JWT, BCrypt
        └── SyllabusTrack.API             # Controllers, middleware, DI
```

**Fluxo de dependência (Clean Architecture):**
```
API → Application → Domain
              ↑
       Infrastructure (implementa interfaces do Domain)
```

- Domain: **zero** dependências externas.
- Application: depende apenas do Domain.
- Infrastructure: implementa interfaces do Domain; nunca referenciada pela Application.
- API: referencia Application e Infrastructure apenas para DI.

---

## 2. Domínio — Entidades e Banco de Dados

### 2.1 Modelo de Dados

O banco **SyllabusTrackDb** (SQL Server, PKs `INT IDENTITY`) tem as seguintes tabelas:

```
EducationalInstitution   (InstitutionId PK)
  └── DegreeProgram      (ProgramId PK, InstitutionId FK)
        └── AcademicTerm (TermId PK, ProgramId FK)
              └── CourseModule    (ModuleId PK, TermId FK)
                    └── AcademicSubject     (SubjectId PK, ModuleId FK)
                          └── SubjectPrerequisite (TargetSubjectId FK, RequiredSubjectId FK)

StudentAccount           (StudentId PK)
  └── StudentEnrollment  (EnrollmentId PK, StudentId FK, ProgramId FK)
        └── StudentProgress (ProgressId PK, EnrollmentId FK, SubjectId FK)
```

**Campos comuns em todas as tabelas:** `IsActive BIT DEFAULT 1`, `CreatedAt DATETIME`, `UpdatedAt DATETIME`.

**Soft delete:** nunca `DELETE` físico — sempre `UPDATE IsActive = 0`.

### 2.2 Entidades C# Mapeadas pelo EF Core

| Entidade C# | Tabela SQL | Tipo |
|---|---|---|
| `EducationalInstitution` | `EducationalInstitution` | `AggregateRoot` |
| `DegreeProgram` | `DegreeProgram` | `AggregateRoot` |
| `AcademicSubject` | `AcademicSubject` | `Entity` |
| `StudentAccount` | `StudentAccount` | `AggregateRoot` |
| `StudentEnrollment` | `StudentEnrollment` | `AggregateRoot` |
| `StudentProgress` | `StudentProgress` | `Entity` |

> **Atenção:** `AcademicTerm` e `CourseModule` existem no banco mas **não têm entidade C#** — são gerenciados via SQL direto ou seeds. `AcademicSubject` referencia `ModuleId` como `int` simples (sem navegação EF).

### 2.3 Classes Base (Domain/Primitives)

```csharp
// Entity — PK int
public abstract class Entity : IEquatable<Entity>
{
    public int Id { get; protected set; }
    protected Entity(int id) => Id = id;
    // Equals/GetHashCode por Id
}

// AggregateRoot — estende Entity, suporta domain events
public abstract class AggregateRoot : Entity
{
    private readonly List<IDomainEvent> _domainEvents = [];
    public IReadOnlyList<IDomainEvent> DomainEvents => _domainEvents.AsReadOnly();
    protected void RaiseDomainEvent(IDomainEvent e) => _domainEvents.Add(e);
    public void ClearDomainEvents() => _domainEvents.Clear();
}

// ValueObject — igualdade por valor
public abstract class ValueObject : IEquatable<ValueObject>
{
    public abstract IEnumerable<object> GetAtomicValues();
    // Equals/GetHashCode via GetAtomicValues()
}
```

### 2.4 Value Objects existentes

| Value Object | Regras |
|---|---|
| `Email` | não vazio, contém `@`, máx 255 chars |
| `Grade` | `decimal` entre 0.00 e 10.00 |
| `PhoneNumber` | existe no domínio mas ainda não aplicado nas entidades |

Todos retornam `Result<T>` via `Create()`.

### 2.5 Padrão de Entidade

```csharp
public sealed class EducationalInstitution : AggregateRoot
{
    public string InstitutionName { get; private set; }
    public string InstitutionAcronym { get; private set; }
    public string CampusLocation { get; private set; }
    public bool IsActive { get; private set; }

    private EducationalInstitution() : base(0) { } // EF Core

    private EducationalInstitution(string name, string acronym, string location) : base(0)
    {
        InstitutionName = name;
        InstitutionAcronym = acronym;
        CampusLocation = location;
        IsActive = true;
    }

    public static Result<EducationalInstitution> Create(string name, string acronym, string location)
    {
        if (string.IsNullOrWhiteSpace(name))
            return Result.Failure<EducationalInstitution>(new Error("Institution.EmptyName", "Institution name is required."));
        return Result.Success(new EducationalInstitution(name, acronym, location));
    }

    public Result UpdateDetails(string name, string acronym, string location) { ... }
    public void Deactivate() => IsActive = false;
}
```

**Regras:**
- Construtor `private` vazio para EF Core (`base(0)`).
- Construtor `private` com parâmetros.
- Factory `static Result<T> Create(...)` — valida e retorna `Result`.
- Método `UpdateDetails(...)` retorna `Result` para atualizações.
- Método `Deactivate()` para soft delete.
- Entidades filhas de aggregates usam `internal static Create(...)`.

### 2.6 Result Pattern

```csharp
// Void
Result.Success()
Result.Failure(new Error("Code", "Message"))

// Com valor
Result.Success<T>(value)
Result.Failure<T>(new Error("Code", "Message"))

// Uso em handlers
if (result.IsFailure)
    return Result.Failure<int>(result.Error);
```

**Nunca lance exceções para erros de negócio esperados dentro de handlers.**

---

## 3. Application Layer — CQRS

### 3.1 Interfaces de Messaging

```csharp
// Command sem retorno de dados
public interface ICommand : IRequest<Result> { }

// Command que retorna um valor (ex: ID criado)
public interface ICommand<TResponse> : IRequest<Result<TResponse>> { }

// Handler de command sem retorno
public interface ICommandHandler<TCommand> : IRequestHandler<TCommand, Result>
    where TCommand : ICommand { }

// Handler de command com retorno
public interface ICommandHandler<TCommand, TResponse> : IRequestHandler<TCommand, Result<TResponse>>
    where TCommand : ICommand<TResponse> { }

// Query (sempre retorna valor)
public interface IQuery<TResponse> : IRequest<Result<TResponse>> { }
public interface IQueryHandler<TQuery, TResponse> : IRequestHandler<TQuery, Result<TResponse>>
    where TQuery : IQuery<TResponse> { }
```

### 3.2 Estrutura por Feature

```
Application/Features/
  {Aggregate}/
    Create/
      CreateXxxCommand.cs          ← sealed record : ICommand<int>
      CreateXxxCommandHandler.cs   ← sealed class : ICommandHandler<Cmd, int>
      CreateXxxCommandValidator.cs ← sealed class : AbstractValidator<Cmd>
    Update/
      UpdateXxxCommand.cs          ← sealed record : ICommand  (sem retorno de dados)
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

### 3.3 Padrão de Command

```csharp
// OBRIGATÓRIO: sempre adicionar o using da camada de messaging
using SyllabusTrack.Application.Abstractions.Messaging;

namespace SyllabusTrack.Application.Features.Institutions.Update
{
    public sealed record UpdateInstitutionCommand(
        int InstitutionId,
        string Name,
        string Acronym,
        string Location) : ICommand;  // ICommand sem tipo = sem retorno de dados
}
```

### 3.4 Padrão de Handler (Command com retorno)

```csharp
internal sealed class CreateInstitutionCommandHandler(
    IEducationalInstitutionRepository repository,
    IUnitOfWork unitOfWork) : ICommandHandler<CreateInstitutionCommand, int>
{
    public async Task<Result<int>> Handle(CreateInstitutionCommand request, CancellationToken cancellationToken)
    {
        var result = EducationalInstitution.Create(request.Name, request.Acronym, request.Location);
        if (result.IsFailure)
            return Result.Failure<int>(result.Error);

        await repository.AddAsync(result.Value, cancellationToken);
        await unitOfWork.CommitAsync(cancellationToken);

        return Result.Success(result.Value.Id);
    }
}
```

### 3.5 FluentValidation

```csharp
public sealed class CreateInstitutionCommandValidator : AbstractValidator<CreateInstitutionCommand>
{
    public CreateInstitutionCommandValidator()
    {
        RuleFor(x => x.Name).NotEmpty().MaximumLength(255);
        RuleFor(x => x.Acronym).MaximumLength(50);
        RuleFor(x => x.Location).MaximumLength(255);
    }
}
```

**Regra:** validações de formato/tamanho → FluentValidation. Regras de negócio complexas → entity factory.

---

## 4. Infrastructure Layer

### 4.1 Repositórios — Regra de Tracking

```
❌ AsNoTracking()  →  NUNCA use em métodos chamados para UPDATE
✅ AsNoTracking()  →  use em consultas/leituras puras (melhor performance)
```

| Método | AsNoTracking? |
|---|---|
| `GetByIdAsync` (chamado em UpdateHandler) | ❌ NÃO |
| `GetByIdWithSyllabusAsync` (chamado em UpdateHandler) | ❌ NÃO |
| `GetAllActiveAsync` | ✅ SIM |
| `GetByStudentIdAsync` | ✅ SIM |
| `GetByModuleIdAsync` | ✅ SIM |

### 4.2 Interfaces de Repositório (definidas no Domain)

```csharp
// IEducationalInstitutionRepository
Task AddAsync(EducationalInstitution institution, CancellationToken ct = default);
Task<EducationalInstitution?> GetByIdAsync(int id, CancellationToken ct = default);
Task<IEnumerable<EducationalInstitution>> GetAllActiveAsync(CancellationToken ct = default);

// IDegreeProgramRepository
Task AddAsync(DegreeProgram program, CancellationToken ct = default);
Task<DegreeProgram?> GetByIdWithSyllabusAsync(int id, CancellationToken ct = default);
Task<IEnumerable<DegreeProgram>> GetAllActiveAsync(CancellationToken ct = default);

// IAcademicSubjectRepository
Task AddAsync(AcademicSubject subject, CancellationToken ct = default);
Task<AcademicSubject?> GetByIdAsync(int id, CancellationToken ct = default);
Task<IEnumerable<AcademicSubject>> GetByModuleIdAsync(int moduleId, CancellationToken ct = default);

// IStudentAccountRepository
Task AddAsync(StudentAccount student, CancellationToken ct = default);
Task<StudentAccount?> GetByIdAsync(int id, CancellationToken ct = default);
Task<StudentAccount?> GetByEmailOrUsernameAsync(string identifier, CancellationToken ct = default);
Task<bool> IsEmailUniqueAsync(Email email, CancellationToken ct = default);
Task<bool> IsUsernameUniqueAsync(string username, CancellationToken ct = default);

// IStudentEnrollmentRepository
Task AddAsync(StudentEnrollment enrollment, CancellationToken ct = default);
Task<StudentEnrollment?> GetByIdWithProgressAsync(int id, CancellationToken ct = default);
Task<IEnumerable<StudentEnrollment>> GetByStudentIdAsync(int studentId, CancellationToken ct = default);
```

### 4.3 EF Core — Configurações

Todas via `IEntityTypeConfiguration<T>`, auto-descobertas com `ApplyConfigurationsFromAssembly`.

```csharp
// Value Object simples (HasConversion)
builder.Property(s => s.EmailAddress)
    .HasColumnName("EmailAddress")
    .HasConversion(
        email => email.Value,
        value => Email.Create(value).Value);

// Value Object nullable
builder.Property(p => p.FinalGrade)
    .HasConversion(
        grade => grade != null ? (decimal?)grade.Value : null,
        value => value.HasValue ? Grade.Create(value.Value).Value : null);

// Coleção privada com backing field
builder.HasMany(e => e.Progresses)
    .WithOne()
    .HasForeignKey(p => p.EnrollmentId)
    .OnDelete(DeleteBehavior.Cascade);
builder.Navigation(e => e.Progresses)
    .UsePropertyAccessMode(PropertyAccessMode.Field);

// FK entre aggregates: sempre Restrict (não Cascade)
builder.HasOne<EducationalInstitution>()
    .WithMany()
    .HasForeignKey(p => p.InstitutionId)
    .OnDelete(DeleteBehavior.Restrict);
```

### 4.4 Segurança

- **Senha:** `BCrypt.Net.BCrypt.HashPassword(password, workFactor: 12)` / `BCrypt.Net.BCrypt.Verify(password, hash)`
- **A procedure `usp_AuthenticateStudent` NÃO valida senha** — apenas retorna o usuário pelo identificador. A verificação do hash BCrypt é feita em `IPasswordHasher.Verify()` no C#.
- **JWT:** assina com `HmacSha256`, configurável via `appsettings.json` (Issuer, Audience, SecretKey, ExpirationMinutes).

---

## 5. API Layer

### 5.1 ApiController Base

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

### 5.2 Padrão de Controller

```csharp
[Authorize]
public sealed class InstitutionsController(ISender sender) : ApiController
{
    [HttpGet]
    public async Task<IActionResult> GetAll(CancellationToken ct)
        => HandleResult(await sender.Send(new GetAllInstitutionsQuery(), ct));

    [HttpGet("{id:int}", Name = "GetInstitutionById")]
    public async Task<IActionResult> GetById(int id, CancellationToken ct)
    {
        var result = await sender.Send(new GetInstitutionByIdQuery(id), ct);
        if (result.IsFailure)
            return NotFound(new ProblemDetails { Title = "Not Found", Detail = result.Error.Message });
        return Ok(result.Value);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateInstitutionCommand command, CancellationToken ct)
    {
        var result = await sender.Send(command, ct);
        if (result.IsFailure)
            return BadRequest(...);
        return CreatedAtRoute("GetInstitutionById", new { id = result.Value }, new { institutionId = result.Value });
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] UpdateInstitutionRequest request, CancellationToken ct)
        => HandleResult(await sender.Send(new UpdateInstitutionCommand(id, request.Name, request.Acronym, request.Location), ct));
}

// Request body separado do Command quando há parâmetro de rota
public sealed record UpdateInstitutionRequest(string Name, string Acronym, string Location);
```

**Auth:** `AuthController` **não** tem `[Authorize]` (endpoints públicos: `POST /register` e `POST /login`). Todos os demais controllers têm `[Authorize]`.

**Named routes:** todo `HttpGet("{id:int}")` deve ter `Name = "GetXxxById"` para o `CreatedAtRoute` do POST funcionar. Nunca usar `CreatedAtRoute` com nome de rota que não existe.

---

## 6. Banco de Dados — Padrões SQL

### 6.1 Stored Procedures

Todas as procedures seguem o padrão `@Action CHAR(1)` com `'I'`, `'U'`, `'D'`, `'S'`, **exceto** `usp_AuthenticateStudent` (propósito único).

```sql
-- CERTO: a procedure retorna o usuário, o C# faz a verificação do hash BCrypt
CREATE PROCEDURE usp_AuthenticateStudent @LoginIdentifier VARCHAR(255)
AS BEGIN
    SELECT StudentId, ..., AccountPassword
    FROM StudentAccount
    WHERE (LoginUsername = @LoginIdentifier OR EmailAddress = @LoginIdentifier) AND IsActive = 1;
END

-- ERRADO: nunca comparar senha em plain text no SQL
-- AND AccountPassword = @AccountPassword  ← NUNCA (senha é hash BCrypt)
```

### 6.2 Índices

Todas as colunas FK têm índice explícito criado após a criação das tabelas. Índice composto em `StudentProgress(EnrollmentId, SubjectId)` com `INCLUDE (CompletionStatus, FinalGrade)`.

### 6.3 Dados de Seed

`SeedData.sql` contém o currículo real de Medicina da UnirG (Matriz Curricular Nº 5) — 12 períodos, ~50 módulos, ~90 disciplinas + estágios + optativas. Não altere sem confirmação com o usuário.

---

## 7. Testes — BDD com Reqnroll

```gherkin
Feature: Cadastro de Instituição

  Scenario: Cadastrar instituição com sucesso
    When cadastro a instituição "Fundação UnirG" com sigla "UnirG" e localização "Gurupi"
    Then o cadastro deve ter sucesso e retornar um ID positivo

  Scenario: Rejeitar nome vazio
    When cadastro a instituição "" com sigla "X" e localização "Y"
    Then o cadastro deve falhar com o erro "Institution.EmptyName"
```

```csharp
[Binding]
public sealed class InstitutionSteps
{
    private readonly IEducationalInstitutionRepository _repo = Substitute.For<IEducationalInstitutionRepository>();
    private readonly IUnitOfWork _uow = Substitute.For<IUnitOfWork>();
    private Result<int> _result = default!;

    [When("cadastro a instituição {string} com sigla {string} e localização {string}")]
    public async Task WhenCadastro(string name, string acronym, string location)
    {
        var handler = new CreateInstitutionCommandHandler(_repo, _uow);
        _result = await handler.Handle(new CreateInstitutionCommand(name, acronym, location), default);
    }

    [Then("o cadastro deve ter sucesso e retornar um ID positivo")]
    public void ThenSucesso() => _result.IsSuccess.Should().BeTrue();

    [Then("o cadastro deve falhar com o erro {string}")]
    public void ThenFalha(string code) => _result.Error.Code.Should().Be(code);
}
```

---

## 8. Checklist — Adicionando uma Nova Feature

- [ ] **Domain:** Entidade extends `Entity`/`AggregateRoot`; construtor `private` vazio para EF Core (`base(0)`); factory `static Result<T> Create(...)`; método `UpdateDetails(...)` retornando `Result`; método `Deactivate()`; interface de repositório em `Domain/Repositories/`
- [ ] **EF Config:** `IEntityTypeConfiguration<T>` em Infrastructure; Value Objects via `HasConversion`; `UsePropertyAccessMode(Field)` para coleções privadas; `OnDelete(Cascade)` apenas para coleções próprias; `Restrict` para FKs entre aggregates; adicionar `DbSet<T>` ao `AppDbContext`
- [ ] **Repository:** Implementação concreta em `Infrastructure/Persistence/Repositories/`; **sem** `AsNoTracking()` em métodos usados para update
- [ ] **DI:** Registrar `services.AddScoped<IXxxRepository, XxxRepository>()` em `DependencyInjection.cs`
- [ ] **Commands:** `XxxCommand.cs` com `using SyllabusTrack.Application.Abstractions.Messaging;`; handler com repositório e `unitOfWork.CommitAsync()`; validator com FluentValidation
- [ ] **Queries:** `XxxQuery.cs`, `XxxQueryHandler.cs` com `AsNoTracking`; `XxxResponse.cs` (sealed record)
- [ ] **Controller:** Extends `ApiController`; `[Authorize]`; usa `HandleResult()`; request body separado do command quando há parâmetro de rota; named route no `HttpGet("{id:int}")` para o `CreatedAtRoute`
- [ ] **SQL:** Tabela com `IsActive BIT DEFAULT 1`, `CreatedAt`, `UpdatedAt`; FK com índice explícito; soft delete (nunca `DELETE` físico)
- [ ] **Testes:** Feature file `.feature` + `[Binding]` com NSubstitute + FluentAssertions; cenários: sucesso + erro de domínio + validação
