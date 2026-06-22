using FluentValidation;
namespace SyllabusTrack.Application.Features.DegreePrograms.Update
{
    public sealed class UpdateProgramCommandValidator : AbstractValidator<UpdateProgramCommand>
    {
        public UpdateProgramCommandValidator()
        {
            RuleFor(x => x.ProgramId).GreaterThan(0);
            RuleFor(x => x.ProgramName).NotEmpty().MaximumLength(255);
            RuleFor(x => x.CurriculumVersion).NotEmpty().MaximumLength(100);
            RuleFor(x => x.TotalSemesters).GreaterThan(0);
        }
    }
}
