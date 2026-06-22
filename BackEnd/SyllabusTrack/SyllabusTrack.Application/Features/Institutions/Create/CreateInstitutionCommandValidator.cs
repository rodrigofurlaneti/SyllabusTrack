using FluentValidation;
namespace SyllabusTrack.Application.Features.Institutions.Create
{
    public sealed class CreateInstitutionCommandValidator : AbstractValidator<CreateInstitutionCommand>
    {
        public CreateInstitutionCommandValidator()
        {
            RuleFor(x => x.Name).NotEmpty().MaximumLength(255);
            RuleFor(x => x.Acronym).MaximumLength(50);
            RuleFor(x => x.Location).MaximumLength(255);
        }
    }
}
