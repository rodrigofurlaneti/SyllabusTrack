using Microsoft.AspNetCore.Mvc;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Produces("application/json")]
public abstract class ApiController : ControllerBase
{
    /// <summary>
    /// Converte um Result em IActionResult padronizado.
    /// Sucesso → 200 OK / 201 Created
    /// Falha   → 400 Bad Request com detalhe do erro
    /// </summary>
    protected IActionResult HandleResult(Result result)
    {
        if (result.IsSuccess)
            return NoContent();

        return BadRequest(new ProblemDetails
        {
            Title = "Business Rule Violation",
            Detail = result.Error.Message,
            Extensions = { ["code"] = result.Error.Code }
        });
    }

    protected IActionResult HandleResult<T>(Result<T> result)
    {
        if (result.IsSuccess)
            return Ok(result.Value);

        return BadRequest(new ProblemDetails
        {
            Title = "Business Rule Violation",
            Detail = result.Error.Message,
            Extensions = { ["code"] = result.Error.Code }
        });
    }

    protected IActionResult HandleCreated<T>(Result<T> result, string routeName, object routeValues)
    {
        if (result.IsSuccess)
            return CreatedAtRoute(routeName, routeValues, result.Value);

        return BadRequest(new ProblemDetails
        {
            Title = "Business Rule Violation",
            Detail = result.Error.Message,
            Extensions = { ["code"] = result.Error.Code }
        });
    }
}
