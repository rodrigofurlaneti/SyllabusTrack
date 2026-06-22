using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.ValueObjects;

namespace SyllabusTrack.Infrastructure.Persistence.Configurations;

internal sealed class StudentAccountConfiguration : IEntityTypeConfiguration<StudentAccount>
{
    public void Configure(EntityTypeBuilder<StudentAccount> builder)
    {
        builder.ToTable("StudentAccount");

        builder.HasKey(s => s.Id);

        builder.Property(s => s.Id)
            .HasColumnName("StudentId")
            .UseIdentityColumn();

        builder.Property(s => s.StudentFullName)
            .HasColumnName("StudentFullName")
            .HasColumnType("VARCHAR(255)")
            .IsRequired();

        builder.Property(s => s.LoginUsername)
            .HasColumnName("LoginUsername")
            .HasColumnType("VARCHAR(50)")
            .IsRequired();

        builder.HasIndex(s => s.LoginUsername)
            .IsUnique();

        // Mapeamento do Value Object Email → coluna simples
        builder.Property(s => s.EmailAddress)
            .HasColumnName("EmailAddress")
            .HasColumnType("VARCHAR(255)")
            .IsRequired()
            .HasConversion(
                email => email.Value,
                value => Email.Create(value).Value);

        builder.HasIndex(s => s.EmailAddress)
            .IsUnique();

        builder.Property(s => s.CellPhoneNumber)
            .HasColumnName("CellPhoneNumber")
            .HasColumnType("VARCHAR(20)")
            .IsRequired();

        builder.Property(s => s.AccountPassword)
            .HasColumnName("AccountPassword")
            .HasColumnType("VARCHAR(255)")
            .IsRequired();

        builder.Property(s => s.IsActive)
            .HasColumnName("IsActive")
            .HasDefaultValue(true)
            .IsRequired();

        builder.Property(s => s.CreatedAt)
            .HasColumnName("CreatedAt")
            .HasColumnType("DATETIME")
            .HasDefaultValueSql("GETDATE()");

        builder.Property(s => s.UpdatedAt)
            .HasColumnName("UpdatedAt")
            .HasColumnType("DATETIME")
            .HasDefaultValueSql("GETDATE()");
    }
}
