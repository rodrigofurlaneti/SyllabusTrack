-- ============================================================
-- FAM Centro Universitário — Seed Lote 2
-- 1. Sistemas para Internet - EAD
-- 2. Sistemas de Informação (Bacharelado)
-- 3. Segurança da Informação - EAD
-- 4. Gestão da Tecnologia da Informação - EAD
-- 5. Ciências da Computação (Bacharelado)
--
-- PRÉ-REQUISITO: Execute Seed_FAM_Courses.sql antes (cria a instituição FAM).
-- ============================================================
USE SyllabusTrackDb;
GO

DECLARE @FamId INT = (
    SELECT InstitutionId FROM EducationalInstitution WHERE InstitutionAcronym = 'FAM'
);

IF @FamId IS NULL
BEGIN
    RAISERROR('Instituição FAM não encontrada. Execute Seed_FAM_Courses.sql primeiro.', 16, 1);
    RETURN;
END


-- ============================================================
-- 1. SISTEMAS PARA INTERNET - EAD
--    Superior em Tecnologia | 5 Semestres | 2200h
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Sistemas para Internet', 'Matriz 2023.1 - EAD', 5);

DECLARE @SIId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@SIId, 1, '1º Semestre'), (@SIId, 2, '2º Semestre'),
(@SIId, 3, '3º Semestre'), (@SIId, 4, '4º Semestre'), (@SIId, 5, '5º Semestre');

DECLARE @SI_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SIId AND TermNumber = 1);
DECLARE @SI_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SIId AND TermNumber = 2);
DECLARE @SI_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SIId AND TermNumber = 3);
DECLARE @SI_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SIId AND TermNumber = 4);
DECLARE @SI_T5 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SIId AND TermNumber = 5);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@SI_T1, 'SI-1A', 'MÓDULO/CICLO 1A', 400),
(@SI_T2, 'SI-1B', 'MÓDULO/CICLO 1B', 400),
(@SI_T3, 'SI-2A', 'MÓDULO/CICLO 2A', 400),
(@SI_T4, 'SI-2B', 'MÓDULO/CICLO 2B', 400),
(@SI_T5, 'SI-3A', 'MÓDULO/CICLO 3A', 320);

DECLARE @SI_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SI-1A');
DECLARE @SI_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SI-1B');
DECLARE @SI_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SI-2A');
DECLARE @SI_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SI-2B');
DECLARE @SI_M5 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SI-3A');

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@SI_M1, 'SI-101', 'Comunicação e Linguagem',                          4, 80, 0),
(@SI_M1, 'SI-102', 'Paradigmas de Linguagens de Programação',          4, 80, 0),
(@SI_M1, 'SI-103', 'Algoritmos e Lógica de Programação',               4, 80, 0),
(@SI_M1, 'SI-104', 'Fundamentos Matemáticos da Computação',            4, 80, 0),
(@SI_M1, 'SI-105', 'Sistemas Computacionais',                           4, 80, 0),
-- 2º Semestre
(@SI_M2, 'SI-201', 'Metodologia da Pesquisa Científica e Tecnológica', 4, 80, 0),
(@SI_M2, 'SI-202', 'Estrutura e Modelagem de Dados',                    4, 80, 0),
(@SI_M2, 'SI-203', 'Banco de Dados',                                     4, 80, 0),
(@SI_M2, 'SI-204', 'Redes de Computadores',                              4, 80, 0),
(@SI_M2, 'SI-205', 'Sistemas Operacionais',                              4, 80, 0),
-- 3º Semestre
(@SI_M3, 'SI-301', 'Antropologia: Identidade e Diversidade',            4, 80, 0),
(@SI_M3, 'SI-302', 'Análise e Projeto de Sistemas',                     4, 80, 0),
(@SI_M3, 'SI-303', 'Interfaces Digitais: Front-End',                    4, 80, 0),
(@SI_M3, 'SI-304', 'Direção de Artes para Web',                         4, 80, 0),
(@SI_M3, 'SI-305', 'Internet das Coisas (IOT) e Novas Tecnologias',    4, 80, 0),
-- 4º Semestre
(@SI_M4, 'SI-401', 'Meio Ambiente, Sociedade e Cidadania',              4, 80, 0),
(@SI_M4, 'SI-402', 'Programação Back-End',                              4, 80, 0),
(@SI_M4, 'SI-403', 'Arquitetura da Informação UX/UI',                   4, 80, 0),
(@SI_M4, 'SI-404', 'Gerenciamento e Gestão de Projetos de TI',         4, 80, 0),
(@SI_M4, 'SI-405', 'Programação de Aplicativos para Dispositivos Móveis', 4, 80, 0),
-- 5º Semestre
(@SI_M5, 'SI-501', 'Eletiva I',                                          4, 80, 1),
(@SI_M5, 'SI-502', 'Design para Dispositivos Móveis',                   4, 80, 0),
(@SI_M5, 'SI-503', 'Interface, Navegação e Interação',                  4, 80, 0),
(@SI_M5, 'SI-504', 'Responsive Web Design',                              4, 80, 0);

