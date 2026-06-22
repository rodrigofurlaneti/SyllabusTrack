using Microsoft.EntityFrameworkCore;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.Repositories;

namespace SyllabusTrack.Infrastructure.Persistence.Repositories;

internal sealed class StudentEnrollmentRepository(AppDbContext dbContext) : IStudentEnrollmentRepository
{
    public async Task AddAsync(StudentEnrollment enrollment, CancellationToken cancellationToken = default)
        => await dbContext.StudentEnrollments.AddAsync(enrollment, cancellationToken);

    public async Task<StudentEnrollment?> GetByIdWithProgressAsync(int id, CancellationToken cancellationToken = default)
        => await dbContext.StudentEnrollments
            .Include(e => e.Progresses)
            .FirstOrDefaultAsync(e => e.Id == id && e.IsActive, cancellationToken);

    public async Task<IEnumerable<StudentEnrollment>> GetByStudentIdAsync(int studentId, CancellationToken cancellationToken = default)
        => await dbContext.StudentEnrollments
            .AsNoTracking()
            .Include(e => e.Progresses)
                .ThenInclude(p => p.Subject)
            .Where(e => e.StudentId == studentId && e.IsActive)
            .ToListAsync(cancellationToken);
}
