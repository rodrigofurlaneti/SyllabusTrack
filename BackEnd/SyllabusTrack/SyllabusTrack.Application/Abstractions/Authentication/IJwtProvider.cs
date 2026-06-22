using SyllabusTrack.Domain.Entities;

namespace SyllabusTrack.Application.Abstractions.Authentication
{
    public interface IJwtProvider
    {
        string Generate(StudentAccount student);
    }
}
