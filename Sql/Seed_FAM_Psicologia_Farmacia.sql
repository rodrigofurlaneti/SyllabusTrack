-- ============================================================
-- Seed_FAM_Psicologia_Farmacia.sql
-- FAM Centro Universitário — Psicologia (10 sem) + Farmácia (8 sem)
-- Execute APÓS SeedData.sql (FAM já deve existir)
-- ============================================================
USE SyllabusTrackDb;
GO

-- ============================================================
-- BATCH 1: PSICOLOGIA
-- Bacharelado | Matriz 2023/1 | 10 Semestres | 4036h
-- ============================================================
DECLARE @FamId INT = (SELECT InstitutionId FROM EducationalInstitution WHERE InstitutionAcronym = 'FAM');

IF @FamId IS NULL
BEGIN PRINT 'ERRO: FAM não encontrada. Execute SeedData.sql primeiro.'; RETURN; END

INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Psicologia', 'Matriz 2023/1', 10);
DECLARE @PsiId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@PsiId,  1, '1º Semestre'),
(@PsiId,  2, '2º Semestre'),
(@PsiId,  3, '3º Semestre'),
(@PsiId,  4, '4º Semestre'),
(@PsiId,  5, '5º Semestre'),
(@PsiId,  6, '6º Semestre'),
(@PsiId,  7, '7º Semestre'),
(@PsiId,  8, '8º Semestre'),
(@PsiId,  9, '9º Semestre'),
(@PsiId, 10, '10º Semestre');

DECLARE @PSI_T1  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @PsiId AND TermNumber = 1);
DECLARE @PSI_T2  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @PsiId AND TermNumber = 2);
DECLARE @PSI_T3  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @PsiId AND TermNumber = 3);
DECLARE @PSI_T4  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @PsiId AND TermNumber = 4);
DECLARE @PSI_T5  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @PsiId AND TermNumber = 5);
DECLARE @PSI_T6  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @PsiId AND TermNumber = 6);
DECLARE @PSI_T7  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @PsiId AND TermNumber = 7);
DECLARE @PSI_T8  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @PsiId AND TermNumber = 8);
DECLARE @PSI_T9  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @PsiId AND TermNumber = 9);
DECLARE @PSI_T10 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @PsiId AND TermNumber = 10);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@PSI_T1,  'PSI-1A',  'MÓDULO/CICLO 1A',  400),
(@PSI_T2,  'PSI-1B',  'MÓDULO/CICLO 1B',  400),
(@PSI_T3,  'PSI-2A',  'MÓDULO/CICLO 2A',  400),
(@PSI_T4,  'PSI-2B',  'MÓDULO/CICLO 2B',  400),
(@PSI_T5,  'PSI-3A',  'MÓDULO/CICLO 3A',  400),
(@PSI_T6,  'PSI-3B',  'MÓDULO/CICLO 3B',  320),
(@PSI_T7,  'PSI-4A',  'MÓDULO/CICLO 4A',  380),
(@PSI_T8,  'PSI-4B',  'MÓDULO/CICLO 4B',  390),
(@PSI_T9,  'PSI-5A',  'MÓDULO/CICLO 5A',  390),
(@PSI_T10, 'PSI-5B',  'MÓDULO/CICLO 5B',  400);