PRINT 'Sistemas para Internet - EAD: OK';


-- ============================================================
-- 2. SISTEMAS DE INFORMAÇÃO
--    Bacharelado | 8 Semestres | 3245h
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Sistemas de Informação', 'Matriz 2023.1', 8);

DECLARE @SISId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@SISId, 1, '1º Semestre'), (@SISId, 2, '2º Semestre'),
(@SISId, 3, '3º Semestre'), (@SISId, 4, '4º Semestre'),
(@SISId, 5, '5º Semestre'), (@SISId, 6, '6º Semestre'),
(@SISId, 7, '7º Semestre'), (@SISId, 8, '8º Semestre');

DECLARE @SIS_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SISId AND TermNumber = 1);
DECLARE @SIS_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SISId AND TermNumber = 2);
DECLARE @SIS_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SISId AND TermNumber = 3);
DECLARE @SIS_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SISId AND TermNumber = 4);
DECLARE @SIS_T5 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SISId AND TermNumber = 5);
DECLARE @SIS_T6 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SISId AND TermNumber = 6);
DECLARE @SIS_T7 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SISId AND TermNumber = 7);
DECLARE @SIS_T8 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SISId AND TermNumber = 8);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@SIS_T1, 'SIS-1A', 'MÓDULO/CICLO 1A', 400),
(@SIS_T2, 'SIS-1B', 'MÓDULO/CICLO 1B', 400),
(@SIS_T3, 'SIS-2A', 'MÓDULO/CICLO 2A', 400),
(@SIS_T4, 'SIS-2B', 'MÓDULO/CICLO 2B', 400),
(@SIS_T5, 'SIS-3A', 'MÓDULO/CICLO 3A', 320),
(@SIS_T6, 'SIS-3B', 'MÓDULO/CICLO 3B', 320),
(@SIS_T7, 'SIS-4A', 'MÓDULO/CICLO 4A', 320),
(@SIS_T8, 'SIS-4B', 'MÓDULO/CICLO 4B', 320);

