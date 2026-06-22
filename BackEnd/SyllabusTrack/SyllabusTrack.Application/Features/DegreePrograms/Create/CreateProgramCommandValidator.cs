using FluentValidation;
namespace SyllabusTrack.Application.Features.DegreePrograms.Create
{
    public sealed class CreateProgramCommandValidator : AbstractValidator<CreateProgramCommand>
    {
        public CreateProgramCommandValidator()
        {
            RuleFor(x => x.InstitutionId).GreaterThan(0);
            RuleFor(x => x.ProgramName).NotEmpty().MaximumLength(255);
            RuleFor(x => x.CurriculumVersion).NotEmpty().MaximumLength(100);
            RuleFor(x => x.TotalSemesters).GreaterThan(0).LessThanOrEqualTo(20);
        }
    }
}
