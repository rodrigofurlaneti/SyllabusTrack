using SyllabusTrack.Domain.Primitives;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.Domain.ValueObjects
{
    public sealed class PhoneNumber : ValueObject
    {
        public const int MaxLength = 20;
        public string Value { get; }

        private PhoneNumber(string value) => Value = value;

        public static Result<PhoneNumber> Create(string phoneNumber)
        {
            if (string.IsNullOrWhiteSpace(phoneNumber))
                return Result.Failure<PhoneNumber>(new Error("PhoneNumber.Empty", "Phone number is required."));

            if (phoneNumber.Length > MaxLength)
                return Result.Failure<PhoneNumber>(new Error("PhoneNumber.TooLong", "Phone number exceeds maximum length."));

            // Aqui você poderia adicionar Regex para validar o formato do celular
            return Result.Success(new PhoneNumber(phoneNumber));
        }

        public override IEnumerable<object> GetAtomicValues()
        {
            yield return Value;
        }
    }
}
