using SyllabusTrack.Application.Abstractions.Messaging;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.Application.Features.Institutions.GetAll
{
    internal sealed class GetAllInstitutionsQueryHandler(
        IEducationalInstitutionRepository repository) : IQueryHandler<GetAllInstitutionsQuery, IReadOnlyCollection<InstitutionResponse>>
    {
        public async Task<Result<IReadOnlyCollection<InstitutionResponse>>> Handle(GetAllInstitutionsQuery request, CancellationToken cancellationToken)
        {
            var institutions = await repository.GetAllActiveAsync(cancellationToken);

            var response = institutions.Select(i => new InstitutionResponse(
                i.Id,
                i.InstitutionName,
                i.InstitutionAcronym,
                i.CampusLocation,
                i.IsActive)).ToList().AsReadOnly();

            return Result.Success<IReadOnlyCollection<InstitutionResponse>>(response);
        }
    }
}
