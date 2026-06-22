using FluentValidation;

namespace SyllabusTrack.Application.Features.Institutions.Update
{
    public sealed class UpdateInstitutionCommandValidator : AbstractValidator<UpdateInstitutionCommand>
    {
        public UpdateInstitutionCommandValidator()
        {
            RuleFor(x => x.InstitutionId).GreaterThan(0);
            RuleFor(x => x.Name).NotEmpty().MaximumLength(255);
            RuleFor(x => x.Acronym).MaximumLength(50);
            RuleFor(x => x.Location).MaximumLength(255);
        }
    }
}
