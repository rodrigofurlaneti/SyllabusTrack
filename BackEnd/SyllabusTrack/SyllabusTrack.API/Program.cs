using SyllabusTrack.API.Extensions;
using SyllabusTrack.API.Middleware;
using SyllabusTrack.Application;
using SyllabusTrack.Infrastructure;

var builder = WebApplication.CreateBuilder(args);

// ==========================================
// SERVICES
// ==========================================

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerWithJwt();

// Camadas de Clean Architecture
builder.Services.AddApplication();
builder.Services.AddInfrastructure(builder.Configuration);

// CORS — ajuste os origins para produção
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend", policy =>
        policy
            .AllowAnyOrigin()
            .AllowAnyHeader()
            .AllowAnyMethod());
});

builder.Services.AddHealthChecks();

var app = builder.Build();

// ==========================================
// PIPELINE
// ==========================================

app.UseMiddleware<GlobalExceptionHandlingMiddleware>();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "SyllabusTrack API v1");
        c.RoutePrefix = string.Empty; // Swagger na raiz "/"
    });
}

app.UseHttpsRedirection();
app.UseCors("AllowFrontend");

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
app.MapHealthChecks("/health");

app.Run();
