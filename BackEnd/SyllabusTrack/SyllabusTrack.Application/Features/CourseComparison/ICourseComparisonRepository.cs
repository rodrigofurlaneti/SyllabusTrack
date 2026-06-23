namespace SyllabusTrack.Application.Features.CourseComparison;

public interface ICourseComparisonRepository
{
    /// <summary>
    /// Compara as disciplinas do <paramref name="targetProgramId"/> com as do
    /// <paramref name="sourceProgramId"/>. O match é feito por nome (case-insensitive).
    /// </summary>
    Task<CourseComparisonResponse?> CompareAsync(
        int sourceProgramId,
        int targetProgramId,
        CancellationToken cancellationToken = default);
}
