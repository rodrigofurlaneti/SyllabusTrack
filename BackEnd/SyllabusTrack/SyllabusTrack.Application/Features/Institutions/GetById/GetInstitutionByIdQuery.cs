using SyllabusTrack.Application.Abstractions.Messaging;

namespace SyllabusTrack.Application.Features.Institutions.GetById
{
    public sealed record GetInstitutionByIdQuery(int InstitutionId) : IQuery<InstitutionResponse>;
}
