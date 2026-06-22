namespace SyllabusTrack.Application.Features.Enrollments
{
    public sealed record ProgressResponse(
        int ProgressId,
        int SubjectId,
        string SubjectName,
        string CompletionStatus,
        string? SemesterTaken,
        decimal? FinalGrade);
}
