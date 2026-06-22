using Microsoft.EntityFrameworkCore;
using SyllabusTrack.Domain.Entities;
using SyllabusTrack.Domain.Primitives;
using System.Reflection;

namespace SyllabusTrack.Infrastructure.Persistence;

public sealed class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<EducationalInstitution> EducationalInstitutions { get; set; }
    public DbSet<DegreeProgram> DegreePrograms { get; set; }
    public DbSet<AcademicSubject> AcademicSubjects { get; set; }
    public DbSet<StudentAccount> StudentAccounts { get; set; }
    public DbSet<StudentEnrollment> StudentEnrollments { get; set; }
    public DbSet<StudentProgress> StudentProgresses { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Aplica todas as configurações do assembly automaticamente (IEntityTypeConfiguration<T>)
        modelBuilder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());
        base.OnModelCreating(modelBuilder);
    }
}