DECLARE @SIS_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SIS-1A');
DECLARE @SIS_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SIS-1B');
DECLARE @SIS_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SIS-2A');
DECLARE @SIS_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SIS-2B');
DECLARE @SIS_M5 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SIS-3A');
DECLARE @SIS_M6 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SIS-3B');
DECLARE @SIS_M7 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SIS-4A');
DECLARE @SIS_M8 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SIS-4B');

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@SIS_M1, 'SIS-101', 'Comunicação e Linguagem',                          4, 80, 0),
(@SIS_M1, 'SIS-102', 'Paradigmas de Linguagens de Programação',          4, 80, 0),
(@SIS_M1, 'SIS-103', 'Algoritmos e Lógica de Programação',               4, 80, 0),
(@SIS_M1, 'SIS-104', 'Fundamentos Matemáticos da Computação',            4, 80, 0),
(@SIS_M1, 'SIS-105', 'Sistemas Computacionais',                           4, 80, 0),
(@SIS_M1, 'SIS-106', 'Projeto Interdisciplinar 1A',                       0,  0, 0),
-- 2º Semestre
(@SIS_M2, 'SIS-201', 'Metodologia da Pesquisa Científica e Tecnológica', 4, 80, 0),
(@SIS_M2, 'SIS-202', 'Sistemas Operacionais',                             4, 80, 0),
(@SIS_M2, 'SIS-203', 'Banco de Dados',                                     4, 80, 0),
(@SIS_M2, 'SIS-204', 'Estrutura e Modelagem de Dados',                    4, 80, 0),
(@SIS_M2, 'SIS-205', 'Redes de Computadores',                             4, 80, 0),
(@SIS_M2, 'SIS-206', 'Projeto Interdisciplinar 1B',                       0,  0, 0),
-- 3º Semestre
(@SIS_M3, 'SIS-301', 'Antropologia: Identidade e Diversidade',            4, 80, 0),
(@SIS_M3, 'SIS-302', 'Engenharia de Software',                             4, 80, 0),
(@SIS_M3, 'SIS-303', 'Programação Orientada a Objetos',                   4, 80, 0),
(@SIS_M3, 'SIS-304', 'Análise e Projeto de Sistemas',                     4, 80, 0),
(@SIS_M3, 'SIS-305', 'Inteligência no Negócio',                           4, 80, 0),
(@SIS_M3, 'SIS-306', 'Projeto Interdisciplinar 2A',                       0,  0, 0),
-- 4º Semestre
(@SIS_M4, 'SIS-401', 'Meio Ambiente, Sociedade e Cidadania',              4, 80, 0),
(@SIS_M4, 'SIS-402', 'Eletiva I',                                          4, 80, 1),
(@SIS_M4, 'SIS-403', 'Gerenciamento e Gestão de Projetos',                4, 80, 0),
(@SIS_M4, 'SIS-404', 'Probabilidade e Estatística',                       4, 80, 0),
(@SIS_M4, 'SIS-405', 'Qualidade de Software',                             4, 80, 0),
(@SIS_M4, 'SIS-406', 'Projeto Interdisciplinar 2B',                       0,  0, 0),
-- 5º Semestre
(@SIS_M5, 'SIS-501', 'Eletiva II',                                         4, 80, 1),
(@SIS_M5, 'SIS-502', 'Mineração de Dados',                                 4, 80, 0),
(@SIS_M5, 'SIS-503', 'Análise e Modelagem de Processos de Negócios',      4, 80, 0),
(@SIS_M5, 'SIS-504', 'Governança e Estratégia de TI',                     4, 80, 0),
(@SIS_M5, 'SIS-505', 'Projeto Interdisciplinar 3A',                       0,  0, 0),
-- 6º Semestre
(@SIS_M6, 'SIS-601', 'Empreendedorismo, Vida e Carreira',                 4, 80, 0),
(@SIS_M6, 'SIS-602', 'Ferramentas para Aplicação da Matemática',          4, 80, 0),
(@SIS_M6, 'SIS-603', 'Tecnologias para Internet',                         4, 80, 0),
(@SIS_M6, 'SIS-604', 'Segurança e Arquitetura Orientada a Serviços',     4, 80, 0),
(@SIS_M6, 'SIS-605', 'Projeto Interdisciplinar 3B',                       0,  0, 0),
-- 7º Semestre
(@SIS_M7, 'SIS-701', 'Eletiva III',                                        4, 80, 1),
(@SIS_M7, 'SIS-702', 'Métodos Matemáticos',                               4, 80, 0),
(@SIS_M7, 'SIS-703', 'Internet das Coisas (IOT) e Novas Tecnologias',    4, 80, 0),
(@SIS_M7, 'SIS-704', 'Desenvolvimento Mobile',                             4, 80, 0),
(@SIS_M7, 'SIS-705', 'Projeto Interdisciplinar 4A',                       0,  0, 0),
-- 8º Semestre
(@SIS_M8, 'SIS-801', 'Inovação e Economia Criativa',                      4, 80, 0),
(@SIS_M8, 'SIS-802', 'Computação Gráfica',                                 4, 80, 0),
(@SIS_M8, 'SIS-803', 'Sistemas Embarcados e Visão Computacional',         4, 80, 0),
(@SIS_M8, 'SIS-804', 'Inteligência Artificial e Computacional',           4, 80, 0),
(@SIS_M8, 'SIS-805', 'Trabalho de Conclusão de Curso',                    4, 80, 0),
(@SIS_M8, 'SIS-806', 'Projeto Interdisciplinar 4B',                       0,  0, 0);

