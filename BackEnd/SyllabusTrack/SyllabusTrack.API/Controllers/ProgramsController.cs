using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SyllabusTrack.Application.Features.AcademicPlanning;
using SyllabusTrack.Application.Features.CourseComparison;
using SyllabusTrack.Application.Features.MultiplePlanning;
using SyllabusTrack.Application.Features.MultipleTargetsPlanning;
using SyllabusTrack.Application.Features.DegreePrograms;
using SyllabusTrack.Application.Features.DegreePrograms.Create;
using SyllabusTrack.Application.Features.DegreePrograms.GetAll;
using SyllabusTrack.Application.Features.DegreePrograms.GetById;
using SyllabusTrack.Application.Features.DegreePrograms.Update;

namespace SyllabusTrack.API.Controllers;

/// <summary>
/// Gerenciamento de Cursos (Degree Programs)
/// </summary>
[Authorize]
public sealed class ProgramsController(ISender sender) : ApiController
{
    /// <summary>
    /// Retorna todos os cursos ativos
    /// </summary>
    [HttpGet]
    [ProducesResponseType(typeof(IReadOnlyCollection<ProgramResponse>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetAll(CancellationToken cancellationToken)
    {
        var result = await sender.Send(new GetAllProgramsQuery(), cancellationToken);
        return HandleResult(result);
    }

    /// <summary>
    /// Retorna um curso pelo ID
    /// </summary>
    [HttpGet("{id:int}", Name = "GetProgramById")]
    [ProducesResponseType(typeof(ProgramResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetById(int id, CancellationToken cancellationToken)
    {
        var result = await sender.Send(new GetProgramByIdQuery(id), cancellationToken);

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
    /// Cria um novo curso vinculado a uma instituição
    /// </summary>
    [HttpPost]
    [ProducesResponseType(typeof(int), StatusCodes.Status201Created)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Create(
        [FromBody] CreateProgramCommand command,
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
            routeName: "GetProgramById",
            routeValues: new { id = result.Value },
            value: new { programId = result.Value });
    }

    /// <summary>
    /// Compara as disciplinas de dois cursos e retorna o percentual de aproveitamento.
    /// Útil para saber quanto do curso-alvo já é coberto pelo curso de referência.
    /// </summary>
    /// <param name="sourceId">ID do curso de referência (já cursado ou em andamento)</param>
    /// <param name="targetId">ID do curso-alvo (que se deseja ingressar)</param>
    [HttpGet("{sourceId:int}/compare/{targetId:int}")]
    [ProducesResponseType(typeof(CourseComparisonResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Compare(
        int sourceId,
        int targetId,
        CancellationToken cancellationToken)
    {
        var result = await sender.Send(new CompareProgramsQuery(sourceId, targetId), cancellationToken);

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
    /// Gera o planejamento acadêmico: quanto tempo o aluno levará para concluir o
    /// curso-alvo aproveitando o curso de referência já concluído.
    /// Retorna o batimento de disciplinas por semestre e estimativa de formatura.
    /// </summary>
    /// <param name="sourceId">ID do curso já concluído (referência)</param>
    /// <param name="targetId">ID do curso que deseja ingressar</param>
    [HttpGet("{sourceId:int}/planning/{targetId:int}")]
    [ProducesResponseType(typeof(AcademicPlanningResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetPlanning(
        int sourceId,
        int targetId,
        CancellationToken cancellationToken)
    {
        var result = await sender.Send(new GetAcademicPlanQuery(sourceId, targetId), cancellationToken);

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
    /// Gera o planejamento acadêmico com múltiplos cursos de referência.
    /// Retorna o aproveitamento da UNIÃO de disciplinas de todos os cursos-fonte
    /// comparada ao curso-alvo, com estimativa de tempo para formatura.
    /// </summary>
    /// <param name="request">Lista de IDs dos cursos já concluídos e o ID do curso-alvo.</param>
    [HttpPost("planning/multiple")]
    [ProducesResponseType(typeof(MultiplePlanningResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetMultiplePlanning(
        [FromBody] MultiplePlanningRequest request,
        CancellationToken cancellationToken)
    {
        var result = await sender.Send(
            new GetMultiplePlanQuery(request.SourceProgramIds, request.TargetProgramId),
            cancellationToken);

        if (result.IsFailure)
        {
            if (result.Error.Code.Contains("NotFound"))
                return NotFound(new ProblemDetails
                {
                    Title  = "Not Found",
                    Detail = result.Error.Message,
                    Extensions = { ["code"] = result.Error.Code }
                });

            return BadRequest(new ProblemDetails
            {
                Title  = "Bad Request",
                Detail = result.Error.Message,
                Extensions = { ["code"] = result.Error.Code }
            });
        }

        return Ok(result.Value);
    }

    /// <summary>
    /// Gera o planejamento com N cursos de referência contra N cursos-alvo.
    /// A UNIÃO de disciplinas dos cursos-fonte é calculada uma vez e aplicada
    /// individualmente contra cada curso-alvo. Retorna um resultado por alvo.
    /// </summary>
    /// <param name="request">IDs dos cursos concluídos (fontes) e dos cursos desejados (alvos).</param>
    [HttpPost("planning/multiple-targets")]
    [ProducesResponseType(typeof(MultipleTargetsPlanningResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetMultipleTargetsPlanning(
        [FromBody] MultipleTargetsPlanningRequest request,
        CancellationToken cancellationToken)
    {
        var result = await sender.Send(
            new GetMultipleTargetsPlanQuery(request.SourceProgramIds, request.TargetProgramIds),
            cancellationToken);

        if (result.IsFailure)
        {
            if (result.Error.Code.Contains("NotFound"))
                return NotFound(new ProblemDetails
                {
                    Title  = "Not Found",
                    Detail = result.Error.Message,
                    Extensions = { ["code"] = result.Error.Code }
                });

            return BadRequest(new ProblemDetails
            {
                Title  = "Bad Request",
                Detail = result.Error.Message,
                Extensions = { ["code"] = result.Error.Code }
            });
        }

        return Ok(result.Value);
    }

    /// <summary>
    /// Atualiza um curso existente
    /// </summary>
    [HttpPut("{id:int}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Update(
        int id,
        [FromBody] UpdateProgramRequest request,
        CancellationToken cancellationToken)
    {
        var command = new UpdateProgramCommand(id, request.ProgramName, request.CurriculumVersion, request.TotalSemesters);
        var result = await sender.Send(command, cancellationToken);
        return HandleResult(result);
    }
}

public sealed record UpdateProgramRequest(string ProgramName, string CurriculumVersion, int TotalSemesters);
