// NOTA: Este arquivo substitui o IStudentAccountRepository.cs existente no Domain
// Adicione o método GetByEmailOrUsernameAsync usado no LoginStudentQueryHandler

using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.ValueObjects;

namespace SyllabusTrack.Domain.Repositories
{
    public interface IStudentAccountRepository
    {
        Task AddAsync(StudentAccount student, CancellationToken cancellationToken = default);
        Task<StudentAccount?> GetByIdAsync(int id, CancellationToken cancellationToken = default);
        Task<bool> IsEmailUniqueAsync(Email email, CancellationToken cancellationToken = default);
        Task<bool> IsUsernameUniqueAsync(string username, CancellationToken cancellationToken = default);

        // Adicionado: necessário para LoginStudentQueryHandler
        Task<StudentAccount?> GetByEmailOrUsernameAsync(string identifier, CancellationToken cancellationToken = default);
    }
}
