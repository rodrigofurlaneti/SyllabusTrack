using SyllabusTrack.Domain.Entities;

namespace SyllabusTrack.Domain.Repositories
{
    public interface IAcademicSubjectRepository
    {
        Task AddAsync(AcademicSubject subject, CancellationToken cancellationToken = default);
        Task<AcademicSubject?> GetByIdAsync(int id, CancellationToken cancellationToken = default);
        Task<IEnumerable<AcademicSubject>> GetByModuleIdAsync(int moduleId, CancellationToken cancellationToken = default);
    }
}
