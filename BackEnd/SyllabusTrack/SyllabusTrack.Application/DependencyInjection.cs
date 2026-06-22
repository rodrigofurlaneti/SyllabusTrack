using FluentValidation;
using Microsoft.Extensions.DependencyInjection;
using SyllabusTrack.Application.Abstractions.Behaviors;

namespace SyllabusTrack.Application
{
    public static class DependencyInjection
    {
        public static IServiceCollection AddApplication(this IServiceCollection services)
        {
            var assembly = typeof(DependencyInjection).Assembly;

            // Registra o MediatR e injeta os Pipeline Behaviors
            services.AddMediatR(configuration =>
            {
                configuration.RegisterServicesFromAssembly(assembly);

                configuration.AddOpenBehavior(typeof(LoggingBehavior<,>));
                configuration.AddOpenBehavior(typeof(ValidationBehavior<,>));
            });

            // Registra todos os Validators do FluentValidation automaticamente
            services.AddValidatorsFromAssembly(assembly);

            return services;
        }
    }
}
