-- ============================================================
-- FAM Centro Universitário — Seed de Cursos EAD
-- 17 Cursos | Matriz 2023.1
-- ============================================================
USE SyllabusTrackDb;
GO

-- FAM já existe na base; apenas recupera o ID
DECLARE @FamId INT = (SELECT InstitutionId FROM EducationalInstitution WHERE InstitutionAcronym = 'FAM');


-- ============================================================
-- 1. CURSO: Administração - EAD
-- Bacharelado | 8 Semestres | 3250h | 2880h disciplinas online
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Administração', 'Matriz 2023.1 - EAD', 8);

DECLARE @ADMId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@ADMId, 1, '1º Semestre'), (@ADMId, 2, '2º Semestre'), (@ADMId, 3, '3º Semestre'),
(@ADMId, 4, '4º Semestre'), (@ADMId, 5, '5º Semestre'), (@ADMId, 6, '6º Semestre'),
(@ADMId, 7, '7º Semestre'), (@ADMId, 8, '8º Semestre');

DECLARE @ADM_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @ADMId AND TermNumber = 1);
DECLARE @ADM_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @ADMId AND TermNumber = 2);
DECLARE @ADM_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @ADMId AND TermNumber = 3);
DECLARE @ADM_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @ADMId AND TermNumber = 4);
DECLARE @ADM_T5 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @ADMId AND TermNumber = 5);
DECLARE @ADM_T6 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @ADMId AND TermNumber = 6);
DECLARE @ADM_T7 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @ADMId AND TermNumber = 7);
DECLARE @ADM_T8 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @ADMId AND TermNumber = 8);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@ADM_T1, 'ADM-1A', 'MÓDULO/CICLO 1A', 400),
(@ADM_T2, 'ADM-1B', 'MÓDULO/CICLO 1B', 400),
(@ADM_T3, 'ADM-2A', 'MÓDULO/CICLO 2A', 400),
(@ADM_T4, 'ADM-2B', 'MÓDULO/CICLO 2B', 400),
(@ADM_T5, 'ADM-3A', 'MÓDULO/CICLO 3A', 320),
(@ADM_T6, 'ADM-3B', 'MÓDULO/CICLO 3B', 320),
(@ADM_T7, 'ADM-4A', 'MÓDULO/CICLO 4A', 320),
(@ADM_T8, 'ADM-4B', 'MÓDULO/CICLO 4B', 320);

DECLARE @ADM_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ADM-1A' AND TermId = @ADM_T1);
DECLARE @ADM_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ADM-1B' AND TermId = @ADM_T2);
DECLARE @ADM_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ADM-2A' AND TermId = @ADM_T3);
DECLARE @ADM_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ADM-2B' AND TermId = @ADM_T4);
DECLARE @ADM_M5 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ADM-3A' AND TermId = @ADM_T5);
DECLARE @ADM_M6 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ADM-3B' AND TermId = @ADM_T6);
DECLARE @ADM_M7 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ADM-4A' AND TermId = @ADM_T7);
DECLARE @ADM_M8 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ADM-4B' AND TermId = @ADM_T8);

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@ADM_M1, 'ADM-101', 'Comunicação e Linguagem',                        4, 80, 0),
(@ADM_M1, 'ADM-102', 'Administração de Recursos Humanos',              4, 80, 0),
(@ADM_M1, 'ADM-103', 'Administração Mercadológica',                    4, 80, 0),
(@ADM_M1, 'ADM-104', 'Introdução à Economia',                          4, 80, 0),
(@ADM_M1, 'ADM-105', 'Teoria Geral da Administração',                  4, 80, 0),
-- 2º Semestre
(@ADM_M2, 'ADM-201', 'Empreendedorismo, Vida e Carreira',              4, 80, 0),
(@ADM_M2, 'ADM-202', 'Direito Tributário e Empresarial',               4, 80, 0),
(@ADM_M2, 'ADM-203', 'Estatística Aplicada',                           4, 80, 0),
(@ADM_M2, 'ADM-204', 'Matemática Financeira',                          4, 80, 0),
(@ADM_M2, 'ADM-205', 'Princípios Jurídicos nas Organizações',          4, 80, 0),
-- 3º Semestre
(@ADM_M3, 'ADM-301', 'Antropologia: Identidade e Diversidade',         4, 80, 0),
(@ADM_M3, 'ADM-302', 'Contabilidade de Custos',                        4, 80, 0),
(@ADM_M3, 'ADM-303', 'Contabilidade Geral',                            4, 80, 0),
(@ADM_M3, 'ADM-304', 'Administração Moderna e Pós Moderna',            4, 80, 0),
(@ADM_M3, 'ADM-305', 'Princípios da Formação de Preços',               4, 80, 0),
-- 4º Semestre
(@ADM_M4, 'ADM-401', 'Meio Ambiente, Sociedade e Cidadania',           4, 80, 0),
(@ADM_M4, 'ADM-402', 'Eletiva I',                                       4, 80, 1),
(@ADM_M4, 'ADM-403', 'Finanças Corporativa',                           4, 80, 0),
(@ADM_M4, 'ADM-404', 'Gestão de Pequenas e Médias Empresas',           4, 80, 0),
(@ADM_M4, 'ADM-405', 'Sistemas de Informações Gerenciais',             4, 80, 0),
-- 5º Semestre
(@ADM_M5, 'ADM-501', 'Fundamentos de Custeio',                         4, 80, 0),
(@ADM_M5, 'ADM-502', 'Gestão Estratégica de Pessoas',                  4, 80, 0),
(@ADM_M5, 'ADM-503', 'Gestão de Produtos, Serviços e Marcas',          4, 80, 0),
(@ADM_M5, 'ADM-504', 'Administração Financeira Avançada',              4, 80, 0),
-- 6º Semestre
(@ADM_M6, 'ADM-601', 'Inovação e Economia Criativa',                   4, 80, 0),
(@ADM_M6, 'ADM-602', 'Técnica e Prática de Vendas',                    4, 80, 0),
(@ADM_M6, 'ADM-603', 'Planejamento e Gestão Estratégica',              4, 80, 0),
(@ADM_M6, 'ADM-604', 'Gestão da Cadeia de Suprimentos',                4, 80, 0),
-- 7º Semestre
(@ADM_M7, 'ADM-701', 'Comportamento Organizacional',                   4, 80, 0),
(@ADM_M7, 'ADM-702', 'Gestão de Negócios Internacionais',              4, 80, 0),
(@ADM_M7, 'ADM-703', 'Gestão da Produção, Operações e Qualidade',      4, 80, 0),
(@ADM_M7, 'ADM-704', 'Governança Corporativa',                         4, 80, 0),
-- 8º Semestre
(@ADM_M8, 'ADM-801', 'Gestão do Conhecimento e Competências Organizacionais', 4, 80, 0),
(@ADM_M8, 'ADM-802', 'Inteligência de Mercado',                        4, 80, 0),
(@ADM_M8, 'ADM-803', 'Administração de Materiais',                     4, 80, 0),
(@ADM_M8, 'ADM-804', 'Pesquisa e Plano de Marketing',                  4, 80, 0);


-- ============================================================
-- 2. CURSO: Ciências Contábeis - EAD
-- Bacharelado | 8 Semestres | 3250h | 2880h disciplinas online
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Ciências Contábeis', 'Matriz 2023.1 - EAD', 8);

DECLARE @CCId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@CCId, 1, '1º Semestre'), (@CCId, 2, '2º Semestre'), (@CCId, 3, '3º Semestre'),
(@CCId, 4, '4º Semestre'), (@CCId, 5, '5º Semestre'), (@CCId, 6, '6º Semestre'),
(@CCId, 7, '7º Semestre'), (@CCId, 8, '8º Semestre');

DECLARE @CC_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CCId AND TermNumber = 1);
DECLARE @CC_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CCId AND TermNumber = 2);
DECLARE @CC_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CCId AND TermNumber = 3);
DECLARE @CC_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CCId AND TermNumber = 4);
DECLARE @CC_T5 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CCId AND TermNumber = 5);
DECLARE @CC_T6 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CCId AND TermNumber = 6);
DECLARE @CC_T7 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CCId AND TermNumber = 7);
DECLARE @CC_T8 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CCId AND TermNumber = 8);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@CC_T1, 'CC-1A', 'MÓDULO/CICLO 1A', 400),
(@CC_T2, 'CC-1B', 'MÓDULO/CICLO 1B', 400),
(@CC_T3, 'CC-2A', 'MÓDULO/CICLO 2A', 400),
(@CC_T4, 'CC-2B', 'MÓDULO/CICLO 2B', 400),
(@CC_T5, 'CC-3A', 'MÓDULO/CICLO 3A', 320),
(@CC_T6, 'CC-3B', 'MÓDULO/CICLO 3B', 320),
(@CC_T7, 'CC-4A', 'MÓDULO/CICLO 4A', 320),
(@CC_T8, 'CC-4B', 'MÓDULO/CICLO 4B', 320);

