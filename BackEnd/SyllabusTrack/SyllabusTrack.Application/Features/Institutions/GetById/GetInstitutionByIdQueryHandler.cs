using SyllabusTrack.Application.Abstractions.Messaging;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.Application.Features.Institutions.GetById
{
    internal sealed class GetInstitutionByIdQueryHandler(
        IEducationalInstitutionRepository repository) : IQueryHandler<GetInstitutionByIdQuery, InstitutionResponse>
    {
        public async Task<Result<InstitutionResponse>> Handle(GetInstitutionByIdQuery request, CancellationToken cancellationToken)
        {
            var institution = await repository.GetByIdAsync(request.InstitutionId, cancellationToken);

            if (institution is null)
                return Result.Failure<InstitutionResponse>(new Error("Institution.NotFound", $"No institution found with ID {request.InstitutionId}"));

            var response = new InstitutionResponse(
                institution.Id,
                institution.InstitutionName,
                institution.InstitutionAcronym,
                institution.CampusLocation,
                institution.IsActive);

            return Result.Success(response);
        }
    }
}
