namespace SyllabusTrack.Application.Features.Institutions
{
    public sealed record InstitutionResponse(
        int InstitutionId,
        string InstitutionName,
        string InstitutionAcronym,
        string CampusLocation,
        bool IsActive);
}
