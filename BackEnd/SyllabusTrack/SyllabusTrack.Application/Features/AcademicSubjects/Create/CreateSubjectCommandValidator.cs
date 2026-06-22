using FluentValidation;
namespace SyllabusTrack.Application.Features.AcademicSubjects.Create
{
    public sealed class CreateSubjectCommandValidator : AbstractValidator<CreateSubjectCommand>
    {
        public CreateSubjectCommandValidator()
        {
            RuleFor(x => x.ModuleId).GreaterThan(0);
            RuleFor(x => x.SubjectCode).NotEmpty().MaximumLength(50);
            RuleFor(x => x.SubjectName).NotEmpty().MaximumLength(255);
            RuleFor(x => x.SubjectCredits).GreaterThanOrEqualTo(0);
            RuleFor(x => x.TotalSubjectHours).GreaterThan(0);
        }
    }
}
