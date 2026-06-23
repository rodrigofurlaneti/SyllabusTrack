using Moq;
using SyllabusTrack.Application.Features.Institutions;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.Specs.Support;

/// <summary>
/// Shared state for Institution scenarios.
/// </summary>
public sealed class InstitutionContext
{
    public Mock<IEducationalInstitutionRepository> RepoMock { get; } = new();
    public Mock<IUnitOfWork>                       UowMock  { get; } = new();

    // Create / Update results
    public Result<int>?       CreateResult { get; set; }
    public Result?            UpdateResult { get; set; }

    // Query results
    public Result<InstitutionResponse>?                      GetByIdResult  { get; set; }
    public Result<IReadOnlyCollection<InstitutionResponse>>? GetAllResult   { get; set; }

    // Entity that was created/updated (for assertions)
    public EducationalInstitution? CreatedInstitution { get; set; }
}
