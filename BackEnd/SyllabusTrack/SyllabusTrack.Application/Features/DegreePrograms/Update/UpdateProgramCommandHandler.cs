using SyllabusTrack.Application.Abstractions.Messaging;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.Application.Features.DegreePrograms.Update
{
    internal sealed class UpdateProgramCommandHandler(
        IDegreeProgramRepository repository,
        IUnitOfWork unitOfWork) : ICommandHandler<UpdateProgramCommand>
    {
        public async Task<Result> Handle(UpdateProgramCommand request, CancellationToken cancellationToken)
        {
            var program = await repository.GetByIdWithSyllabusAsync(request.ProgramId, cancellationToken);

            if (program is null)
                return Result.Failure(new Error("Program.NotFound", $"No program found with ID {request.ProgramId}"));

            // Assumindo que você adicione um método UpdateDetails na entidade DegreeProgram
            var updateResult = program.UpdateDetails(request.ProgramName, request.CurriculumVersion, request.TotalSemesters);

            if (updateResult.IsFailure)
                return Result.Failure(updateResult.Error);

            await unitOfWork.CommitAsync(cancellationToken);

            return Result.Success();
        }
    }
}
