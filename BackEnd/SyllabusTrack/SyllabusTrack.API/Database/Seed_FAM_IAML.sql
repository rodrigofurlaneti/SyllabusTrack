-- ============================================================
-- FAM Centro Universitário — Seed de Curso
-- Inteligência Artificial e Machine Learning
-- Superior em Tecnologia | 5 Semestres | 2025h
-- ============================================================
USE SyllabusTrackDb;
GO

-- ============================================================
-- NOTA: A instituição FAM já deve existir no banco.
-- Este script referencia o InstitutionId existente.
-- ============================================================

DECLARE @FamId INT = (SELECT InstitutionId FROM EducationalInstitution WHERE InstitutionAcronym = 'FAM');

-- ============================================================
-- 1. CURSO
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Inteligência Artificial e Machine Learning', 'Matriz 2023.1', 5);

DECLARE @IAMLId INT = SCOPE_IDENTITY();

-- ============================================================
-- 2. SEMESTRES
-- ============================================================
INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@IAMLId, 1, '1º Semestre'),
(@IAMLId, 2, '2º Semestre'),
(@IAMLId, 3, '3º Semestre'),
(@IAMLId, 4, '4º Semestre'),
(@IAMLId, 5, '5º Semestre');

DECLARE @IAML_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @IAMLId AND TermNumber = 1);
DECLARE @IAML_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @IAMLId AND TermNumber = 2);
DECLARE @IAML_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @IAMLId AND TermNumber = 3);
DECLARE @IAML_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @IAMLId AND TermNumber = 4);
DECLARE @IAML_T5 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @IAMLId AND TermNumber = 5);

-- ============================================================
-- 3. MÓDULOS
-- TotalModuleCredits = soma das horas das disciplinas do módulo
-- ============================================================
INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@IAML_T1, 'IAML-1A', 'MÓDULO/CICLO 1A', 374),  -- 80+67+67+80+80
(@IAML_T2, 'IAML-1B', 'MÓDULO/CICLO 1B', 361),  -- 80+80+67+67+67
(@IAML_T3, 'IAML-2A', 'MÓDULO/CICLO 2A', 348),  -- 80+67+67+67+67
(@IAML_T4, 'IAML-2B', 'MÓDULO/CICLO 2B', 374),  -- 80+80+80+67+67
(@IAML_T5, 'IAML-3A', 'MÓDULO/CICLO 3A', 348);  -- 80+67+67+67+67

DECLARE @IAML_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'IAML-1A');
DECLARE @IAML_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'IAML-1B');
DECLARE @IAML_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'IAML-2A');
DECLARE @IAML_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'IAML-2B');
DECLARE @IAML_M5 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'IAML-3A');

-- ============================================================
-- 4. DISCIPLINAS
-- SubjectCredits: 80h = 4 créditos | 67h = 3 créditos
-- Projetos Interdisciplinares: 0h, 0 créditos (atividade integradora)
-- Eletiva I: IsOptional = 1
-- ============================================================
INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES

-- 1º Semestre — Módulo/Ciclo 1A
(@IAML_M1, 'IAML-101', 'Comunicação e Linguagem',                        4,  80, 0),
(@IAML_M1, 'IAML-102', 'Sistemas Computacionais',                         3,  67, 0),
(@IAML_M1, 'IAML-103', 'Fundamentos Matemáticos da Computação',          3,  67, 0),
(@IAML_M1, 'IAML-104', 'Inteligência Artificial e Computacional',        4,  80, 0),
(@IAML_M1, 'IAML-105', 'Algoritmos e Lógica de Programação',             4,  80, 0),
(@IAML_M1, 'IAML-106', 'Projeto Interdisciplinar 1A',                     0,   0, 0),

-- 2º Semestre — Módulo/Ciclo 1B
(@IAML_M2, 'IAML-201', 'Metodologia da Pesquisa Científica e Tecnológica', 4, 80, 0),
(@IAML_M2, 'IAML-202', 'Arquitetura da Informação UX/UI',                  4, 80, 0),
(@IAML_M2, 'IAML-203', 'Estrutura e Modelagem de Dados',                   3, 67, 0),
(@IAML_M2, 'IAML-204', 'Banco de Dados',                                    3, 67, 0),
(@IAML_M2, 'IAML-205', 'Arquitetura NOSQL',                                 3, 67, 0),
(@IAML_M2, 'IAML-206', 'Projeto Interdisciplinar 1B',                       0,  0, 0),

-- 3º Semestre — Módulo/Ciclo 2A
(@IAML_M3, 'IAML-301', 'Antropologia: Identidade e Diversidade',          4, 80, 0),
(@IAML_M3, 'IAML-302', 'Engenharia de Software',                           3, 67, 0),
(@IAML_M3, 'IAML-303', 'Análise e Projeto de Sistemas',                   3, 67, 0),
(@IAML_M3, 'IAML-304', 'Programação Orientada a Objetos',                 3, 67, 0),
(@IAML_M3, 'IAML-305', 'Internet das Coisas (IOT) e Novas Tecnologias',  3, 67, 0),
(@IAML_M3, 'IAML-306', 'Projeto Interdisciplinar 2A',                     0,  0, 0),

-- 4º Semestre — Módulo/Ciclo 2B
(@IAML_M4, 'IAML-401', 'Meio Ambiente, Sociedade e Cidadania',            4, 80, 0),
(@IAML_M4, 'IAML-402', 'Social Media Analytics',                           4, 80, 0),
(@IAML_M4, 'IAML-403', 'Qualidade de Software',                            4, 80, 0),
(@IAML_M4, 'IAML-404', 'Aplicações para Banco de Dados e Data Science',   3, 67, 0),
(@IAML_M4, 'IAML-405', 'Redes Neurais',                                     3, 67, 0),
(@IAML_M4, 'IAML-406', 'Projeto Interdisciplinar 2B',                      0,  0, 0),

-- 5º Semestre — Módulo/Ciclo 3A
(@IAML_M5, 'IAML-501', 'Eletiva I',                                         4, 80, 1),
(@IAML_M5, 'IAML-502', 'Sistemas Embarcados e Visão Computacional',        3, 67, 0),
(@IAML_M5, 'IAML-503', 'Linguagem Natural e IA Generativa',                3, 67, 0),
(@IAML_M5, 'IAML-504', 'Machine Learning',                                  3, 67, 0),
(@IAML_M5, 'IAML-505', 'Redes Neurais Convolucionais e Deep Learning',     3, 67, 0),
(@IAML_M5, 'IAML-506', 'Projeto Interdisciplinar 3A',                      0,  0, 0);

-- ============================================================
-- 5. VERIFICAÇÃO
-- ============================================================
SELECT
    i.InstitutionName,
    p.ProgramName,
    p.CurriculumVersion,
    COUNT(DISTINCT t.TermId)                             AS Semestres,
    COUNT(DISTINCT m.ModuleId)                           AS Modulos,
    COUNT(s.SubjectId)                                   AS Disciplinas,
    SUM(s.TotalSubjectHours)                             AS CargaHorariaDisciplinas
FROM EducationalInstitution i
JOIN DegreeProgram   p ON p.InstitutionId = i.InstitutionId
JOIN AcademicTerm    t ON t.ProgramId     = p.ProgramId
JOIN CourseModule    m ON m.TermId        = t.TermId
JOIN AcademicSubject s ON s.ModuleId      = m.ModuleId
WHERE p.ProgramName = 'Inteligência Artificial e Machine Learning'
GROUP BY i.InstitutionName, p.ProgramName, p.CurriculumVersion;
