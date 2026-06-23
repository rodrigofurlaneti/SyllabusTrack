-- ============================================================
-- Seed_RodrigoMadeira.sql
-- Insere o histórico acadêmico completo de Rodrigo Madeira
-- nos cursos de ADS e BD (FAM EAD — Matriz 2023/1)
--
-- Mapeamento de situações:
--   Aprovado    → 'Completed'
--   Reprovado   → 'Failed'
--   Dispensado  → 'Completed'  (aproveitamento/equivalência)
--   *Equiv.     → 'Completed'
--   Cursando    → 'InProgress'
--
-- Execute APÓS Cleanup_All.sql + SeedData.sql
-- ============================================================
USE SyllabusTrackDb;
GO

-- ============================================================
-- 0. LOCALIZA O ALUNO
-- ============================================================
DECLARE @StudentId INT = (
    SELECT StudentId
    FROM   StudentAccount
    WHERE  StudentFullName = 'Rodrigo Madeira'
      AND  IsActive = 1
);

IF @StudentId IS NULL
BEGIN
    PRINT 'ERRO: Aluno Rodrigo Madeira não encontrado. Verifique o cadastro.';
    RETURN;
END
PRINT 'Aluno encontrado — StudentId: ' + CAST(@StudentId AS VARCHAR);

-- ============================================================
-- 1. LOCALIZA OS PROGRAMAS FAM
-- ============================================================
DECLARE @FamId   INT = (SELECT InstitutionId FROM EducationalInstitution WHERE InstitutionAcronym = 'FAM');
DECLARE @AdsId   INT = (SELECT ProgramId     FROM DegreeProgram WHERE InstitutionId = @FamId AND ProgramName LIKE '%Análise e Desenvolvimento%');
DECLARE @BdId    INT = (SELECT ProgramId     FROM DegreeProgram WHERE InstitutionId = @FamId AND ProgramName LIKE '%Banco de Dados%' AND CurriculumVersion LIKE '%2023%');

IF @FamId IS NULL OR @AdsId IS NULL OR @BdId IS NULL
BEGIN
    PRINT 'ERRO: FAM=' + ISNULL(CAST(@FamId AS VARCHAR),'NULL')
        + ' ADS=' + ISNULL(CAST(@AdsId AS VARCHAR),'NULL')
        + ' BD='  + ISNULL(CAST(@BdId  AS VARCHAR),'NULL');
    PRINT 'Execute SeedData.sql antes deste script.';
    RETURN;
END
PRINT 'FAM InstitutionId: ' + CAST(@FamId AS VARCHAR);
PRINT 'ADS ProgramId:     ' + CAST(@AdsId AS VARCHAR);
PRINT 'BD  ProgramId:     ' + CAST(@BdId  AS VARCHAR);

-- ============================================================
-- 2. CRIA/LOCALIZA MATRÍCULAS (StudentEnrollment)
-- ============================================================

-- ADS — ingresso 01/01/2025, Transferência Externa
IF NOT EXISTS (SELECT 1 FROM StudentEnrollment WHERE StudentId = @StudentId AND ProgramId = @AdsId AND IsActive = 1)
BEGIN
    INSERT INTO StudentEnrollment (StudentId, ProgramId, EnrollmentDate, EnrollmentStatus)
    VALUES (@StudentId, @AdsId, '2025-01-01', 'Active');
    PRINT 'Matrícula ADS criada.';
END
DECLARE @EnrAds INT = (SELECT EnrollmentId FROM StudentEnrollment WHERE StudentId = @StudentId AND ProgramId = @AdsId AND IsActive = 1);

-- BD — ingresso 01/01/2024, Seleção Simplificada
IF NOT EXISTS (SELECT 1 FROM StudentEnrollment WHERE StudentId = @StudentId AND ProgramId = @BdId AND IsActive = 1)
BEGIN
    INSERT INTO StudentEnrollment (StudentId, ProgramId, EnrollmentDate, EnrollmentStatus)
    VALUES (@StudentId, @BdId, '2024-01-01', 'Active');
    PRINT 'Matrícula BD criada.';
