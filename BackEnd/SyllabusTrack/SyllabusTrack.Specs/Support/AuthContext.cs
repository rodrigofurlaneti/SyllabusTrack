using Moq;
using SyllabusTrack.Application.Abstractions.Authentication;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.Specs.Support;

/// <summary>
/// Shared state for Auth (Register + Login) scenarios.
/// Injected by Reqnroll's DI container into step definition classes.
/// </summary>
public sealed class AuthContext
{
    // ── Mocks ────────────────────────────────────────────────────────────────
    public Mock<IStudentAccountRepository> RepoMock    { get; } = new();
    public Mock<IPasswordHasher>           HasherMock  { get; } = new();
    public Mock<IUnitOfWork>               UowMock     { get; } = new();
    public Mock<IJwtProvider>              JwtMock     { get; } = new();

    // ── Registration results ─────────────────────────────────────────────────
    public Result<int>?    RegisterResult { get; set; }

    // ── Login results ────────────────────────────────────────────────────────
    public Result<string>? LoginResult    { get; set; }
}