DECLARE @CC_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CC-1A' AND TermId = @CC_T1);
DECLARE @CC_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CC-1B' AND TermId = @CC_T2);
DECLARE @CC_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CC-2A' AND TermId = @CC_T3);
DECLARE @CC_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CC-2B' AND TermId = @CC_T4);
DECLARE @CC_M5 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CC-3A' AND TermId = @CC_T5);
DECLARE @CC_M6 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CC-3B' AND TermId = @CC_T6);
DECLARE @CC_M7 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CC-4A' AND TermId = @CC_T7);
DECLARE @CC_M8 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CC-4B' AND TermId = @CC_T8);

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@CC_M1, 'CC-101', 'Comunicação e Linguagem',                          4, 80, 0),
(@CC_M1, 'CC-102', 'Administração de Recursos Humanos',                4, 80, 0),
(@CC_M1, 'CC-103', 'Administração Mercadológica',                      4, 80, 0),
(@CC_M1, 'CC-104', 'Introdução à Economia',                            4, 80, 0),
(@CC_M1, 'CC-105', 'Teoria Geral da Administração',                    4, 80, 0),
-- 2º Semestre
(@CC_M2, 'CC-201', 'Empreendedorismo, Vida e Carreira',                4, 80, 0),
(@CC_M2, 'CC-202', 'Direito Tributário e Empresarial',                 4, 80, 0),
(@CC_M2, 'CC-203', 'Estatística Aplicada',                             4, 80, 0),
(@CC_M2, 'CC-204', 'Matemática Financeira',                            4, 80, 0),
(@CC_M2, 'CC-205', 'Princípios Jurídicos nas Organizações',            4, 80, 0),
-- 3º Semestre
(@CC_M3, 'CC-301', 'Antropologia: Identidade e Diversidade',           4, 80, 0),
(@CC_M3, 'CC-302', 'Contabilidade Básica',                             4, 80, 0),
(@CC_M3, 'CC-303', 'Contabilidade de Custos',                          4, 80, 0),
(@CC_M3, 'CC-304', 'Contabilidade Geral',                              4, 80, 0),
(@CC_M3, 'CC-305', 'Princípios da Formação de Preços',                 4, 80, 0),
-- 4º Semestre
(@CC_M4, 'CC-401', 'Meio Ambiente, Sociedade e Cidadania',             4, 80, 0),
(@CC_M4, 'CC-402', 'Finanças Corporativa',                             4, 80, 0),
(@CC_M4, 'CC-403', 'Gestão de Pequenas e Médias Empresas',             4, 80, 0),
(@CC_M4, 'CC-404', 'Mercado Financeiro e Derivativos',                 4, 80, 0),
(@CC_M4, 'CC-405', 'Sistemas de Informações Gerenciais',               4, 80, 0),
-- 5º Semestre
(@CC_M5, 'CC-501', 'Fundamentos de Custeio',                           4, 80, 0),
(@CC_M5, 'CC-502', 'Contabilidade Financeira',                         4, 80, 0),
(@CC_M5, 'CC-503', 'Contabilidade Tributária',                         4, 80, 0),
(@CC_M5, 'CC-504', 'Administração Financeira Avançada',                4, 80, 0),
-- 6º Semestre
(@CC_M6, 'CC-601', 'Inovação e Economia Criativa',                     4, 80, 0),
(@CC_M6, 'CC-602', 'Contabilidade Societária',                         4, 80, 0),
(@CC_M6, 'CC-603', 'Contabilidade e Planejamento Tributário',          4, 80, 0),
(@CC_M6, 'CC-604', 'Contabilidade Gerencial e Controladoria',          4, 80, 0),
-- 7º Semestre
(@CC_M7, 'CC-701', 'Procedimentos de Auditoria Independente',          4, 80, 0),
(@CC_M7, 'CC-702', 'Governança Corporativa',                           4, 80, 0),
(@CC_M7, 'CC-703', 'Normas Contábeis: IFRS, CPC e NBC',                4, 80, 0),
(@CC_M7, 'CC-704', 'Estrutura e Demonstrações Contábeis',              4, 80, 0),
-- 8º Semestre
(@CC_M8, 'CC-801', 'Eletiva I',                                         4, 80, 1),
(@CC_M8, 'CC-802', 'Perícia Contábil e Atuária',                       4, 80, 0),
(@CC_M8, 'CC-803', 'Contabilidade Avançada',                           4, 80, 0),
(@CC_M8, 'CC-804', 'Contabilidade Pública',                            4, 80, 0);


-- ============================================================
-- 3. CURSO: Ciências Econômicas - EAD
-- Bacharelado | 8 Semestres | 3250h | 2880h disciplinas online | TCC: Sim
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Ciências Econômicas', 'Matriz 2023.1 - EAD', 8);

DECLARE @CEId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@CEId, 1, '1º Semestre'), (@CEId, 2, '2º Semestre'), (@CEId, 3, '3º Semestre'),
(@CEId, 4, '4º Semestre'), (@CEId, 5, '5º Semestre'), (@CEId, 6, '6º Semestre'),
(@CEId, 7, '7º Semestre'), (@CEId, 8, '8º Semestre');

DECLARE @CE_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CEId AND TermNumber = 1);
DECLARE @CE_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CEId AND TermNumber = 2);
DECLARE @CE_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CEId AND TermNumber = 3);
DECLARE @CE_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CEId AND TermNumber = 4);
DECLARE @CE_T5 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CEId AND TermNumber = 5);
DECLARE @CE_T6 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CEId AND TermNumber = 6);
DECLARE @CE_T7 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CEId AND TermNumber = 7);
DECLARE @CE_T8 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CEId AND TermNumber = 8);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@CE_T1, 'CE-1A', 'MÓDULO/CICLO 1A', 400),
(@CE_T2, 'CE-1B', 'MÓDULO/CICLO 1B', 400),
(@CE_T3, 'CE-2A', 'MÓDULO/CICLO 2A', 400),
(@CE_T4, 'CE-2B', 'MÓDULO/CICLO 2B', 400),
(@CE_T5, 'CE-3A', 'MÓDULO/CICLO 3A', 320),
(@CE_T6, 'CE-3B', 'MÓDULO/CICLO 3B', 320),
(@CE_T7, 'CE-4A', 'MÓDULO/CICLO 4A', 320),
(@CE_T8, 'CE-4B', 'MÓDULO/CICLO 4B', 320);

DECLARE @CE_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CE-1A' AND TermId = @CE_T1);
DECLARE @CE_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CE-1B' AND TermId = @CE_T2);
DECLARE @CE_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CE-2A' AND TermId = @CE_T3);
DECLARE @CE_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CE-2B' AND TermId = @CE_T4);
DECLARE @CE_M5 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CE-3A' AND TermId = @CE_T5);
DECLARE @CE_M6 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CE-3B' AND TermId = @CE_T6);
DECLARE @CE_M7 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CE-4A' AND TermId = @CE_T7);
DECLARE @CE_M8 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CE-4B' AND TermId = @CE_T8);

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@CE_M1, 'CE-101', 'Comunicação e Linguagem',                          4, 80, 0),
(@CE_M1, 'CE-102', 'Administração de Recursos Humanos',                4, 80, 0),
(@CE_M1, 'CE-103', 'Administração Mercadológica',                      4, 80, 0),
(@CE_M1, 'CE-104', 'Introdução à Economia',                            4, 80, 0),
(@CE_M1, 'CE-105', 'Teoria Geral da Administração',                    4, 80, 0),
-- 2º Semestre
(@CE_M2, 'CE-201', 'História do Pensamento Econômico',                 4, 80, 0),
(@CE_M2, 'CE-202', 'Direito Tributário e Empresarial',                 4, 80, 0),
(@CE_M2, 'CE-203', 'Estatística Aplicada',                             4, 80, 0),
(@CE_M2, 'CE-204', 'Matemática Financeira',                            4, 80, 0),
(@CE_M2, 'CE-205', 'Princípios Jurídicos nas Organizações',            4, 80, 0),
-- 3º Semestre
(@CE_M3, 'CE-301', 'Antropologia: Identidade e Diversidade',           4, 80, 0),
(@CE_M3, 'CE-302', 'Contabilidade de Custos',                          4, 80, 0),
(@CE_M3, 'CE-303', 'Contabilidade Geral',                              4, 80, 0),
(@CE_M3, 'CE-304', 'História Econômica Geral',                         4, 80, 0),
(@CE_M3, 'CE-305', 'Mercado de Capitais e Sistema Financeiro Nacional',4, 80, 0),
-- 4º Semestre
(@CE_M4, 'CE-401', 'Meio Ambiente, Sociedade e Cidadania',             4, 80, 0),
(@CE_M4, 'CE-402', 'Análise Estatística em Economia',                  4, 80, 0),
(@CE_M4, 'CE-403', 'Econometria',                                       4, 80, 0),
(@CE_M4, 'CE-404', 'Finanças Corporativa',                             4, 80, 0),
(@CE_M4, 'CE-405', 'Sistemas de Informações Gerenciais',               4, 80, 0),
-- 5º Semestre
(@CE_M5, 'CE-501', 'História Econômica do Brasil',                     4, 80, 0),
(@CE_M5, 'CE-502', 'Microeconomia',                                     4, 80, 0),
(@CE_M5, 'CE-503', 'Macroeconomia',                                     4, 80, 0),
(@CE_M5, 'CE-504', 'Contabilidade Social',                             4, 80, 0),
-- 6º Semestre
(@CE_M6, 'CE-601', 'Metodologia da Pesquisa Científica e Tecnológica', 4, 80, 0),
(@CE_M6, 'CE-602', 'Economia Internacional',                           4, 80, 0),
(@CE_M6, 'CE-603', 'Mercado Financeiro e Derivativos',                 4, 80, 0),
(@CE_M6, 'CE-604', 'Economia Monetária',                               4, 80, 0),
-- 7º Semestre
(@CE_M7, 'CE-701', 'Eletiva I',                                         4, 80, 1),
(@CE_M7, 'CE-702', 'Estudos do Crescimento e Desenvolvimento Econômico',4, 80, 0),
(@CE_M7, 'CE-703', 'Estrutura de Capital e Políticas de Crédito',      4, 80, 0),
(@CE_M7, 'CE-704', 'Trabalho de Conclusão do Curso I',                 4, 80, 0),
-- 8º Semestre
(@CE_M8, 'CE-801', 'Economia Brasileira Contemporânea',                4, 80, 0),
(@CE_M8, 'CE-802', 'Economia Política e do Setor Público',             4, 80, 0),
(@CE_M8, 'CE-803', 'Trabalho de Conclusão do Curso II',                4, 80, 0),
(@CE_M8, 'CE-804', 'Ética e Legislação Profissional',                  4, 80, 0);


