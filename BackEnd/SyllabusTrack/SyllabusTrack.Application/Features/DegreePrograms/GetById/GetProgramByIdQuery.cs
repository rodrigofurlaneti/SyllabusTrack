using SyllabusTrack.Application.Abstractions.Messaging;

namespace SyllabusTrack.Application.Features.DegreePrograms.GetById
{
    public sealed record GetProgramByIdQuery(int ProgramId) : IQuery<ProgramResponse>;
}
