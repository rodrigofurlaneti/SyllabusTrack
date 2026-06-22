using SyllabusTrack.Domain.Entities;
namespace SyllabusTrack.Domain.Repositories
{
    public interface IStudentEnrollmentRepository
    {
        Task AddAsync(StudentEnrollment enrollment, CancellationToken cancellationToken = default);
        Task<StudentEnrollment?> GetByIdWithProgressAsync(int id, CancellationToken cancellationToken = default);
        Task<IEnumerable<StudentEnrollment>> GetByStudentIdAsync(int studentId, CancellationToken cancellationToken = default);
    }
}
