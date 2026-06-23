using SyllabusTrack.Application.Abstractions.Messaging;

namespace SyllabusTrack.Application.Features.AcademicPlanning;

/// <param name="SourceProgramId">Curso já concluído (referência).</param>
/// <param name="TargetProgramId">Curso que deseja cursar.</param>
public sealed record GetAcademicPlanQuery(
    int SourceProgramId,
    int TargetProgramId
) : IQuery<AcademicPlanningResponse>;
