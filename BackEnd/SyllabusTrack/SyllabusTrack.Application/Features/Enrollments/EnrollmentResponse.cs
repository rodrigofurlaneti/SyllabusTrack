namespace SyllabusTrack.Application.Features.Enrollments
{
    public sealed record EnrollmentResponse(
        int EnrollmentId,
        int StudentId,
        int ProgramId,
        string ProgramName,
        string InstitutionName,
        string InstitutionAcronym,
        int TotalSemesters,
        string EnrollmentStatus,
        IReadOnlyCollection<ProgressResponse> Progresses);
}
