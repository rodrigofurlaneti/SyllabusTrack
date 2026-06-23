# ── Stage 1: Build ────────────────────────────────────────────────────────────
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copia arquivos de projeto e restaura dependências (camada cacheada)
COPY ["SyllabusTrack.API/SyllabusTrack.API.csproj",             "SyllabusTrack.API/"]
COPY ["SyllabusTrack.Application/SyllabusTrack.Application.csproj", "SyllabusTrack.Application/"]
COPY ["SyllabusTrack.Domain/SyllabusTrack.Domain.csproj",       "SyllabusTrack.Domain/"]
COPY ["SyllabusTrack.Infrastructure/SyllabusTrack.Infrastructure.csproj", "SyllabusTrack.Infrastructure/"]

RUN dotnet restore "SyllabusTrack.API/SyllabusTrack.API.csproj"

# Copia o restante e publica em Release
COPY . .
WORKDIR /src/SyllabusTrack.API
RUN dotnet publish "SyllabusTrack.API.csproj" -c Release -o /app/publish --no-restore

# ── Stage 2: Runtime ───────────────────────────────────────────────────────────
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Usuário não-root para segurança
RUN adduser --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

COPY --from=build /app/publish .

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

ENTRYPOINT ["dotnet", "SyllabusTrack.API.dll"]
