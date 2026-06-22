using MediatR;
using Microsoft.AspNetCore.Mvc;
using SyllabusTrack.Application.Features.Auth.Login;
using SyllabusTrack.Application.Features.Auth.Register;

namespace SyllabusTrack.API.Controllers;

/// <summary>
/// Autenticação de estudantes (registro e login)
/// </summary>
public sealed class AuthController(ISender sender) : ApiController
{
    /// <summary>
    /// Registra um novo estudante
    /// </summary>
    /// <returns>ID do novo estudante criado</returns>
    [HttpPost("register")]
    [ProducesResponseType(typeof(int), StatusCodes.Status201Created)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Register(
        [FromBody] RegisterStudentCommand command,
        CancellationToken cancellationToken)
    {
        var result = await sender.Send(command, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new ProblemDetails
            {
                Title = "Registration Failed",
                Detail = result.Error.Message,
                Extensions = { ["code"] = result.Error.Code }
            });

        return Created(string.Empty, new { studentId = result.Value });
    }

    /// <summary>
    /// Autentica um estudante e retorna o token JWT
    /// </summary>
    /// <returns>Token JWT</returns>
    [HttpPost("login")]
    [ProducesResponseType(typeof(object), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> Login(
        [FromBody] LoginStudentQuery query,
        CancellationToken cancellationToken)
    {
        var result = await sender.Send(query, cancellationToken);

        if (result.IsFailure)
            return Unauthorized(new ProblemDetails
            {
                Title = "Authentication Failed",
                Detail = result.Error.Message,
                Extensions = { ["code"] = result.Error.Code }
            });

        return Ok(new { token = result.Value });
    }
}
