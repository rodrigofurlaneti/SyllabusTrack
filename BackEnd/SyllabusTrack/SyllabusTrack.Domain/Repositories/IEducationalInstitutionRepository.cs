using SyllabusTrack.Domain.Entities;

namespace SyllabusTrack.Domain.Repositories
{
    public interface IEducationalInstitutionRepository
    {
        Task AddAsync(EducationalInstitution institution, CancellationToken cancellationToken = default);
        Task<EducationalInstitution?> GetByIdAsync(int id, CancellationToken cancellationToken = default);
        Task<IEnumerable<EducationalInstitution>> GetAllActiveAsync(CancellationToken cancellationToken = default);
    }
}
