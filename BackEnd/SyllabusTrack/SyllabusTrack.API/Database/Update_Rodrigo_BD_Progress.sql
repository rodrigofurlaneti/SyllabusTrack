-- ============================================================
-- Atualiza progresso de rodrigo.madeira — Banco de Dados EAD
-- Fonte: Histórico Escolar FAM (Grade Curricular)
--
-- Status mapeados:
--   Aprovado   → Completed  (com nota)
--   Dispensado → Completed  (equivalência, sem nota)
--   Reprovado  → Failed     (nota 0,00)
--   Cursando   → InProgress (sem nota)
--   Pendente   → Pending    (sem alteração — já está assim)
-- ============================================================
USE SyllabusTrackDb;
GO

DECLARE @StudentId INT = (
    SELECT StudentId FROM StudentAccount
    WHERE LoginUsername = 'rodrigo.madeira' AND IsActive = 1
);

DECLARE @BD_ProgramId INT = (
    SELECT p.ProgramId
    FROM DegreeProgram p
    JOIN EducationalInstitution i ON i.InstitutionId = p.InstitutionId
    WHERE i.InstitutionAcronym = 'FAM'
      AND p.ProgramName = 'Banco de Dados'
);

DECLARE @EnrollmentId INT = (
    SELECT EnrollmentId FROM StudentEnrollment
    WHERE StudentId = @StudentId AND ProgramId = @BD_ProgramId AND IsActive = 1
);

IF @EnrollmentId IS NULL
BEGIN
    RAISERROR('Matrícula de rodrigo.madeira em Banco de Dados não encontrada.', 16, 1);
    RETURN;
END

-- ============================================================
-- Tabela temporária com o mapeamento do histórico
-- ============================================================
CREATE TABLE #ProgressMap (
    SubjectCode     VARCHAR(10),
    CompletionStatus VARCHAR(20),
    SemesterTaken   VARCHAR(10),
    FinalGrade      DECIMAL(5,2)
);

INSERT INTO #ProgressMap VALUES
-- ── 1º SEMESTRE ──────────────────────────────────────────────
-- BD-101 Comunicação e Linguagem          → Reprovado E2024/2
('BD-101', 'Failed',     'E2024/2', 0.00),
-- BD-102 Paradigmas de Ling. Programação  → Aprovado  E2024/1 | 7,50
('BD-102', 'Completed',  'E2024/1', 7.50),
-- BD-103 Algoritmos e Lógica              → Aprovado  E2025/2 | 8,50
('BD-103', 'Completed',  'E2025/2', 8.50),
-- BD-104 Fundamentos Matemáticos          → Reprovado E2025/1
('BD-104', 'Failed',     'E2025/1', 0.00),
-- BD-105 Sistemas Computacionais          → Aprovado  E2024/1 | 9,00
('BD-105', 'Completed',  'E2024/1', 9.00),

-- ── 2º SEMESTRE ──────────────────────────────────────────────
-- BD-201 Metodologia da Pesquisa          → Aprovado  E2024/2 | 6,50
('BD-201', 'Completed',  'E2024/2', 6.50),
-- BD-202 Estrutura e Modelagem de Dados   → Dispensado 2017/1
('BD-202', 'Completed',  '2017/1',  NULL),
-- BD-203 Banco de Dados                   → Dispensado 2017/2
('BD-203', 'Completed',  '2017/2',  NULL),
-- BD-204 Sistemas Operacionais            → Aprovado  E2024/2 | 7,00
('BD-204', 'Completed',  'E2024/2', 7.00),
-- BD-205 Redes de Computadores            → Aprovado  E2024/2 | 7,50
('BD-205', 'Completed',  'E2024/2', 7.50),

