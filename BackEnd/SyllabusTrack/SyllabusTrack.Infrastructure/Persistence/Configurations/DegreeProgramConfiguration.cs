using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SyllabusTrack.Domain.Entities;

namespace SyllabusTrack.Infrastructure.Persistence.Configurations;

internal sealed class DegreeProgramConfiguration : IEntityTypeConfiguration<DegreeProgram>
{
    public void Configure(EntityTypeBuilder<DegreeProgram> builder)
    {
        builder.ToTable("DegreeProgram");

        builder.HasKey(p => p.Id);

        builder.Property(p => p.Id)
            .HasColumnName("ProgramId")
            .UseIdentityColumn();

        builder.Property(p => p.InstitutionId)
            .HasColumnName("InstitutionId")
            .IsRequired();

        builder.Property(p => p.ProgramName)
            .HasColumnName("ProgramName")
            .HasColumnType("VARCHAR(255)")
            .IsRequired();

        builder.Property(p => p.CurriculumVersion)
            .HasColumnName("CurriculumVersion")
            .HasColumnType("VARCHAR(100)")
            .IsRequired();

        builder.Property(p => p.TotalSemesters)
            .HasColumnName("TotalSemesters")
            .IsRequired();

        builder.Property(p => p.IsActive)
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

        // Relacionamento: DegreeProgram → EducationalInstitution
        builder.HasOne<EducationalInstitution>()
            .WithMany()
            .HasForeignKey(p => p.InstitutionId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
