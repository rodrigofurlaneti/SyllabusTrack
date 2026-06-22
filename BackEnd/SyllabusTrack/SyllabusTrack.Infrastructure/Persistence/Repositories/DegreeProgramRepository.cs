using Microsoft.EntityFrameworkCore;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.Repositories;

namespace SyllabusTrack.Infrastructure.Persistence.Repositories;

internal sealed class DegreeProgramRepository(AppDbContext dbContext) : IDegreeProgramRepository
{
    public async Task AddAsync(DegreeProgram program, CancellationToken cancellationToken = default)
        => await dbContext.DegreePrograms.AddAsync(program, cancellationToken);

    // Sem AsNoTracking — entidade será modificada (update) e precisa ser rastreada pelo EF Core
    public async Task<DegreeProgram?> GetByIdWithSyllabusAsync(int id, CancellationToken cancellationToken = default)
        => await dbContext.DegreePrograms
            .FirstOrDefaultAsync(p => p.Id == id && p.IsActive, cancellationToken);

    public async Task<IEnumerable<DegreeProgram>> GetAllActiveAsync(CancellationToken cancellationToken = default)
        => await dbContext.DegreePrograms
            .AsNoTracking()
            .Where(p => p.IsActive)
            .ToListAsync(cancellationToken);
}
