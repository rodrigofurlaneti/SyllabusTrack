namespace SyllabusTrack.Application.Features.MultipleTargetsPlanning;

public interface IMultipleTargetsPlanningRepository
{
    /// <summary>
    /// Constrói a UNIÃO de disciplinas de todos os <paramref name="sourceProgramIds"/>
    /// e calcula o aproveitamento contra cada curso em <paramref name="targetProgramIds"/>.
    /// Retorna <c>null</c> se qualquer um dos programas não for encontrado.
    /// </summary>
    Task<MultipleTargetsPlanningResponse?> GetMultipleTargetsPlanAsync(
        IReadOnlyCollection<int> sourceProgramIds,
        IReadOnlyCollection<int> targetProgramIds,
        CancellationToken cancellationToken = default);
}
