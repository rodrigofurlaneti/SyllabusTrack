using SyllabusTrack.Application.Abstractions.Messaging;
namespace SyllabusTrack.Application.Features.DegreePrograms.Update
{
    public sealed record UpdateProgramCommand(
        int ProgramId,
        string ProgramName,
        string CurriculumVersion,
        int TotalSemesters) : ICommand;
}
