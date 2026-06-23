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
    public sealed class StudentEnrollment : AggregateRoot
    {
        public int StudentId { get; private set; }
        public int ProgramId { get; private set; }
        public DateTime EnrollmentDate { get; private set; }
        public string EnrollmentStatus { get; private set; } = null!;
        public bool IsActive { get; private set; }

        // Relação 1:N com Progresso (Encapsulada)
        private readonly List<StudentProgress> _progresses = [];
        public IReadOnlyCollection<StudentProgress> Progresses => _progresses.AsReadOnly();

        private StudentEnrollment() : base(0) { }

        private StudentEnrollment(int studentId, int programId, string status) : base(0)
        {
            StudentId = studentId;
            ProgramId = programId;
            EnrollmentDate = DateTime.UtcNow;
            EnrollmentStatus = status;
            IsActive = true;
        }

        public static Result<StudentEnrollment> Create(int studentId, int programId)
        {
            if (studentId <= 0 || programId <= 0)
                return Result.Failure<StudentEnrollment>(new Error("Enrollment.InvalidData", "Student and Program IDs are required."));

            return Result.Success(new StudentEnrollment(studentId, programId, "Active"));
        }

        // Upsert: atualiza o progresso se já existe, cria se não existe
        public Result AddProgress(int subjectId, string status, string semesterTaken, Grade? finalGrade)
        {
            var existing = _progresses.FirstOrDefault(p => p.SubjectId == subjectId && p.IsActive);

            if (existing is not null)
            {
                // Valida o status antes de atualizar
                var validStatuses = new[] { "Pending", "InProgress", "Completed", "Failed" };
                if (!validStatuses.Contains(status))
                    return Result.Failure(new Error("Progress.InvalidStatus", "Invalid completion status."));

                existing.Update(status, semesterTaken, finalGrade);
                return Result.Success();
            }

            var progressResult = StudentProgress.Create(Id, subjectId, status, semesterTaken, finalGrade);

            if (progressResult.IsFailure)
                return Result.Failure(progressResult.Error);

            _progresses.Add(progressResult.Value);

            return Result.Success();
        }
    }
}
