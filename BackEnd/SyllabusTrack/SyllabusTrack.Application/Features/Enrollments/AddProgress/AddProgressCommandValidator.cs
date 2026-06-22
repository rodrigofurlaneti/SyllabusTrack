using FluentValidation;

namespace SyllabusTrack.Application.Features.Enrollments.AddProgress
{
    public sealed class AddProgressCommandValidator : AbstractValidator<AddProgressCommand>
    {
        public AddProgressCommandValidator()
        {
            RuleFor(x => x.EnrollmentId).GreaterThan(0);
            RuleFor(x => x.SubjectId).GreaterThan(0);
            RuleFor(x => x.CompletionStatus).NotEmpty();
            RuleFor(x => x.SemesterTaken).MaximumLength(20);
            RuleFor(x => x.FinalGrade).InclusiveBetween(0m, 10m).When(x => x.FinalGrade.HasValue);
        }
    }
}
