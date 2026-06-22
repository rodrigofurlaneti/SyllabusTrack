# SyllabusTrack.Domain

Esta é a camada central (Core) do projeto **SyllabusTrack**, baseada nos princípios de Clean Architecture e Domain-Driven Design (DDD).

## ⚠️ Regra de Ouro
**Nenhum pacote externo** (como Entity Framework, MediatR, etc.) deve ser instalado nesta camada. O Domínio não conhece banco de dados, APIs ou frameworks. Ele contém apenas código C# puro com as regras de negócio.

---

## 📁 Estrutura de Pastas e Arquivos

Seu projeto deve estar organizado exatamente assim:

```text
SyllabusTrack.Domain/
│
├── SyllabusTrack.Domain.csproj
│
├── Primitives/
│   ├── AggregateRoot.cs       # Classe base para raízes de agregação
│   ├── Entity.cs              # Classe base para entidades com identidade (Id)
│   ├── IDomainEvent.cs        # Interface marcadora para eventos de domínio
│   └── ValueObject.cs         # Classe base para objetos imutáveis
│
├── Shared/
│   ├── Error.cs               # Estrutura de erros padronizada (Code, Message)
│   └── Result.cs              # Padrão Result (Substitui o uso de throw/Exceptions)
│
├── ValueObjects/
│   ├── Email.cs               # Objeto de valor para e-mail com validação embutida
│   ├── Grade.cs               # Objeto de valor para notas (0.00 a 10.00)
│   └── PhoneNumber.cs         # Objeto de valor para telefones
│
├── Entities/
│   ├── AcademicSubject.cs         # Disciplina/Matéria (Filha de CourseModule/DegreeProgram)
│   ├── DegreeProgram.cs           # O Curso (Ex: Medicina)
│   ├── EducationalInstitution.cs  # A Instituição (Ex: UnirG)
│   ├── StudentAccount.cs          # Cadastro de Acesso do Estudante
│   ├── StudentEnrollment.cs       # Matrícula do Estudante em um Curso
│   └── StudentProgress.cs         # Relação de notas e status das matérias cursadas
│
└── Repositories/
    ├── IDegreeProgramRepository.cs
    ├── IEducationalInstitutionRepository.cs
    ├── IStudentAccountRepository.cs
    ├── IStudentEnrollmentRepository.cs
    └── IUnitOfWork.cs         # Padrão Unit of Work para transações atômicas

```

## 📐 Padrões Aplicados

### Rich Domain Model: As entidades não são apenas "sacos de dados" (getters e setters públicos). Todos os modificadores de estado (set) são private. A única forma de alterar uma entidade é através de seus próprios métodos.

### Fail Fast & Object Calisthenics: Ausência de else. O código valida os erros primeiro e retorna cedo utilizando o padrão Result.

### Inversão de Dependência: As interfaces de repositórios vivem aqui, mas a implementação viverá na camada de Infrastructure. O Domínio dita as regras, a Infraestrutura obedece.

# SyllabusTrack.Application

Camada responsável pelos Casos de Uso (Use Cases) e lógica de aplicação, utilizando o padrão CQRS com MediatR.

## 📁 Estrutura de Pastas

```text
SyllabusTrack.Application/
│
├── Abstractions/
│   ├── Authentication/
│   │   ├── IJwtProvider.cs
│   │   └── IPasswordHasher.cs
│   └── Messaging/
│       ├── ICommand.cs
│       └── IQuery.cs
│
├── Behaviors/
│   ├── LoggingBehavior.cs
│   └── ValidationBehavior.cs
│
├── Features/
│   └── Auth/
│       ├── Login/
│       │   ├── LoginStudentQuery.cs
│       │   ├── LoginStudentQueryHandler.cs
│       │   └── LoginStudentQueryValidator.cs (Crie depois, se necessário)
│       └── Register/
│           ├── RegisterStudentCommand.cs
│           ├── RegisterStudentCommandHandler.cs
│           └── RegisterStudentCommandValidator.cs
│
└── DependencyInjection.cs
```
---