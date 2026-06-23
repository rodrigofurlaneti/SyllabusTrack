namespace SyllabusTrack.Application.Features.MultiplePlanning;

public interface IMultiplePlanningRepository
{
    /// <summary>
    /// Gera o planejamento com múltiplos cursos de referência.
    /// O conjunto de disciplinas aproveitáveis é a UNIÃO de todos os <paramref name="sourceProgramIds"/>.
    /// </summary>
    Task<MultiplePlanningResponse?> GetMultiplePlanAsync(
        IReadOnlyCollection<int> sourceProgramIds,
        int targetProgramId,
        CancellationToken cancellationToken = default);
}
