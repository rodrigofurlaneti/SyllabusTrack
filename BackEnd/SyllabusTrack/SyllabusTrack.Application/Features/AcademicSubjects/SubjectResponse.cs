namespace SyllabusTrack.Application.Features.AcademicSubjects
{
    public sealed record SubjectResponse(
        int SubjectId,
        int ModuleId,
        string SubjectCode,
        string SubjectName,
        int SubjectCredits,
        int TotalSubjectHours,
        bool IsOptional,
        bool IsActive);
}
