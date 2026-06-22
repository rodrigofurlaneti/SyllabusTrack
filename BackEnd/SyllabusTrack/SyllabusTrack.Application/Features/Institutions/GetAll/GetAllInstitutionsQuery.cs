using SyllabusTrack.Application.Abstractions.Messaging;

namespace SyllabusTrack.Application.Features.Institutions.GetAll
{
    public sealed record GetAllInstitutionsQuery() : IQuery<IReadOnlyCollection<InstitutionResponse>>;
}
