using SyllabusTrack.Domain.Primitives;
using SyllabusTrack.Domain.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SyllabusTrack.Domain.ValueObjects
{
    public sealed class Grade : ValueObject
    {
        public decimal Value { get; }

        private Grade(decimal value) => Value = value;

        public static Result<Grade> Create(decimal value)
        {
            if (value < 0m || value > 10m)
                return Result.Failure<Grade>(new Error("Grade.Invalid", "Grade must be between 0.00 and 10.00."));

            return Result.Success(new Grade(value));
        }

        public override IEnumerable<object> GetAtomicValues()
        {
            yield return Value;
        }
    }
}