PRINT 'Sistemas de Informação (Bacharelado): OK';


-- ============================================================
-- 3. SEGURANÇA DA INFORMAÇÃO - EAD
--    Superior em Tecnologia | 5 Semestres | 2200h
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Segurança da Informação', 'Matriz 2023.1 - EAD', 5);

DECLARE @SEGId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@SEGId, 1, '1º Semestre'), (@SEGId, 2, '2º Semestre'),
(@SEGId, 3, '3º Semestre'), (@SEGId, 4, '4º Semestre'), (@SEGId, 5, '5º Semestre');

DECLARE @SEG_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SEGId AND TermNumber = 1);
DECLARE @SEG_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SEGId AND TermNumber = 2);
DECLARE @SEG_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SEGId AND TermNumber = 3);
DECLARE @SEG_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SEGId AND TermNumber = 4);
DECLARE @SEG_T5 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @SEGId AND TermNumber = 5);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@SEG_T1, 'SEG-1A', 'MÓDULO/CICLO 1A', 400),
(@SEG_T2, 'SEG-1B', 'MÓDULO/CICLO 1B', 400),
(@SEG_T3, 'SEG-2A', 'MÓDULO/CICLO 2A', 400),
(@SEG_T4, 'SEG-2B', 'MÓDULO/CICLO 2B', 400),
(@SEG_T5, 'SEG-3A', 'MÓDULO/CICLO 3A', 320);

DECLARE @SEG_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SEG-1A');
DECLARE @SEG_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SEG-1B');
DECLARE @SEG_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SEG-2A');
DECLARE @SEG_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SEG-2B');
DECLARE @SEG_M5 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'SEG-3A');

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@SEG_M1, 'SEG-101', 'Comunicação e Linguagem',                          4, 80, 0),
(@SEG_M1, 'SEG-102', 'Paradigmas de Linguagens de Programação',          4, 80, 0),
(@SEG_M1, 'SEG-103', 'Algoritmos e Lógica de Programação',               4, 80, 0),
(@SEG_M1, 'SEG-104', 'Fundamentos Matemáticos da Computação',            4, 80, 0),
(@SEG_M1, 'SEG-105', 'Sistemas Computacionais',                           4, 80, 0),
-- 2º Semestre
(@SEG_M2, 'SEG-201', 'Metodologia da Pesquisa Científica e Tecnológica', 4, 80, 0),
(@SEG_M2, 'SEG-202', 'Estrutura e Modelagem de Dados',                    4, 80, 0),
(@SEG_M2, 'SEG-203', 'Banco de Dados',                                     4, 80, 0),
(@SEG_M2, 'SEG-204', 'Sistemas Operacionais',                              4, 80, 0),
(@SEG_M2, 'SEG-205', 'Redes de Computadores',                              4, 80, 0),
-- 3º Semestre
(@SEG_M3, 'SEG-301', 'Antropologia: Identidade e Diversidade',            4, 80, 0),
(@SEG_M3, 'SEG-302', 'Estratégias, Governança e Ferramentas para Segurança', 4, 80, 0),
(@SEG_M3, 'SEG-303', 'Ética, Hacking e Ransomware',                       4, 80, 0),
(@SEG_M3, 'SEG-304', 'Inovação e Novas Tecnologias',                      4, 80, 0),
(@SEG_M3, 'SEG-305', 'Inteligência e Espionagem',                         4, 80, 0),
-- 4º Semestre
(@SEG_M4, 'SEG-401', 'Meio Ambiente, Sociedade e Cidadania',              4, 80, 0),
(@SEG_M4, 'SEG-402', 'Eletiva I',                                          4, 80, 1),
(@SEG_M4, 'SEG-403', 'Planejamento e Gestão Estratégica',                 4, 80, 0),
(@SEG_M4, 'SEG-404', 'Computação Forense & Perícia Digital',              4, 80, 0),
(@SEG_M4, 'SEG-405', 'Defesa Cibernética',                                4, 80, 0),
-- 5º Semestre
(@SEG_M5, 'SEG-501', 'Planejamento e Infraestrutura de Segurança',       4, 80, 0),
(@SEG_M5, 'SEG-502', 'Tecnologias e Cibersegurança',                      4, 80, 0),
(@SEG_M5, 'SEG-503', 'Gestão de Riscos',                                   4, 80, 0),
(@SEG_M5, 'SEG-504', 'Gestão de Crises e Continuidade dos Negócios',     4, 80, 0);

