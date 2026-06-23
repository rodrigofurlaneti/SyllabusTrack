using SyllabusTrack.Domain.Primitives;
using SyllabusTrack.Domain.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SyllabusTrack.Domain.Entities
{
    public sealed class EducationalInstitution : AggregateRoot
    {
        public string InstitutionName { get; private set; } = null!;
        public string InstitutionAcronym { get; private set; } = null!;
        public string CampusLocation { get; private set; } = null!;
        public bool IsActive { get; private set; }

        private EducationalInstitution() : base(0) { } // EF Core

        private EducationalInstitution(string name, string acronym, string location) : base(0)
        {
            InstitutionName = name;
            InstitutionAcronym = acronym;
            CampusLocation = location;
            IsActive = true;
        }

        public static Result<EducationalInstitution> Create(string name, string acronym, string location)
        {
            if (string.IsNullOrWhiteSpace(name))
                return Result.Failure<EducationalInstitution>(new Error("Institution.EmptyName", "Institution name is required."));

            return Result.Success(new EducationalInstitution(name, acronym, location));
        }

        public Result UpdateDetails(string name, string acronym, string location)
        {
            if (string.IsNullOrWhiteSpace(name))
                return Result.Failure(new Error("Institution.EmptyName", "Institution name is required."));

            InstitutionName = name;
            InstitutionAcronym = acronym;
            CampusLocation = location;

            return Result.Success();
        }

        public void Deactivate() => IsActive = false;
    }
}
