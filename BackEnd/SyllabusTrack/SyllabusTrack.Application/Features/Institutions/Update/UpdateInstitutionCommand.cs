using SyllabusTrack.Application.Abstractions.Messaging;

namespace SyllabusTrack.Application.Features.Institutions.Update
{
    public sealed record UpdateInstitutionCommand(
        int InstitutionId,
        string Name,
        string Acronym,
        string Location) : ICommand; // Não retorna dados, apenas Result de sucesso/falha
}
