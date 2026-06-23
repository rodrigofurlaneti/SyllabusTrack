-- ============================================================
-- FAM Centro Universitário — Seed de Curso
-- Biomedicina — Bacharelado | 8 Semestres | 3241h
-- ============================================================
-- NOTA: A instituição FAM já deve existir no banco.
-- SubjectCredits: 80h = 4 | 325h (estágio) = 16 | 40h (TCC) = 2 | 0h = 0
-- Projetos Interdisciplinares: 0h, 0 créditos (atividade integradora)
-- Eletiva I: IsOptional = 1
-- ============================================================
USE SyllabusTrackDb;
GO

DECLARE @FamId INT = (SELECT InstitutionId FROM EducationalInstitution WHERE InstitutionAcronym = 'FAM');

-- ============================================================
-- 1. CURSO
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Biomedicina', 'Matriz 2023.1', 8);

DECLARE @BIOMId INT = SCOPE_IDENTITY();

-- ============================================================
-- 2. SEMESTRES
-- ============================================================
INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@BIOMId, 1, '1º Semestre'),
(@BIOMId, 2, '2º Semestre'),
(@BIOMId, 3, '3º Semestre'),
(@BIOMId, 4, '4º Semestre'),
(@BIOMId, 5, '5º Semestre'),
(@BIOMId, 6, '6º Semestre'),
(@BIOMId, 7, '7º Semestre'),
(@BIOMId, 8, '8º Semestre');

DECLARE @BIO_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @BIOMId AND TermNumber = 1);
DECLARE @BIO_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @BIOMId AND TermNumber = 2);
DECLARE @BIO_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @BIOMId AND TermNumber = 3);
DECLARE @BIO_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @BIOMId AND TermNumber = 4);
DECLARE @BIO_T5 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @BIOMId AND TermNumber = 5);
DECLARE @BIO_T6 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @BIOMId AND TermNumber = 6);
DECLARE @BIO_T7 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @BIOMId AND TermNumber = 7);
DECLARE @BIO_T8 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @BIOMId AND TermNumber = 8);

-- ============================================================
-- 3. MÓDULOS
-- TotalModuleCredits = soma das horas das disciplinas do módulo
-- ============================================================
INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@BIO_T1, 'BIO-1A', 'MÓDULO/CICLO 1A', 400),  -- 5 x 80h
(@BIO_T2, 'BIO-1B', 'MÓDULO/CICLO 1B', 400),  -- 5 x 80h
(@BIO_T3, 'BIO-2A', 'MÓDULO/CICLO 2A', 400),  -- 5 x 80h
(@BIO_T4, 'BIO-2B', 'MÓDULO/CICLO 2B', 400),  -- 5 x 80h
(@BIO_T5, 'BIO-3A', 'MÓDULO/CICLO 3A', 320),  -- 4 x 80h
(@BIO_T6, 'BIO-3B', 'MÓDULO/CICLO 3B', 320),  -- 4 x 80h (incluindo Eletiva I)
(@BIO_T7, 'BIO-4A', 'MÓDULO/CICLO 4A', 445),  -- 80 (Lab I) + 325 (Estágio I) + 40 (TCC I)
(@BIO_T8, 'BIO-4B', 'MÓDULO/CICLO 4B', 445);  -- 80 (Lab II) + 325 (Estágio II) + 40 (TCC II)

DECLARE @BIO_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'BIO-1A');
DECLARE @BIO_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'BIO-1B');
DECLARE @BIO_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'BIO-2A');
DECLARE @BIO_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'BIO-2B');
DECLARE @BIO_M5 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'BIO-3A');
DECLARE @BIO_M6 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'BIO-3B');
DECLARE @BIO_M7 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'BIO-4A');
DECLARE @BIO_M8 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'BIO-4B');

-- ============================================================
-- 4. DISCIPLINAS
-- ============================================================
INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES

-- 1º SEMESTRE — Módulo/Ciclo 1A
(@BIO_M1, 'BIO-101', 'Comunicação e Linguagem',                                                                        4,  80, 0),
(@BIO_M1, 'BIO-102', 'Biologia Celular e Citogenética',                                                                4,  80, 0),
(@BIO_M1, 'BIO-103', 'Condutas e Procedimentos em Laboratório',                                                        4,  80, 0),
(@BIO_M1, 'BIO-104', 'Morfologia dos Sistemas Musculoesquelético, Neuroendócrino, Geniturinário e Tegumentar',         4,  80, 0),
(@BIO_M1, 'BIO-105', 'Genética e Reprodução Humana',                                                                   4,  80, 0),
(@BIO_M1, 'BIO-106', 'Projeto Interdisciplinar 1A',                                                                     0,   0, 0),

-- 2º SEMESTRE — Módulo/Ciclo 1B
(@BIO_M2, 'BIO-201', 'Metodologia da Pesquisa Científica e Tecnológica',                                               4,  80, 0),
(@BIO_M2, 'BIO-202', 'Agentes Infecciosos e Resposta Imune',                                                           4,  80, 0),
(@BIO_M2, 'BIO-203', 'Bioquímica',                                                                                      4,  80, 0),
(@BIO_M2, 'BIO-204', 'Morfologia dos Sistemas Neuromuscular, Cardiológico, Respiratório e Digestório',                 4,  80, 0),
(@BIO_M2, 'BIO-205', 'Bromatologia e Tecnologia dos Alimentos',                                                        4,  80, 0),
(@BIO_M2, 'BIO-206', 'Projeto Interdisciplinar 1B',                                                                     0,   0, 0),