-- ============================================================
-- 4. CURSO: Comércio Exterior - EAD
-- Superior em Tecnologia | 4 Semestres | 1740h | 1520h disciplinas online
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Comércio Exterior', 'Matriz 2023.1 - EAD', 4);

DECLARE @CEXId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@CEXId, 1, '1º Semestre'), (@CEXId, 2, '2º Semestre'),
(@CEXId, 3, '3º Semestre'), (@CEXId, 4, '4º Semestre');

DECLARE @CEX_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CEXId AND TermNumber = 1);
DECLARE @CEX_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CEXId AND TermNumber = 2);
DECLARE @CEX_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CEXId AND TermNumber = 3);
DECLARE @CEX_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CEXId AND TermNumber = 4);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@CEX_T1, 'CEX-1A', 'MÓDULO/CICLO 1A', 400),
(@CEX_T2, 'CEX-1B', 'MÓDULO/CICLO 1B', 400),
(@CEX_T3, 'CEX-2A', 'MÓDULO/CICLO 2A', 400),
(@CEX_T4, 'CEX-2B', 'MÓDULO/CICLO 2B', 320);

DECLARE @CEX_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CEX-1A' AND TermId = @CEX_T1);
DECLARE @CEX_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CEX-1B' AND TermId = @CEX_T2);
DECLARE @CEX_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CEX-2A' AND TermId = @CEX_T3);
DECLARE @CEX_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CEX-2B' AND TermId = @CEX_T4);

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@CEX_M1, 'CEX-101', 'Comunicação e Linguagem',                        4, 80, 0),
(@CEX_M1, 'CEX-102', 'Administração de Recursos Humanos',              4, 80, 0),
(@CEX_M1, 'CEX-103', 'Administração Mercadológica',                    4, 80, 0),
(@CEX_M1, 'CEX-104', 'Introdução à Economia',                          4, 80, 0),
(@CEX_M1, 'CEX-105', 'Teoria Geral da Administração',                  4, 80, 0),
-- 2º Semestre
(@CEX_M2, 'CEX-201', 'Empreendedorismo, Vida e Carreira',              4, 80, 0),
(@CEX_M2, 'CEX-202', 'Estatística Aplicada',                           4, 80, 0),
(@CEX_M2, 'CEX-203', 'Fundamentos e Operações do Comércio Exterior',   4, 80, 0),
(@CEX_M2, 'CEX-204', 'Matemática Financeira',                          4, 80, 0),
(@CEX_M2, 'CEX-205', 'Gestão da Cadeia de Suprimentos',                4, 80, 0),
-- 3º Semestre
(@CEX_M3, 'CEX-301', 'Antropologia: Identidade e Diversidade',         4, 80, 0),
(@CEX_M3, 'CEX-302', 'Formação de Preço e Custos no Comércio Exterior',4, 80, 0),
(@CEX_M3, 'CEX-303', 'Direito e Comércio Internacional',               4, 80, 0),
(@CEX_M3, 'CEX-304', 'Normas e Processos do Comércio Exterior',        4, 80, 0),
(@CEX_M3, 'CEX-305', 'Administração Moderna e Pós-Moderna',            4, 80, 0),
-- 4º Semestre
(@CEX_M4, 'CEX-401', 'Meio Ambiente, Sociedade e Cidadania',           4, 80, 0),
(@CEX_M4, 'CEX-402', 'Eletiva I',                                       4, 80, 1),
(@CEX_M4, 'CEX-403', 'Sistemas de Informações Gerenciais',             4, 80, 0),
(@CEX_M4, 'CEX-404', 'Planejamento e Gestão Estratégica',              4, 80, 0);


-- ============================================================
-- 5. CURSO: Comunicação Institucional - EAD
-- Superior em Tecnologia | 4 Semestres | 1830h | 1600h disciplinas online
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Comunicação Institucional', 'Matriz 2023.1 - EAD', 4);

DECLARE @CIId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@CIId, 1, '1º Semestre'), (@CIId, 2, '2º Semestre'),
(@CIId, 3, '3º Semestre'), (@CIId, 4, '4º Semestre');

DECLARE @CI_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CIId AND TermNumber = 1);
DECLARE @CI_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CIId AND TermNumber = 2);
DECLARE @CI_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CIId AND TermNumber = 3);
DECLARE @CI_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @CIId AND TermNumber = 4);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@CI_T1, 'CI-1A', 'MÓDULO/CICLO 1A', 400),
(@CI_T2, 'CI-1B', 'MÓDULO/CICLO 1B', 400),
(@CI_T3, 'CI-2A', 'MÓDULO/CICLO 2A', 400),
(@CI_T4, 'CI-2B', 'MÓDULO/CICLO 2B', 400);

DECLARE @CI_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CI-1A' AND TermId = @CI_T1);
DECLARE @CI_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CI-1B' AND TermId = @CI_T2);
DECLARE @CI_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CI-2A' AND TermId = @CI_T3);
DECLARE @CI_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CI-2B' AND TermId = @CI_T4);

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@CI_M1, 'CI-101', 'Comunicação e Linguagem',                          4, 80, 0),
(@CI_M1, 'CI-102', 'Comportamento Organizacional',                     4, 80, 0),
(@CI_M1, 'CI-103', 'Comportamento do Consumidor',                      4, 80, 0),
(@CI_M1, 'CI-104', 'Inovação e Economia Criativa',                     4, 80, 0),
(@CI_M1, 'CI-105', 'Teoria e História da Comunicação',                 4, 80, 0),
-- 2º Semestre
(@CI_M2, 'CI-201', 'Metodologia da Pesquisa Científica e Tecnológica', 4, 80, 0),
(@CI_M2, 'CI-202', 'Gestão da Comunicação Integrada',                  4, 80, 0),
(@CI_M2, 'CI-203', 'Identidade Corporativa',                           4, 80, 0),
(@CI_M2, 'CI-204', 'Introdução à Relações Públicas',                   4, 80, 0),
(@CI_M2, 'CI-205', 'Pesquisa e Plano de Marketing',                    4, 80, 0),
-- 3º Semestre
(@CI_M3, 'CI-301', 'Antropologia: Identidade e Diversidade',           4, 80, 0),
(@CI_M3, 'CI-302', 'Eletiva I',                                         4, 80, 1),
(@CI_M3, 'CI-303', 'Governança Corporativa',                           4, 80, 0),
(@CI_M3, 'CI-304', 'Planejamento em Relações Públicas',                4, 80, 0),
(@CI_M3, 'CI-305', 'Relações Públicas em Mídias Digitais',             4, 80, 0),
-- 4º Semestre
(@CI_M4, 'CI-401', 'Meio Ambiente, Sociedade e Cidadania',             4, 80, 0),
(@CI_M4, 'CI-402', 'Produção em Áudio, Tv e Vídeo',                    4, 80, 0),
(@CI_M4, 'CI-403', 'Cerimonial e Protocolo',                           4, 80, 0),
(@CI_M4, 'CI-404', 'Pesquisa e Diagnóstico em Relações Públicas',      4, 80, 0),
(@CI_M4, 'CI-405', 'Gestão de Eventos',                                4, 80, 0);


-- ============================================================
-- 6. CURSO: Design Gráfico e Digital - EAD
-- Superior em Tecnologia | 4 Semestres | 1740h | 1520h disciplinas online
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Design Gráfico e Digital', 'Matriz 2023.1 - EAD', 4);

DECLARE @DGDId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@DGDId, 1, '1º Semestre'), (@DGDId, 2, '2º Semestre'),
(@DGDId, 3, '3º Semestre'), (@DGDId, 4, '4º Semestre');

DECLARE @DGD_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @DGDId AND TermNumber = 1);
DECLARE @DGD_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @DGDId AND TermNumber = 2);
DECLARE @DGD_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @DGDId AND TermNumber = 3);
DECLARE @DGD_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @DGDId AND TermNumber = 4);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@DGD_T1, 'DGD-1A', 'MÓDULO/CICLO 1A', 400),
(@DGD_T2, 'DGD-1B', 'MÓDULO/CICLO 1B', 400),
(@DGD_T3, 'DGD-2A', 'MÓDULO/CICLO 2A', 400),
(@DGD_T4, 'DGD-2B', 'MÓDULO/CICLO 2B', 320);

