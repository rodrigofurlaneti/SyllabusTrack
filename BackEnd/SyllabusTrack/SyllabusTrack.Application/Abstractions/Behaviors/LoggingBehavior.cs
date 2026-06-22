using MediatR;
using Microsoft.Extensions.Logging;
using SyllabusTrack.Domain.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SyllabusTrack.Application.Abstractions.Behaviors
{
    public sealed class LoggingBehavior<TRequest, TResponse>(ILogger<LoggingBehavior<TRequest, TResponse>> logger)
        : IPipelineBehavior<TRequest, TResponse>
        where TRequest : IRequest<TResponse>
        where TResponse : Result
    {
        public async Task<TResponse> Handle(
            TRequest request,
            RequestHandlerDelegate<TResponse> next,
            CancellationToken cancellationToken)
        {
            logger.LogInformation("Starting request {@RequestName}", typeof(TRequest).Name);

            var result = await next();

            if (result.IsFailure)
            {
                logger.LogError("Request failure {@RequestName}, {@Error}", typeof(TRequest).Name, result.Error);
            }
            else
            {
                logger.LogInformation("Completed request {@RequestName}", typeof(TRequest).Name);
            }

            return result;
        }
    }
}
