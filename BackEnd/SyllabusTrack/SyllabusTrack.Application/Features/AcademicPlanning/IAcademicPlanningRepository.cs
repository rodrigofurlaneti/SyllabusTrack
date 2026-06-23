namespace SyllabusTrack.Application.Features.AcademicPlanning;

public interface IAcademicPlanningRepository
{
    /// <summary>
    /// Gera o planejamento acadêmico: compara disciplinas por semestre e estima
    /// quantos semestres/anos o aluno levará para concluir o <paramref name="targetProgramId"/>
    /// aproveitando o <paramref name="sourceProgramId"/> já concluído.
    /// </summary>
    Task<AcademicPlanningResponse?> GetPlanAsync(
        int sourceProgramId,
        int targetProgramId,
        CancellationToken cancellationToken = default);
}
