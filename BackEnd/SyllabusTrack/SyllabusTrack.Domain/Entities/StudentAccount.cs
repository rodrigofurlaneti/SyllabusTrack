using SyllabusTrack.Domain.Primitives;
using SyllabusTrack.Domain.Shared;
using SyllabusTrack.Domain.ValueObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SyllabusTrack.Domain.Entities
{
    public sealed class StudentAccount : AggregateRoot
    {
        public string StudentFullName { get; private set; }
        public string LoginUsername { get; private set; }
        public Email EmailAddress { get; private set; }
        public string CellPhoneNumber { get; private set; }
        public string AccountPassword { get; private set; }
        public bool IsActive { get; private set; }
        public DateTime CreatedAt { get; private set; }
        public DateTime UpdatedAt { get; private set; }

        // Construtor privado para o EF Core
        private StudentAccount() : base(0) { }

        private StudentAccount(
            string studentFullName,
            string loginUsername,
            Email emailAddress,
            string cellPhoneNumber,
            string accountPassword) : base(0)
        {
            StudentFullName = studentFullName;
            LoginUsername = loginUsername;
            EmailAddress = emailAddress;
            CellPhoneNumber = cellPhoneNumber;
            AccountPassword = accountPassword;
            IsActive = true;
            CreatedAt = DateTime.UtcNow;
            UpdatedAt = DateTime.UtcNow;
        }

        public static Result<StudentAccount> Create(
            string studentFullName,
            string loginUsername,
            Email emailAddress,
            string cellPhoneNumber,
            string accountPassword)
        {
            if (string.IsNullOrWhiteSpace(studentFullName))
                return Result.Failure<StudentAccount>(new Error("Student.EmptyName", "Student name is required."));

            if (string.IsNullOrWhiteSpace(loginUsername))
                return Result.Failure<StudentAccount>(new Error("Student.EmptyUsername", "Username is required."));

            var student = new StudentAccount(studentFullName, loginUsername, emailAddress, cellPhoneNumber, accountPassword);

            // Aqui poderíamos disparar um Domain Event:
            // student.RaiseDomainEvent(new StudentRegisteredDomainEvent(student.Id));

            return Result.Success(student);
        }
    }
}