DECLARE @DGD_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'DGD-1A' AND TermId = @DGD_T1);
DECLARE @DGD_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'DGD-1B' AND TermId = @DGD_T2);
DECLARE @DGD_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'DGD-2A' AND TermId = @DGD_T3);
DECLARE @DGD_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'DGD-2B' AND TermId = @DGD_T4);

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@DGD_M1, 'DGD-101', 'Comunicação e Linguagem',                        4, 80, 0),
(@DGD_M1, 'DGD-102', 'Teoria e História do Design',                    4, 80, 0),
(@DGD_M1, 'DGD-103', 'Linguagem Visual e Estética',                    4, 80, 0),
(@DGD_M1, 'DGD-104', 'Direção de Arte',                                4, 80, 0),
(@DGD_M1, 'DGD-105', 'História da Arte',                               4, 80, 0),
-- 2º Semestre
(@DGD_M2, 'DGD-201', 'Empreendedorismo, Vida e Carreira',              4, 80, 0),
(@DGD_M2, 'DGD-202', 'Processos Fotográficos',                         4, 80, 0),
(@DGD_M2, 'DGD-203', 'Representação Bidimensional',                    4, 80, 0),
(@DGD_M2, 'DGD-204', 'Desenho de Observação',                          4, 80, 0),
(@DGD_M2, 'DGD-205', 'Tipografia e Lettering',                         4, 80, 0),
-- 3º Semestre
(@DGD_M3, 'DGD-301', 'Antropologia: Identidade e Diversidade',         4, 80, 0),
(@DGD_M3, 'DGD-302', 'Eletiva I',                                       4, 80, 1),
(@DGD_M3, 'DGD-303', 'Ilustração e Infografia',                        4, 80, 0),
(@DGD_M3, 'DGD-304', 'Branding e Identidade Visual',                   4, 80, 0),
(@DGD_M3, 'DGD-305', 'Design Editorial e Produção Gráfica',            4, 80, 0),
-- 4º Semestre
(@DGD_M4, 'DGD-401', 'Meio Ambiente, Sociedade e Cidadania',           4, 80, 0),
(@DGD_M4, 'DGD-402', 'Design UX/UI',                                   4, 80, 0),
(@DGD_M4, 'DGD-403', 'Design de Informação e Sinalização',             4, 80, 0),
(@DGD_M4, 'DGD-404', 'Motion Graphics',                                4, 80, 0);


-- ============================================================
-- 7. CURSO: Empreendedorismo e Inovação - EAD
-- Superior em Tecnologia | 4 Semestres | 1740h | 1520h disciplinas online
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Empreendedorismo e Inovação', 'Matriz 2023.1 - EAD', 4);

DECLARE @EIId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@EIId, 1, '1º Semestre'), (@EIId, 2, '2º Semestre'),
(@EIId, 3, '3º Semestre'), (@EIId, 4, '4º Semestre');

DECLARE @EI_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @EIId AND TermNumber = 1);
DECLARE @EI_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @EIId AND TermNumber = 2);
DECLARE @EI_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @EIId AND TermNumber = 3);
DECLARE @EI_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @EIId AND TermNumber = 4);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@EI_T1, 'EI-1A', 'MÓDULO/CICLO 1A', 400),
(@EI_T2, 'EI-1B', 'MÓDULO/CICLO 1B', 400),
(@EI_T3, 'EI-2A', 'MÓDULO/CICLO 2A', 400),
(@EI_T4, 'EI-2B', 'MÓDULO/CICLO 2B', 320);

DECLARE @EI_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'EI-1A' AND TermId = @EI_T1);
DECLARE @EI_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'EI-1B' AND TermId = @EI_T2);
DECLARE @EI_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'EI-2A' AND TermId = @EI_T3);
DECLARE @EI_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'EI-2B' AND TermId = @EI_T4);

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@EI_M1, 'EI-101', 'Comunicação e Linguagem',                          4, 80, 0),
(@EI_M1, 'EI-102', 'Administração de Recursos Humanos',                4, 80, 0),
(@EI_M1, 'EI-103', 'Administração Mercadológica',                      4, 80, 0),
(@EI_M1, 'EI-104', 'Introdução à Economia',                            4, 80, 0),
(@EI_M1, 'EI-105', 'Teoria Geral da Administração',                    4, 80, 0),
-- 2º Semestre
(@EI_M2, 'EI-201', 'Empreendedorismo, Vida e Carreira',                4, 80, 0),
(@EI_M2, 'EI-202', 'Eletiva I',                                         4, 80, 1),
(@EI_M2, 'EI-203', 'Pesquisa e Plano de Marketing',                    4, 80, 0),
(@EI_M2, 'EI-204', 'Matemática Financeira',                            4, 80, 0),
(@EI_M2, 'EI-205', 'Gestão da Cadeia de Suprimentos',                  4, 80, 0),
-- 3º Semestre
(@EI_M3, 'EI-301', 'Antropologia: Identidade e Diversidade',           4, 80, 0),
(@EI_M3, 'EI-302', 'Inovação e Competitividade Empresarial',           4, 80, 0),
(@EI_M3, 'EI-303', 'Contabilidade Geral',                              4, 80, 0),
(@EI_M3, 'EI-304', 'Inovação e Novas Tecnologias',                     4, 80, 0),
(@EI_M3, 'EI-305', 'Effectuation e Plano de Negócios',                 4, 80, 0),
-- 4º Semestre
(@EI_M4, 'EI-401', 'Meio Ambiente, Sociedade e Cidadania',             4, 80, 0),
(@EI_M4, 'EI-402', 'Estratégia Empresarial',                           4, 80, 0),
(@EI_M4, 'EI-403', 'Marketing Digital, Inteligência Artificial e Novas Mídias', 4, 80, 0),
(@EI_M4, 'EI-404', 'Gestão da Informação e Inteligência de Mercado',   4, 80, 0);


-- ============================================================
-- 8. CURSO: Gestão Comercial - EAD
-- Superior em Tecnologia | 4 Semestres | 1740h | 1520h disciplinas online
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Gestão Comercial', 'Matriz 2023.1 - EAD', 4);

DECLARE @GCId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@GCId, 1, '1º Semestre'), (@GCId, 2, '2º Semestre'),
(@GCId, 3, '3º Semestre'), (@GCId, 4, '4º Semestre');

DECLARE @GC_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GCId AND TermNumber = 1);
DECLARE @GC_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GCId AND TermNumber = 2);
DECLARE @GC_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GCId AND TermNumber = 3);
DECLARE @GC_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GCId AND TermNumber = 4);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@GC_T1, 'GC-1A', 'MÓDULO/CICLO 1A', 400),
(@GC_T2, 'GC-1B', 'MÓDULO/CICLO 1B', 400),
(@GC_T3, 'GC-2A', 'MÓDULO/CICLO 2A', 400),
(@GC_T4, 'GC-2B', 'MÓDULO/CICLO 2B', 320);

DECLARE @GC_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GC-1A' AND TermId = @GC_T1);
DECLARE @GC_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GC-1B' AND TermId = @GC_T2);
DECLARE @GC_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GC-2A' AND TermId = @GC_T3);
DECLARE @GC_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GC-2B' AND TermId = @GC_T4);

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@GC_M1, 'GC-101', 'Comunicação e Linguagem',                          4, 80, 0),
(@GC_M1, 'GC-102', 'Administração de Recursos Humanos',                4, 80, 0),
(@GC_M1, 'GC-103', 'Administração Mercadológica',                      4, 80, 0),
(@GC_M1, 'GC-104', 'Introdução à Economia',                            4, 80, 0),
(@GC_M1, 'GC-105', 'Teoria Geral da Administração',                    4, 80, 0),
-- 2º Semestre
(@GC_M2, 'GC-201', 'Empreendedorismo, Vida e Carreira',                4, 80, 0),
(@GC_M2, 'GC-202', 'Matemática Financeira',                            4, 80, 0),
(@GC_M2, 'GC-203', 'Eletiva I',                                         4, 80, 1),
(@GC_M2, 'GC-204', 'Gestão da Cadeia de Suprimentos',                  4, 80, 0),
(@GC_M2, 'GC-205', 'Princípios Jurídicos nas Organizações',            4, 80, 0),
-- 3º Semestre
(@GC_M3, 'GC-301', 'Antropologia: Identidade e Diversidade',           4, 80, 0),
(@GC_M3, 'GC-302', 'Gestão de Produtos, Serviços e Marcas',            4, 80, 0),
(@GC_M3, 'GC-303', 'Princípios da Formação de Preços',                 4, 80, 0),
(@GC_M3, 'GC-304', 'Gestão de Vendas e Especificidades do Varejo',     4, 80, 0),
(@GC_M3, 'GC-305', 'Administração Moderna e Pós-Moderna',              4, 80, 0),
-- 4º Semestre
(@GC_M4, 'GC-401', 'Meio Ambiente, Sociedade e Cidadania',             4, 80, 0),
(@GC_M4, 'GC-402', 'Técnica e Prática de Vendas',                      4, 80, 0),
(@GC_M4, 'GC-403', 'Sistemas de Informações Gerenciais',               4, 80, 0),
(@GC_M4, 'GC-404', 'Planejamento e Gestão Estratégica',                4, 80, 0);


