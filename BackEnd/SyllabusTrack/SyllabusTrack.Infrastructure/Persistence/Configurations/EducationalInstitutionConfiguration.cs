using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SyllabusTrack.Domain.Entities;

namespace SyllabusTrack.Infrastructure.Persistence.Configurations;

internal sealed class EducationalInstitutionConfiguration : IEntityTypeConfiguration<EducationalInstitution>
{
    public void Configure(EntityTypeBuilder<EducationalInstitution> builder)
    {
        builder.ToTable("EducationalInstitution");

        builder.HasKey(e => e.Id);

        builder.Property(e => e.Id)
            .HasColumnName("InstitutionId")
            .UseIdentityColumn();

        builder.Property(e => e.InstitutionName)
            .HasColumnName("InstitutionName")
            .HasColumnType("VARCHAR(255)")
            .IsRequired();

        builder.Property(e => e.InstitutionAcronym)
            .HasColumnName("InstitutionAcronym")
            .HasColumnType("VARCHAR(50)");

        builder.Property(e => e.CampusLocation)
            .HasColumnName("CampusLocation")
            .HasColumnType("VARCHAR(255)");

        builder.Property(e => e.IsActive)
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
