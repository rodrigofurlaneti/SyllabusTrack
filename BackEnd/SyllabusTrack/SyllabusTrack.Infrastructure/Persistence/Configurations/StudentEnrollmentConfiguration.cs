using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SyllabusTrack.Domain.Entities;

namespace SyllabusTrack.Infrastructure.Persistence.Configurations;

internal sealed class StudentEnrollmentConfiguration : IEntityTypeConfiguration<StudentEnrollment>
{
    public void Configure(EntityTypeBuilder<StudentEnrollment> builder)
    {
        builder.ToTable("StudentEnrollment");

        builder.HasKey(e => e.Id);

        builder.Property(e => e.Id)
            .HasColumnName("EnrollmentId")
            .UseIdentityColumn();

        builder.Property(e => e.StudentId)
            .HasColumnName("StudentId")
            .IsRequired();

        builder.Property(e => e.ProgramId)
            .HasColumnName("ProgramId")
            .IsRequired();

        builder.Property(e => e.EnrollmentDate)
            .HasColumnName("EnrollmentDate")
            .HasColumnType("DATE")
            .IsRequired();

        builder.Property(e => e.EnrollmentStatus)
            .HasColumnName("EnrollmentStatus")
            .HasColumnType("VARCHAR(50)")
            .IsRequired();

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

        // Relacionamento: StudentEnrollment → StudentAccount
        builder.HasOne<StudentAccount>()
            .WithMany()
            .HasForeignKey(e => e.StudentId)
            .OnDelete(DeleteBehavior.Restrict);

        // Relacionamento: StudentEnrollment → DegreeProgram
        builder.HasOne<DegreeProgram>()
            .WithMany()
            .HasForeignKey(e => e.ProgramId)
            .OnDelete(DeleteBehavior.Restrict);

        // Relacionamento 1:N com StudentProgress (encapsulado via campo privado)
        builder.HasMany(e => e.Progresses)
            .WithOne()
            .HasForeignKey(p => p.EnrollmentId)
            .OnDelete(DeleteBehavior.Cascade);

        // Carrega a coleção privada _progresses via backing field
        builder.Navigation(e => e.Progresses)
            .UsePropertyAccessMode(PropertyAccessMode.Field);
    }
}
