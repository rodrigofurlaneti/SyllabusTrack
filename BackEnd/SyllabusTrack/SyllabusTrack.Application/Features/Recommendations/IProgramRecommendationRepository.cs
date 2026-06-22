namespace SyllabusTrack.Application.Features.Recommendations;

/// <summary>
/// Repositório de leitura para o ranking de aproveitamento de cursos.
/// Definido em Application para desacoplar do banco de dados.
/// </summary>
public interface IProgramRecommendationRepository
{
    Task<IReadOnlyCollection<ProgramRecommendationResponse>> GetRecommendationsAsync(
        int studentId,
        CancellationToken cancellationToken = default);
}