END
DECLARE @EnrBd INT = (SELECT EnrollmentId FROM StudentEnrollment WHERE StudentId = @StudentId AND ProgramId = @BdId AND IsActive = 1);

PRINT 'EnrollmentId ADS: ' + CAST(@EnrAds AS VARCHAR);
PRINT 'EnrollmentId BD:  ' + CAST(@EnrBd  AS VARCHAR);

-- ============================================================
-- 3. HELPER — SubjectIds por código
-- ============================================================
-- ADS
DECLARE @ADS101 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-101');
DECLARE @ADS102 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-102');
DECLARE @ADS103 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-103');
DECLARE @ADS104 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-104');
DECLARE @ADS105 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-105');
DECLARE @ADS201 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-201');
DECLARE @ADS202 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-202');
DECLARE @ADS203 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-203');
DECLARE @ADS204 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-204');
DECLARE @ADS205 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-205');
DECLARE @ADS301 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-301');
DECLARE @ADS302 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-302');
DECLARE @ADS303 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-303');
DECLARE @ADS304 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-304');
DECLARE @ADS305 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-305');
DECLARE @ADS401 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-401');
DECLARE @ADS402 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-402');
DECLARE @ADS403 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-403');
DECLARE @ADS405 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-405');
DECLARE @ADS502 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-502');
DECLARE @ADS503 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-503');
DECLARE @ADS504 INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'ADS-504');

-- BD
DECLARE @BD101  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-101');
DECLARE @BD102  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-102');
DECLARE @BD103  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-103');
DECLARE @BD104  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-104');
DECLARE @BD105  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-105');
DECLARE @BD201  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-201');
DECLARE @BD202  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-202');
DECLARE @BD203  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-203');
DECLARE @BD204  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-204');
DECLARE @BD205  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-205');
DECLARE @BD301  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-301');
DECLARE @BD302  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-302');
DECLARE @BD303  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-303');
DECLARE @BD304  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-304');
DECLARE @BD305  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-305');
DECLARE @BD401  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-401');
DECLARE @BD402  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-402');
DECLARE @BD403  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-403');
DECLARE @BD404  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-404');
DECLARE @BD405  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-405');
DECLARE @BD501  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-501');
DECLARE @BD502  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-502');
DECLARE @BD503  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-503');
DECLARE @BD504  INT = (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = 'BD-504');

-- ============================================================
-- 4. PROGRESSO — CURSO ADS
-- ============================================================
-- Remove entradas antigas para reexecução limpa
DELETE FROM StudentProgress WHERE EnrollmentId = @EnrAds;

