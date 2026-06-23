-- ============================================================
-- FAM Centro Universitário — Seed de Curso
-- Enfermagem — Bacharelado | 8 Semestres | 4000h
-- ============================================================
-- NOTA: A instituição FAM já deve existir no banco.
-- SubjectCredits: 80h = 4 | 400h (estágio) = 20 | 40h = 2 | 0h = 0
-- Projetos Interdisciplinares: 0h, 0 créditos (atividade integradora)
-- Integração Clínico Assistencial I: 0h (atividade vinculada ao estágio)
-- Eletiva I / Eletiva II: IsOptional = 1
-- ============================================================
USE SyllabusTrackDb;
GO

DECLARE @FamId INT = (SELECT InstitutionId FROM EducationalInstitution WHERE InstitutionAcronym = 'FAM');

-- ============================================================
-- 1. CURSO
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Enfermagem', 'Matriz 2023.1', 8);

DECLARE @ENFId INT = SCOPE_IDENTITY();

-- ============================================================
-- 2. SEMESTRES
-- ============================================================
INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@ENFId, 1, '1º Semestre'),
(@ENFId, 2, '2º Semestre'),
(@ENFId, 3, '3º Semestre'),
(@ENFId, 4, '4º Semestre'),
(@ENFId, 5, '5º Semestre'),
(@ENFId, 6, '6º Semestre'),
(@ENFId, 7, '7º Semestre'),
(@ENFId, 8, '8º Semestre');

DECLARE @ENF_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @ENFId AND TermNumber = 1);
DECLARE @ENF_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @ENFId AND TermNumber = 2);
DECLARE @ENF_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @ENFId AND TermNumber = 3);
DECLARE @ENF_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @ENFId AND TermNumber = 4);
DECLARE @ENF_T5 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @ENFId AND TermNumber = 5);
DECLARE @ENF_T6 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @ENFId AND TermNumber = 6);
DECLARE @ENF_T7 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @ENFId AND TermNumber = 7);
DECLARE @ENF_T8 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @ENFId AND TermNumber = 8);

-- ============================================================
-- 3. MÓDULOS
-- TotalModuleCredits = soma das horas das disciplinas do módulo
-- ============================================================
INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@ENF_T1, 'ENF-1A', 'MÓDULO/CICLO 1A', 400),  -- 5 x 80h
(@ENF_T2, 'ENF-1B', 'MÓDULO/CICLO 1B', 480),  -- 6 x 80h
(@ENF_T3, 'ENF-2A', 'MÓDULO/CICLO 2A', 400),  -- 5 x 80h
(@ENF_T4, 'ENF-2B', 'MÓDULO/CICLO 2B', 400),  -- 5 x 80h
(@ENF_T5, 'ENF-3A', 'MÓDULO/CICLO 3A', 480),  -- 6 x 80h
(@ENF_T6, 'ENF-3B', 'MÓDULO/CICLO 3B', 480),  -- 6 x 80h (incluindo Eletiva I)
(@ENF_T7, 'ENF-4A', 'MÓDULO/CICLO 4A', 560),  -- 80 (Eletiva II) + 0 (Integração I) + 80 (TCC I) + 400 (Estágio I)
(@ENF_T8, 'ENF-4B', 'MÓDULO/CICLO 4B', 560);  -- 80 (Integração II) + 400 (Estágio II) + 80 (TCC II)

DECLARE @ENF_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ENF-1A');
DECLARE @ENF_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ENF-1B');
DECLARE @ENF_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ENF-2A');
DECLARE @ENF_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ENF-2B');
DECLARE @ENF_M5 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ENF-3A');
DECLARE @ENF_M6 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ENF-3B');
DECLARE @ENF_M7 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ENF-4A');
DECLARE @ENF_M8 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ENF-4B');

-- ============================================================
-- 4. DISCIPLINAS
-- ============================================================
INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES

-- 1º SEMESTRE — Módulo/Ciclo 1A
(@ENF_M1, 'ENF-101', 'Comunicação e Linguagem',                                                                        4,  80, 0),
(@ENF_M1, 'ENF-102', 'Biologia Celular e Citogenética',                                                                4,  80, 0),
(@ENF_M1, 'ENF-103', 'Trajetória Histórica e Referenciais Teóricos em Enfermagem',                                     4,  80, 0),
(@ENF_M1, 'ENF-104', 'Morfologia dos Sistemas Musculoesquelético, Neuroendócrino, Genitourinário e Tegumentar',        4,  80, 0),
(@ENF_M1, 'ENF-105', 'Tecnologias para Preservação e Reparação da Integridade da Pele',                                4,  80, 0),
(@ENF_M1, 'ENF-106', 'Projeto Interdisciplinar 1A',                                                                     0,   0, 0),

-- 2º SEMESTRE — Módulo/Ciclo 1B
(@ENF_M2, 'ENF-201', 'Metodologia da Pesquisa Científica e Tecnológica',                                               4,  80, 0),
(@ENF_M2, 'ENF-202', 'Agentes Infecciosos e Resposta Imune',                                                           4,  80, 0),
(@ENF_M2, 'ENF-203', 'Tecnologias e Segurança na Terapia Medicamentosa',                                               4,  80, 0),
(@ENF_M2, 'ENF-204', 'Bioquímica',                                                                                      4,  80, 0),
(@ENF_M2, 'ENF-205', 'Morfologia dos Sistemas Neuromuscular, Cardiológico, Respiratório e Digestório',                 4,  80, 0),
(@ENF_M2, 'ENF-206', 'Processo de Enfermagem com Ênfase na Avaliação Clínica e Diagnóstica do Enfermeiro',             4,  80, 0),
(@ENF_M2, 'ENF-207', 'Projeto Interdisciplinar 1B',                                                                     0,   0, 0),

