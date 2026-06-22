using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SyllabusTrack.Application.Features.Institutions;
using SyllabusTrack.Application.Features.Institutions.Create;
using SyllabusTrack.Application.Features.Institutions.GetAll;
using SyllabusTrack.Application.Features.Institutions.GetById;
using SyllabusTrack.Application.Features.Institutions.Update;

namespace SyllabusTrack.API.Controllers;

/// <summary>
/// Gerenciamento de Instituições de Ensino
/// </summary>
[Authorize]
public sealed class InstitutionsController(ISender sender) : ApiController
{
    /// <summary>
    /// Retorna todas as instituições ativas
    /// </summary>
    [HttpGet]
    [ProducesResponseType(typeof(IReadOnlyCollection<InstitutionResponse>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetAll(CancellationToken cancellationToken)
    {
        var result = await sender.Send(new GetAllInstitutionsQuery(), cancellationToken);
        return HandleResult(result);
    }

    /// <summary>
    /// Retorna uma instituição pelo ID
    /// </summary>
    [HttpGet("{id:int}", Name = "GetInstitutionById")]
    [ProducesResponseType(typeof(InstitutionResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetById(int id, CancellationToken cancellationToken)
    {
        var result = await sender.Send(new GetInstitutionByIdQuery(id), cancellationToken);

        if (result.IsFailure)
            return NotFound(new ProblemDetails
            {
                Title = "Not Found",
                Detail = result.Error.Message,
                Extensions = { ["code"] = result.Error.Code }
            });

        return Ok(result.Value);
    }

    /// <summary>
    /// Cria uma nova instituição
    /// </summary>
    [HttpPost]
    [ProducesResponseType(typeof(int), StatusCodes.Status201Created)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Create(
        [FromBody] CreateInstitutionCommand command,
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

        return CreatedAtRoute(
            routeName: "GetInstitutionById",
            routeValues: new { id = result.Value },
            value: new { institutionId = result.Value });
    }

    /// <summary>
    /// Atualiza uma instituição existente
    /// </summary>
    [HttpPut("{id:int}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Update(
        int id,
        [FromBody] UpdateInstitutionRequest request,
        CancellationToken cancellationToken)
    {
        var command = new UpdateInstitutionCommand(id, request.Name, request.Acronym, request.Location);
        var result = await sender.Send(command, cancellationToken);
        return HandleResult(result);
    }
}

/// <summary>
/// Request body para atualização de instituição (separa o ID de rota do corpo)
/// </summary>
public sealed record UpdateInstitutionRequest(string Name, string Acronym, string Location);
