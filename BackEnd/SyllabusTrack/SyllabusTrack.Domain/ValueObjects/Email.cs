using SyllabusTrack.Domain.Primitives;
using SyllabusTrack.Domain.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SyllabusTrack.Domain.ValueObjects
{
    public sealed class Email : ValueObject
    {
        public const int MaxLength = 255;
        public string Value { get; }

        private Email(string value) => Value = value;

        public static Result<Email> Create(string email)
        {
            if (string.IsNullOrWhiteSpace(email))
                return Result.Failure<Email>(new Error("Email.Empty", "Email is required."));

            if (email.Length > MaxLength)
                return Result.Failure<Email>(new Error("Email.TooLong", "Email is too long."));

            if (!email.Contains('@'))
                return Result.Failure<Email>(new Error("Email.Invalid", "Email format is invalid."));

            return Result.Success(new Email(email));
        }

        public override IEnumerable<object> GetAtomicValues()
        {
            yield return Value;
        }
    }
}