-- 3º SEMESTRE — Módulo/Ciclo 2A
(@ENF_M3, 'ENF-301', 'Antropologia: Identidade e Diversidade',                                                         4,  80, 0),
(@ENF_M3, 'ENF-302', 'Processo de Cuidado em Saúde do Adulto',                                                         4,  80, 0),
(@ENF_M3, 'ENF-303', 'Práticas Assistenciais em Saúde do Adulto',                                                      4,  80, 0),
(@ENF_M3, 'ENF-304', 'Fisiopatologia dos Sistemas Neuromuscular, Respiratório e Cardiovascular',                       4,  80, 0),
(@ENF_M3, 'ENF-305', 'Farmacologia e Toxicologia',                                                                     4,  80, 0),
(@ENF_M3, 'ENF-306', 'Projeto Interdisciplinar 2A',                                                                     0,   0, 0),

-- 4º SEMESTRE — Módulo/Ciclo 2B
(@ENF_M4, 'ENF-401', 'Meio Ambiente, Sociedade e Cidadania',                                                           4,  80, 0),
(@ENF_M4, 'ENF-402', 'Fisiopatologia dos Sistemas Digestório, Urinário e Endócrino',                                   4,  80, 0),
(@ENF_M4, 'ENF-403', 'Processo de Cuidado em Atenção Primária à Saúde',                                               4,  80, 0),
(@ENF_M4, 'ENF-404', 'Processo de Cuidado em Saúde Neonatal, da Criança e do Adolescente',                            4,  80, 0),
(@ENF_M4, 'ENF-405', 'Processo de Cuidado em Saúde da Mulher',                                                        4,  80, 0),
(@ENF_M4, 'ENF-406', 'Projeto Interdisciplinar 2B',                                                                     0,   0, 0),

-- 5º SEMESTRE — Módulo/Ciclo 3A
(@ENF_M5, 'ENF-501', 'Políticas Públicas de Saúde no Brasil',                                                          4,  80, 0),
(@ENF_M5, 'ENF-502', 'Competências para Gestão da Assistência de Enfermagem',                                          4,  80, 0),
(@ENF_M5, 'ENF-503', 'Processo de Cuidado em Enfermagem em Saúde Mental e Psiquiatria',                                4,  80, 0),
(@ENF_M5, 'ENF-504', 'Processo de Cuidado em Saúde do Idoso e Cuidados Paliativos',                                   4,  80, 0),
(@ENF_M5, 'ENF-505', 'Processo de Cuidado em Saúde Materna',                                                           4,  80, 0),
(@ENF_M5, 'ENF-506', 'Práticas Assistenciais em Saúde Materna',                                                        4,  80, 0),
(@ENF_M5, 'ENF-507', 'Projeto Interdisciplinar 3A',                                                                     0,   0, 0),

-- 6º SEMESTRE — Módulo/Ciclo 3B
(@ENF_M6, 'ENF-601', 'Eletiva I',                                                                                       4,  80, 1),
(@ENF_M6, 'ENF-602', 'Competências para Gestão dos Serviços de Enfermagem',                                            4,  80, 0),
(@ENF_M6, 'ENF-603', 'Processo de Cuidado ao Paciente Cirúrgico',                                                      4,  80, 0),
(@ENF_M6, 'ENF-604', 'Processo de Cuidado ao Paciente Crítico e em Emergências',                                       4,  80, 0),
(@ENF_M6, 'ENF-605', 'Práticas Assistenciais ao Paciente Crítico',                                                     4,  80, 0),
(@ENF_M6, 'ENF-606', 'Gestão dos Serviços e Liderança em Enfermagem',                                                  4,  80, 0),
(@ENF_M6, 'ENF-607', 'Projeto Interdisciplinar 3B',                                                                     0,   0, 0),

-- 7º SEMESTRE — Módulo/Ciclo 4A
(@ENF_M7, 'ENF-701', 'Eletiva II',                                                                                      4,  80, 1),
(@ENF_M7, 'ENF-702', 'Integração Clínico Assistencial I',                                                               0,   0, 0),
(@ENF_M7, 'ENF-703', 'Trabalho de Conclusão de Curso I',                                                               4,  80, 0),
(@ENF_M7, 'ENF-704', 'Estágio Supervisionado I - Enfermagem',                                                          20, 400, 0),

-- 8º SEMESTRE — Módulo/Ciclo 4B
(@ENF_M8, 'ENF-801', 'Integração Clínico Assistencial II',                                                             4,  80, 0),
(@ENF_M8, 'ENF-802', 'Estágio Supervisionado II - Enfermagem',                                                         20, 400, 0),
(@ENF_M8, 'ENF-803', 'Trabalho de Conclusão de Curso II',                                                              4,  80, 0);

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
WHERE p.ProgramName = 'Enfermagem'
GROUP BY i.InstitutionName, p.ProgramName, p.CurriculumVersion;