DECLARE @PSI_M1  INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'PSI-1A'  AND TermId = @PSI_T1);
DECLARE @PSI_M2  INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'PSI-1B'  AND TermId = @PSI_T2);
DECLARE @PSI_M3  INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'PSI-2A'  AND TermId = @PSI_T3);
DECLARE @PSI_M4  INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'PSI-2B'  AND TermId = @PSI_T4);
DECLARE @PSI_M5  INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'PSI-3A'  AND TermId = @PSI_T5);
DECLARE @PSI_M6  INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'PSI-3B'  AND TermId = @PSI_T6);
DECLARE @PSI_M7  INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'PSI-4A'  AND TermId = @PSI_T7);
DECLARE @PSI_M8  INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'PSI-4B'  AND TermId = @PSI_T8);
DECLARE @PSI_M9  INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'PSI-5A'  AND TermId = @PSI_T9);
DECLARE @PSI_M10 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'PSI-5B'  AND TermId = @PSI_T10);

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- MÓDULO 1A — 1º Semestre
(@PSI_M1,  'PSI-101',  'Comunicação e Linguagem',                                4,  80, 0),
(@PSI_M1,  'PSI-102',  'Políticas Públicas de Saúde no Brasil',                  4,  80, 0),
(@PSI_M1,  'PSI-103',  'Bases Históricas e Filosóficas da Psicologia',           4,  80, 0),
(@PSI_M1,  'PSI-104',  'Processos Psicológicos Básicos',                         4,  80, 0),
(@PSI_M1,  'PSI-105',  'Psicologia como Ciência e Profissão',                    4,  80, 0),
(@PSI_M1,  'PSI-106',  'Projeto Interdisciplinar 1A',                             0,   0, 0),
-- MÓDULO 1B — 2º Semestre
(@PSI_M2,  'PSI-201',  'Metodologia da Pesquisa Científica e Tecnológica',       4,  80, 0),
(@PSI_M2,  'PSI-202',  'Empreendedorismo, Vida e Carreira',                      4,  80, 0),
(@PSI_M2,  'PSI-203',  'Psicologia da Aprendizagem',                              4,  80, 0),
(@PSI_M2,  'PSI-204',  'Psicologia do Desenvolvimento - Infância e Adolescência',4,  80, 0),
(@PSI_M2,  'PSI-205',  'Psicologia Escolar e Educação Inclusiva',                4,  80, 0),
(@PSI_M2,  'PSI-206',  'Projeto Interdisciplinar 1B',                             0,   0, 0),
-- MÓDULO 2A — 3º Semestre
(@PSI_M3,  'PSI-301',  'Antropologia: Identidade e Diversidade',                 4,  80, 0),
(@PSI_M3,  'PSI-302',  'Gestão Estratégica de Pessoas',                          4,  80, 0),
(@PSI_M3,  'PSI-303',  'Psicologia do Desenvolvimento - Vida Adulta e Maturidade',4, 80, 0),
(@PSI_M3,  'PSI-304',  'Subjetividade e Modos de Produção no Trabalho',          4,  80, 0),
(@PSI_M3,  'PSI-305',  'Teorias da Personalidade',                               4,  80, 0),
(@PSI_M3,  'PSI-306',  'Projeto Interdisciplinar 2A',                             0,   0, 0),
-- MÓDULO 2B — 4º Semestre
(@PSI_M4,  'PSI-401',  'Meio Ambiente, Sociedade e Cidadania',                   4,  80, 0),
(@PSI_M4,  'PSI-402',  'Práticas em Análise do Comportamento',                   4,  80, 0),
(@PSI_M4,  'PSI-403',  'Psicologia Comportamental',                              4,  80, 0),
(@PSI_M4,  'PSI-404',  'Psicologia Social',                                      4,  80, 0),
(@PSI_M4,  'PSI-405',  'Estágio Básico: Ações Comunitárias',                     4,  80, 0),
(@PSI_M4,  'PSI-406',  'Projeto Interdisciplinar 2B',                             0,   0, 0),
-- MÓDULO 3A — 5º Semestre
(@PSI_M5,  'PSI-501',  'Epidemiologia e Bioestatística',                         4,  80, 0),
(@PSI_M5,  'PSI-502',  'Eletiva I',                                               4,  80, 1),
(@PSI_M5,  'PSI-503',  'Psicanálise - Metapsicologia Freudiana',                 4,  80, 0),
(@PSI_M5,  'PSI-504',  'Psicopatologia e Saúde Mental do Adulto',                4,  80, 0),
(@PSI_M5,  'PSI-505',  'Estágio Básico - Avaliação Psicológica da Personalidade',4,  80, 0),
(@PSI_M5,  'PSI-506',  'Projeto Interdisciplinar 3A',                             0,   0, 0),
-- MÓDULO 3B — 6º Semestre
(@PSI_M6,  'PSI-601',  'Psicofarmacologia',                                      4,  80, 0),
(@PSI_M6,  'PSI-602',  'Neuroanatofisiologia',                                   4,  80, 0),
(@PSI_M6,  'PSI-603',  'Neuropsicologia',                                        4,  80, 0),
(@PSI_M6,  'PSI-604',  'Estágio Básico - Avaliação Psicológica da Cognição',     4,  80, 0),
(@PSI_M6,  'PSI-605',  'Projeto Interdisciplinar 3B',                             0,   0, 0),
-- MÓDULO 4A — 7º Semestre
(@PSI_M7,  'PSI-701',  'Psicanálise - Tópicos Avançados',                        4,  80, 0),
(@PSI_M7,  'PSI-702',  'Psicologia Existencial Humanista',                        4,  80, 0),
(@PSI_M7,  'PSI-703',  'Psicopatologia e Saúde Mental da Criança e Adolescente', 4,  80, 0),
(@PSI_M7,  'PSI-704',  'Estágio - Práticas Diagnósticas',                        7, 140, 0),
(@PSI_M7,  'PSI-705',  'Projeto Interdisciplinar 4A',                             0,   0, 0),
-- MÓDULO 4B — 8º Semestre
(@PSI_M8,  'PSI-801',  'Clínica Comportamental',                                 4,  80, 0),
(@PSI_M8,  'PSI-802',  'Psicanálise - Pós Freudianos',                           4,  80, 0),
(@PSI_M8,  'PSI-803',  'Psicologia do Casal e Família',                          4,  80, 0),
(@PSI_M8,  'PSI-804',  'Estágio - Práticas em Psicoterapia',                     8, 150, 0),
(@PSI_M8,  'PSI-805',  'Projeto Interdisciplinar 4B',                             0,   0, 0),
-- MÓDULO 5A — 9º Semestre
(@PSI_M9,  'PSI-901',  'Atenção Psicossocial - Álcool e Drogas',                 4,  80, 0),
(@PSI_M9,  'PSI-902',  'Processos Grupais e Institucionais',                     4,  80, 0),
(@PSI_M9,  'PSI-903',  'Psicologia Junguiana e Práticas Integrativas',           4,  80, 0),
(@PSI_M9,  'PSI-904',  'Estágio - Práticas Grupais e Institucionais',            8, 150, 0),
(@PSI_M9,  'PSI-905',  'Projeto Interdisciplinar 5A',                             0,   0, 0),
-- MÓDULO 5B — 10º Semestre
(@PSI_M10, 'PSI-1001', 'Cidadania e Ética Profissional',                         4,  80, 0),
(@PSI_M10, 'PSI-1002', 'Trabalho de Conclusão de Curso',                         4,  80, 0),
(@PSI_M10, 'PSI-1003', 'Psicologia Contemporânea e Exercício Profissional',      4,  80, 0),
(@PSI_M10, 'PSI-1004', 'Estágio Eletivo de Ênfase em Psicologia',               8, 160, 0);

