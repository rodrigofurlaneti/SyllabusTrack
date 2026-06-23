using SyllabusTrack.Domain.Primitives;
using SyllabusTrack.Domain.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SyllabusTrack.Domain.Entities
{
    public sealed class AcademicSubject : Entity
    {
        public int ModuleId { get; private set; }
        public string SubjectCode { get; private set; } = null!;
        public string SubjectName { get; private set; } = null!;
        public int SubjectCredits { get; private set; }
        public int TotalSubjectHours { get; private set; }
        public bool IsOptional { get; private set; }
        public bool IsActive { get; private set; }

        private AcademicSubject() : base(0) { }

        private AcademicSubject(int moduleId, string code, string name, int credits, int totalHours, bool isOptional) : base(0)
        {
            ModuleId = moduleId;
            SubjectCode = code;
            SubjectName = name;
            SubjectCredits = credits;
            TotalSubjectHours = totalHours;
            IsOptional = isOptional;
            IsActive = true;
        }

        public static Result<AcademicSubject> Create(int moduleId, string code, string name, int credits, int totalHours, bool isOptional)
        {
            if (totalHours <= 0)
                return Result.Failure<AcademicSubject>(new Error("Subject.InvalidHours", "Total hours must be positive."));

            return Result.Success(new AcademicSubject(moduleId, code, name, credits, totalHours, isOptional));
        }
    }
}