PRINT 'Segurança da Informação - EAD: OK';


-- ============================================================
-- 4. GESTÃO DA TECNOLOGIA DA INFORMAÇÃO - EAD
--    Superior em Tecnologia | 5 Semestres | 2200h
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Gestão da Tecnologia da Informação', 'Matriz 2023.1 - EAD', 5);

DECLARE @GTIId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@GTIId, 1, '1º Semestre'), (@GTIId, 2, '2º Semestre'),
(@GTIId, 3, '3º Semestre'), (@GTIId, 4, '4º Semestre'), (@GTIId, 5, '5º Semestre');

DECLARE @GTI_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GTIId AND TermNumber = 1);
DECLARE @GTI_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GTIId AND TermNumber = 2);
DECLARE @GTI_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GTIId AND TermNumber = 3);
DECLARE @GTI_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GTIId AND TermNumber = 4);
DECLARE @GTI_T5 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @GTIId AND TermNumber = 5);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@GTI_T1, 'GTI-1A', 'MÓDULO/CICLO 1A', 400),
(@GTI_T2, 'GTI-1B', 'MÓDULO/CICLO 1B', 400),
(@GTI_T3, 'GTI-2A', 'MÓDULO/CICLO 2A', 400),
(@GTI_T4, 'GTI-2B', 'MÓDULO/CICLO 2B', 400),
(@GTI_T5, 'GTI-3A', 'MÓDULO/CICLO 3A', 320);

DECLARE @GTI_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GTI-1A');
DECLARE @GTI_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GTI-1B');
DECLARE @GTI_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GTI-2A');
DECLARE @GTI_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GTI-2B');
DECLARE @GTI_M5 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'GTI-3A');

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@GTI_M1, 'GTI-101', 'Comunicação e Linguagem',                          4, 80, 0),
(@GTI_M1, 'GTI-102', 'Paradigmas de Linguagens de Programação',          4, 80, 0),
(@GTI_M1, 'GTI-103', 'Algoritmos e Lógica de Programação',               4, 80, 0),
(@GTI_M1, 'GTI-104', 'Fundamentos Matemáticos da Computação',            4, 80, 0),
(@GTI_M1, 'GTI-105', 'Sistemas Computacionais',                           4, 80, 0),
-- 2º Semestre
(@GTI_M2, 'GTI-201', 'Metodologia da Pesquisa Científica e Tecnológica', 4, 80, 0),
(@GTI_M2, 'GTI-202', 'Estrutura e Modelagem de Dados',                    4, 80, 0),
(@GTI_M2, 'GTI-203', 'Banco de Dados',                                     4, 80, 0),
(@GTI_M2, 'GTI-204', 'Sistemas Operacionais',                              4, 80, 0),
(@GTI_M2, 'GTI-205', 'Redes de Computadores',                              4, 80, 0),
-- 3º Semestre
(@GTI_M3, 'GTI-301', 'Antropologia: Identidade e Diversidade',            4, 80, 0),
(@GTI_M3, 'GTI-302', 'Análise e Projeto de Sistemas',                     4, 80, 0),
(@GTI_M3, 'GTI-303', 'Engenharia de Software',                             4, 80, 0),
(@GTI_M3, 'GTI-304', 'Programação Orientada a Objetos',                   4, 80, 0),
(@GTI_M3, 'GTI-305', 'Governança e Estratégias de TI',                    4, 80, 0),
-- 4º Semestre
(@GTI_M4, 'GTI-401', 'Meio Ambiente, Sociedade e Cidadania',              4, 80, 0),
(@GTI_M4, 'GTI-402', 'Eletiva I',                                          4, 80, 1),
(@GTI_M4, 'GTI-403', 'Análise e Modelagem de Processos de Negócios',     4, 80, 0),
(@GTI_M4, 'GTI-404', 'Gerenciamento e Gestão de Projetos de TI',         4, 80, 0),
(@GTI_M4, 'GTI-405', 'Probabilidade e Estatística',                       4, 80, 0),
-- 5º Semestre
(@GTI_M5, 'GTI-501', 'Mineração de Dados e Big Data',                     4, 80, 0),
(@GTI_M5, 'GTI-502', 'Tecnologias e Cibersegurança',                      4, 80, 0),
(@GTI_M5, 'GTI-503', 'Comportamento Organizacional',                       4, 80, 0),
(@GTI_M5, 'GTI-504', 'Gestão de Crises e Continuidade dos Negócios',     4, 80, 0);

