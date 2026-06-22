using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SyllabusTrack.Domain.Primitives
{
    public abstract class Entity(int id)
    {
        public int Id { get; protected set; } = id;

        protected Entity() : this(0) { } 

        public override bool Equals(object? obj)
        {
            if (obj is null || obj.GetType() != GetType()) return false;
            if (obj is not Entity other) return false;
            return Id == other.Id;
        }

        public override int GetHashCode() => Id.GetHashCode();
    }
}
