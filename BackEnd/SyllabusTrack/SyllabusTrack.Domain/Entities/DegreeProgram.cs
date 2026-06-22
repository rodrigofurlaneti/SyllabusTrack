using SyllabusTrack.Domain.Primitives;
using SyllabusTrack.Domain.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SyllabusTrack.Domain.Entities
{
    public sealed class DegreeProgram : AggregateRoot
    {
        public int InstitutionId { get; private set; }
        public string ProgramName { get; private set; }
        public string CurriculumVersion { get; private set; }
        public int TotalSemesters { get; private set; }
        public bool IsActive { get; private set; }

        private DegreeProgram() : base(0) { } // EF Core

        private DegreeProgram(int institutionId, string name, string version, int semesters) : base(0)
        {
            InstitutionId = institutionId;
            ProgramName = name;
            CurriculumVersion = version;
            TotalSemesters = semesters;
            IsActive = true;
        }

        public static Result<DegreeProgram> Create(int institutionId, string name, string version, int semesters)
        {
            if (institutionId <= 0)
                return Result.Failure<DegreeProgram>(new Error("Program.InvalidInstitution", "Valid Institution ID is required."));

            if (semesters <= 0)
                return Result.Failure<DegreeProgram>(new Error("Program.InvalidSemesters", "Total semesters must be greater than zero."));

            return Result.Success(new DegreeProgram(institutionId, name, version, semesters));
        }

        public void Deactivate() => IsActive = false;
    }
}
