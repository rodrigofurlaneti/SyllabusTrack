using SyllabusTrack.Application.Abstractions.Messaging;

namespace SyllabusTrack.Application.Features.Enrollments.AddProgress
{
    public sealed record AddProgressCommand(
        int EnrollmentId,
        int SubjectId,
        string CompletionStatus,
        string SemesterTaken,
        decimal? FinalGrade) : ICommand;
}