SELECT 'Psicologia' AS Curso, COUNT(*) AS Disciplinas, SUM(TotalSubjectHours) AS CargaHoraria
FROM AcademicSubject s
JOIN CourseModule m ON m.ModuleId = s.ModuleId
JOIN AcademicTerm t ON t.TermId = m.TermId
WHERE t.ProgramId = @PsiId AND s.TotalSubjectHours > 0;

GO

-- ============================================================
-- BATCH 2: FARMÁCIA
-- Bacharelado | Matriz 2023/1 | 8 Semestres | 4000h
-- ============================================================
DECLARE @FamId2 INT = (SELECT InstitutionId FROM EducationalInstitution WHERE InstitutionAcronym = 'FAM');

INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId2, 'Farmácia', 'Matriz 2023/1', 8);
DECLARE @FarId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@FarId, 1, '1º Semestre'),
(@FarId, 2, '2º Semestre'),
(@FarId, 3, '3º Semestre'),
(@FarId, 4, '4º Semestre'),
(@FarId, 5, '5º Semestre'),
(@FarId, 6, '6º Semestre'),
(@FarId, 7, '7º Semestre'),
(@FarId, 8, '8º Semestre');

DECLARE @FAR_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @FarId AND TermNumber = 1);
DECLARE @FAR_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @FarId AND TermNumber = 2);
DECLARE @FAR_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @FarId AND TermNumber = 3);
DECLARE @FAR_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @FarId AND TermNumber = 4);
DECLARE @FAR_T5 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @FarId AND TermNumber = 5);
DECLARE @FAR_T6 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @FarId AND TermNumber = 6);
DECLARE @FAR_T7 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @FarId AND TermNumber = 7);
DECLARE @FAR_T8 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @FarId AND TermNumber = 8);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@FAR_T1, 'FAR-1A', 'MÓDULO/CICLO 1A', 400),
(@FAR_T2, 'FAR-1B', 'MÓDULO/CICLO 1B', 400),
(@FAR_T3, 'FAR-2A', 'MÓDULO/CICLO 2A', 480),
(@FAR_T4, 'FAR-2B', 'MÓDULO/CICLO 2B', 480),
(@FAR_T5, 'FAR-3A', 'MÓDULO/CICLO 3A', 400),
(@FAR_T6, 'FAR-3B', 'MÓDULO/CICLO 3B', 400),
(@FAR_T7, 'FAR-4A', 'MÓDULO/CICLO 4A', 640),
(@FAR_T8, 'FAR-4B', 'MÓDULO/CICLO 4B', 640);

