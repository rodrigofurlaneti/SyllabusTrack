using Microsoft.EntityFrameworkCore;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.Repositories;

namespace SyllabusTrack.Infrastructure.Persistence.Repositories;

internal sealed class EducationalInstitutionRepository(AppDbContext dbContext) : IEducationalInstitutionRepository
{
    public async Task AddAsync(EducationalInstitution institution, CancellationToken cancellationToken = default)
        => await dbContext.EducationalInstitutions.AddAsync(institution, cancellationToken);

    // Sem AsNoTracking — entidade será modificada (update) e precisa ser rastreada pelo EF Core
    public async Task<EducationalInstitution?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        => await dbContext.EducationalInstitutions
            .FirstOrDefaultAsync(i => i.Id == id && i.IsActive, cancellationToken);

    public async Task<IEnumerable<EducationalInstitution>> GetAllActiveAsync(CancellationToken cancellationToken = default)
        => await dbContext.EducationalInstitutions
            .AsNoTracking()
            .Where(i => i.IsActive)
            .ToListAsync(cancellationToken);
}
