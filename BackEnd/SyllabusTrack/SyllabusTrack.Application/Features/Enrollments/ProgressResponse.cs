namespace SyllabusTrack.Application.Features.Enrollments
{
    public sealed record ProgressResponse(
        int ProgressId,
        int SubjectId,
        string CompletionStatus,
        string SemesterTaken,
        decimal? FinalGrade);
}
