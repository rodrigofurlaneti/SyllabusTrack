-- ============================================================
-- Matrícula rodrigo.madeira nos cursos FAM
-- Banco de Dados - EAD  +  Análise e Desenvolvimento de Sistemas
-- Todas as disciplinas como 'Pending' (aluno iniciando o curso)
-- ============================================================
USE SyllabusTrackDb;
GO

DECLARE @StudentId INT = (
    SELECT StudentId FROM StudentAccount WHERE LoginUsername = 'rodrigo.madeira' AND IsActive = 1
);

IF @StudentId IS NULL
BEGIN
    RAISERROR('Aluno rodrigo.madeira não encontrado.', 16, 1);
    RETURN;
END

-- ============================================================
-- 1. CURSO: Banco de Dados - EAD
-- ============================================================
DECLARE @BD_ProgramId INT = (
    SELECT p.ProgramId
    FROM DegreeProgram p
    JOIN EducationalInstitution i ON i.InstitutionId = p.InstitutionId
    WHERE i.InstitutionAcronym = 'FAM'
      AND p.ProgramName = 'Banco de Dados'
);

IF @BD_ProgramId IS NULL
BEGIN
    RAISERROR('Curso Banco de Dados (FAM) não encontrado. Execute Seed_FAM_Courses.sql primeiro.', 16, 1);
    RETURN;
END

-- Cria matrícula (se ainda não existir)
IF NOT EXISTS (
    SELECT 1 FROM StudentEnrollment
    WHERE StudentId = @StudentId AND ProgramId = @BD_ProgramId AND IsActive = 1
)
BEGIN
    INSERT INTO StudentEnrollment (StudentId, ProgramId, EnrollmentDate, EnrollmentStatus)
    VALUES (@StudentId, @BD_ProgramId, GETDATE(), 'Active');
END

DECLARE @BD_EnrollmentId INT = (
    SELECT TOP 1 EnrollmentId FROM StudentEnrollment
    WHERE StudentId = @StudentId AND ProgramId = @BD_ProgramId AND IsActive = 1
);

-- Insere todas as disciplinas como Pending (ignora duplicatas)
INSERT INTO StudentProgress (EnrollmentId, SubjectId, CompletionStatus, SemesterTaken, FinalGrade)
SELECT
    @BD_EnrollmentId,
    s.SubjectId,
    'Pending',
    NULL,
    NULL
FROM AcademicSubject s
JOIN CourseModule    m ON m.ModuleId  = s.ModuleId
JOIN AcademicTerm   t ON t.TermId    = m.TermId
WHERE t.ProgramId = @BD_ProgramId
  AND s.IsActive  = 1
  AND NOT EXISTS (
    SELECT 1 FROM StudentProgress sp
    WHERE sp.EnrollmentId = @BD_EnrollmentId
      AND sp.SubjectId    = s.SubjectId
      AND sp.IsActive     = 1
  );

PRINT 'BD - Disciplinas inseridas: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- ============================================================
-- 2. CURSO: Análise e Desenvolvimento de Sistemas
-- ============================================================
DECLARE @ADS_ProgramId INT = (
    SELECT p.ProgramId
    FROM DegreeProgram p
    JOIN EducationalInstitution i ON i.InstitutionId = p.InstitutionId
    WHERE i.InstitutionAcronym = 'FAM'
      AND p.ProgramName = 'Análise e Desenvolvimento de Sistemas'
);

IF @ADS_ProgramId IS NULL
BEGIN
    RAISERROR('Curso ADS (FAM) não encontrado. Execute Seed_FAM_Courses.sql primeiro.', 16, 1);
    RETURN;
END

-- Cria matrícula (se ainda não existir)
IF NOT EXISTS (
    SELECT 1 FROM StudentEnrollment
    WHERE StudentId = @StudentId AND ProgramId = @ADS_ProgramId AND IsActive = 1
)
BEGIN
    INSERT INTO StudentEnrollment (StudentId, ProgramId, EnrollmentDate, EnrollmentStatus)
    VALUES (@StudentId, @ADS_ProgramId, GETDATE(), 'Active');
END

DECLARE @ADS_EnrollmentId INT = (
    SELECT TOP 1 EnrollmentId FROM StudentEnrollment
    WHERE StudentId = @StudentId AND ProgramId = @ADS_ProgramId AND IsActive = 1
);

-- Insere todas as disciplinas como Pending (ignora duplicatas)
INSERT INTO StudentProgress (EnrollmentId, SubjectId, CompletionStatus, SemesterTaken, FinalGrade)
SELECT
    @ADS_EnrollmentId,
    s.SubjectId,
    'Pending',
    NULL,
    NULL
FROM AcademicSubject s
JOIN CourseModule    m ON m.ModuleId  = s.ModuleId
JOIN AcademicTerm   t ON t.TermId    = m.TermId
WHERE t.ProgramId = @ADS_ProgramId
  AND s.IsActive  = 1
  AND NOT EXISTS (
    SELECT 1 FROM StudentProgress sp
    WHERE sp.EnrollmentId = @ADS_EnrollmentId
      AND sp.SubjectId    = s.SubjectId
      AND sp.IsActive     = 1
  );

PRINT 'ADS - Disciplinas inseridas: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- ============================================================
-- 3. RESUMO
-- ============================================================
SELECT
    p.ProgramName                               AS Curso,
    e.EnrollmentStatus                          AS Status,
    COUNT(sp.ProgressId)                        AS TotalDisciplinas,
    SUM(CASE WHEN sp.CompletionStatus = 'Pending'    THEN 1 ELSE 0 END) AS Pendentes,
    SUM(CASE WHEN sp.CompletionStatus = 'Completed'  THEN 1 ELSE 0 END) AS Concluidas
FROM StudentEnrollment e
JOIN DegreeProgram     p  ON p.ProgramId    = e.ProgramId
JOIN EducationalInstitution i ON i.InstitutionId = p.InstitutionId
LEFT JOIN StudentProgress sp ON sp.EnrollmentId = e.EnrollmentId AND sp.IsActive = 1
WHERE e.StudentId = @StudentId
  AND i.InstitutionAcronym = 'FAM'
  AND e.IsActive = 1
GROUP BY p.ProgramName, e.EnrollmentStatus;
