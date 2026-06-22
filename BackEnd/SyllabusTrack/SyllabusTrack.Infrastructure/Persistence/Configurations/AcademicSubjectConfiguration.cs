using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SyllabusTrack.Domain.Entities;

namespace SyllabusTrack.Infrastructure.Persistence.Configurations;

internal sealed class AcademicSubjectConfiguration : IEntityTypeConfiguration<AcademicSubject>
{
    public void Configure(EntityTypeBuilder<AcademicSubject> builder)
    {
        builder.ToTable("AcademicSubject");

        builder.HasKey(s => s.Id);

        builder.Property(s => s.Id)
            .HasColumnName("SubjectId")
            .UseIdentityColumn();

        builder.Property(s => s.ModuleId)
            .HasColumnName("ModuleId")
            .IsRequired();

        builder.Property(s => s.SubjectCode)
            .HasColumnName("SubjectCode")
            .HasColumnType("VARCHAR(50)")
            .IsRequired();

        builder.Property(s => s.SubjectName)
            .HasColumnName("SubjectName")
            .HasColumnType("VARCHAR(255)")
            .IsRequired();

        builder.Property(s => s.SubjectCredits)
            .HasColumnName("SubjectCredits");

        builder.Property(s => s.TotalSubjectHours)
            .HasColumnName("TotalSubjectHours")
            .IsRequired();

        builder.Property(s => s.IsOptional)
            .HasColumnName("IsOptional")
            .HasDefaultValue(false);

        builder.Property(s => s.IsActive)
            .HasColumnName("IsActive")
            .HasDefaultValue(true)
            .IsRequired();

        builder.Property<DateTime>("CreatedAt")
            .HasColumnName("CreatedAt")
            .HasColumnType("DATETIME")
            .HasDefaultValueSql("GETDATE()");

        builder.Property<DateTime>("UpdatedAt")
            .HasColumnName("UpdatedAt")
            .HasColumnType("DATETIME")
            .HasDefaultValueSql("GETDATE()");
    }
}
