using Microsoft.EntityFrameworkCore;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.Repositories;

namespace SyllabusTrack.Infrastructure.Persistence.Repositories;

internal sealed class AcademicSubjectRepository(AppDbContext dbContext) : IAcademicSubjectRepository
{
    public async Task AddAsync(AcademicSubject subject, CancellationToken cancellationToken = default)
        => await dbContext.AcademicSubjects.AddAsync(subject, cancellationToken);

    public async Task<AcademicSubject?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        => await dbContext.AcademicSubjects
            .AsNoTracking()
            .FirstOrDefaultAsync(s => s.Id == id && s.IsActive, cancellationToken);

    public async Task<IEnumerable<AcademicSubject>> GetByModuleIdAsync(int moduleId, CancellationToken cancellationToken = default)
        => await dbContext.AcademicSubjects
            .AsNoTracking()
            .Where(s => s.ModuleId == moduleId && s.IsActive)
            .ToListAsync(cancellationToken);
}
