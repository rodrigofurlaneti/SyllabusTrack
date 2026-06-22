using SyllabusTrack.Application.Abstractions.Authentication;
using SyllabusTrack.Application.Abstractions.Messaging;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Domain.Shared;
using SyllabusTrack.Domain.ValueObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SyllabusTrack.Application.Features.Auth.Register
{
    internal sealed class RegisterStudentCommandHandler(
        IStudentAccountRepository studentRepository,
        IPasswordHasher passwordHasher,
        IUnitOfWork unitOfWork) : ICommandHandler<RegisterStudentCommand, int>
    {
        public async Task<Result<int>> Handle(RegisterStudentCommand request, CancellationToken cancellationToken)
        {
            var emailResult = Email.Create(request.Email);
            if (emailResult.IsFailure)
                return Result.Failure<int>(emailResult.Error);

            if (!await studentRepository.IsEmailUniqueAsync(emailResult.Value, cancellationToken))
                return Result.Failure<int>(new Error("Auth.EmailTaken", "The provided email is already in use."));

            if (!await studentRepository.IsUsernameUniqueAsync(request.Username, cancellationToken))
                return Result.Failure<int>(new Error("Auth.UsernameTaken", "The provided username is already in use."));

            string hashedPassword = passwordHasher.Hash(request.Password);

            var studentResult = StudentAccount.Create(
                request.FullName,
                request.Username,
                emailResult.Value,
                request.PhoneNumber,
                hashedPassword);

            if (studentResult.IsFailure)
                return Result.Failure<int>(studentResult.Error);

            await studentRepository.AddAsync(studentResult.Value, cancellationToken);
            await unitOfWork.CommitAsync(cancellationToken);

            return Result.Success(studentResult.Value.Id);
        }
    }
}
