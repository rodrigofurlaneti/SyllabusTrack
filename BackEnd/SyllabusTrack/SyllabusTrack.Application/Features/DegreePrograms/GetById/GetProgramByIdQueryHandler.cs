using SyllabusTrack.Application.Abstractions.Messaging;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.Application.Features.DegreePrograms.GetById
{
    internal sealed class GetProgramByIdQueryHandler(
        IDegreeProgramRepository repository) : IQueryHandler<GetProgramByIdQuery, ProgramResponse>
    {
        public async Task<Result<ProgramResponse>> Handle(GetProgramByIdQuery request, CancellationToken cancellationToken)
        {
            var program = await repository.GetByIdWithSyllabusAsync(request.ProgramId, cancellationToken);

            if (program is null)
                return Result.Failure<ProgramResponse>(new Error("Program.NotFound", $"Program not found."));

            return Result.Success(new ProgramResponse(
                program.Id,
                program.InstitutionId,
                program.ProgramName,
                program.CurriculumVersion,
                program.TotalSemesters,
                program.IsActive));
        }
    }
}
