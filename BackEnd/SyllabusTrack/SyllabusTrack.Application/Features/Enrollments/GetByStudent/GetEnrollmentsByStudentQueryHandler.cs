using SyllabusTrack.Application.Abstractions.Messaging;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.Application.Features.Enrollments.GetByStudent
{
    internal sealed class GetEnrollmentsByStudentQueryHandler(
        IStudentEnrollmentRepository repository) : IQueryHandler<GetEnrollmentsByStudentQuery, IReadOnlyCollection<EnrollmentResponse>>
    {
        public async Task<Result<IReadOnlyCollection<EnrollmentResponse>>> Handle(GetEnrollmentsByStudentQuery request, CancellationToken cancellationToken)
        {
            var enrollments = await repository.GetByStudentIdAsync(request.StudentId, cancellationToken);

            var response = enrollments.Select(e => new EnrollmentResponse(
                e.Id,
                e.StudentId,
                e.ProgramId,
                e.EnrollmentStatus,
                e.Progresses.Select(p => new ProgressResponse(
                    p.Id,
                    p.SubjectId,
                    p.CompletionStatus,
                    p.SemesterTaken,
                    p.FinalGrade?.Value // Extrai o decimal do ValueObject
                )).ToList().AsReadOnly()
            )).ToList().AsReadOnly();

            return Result.Success<IReadOnlyCollection<EnrollmentResponse>>(response);
        }
    }
}
