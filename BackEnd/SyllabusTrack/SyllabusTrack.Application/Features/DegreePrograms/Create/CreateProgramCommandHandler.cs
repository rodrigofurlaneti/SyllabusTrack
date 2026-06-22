using SyllabusTrack.Application.Abstractions.Messaging;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.Application.Features.DegreePrograms.Create
{
    internal sealed class CreateProgramCommandHandler(
        IDegreeProgramRepository repository,
        IEducationalInstitutionRepository institutionRepository,
        IUnitOfWork unitOfWork) : ICommandHandler<CreateProgramCommand, int>
    {
        public async Task<Result<int>> Handle(CreateProgramCommand request, CancellationToken cancellationToken)
        {
            // Regra de negócio: a instituição precisa existir
            var institution = await institutionRepository.GetByIdAsync(request.InstitutionId, cancellationToken);
            if (institution is null)
                return Result.Failure<int>(new Error("Institution.NotFound", "The specified institution does not exist."));

            var programResult = DegreeProgram.Create(
                request.InstitutionId,
                request.ProgramName,
                request.CurriculumVersion,
                request.TotalSemesters);

            if (programResult.IsFailure)
                return Result.Failure<int>(programResult.Error);

            await repository.AddAsync(programResult.Value, cancellationToken);
            await unitOfWork.CommitAsync(cancellationToken);

            return Result.Success(programResult.Value.Id);
        }
    }
}
