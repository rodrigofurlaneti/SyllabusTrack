using SyllabusTrack.Domain.Repositories;

namespace SyllabusTrack.Infrastructure.Persistence;

internal sealed class UnitOfWork(AppDbContext dbContext) : IUnitOfWork
{
    public async Task<int> CommitAsync(CancellationToken cancellationToken = default)
        => await dbContext.SaveChangesAsync(cancellationToken);
}
