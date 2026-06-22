using SyllabusTrack.Application.Abstractions.Messaging;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.Application.Features.AcademicSubjects.Create
{
    internal sealed class CreateSubjectCommandHandler(
        IAcademicSubjectRepository repository,
        IUnitOfWork unitOfWork) : ICommandHandler<CreateSubjectCommand, int>
    {
        public async Task<Result<int>> Handle(CreateSubjectCommand request, CancellationToken cancellationToken)
        {
            var subjectResult = AcademicSubject.Create(
                request.ModuleId,
                request.SubjectCode,
                request.SubjectName,
                request.SubjectCredits,
                request.TotalSubjectHours,
                request.IsOptional);

            if (subjectResult.IsFailure)
                return Result.Failure<int>(subjectResult.Error);

            await repository.AddAsync(subjectResult.Value, cancellationToken);
            await unitOfWork.CommitAsync(cancellationToken);

            return Result.Success(subjectResult.Value.Id);
        }
    }
}
