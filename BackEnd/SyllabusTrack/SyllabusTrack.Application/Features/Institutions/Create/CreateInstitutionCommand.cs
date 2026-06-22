using SyllabusTrack.Application.Abstractions.Messaging;
namespace SyllabusTrack.Application.Features.Institutions.Create
{
    public sealed record CreateInstitutionCommand(
        string Name,
        string Acronym,
        string Location) : ICommand<int>;
}
