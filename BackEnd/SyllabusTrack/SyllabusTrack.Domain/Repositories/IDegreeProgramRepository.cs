using SyllabusTrack.Domain.Entities;
namespace SyllabusTrack.Domain.Repositories
{
    public interface IDegreeProgramRepository
    {
        Task AddAsync(DegreeProgram program, CancellationToken cancellationToken = default);
        Task<DegreeProgram?> GetByIdWithSyllabusAsync(int id, CancellationToken cancellationToken = default);
    }
}