-- ============================================================
-- 9. CURSO: Gestão da Qualidade - EAD
-- Superior em Tecnologia | 4 Semestres | 1740h | 1520h disciplinas online
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Gestão da Qualidade', 'Matriz 2023.1 - EAD', 4);

DECLARE @GQId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@GQId, 1, '1º Semestre'), (@GQId, 2, '2º Semestre'),
(@GQId, 3, '3º Semestre'), (@GQId, 4, '4º Semestre');

DECLARE @GQ_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GQId AND TermNumber = 1);
DECLARE @GQ_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GQId AND TermNumber = 2);
DECLARE @GQ_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GQId AND TermNumber = 3);
DECLARE @GQ_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GQId AND TermNumber = 4);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@GQ_T1, 'GQ-1A', 'MÓDULO/CICLO 1A', 400),
(@GQ_T2, 'GQ-1B', 'MÓDULO/CICLO 1B', 400),
(@GQ_T3, 'GQ-2A', 'MÓDULO/CICLO 2A', 400),
(@GQ_T4, 'GQ-2B', 'MÓDULO/CICLO 2B', 320);

DECLARE @GQ_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GQ-1A' AND TermId = @GQ_T1);
DECLARE @GQ_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GQ-1B' AND TermId = @GQ_T2);
DECLARE @GQ_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GQ-2A' AND TermId = @GQ_T3);
DECLARE @GQ_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GQ-2B' AND TermId = @GQ_T4);

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@GQ_M1, 'GQ-101', 'Comunicação e Linguagem',                          4, 80, 0),
(@GQ_M1, 'GQ-102', 'Administração de Recursos Humanos',                4, 80, 0),
(@GQ_M1, 'GQ-103', 'Administração Mercadológica',                      4, 80, 0),
(@GQ_M1, 'GQ-104', 'Introdução à Economia',                            4, 80, 0),
(@GQ_M1, 'GQ-105', 'Teoria Geral da Administração',                    4, 80, 0),
-- 2º Semestre
(@GQ_M2, 'GQ-201', 'Empreendedorismo, Vida e Carreira',                4, 80, 0),
(@GQ_M2, 'GQ-202', 'Eletiva I',                                         4, 80, 1),
(@GQ_M2, 'GQ-203', 'Estatística Aplicada',                             4, 80, 0),
(@GQ_M2, 'GQ-204', 'Diagnóstico da Qualidade',                         4, 80, 0),
(@GQ_M2, 'GQ-205', 'Princípios Jurídicos nas Organizações',            4, 80, 0),
-- 3º Semestre
(@GQ_M3, 'GQ-301', 'Antropologia: Identidade e Diversidade',           4, 80, 0),
(@GQ_M3, 'GQ-302', 'Contabilidade Geral',                              4, 80, 0),
(@GQ_M3, 'GQ-303', 'Ferramentas e Controle da Qualidade',              4, 80, 0),
(@GQ_M3, 'GQ-304', 'Gestão da Produção, Operações e Qualidade',        4, 80, 0),
(@GQ_M3, 'GQ-305', 'Gestão Estratégica de Pessoas',                    4, 80, 0),
-- 4º Semestre
(@GQ_M4, 'GQ-401', 'Meio Ambiente, Sociedade e Cidadania',             4, 80, 0),
(@GQ_M4, 'GQ-402', 'Gestão da Qualidade',                              4, 80, 0),
(@GQ_M4, 'GQ-403', 'Normatização e Auditoria da Qualidade',            4, 80, 0),
(@GQ_M4, 'GQ-404', 'Mapeamento e Gerenciamento de Processos',          4, 80, 0);


-- ============================================================
-- 10. CURSO: Gestão de Recursos Humanos - EAD
-- Superior em Tecnologia | 4 Semestres | 1740h | 1520h disciplinas online
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Gestão de Recursos Humanos', 'Matriz 2023.1 - EAD', 4);

DECLARE @GRHId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@GRHId, 1, '1º Semestre'), (@GRHId, 2, '2º Semestre'),
(@GRHId, 3, '3º Semestre'), (@GRHId, 4, '4º Semestre');

DECLARE @GRH_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GRHId AND TermNumber = 1);
DECLARE @GRH_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GRHId AND TermNumber = 2);
DECLARE @GRH_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GRHId AND TermNumber = 3);
DECLARE @GRH_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GRHId AND TermNumber = 4);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@GRH_T1, 'GRH-1A', 'MÓDULO/CICLO 1A', 400),
(@GRH_T2, 'GRH-1B', 'MÓDULO/CICLO 1B', 400),
(@GRH_T3, 'GRH-2A', 'MÓDULO/CICLO 2A', 400),
(@GRH_T4, 'GRH-2B', 'MÓDULO/CICLO 2B', 320);

DECLARE @GRH_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GRH-1A' AND TermId = @GRH_T1);
DECLARE @GRH_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GRH-1B' AND TermId = @GRH_T2);
DECLARE @GRH_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GRH-2A' AND TermId = @GRH_T3);
DECLARE @GRH_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GRH-2B' AND TermId = @GRH_T4);

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@GRH_M1, 'GRH-101', 'Comunicação e Linguagem',                        4, 80, 0),
(@GRH_M1, 'GRH-102', 'Administração de Recursos Humanos',              4, 80, 0),
(@GRH_M1, 'GRH-103', 'Administração Mercadológica',                    4, 80, 0),
(@GRH_M1, 'GRH-104', 'Introdução à Economia',                          4, 80, 0),
(@GRH_M1, 'GRH-105', 'Teoria Geral da Administração',                  4, 80, 0),
-- 2º Semestre
(@GRH_M2, 'GRH-201', 'Empreendedorismo, Vida e Carreira',              4, 80, 0),
(@GRH_M2, 'GRH-202', 'Eletiva I',                                       4, 80, 1),
(@GRH_M2, 'GRH-203', 'Estatística Aplicada',                           4, 80, 0),
(@GRH_M2, 'GRH-204', 'Matemática Financeira',                          4, 80, 0),
(@GRH_M2, 'GRH-205', 'Princípios Jurídicos nas Organizações',          4, 80, 0),
-- 3º Semestre
(@GRH_M3, 'GRH-301', 'Antropologia: Identidade e Diversidade',         4, 80, 0),
(@GRH_M3, 'GRH-302', 'Comportamento Organizacional',                   4, 80, 0),
(@GRH_M3, 'GRH-303', 'Captação e Desenvolvimento de Pessoas',          4, 80, 0),
(@GRH_M3, 'GRH-304', 'Gestão Estratégica de Pessoas',                  4, 80, 0),
(@GRH_M3, 'GRH-305', 'Contabilidade Geral',                            4, 80, 0),
-- 4º Semestre
(@GRH_M4, 'GRH-401', 'Meio Ambiente, Sociedade e Cidadania',           4, 80, 0),
(@GRH_M4, 'GRH-402', 'Avaliação de Desempenho e Planejamento de Carreira', 4, 80, 0),
(@GRH_M4, 'GRH-403', 'Sistemas de Recompensa e Benefício',             4, 80, 0),
(@GRH_M4, 'GRH-404', 'Sistemas de Informações Gerenciais',             4, 80, 0);


-- ============================================================
-- 11. CURSO: Gestão Financeira - EAD
-- Superior em Tecnologia | 4 Semestres | 1740h | 1520h disciplinas online
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Gestão Financeira', 'Matriz 2023.1 - EAD', 4);

DECLARE @GFId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@GFId, 1, '1º Semestre'), (@GFId, 2, '2º Semestre'),
(@GFId, 3, '3º Semestre'), (@GFId, 4, '4º Semestre');

DECLARE @GF_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GFId AND TermNumber = 1);
DECLARE @GF_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GFId AND TermNumber = 2);
DECLARE @GF_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GFId AND TermNumber = 3);
DECLARE @GF_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GFId AND TermNumber = 4);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@GF_T1, 'GF-1A', 'MÓDULO/CICLO 1A', 400),
(@GF_T2, 'GF-1B', 'MÓDULO/CICLO 1B', 400),
(@GF_T3, 'GF-2A', 'MÓDULO/CICLO 2A', 400),
(@GF_T4, 'GF-2B', 'MÓDULO/CICLO 2B', 320);

