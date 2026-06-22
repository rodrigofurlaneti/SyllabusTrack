using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SyllabusTrack.Application.Features.Enrollments;
using SyllabusTrack.Application.Features.Enrollments.AddProgress;
using SyllabusTrack.Application.Features.Enrollments.Create;
using SyllabusTrack.Application.Features.Enrollments.GetByStudent;
using System.Security.Claims;

namespace SyllabusTrack.API.Controllers;

/// <summary>
/// Gerenciamento de Matrículas e Progresso Acadêmico
/// </summary>
[Authorize]
public sealed class EnrollmentsController(ISender sender) : ApiController
{
    /// <summary>
    /// Retorna todas as matrículas de um estudante com seu progresso
    /// </summary>
    [HttpGet("student/{studentId:int}")]
    [ProducesResponseType(typeof(IReadOnlyCollection<EnrollmentResponse>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetByStudent(int studentId, CancellationToken cancellationToken)
    {
        var result = await sender.Send(new GetEnrollmentsByStudentQuery(studentId), cancellationToken);
        return HandleResult(result);
    }

    /// <summary>
    /// Matricula um estudante em um curso
    /// </summary>
    [HttpPost]
    [ProducesResponseType(typeof(int), StatusCodes.Status201Created)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Create(
        [FromBody] CreateEnrollmentCommand command,
        CancellationToken cancellationToken)
    {
        var result = await sender.Send(command, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new ProblemDetails
            {
                Title = "Enrollment Failed",
                Detail = result.Error.Message,
                Extensions = { ["code"] = result.Error.Code }
            });

        return Created(string.Empty, new { enrollmentId = result.Value });
    }

    /// <summary>
    /// Adiciona ou atualiza o progresso de uma disciplina em uma matrícula
    /// </summary>
    [HttpPost("{enrollmentId:int}/progress")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
    public async Task<IActionResult> AddProgress(
        int enrollmentId,
        [FromBody] AddProgressRequest request,
        CancellationToken cancellationToken)
    {
        var command = new AddProgressCommand(
            enrollmentId,
            request.SubjectId,
            request.CompletionStatus,
            request.SemesterTaken,
            request.FinalGrade);

        var result = await sender.Send(command, cancellationToken);
        return HandleResult(result);
    }
}

public sealed record AddProgressRequest(
    int SubjectId,
    string CompletionStatus,
    string SemesterTaken,
    decimal? FinalGrade);
