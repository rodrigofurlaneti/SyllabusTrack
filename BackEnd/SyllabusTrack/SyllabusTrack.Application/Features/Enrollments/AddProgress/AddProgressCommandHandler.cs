using SyllabusTrack.Application.Abstractions.Messaging;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Domain.Shared;
using SyllabusTrack.Domain.ValueObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SyllabusTrack.Application.Features.Enrollments.AddProgress
{
    internal sealed class AddProgressCommandHandler(
        IStudentEnrollmentRepository repository,
        IUnitOfWork unitOfWork) : ICommandHandler<AddProgressCommand>
    {
        public async Task<Result> Handle(AddProgressCommand request, CancellationToken cancellationToken)
        {
            // 1. Busca a matrícula com todos os progressos atuais
            var enrollment = await repository.GetByIdWithProgressAsync(request.EnrollmentId, cancellationToken);

            if (enrollment is null)
                return Result.Failure(new Error("Enrollment.NotFound", "Enrollment not found."));

            // 2. Transforma a nota decimal simples no nosso ValueObject seguro
            Grade? grade = null;
            if (request.FinalGrade.HasValue)
            {
                var gradeResult = Grade.Create(request.FinalGrade.Value);
                if (gradeResult.IsFailure)
                    return Result.Failure(gradeResult.Error);

                grade = gradeResult.Value;
            }

            // 3. Pede para a entidade validar as regras e adicionar o progresso
            var addProgressResult = enrollment.AddProgress(
                request.SubjectId,
                request.CompletionStatus,
                request.SemesterTaken,
                grade);

            if (addProgressResult.IsFailure)
                return Result.Failure(addProgressResult.Error);

            // 4. Salva no banco
            await unitOfWork.CommitAsync(cancellationToken);

            return Result.Success();
        }
    }
}
