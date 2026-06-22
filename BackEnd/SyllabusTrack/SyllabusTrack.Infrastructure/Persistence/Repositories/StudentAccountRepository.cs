using Microsoft.EntityFrameworkCore;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Domain.ValueObjects;

namespace SyllabusTrack.Infrastructure.Persistence.Repositories;

internal sealed class StudentAccountRepository(AppDbContext dbContext) : IStudentAccountRepository
{
    public async Task AddAsync(StudentAccount student, CancellationToken cancellationToken = default)
        => await dbContext.StudentAccounts.AddAsync(student, cancellationToken);

    public async Task<StudentAccount?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        => await dbContext.StudentAccounts
            .AsNoTracking()
            .FirstOrDefaultAsync(s => s.Id == id && s.IsActive, cancellationToken);

    public async Task<StudentAccount?> GetByEmailOrUsernameAsync(string identifier, CancellationToken cancellationToken = default)
        => await dbContext.StudentAccounts
            .AsNoTracking()
            .FirstOrDefaultAsync(s =>
                (s.EmailAddress.Value == identifier || s.LoginUsername == identifier) && s.IsActive,
                cancellationToken);

    public async Task<bool> IsEmailUniqueAsync(Email email, CancellationToken cancellationToken = default)
        => !await dbContext.StudentAccounts
            .AsNoTracking()
            .AnyAsync(s => s.EmailAddress.Value == email.Value, cancellationToken);

    public async Task<bool> IsUsernameUniqueAsync(string username, CancellationToken cancellationToken = default)
        => !await dbContext.StudentAccounts
            .AsNoTracking()
            .AnyAsync(s => s.LoginUsername == username, cancellationToken);
}
