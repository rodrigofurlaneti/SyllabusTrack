-- ============================================================
-- Atualiza progresso de rodrigo.madeira — ADS (Análise e Desenvolvimento de Sistemas)
-- Fonte: Histórico Escolar FAM (Grade Curricular)
--
-- Observações de mapeamento:
-- ► O aluno está matriculado em BD e ADS simultaneamente — disciplinas comuns
--   (ex: Algoritmos, Paradigmas, Banco de Dados) aparecem nos dois históricos.
-- ► "Sistemas Distribuídos e SOA" aparece no 4º bloco do ADS → mapeado para
--   ADS-404 (Aplicações p/ Banco de Dados e Data Science), pois o currículo
--   da FAM no sistema pode diferir do PDF (matriz 2023.1 pode ter variação).
-- ► "Programação de Aplicativos para Dispositivos Móveis" → mapeado para
--   ADS-502 (Desenvolvimento Mobile) — disciplinas equivalentes.
-- ► "Mineração de Dados e Big Data" (cursando 5º bloco) pertence ao curso GTI,
--   não entra no mapeamento ADS.
-- ► Projetos Interdisciplinares (PI) permanecem como Pending — não aparecem
--   no histórico porque são atividades integradoras sem CH própria registrada.
--
-- Validação: 19 Concluídas + 2 Reprovadas + 2 Cursando + 1 Pendente = 24 ✓
-- ============================================================
USE SyllabusTrackDb;
GO

DECLARE @StudentId INT = (
    SELECT StudentId FROM StudentAccount
    WHERE LoginUsername = 'rodrigo.madeira' AND IsActive = 1
);

DECLARE @ADS_ProgramId INT = (
    SELECT p.ProgramId
    FROM DegreeProgram p
    JOIN EducationalInstitution i ON i.InstitutionId = p.InstitutionId
    WHERE i.InstitutionAcronym = 'FAM'
      AND p.ProgramName = 'Análise e Desenvolvimento de Sistemas'
);

DECLARE @EnrollmentId INT = (
    SELECT EnrollmentId FROM StudentEnrollment
    WHERE StudentId = @StudentId AND ProgramId = @ADS_ProgramId AND IsActive = 1
);

IF @EnrollmentId IS NULL
BEGIN
    RAISERROR('Matrícula de rodrigo.madeira em ADS não encontrada.', 16, 1);
    RETURN;
END

-- ============================================================
-- Tabela temporária com o mapeamento do histórico
-- ============================================================
CREATE TABLE #ProgressMap (
    SubjectCode      VARCHAR(10),
    CompletionStatus VARCHAR(20),
    SemesterTaken    VARCHAR(10),
    FinalGrade       DECIMAL(5,2)
);

INSERT INTO #ProgressMap VALUES
-- ── 1º SEMESTRE ──────────────────────────────────────────────────────────────
-- ADS-101 Comunicação e Linguagem             → Reprovado  E2024/2 | 0,00
('ADS-101', 'Failed',     'E2024/2', 0.00),
-- ADS-102 Paradigmas de Linguagens            → Aprovado   E2024/1 | 7,50
('ADS-102', 'Completed',  'E2024/1', 7.50),
-- ADS-103 Algoritmos e Lógica de Programação  → Aprovado   E2025/2 | 8,50
('ADS-103', 'Completed',  'E2025/2', 8.50),
-- ADS-104 Fundamentos Matemáticos             → Reprovado  E2025/1 | 0,00
('ADS-104', 'Failed',     'E2025/1', 0.00),
-- ADS-105 Sistemas Computacionais             → Aprovado   E2024/1 | 9,00
('ADS-105', 'Completed',  'E2024/1', 9.00),
-- ADS-106 Projeto Interdisciplinar 1A         → Pending (sem registro no histórico)

-- ── 2º SEMESTRE ──────────────────────────────────────────────────────────────
-- ADS-201 Metodologia da Pesquisa             → Aprovado   E2024/2 | 6,50
('ADS-201', 'Completed',  'E2024/2', 6.50),
-- ADS-202 Sistemas Operacionais               → Aprovado   E2024/2 | 7,00
('ADS-202', 'Completed',  'E2024/2', 7.00),
-- ADS-203 Banco de Dados                      → Dispensado 2017/2  | sem nota
('ADS-203', 'Completed',  '2017/2',  NULL),
-- ADS-204 Estrutura e Modelagem de Dados      → Dispensado 2017/1  | sem nota
('ADS-204', 'Completed',  '2017/1',  NULL),
-- ADS-205 Redes de Computadores               → Aprovado   E2024/2 | 7,50
('ADS-205', 'Completed',  'E2024/2', 7.50),
-- ADS-206 Projeto Interdisciplinar 1B         → Pending