DECLARE @FAR_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'FAR-1A' AND TermId = @FAR_T1);
DECLARE @FAR_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'FAR-1B' AND TermId = @FAR_T2);
DECLARE @FAR_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'FAR-2A' AND TermId = @FAR_T3);
DECLARE @FAR_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'FAR-2B' AND TermId = @FAR_T4);
DECLARE @FAR_M5 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'FAR-3A' AND TermId = @FAR_T5);
DECLARE @FAR_M6 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'FAR-3B' AND TermId = @FAR_T6);
DECLARE @FAR_M7 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'FAR-4A' AND TermId = @FAR_T7);
DECLARE @FAR_M8 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'FAR-4B' AND TermId = @FAR_T8);

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- MÓDULO 1A — 1º Semestre
(@FAR_M1, 'FAR-101', 'Metodologia da Pesquisa Científica e Tecnológica',                           4,  80, 0),
(@FAR_M1, 'FAR-102', 'Biologia Celular e Citogenética',                                            4,  80, 0),
(@FAR_M1, 'FAR-103', 'Morfologia dos Sistemas Musculoesquelético, Neuroendócrino, Geniturinário e Tegumentar', 4, 80, 0),
(@FAR_M1, 'FAR-104', 'Química Geral e Tecnológica',                                                4,  80, 0),
(@FAR_M1, 'FAR-105', 'Química Orgânica',                                                           4,  80, 0),
(@FAR_M1, 'FAR-106', 'Projeto Interdisciplinar 1A',                                                0,   0, 0),
-- MÓDULO 1B — 2º Semestre
(@FAR_M2, 'FAR-201', 'Agentes Infecciosos e Resposta Imune',                                      4,  80, 0),
(@FAR_M2, 'FAR-202', 'Bioquímica',                                                                 4,  80, 0),
(@FAR_M2, 'FAR-203', 'Morfologia dos Sistemas Neuromuscular, Cardiológico, Respiratório e Cardiovascular', 4, 80, 0),
(@FAR_M2, 'FAR-204', 'Química Inorgânica',                                                         4,  80, 0),
(@FAR_M2, 'FAR-205', 'Parasitologia Geral e Clínica',                                             4,  80, 0),
(@FAR_M2, 'FAR-206', 'Projeto Interdisciplinar 1B',                                                0,   0, 0),
-- MÓDULO 2A — 3º Semestre
(@FAR_M3, 'FAR-301', 'Antropologia: Identidade e Diversidade',                                    4,  80, 0),
(@FAR_M3, 'FAR-302', 'Comunicação e Linguagem',                                                   4,  80, 0),
(@FAR_M3, 'FAR-303', 'Fisiopatologia dos Sistemas Neuromuscular, Respiratória e Cardiovascular',  4,  80, 0),
(@FAR_M3, 'FAR-304', 'Farmacologia dos Sistemas Neuromuscular, Respiratória e Cardiovascular',    4,  80, 0),
(@FAR_M3, 'FAR-305', 'Microbiologia e Imunologia Clínica',                                        4,  80, 0),
(@FAR_M3, 'FAR-306', 'Bromatologia e Tecnologia dos Alimentos',                                   4,  80, 0),
(@FAR_M3, 'FAR-307', 'Projeto Interdisciplinar 2A',                                                0,   0, 0),
-- MÓDULO 2B — 4º Semestre
(@FAR_M4, 'FAR-401', 'Meio Ambiente, Sociedade e Cidadania',                                      4,  80, 0),
(@FAR_M4, 'FAR-402', 'Física Geral',                                                              4,  80, 0),
(@FAR_M4, 'FAR-403', 'Fisiopatologia dos Sistemas Digestório, Urinário e Endócrino',              4,  80, 0),
(@FAR_M4, 'FAR-404', 'Farmacologia dos Sistemas Digestório, Urinário e Endócrino',               4,  80, 0),
(@FAR_M4, 'FAR-405', 'Hematologia Básica',                                                        4,  80, 0),
(@FAR_M4, 'FAR-406', 'Bioquímica Clínica',                                                        4,  80, 0),
(@FAR_M4, 'FAR-407', 'Projeto Interdisciplinar 2B',                                                0,   0, 0),
-- MÓDULO 3A — 5º Semestre
(@FAR_M5, 'FAR-501', 'Políticas Públicas de Saúde no Brasil',                                     4,  80, 0),
(@FAR_M5, 'FAR-502', 'Biologia Molecular e Biotecnologia',                                        4,  80, 0),
(@FAR_M5, 'FAR-503', 'Análise Instrumental',                                                      4,  80, 0),
(@FAR_M5, 'FAR-504', 'Química Farmacêutica',                                                      4,  80, 0),
(@FAR_M5, 'FAR-505', 'Química Analítica',                                                         4,  80, 0),
(@FAR_M5, 'FAR-506', 'Projeto Interdisciplinar 3A',                                                0,   0, 0),
-- MÓDULO 3B — 6º Semestre
(@FAR_M6, 'FAR-601', 'Eletiva I',                                                                  4,  80, 1),
(@FAR_M6, 'FAR-602', 'Citologia Oncótica',                                                        4,  80, 0),
(@FAR_M6, 'FAR-603', 'Práticas Integrativas Complementares',                                      4,  80, 0),
(@FAR_M6, 'FAR-604', 'Farmacotécnica',                                                            4,  80, 0),
(@FAR_M6, 'FAR-605', 'Farmacotécnica: Laboratório',                                               4,  80, 0),
(@FAR_M6, 'FAR-606', 'Projeto Interdisciplinar 3B',                                                0,   0, 0),
-- MÓDULO 4A — 7º Semestre
(@FAR_M7, 'FAR-701', 'Deontologia e Legislação Farmacêutica',                                     4,  80, 0),
(@FAR_M7, 'FAR-702', 'Controle de Qualidade de Medicamentos e Cosméticos',                        4,  80, 0),
(@FAR_M7, 'FAR-703', 'Tecnologia Farmacêutica',                                                   4,  80, 0),
(@FAR_M7, 'FAR-704', 'Farmacognosia e Fitoterapia',                                               4,  80, 0),
(@FAR_M7, 'FAR-705', 'Estágio Supervisionado I',                                                  20, 400, 0),
-- MÓDULO 4B — 8º Semestre
(@FAR_M8, 'FAR-801', 'Farmácia Hospitalar e Clínica',                                             4,  80, 0),
(@FAR_M8, 'FAR-802', 'Toxicologia',                                                               4,  80, 0),
(@FAR_M8, 'FAR-803', 'Cosmetologia',                                                              4,  80, 0),
(@FAR_M8, 'FAR-804', 'Estágio Supervisionado II',                                                 20, 400, 0);

SELECT 'Farmácia' AS Curso, COUNT(*) AS Disciplinas, SUM(TotalSubjectHours) AS CargaHoraria
FROM AcademicSubject s
JOIN CourseModule m ON m.ModuleId = s.ModuleId
JOIN AcademicTerm t ON t.TermId = m.TermId
WHERE t.ProgramId = @FarId AND s.TotalSubjectHours > 0;

GO