DECLARE @GF_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GF-1A' AND TermId = @GF_T1);
DECLARE @GF_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GF-1B' AND TermId = @GF_T2);
DECLARE @GF_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GF-2A' AND TermId = @GF_T3);
DECLARE @GF_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GF-2B' AND TermId = @GF_T4);

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@GF_M1, 'GF-101', 'Comunicação e Linguagem',                          4, 80, 0),
(@GF_M1, 'GF-102', 'Administração de Recursos Humanos',                4, 80, 0),
(@GF_M1, 'GF-103', 'Administração Mercadológica',                      4, 80, 0),
(@GF_M1, 'GF-104', 'Introdução à Economia',                            4, 80, 0),
(@GF_M1, 'GF-105', 'Teoria Geral da Administração',                    4, 80, 0),
-- 2º Semestre
(@GF_M2, 'GF-201', 'Empreendedorismo, Vida e Carreira',                4, 80, 0),
(@GF_M2, 'GF-202', 'Eletiva I',                                         4, 80, 1),
(@GF_M2, 'GF-203', 'Matemática Financeira',                            4, 80, 0),
(@GF_M2, 'GF-204', 'Estatística Aplicada',                             4, 80, 0),
(@GF_M2, 'GF-205', 'Princípios Jurídicos nas Organizações',            4, 80, 0),
-- 3º Semestre
(@GF_M3, 'GF-301', 'Antropologia: Identidade e Diversidade',           4, 80, 0),
(@GF_M3, 'GF-302', 'Contabilidade Geral',                              4, 80, 0),
(@GF_M3, 'GF-303', 'Princípios da Formação de Preços',                 4, 80, 0),
(@GF_M3, 'GF-304', 'Fundamentos de Custeio',                           4, 80, 0),
(@GF_M3, 'GF-305', 'Administração Financeira Avançada',                4, 80, 0),
-- 4º Semestre
(@GF_M4, 'GF-401', 'Meio Ambiente, Sociedade e Cidadania',             4, 80, 0),
(@GF_M4, 'GF-402', 'Finanças Corporativa',                             4, 80, 0),
(@GF_M4, 'GF-403', 'Mercado Financeiro e Derivativos',                 4, 80, 0),
(@GF_M4, 'GF-404', 'Sistemas de Informações Gerenciais',               4, 80, 0);


-- ============================================================
-- 12. CURSO: Logística - EAD
-- Superior em Tecnologia | 4 Semestres | 1740h | 1520h disciplinas online
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Logística', 'Matriz 2023.1 - EAD', 4);

DECLARE @LOGId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@LOGId, 1, '1º Semestre'), (@LOGId, 2, '2º Semestre'),
(@LOGId, 3, '3º Semestre'), (@LOGId, 4, '4º Semestre');

DECLARE @LOG_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @LOGId AND TermNumber = 1);
DECLARE @LOG_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @LOGId AND TermNumber = 2);
DECLARE @LOG_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @LOGId AND TermNumber = 3);
DECLARE @LOG_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @LOGId AND TermNumber = 4);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@LOG_T1, 'LOG-1A', 'MÓDULO/CICLO 1A', 400),
(@LOG_T2, 'LOG-1B', 'MÓDULO/CICLO 1B', 400),
(@LOG_T3, 'LOG-2A', 'MÓDULO/CICLO 2A', 400),
(@LOG_T4, 'LOG-2B', 'MÓDULO/CICLO 2B', 320);

DECLARE @LOG_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'LOG-1A' AND TermId = @LOG_T1);
DECLARE @LOG_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'LOG-1B' AND TermId = @LOG_T2);
DECLARE @LOG_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'LOG-2A' AND TermId = @LOG_T3);
DECLARE @LOG_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'LOG-2B' AND TermId = @LOG_T4);

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@LOG_M1, 'LOG-101', 'Comunicação e Linguagem',                        4, 80, 0),
(@LOG_M1, 'LOG-102', 'Administração de Recursos Humanos',              4, 80, 0),
(@LOG_M1, 'LOG-103', 'Administração Mercadológica',                    4, 80, 0),
(@LOG_M1, 'LOG-104', 'Introdução à Economia',                          4, 80, 0),
(@LOG_M1, 'LOG-105', 'Teoria Geral da Administração',                  4, 80, 0),
-- 2º Semestre
(@LOG_M2, 'LOG-201', 'Empreendedorismo, Vida e Carreira',              4, 80, 0),
(@LOG_M2, 'LOG-202', 'Matemática Financeira',                          4, 80, 0),
(@LOG_M2, 'LOG-203', 'Estatística Aplicada',                           4, 80, 0),
(@LOG_M2, 'LOG-204', 'Gestão da Cadeia de Suprimentos',                4, 80, 0),
(@LOG_M2, 'LOG-205', 'Princípios Jurídicos nas Organizações',          4, 80, 0),
-- 3º Semestre
(@LOG_M3, 'LOG-301', 'Antropologia: Identidade e Diversidade',         4, 80, 0),
(@LOG_M3, 'LOG-302', 'Fundamentos e Processos Logísticos',             4, 80, 0),
(@LOG_M3, 'LOG-303', 'Gestão de Custos Logísticos',                    4, 80, 0),
(@LOG_M3, 'LOG-304', 'Gestão da Produção, Operações e Qualidade',      4, 80, 0),
(@LOG_M3, 'LOG-305', 'Transporte e Distribuição',                      4, 80, 0),
-- 4º Semestre
(@LOG_M4, 'LOG-401', 'Meio Ambiente, Sociedade e Cidadania',           4, 80, 0),
(@LOG_M4, 'LOG-402', 'Eletiva I',                                       4, 80, 1),
(@LOG_M4, 'LOG-403', 'Logística Internacional',                        4, 80, 0),
(@LOG_M4, 'LOG-404', 'Mapeamento e Gerenciamento de Processos',        4, 80, 0);


-- ============================================================
-- 13. CURSO: Marketing - EAD
-- Superior em Tecnologia | 4 Semestres | 1740h | 1520h disciplinas online
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Marketing', 'Matriz 2023.1 - EAD', 4);

DECLARE @MKTId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@MKTId, 1, '1º Semestre'), (@MKTId, 2, '2º Semestre'),
(@MKTId, 3, '3º Semestre'), (@MKTId, 4, '4º Semestre');

DECLARE @MKT_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MKTId AND TermNumber = 1);
DECLARE @MKT_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MKTId AND TermNumber = 2);
DECLARE @MKT_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MKTId AND TermNumber = 3);
DECLARE @MKT_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MKTId AND TermNumber = 4);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@MKT_T1, 'MKT-1A', 'MÓDULO/CICLO 1A', 400),
(@MKT_T2, 'MKT-1B', 'MÓDULO/CICLO 1B', 400),
(@MKT_T3, 'MKT-2A', 'MÓDULO/CICLO 2A', 400),
(@MKT_T4, 'MKT-2B', 'MÓDULO/CICLO 2B', 320);

DECLARE @MKT_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MKT-1A' AND TermId = @MKT_T1);
DECLARE @MKT_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MKT-1B' AND TermId = @MKT_T2);
DECLARE @MKT_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MKT-2A' AND TermId = @MKT_T3);
DECLARE @MKT_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MKT-2B' AND TermId = @MKT_T4);

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@MKT_M1, 'MKT-101', 'Comunicação e Linguagem',                        4, 80, 0),
(@MKT_M1, 'MKT-102', 'Administração de Recursos Humanos',              4, 80, 0),
(@MKT_M1, 'MKT-103', 'Administração Mercadológica',                    4, 80, 0),
(@MKT_M1, 'MKT-104', 'Introdução à Economia',                          4, 80, 0),
(@MKT_M1, 'MKT-105', 'Teoria Geral da Administração',                  4, 80, 0),
-- 2º Semestre
(@MKT_M2, 'MKT-201', 'Empreendedorismo, Vida e Carreira',              4, 80, 0),
(@MKT_M2, 'MKT-202', 'Matemática Financeira',                          4, 80, 0),
(@MKT_M2, 'MKT-203', 'Estatística Aplicada',                           4, 80, 0),
(@MKT_M2, 'MKT-204', 'Ferramentas de Comunicação e Marketing',         4, 80, 0),
(@MKT_M2, 'MKT-205', 'Princípios Jurídicos nas Organizações',          4, 80, 0),
-- 3º Semestre
(@MKT_M3, 'MKT-301', 'Antropologia: Identidade e Diversidade',         4, 80, 0),
(@MKT_M3, 'MKT-302', 'Eletiva I',                                       4, 80, 1),
(@MKT_M3, 'MKT-303', 'Administração Moderna e Pós-Moderna',            4, 80, 0),
(@MKT_M3, 'MKT-304', 'Gestão de Produtos, Serviços e Marcas',          4, 80, 0),
(@MKT_M3, 'MKT-305', 'Relações de Consumo',                            4, 80, 0),
-- 4º Semestre
(@MKT_M4, 'MKT-401', 'Meio Ambiente, Sociedade e Cidadania',           4, 80, 0),
(@MKT_M4, 'MKT-402', 'Marketing Digital, Inteligência Artificial e Novas Mídias', 4, 80, 0),
(@MKT_M4, 'MKT-403', 'Pesquisa e Plano de Marketing',                  4, 80, 0),
(@MKT_M4, 'MKT-404', 'Sistemas de Informações Gerenciais',             4, 80, 0);


-- ============================================================
-- 14. CURSO: Marketing Digital e Data Science - EAD
-- Superior em Tecnologia | 5 Semestres | 2200h | 1920h disciplinas online
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Marketing Digital e Data Science', 'Matriz 2023.1 - EAD', 5);

DECLARE @MDDSId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@MDDSId, 1, '1º Semestre'), (@MDDSId, 2, '2º Semestre'), (@MDDSId, 3, '3º Semestre'),
(@MDDSId, 4, '4º Semestre'), (@MDDSId, 5, '5º Semestre');