-- ── 3º SEMESTRE ──────────────────────────────────────────────────────────────
-- ADS-301 Antropologia: Id. e Diversidade     → Equiv.+Aprovado E2025/1 | 8,50
('ADS-301', 'Completed',  'E2025/1', 8.50),
-- ADS-302 Engenharia de Software              → Dispensado 2017/2  | sem nota
('ADS-302', 'Completed',  '2017/2',  NULL),
-- ADS-303 Programação Orientada a Objetos     → Aprovado   E2025/1 | 9,00
('ADS-303', 'Completed',  'E2025/1', 9.00),
-- ADS-304 Análise e Projeto de Sistemas       → Aprovado   E2025/1 | 6,50
('ADS-304', 'Completed',  'E2025/1', 6.50),
-- ADS-305 Internet das Coisas (IOT)           → Cursando   E2026/1
('ADS-305', 'InProgress', 'E2026/1', NULL),
-- ADS-306 Projeto Interdisciplinar 2A         → Pending

-- ── 4º SEMESTRE ──────────────────────────────────────────────────────────────
-- ADS-401 Meio Ambiente, Soc. e Cidadania     → Aprovado   E2025/2 | 7,50
('ADS-401', 'Completed',  'E2025/2', 7.50),
-- ADS-402 Eletiva I                           → Dispensado 2017/1  | sem nota
('ADS-402', 'Completed',  '2017/1',  NULL),
-- ADS-403 Gerenciamento e Gestão de Projetos  → Aprovado   E2025/2 | 9,00
--         (FAM registra como "Gerenciamento e Gestão de Projetos de TI")
('ADS-403', 'Completed',  'E2025/2', 9.00),
-- ADS-404 Aplic. p/ Banco de Dados e DS       → Aprovado   E2025/2 | 9,00
--         (FAM registra como "Sistemas Distribuídos e SOA" neste currículo)
('ADS-404', 'Completed',  'E2025/2', 9.00),
-- ADS-405 Qualidade de Software               → Cursando   E2026/1
--         (FAM registra como "Qualidade e Teste de Software")
('ADS-405', 'InProgress', 'E2026/1', NULL),
-- ADS-406 Projeto Interdisciplinar 2B         → Pending

-- ── 5º SEMESTRE ──────────────────────────────────────────────────────────────
-- ADS-501 Eletiva II                          → Pending (não mencionada no histórico)
-- ADS-502 Desenvolvimento Mobile              → Aprovado   E2025/2 | 8,00
--         (FAM registra como "Programação de Aplicativos para Dispositivos Móveis")
('ADS-502', 'Completed',  'E2025/2', 8.00),
-- ADS-503 Programação Back-End                → Aprovado   E2025/2 | 8,50
('ADS-503', 'Completed',  'E2025/2', 8.50),
-- ADS-504 Interfaces Digitais: Front-End      → Aprovado   E2025/1 | 8,00
('ADS-504', 'Completed',  'E2025/1', 8.00);
-- ADS-505 Projeto Interdisciplinar 3A         → Pending

-- ============================================================
-- Aplica os updates em lote
-- ============================================================
UPDATE sp
SET
    sp.CompletionStatus = pm.CompletionStatus,
    sp.SemesterTaken    = pm.SemesterTaken,
    sp.FinalGrade       = pm.FinalGrade
FROM StudentProgress sp
JOIN AcademicSubject  s  ON s.SubjectId   = sp.SubjectId
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

-- Totais (excluindo Projetos Interdisciplinares com CH = 0)
SELECT
    sp.CompletionStatus AS Status,
    COUNT(*)            AS Quantidade
FROM StudentProgress sp
JOIN AcademicSubject s ON s.SubjectId = sp.SubjectId
WHERE sp.EnrollmentId   = @EnrollmentId
  AND sp.IsActive       = 1
  AND s.TotalSubjectHours > 0   -- exclui PIs
GROUP BY sp.CompletionStatus
ORDER BY sp.CompletionStatus;
