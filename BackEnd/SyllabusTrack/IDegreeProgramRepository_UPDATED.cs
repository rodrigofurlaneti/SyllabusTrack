// NOTA: Este arquivo substitui o IDegreeProgramRepository.cs existente no Domain
// Adicione o método GetAllActiveAsync que está sendo usado no GetAllProgramsQueryHandler

using SyllabusTrack.Domain.Entities;

namespace SyllabusTrack.Domain.Repositories
{
    public interface IDegreeProgramRepository
    {
        Task AddAsync(DegreeProgram program, CancellationToken cancellationToken = default);
        Task<DegreeProgram?> GetByIdWithSyllabusAsync(int id, CancellationToken cancellationToken = default);

        // Adicionado: necessário para GetAllProgramsQueryHandler
        Task<IEnumerable<DegreeProgram>> GetAllActiveAsync(CancellationToken cancellationToken = default);
    }
}
