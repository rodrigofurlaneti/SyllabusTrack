using SyllabusTrack.Application.Abstractions.Authentication;
using SyllabusTrack.Application.Abstractions.Messaging;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Domain.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SyllabusTrack.Application.Features.Auth.Login
{
    internal sealed class LoginStudentQueryHandler(
        IStudentAccountRepository studentRepository,
        IPasswordHasher passwordHasher,
        IJwtProvider jwtProvider) : IQueryHandler<LoginStudentQuery, string>
    {
        public async Task<Result<string>> Handle(LoginStudentQuery request, CancellationToken cancellationToken)
        {
            // Tenta buscar por Email primeiro, se não achar, tenta por Username (Lógica será encapsulada no repositório)
            var student = await studentRepository.GetByEmailOrUsernameAsync(request.EmailOrUsername, cancellationToken);

            if (student is null)
                return Result.Failure<string>(new Error("Auth.InvalidCredentials", "Invalid email/username or password."));

            bool isPasswordValid = passwordHasher.Verify(request.Password, student.AccountPassword);

            if (!isPasswordValid)
                return Result.Failure<string>(new Error("Auth.InvalidCredentials", "Invalid email/username or password."));

            string token = jwtProvider.Generate(student);

            return Result.Success(token);
        }
    }
}
