using SyllabusTrack.Application.Abstractions.Messaging;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Domain.Shared;
namespace SyllabusTrack.Application.Features.DegreePrograms.GetAll
{
    internal sealed class GetAllProgramsQueryHandler(
        IDegreeProgramRepository repository) : IQueryHandler<GetAllProgramsQuery, IReadOnlyCollection<ProgramResponse>>
    {
        public async Task<Result<IReadOnlyCollection<ProgramResponse>>> Handle(GetAllProgramsQuery request, CancellationToken cancellationToken)
        {
            var programs = await repository.GetAllActiveAsync(cancellationToken);

            var response = programs.Select(p => new ProgramResponse(
                p.Id,
                p.InstitutionId,
                p.ProgramName,
                p.CurriculumVersion,
                p.TotalSemesters,
                p.IsActive)).ToList().AsReadOnly();

            return Result.Success<IReadOnlyCollection<ProgramResponse>>(response);
        }
    }
}
