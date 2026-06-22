using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SyllabusTrack.Application.Features.AcademicSubjects.Create;

namespace SyllabusTrack.API.Controllers;

/// <summary>
/// Gerenciamento de Disciplinas (Academic Subjects)
/// </summary>
[Authorize]
public sealed class SubjectsController(ISender sender) : ApiController
{
    /// <summary>
    /// Cria uma nova disciplina vinculada a um módulo
    /// </summary>
    [HttpPost]
    [ProducesResponseType(typeof(int), StatusCodes.Status201Created)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Create(
        [FromBody] CreateSubjectCommand command,
        CancellationToken cancellationToken)
    {
        var result = await sender.Send(command, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new ProblemDetails
            {
                Title = "Creation Failed",
                Detail = result.Error.Message,
                Extensions = { ["code"] = result.Error.Code }
            });

        return Created(string.Empty, new { subjectId = result.Value });
    }
}
