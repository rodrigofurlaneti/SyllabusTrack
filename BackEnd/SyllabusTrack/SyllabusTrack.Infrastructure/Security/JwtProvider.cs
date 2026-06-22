using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using SyllabusTrack.Application.Abstractions.Authentication;
using SyllabusTrack.Domain.Entities;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace SyllabusTrack.Infrastructure.Security;

internal sealed class JwtProvider(IOptions<JwtOptions> options) : IJwtProvider
{
    private readonly JwtOptions _options = options.Value;

    public string Generate(StudentAccount student)
    {
        var claims = new Claim[]
        {
            new(JwtRegisteredClaimNames.Sub, student.Id.ToString()),
            new(JwtRegisteredClaimNames.Email, student.EmailAddress.Value),
            new(JwtRegisteredClaimNames.UniqueName, student.LoginUsername),
            new(JwtRegisteredClaimNames.Name, student.StudentFullName),
            new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
        };

        var signingCredentials = new SigningCredentials(
            new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_options.SecretKey)),
            SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: _options.Issuer,
            audience: _options.Audience,
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(_options.ExpirationMinutes),
            signingCredentials: signingCredentials);

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}
