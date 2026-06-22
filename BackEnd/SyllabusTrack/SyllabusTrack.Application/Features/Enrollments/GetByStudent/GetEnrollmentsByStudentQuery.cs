using SyllabusTrack.Application.Abstractions.Messaging;
namespace SyllabusTrack.Application.Features.Enrollments.GetByStudent
{
    public sealed record GetEnrollmentsByStudentQuery(int StudentId) : IQuery<IReadOnlyCollection<EnrollmentResponse>>;
}
