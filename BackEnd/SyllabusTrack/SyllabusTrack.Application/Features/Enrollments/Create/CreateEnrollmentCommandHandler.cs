using SyllabusTrack.Application.Abstractions.Messaging;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Domain.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SyllabusTrack.Application.Features.Enrollments.Create
{
    internal sealed class CreateEnrollmentCommandHandler(
        IStudentEnrollmentRepository repository,
        IUnitOfWork unitOfWork) : ICommandHandler<CreateEnrollmentCommand, int>
    {
        public async Task<Result<int>> Handle(CreateEnrollmentCommand request, CancellationToken cancellationToken)
        {
            var enrollmentResult = StudentEnrollment.Create(request.StudentId, request.ProgramId);

            if (enrollmentResult.IsFailure)
                return Result.Failure<int>(enrollmentResult.Error);

            await repository.AddAsync(enrollmentResult.Value, cancellationToken);
            await unitOfWork.CommitAsync(cancellationToken);

            return Result.Success(enrollmentResult.Value.Id);
        }
    }
}
