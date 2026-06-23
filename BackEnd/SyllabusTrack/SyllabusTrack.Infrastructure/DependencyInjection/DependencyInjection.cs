using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using SyllabusTrack.Application.Abstractions.Authentication;
using SyllabusTrack.Application.Features.AcademicPlanning;
using SyllabusTrack.Application.Features.CourseComparison;
using SyllabusTrack.Application.Features.Recommendations;
using SyllabusTrack.Domain.Repositories;
using SyllabusTrack.Infrastructure.Persistence;
using SyllabusTrack.Infrastructure.Persistence.Repositories;
using SyllabusTrack.Infrastructure.Security;
using System.Text;

namespace SyllabusTrack.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructure(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        // === DATABASE ===
        services.AddDbContext<AppDbContext>(options =>
            options.UseSqlServer(
                configuration.GetConnectionString("DefaultConnection"),
                sqlOptions => sqlOptions.EnableRetryOnFailure(
                    maxRetryCount: 3,
                    maxRetryDelay: TimeSpan.FromSeconds(5),
                    errorNumbersToAdd: null)));

        // === REPOSITORIES ===
        services.AddScoped<IEducationalInstitutionRepository, EducationalInstitutionRepository>();
        services.AddScoped<IDegreeProgramRepository, DegreeProgramRepository>();
        services.AddScoped<IAcademicSubjectRepository, AcademicSubjectRepository>();
        services.AddScoped<IStudentAccountRepository, StudentAccountRepository>();
        services.AddScoped<IStudentEnrollmentRepository, StudentEnrollmentRepository>();
        services.AddScoped<IProgramRecommendationRepository, ProgramRecommendationRepository>();
        services.AddScoped<ICourseComparisonRepository, CourseComparisonRepository>();
        services.AddScoped<IAcademicPlanningRepository, AcademicPlanningRepository>();
        services.AddScoped<IUnitOfWork, UnitOfWork>();

        // === SECURITY ===
        services.Configure<JwtOptions>(configuration.GetSection(JwtOptions.SectionName));
        services.AddScoped<IJwtProvider, JwtProvider>();
        services.AddScoped<IPasswordHasher, PasswordHasher>();

        // === JWT AUTHENTICATION ===
        var jwtSettings = configuration.GetSection(JwtOptions.SectionName).Get<JwtOptions>()!;

        services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(options =>
            {
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = true,
                    ValidateIssuerSigningKey = true,
                    ValidIssuer = jwtSettings.Issuer,
                    ValidAudience = jwtSettings.Audience,
                    IssuerSigningKey = new SymmetricSecurityKey(
                        Encoding.UTF8.GetBytes(jwtSettings.SecretKey)),
                    ClockSkew = TimeSpan.Zero
                };
            });

        services.AddAuthorization();

        return services;
    }
}