DECLARE @MDDS_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MDDSId AND TermNumber = 1);
DECLARE @MDDS_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MDDSId AND TermNumber = 2);
DECLARE @MDDS_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MDDSId AND TermNumber = 3);
DECLARE @MDDS_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MDDSId AND TermNumber = 4);
DECLARE @MDDS_T5 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MDDSId AND TermNumber = 5);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@MDDS_T1, 'MDDS-1A', 'MÓDULO/CICLO 1A', 400),
(@MDDS_T2, 'MDDS-1B', 'MÓDULO/CICLO 1B', 400),
(@MDDS_T3, 'MDDS-2A', 'MÓDULO/CICLO 2A', 400),
(@MDDS_T4, 'MDDS-2B', 'MÓDULO/CICLO 2B', 400),
(@MDDS_T5, 'MDDS-3A', 'MÓDULO/CICLO 3A', 320);

DECLARE @MDDS_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MDDS-1A' AND TermId = @MDDS_T1);
DECLARE @MDDS_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MDDS-1B' AND TermId = @MDDS_T2);
DECLARE @MDDS_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MDDS-2A' AND TermId = @MDDS_T3);
DECLARE @MDDS_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MDDS-2B' AND TermId = @MDDS_T4);
DECLARE @MDDS_M5 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MDDS-3A' AND TermId = @MDDS_T5);

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@MDDS_M1, 'MDDS-101', 'Comunicação e Linguagem',                      4, 80, 0),
(@MDDS_M1, 'MDDS-102', 'Inovação e Economia Criativa',                 4, 80, 0),
(@MDDS_M1, 'MDDS-103', 'Comportamento Organizacional',                 4, 80, 0),
(@MDDS_M1, 'MDDS-104', 'Fundamentos Matemáticos da Computação',        4, 80, 0),
(@MDDS_M1, 'MDDS-105', 'Sistemas Computacionais',                      4, 80, 0),
-- 2º Semestre
(@MDDS_M2, 'MDDS-201', 'Metodologia da Pesquisa Científica e Tecnológica', 4, 80, 0),
(@MDDS_M2, 'MDDS-202', 'Estrutura e Modelagem de Dados',               4, 80, 0),
(@MDDS_M2, 'MDDS-203', 'Ferramentas de Comunicação e Marketing',       4, 80, 0),
(@MDDS_M2, 'MDDS-204', 'Pesquisa e Plano de Marketing',                4, 80, 0),
(@MDDS_M2, 'MDDS-205', 'Banco de Dados',                               4, 80, 0),
-- 3º Semestre
(@MDDS_M3, 'MDDS-301', 'Antropologia: Identidade e Diversidade',       4, 80, 0),
(@MDDS_M3, 'MDDS-302', 'Interfaces Digitais: Front-End',               4, 80, 0),
(@MDDS_M3, 'MDDS-303', 'Marketing de Conteúdo e Storytelling',         4, 80, 0),
(@MDDS_M3, 'MDDS-304', 'Ética, Hacking e Ransomware',                  4, 80, 0),
(@MDDS_M3, 'MDDS-305', 'Big Data e Data Science',                      4, 80, 0),
-- 4º Semestre
(@MDDS_M4, 'MDDS-401', 'Meio Ambiente, Sociedade e Cidadania',         4, 80, 0),
(@MDDS_M4, 'MDDS-402', 'Probabilidade e Estatística',                  4, 80, 0),
(@MDDS_M4, 'MDDS-403', 'Programação Back-End',                         4, 80, 0),
(@MDDS_M4, 'MDDS-404', 'Arquitetura da Informação UX/UI',              4, 80, 0),
(@MDDS_M4, 'MDDS-405', 'Marketing Digital, Inteligência Artificial e Novas Mídias', 4, 80, 0),
-- 5º Semestre
(@MDDS_M5, 'MDDS-501', 'Eletiva I',                                     4, 80, 1),
(@MDDS_M5, 'MDDS-502', 'Gestão Estratégica de Conteúdo Digital',       4, 80, 0),
(@MDDS_M5, 'MDDS-503', 'Mensuração de Resultados em Mídias Sociais',   4, 80, 0),
(@MDDS_M5, 'MDDS-504', 'Mineração de Dados',                           4, 80, 0);


-- ============================================================
-- 15. CURSO: Processos Gerenciais - EAD
-- Superior em Tecnologia | 4 Semestres | 1740h | 1520h disciplinas online
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Processos Gerenciais', 'Matriz 2023.1 - EAD', 4);

DECLARE @PGId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@PGId, 1, '1º Semestre'), (@PGId, 2, '2º Semestre'),
(@PGId, 3, '3º Semestre'), (@PGId, 4, '4º Semestre');

DECLARE @PG_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @PGId AND TermNumber = 1);
DECLARE @PG_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @PGId AND TermNumber = 2);
DECLARE @PG_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @PGId AND TermNumber = 3);
DECLARE @PG_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @PGId AND TermNumber = 4);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@PG_T1, 'PG-1A', 'MÓDULO/CICLO 1A', 400),
(@PG_T2, 'PG-1B', 'MÓDULO/CICLO 1B', 400),
(@PG_T3, 'PG-2A', 'MÓDULO/CICLO 2A', 400),
(@PG_T4, 'PG-2B', 'MÓDULO/CICLO 2B', 320);

DECLARE @PG_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'PG-1A' AND TermId = @PG_T1);
DECLARE @PG_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'PG-1B' AND TermId = @PG_T2);
DECLARE @PG_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'PG-2A' AND TermId = @PG_T3);
DECLARE @PG_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'PG-2B' AND TermId = @PG_T4);

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@PG_M1, 'PG-101', 'Comunicação e Linguagem',                          4, 80, 0),
(@PG_M1, 'PG-102', 'Administração de Recursos Humanos',                4, 80, 0),
(@PG_M1, 'PG-103', 'Administração Mercadológica',                      4, 80, 0),
(@PG_M1, 'PG-104', 'Introdução à Economia',                            4, 80, 0),
(@PG_M1, 'PG-105', 'Teoria Geral da Administração',                    4, 80, 0),
-- 2º Semestre
(@PG_M2, 'PG-201', 'Empreendedorismo, Vida e Carreira',                4, 80, 0),
(@PG_M2, 'PG-202', 'Eletiva I',                                         4, 80, 1),
(@PG_M2, 'PG-203', 'Estatística Aplicada',                             4, 80, 0),
(@PG_M2, 'PG-204', 'Matemática Financeira',                            4, 80, 0),
(@PG_M2, 'PG-205', 'Princípios Jurídicos nas Organizações',            4, 80, 0),
-- 3º Semestre
(@PG_M3, 'PG-301', 'Antropologia: Identidade e Diversidade',           4, 80, 0),
(@PG_M3, 'PG-302', 'Comportamento Organizacional',                     4, 80, 0),
(@PG_M3, 'PG-303', 'Contabilidade Geral',                              4, 80, 0),
(@PG_M3, 'PG-304', 'Gestão de Produtos, Serviços e Marcas',            4, 80, 0),
(@PG_M3, 'PG-305', 'Gestão Estratégica de Pessoas',                    4, 80, 0),
-- 4º Semestre
(@PG_M4, 'PG-401', 'Meio Ambiente, Sociedade e Cidadania',             4, 80, 0),
(@PG_M4, 'PG-402', 'Sistemas de Informações Gerenciais',               4, 80, 0),
(@PG_M4, 'PG-403', 'Gestão da Qualidade',                              4, 80, 0),
(@PG_M4, 'PG-404', 'Mapeamento e Gerenciamento de Processos',          4, 80, 0);


-- ============================================================
-- 16. CURSO: Relações Públicas - EAD
-- Bacharelado | 8 Semestres | 3560h | 2800h disciplinas online | TCC: Sim | Estágio: 200h
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Relações Públicas', 'Matriz 2023.1 - EAD', 8);

DECLARE @RPId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@RPId, 1, '1º Semestre'), (@RPId, 2, '2º Semestre'), (@RPId, 3, '3º Semestre'),
(@RPId, 4, '4º Semestre'), (@RPId, 5, '5º Semestre'), (@RPId, 6, '6º Semestre'),
(@RPId, 7, '7º Semestre'), (@RPId, 8, '8º Semestre');

DECLARE @RP_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @RPId AND TermNumber = 1);
DECLARE @RP_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @RPId AND TermNumber = 2);
DECLARE @RP_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @RPId AND TermNumber = 3);
DECLARE @RP_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @RPId AND TermNumber = 4);
DECLARE @RP_T5 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @RPId AND TermNumber = 5);
DECLARE @RP_T6 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @RPId AND TermNumber = 6);
DECLARE @RP_T7 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @RPId AND TermNumber = 7);
DECLARE @RP_T8 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @RPId AND TermNumber = 8);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@RP_T1, 'RP-1A', 'MÓDULO/CICLO 1A', 400),
(@RP_T2, 'RP-1B', 'MÓDULO/CICLO 1B', 400),
(@RP_T3, 'RP-2A', 'MÓDULO/CICLO 2A', 400),
(@RP_T4, 'RP-2B', 'MÓDULO/CICLO 2B', 400),
(@RP_T5, 'RP-3A', 'MÓDULO/CICLO 3A', 400),
(@RP_T6, 'RP-3B', 'MÓDULO/CICLO 3B', 320),
(@RP_T7, 'RP-4A', 'MÓDULO/CICLO 4A', 240),
(@RP_T8, 'RP-4B', 'MÓDULO/CICLO 4B', 240);

