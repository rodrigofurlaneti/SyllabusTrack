using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.ValueObjects;

namespace SyllabusTrack.Infrastructure.Persistence.Configurations;

internal sealed class StudentProgressConfiguration : IEntityTypeConfiguration<StudentProgress>
{
    public void Configure(EntityTypeBuilder<StudentProgress> builder)
    {
        builder.ToTable("StudentProgress");

        builder.HasKey(p => p.Id);

        builder.Property(p => p.Id)
            .HasColumnName("ProgressId")
            .UseIdentityColumn();

        builder.Property(p => p.EnrollmentId)
            .HasColumnName("EnrollmentId")
            .IsRequired();

        builder.Property(p => p.SubjectId)
            .HasColumnName("SubjectId")
            .IsRequired();

        builder.Property(p => p.CompletionStatus)
            .HasColumnName("CompletionStatus")
            .HasColumnType("VARCHAR(50)")
            .IsRequired();

        builder.Property(p => p.SemesterTaken)
            .HasColumnName("SemesterTaken")
            .HasColumnType("VARCHAR(20)");

        // Mapeamento do Value Object Grade → coluna DECIMAL
        builder.Property(p => p.FinalGrade)
            .HasColumnName("FinalGrade")
            .HasColumnType("DECIMAL(5,2)")
            .HasConversion(
                grade => grade != null ? (decimal?)grade.Value : null,
                value => value.HasValue ? Grade.Create(value.Value).Value : null);

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

        // Relacionamento: StudentProgress → AcademicSubject
        builder.HasOne<AcademicSubject>()
            .WithMany()
            .HasForeignKey(p => p.SubjectId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