PRINT 'Gestão da Tecnologia da Informação - EAD: OK';


-- ============================================================
-- 5. CIÊNCIAS DA COMPUTAÇÃO
--    Bacharelado | 8 Semestres | 3200h
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Ciências da Computação', 'Matriz 2023.1', 8);

DECLARE @CCId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@CCId, 1, '1º Semestre'), (@CCId, 2, '2º Semestre'),
(@CCId, 3, '3º Semestre'), (@CCId, 4, '4º Semestre'),
(@CCId, 5, '5º Semestre'), (@CCId, 6, '6º Semestre'),
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

DECLARE @CC_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CC-1A');
DECLARE @CC_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CC-1B');
DECLARE @CC_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CC-2A');
DECLARE @CC_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CC-2B');
DECLARE @CC_M5 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CC-3A');
DECLARE @CC_M6 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CC-3B');
DECLARE @CC_M7 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CC-4A');
DECLARE @CC_M8 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'CC-4B');

INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre
(@CC_M1, 'CC-101', 'Comunicação e Linguagem',                          4, 80, 0),
(@CC_M1, 'CC-102', 'Paradigmas de Linguagens de Programação',          4, 80, 0),
(@CC_M1, 'CC-103', 'Algoritmos e Lógica de Programação',               4, 80, 0),
(@CC_M1, 'CC-104', 'Fundamentos Matemáticos da Computação',            4, 80, 0),
(@CC_M1, 'CC-105', 'Sistemas Computacionais',                           4, 80, 0),
(@CC_M1, 'CC-106', 'Projeto Interdisciplinar 1A',                       0,  0, 0),
-- 2º Semestre
(@CC_M2, 'CC-201', 'Metodologia da Pesquisa Científica e Tecnológica', 4, 80, 0),
(@CC_M2, 'CC-202', 'Sistemas Operacionais',                             4, 80, 0),
(@CC_M2, 'CC-203', 'Banco de Dados',                                     4, 80, 0),
(@CC_M2, 'CC-204', 'Estrutura e Modelagem de Dados',                    4, 80, 0),
(@CC_M2, 'CC-205', 'Redes de Computadores',                             4, 80, 0),
(@CC_M2, 'CC-206', 'Projeto Interdisciplinar 1B',                       0,  0, 0),
-- 3º Semestre
(@CC_M3, 'CC-301', 'Antropologia: Identidade e Diversidade',            4, 80, 0),
(@CC_M3, 'CC-302', 'Engenharia de Software',                             4, 80, 0),
(@CC_M3, 'CC-303', 'Programação Orientada a Objetos',                   4, 80, 0),
(@CC_M3, 'CC-304', 'Análise e Projeto de Sistemas',                     4, 80, 0),
(@CC_M3, 'CC-305', 'Internet das Coisas (IOT) e Novas Tecnologias',    4, 80, 0),
(@CC_M3, 'CC-306', 'Projeto Interdisciplinar 2A',                       0,  0, 0),
-- 4º Semestre
(@CC_M4, 'CC-401', 'Meio Ambiente, Sociedade e Cidadania',              4, 80, 0),
(@CC_M4, 'CC-402', 'Eletiva I',                                          4, 80, 1),
(@CC_M4, 'CC-403', 'Gerenciamento e Gestão de Projetos',                4, 80, 0),
(@CC_M4, 'CC-404', 'Aplicações para Banco de Dados e Data Science',    4, 80, 0),
(@CC_M4, 'CC-405', 'Qualidade de Software',                             4, 80, 0),
(@CC_M4, 'CC-406', 'Projeto Interdisciplinar 2B',                       0,  0, 0),
-- 5º Semestre
(@CC_M5, 'CC-501', 'Eletiva II',                                         4, 80, 1),
(@CC_M5, 'CC-502', 'Desenvolvimento Mobile',                             4, 80, 0),
(@CC_M5, 'CC-503', 'Programação Back-End',                              4, 80, 0),
(@CC_M5, 'CC-504', 'Interfaces Digitais: Front-End',                    4, 80, 0),
(@CC_M5, 'CC-505', 'Projeto Interdisciplinar 3A',                       0,  0, 0),
-- 6º Semestre
(@CC_M6, 'CC-601', 'Sistemas Distribuídos',                             4, 80, 0),
(@CC_M6, 'CC-602', 'Estrutura de Dados',                                4, 80, 0),
(@CC_M6, 'CC-603', 'Complexidade de Algoritmos',                        4, 80, 0),
(@CC_M6, 'CC-604', 'Probabilidade e Estatística',                       4, 80, 0),
(@CC_M6, 'CC-605', 'Projeto Interdisciplinar 3B',                       0,  0, 0),
-- 7º Semestre
(@CC_M7, 'CC-701', 'Estruturas Matemáticas',                            4, 80, 0),
(@CC_M7, 'CC-702', 'Métodos Matemáticos',                               4, 80, 0),
(@CC_M7, 'CC-703', 'Compiladores',                                       4, 80, 0),
(@CC_M7, 'CC-704', 'Linguagens Formais e Autômatos',                    4, 80, 0),
(@CC_M7, 'CC-705', 'Projeto Interdisciplinar 4A',                       0,  0, 0),
-- 8º Semestre
(@CC_M8, 'CC-801', 'Inovação e Economia Criativa',                      4, 80, 0),
(@CC_M8, 'CC-802', 'Computação Gráfica',                                4, 80, 0),
(@CC_M8, 'CC-803', 'Sistemas Embarcados e Visão Computacional',         4, 80, 0),
(@CC_M8, 'CC-804', 'Inteligência Artificial e Computacional',           4, 80, 0),
(@CC_M8, 'CC-805', 'Trabalho de Conclusão de Curso',                    4, 80, 0),
(@CC_M8, 'CC-806', 'Estágio Supervisionado',                            0,180, 0),
(@CC_M8, 'CC-807', 'Projeto Interdisciplinar 4B',                       0,  0, 0);

PRINT 'Ciências da Computação (Bacharelado): OK';


-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================
SELECT
    p.ProgramName                  AS Curso,
    p.CurriculumVersion            AS Versao,
    p.TotalSemesters               AS Semestres,
    COUNT(DISTINCT t.TermId)       AS TermosInseridos,
    COUNT(DISTINCT m.ModuleId)     AS Modulos,
    COUNT(s.SubjectId)             AS Disciplinas,
    SUM(s.TotalSubjectHours)       AS CargaHorariaDisciplinas
FROM DegreeProgram   p
JOIN EducationalInstitution i ON i.InstitutionId = p.InstitutionId
JOIN AcademicTerm    t ON t.ProgramId  = p.ProgramId
JOIN CourseModule    m ON m.TermId     = t.TermId
JOIN AcademicSubject s ON s.ModuleId   = m.ModuleId
WHERE i.InstitutionAcronym = 'FAM'
  AND p.ProgramName NOT IN ('Banco de Dados', 'Análise e Desenvolvimento de Sistemas')  -- lote 1 já inserido
GROUP BY p.ProgramName, p.CurriculumVersion, p.TotalSemesters
ORDER BY p.ProgramName;
