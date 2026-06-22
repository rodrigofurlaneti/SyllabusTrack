using SyllabusTrack.Application.Abstractions.Messaging;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.Application.Features.Institutions.Update
{
    internal sealed class UpdateInstitutionCommandHandler(
        IEducationalInstitutionRepository repository,
        IUnitOfWork unitOfWork) : ICommandHandler<UpdateInstitutionCommand>
    {
        public async Task<Result> Handle(UpdateInstitutionCommand request, CancellationToken cancellationToken)
        {
            var institution = await repository.GetByIdAsync(request.InstitutionId, cancellationToken);

            if (institution is null)
                return Result.Failure(new Error("Institution.NotFound", $"No institution found with ID {request.InstitutionId}"));

            var updateResult = institution.UpdateDetails(request.Name, request.Acronym, request.Location);

            if (updateResult.IsFailure)
                return Result.Failure(updateResult.Error);

            // O EF Core já mapeia a entidade, então só precisamos fazer o commit
            await unitOfWork.CommitAsync(cancellationToken);

            return Result.Success();
        }
    }
}
