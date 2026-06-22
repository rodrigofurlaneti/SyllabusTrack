using SyllabusTrack.Application.Abstractions.Messaging;
namespace SyllabusTrack.Application.Features.Auth.Register
{
    public sealed record RegisterStudentCommand(
        string FullName,
        string Username,
        string Email,
        string PhoneNumber,
        string Password) : ICommand<int>; // Retorna o ID do novo usuário
}
