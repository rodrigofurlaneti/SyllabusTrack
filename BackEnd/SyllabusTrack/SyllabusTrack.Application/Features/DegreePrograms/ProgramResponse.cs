namespace SyllabusTrack.Application.Features.DegreePrograms
{
    public sealed record ProgramResponse(
        int ProgramId,
        int InstitutionId,
        string ProgramName,
        string CurriculumVersion,
        int TotalSemesters,
        bool IsActive);
}
