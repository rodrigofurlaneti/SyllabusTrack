using SyllabusTrack.Application.Abstractions.Messaging;

namespace SyllabusTrack.Application.Features.Auth.Login
{
    public sealed record LoginStudentQuery(string EmailOrUsername, string Password) : IQuery<string>; // Retorna o Token JWT
}