-- 3º SEMESTRE — Módulo/Ciclo 2A
(@BIO_M3, 'BIO-301', 'Antropologia: Identidade e Diversidade',                                                         4,  80, 0),
(@BIO_M3, 'BIO-302', 'Farmacologia e Toxicologia',                                                                     4,  80, 0),
(@BIO_M3, 'BIO-303', 'Microbiologia Imunologia Clínica',                                                               4,  80, 0),
(@BIO_M3, 'BIO-304', 'Fisiopatologia dos Sistemas Neuromuscular, Respiratório e Cardiovascular',                       4,  80, 0),
(@BIO_M3, 'BIO-305', 'Histotecnologia',                                                                                 4,  80, 0),
(@BIO_M3, 'BIO-306', 'Projeto Interdisciplinar 2A',                                                                     0,   0, 0),

-- 4º SEMESTRE — Módulo/Ciclo 2B
(@BIO_M4, 'BIO-401', 'Meio Ambiente, Sociedade e Cidadania',                                                           4,  80, 0),
(@BIO_M4, 'BIO-402', 'Bioquímica Clínica',                                                                             4,  80, 0),
(@BIO_M4, 'BIO-403', 'Fisiopatologia dos Sistemas Digestório, Urinário e Endócrino',                                   4,  80, 0),
(@BIO_M4, 'BIO-404', 'Hematologia Básica',                                                                             4,  80, 0),
(@BIO_M4, 'BIO-405', 'Parasitologia Geral e Clínica',                                                                  4,  80, 0),
(@BIO_M4, 'BIO-406', 'Projeto Interdisciplinar 2B',                                                                     0,   0, 0),

-- 5º SEMESTRE — Módulo/Ciclo 3A
(@BIO_M5, 'BIO-501', 'Políticas Públicas de Saúde no Brasil',                                                          4,  80, 0),
(@BIO_M5, 'BIO-502', 'Hemostasia e Hemoterapia',                                                                       4,  80, 0),
(@BIO_M5, 'BIO-503', 'Biologia Molecular e Biotecnologia',                                                             4,  80, 0),
(@BIO_M5, 'BIO-504', 'Técnicas e Processamento em Rotinas de Imagem',                                                  4,  80, 0),
(@BIO_M5, 'BIO-505', 'Projeto Interdisciplinar 3A',                                                                     0,   0, 0),

-- 6º SEMESTRE — Módulo/Ciclo 3B
(@BIO_M6, 'BIO-601', 'Eletiva I',                                                                                       4,  80, 1),
(@BIO_M6, 'BIO-602', 'Bioestatística e Pesquisa Clínica',                                                              4,  80, 0),
(@BIO_M6, 'BIO-603', 'Citologia Oncótica',                                                                             4,  80, 0),
(@BIO_M6, 'BIO-604', 'Biomedicina Estética',                                                                           4,  80, 0),
(@BIO_M6, 'BIO-605', 'Projeto Interdisciplinar 3B',                                                                     0,   0, 0),

-- 7º SEMESTRE — Módulo/Ciclo 4A
(@BIO_M7, 'BIO-701', 'Laboratório Clínico I',                                                                          4,  80, 0),
(@BIO_M7, 'BIO-702', 'Estágio Supervisionado I',                                                                       16, 325, 0),
(@BIO_M7, 'BIO-703', 'Trabalho de Conclusão de Curso I',                                                               2,  40, 0),

-- 8º SEMESTRE — Módulo/Ciclo 4B
(@BIO_M8, 'BIO-801', 'Laboratório Clínico II',                                                                         4,  80, 0),
(@BIO_M8, 'BIO-802', 'Estágio Supervisionado II',                                                                      16, 325, 0),
(@BIO_M8, 'BIO-803', 'Trabalho de Conclusão de Curso II',                                                              2,  40, 0);

-- ============================================================
-- 5. VERIFICAÇÃO
-- ============================================================
SELECT
    i.InstitutionName,
    p.ProgramName,
    p.CurriculumVersion,
    COUNT(DISTINCT t.TermId)   AS Semestres,
    COUNT(DISTINCT m.ModuleId) AS Modulos,
    COUNT(s.SubjectId)         AS Disciplinas,
    SUM(s.TotalSubjectHours)   AS CargaHorariaDisciplinas
FROM EducationalInstitution i
JOIN DegreeProgram   p ON p.InstitutionId = i.InstitutionId
JOIN AcademicTerm    t ON t.ProgramId     = p.ProgramId
JOIN CourseModule    m ON m.TermId        = t.TermId
JOIN AcademicSubject s ON s.ModuleId      = m.ModuleId
WHERE p.ProgramName = 'Biomedicina'
GROUP BY i.InstitutionName, p.ProgramName, p.CurriculumVersion;