INSERT INTO StudentProgress (EnrollmentId, SubjectId, CompletionStatus, SemesterTaken, FinalGrade) VALUES
-- MÓDULO 1A (1º Semestre)
(@EnrAds, @ADS101, 'Failed',      'E2024/2', 0.00),   -- Comunicação e Linguagem          (Reprovado)
(@EnrAds, @ADS102, 'Completed',   'E2024/1', 7.50),   -- Paradigmas de Ling. de Prog.     (Aprovado)
(@EnrAds, @ADS103, 'Completed',   'E2025/2', 8.50),   -- Algoritmos e Lógica de Prog.     (Aprovado)
(@EnrAds, @ADS104, 'Failed',      'E2025/1', 0.00),   -- Fund. Matemáticos da Computação  (Reprovado)
(@EnrAds, @ADS105, 'Completed',   'E2024/1', 9.00),   -- Sistemas Computacionais          (Aprovado)
-- MÓDULO 1B (2º Semestre)
(@EnrAds, @ADS201, 'Completed',   'E2024/2', 6.50),   -- Metodologia da Pesquisa          (Aprovado)
(@EnrAds, @ADS202, 'Completed',   'E2024/2', 7.00),   -- Sistemas Operacionais            (Aprovado)
(@EnrAds, @ADS203, 'Completed',   '2017/2',  NULL),   -- Banco de Dados                   (Dispensado)
(@EnrAds, @ADS204, 'Completed',   '2017/1',  NULL),   -- Estrutura e Modelagem de Dados   (Dispensado)
(@EnrAds, @ADS205, 'Completed',   'E2024/2', 7.50),   -- Redes de Computadores            (Aprovado)
-- MÓDULO 2A (3º Semestre)
(@EnrAds, @ADS301, 'Completed',   'E2025/1', 8.50),   -- Antropologia                     (Aprovado)
(@EnrAds, @ADS302, 'Completed',   '2017/2',  NULL),   -- Engenharia de Software           (Dispensado)
(@EnrAds, @ADS303, 'Completed',   'E2025/1', 9.00),   -- Programação Orientada a Objetos  (Aprovado)
(@EnrAds, @ADS304, 'Completed',   'E2025/1', 6.50),   -- Análise e Projeto de Sistemas    (Aprovado)
(@EnrAds, @ADS305, 'InProgress',  'E2026/1', NULL),   -- Internet das Coisas              (Cursando)
-- MÓDULO 2B (4º Semestre)
(@EnrAds, @ADS401, 'Completed',   'E2025/2', 7.50),   -- Meio Ambiente, Soc. e Cidadania  (Aprovado)
(@EnrAds, @ADS402, 'Completed',   '2017/1',  NULL),   -- Eletiva I                        (Dispensado)
(@EnrAds, @ADS403, 'Completed',   'E2025/2', 9.00),   -- Gerenciamento e Gestão de Proj.  (Aprovado)
(@EnrAds, @ADS405, 'InProgress',  'E2026/1', NULL),   -- Qualidade de Software            (Cursando)
-- MÓDULO 3A (5º Semestre)
(@EnrAds, @ADS502, 'Completed',   'E2025/2', 8.00),   -- Desenvolvimento Mobile           (Aprovado)
(@EnrAds, @ADS503, 'Completed',   'E2025/2', 8.50),   -- Programação Back-End             (Aprovado)
(@EnrAds, @ADS504, 'Completed',   'E2025/1', 8.00);   -- Interfaces Digitais: Front-End   (Aprovado)

PRINT 'StudentProgress ADS inserido: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' linhas';

-- ============================================================
-- 5. PROGRESSO — CURSO BD
-- ============================================================
DELETE FROM StudentProgress WHERE EnrollmentId = @EnrBd;

