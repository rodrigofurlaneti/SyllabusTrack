using SyllabusTrack.Application.Abstractions.Messaging;
namespace SyllabusTrack.Application.Features.DegreePrograms.Create
{
    public sealed record CreateProgramCommand(
        int InstitutionId,
        string ProgramName,
        string CurriculumVersion,
        int TotalSemesters) : ICommand<int>;
}
