using SyllabusTrack.Application.Abstractions.Messaging;

namespace SyllabusTrack.Application.Features.CourseComparison;

/// <summary>
/// Compara as disciplinas do curso de referência com as do curso-alvo.
/// </summary>
/// <param name="SourceProgramId">Curso que o aluno já cursou / curso de referência.</param>
/// <param name="TargetProgramId">Curso que o aluno deseja ingressar.</param>
public sealed record CompareProgramsQuery(
    int SourceProgramId,
    int TargetProgramId
) : IQuery<CourseComparisonResponse>;
