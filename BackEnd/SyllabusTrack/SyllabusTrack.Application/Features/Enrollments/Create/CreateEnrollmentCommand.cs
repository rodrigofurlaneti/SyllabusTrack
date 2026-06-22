using SyllabusTrack.Application.Abstractions.Messaging;
namespace SyllabusTrack.Application.Features.Enrollments.Create
{
    public sealed record CreateEnrollmentCommand(
        int StudentId,
        int ProgramId) : ICommand<int>;
}
