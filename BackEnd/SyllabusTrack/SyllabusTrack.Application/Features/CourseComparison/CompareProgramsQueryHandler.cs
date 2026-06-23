using SyllabusTrack.Application.Abstractions.Messaging;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.Application.Features.CourseComparison;

internal sealed class CompareProgramsQueryHandler(
    ICourseComparisonRepository repository)
    : IQueryHandler<CompareProgramsQuery, CourseComparisonResponse>
{
    public async Task<Result<CourseComparisonResponse>> Handle(
        CompareProgramsQuery request,
        CancellationToken cancellationToken)
    {
        var result = await repository.CompareAsync(
            request.SourceProgramId,
            request.TargetProgramId,
            cancellationToken);

        if (result is null)
            return Result.Failure<CourseComparisonResponse>(
                new Error("Comparison.NotFound",
                    "Um ou ambos os cursos informados não foram encontrados."));

        return Result.Success(result);
    }
}