-- ── 3º SEMESTRE ──────────────────────────────────────────────
-- BD-301 Antropologia                     → Aprovado  E2025/1 | 8,50
('BD-301', 'Completed',  'E2025/1', 8.50),
-- BD-302 Análise e Projeto de Sistemas    → Aprovado  E2025/1 | 6,50
('BD-302', 'Completed',  'E2025/1', 6.50),
-- BD-303 Engenharia de Software           → Dispensado 2017/2
('BD-303', 'Completed',  '2017/2',  NULL),
-- BD-304 Big Data e Data Science          → Aprovado  E2025/1 | 9,50
('BD-304', 'Completed',  'E2025/1', 9.50),
-- BD-305 Inovação e Novas Tecnologias     → Aprovado  E2025/1 | 9,00
('BD-305', 'Completed',  'E2025/1', 9.00),

-- ── 4º SEMESTRE ──────────────────────────────────────────────
-- BD-401 Meio Ambiente, Soc. e Cidadania  → Aprovado  E2025/2 | 7,50
('BD-401', 'Completed',  'E2025/2', 7.50),
-- BD-402 Sistemas Distribuídos e SOA      → Aprovado  E2025/2 | 9,00
('BD-402', 'Completed',  'E2025/2', 9.00),
-- BD-403 Programação Back-End             → Aprovado  E2025/2 | 8,50
('BD-403', 'Completed',  'E2025/2', 8.50),
-- BD-404 Programação em Banco de Dados    → Aprovado  E2025/2 | 7,50
('BD-404', 'Completed',  'E2025/2', 7.50),
-- BD-405 Administração de Banco de Dados  → Aprovado  E2025/2 | 8,00
('BD-405', 'Completed',  'E2025/2', 8.00),

-- ── 5º SEMESTRE ──────────────────────────────────────────────
-- BD-501 Eletiva I                        → Dispensado 2017/1
('BD-501', 'Completed',  '2017/1',  NULL),
-- BD-502 Mineração de Dados               → Cursando  E2026/1
('BD-502', 'InProgress', 'E2026/1', NULL),
-- BD-503 Otimização e Desempenho de BD    → Cursando  E2026/1
('BD-503', 'InProgress', 'E2026/1', NULL),
-- BD-504 BD em Ambientes de Alta Escalab. → Cursando  E2026/1
('BD-504', 'InProgress', 'E2026/1', NULL);

-- ============================================================
-- Aplica os updates em lote
-- ============================================================
UPDATE sp
SET
    sp.CompletionStatus = pm.CompletionStatus,
    sp.SemesterTaken    = pm.SemesterTaken,
    sp.FinalGrade       = pm.FinalGrade
FROM StudentProgress sp
JOIN AcademicSubject  s  ON s.SubjectId  = sp.SubjectId
JOIN #ProgressMap     pm ON pm.SubjectCode = s.SubjectCode
WHERE sp.EnrollmentId = @EnrollmentId
  AND sp.IsActive     = 1;

DECLARE @Updated INT = @@ROWCOUNT;
PRINT 'Registros atualizados: ' + CAST(@Updated AS VARCHAR);

DROP TABLE #ProgressMap;

-- ============================================================
-- VERIFICAÇÃO — resumo por status
-- ============================================================
SELECT
    s.SubjectCode                       AS Codigo,
    s.SubjectName                       AS Disciplina,
    t.TermNumber                        AS Semestre,
    sp.CompletionStatus                 AS Status,
    sp.SemesterTaken                    AS PeriodoLetivo,
    CAST(sp.FinalGrade AS DECIMAL(4,2)) AS Nota
FROM StudentProgress sp
JOIN AcademicSubject s ON s.SubjectId = sp.SubjectId
JOIN CourseModule    m ON m.ModuleId  = s.ModuleId
JOIN AcademicTerm   t ON t.TermId    = m.TermId
WHERE sp.EnrollmentId = @EnrollmentId
  AND sp.IsActive     = 1
ORDER BY t.TermNumber, s.SubjectCode;

-- Resumo por status
SELECT
    sp.CompletionStatus AS Status,
    COUNT(*)            AS Quantidade
FROM StudentProgress sp
WHERE sp.EnrollmentId = @EnrollmentId AND sp.IsActive = 1
GROUP BY sp.CompletionStatus
ORDER BY sp.CompletionStatus;
