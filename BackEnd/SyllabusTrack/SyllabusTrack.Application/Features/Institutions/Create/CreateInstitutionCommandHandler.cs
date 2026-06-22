using SyllabusTrack.Application.Abstractions.Messaging;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.Application.Features.Institutions.Create
{
    internal sealed class CreateInstitutionCommandHandler(
        IEducationalInstitutionRepository repository,
        IUnitOfWork unitOfWork) : ICommandHandler<CreateInstitutionCommand, int>
    {
        public async Task<Result<int>> Handle(CreateInstitutionCommand request, CancellationToken cancellationToken)
        {
            var institutionResult = EducationalInstitution.Create(
                request.Name,
                request.Acronym,
                request.Location);

            if (institutionResult.IsFailure)
                return Result.Failure<int>(institutionResult.Error);

            await repository.AddAsync(institutionResult.Value, cancellationToken);
            await unitOfWork.CommitAsync(cancellationToken);

            return Result.Success(institutionResult.Value.Id);
        }
    }
}
