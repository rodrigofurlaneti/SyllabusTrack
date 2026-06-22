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
    public sealed class StudentProgress : Entity
    {
        public int EnrollmentId { get; private set; }
        public int SubjectId { get; private set; }
        public AcademicSubject? Subject { get; private set; } // Navigation property para EF Core Include
        public string CompletionStatus { get; private set; }
        public string SemesterTaken { get; private set; }
        public Grade? FinalGrade { get; private set; } // Uso do Value Object Grade
        public bool IsActive { get; private set; }

        private StudentProgress() : base(0) { }

        internal StudentProgress(int enrollmentId, int subjectId, string status, string semesterTaken, Grade? finalGrade) : base(0)
        {
            EnrollmentId = enrollmentId;
            SubjectId = subjectId;
            CompletionStatus = status;
            SemesterTaken = semesterTaken;
            FinalGrade = finalGrade;
            IsActive = true;
        }

        internal void Update(string status, string? semesterTaken, Grade? finalGrade)
        {
            CompletionStatus = status;
            if (semesterTaken is not null)
                SemesterTaken = semesterTaken;
            if (finalGrade is not null)
                FinalGrade = finalGrade;
        }

        internal static Result<StudentProgress> Create(int enrollmentId, int subjectId, string status, string semesterTaken, Grade? finalGrade)
        {
            var validStatuses = new[] { "Pending", "InProgress", "Completed", "Failed" };
            if (!validStatuses.Contains(status))
                return Result.Failure<StudentProgress>(new Error("Progress.InvalidStatus", "Invalid completion status."));

            return Result.Success(new StudentProgress(enrollmentId, subjectId, status, semesterTaken, finalGrade));
        }
    }
}
