using FluentValidation;

namespace SyllabusTrack.Application.Features.Auth.Register
{
    public sealed class RegisterStudentCommandValidator : AbstractValidator<RegisterStudentCommand>
    {
        public RegisterStudentCommandValidator()
        {
            RuleFor(c => c.FullName).NotEmpty().MaximumLength(255);
            RuleFor(c => c.Username).NotEmpty().MaximumLength(50);
            RuleFor(c => c.Email).NotEmpty().EmailAddress();
            RuleFor(c => c.PhoneNumber).NotEmpty().MaximumLength(20);
            RuleFor(c => c.Password).NotEmpty().MinimumLength(6);
        }
    }
}
