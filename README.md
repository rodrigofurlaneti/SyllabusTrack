# SyllabusTrack

**SyllabusTrack** é uma plataforma fullstack para acompanhamento de grade curricular e progresso acadêmico de estudantes de medicina, desenvolvida com as melhores práticas de arquitetura de software.

---

## Índice

- [Visão Geral](#visão-geral)
- [Stack Tecnológica](#stack-tecnológica)
- [Arquitetura](#arquitetura)
- [Modelagem de Dados](#modelagem-de-dados)
- [Estrutura de Pastas](#estrutura-de-pastas)
- [Padrões e Princípios](#padrões-e-princípios)
- [Camadas da API](#camadas-da-api)
- [Testes](#testes)
- [Como Executar](#como-executar)
- [Decisões Arquiteturais](#decisões-arquiteturais)

---

## Visão Geral

O **SyllabusTrack** é uma plataforma que permite:

- **Gestão de Instituições e Cursos**: cadastro de instituições de ensino e seus respectivos cursos com versionamento de grade curricular.
- **Grade Curricular Completa**: estrutura hierárquica de Curso → Período Acadêmico → Módulo → Disciplina, com carga horária detalhada (teórica, prática, estágio etc.) e pré-requisitos entre disciplinas.
- **Matrícula de Estudantes**: vinculação de estudantes a um curso com controle de status de matrícula.
- **Acompanhamento de Progresso**: registro do status de cada disciplina cursada (Pendente, Em Andamento, Concluída, Reprovada) com nota final e semestre cursado.
- **Autenticação JWT**: cadastro e login de estudantes com tokens seguros e senhas armazenadas com hash BCrypt.

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
| **NSubstitute** | Mocks e stubs |
| **Reqnroll** | BDD / Gherkin |

### Frontend (planejado)

| Tecnologia | Versão | Uso |
|---|---|---|
| **React** | 19 | Framework de UI |
| **TypeScript** | — | Tipagem estática |
| **Vite** | — | Build tool + HMR |
| **React Router** | 7 | Roteamento SPA |
| **TanStack Query** | 5 | Server state e cache |
| **Zustand** | 5 | Client state (auth) |
| **React Hook Form** | 7 | Formulários |
| **Zod** | — | Validação de schemas |
| **Axios** | — | HTTP client + interceptors JWT |

### Banco de Dados (SQL)

| Arquivo | Conteúdo |
|---|---|
| `Sql/MasterScript.sql` | DDL: tabelas, índices e stored procedures |
| `Sql/SeedData.sql` | Grade curricular real de Medicina — UnirG (Matriz Nº 5, 12 períodos, ~90 disciplinas) |

---

## Arquitetura

O projeto segue **Clean Architecture** com separação estrita de responsabilidades em 4 camadas. As dependências fluem de fora para dentro — **nunca** o contrário.

```
┌─────────────────────────────────────────────┐
│                    API                      │  ← Apresentação (Controllers, Middleware)
├─────────────────────────────────────────────┤
│              Infrastructure                 │  ← Dados (EF Core, JWT, BCrypt)
├─────────────────────────────────────────────┤
│               Application                  │  ← Casos de uso (CQRS, Validação, Pipeline)
├─────────────────────────────────────────────┤
│                 Domain                      │  ← Núcleo do negócio (Entidades, Regras)
└─────────────────────────────────────────────┘

Fluxo de dependência:
  API → Infrastructure → Application → Domain
  Domain não conhece nenhuma outra camada.
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
    ├── LoggingBehavior    (log entrada/saída)
    └── ValidationBehavior (FluentValidation)
         │
         ▼
    CommandHandler / QueryHandler (Application)
         │  IRepository / IUnitOfWork
         ▼
    Repository (Infrastructure / EF Core)
         │
         ▼
    SQL Server (SyllabusTrackDb)
```

---

## Modelagem de Dados

### Hierarquia do Currículo

```
EducationalInstitution  (InstitutionId PK)
│   InstitutionName     VARCHAR(255)
│   InstitutionAcronym  VARCHAR(50)
│   CampusLocation      VARCHAR(255)
│   IsActive            BIT
│
└── DegreeProgram       (ProgramId PK, InstitutionId FK)
    │   ProgramName         VARCHAR(255)   ← Ex: "Medicina"
    │   CurriculumVersion   VARCHAR(100)   ← Ex: "Matriz Curricular Nº 5"
    │   TotalSemesters      INT            ← Ex: 12
    │   IsActive            BIT
    │
    └── AcademicTerm    (TermId PK, ProgramId FK)
        │   TermNumber       INT           ← 1 a 12
        │   TermDescription  VARCHAR(100)
        │
        └── CourseModule (ModuleId PK, TermId FK)
            │   ModuleCode   VARCHAR(50)   ← Ex: "63013161"
            │   ModuleName   VARCHAR(255)
            │
            └── AcademicSubject (SubjectId PK, ModuleId FK)
                    SubjectCode       VARCHAR(50)
                    SubjectName       VARCHAR(255)
                    SubjectCredits    INT
                    TheoreticalHours  INT
                    PracticalHours    INT
                    StudyGroupHours   INT
                    ExtensionHours    INT
                    InternshipHours   INT
                    TotalSubjectHours INT
                    IsOptional        BIT

SubjectPrerequisite (TargetSubjectId FK, RequiredSubjectId FK)
```

### Estudantes e Matrícula

```
StudentAccount      (StudentId PK)
│   StudentFullName  VARCHAR(255)
│   LoginUsername    VARCHAR(50)   UNIQUE
│   EmailAddress     VARCHAR(255)  UNIQUE   ← Value Object Email
│   CellPhoneNumber  VARCHAR(20)
│   AccountPassword  VARCHAR(255)           ← Hash BCrypt — nunca plain text
│   IsActive         BIT
│
└── StudentEnrollment (EnrollmentId PK, StudentId FK, ProgramId FK)
    │   EnrollmentDate    DATE
    │   EnrollmentStatus  VARCHAR(50)   ← "Active"
    │   IsActive          BIT
    │
    └── StudentProgress (ProgressId PK, EnrollmentId FK, SubjectId FK)
            CompletionStatus  VARCHAR(50)    ← "Pending" | "InProgress" | "Completed" | "Failed"
            SemesterTaken     VARCHAR(20)    ← Ex: "2024.1"
            FinalGrade        DECIMAL(5,2)   ← Value Object Grade (0.00 a 10.00)
            IsActive          BIT
```

> **Soft delete:** nenhum `DELETE` físico. Todo registro é desativado com `IsActive = 0`.

> **Campos de auditoria:** todas as tabelas têm `CreatedAt DATETIME` e `UpdatedAt DATETIME`.

> **AcademicTerm e CourseModule** existem no banco mas não têm entidade C# — são gerenciados via SQL/seed. `AcademicSubject` referencia `ModuleId` como `int` simples.

### Stored Procedures

| Procedure | Ações |
|---|---|
| `usp_ManageEducationalInstitution` | I / U / D / S |
| `usp_ManageStudentAccount` | I / U / D / S |
| `usp_AuthenticateStudent` | Busca por email ou username — **sem comparação de senha** (hash BCrypt verificado no C#) |
| `usp_ManageStudentProgress` | I / U / D / S |

---

## Estrutura de Pastas

```
SyllabusTrack/
│
├── Sql/
│   ├── MasterScript.sql          ← DDL: tabelas, índices, stored procedures
│   └── SeedData.sql              ← Currículo real de Medicina UnirG (12 períodos)
│
├── FrontEnd/                     ← React + TypeScript SPA (em desenvolvimento)
│
├── BackEnd/
│   └── SyllabusTrack/
│       ├── SyllabusTrack.sln
│       │
│       ├── SyllabusTrack.Domain/
│       │   ├── Entities/
│       │   │   ├── AcademicSubject.cs          ← Entity
│       │   │   ├── DegreeProgram.cs            ← AggregateRoot
│       │   │   ├── EducationalInstitution.cs   ← AggregateRoot
│       │   │   ├── StudentAccount.cs           ← AggregateRoot
│       │   │   ├── StudentEnrollment.cs        ← AggregateRoot (possui StudentProgress)
│       │   │   └── StudentProgress.cs          ← Entity (filho de StudentEnrollment)
│       │   ├── Primitives/
│       │   │   ├── AggregateRoot.cs
│       │   │   ├── Entity.cs
│       │   │   ├── IDomainEvent.cs
│       │   │   └── ValueObject.cs
│       │   ├── Repositories/
│       │   │   ├── IAcademicSubjectRepository.cs
│       │   │   ├── IDegreeProgramRepository.cs
│       │   │   ├── IEducationalInstitutionRepository.cs
│       │   │   ├── IStudentAccountRepository.cs
│       │   │   ├── IStudentEnrollmentRepository.cs
│       │   │   └── IUnitOfWork.cs
│       │   ├── Shared/
│       │   │   ├── Error.cs
│       │   │   └── Result.cs
│       │   └── ValueObjects/
│       │       ├── Email.cs          ← validação embutida
│       │       ├── Grade.cs          ← decimal 0.00 a 10.00
│       │       └── PhoneNumber.cs
│       │
│       ├── SyllabusTrack.Application/
│       │   ├── Abstractions/
│       │   │   ├── Authentication/
│       │   │   │   ├── IJwtProvider.cs
│       │   │   │   └── IPasswordHasher.cs
│       │   │   ├── Behaviors/
│       │   │   │   ├── LoggingBehavior.cs
│       │   │   │   └── ValidationBehavior.cs
│       │   │   └── Messaging/
│       │   │       ├── ICommand.cs
│       │   │       └── IQuery.cs
│       │   ├── Features/
│       │   │   ├── AcademicSubjects/
│       │   │   │   └── Create/   ← Command + Handler + Validator
│       │   │   ├── Auth/
│       │   │   │   ├── Login/    ← Query + Handler
│       │   │   │   └── Register/ ← Command + Handler + Validator
│       │   │   ├── DegreePrograms/
│       │   │   │   ├── Create/ GetAll/ GetById/ Update/
│       │   │   │   └── ProgramResponse.cs
│       │   │   ├── Enrollments/
│       │   │   │   ├── AddProgress/ Create/ GetByStudent/
│       │   │   │   ├── EnrollmentResponse.cs
│       │   │   │   └── ProgressResponse.cs
│       │   │   └── Institutions/
│       │   │       ├── Create/ GetAll/ GetById/ Update/
│       │   │       └── InstitutionResponse.cs
│       │   └── DependencyInjection.cs
│       │
│       ├── SyllabusTrack.Infrastructure/
│       │   ├── DependencyInjection/
│       │   │   └── DependencyInjection.cs
│       │   ├── Persistence/
│       │   │   ├── AppDbContext.cs
│       │   │   ├── Configurations/
│       │   │   │   ├── AcademicSubjectConfiguration.cs
│       │   │   │   ├── DegreeProgramConfiguration.cs
│       │   │   │   ├── EducationalInstitutionConfiguration.cs
│       │   │   │   ├── StudentAccountConfiguration.cs
│       │   │   │   ├── StudentEnrollmentConfiguration.cs
│       │   │   │   └── StudentProgressConfiguration.cs
│       │   │   ├── Repositories/
│       │   │   │   ├── AcademicSubjectRepository.cs
│       │   │   │   ├── DegreeProgramRepository.cs
│       │   │   │   ├── EducationalInstitutionRepository.cs
│       │   │   │   ├── StudentAccountRepository.cs
│       │   │   │   └── StudentEnrollmentRepository.cs
│       │   │   └── UnitOfWork.cs
│       │   └── Security/
│       │       ├── JwtOptions.cs
│       │       ├── JwtProvider.cs
│       │       └── PasswordHasher.cs
│       │
│       └── SyllabusTrack.API/
│           ├── Controllers/
│           │   ├── ApiController.cs           ← HandleResult<T> helper base
│           │   ├── AuthController.cs          ← POST register / login (público)
│           │   ├── EnrollmentsController.cs   ← CRUD matrículas e progresso
│           │   ├── InstitutionsController.cs  ← CRUD instituições
│           │   ├── ProgramsController.cs      ← CRUD cursos
│           │   └── SubjectsController.cs      ← POST disciplinas
│           ├── Extensions/
│           │   └── SwaggerExtensions.cs       ← Swagger + JWT Bearer
│           ├── Middleware/
│           │   └── GlobalExceptionHandlingMiddleware.cs
│           ├── appsettings.json
│           └── Program.cs
│
└── SKILL.md                      ← Padrões arquiteturais para uso com IA
```

---

## Padrões e Princípios

### Domain-Driven Design (DDD)

- **Aggregate Roots**: `EducationalInstitution`, `DegreeProgram`, `StudentAccount`, `StudentEnrollment` — únicos pontos de entrada para mutação de estado.
- **Entities**: `AcademicSubject`, `StudentProgress` — têm identidade mas pertencem a um aggregate.
- **Value Objects**: `Email`, `Grade`, `PhoneNumber` — imutáveis, igualdade por valor, validação embutida via `Create()`.
- **Rich Domain Model**: setters `private` em todas as propriedades; estado alterado apenas pelos próprios métodos da entidade.
- **Inversão de Dependência**: interfaces de repositório definidas no Domain, implementadas na Infrastructure.

### CQRS com MediatR

```
Command → altera estado   → retorna Result (void) ou Result<int> (ID criado)
Query   → lê dados        → retorna Result<TResponse> com DTO
```

Cada caso de uso tem pasta isolada com `Command/Query + Handler + Validator`.

### Result Pattern (Railway-Oriented)

Sem exceções para controle de fluxo:

```csharp
// Falha de negócio — nunca throw em handlers
return Result.Failure<int>(new Error("Institution.EmptyName", "Institution name is required."));

// Verificação no handler
if (result.IsFailure)
    return Result.Failure<int>(result.Error);

// No controller
if (result.IsFailure)
    return BadRequest(new ProblemDetails { Detail = result.Error.Message });
```

### Interfaces de Messaging

```csharp
ICommand                        // Command sem retorno → Result
ICommand<TResponse>             // Command com retorno → Result<TResponse>
ICommandHandler<TCommand>       // Handler sem retorno
ICommandHandler<TCommand, T>    // Handler com retorno
IQuery<TResponse>               // Query sempre tem retorno
IQueryHandler<TQuery, TResponse>
```

> **Atenção:** todo arquivo `XxxCommand.cs` ou `XxxQuery.cs` deve ter `using SyllabusTrack.Application.Abstractions.Messaging;` — sem ele, `ICommand` e `IQuery` não são resolvidos pelo compilador.

### Repository + Unit of Work

- `AsNoTracking()` **apenas** em leituras puras; nunca em métodos usados para update.
- `IUnitOfWork.CommitAsync()` persiste tudo atomicamente.
- Soft delete: `entity.Deactivate()` → `IsActive = false` → `CommitAsync()`.

### SOLID

| Princípio | Aplicação |
|---|---|
| **S**ingle Responsibility | Cada handler tem um único caso de uso |
| **O**pen/Closed | Novos comportamentos via novos handlers, sem alterar existentes |
| **L**iskov Substitution | Repositórios concretos substituem as interfaces sem quebrar contratos |
| **I**nterface Segregation | `IRepository` por aggregate + `IUnitOfWork` separados |
| **D**ependency Inversion | Application depende de interfaces; Infrastructure implementa |

---

## Camadas da API

### Autenticação (público)

```
POST /api/auth/register   → Cadastra novo estudante → { studentId }
POST /api/auth/login      → Autentica credenciais   → { token }
```

### Instituições (requer JWT)

```
GET    /api/institutions         → Lista todas as instituições ativas
GET    /api/institutions/{id}    → Busca instituição por ID
POST   /api/institutions         → Cria nova instituição → { institutionId }
PUT    /api/institutions/{id}    → Atualiza nome, sigla e localização
```

### Cursos (requer JWT)

```
GET    /api/programs             → Lista todos os cursos ativos
GET    /api/programs/{id}        → Busca curso por ID
POST   /api/programs             → Cria novo curso (vincula à instituição) → { programId }
PUT    /api/programs/{id}        → Atualiza nome, versão e total de semestres
```

### Disciplinas (requer JWT)

```
POST   /api/subjects             → Cria nova disciplina (vincula ao módulo via ModuleId) → { subjectId }
```

### Matrículas e Progresso (requer JWT)

```
GET    /api/enrollments/student/{studentId}       → Matrículas do estudante com progresso completo
POST   /api/enrollments                           → Matricula estudante em um curso → { enrollmentId }
POST   /api/enrollments/{enrollmentId}/progress   → Registra progresso de uma disciplina
```

### Respostas de Erro Padronizadas

| Situação | Status | Formato |
|---|---|---|
| Validação FluentValidation | 422 | `{ title, detail }` |
| Regra de negócio | 400 | `{ title, detail, extensions.code }` |
| Não encontrado | 404 | `{ title, detail, extensions.code }` |
| Não autorizado | 401 | `{ title, detail, extensions.code }` |
| Erro interno | 500 | `{ title, detail }` |

---

## Testes

### Estratégia BDD com Reqnroll

Testes escritos como feature files Gherkin, testando a camada Application em isolamento com NSubstitute — sem banco de dados real, sem WebApplicationFactory.

```gherkin
Feature: Cadastro de Instituição

  Scenario: Cadastrar com sucesso
    When cadastro a instituição "Fundação UnirG" com sigla "UnirG" e localização "Gurupi"
    Then o cadastro deve ter sucesso e retornar um ID positivo

  Scenario: Rejeitar nome vazio
    When cadastro a instituição "" com sigla "X" e localização "Y"
    Then o cadastro deve falhar com o erro "Institution.EmptyName"

Feature: Login de Estudante

  Scenario: Login com credenciais inválidas
    Given um estudante cadastrado com email "student@unirg.edu.br"
    When realizo login com senha incorreta
    Then o login deve falhar com o erro "Auth.InvalidCredentials"

Feature: Progresso Acadêmico

  Scenario: Rejeitar disciplina já concluída
    Given uma matrícula com a disciplina 42 com status "Completed"
    When adiciono progresso para a disciplina 42 novamente
    Then deve falhar com o erro "Enrollment.SubjectAlreadyCompleted"
```

### O que é testado

| Escopo | Ferramenta |
|---|---|
| Handlers de Command e Query | xUnit + NSubstitute + FluentAssertions |
| Validators FluentValidation | xUnit |
| Factories de entidades (regras de domínio) | via testes de handler |
| Pipeline behaviors | xUnit |

### O que não é testado (decisão pragmática)

- Repositórios EF Core (sem banco de dados de teste)
- Controllers (sem WebApplicationFactory)
- Infraestrutura de segurança (JWT, BCrypt)

### Executar os testes

```bash
cd BackEnd/SyllabusTrack
dotnet test
```

---

## Como Executar

### Pré-requisitos

| Ferramenta | Versão mínima |
|---|---|
| .NET SDK | 9.0 |
| SQL Server | 2019+ (ou SQL Server Express / LocalDB) |
| Node.js | 18+ (para o frontend) |

---

### Backend

#### 1. Configurar o banco de dados

Execute os scripts no SQL Server Management Studio ou Azure Data Studio:

```sql
-- 1. Cria banco, tabelas, índices e stored procedures
Sql/MasterScript.sql

-- 2. Popula com o currículo real de Medicina da UnirG (Matriz Nº 5, 12 períodos)
Sql/SeedData.sql
```

#### 2. Ajustar `appsettings.json`

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

#### 3. Rodar a API

```bash
cd BackEnd/SyllabusTrack
dotnet run --project SyllabusTrack.API
```

O **Swagger UI** sobe na raiz da API. Use `POST /api/auth/register` para criar um estudante, `POST /api/auth/login` para obter o token JWT e clique em **Authorize** para autenticar as demais rotas.

---

## Decisões Arquiteturais

| Decisão | Justificativa |
|---|---|
| **PK como `INT IDENTITY`** | Mais simples e performático para o modelo relacional hierárquico do currículo |
| **Result Pattern** | Erros de negócio explícitos no tipo de retorno; sem `try/catch` espalhado pelos handlers |
| **Value Objects para Email e Grade** | Centraliza validação; dados inválidos nunca chegam ao banco |
| **`AsNoTracking()` apenas em leituras puras** | Repositórios usados em update precisam que o EF rastreie a entidade para detectar mudanças |
| **`OnDelete(Restrict)` entre aggregates** | FKs entre aggregates distintos nunca fazem cascade delete automático |
| **`OnDelete(Cascade)` em coleções próprias** | `StudentEnrollment → StudentProgress`: progresso pertence ao enrollment |
| **AcademicTerm e CourseModule sem entidade C#** | São tabelas de suporte ao seed; `AcademicSubject` referencia `ModuleId` como `int` simples |
| **BCrypt workFactor 12** | Equilíbrio entre segurança e performance em hardware moderno |
| **usp_AuthenticateStudent sem comparação de senha** | Hash BCrypt não pode ser comparado no SQL — verificação feita via `IPasswordHasher.Verify()` no C# |
| **Índices explícitos em todas as FKs** | SQL Server não cria índices nas FKs automaticamente; sem eles JOINs fazem table scan |
| **Reqnroll para BDD** | Testes legíveis como especificação viva; isola Application sem banco de dados |
| **Swagger com JWT embutido** | Facilita testes manuais durante o desenvolvimento sem ferramentas externas |
| **CORS aberto em dev** | `AllowAnyOrigin` apenas em desenvolvimento — restringir por origin em produção |

---

*Projeto desenvolvido com foco em qualidade de código, testabilidade e aderência às melhores práticas dos ecossistemas .NET e React.*
