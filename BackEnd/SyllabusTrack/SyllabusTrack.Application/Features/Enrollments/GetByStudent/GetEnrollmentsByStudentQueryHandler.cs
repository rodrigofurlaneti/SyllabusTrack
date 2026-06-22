using SyllabusTrack.Application.Abstractions.Messaging;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.Application.Features.Enrollments.GetByStudent
{
    internal sealed class GetEnrollmentsByStudentQueryHandler(
        IStudentEnrollmentRepository repository,
        IDegreeProgramRepository programRepository,
        IEducationalInstitutionRepository institutionRepository)
        : IQueryHandler<GetEnrollmentsByStudentQuery, IReadOnlyCollection<EnrollmentResponse>>
    {
        public async Task<Result<IReadOnlyCollection<EnrollmentResponse>>> Handle(
            GetEnrollmentsByStudentQuery request,
            CancellationToken cancellationToken)
        {
            var enrollments = await repository.GetByStudentIdAsync(request.StudentId, cancellationToken);

            // Batch-fetch programs and institutions to avoid N+1
            var programs = (await programRepository.GetAllActiveAsync(cancellationToken))
                .ToDictionary(p => p.Id);

            var institutions = (await institutionRepository.GetAllActiveAsync(cancellationToken))
                .ToDictionary(i => i.Id);

            var response = enrollments.Select(e =>
            {
                programs.TryGetValue(e.ProgramId, out var program);
                var institutionId = program?.InstitutionId ?? 0;
                institutions.TryGetValue(institutionId, out var institution);

                return new EnrollmentResponse(
                    e.Id,
                    e.StudentId,
                    e.ProgramId,
                    program?.ProgramName ?? string.Empty,
                    institution?.InstitutionName ?? string.Empty,
                    institution?.InstitutionAcronym ?? string.Empty,
                    program?.TotalSemesters ?? 0,
                    e.EnrollmentStatus,
                    e.Progresses.Select(p => new ProgressResponse(
                        p.Id,
                        p.SubjectId,
                        p.Subject?.SubjectCode ?? string.Empty,
                        p.Subject?.SubjectName ?? string.Empty,
                        p.CompletionStatus,
                        p.SemesterTaken,
                        p.FinalGrade?.Value
                    )).ToList().AsReadOnly()
                );
            }).ToList().AsReadOnly();

            return Result.Success<IReadOnlyCollection<EnrollmentResponse>>(response);
        }
    }
}
