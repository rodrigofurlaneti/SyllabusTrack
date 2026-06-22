using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SyllabusTrack.Application.Features.Recommendations;
using SyllabusTrack.Application.Features.Recommendations.GetRecommendations;

namespace SyllabusTrack.API.Controllers;

/// <summary>
/// Ranking de cursos por aproveitamento de disciplinas já concluídas
/// </summary>
[Authorize]
public sealed class RecommendationsController(ISender sender) : ApiController
{
    /// <summary>
    /// Retorna os cursos rankeados pelo percentual de aproveitamento do aluno.
    /// Compara as disciplinas concluídas com as grades curriculares de cursos
    /// nos quais o aluno ainda não está matriculado.
    /// </summary>
    /// <param name="studentId">ID do aluno</param>
    [HttpGet("student/{studentId:int}")]
    [ProducesResponseType(typeof(IReadOnlyCollection<ProgramRecommendationResponse>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> GetRecommendations(
        int studentId,
        CancellationToken cancellationToken)
    {
        var result = await sender.Send(
            new GetProgramRecommendationsQuery(studentId),
            cancellationToken);

        return HandleResult(result);
    }
}
