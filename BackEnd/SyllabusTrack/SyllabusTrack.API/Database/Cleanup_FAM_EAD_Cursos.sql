-- ============================================================
-- LIMPEZA COMPLETA: Remove todos os cursos FAM EAD (com FK cascade manual)
-- Execute ANTES de re-executar o Seed_FAM_EAD_Cursos.sql
-- ============================================================
USE SyllabusTrackDb;
GO

DECLARE @FamId INT = (SELECT InstitutionId FROM EducationalInstitution WHERE InstitutionAcronym = 'FAM');

-- Coleta os ProgramIds FAM EAD a remover
CREATE TABLE #EADPrograms (ProgramId INT PRIMARY KEY);

INSERT INTO #EADPrograms
SELECT ProgramId FROM DegreeProgram
WHERE InstitutionId = @FamId
  AND CurriculumVersion LIKE '%EAD%';

-- Coleta os SubjectIds envolvidos
CREATE TABLE #EADSubjects (SubjectId INT PRIMARY KEY);

INSERT INTO #EADSubjects
SELECT s.SubjectId
FROM AcademicSubject s
INNER JOIN CourseModule  cm  ON cm.ModuleId  = s.ModuleId
INNER JOIN AcademicTerm  at2 ON at2.TermId   = cm.TermId
WHERE at2.ProgramId IN (SELECT ProgramId FROM #EADPrograms);

-- 1. StudentProgress (referencia SubjectId)
DELETE sp
FROM StudentProgress sp
WHERE sp.SubjectId IN (SELECT SubjectId FROM #EADSubjects);

-- 2. StudentEnrollment (referencia ProgramId)
DELETE se
FROM StudentEnrollment se
WHERE se.ProgramId IN (SELECT ProgramId FROM #EADPrograms);

-- 3. AcademicSubject
DELETE s
FROM AcademicSubject s
WHERE s.SubjectId IN (SELECT SubjectId FROM #EADSubjects);

-- 4. CourseModule com TermId válido (vinculados a programas EAD)
DELETE cm
FROM CourseModule cm
INNER JOIN AcademicTerm at2 ON at2.TermId = cm.TermId
WHERE at2.ProgramId IN (SELECT ProgramId FROM #EADPrograms);

-- 5. CourseModule órfãos (TermId NULL de execuções anteriores com erro)
DELETE FROM CourseModule
WHERE TermId IS NULL
  AND (   ModuleCode LIKE 'ADM-%'  OR ModuleCode LIKE 'CC-%'   OR ModuleCode LIKE 'CE-%'
       OR ModuleCode LIKE 'CEX-%'  OR ModuleCode LIKE 'CI-%'   OR ModuleCode LIKE 'DGD-%'
       OR ModuleCode LIKE 'EI-%'   OR ModuleCode LIKE 'GC-%'   OR ModuleCode LIKE 'GQ-%'
       OR ModuleCode LIKE 'GRH-%'  OR ModuleCode LIKE 'GF-%'   OR ModuleCode LIKE 'LOG-%'
       OR ModuleCode LIKE 'MKT-%'  OR ModuleCode LIKE 'MDDS-%' OR ModuleCode LIKE 'PG-%'
       OR ModuleCode LIKE 'RP-%'   OR ModuleCode LIKE 'SEP-%');

-- 6. AcademicTerm
DELETE at2
FROM AcademicTerm at2
WHERE at2.ProgramId IN (SELECT ProgramId FROM #EADPrograms);

-- 7. DegreeProgram
DELETE FROM DegreeProgram
WHERE ProgramId IN (SELECT ProgramId FROM #EADPrograms);

-- Limpeza da tabela temporária
DROP TABLE #EADSubjects;
DROP TABLE #EADPrograms;

-- Verificação final
SELECT 'Cursos FAM EAD restantes (deve ser 0):' AS Status, COUNT(*) AS Total
FROM DegreeProgram dp
JOIN EducationalInstitution ei ON ei.InstitutionId = dp.InstitutionId
WHERE ei.InstitutionAcronym = 'FAM'
  AND dp.CurriculumVersion LIKE '%EAD%';
