using SyllabusTrack.Application.Abstractions.Messaging;
namespace SyllabusTrack.Application.Features.AcademicSubjects.Create
{
    public sealed record CreateSubjectCommand(
        int ModuleId,
        string SubjectCode,
        string SubjectName,
        int SubjectCredits,
        int TotalSubjectHours,
        bool IsOptional) : ICommand<int>;
}
