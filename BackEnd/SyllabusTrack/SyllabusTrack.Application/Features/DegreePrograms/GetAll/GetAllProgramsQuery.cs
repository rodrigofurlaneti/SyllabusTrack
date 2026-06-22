using SyllabusTrack.Application.Abstractions.Messaging;
namespace SyllabusTrack.Application.Features.DegreePrograms.GetAll
{
    public sealed record GetAllProgramsQuery() : IQuery<IReadOnlyCollection<ProgramResponse>>;
}