DECLARE @RP_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'RP-1A' AND TermId = @RP_T1);
DECLARE @RP_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'RP-1B' AND TermId = @RP_T2);
DECLARE @RP_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'RP-2A' AND TermId = @RP_T3);
DECLARE @RP_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'RP-2B' AND TermId = @RP_T4);
DECLARE @RP_M5 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'RP-3A' AND TermId = @RP_T5);
DECLARE @RP_M6 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'RP-3B' AND TermId = @RP_T6);
DECLARE @RP_M7 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'RP-4A' AND TermId = @RP_T7);
DECLARE @RP_M8 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'RP-4B' AND TermId = @RP_T8);

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@RP_M1, 'RP-101', 'Comunicação e Linguagem',                          4, 80, 0),
(@RP_M1, 'RP-102', 'Comportamento Organizacional',                     4, 80, 0),
(@RP_M1, 'RP-103', 'Comportamento do Consumidor',                      4, 80, 0),
(@RP_M1, 'RP-104', 'Inovação e Economia Criativa',                     4, 80, 0),
(@RP_M1, 'RP-105', 'Teoria e História da Comunicação',                 4, 80, 0),
-- 2º Semestre
(@RP_M2, 'RP-201', 'Metodologia da Pesquisa Científica e Tecnológica', 4, 80, 0),
(@RP_M2, 'RP-202', 'Gestão da Comunicação Integrada',                  4, 80, 0),
(@RP_M2, 'RP-203', 'Identidade Corporativa',                           4, 80, 0),
(@RP_M2, 'RP-204', 'Introdução à Relações Públicas',                   4, 80, 0),
(@RP_M2, 'RP-205', 'Pesquisa e Plano de Marketing',                    4, 80, 0),
-- 3º Semestre
(@RP_M3, 'RP-301', 'Antropologia: Identidade e Diversidade',           4, 80, 0),
(@RP_M3, 'RP-302', 'Eletiva I',                                         4, 80, 1),
(@RP_M3, 'RP-303', 'Governança Corporativa',                           4, 80, 0),
(@RP_M3, 'RP-304', 'Planejamento em Relações Públicas',                4, 80, 0),
(@RP_M3, 'RP-305', 'Relações Públicas em Mídias Digitais',             4, 80, 0),
-- 4º Semestre
(@RP_M4, 'RP-401', 'Meio Ambiente, Sociedade e Cidadania',             4, 80, 0),
(@RP_M4, 'RP-402', 'Produção em Áudio, Tv e Vídeo',                    4, 80, 0),
(@RP_M4, 'RP-403', 'Cerimonial e Protocolo',                           4, 80, 0),
(@RP_M4, 'RP-404', 'Pesquisa e Diagnóstico em Relações Públicas',      4, 80, 0),
(@RP_M4, 'RP-405', 'Gestão de Eventos',                                4, 80, 0),
-- 5º Semestre
(@RP_M5, 'RP-501', 'Empreendedorismo, Vida e Carreira',                4, 80, 0),
(@RP_M5, 'RP-502', 'Atendimento ao Consumidor e Ouvidoria',            4, 80, 0),
(@RP_M5, 'RP-503', 'Opinião Pública: Teorias e Aplicações',            4, 80, 0),
(@RP_M5, 'RP-504', 'Viabilização de Projetos Sociais e Culturais',     4, 80, 0),
(@RP_M5, 'RP-505', 'Gestão Estratégica para Cenários de Crise',        4, 80, 0),
-- 6º Semestre
(@RP_M6, 'RP-601', 'Marketing Digital, Inteligência Artificial e Novas Mídias', 4, 80, 0),
(@RP_M6, 'RP-602', 'Comunicação para Stakeholders',                    4, 80, 0),
(@RP_M6, 'RP-603', 'Construção de Imagem',                             4, 80, 0),
(@RP_M6, 'RP-604', 'Governos e Relações Públicas',                     4, 80, 0),
-- 7º Semestre
(@RP_M7, 'RP-701', 'Relacionamento com a Imprensa',                    4, 80, 0),
(@RP_M7, 'RP-702', 'Relações Públicas para o Terceiro Setor',          4, 80, 0),
(@RP_M7, 'RP-703', 'Trabalho de Conclusão de Curso I',                 4, 80, 0),
-- 8º Semestre
(@RP_M8, 'RP-801', 'Ética e Legislação em Relações Públicas',          4, 80, 0),
(@RP_M8, 'RP-802', 'Planejamento Estratégico em Relações Públicas',    4, 80, 0),
(@RP_M8, 'RP-803', 'Trabalho de Conclusão de Curso II',                4, 80, 0);


-- ============================================================
-- 17. CURSO: Segurança Pública - EAD
-- Superior em Tecnologia | 4 Semestres | 1740h | 1520h disciplinas online
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Segurança Pública', 'Matriz 2023.1 - EAD', 4);

DECLARE @SEPId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@SEPId, 1, '1º Semestre'), (@SEPId, 2, '2º Semestre'),
(@SEPId, 3, '3º Semestre'), (@SEPId, 4, '4º Semestre');

DECLARE @SEP_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SEPId AND TermNumber = 1);
DECLARE @SEP_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SEPId AND TermNumber = 2);
DECLARE @SEP_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SEPId AND TermNumber = 3);
DECLARE @SEP_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SEPId AND TermNumber = 4);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@SEP_T1, 'SEP-1A', 'MÓDULO/CICLO 1A', 400),
(@SEP_T2, 'SEP-1B', 'MÓDULO/CICLO 1B', 400),
(@SEP_T3, 'SEP-2A', 'MÓDULO/CICLO 2A', 400),
(@SEP_T4, 'SEP-2B', 'MÓDULO/CICLO 2B', 320);

DECLARE @SEP_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SEP-1A' AND TermId = @SEP_T1);
DECLARE @SEP_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SEP-1B' AND TermId = @SEP_T2);
DECLARE @SEP_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SEP-2A' AND TermId = @SEP_T3);
DECLARE @SEP_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SEP-2B' AND TermId = @SEP_T4);

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@SEP_M1, 'SEP-101', 'Comunicação e Linguagem',                        4, 80, 0),
(@SEP_M1, 'SEP-102', 'Teoria Geral do Estado',                         4, 80, 0),
(@SEP_M1, 'SEP-103', 'Fundamentos do Direito Administrativo',          4, 80, 0),
(@SEP_M1, 'SEP-104', 'Filosofia do Direito',                           4, 80, 0),
(@SEP_M1, 'SEP-105', 'Direito e Garantias Fundamentais',               4, 80, 0),
-- 2º Semestre
(@SEP_M2, 'SEP-201', 'Empreendedorismo, Vida e Carreira',              4, 80, 0),
(@SEP_M2, 'SEP-202', 'Eletiva I',                                       4, 80, 1),
(@SEP_M2, 'SEP-203', 'Relações Jurídicas no âmbito da Administração Pública', 4, 80, 0),
(@SEP_M2, 'SEP-204', 'Teoria Geral do Delito',                         4, 80, 0),
(@SEP_M2, 'SEP-205', 'Direitos Humanos',                               4, 80, 0),
-- 3º Semestre
(@SEP_M3, 'SEP-301', 'Antropologia, Identidade e Diversidade',         4, 80, 0),
(@SEP_M3, 'SEP-302', 'Psicologia Jurídica',                            4, 80, 0),
(@SEP_M3, 'SEP-303', 'Teoria da Pena',                                 4, 80, 0),
(@SEP_M3, 'SEP-304', 'Crimes em Espécie - Pessoa Humana',              4, 80, 0),
(@SEP_M3, 'SEP-305', 'Crimes em Espécie - Interesses Coletivos',       4, 80, 0),
-- 4º Semestre
(@SEP_M4, 'SEP-401', 'Meio Ambiente, Sociedade e Cidadania',           4, 80, 0),
(@SEP_M4, 'SEP-402', 'Segurança Pública e Penitenciária',              4, 80, 0),
(@SEP_M4, 'SEP-403', 'Direito Processual Penal - Fundamentos e Procedimentos', 4, 80, 0),
(@SEP_M4, 'SEP-404', 'Gestão e Orçamento Públicos',                    4, 80, 0);


-- ============================================================
-- VERIFICAÇÃO: cursos inseridos para FAM
-- ============================================================
SELECT dp.ProgramId, dp.ProgramName, dp.CurriculumVersion, dp.TotalSemesters,
       COUNT(DISTINCT at2.TermId) AS Semestres,
       COUNT(DISTINCT s.SubjectId) AS TotalDisciplinas,
       SUM(s.TotalSubjectHours) AS TotalHorasDisciplinas
FROM DegreeProgram dp
JOIN EducationalInstitution ei ON ei.InstitutionId = dp.InstitutionId
LEFT JOIN AcademicTerm at2 ON at2.ProgramId = dp.ProgramId
LEFT JOIN CourseModule cm ON cm.TermId = at2.TermId
LEFT JOIN AcademicSubject s ON s.ModuleId = cm.ModuleId
WHERE ei.InstitutionAcronym = 'FAM'
  AND dp.CurriculumVersion LIKE '%EAD%'
GROUP BY dp.ProgramId, dp.ProgramName, dp.CurriculumVersion, dp.TotalSemesters
ORDER BY dp.ProgramName;
