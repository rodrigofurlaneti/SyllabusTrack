-- ============================================================
-- Cleanup_All.sql
-- Remove TODOS os dados de seed (UnirG + FAM) na ordem correta de FK
-- Execute ANTES de rodar SeedData.sql em um banco com dados existentes
-- ============================================================
USE SyllabusTrackDb;
GO

-- ============================================================
-- PASSO 1: Coleta os IDs das instituições a limpar
-- ============================================================
CREATE TABLE #InstitutionsToClean (InstitutionId INT PRIMARY KEY);
INSERT INTO #InstitutionsToClean
SELECT InstitutionId FROM EducationalInstitution
WHERE InstitutionAcronym IN ('FAM', 'UnirG');

CREATE TABLE #ProgramsToClean (ProgramId INT PRIMARY KEY);
INSERT INTO #ProgramsToClean
SELECT ProgramId FROM DegreeProgram
WHERE InstitutionId IN (SELECT InstitutionId FROM #InstitutionsToClean);

CREATE TABLE #SubjectsToClean (SubjectId INT PRIMARY KEY);
INSERT INTO #SubjectsToClean
SELECT s.SubjectId
FROM AcademicSubject s
INNER JOIN CourseModule  cm  ON cm.ModuleId  = s.ModuleId
INNER JOIN AcademicTerm  at2 ON at2.TermId   = cm.TermId
WHERE at2.ProgramId IN (SELECT ProgramId FROM #ProgramsToClean);

DECLARE @cntInst INT, @cntProg INT, @cntSubj INT;
SELECT @cntInst = COUNT(*) FROM #InstitutionsToClean;
SELECT @cntProg = COUNT(*) FROM #ProgramsToClean;
SELECT @cntSubj = COUNT(*) FROM #SubjectsToClean;
PRINT 'Instituições a limpar: ' + CAST(@cntInst AS VARCHAR);
PRINT 'Programas a limpar:    ' + CAST(@cntProg AS VARCHAR);
PRINT 'Disciplinas a limpar:  ' + CAST(@cntSubj AS VARCHAR);

-- ============================================================
-- PASSO 2: Pré-requisitos de disciplinas
-- ============================================================
DELETE sp FROM SubjectPrerequisite sp
WHERE sp.TargetSubjectId   IN (SELECT SubjectId FROM #SubjectsToClean)
   OR sp.RequiredSubjectId IN (SELECT SubjectId FROM #SubjectsToClean);
PRINT 'SubjectPrerequisite removidos: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- ============================================================
-- PASSO 3: Progresso dos alunos
-- ============================================================
DELETE sp FROM StudentProgress sp
WHERE sp.SubjectId IN (SELECT SubjectId FROM #SubjectsToClean);
PRINT 'StudentProgress removidos: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- ============================================================
-- PASSO 4: Matrículas dos alunos
-- ============================================================
DELETE se FROM StudentEnrollment se
WHERE se.ProgramId IN (SELECT ProgramId FROM #ProgramsToClean);
PRINT 'StudentEnrollment removidos: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- ============================================================
-- PASSO 5: Disciplinas
-- ============================================================
DELETE s FROM AcademicSubject s
WHERE s.SubjectId IN (SELECT SubjectId FROM #SubjectsToClean);
PRINT 'AcademicSubject removidos: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- ============================================================
-- PASSO 6: Módulos com TermId válido
-- ============================================================
DELETE cm FROM CourseModule cm
INNER JOIN AcademicTerm at2 ON at2.TermId = cm.TermId
WHERE at2.ProgramId IN (SELECT ProgramId FROM #ProgramsToClean);
PRINT 'CourseModule removidos (com TermId): ' + CAST(@@ROWCOUNT AS VARCHAR);

-- ============================================================
-- PASSO 7: Módulos órfãos (TermId NULL de execuções com erro)
-- ============================================================
DELETE FROM CourseModule
WHERE TermId IS NULL
  AND (   ModuleCode LIKE 'ADM-%'  OR ModuleCode LIKE 'ADS-%'  OR ModuleCode LIKE 'BD-%'
       OR ModuleCode LIKE 'CC-%'   OR ModuleCode LIKE 'CE-%'   OR ModuleCode LIKE 'CEX-%'
       OR ModuleCode LIKE 'CI-%'   OR ModuleCode LIKE 'DGD-%'  OR ModuleCode LIKE 'EI-%'
       OR ModuleCode LIKE 'GC-%'   OR ModuleCode LIKE 'GQ-%'   OR ModuleCode LIKE 'GRH-%'
       OR ModuleCode LIKE 'GF-%'   OR ModuleCode LIKE 'LOG-%'  OR ModuleCode LIKE 'MKT-%'
       OR ModuleCode LIKE 'MDDS-%' OR ModuleCode LIKE 'PG-%'   OR ModuleCode LIKE 'RP-%'
       OR ModuleCode LIKE 'SEP-%'  OR ModuleCode LIKE 'IAML-%' OR ModuleCode LIKE 'OPT'
       OR ModuleCode LIKE '630131%');
PRINT 'CourseModule órfãos removidos: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- ============================================================
-- PASSO 8: Semestres
-- ============================================================
DELETE at2 FROM AcademicTerm at2
WHERE at2.ProgramId IN (SELECT ProgramId FROM #ProgramsToClean);
PRINT 'AcademicTerm removidos: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- ============================================================
-- PASSO 9: Cursos
-- ============================================================
DELETE FROM DegreeProgram
WHERE ProgramId IN (SELECT ProgramId FROM #ProgramsToClean);
PRINT 'DegreeProgram removidos: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- ============================================================
-- PASSO 10: Instituições
-- ============================================================
DELETE FROM EducationalInstitution
WHERE InstitutionId IN (SELECT InstitutionId FROM #InstitutionsToClean);
PRINT 'EducationalInstitution removidos: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- ============================================================
-- Limpeza de tabelas temporárias
-- ============================================================
DROP TABLE #SubjectsToClean;
DROP TABLE #ProgramsToClean;
DROP TABLE #InstitutionsToClean;

-- ============================================================
-- Verificação final
-- ============================================================
SELECT
    CASE WHEN COUNT(*) = 0 THEN 'OK — banco limpo para nova execução do SeedData.sql'
         ELSE 'ATENÇÃO — ainda existem ' + CAST(COUNT(*) AS VARCHAR) + ' registros'
    END AS Status
FROM EducationalInstitution
WHERE InstitutionAcronym IN ('FAM', 'UnirG');
GO
