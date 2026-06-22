using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SyllabusTrack.Domain.Primitives
{
    public abstract class ValueObject : IEquatable<ValueObject>
    {
        public abstract IEnumerable<object> GetAtomicValues();

        public bool Equals(ValueObject? other)
        {
            if (other is null) return false;
            return GetAtomicValues().SequenceEqual(other.GetAtomicValues());
        }

        public override bool Equals(object? obj) =>
            obj is ValueObject other && Equals(other);

        public override int GetHashCode() =>
            GetAtomicValues().Aggregate(default(int), (hashCode, value) => HashCode.Combine(hashCode, value.GetHashCode()));
    }
}
