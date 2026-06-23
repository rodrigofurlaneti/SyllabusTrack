# SyllabusTrack

**SyllabusTrack** é uma plataforma fullstack para acompanhamento de grade curricular, progresso acadêmico e planejamento de aproveitamento entre cursos, desenvolvida com Clean Architecture, CQRS e DDD.

[![CI — Build, Test & Docker](https://github.com/rodrigofurlaneti/SyllabusTrack/actions/workflows/ci.yml/badge.svg)](https://github.com/rodrigofurlaneti/SyllabusTrack/actions/workflows/ci.yml)

---

## Índice

- [Visão Geral](#visão-geral)
- [Funcionalidades](#funcionalidades)
- [Stack Tecnológica](#stack-tecnológica)
- [Arquitetura](#arquitetura)
- [Camadas de Teste](#camadas-de-teste)
- [CI/CD Pipeline](#cicd-pipeline)
- [Modelagem de Dados](#modelagem-de-dados)
- [Estrutura de Pastas](#estrutura-de-pastas)
- [Padrões e Princípios](#padrões-e-princípios)
- [API — Endpoints](#api--endpoints)
- [Dados de Seed](#dados-de-seed)
- [Como Executar](#como-executar)
- [Decisões Arquiteturais](#decisões-arquiteturais)

---

## Visão Geral

O **SyllabusTrack** permite que estudantes acompanhem sua trajetória acadêmica e planejem o aproveitamento de disciplinas entre diferentes cursos. O sistema calcula automaticamente quais matérias de um curso já concluído cobrem as exigências de um novo curso, estimando o tempo até a formatura.

---

## Funcionalidades

### Gestão Acadêmica
- **Instituições e Cursos**: cadastro de instituições de ensino e cursos com versionamento de grade curricular.
- **Grade Curricular**: estrutura hierárquica Curso → Período → Módulo → Disciplina, com carga horária detalhada (teórica, prática, estágio, extensão) e pré-requisitos.
- **Matrícula**: vinculação de estudantes a cursos com controle de status.
- **Progresso**: registro do status de cada disciplina (`Pending`, `InProgress`, `Completed`, `Failed`) com nota e semestre cursado.

### Análise e Planejamento
- **Dashboard**: resumo do progresso geral do estudante, disciplinas concluídas, em andamento e pendentes.
- **Próximos Cursos**: recomendações de cursos compatíveis com o perfil do estudante.
- **Comparar Cursos**: comparação entre dois cursos mostrando o percentual de aproveitamento de disciplinas e carga horária.
- **Planejamento Acadêmico**: dado 1 curso concluído e 1 curso-alvo, calcula o plano semestre a semestre com estimativa de formatura.
- **Planejamento Múltiplo** (N → 1): combina a UNIÃO de disciplinas de N cursos concluídos contra 1 curso-alvo, eliminando duplicatas automaticamente.
- **Planejamento Multi-Alvo** (N → N): combina a UNIÃO de N cursos concluídos contra N cursos-alvo simultaneamente, com plano consolidado de matérias únicas a cursar (deduplicação entre alvos) e destaque para matérias compartilhadas que valem para 2+ cursos.

### Autenticação
- Cadastro e login com JWT Bearer + BCrypt (workFactor 12).

---

## Stack Tecnológica

### Backend

| Tecnologia | Versão | Uso |
|---|---|---|
| **.NET** | 9.0 | Plataforma principal |
| **C#** | 13 | Linguagem |
| **ASP.NET Core Web API** | 9.0 | Framework HTTP |
| **Entity Framework Core** | 9.0 | ORM |
| **SQL Server** | 2019+ | Banco de dados |
| **MediatR** | 12.4 | Mediador CQRS |
| **FluentValidation** | 11 | Validação de commands |
| **BCrypt.Net-Next** | — | Hash de senhas |
| **JWT Bearer** | 9.0 | Autenticação |
| **Swashbuckle (Swagger)** | — | Documentação da API |

### Testes Backend

| Tecnologia | Uso |
|---|---|
| **xUnit** | Framework de testes |
| **FluentAssertions** | Asserções expressivas |
| **NSubstitute** | Mocks e stubs (unit tests) |
| **Moq** | Mocks e stubs (BDD specs) |
| **Reqnroll** | BDD / Gherkin (specs) |
| **NetArchTest.Rules** | Testes de arquitetura DDD |

### Frontend

| Tecnologia | Versão | Uso |
|---|---|---|
| **React** | 19 | Framework de UI |
| **TypeScript** | — | Tipagem estática |
| **Vite** | — | Build tool + HMR |
| **React Router DOM** | 7 | Roteamento SPA |
| **TanStack Query** | 5 | Server state, cache e mutations |
| **Zustand** | 5 | Client state (auth) |
| **React Hook Form** | 7 | Formulários |
| **Zod** | — | Validação de schemas |
| **Axios** | — | HTTP client com interceptors JWT |
| **Tailwind CSS** | — | Estilização utilitária |

---

## Arquitetura

Clean Architecture com 4 camadas. Dependências fluem de fora para dentro — **nunca** o contrário.

```
┌─────────────────────────────────────────────┐
│                    API                      │  ← Controllers, Middleware
├─────────────────────────────────────────────┤
│              Infrastructure                 │  ← EF Core, JWT, BCrypt
├─────────────────────────────────────────────┤
│               Application                  │  ← CQRS, Validação, Pipeline
├─────────────────────────────────────────────┤
│                 Domain                      │  ← Entidades, Value Objects, Regras
└─────────────────────────────────────────────┘
```

### Fluxo de uma Requisição

```
HTTP Request
    │
    ▼
Controller (API)
    │  new Command / Query
    ▼
MediatR Pipeline
    ├── LoggingBehavior
    └── ValidationBehavior (FluentValidation)
         │
         ▼
    CommandHandler / QueryHandler (Application)
         │
         ▼
    Repository (Infrastructure / EF Core ou SqlQuery<T>)
         │
         ▼
    SQL Server (SyllabusTrackDb)
```

---

## Camadas de Teste

O projeto possui **três projetos de teste** complementares, todos executados no CI:

### 1. SyllabusTrack.Tests — Testes Unitários (126 testes)

Testes unitários com xUnit + FluentAssertions + NSubstitute cobrindo Domain e Application:

- **Domain:** entidades (`EducationalInstitution`, `StudentAccount`), Value Objects (`Email`, `Grade`, `PhoneNumber`), `Result`/`Error`
- **Application:** todos os command handlers, query handlers e validators por feature (Auth, Institutions, CourseComparison, AcademicPlanning, MultiplePlanning, MultipleTargetsPlanning, Recommendations)

```bash
dotnet test SyllabusTrack.Tests --verbosity normal
# Total: 126 | Passed: 126
```

### 2. SyllabusTrack.Specs — BDD / Gherkin (52 specs)

Especificações de comportamento com Reqnroll (Cucumber para .NET) + Moq, cobrindo os cenários de negócio via features `.feature`:

| Feature | Cenários |
|---|---|
| Auth (Register + Login) | 13 |
| Institutions | 8 |
| CourseComparison | 4 |
| AcademicPlanning | 5 |
| MultiplePlanning | 10 |
| MultipleTargetsPlanning | 10 |
| Recommendations | 2 |

```bash
dotnet test SyllabusTrack.Specs --verbosity normal
# Total: 52 | Passed: 52
```

### 3. SyllabusTrack.ArchTests — Testes de Arquitetura DDD (31 testes)

Testes de arquitetura com **NetArchTest.Rules 1.3.2** garantindo que as fronteiras de Clean Architecture/DDD nunca sejam violadas:

| Classe de Teste | Regras Verificadas |
|---|---|
| `LayerDependencyTests` (6) | Domain/Application/Infrastructure/API não violam hierarquia de dependências |
| `DomainRulesTests` (7) | Entidades herdam `Entity`/`AggregateRoot`, são `sealed`, sem setters públicos; Value Objects herdam `ValueObject`; repositórios são interfaces; Domain sem EF Core |
| `ApplicationRulesTests` (6) | Command/Query handlers seguem nomenclatura e implementam interfaces corretas; validators herdam `AbstractValidator<T>`; Application sem EF Core |
| `InfrastructureRulesTests` (5) | Repositórios concretos são `sealed` e terminam em "Repository"; configurations são `sealed`, terminam em "Configuration" e implementam `IEntityTypeConfiguration<T>` |
| `ApiRulesTests` (7) | Controllers residem em `SyllabusTrack.API.Controllers`, herdam `ApiController`, têm `[ApiController]`; middleware termina em "Middleware" |

```bash
dotnet test SyllabusTrack.ArchTests --verbosity normal
# Total: 31 | Passed: 31
```

---

## CI/CD Pipeline

O arquivo `.github/workflows/ci.yml` define o pipeline completo:

```
push/PR para main ou develop
        │
        ├── Backend — Build & Test
        │       │
        │       ├── dotnet restore (solução completa)
        │       ├── dotnet build  (0 warnings, 0 errors)
        │       ├── Run Unit Tests     → unit-tests.trx
        │       ├── Run BDD Specs      → bdd-specs.trx
        │       └── Run Architecture Tests → arch-tests.trx
        │
        ├── Frontend — Build & Lint
        │       ├── npm ci
        │       ├── tsc --noEmit
        │       └── npm run build
        │
        ├── Docker — Build & Push (push para main apenas)
        │       ├── Build & push API image  → ghcr.io/.../syllabustrack-api
        │       └── Build & push Frontend   → ghcr.io/.../syllabustrack-frontend
        │
        └── Pipeline Summary
```

---

## Modelagem de Dados

### Hierarquia do Currículo

```
EducationalInstitution  (InstitutionId PK)
│
└── DegreeProgram       (ProgramId PK, InstitutionId FK)
    │   TotalSemesters INT
    │
    └── AcademicTerm    (TermId PK, ProgramId FK)
        │   TermNumber INT
        │
        └── CourseModule (ModuleId PK, TermId FK)
            │   ModuleCode VARCHAR(50)
            │
            └── AcademicSubject (SubjectId PK, ModuleId FK)
                    SubjectCode, SubjectName
                    TheoreticalHours, PracticalHours
                    StudyGroupHours, ExtensionHours
                    InternshipHours, TotalSubjectHours

SubjectPrerequisite (TargetSubjectId FK, RequiredSubjectId FK)
```

### Estudantes

```
StudentAccount      (StudentId PK)
│
└── StudentEnrollment (EnrollmentId PK, StudentId FK, ProgramId FK)
    │   EnrollmentStatus VARCHAR(50)  ← "Active"
    │
    └── StudentProgress (ProgressId PK, EnrollmentId FK, SubjectId FK)
            CompletionStatus  ← "Pending" | "InProgress" | "Completed" | "Failed"
            SemesterTaken     ← Ex: "2024.1"
            FinalGrade        ← DECIMAL(5,2), Value Object Grade (0.00–10.00)
```

> **Soft delete:** toda remoção é `IsActive = 0`. Campos `CreatedAt` e `UpdatedAt` em todas as tabelas.

> **`AcademicTerm` e `CourseModule`** existem no banco mas **não têm entidade C#** — gerenciados via SQL/seed.

---

## Estrutura de Pastas

```
SyllabusTrack/
│
├── Sql/
│   ├── MasterScript.sql                   ← DDL: tabelas, índices, stored procedures
│   ├── SeedData.sql                       ← UnirG: Medicina (12 sem) + 19 cursos FAM EAD
│   ├── Seed_FAM_Psicologia_Farmacia.sql   ← FAM: Psicologia (10 sem) + Farmácia (8 sem)
│   ├── Seed_RodrigoMadeira.sql            ← Histórico acadêmico do estudante Rodrigo Madeira
│   └── Cleanup_All.sql                    ← Remove todos os dados seed (ordem FK correta)
│
├── FrontEnd/
│   └── src/
│       ├── core/
│       │   ├── api/client.ts              ← Axios singleton com interceptor JWT
│       │   ├── auth/authStore.ts          ← Zustand: token + user
│       │   └── router/AppRouter.tsx       ← React Router: rotas protegidas
│       ├── features/
│       │   ├── auth/                      ← Login, Register (páginas + hooks + API)
│       │   ├── dashboard/                 ← Resumo de progresso
│       │   ├── curriculum/               ← Grade curricular por curso
│       │   ├── progress/                 ← Progresso por disciplina
│       │   ├── recommendations/          ← Próximos cursos recomendados
│       │   ├── comparison/               ← Comparar dois cursos
│       │   ├── planning/                 ← Planejamento 1 → 1
│       │   ├── multipleplanning/         ← Planejamento N fontes → 1 alvo
│       │   └── multipletargetsplanning/  ← Planejamento N fontes → N alvos
│       └── shared/
│           └── components/
│               ├── NavBar.tsx
│               └── Layout.tsx
│
└── BackEnd/
    └── SyllabusTrack/
        ├── SyllabusTrack.Domain/
        │   ├── Entities/
        │   │   ├── AcademicSubject.cs
        │   │   ├── DegreeProgram.cs          ← AggregateRoot
        │   │   ├── EducationalInstitution.cs ← AggregateRoot
        │   │   ├── StudentAccount.cs         ← AggregateRoot
        │   │   ├── StudentEnrollment.cs      ← AggregateRoot (possui StudentProgress)
        │   │   └── StudentProgress.cs        ← Entity
        │   ├── Primitives/
        │   │   ├── AggregateRoot.cs
        │   │   ├── Entity.cs
        │   │   ├── IDomainEvent.cs
        │   │   └── ValueObject.cs
        │   ├── Repositories/                 ← Interfaces de repositório
        │   ├── Shared/
        │   │   ├── Error.cs
        │   │   └── Result.cs
        │   └── ValueObjects/
        │       ├── Email.cs
        │       ├── Grade.cs
        │       └── PhoneNumber.cs
        │
        ├── SyllabusTrack.Application/
        │   ├── Abstractions/
        │   │   ├── Authentication/           ← IJwtProvider, IPasswordHasher
        │   │   ├── Behaviors/                ← LoggingBehavior, ValidationBehavior
        │   │   └── Messaging/                ← ICommand, IQuery, ICommandHandler, IQueryHandler
        │   └── Features/
        │       ├── Auth/                     ← Login, Register
        │       ├── Institutions/             ← Create, GetAll, GetById, Update
        │       ├── DegreePrograms/           ← Create, GetAll, GetById, Update
        │       ├── AcademicSubjects/         ← Create
        │       ├── Enrollments/              ← Create, AddProgress, GetByStudent
        │       ├── Recommendations/          ← GetRecommendations
        │       ├── CourseComparison/         ← CompareProgramsQuery (sem entidade EF)
        │       ├── AcademicPlanning/         ← GetAcademicPlanQuery (sem entidade EF)
        │       ├── MultiplePlanning/         ← GetMultiplePlanQuery — N fontes → 1 alvo
        │       └── MultipleTargetsPlanning/  ← GetMultipleTargetsPlanQuery — N fontes → N alvos
        │
        ├── SyllabusTrack.Infrastructure/
        │   ├── DependencyInjection/
        │   ├── Persistence/
        │   │   ├── AppDbContext.cs
        │   │   ├── Configurations/           ← IEntityTypeConfiguration<T> por entidade
        │   │   ├── Repositories/
        │   │   │   ├── EducationalInstitutionRepository.cs
        │   │   │   ├── DegreeProgramRepository.cs
        │   │   │   ├── AcademicSubjectRepository.cs
        │   │   │   ├── StudentAccountRepository.cs
        │   │   │   ├── StudentEnrollmentRepository.cs
        │   │   │   ├── ProgramRecommendationRepository.cs
        │   │   │   ├── CourseComparisonRepository.cs
        │   │   │   ├── AcademicPlanningRepository.cs
        │   │   │   ├── MultiplePlanningRepository.cs
        │   │   │   └── MultipleTargetsPlanningRepository.cs
        │   │   └── UnitOfWork.cs
        │   └── Security/
        │       ├── JwtOptions.cs
        │       ├── JwtProvider.cs
        │       └── PasswordHasher.cs
        │
        ├── SyllabusTrack.API/
        │   ├── Controllers/
        │   │   ├── ApiController.cs           ← HandleResult<T> helper base
        │   │   ├── AuthController.cs          ← POST register / login (público)
        │   │   ├── EnrollmentsController.cs
        │   │   ├── InstitutionsController.cs
        │   │   ├── ProgramsController.cs      ← CRUD + compare + planning endpoints
        │   │   └── SubjectsController.cs
        │   ├── Extensions/SwaggerExtensions.cs
        │   ├── Middleware/GlobalExceptionHandlingMiddleware.cs
        │   └── Program.cs
        │
        ├── SyllabusTrack.Tests/               ← 126 testes unitários
        ├── SyllabusTrack.Specs/               ← 52 specs BDD / Gherkin
        └── SyllabusTrack.ArchTests/           ← 31 testes de arquitetura (NetArchTest)
            ├── ArchTestBase.cs
            ├── LayerDependencyTests.cs
            ├── DomainRulesTests.cs
            ├── ApplicationRulesTests.cs
            ├── InfrastructureRulesTests.cs
            └── ApiRulesTests.cs
```

---

## Padrões e Princípios

### Domain-Driven Design (DDD)

- **Aggregate Roots**: `EducationalInstitution`, `DegreeProgram`, `StudentAccount`, `StudentEnrollment`.
- **Entities**: `AcademicSubject`, `StudentProgress`.
- **Value Objects**: `Email`, `Grade`, `PhoneNumber` — imutáveis, validação via `Create()`, retornam `Result<T>`.
- **Rich Domain Model**: setters `private`; estado alterado apenas pelos métodos da entidade.
- **Inversão de Dependência**: interfaces no Domain, implementações na Infrastructure.

### CQRS com MediatR

```
Command → altera estado   → Result / Result<int>
Query   → lê dados        → Result<TResponse>
```

Cada caso de uso tem pasta isolada: `Command/Query + Handler + Validator`.

Features de leitura complexa (`CourseComparison`, `AcademicPlanning`, `MultiplePlanning`, `MultipleTargetsPlanning`) usam **repositório próprio com `SqlQuery<T>`** em vez de entidades EF — sem Command/Query tradicional para escrita, apenas Query.

### Result Pattern

```csharp
// Sem exceções para controle de fluxo de negócio
return Result.Failure<int>(new Error("Institution.EmptyName", "Institution name is required."));
return Result.Success(entity.Id);

// No controller
if (result.IsFailure)
    return BadRequest(new ProblemDetails { Detail = result.Error.Message });
```

### EF Core 9 — SqlQuery<T>

Features de análise usam `dbContext.Database.SqlQuery<TRow>($"...")` com interpolação segura do EF Core (parametrizado automaticamente):

```csharp
// ✅ CORRETO — sem ORDER BY (EF Core 9 envolve em subquery; SQL Server rejeita ORDER BY)
var rows = await dbContext.Database
    .SqlQuery<SubjectRow>($"""
        SELECT s.SubjectName, s.TotalSubjectHours AS Hours, t.TermNumber
        FROM   AcademicTerm t
        JOIN   CourseModule m  ON m.TermId   = t.TermId
        JOIN   AcademicSubject s ON s.ModuleId = m.ModuleId
        WHERE  t.ProgramId = {programId}
        """)
    .ToListAsync(ct);

// Ordenação sempre em C# depois do ToListAsync()
var ordered = rows.GroupBy(r => r.TermNumber).OrderBy(g => g.Key);

// ❌ ERRADO — causa "ORDER BY clause is invalid in views, inline functions..."
// ORDER BY t.TermNumber  ← nunca dentro de SqlQuery<T>
```

### Repository + Unit of Work

- `AsNoTracking()` **apenas** em leituras puras; nunca em métodos usados para update.
- `IUnitOfWork.CommitAsync()` persiste atomicamente.
- Soft delete: `entity.Deactivate()` → `IsActive = false`.

### Testes de Arquitetura (NetArchTest)

As fronteiras DDD são verificadas automaticamente a cada push. Qualquer violação quebra o CI antes de chegar ao merge:

```
Domain   → não pode depender de Application / Infrastructure / API
Application → não pode depender de Infrastructure / API
Infrastructure → não pode depender de API
Entidades → sealed, private setters, herdam Entity/AggregateRoot
Value Objects → sealed, herdam ValueObject
Repositórios Domain → interfaces (prefixo I)
Repositórios Infrastructure → sealed, terminam em "Repository"
Configurations → sealed, terminam em "Configuration", implementam IEntityTypeConfiguration<T>
Controllers → herdam ApiController, terminam em "Controller", têm [ApiController]
```

---

## API — Endpoints

### Autenticação (público)

```
POST /api/auth/register   → { studentId }
POST /api/auth/login      → { token }
```

### Instituições `[Authorize]`

```
GET  /api/institutions         → Lista ativas
GET  /api/institutions/{id}
POST /api/institutions         → { institutionId }
PUT  /api/institutions/{id}
```

### Cursos `[Authorize]`

```
GET  /api/programs             → Lista ativos
GET  /api/programs/{id}
POST /api/programs             → { programId }
PUT  /api/programs/{id}

GET  /api/programs/{sourceId}/compare/{targetId}
     → CourseComparisonResponse (percentual de aproveitamento 1→1)

GET  /api/programs/{sourceId}/planning/{targetId}
     → AcademicPlanningResponse (plano semestral 1→1)

POST /api/programs/planning/multiple
     Body: { sourceProgramIds: int[], targetProgramId: int }
     → MultiplePlanningResponse (plano N fontes → 1 alvo)

POST /api/programs/planning/multiple-targets
     Body: { sourceProgramIds: int[], targetProgramIds: int[] }
     → MultipleTargetsPlanningResponse (plano N fontes → N alvos com plano consolidado)
```

### Disciplinas `[Authorize]`

```
POST /api/subjects             → { subjectId }
```

### Matrículas e Progresso `[Authorize]`

```
GET  /api/enrollments/student/{studentId}
POST /api/enrollments                          → { enrollmentId }
POST /api/enrollments/{enrollmentId}/progress
```

### Respostas de Erro Padronizadas

| Status | Situação |
|---|---|
| 400 | Regra de negócio, validação FluentValidation |
| 401 | Não autenticado |
| 404 | Recurso não encontrado |
| 422 | Validação de payload |
| 500 | Erro interno não tratado |

---

## Dados de Seed

| Arquivo | Conteúdo |
|---|---|
| `SeedData.sql` | **UnirG**: Medicina (Matriz Nº 5, 12 semestres, ~90 disciplinas) · **FAM EAD**: 19 cursos (ADS, BD, Sistemas para Internet, Gestão de TI, Redes, Ciência da Computação, Engenharia, ADM, Logística, RH, Marketing, etc.) |
| `Seed_FAM_Psicologia_Farmacia.sql` | **FAM**: Psicologia (10 semestres, 4036h) + Farmácia (8 semestres, 4000h) |
| `Seed_RodrigoMadeira.sql` | Histórico acadêmico completo do estudante Rodrigo Madeira nos cursos ADS e BD da FAM (matrículas + 46 registros de progresso) |
| `Cleanup_All.sql` | Remove todas as instituições e seus dados em cascata, respeitando a ordem de FK. Executar antes de re-rodar os seeds. |

### Ordem de execução dos scripts

```sql
-- 1. Estrutura do banco (apenas na primeira vez ou após drop)
Sql/MasterScript.sql

-- 2. Limpar dados existentes (quando for reexecutar seeds)
Sql/Cleanup_All.sql

-- 3. Seed principal (UnirG + FAM EAD 19 cursos)
Sql/SeedData.sql

-- 4. Seed Psicologia + Farmácia
Sql/Seed_FAM_Psicologia_Farmacia.sql

-- 5. Histórico do estudante (após os seeds de cursos)
Sql/Seed_RodrigoMadeira.sql
```

---

## Como Executar

### Pré-requisitos

| Ferramenta | Versão mínima |
|---|---|
| .NET SDK | 9.0 |
| SQL Server | 2019+ (ou Express / LocalDB) |
| Node.js | 18+ |

### Backend

**1. Configurar o banco**

Execute os scripts SQL na ordem descrita na seção anterior.

**2. Ajustar `appsettings.json`**

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=SyllabusTrackDb;Trusted_Connection=True;TrustServerCertificate=True;"
  },
  "Jwt": {
    "Issuer": "SyllabusTrack.API",
    "Audience": "SyllabusTrack.Client",
    "SecretKey": "SUA_CHAVE_SECRETA_COM_NO_MINIMO_32_CARACTERES",
    "ExpirationMinutes": 60
  }
}
```

**3. Rodar a API**

```bash
cd BackEnd/SyllabusTrack
dotnet run --project SyllabusTrack.API
```

Swagger UI sobe na raiz. Use `POST /api/auth/register` + `POST /api/auth/login` para obter o token e clique em **Authorize**.

### Frontend

```bash
cd FrontEnd
npm install
npm run dev
```

A aplicação sobe em `http://localhost:5173` por padrão.

### Testes

```bash
cd BackEnd/SyllabusTrack

# Todos os projetos
dotnet test

# Por projeto
dotnet test SyllabusTrack.Tests       # 126 testes unitários
dotnet test SyllabusTrack.Specs       # 52 specs BDD
dotnet test SyllabusTrack.ArchTests   # 31 testes de arquitetura
```

---

## Decisões Arquiteturais

| Decisão | Justificativa |
|---|---|
| **Clean Architecture** | Isolamento de responsabilidades; Domain sem dependências externas |
| **CQRS com MediatR** | Commands e Queries claramente separados; pipeline behaviors centralizam log e validação |
| **Result Pattern** | Erros de negócio explícitos no tipo de retorno; sem `try/catch` espalhado |
| **SqlQuery\<T\> para análise de currículo** | Planejamento e comparação envolvem JOINs complexos entre tabelas sem entidade EF (`AcademicTerm`, `CourseModule`); raw SQL é mais legível e eficiente |
| **Sem ORDER BY em SqlQuery\<T\>** | EF Core 9 envolve a query em subquery; SQL Server rejeita `ORDER BY` em subqueries sem `TOP`/`OFFSET`. Ordenação sempre em C# após `ToListAsync()` |
| **HashSet para UNION de disciplinas** | N consultas parametrizadas (uma por fonte) + union em memória via `HashSet<string>` — seguro contra SQL injection, O(1) por lookup |
| **Plano consolidado no frontend** | Deduplicação entre alvos é computada em memória a partir dos dados já retornados pela API — sem round-trip extra |
| **Value Objects para Email e Grade** | Centraliza validação; dados inválidos nunca chegam ao banco |
| **`AsNoTracking()` apenas em leituras** | Repositórios usados em update precisam que o EF rastreie a entidade |
| **`OnDelete(Restrict)` entre aggregates** | FKs entre aggregates distintos nunca fazem cascade delete automático |
| **`OnDelete(Cascade)` em coleções próprias** | `StudentEnrollment → StudentProgress` pertence ao enrollment |
| **Soft delete universal** | `IsActive = 0`; dados históricos preservados |
| **Índices explícitos em FKs** | SQL Server não cria índices nas FKs automaticamente |
| **BCrypt workFactor 12** | Equilíbrio entre segurança e performance |
| **useMutation para POST de consulta** | Endpoints de planejamento são POST (body complexo) mas retornam dados; `useMutation` é mais adequado que `useQuery` para disparo manual |
| **CORS aberto em dev** | `AllowAnyOrigin` apenas em desenvolvimento — restringir por origin em produção |
| **NetArchTest.Rules para arquitetura** | Regras DDD verificadas automaticamente no CI — nenhum PR pode quebrar as fronteiras de camada sem o CI reportar |

---

*Projeto desenvolvido com foco em qualidade de código, testabilidade e aderência às melhores práticas dos ecossistemas .NET e React.*