INSERT INTO StudentProgress (EnrollmentId, SubjectId, CompletionStatus, SemesterTaken, FinalGrade) VALUES
-- MÓDULO 1A (1º Semestre)
(@EnrBd, @BD101, 'Failed',     'E2024/2', 0.00),   -- Comunicação e Linguagem          (Reprovado)
(@EnrBd, @BD102, 'Completed',  'E2024/1', 7.50),   -- Paradigmas de Ling. de Prog.     (Aprovado)
(@EnrBd, @BD103, 'Completed',  'E2025/2', 8.50),   -- Algoritmos e Lógica de Prog.     (Aprovado)
(@EnrBd, @BD104, 'Failed',     'E2025/1', 0.00),   -- Fund. Matemáticos da Computação  (Reprovado)
(@EnrBd, @BD105, 'Completed',  'E2024/1', 9.00),   -- Sistemas Computacionais          (Aprovado)
-- MÓDULO 1B (2º Semestre)
(@EnrBd, @BD201, 'Completed',  'E2024/2', 6.50),   -- Metodologia da Pesquisa          (Aprovado)
(@EnrBd, @BD202, 'Completed',  '2017/1',  NULL),   -- Estrutura e Modelagem de Dados   (Dispensado)
(@EnrBd, @BD203, 'Completed',  '2017/2',  NULL),   -- Banco de Dados                   (Dispensado)
(@EnrBd, @BD204, 'Completed',  'E2024/2', 7.00),   -- Sistemas Operacionais            (Aprovado)
(@EnrBd, @BD205, 'Completed',  'E2024/2', 7.50),   -- Redes de Computadores            (Aprovado)
-- MÓDULO 2A (3º Semestre)
(@EnrBd, @BD301, 'Completed',  'E2025/1', 8.50),   -- Antropologia                     (Aprovado)
(@EnrBd, @BD302, 'Completed',  'E2025/1', 6.50),   -- Análise e Projeto de Sistemas    (Aprovado)
(@EnrBd, @BD303, 'Completed',  '2017/2',  NULL),   -- Engenharia de Software           (Dispensado)
(@EnrBd, @BD304, 'Completed',  'E2025/1', 9.50),   -- Big Data e Data Science          (Aprovado)
(@EnrBd, @BD305, 'Completed',  'E2025/1', 9.00),   -- Inovação e Novas Tecnologias     (Aprovado)
-- MÓDULO 2B (4º Semestre)
(@EnrBd, @BD401, 'Completed',  'E2025/2', 7.50),   -- Meio Ambiente, Soc. e Cidadania  (Aprovado)
(@EnrBd, @BD402, 'Completed',  'E2025/2', 9.00),   -- Sistemas Distribuídos e SOA      (Aprovado)
(@EnrBd, @BD403, 'Completed',  'E2025/2', 8.50),   -- Programação Back-End             (Aprovado)
(@EnrBd, @BD404, 'Completed',  'E2025/2', 7.50),   -- Programação em Banco de Dados    (Aprovado)
(@EnrBd, @BD405, 'Completed',  'E2025/2', 8.00),   -- Administração de Banco de Dados  (Aprovado)
-- MÓDULO 3A (5º Semestre)
(@EnrBd, @BD501, 'Completed',  '2017/1',  NULL),   -- Eletiva I                        (Dispensado)
(@EnrBd, @BD502, 'InProgress', 'E2026/1', NULL),   -- Mineração de Dados               (Cursando)
(@EnrBd, @BD503, 'InProgress', 'E2026/1', NULL),   -- Otimização e Desempenho de BD    (Cursando)
(@EnrBd, @BD504, 'InProgress', 'E2026/1', NULL);   -- BD em Ambientes de Alta Escala.  (Cursando)

PRINT 'StudentProgress BD inserido: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' linhas';

-- ============================================================
-- 6. VERIFICAÇÃO FINAL
-- ============================================================
SELECT
    p.ProgramName,
    sp.CompletionStatus,
    COUNT(*)                                       AS Quantidade,
    ROUND(AVG(CASE WHEN sp.FinalGrade IS NOT NULL THEN sp.FinalGrade END), 2) AS MediaNota
FROM StudentProgress sp
JOIN StudentEnrollment se ON se.EnrollmentId = sp.EnrollmentId
JOIN DegreeProgram     p  ON p.ProgramId     = se.ProgramId
WHERE se.StudentId = @StudentId
GROUP BY p.ProgramName, sp.CompletionStatus
ORDER BY p.ProgramName, sp.CompletionStatus;

-- Resumo por curso
SELECT
    p.ProgramName,
    COUNT(*)                                                                  AS TotalDisciplinas,
    SUM(CASE WHEN sp.CompletionStatus = 'Completed'  THEN 1 ELSE 0 END)      AS Concluidas,
    SUM(CASE WHEN sp.CompletionStatus = 'InProgress' THEN 1 ELSE 0 END)      AS EmCurso,
    SUM(CASE WHEN sp.CompletionStatus = 'Failed'     THEN 1 ELSE 0 END)      AS Reprovadas,
    ROUND(AVG(CASE WHEN sp.FinalGrade IS NOT NULL AND sp.FinalGrade > 0
                   THEN sp.FinalGrade END), 2)                                AS MediaGeral,
    SUM(CASE WHEN sp.CompletionStatus = 'Completed' THEN s.TotalSubjectHours ELSE 0 END) AS CHIntegralizada
FROM StudentProgress sp
JOIN StudentEnrollment  se ON se.EnrollmentId = sp.EnrollmentId
JOIN DegreeProgram       p ON p.ProgramId     = se.ProgramId
JOIN AcademicSubject     s ON s.SubjectId     = sp.SubjectId
WHERE se.StudentId = @StudentId
GROUP BY p.ProgramName
ORDER BY p.ProgramName;
GO
