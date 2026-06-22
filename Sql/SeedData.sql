USE SyllabusTrackDb;
GO

-- =========================================
-- 1. INSTITUIÇÃO E CURSO
-- =========================================
INSERT INTO EducationalInstitution (InstitutionName, InstitutionAcronym, CampusLocation)
VALUES ('Fundação UnirG - Universidade de Gurupi', 'UnirG', 'Campus Gurupi');

DECLARE @InstitutionId INT = (SELECT TOP 1 InstitutionId FROM EducationalInstitution WHERE InstitutionAcronym = 'UnirG');

INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@InstitutionId, 'Medicina', 'Matriz Curricular Nº 5 - Matriz Unificada', 12);

DECLARE @ProgramId INT = (SELECT TOP 1 ProgramId FROM DegreeProgram WHERE ProgramName = 'Medicina');

-- =========================================
-- 2. PERÍODOS ACADÊMICOS (1 ao 12)
-- =========================================
INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@ProgramId, 1, 'Primeiro Período'),
(@ProgramId, 2, 'Segundo Período'),
(@ProgramId, 3, 'Terceiro Período'),
(@ProgramId, 4, 'Quarto Período'),
(@ProgramId, 5, 'Quinto Período'),
(@ProgramId, 6, 'Sexto Período'),
(@ProgramId, 7, 'Sétimo Período'),
(@ProgramId, 8, 'Oitavo Período'),
(@ProgramId, 9, 'Nono Período (Estágio I)'),
(@ProgramId, 10, 'Décimo Período (Estágio II)'),
(@ProgramId, 11, 'Décimo Primeiro Período (Estágio III)'),
(@ProgramId, 12, 'Décimo Segundo Período (Estágio IV)');

-- =========================================
-- 3. MÓDULOS DOS SEMESTRES
-- =========================================
-- Utilizaremos a "Ordem" ou "Código do Módulo" do PDF como ModuleCode para facilitar o vínculo
DECLARE @T1 INT = (SELECT TermId FROM AcademicTerm WHERE TermNumber = 1);
DECLARE @T2 INT = (SELECT TermId FROM AcademicTerm WHERE TermNumber = 2);
DECLARE @T3 INT = (SELECT TermId FROM AcademicTerm WHERE TermNumber = 3);
DECLARE @T4 INT = (SELECT TermId FROM AcademicTerm WHERE TermNumber = 4);
DECLARE @T5 INT = (SELECT TermId FROM AcademicTerm WHERE TermNumber = 5);
DECLARE @T6 INT = (SELECT TermId FROM AcademicTerm WHERE TermNumber = 6);
DECLARE @T7 INT = (SELECT TermId FROM AcademicTerm WHERE TermNumber = 7);
DECLARE @T8 INT = (SELECT TermId FROM AcademicTerm WHERE TermNumber = 8);
DECLARE @T9 INT = (SELECT TermId FROM AcademicTerm WHERE TermNumber = 9);
DECLARE @T10 INT = (SELECT TermId FROM AcademicTerm WHERE TermNumber = 10);
DECLARE @T11 INT = (SELECT TermId FROM AcademicTerm WHERE TermNumber = 11);
DECLARE @T12 INT = (SELECT TermId FROM AcademicTerm WHERE TermNumber = 12);

INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
-- 1º Período
(@T1, '63013161', 'PROCESSOS BIOLÓGICOS I-A', 14),
(@T1, '63013165', 'PROCESSOS BIOLÓGICOS I-B', 10),
(@T1, '63013169', 'FUNDAMENTOS INTEGRADORES I', 8),
(@T1, '63013172', 'PRÁTICA MÉDICA I', 6),
(@T1, 'OPT', 'DISCIPLINAS OPTATIVAS', 16), -- Agrupador de Optativas
-- 2º Período
(@T2, '63013176', 'PROCESSOS BIOLÓGICOS II-A', 18),
(@T2, '63013181', 'PROCESSOS BIOLÓGICOS II-B', 5),
(@T2, '63013184', 'FUNDAMENTOS INTEGRADORES II', 10),
(@T2, '63013188', 'PRÁTICA MÉDICA II - Semiologia I', 4),
(@T2, '63013189', 'METODOLOGIA CIENTÍFICA', 2),
-- 3º Período
(@T3, '63013190', 'PROCESSOS BIOLÓGICOS III', 11),
(@T3, '63013194', 'FUNDAMENTOS INTEGRADORES III', 11),
(@T3, '63013198', 'PRÁTICA MÉDICA III', 14),
(@T3, '63013203', 'PESQUISA E INICIAÇÃO CIENTÍFICA', 2),
-- 4º Período
(@T4, '63013204', 'MEDICINA INTEGRADA I', 11),
(@T4, '63013209', 'ATENÇÃO À SAÚDE I', 6),
(@T4, '63013213', 'FUNDAMENTOS INTEGRADORES IV', 8),
(@T4, '63013216', 'PRÁTICA MÉDICA IV', 12),
-- 5º Período
(@T5, '63013220', 'ATENÇÃO À SAÚDE II', 8),
(@T5, '63013223', 'CLÍNICA MÉDICA I', 25),
(@T5, '63013231', 'FUNDAMENTOS INTEGRADORES V', 6),
-- 6º Período
(@T6, '63013232', 'ATENÇÃO À SAÚDE III', 8),
(@T6, '63013235', 'MEDICINA INTEGRADA II', 5),
(@T6, '63013238', 'CLÍNICA MÉDICA II', 20),
(@T6, '63013244', 'FUNDAMENTOS INTEGRADORES VI', 6),
-- 7º Período
(@T7, '63013245', 'ATENÇÃO À SAÚDE IV', 6),
(@T7, '63013248', 'CLÍNICA MÉDICA III', 23),
(@T7, '63013255', 'FUNDAMENTOS INTEGRADORES VII', 6),
(@T7, '63013256', 'MEDICINA INTEGRADA III', 2),
(@T7, '63013257', 'PROJETO DE PESQUISA', 2),
-- 8º Período
(@T8, '63013258', 'ATENÇÃO À SAÚDE V', 4),
(@T8, '63013259', 'MEDICINA INTEGRADA IV', 3),
(@T8, '63013260', 'FUNDAMENTOS INTEGRADORES VIII', 6),
(@T8, '63013261', 'CLÍNICA MÉDICA V', 23),
(@T8, '63013269', 'TRABALHO DE CONCLUSÃO DE CURSO - TCC', 2),
-- Internato (Estágios 9 ao 12)
(@T9, '63013270', 'ESTÁGIO SUPERVISIONADO I', 44),
(@T10, '63013271', 'ESTÁGIO SUPERVISIONADO II', 44),
(@T11, '63013272', 'ESTÁGIO SUPERVISIONADO III', 43),
(@T12, '63013273', 'ESTÁGIO SUPERVISIONADO IV', 43);

-- =========================================
-- 4. DISCIPLINAS E CARGAS HORÁRIAS
-- =========================================

-- Função auxiliar não necessária, faremos inserts massivos filtrando o ModuleId
INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TheoreticalHours, PracticalHours, StudyGroupHours, ExtensionHours, InternshipHours, TotalSubjectHours, IsOptional) VALUES

-- PRIMEIRO PERÍODO
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013161'), '63013162', 'Anatomia Humana I', 6, 30, 45, 15, 0, 0, 90, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013161'), '63013163', 'Fisiologia Humana I', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013161'), '63013164', 'Histologia Médica', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013165'), '63013166', 'Biologia Celular e Molecular', 3, 30, 0, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013165'), '63013167', 'Embriologia', 3, 30, 0, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013165'), '63013168', 'Bioquímica I', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013169'), '63013170', 'Integração Universidade, Serviço e Comunidade I', 6, 15, 0, 0, 75, 0, 90, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013169'), '63013171', 'Formação Humana I', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013172'), '63013173', 'Rede de Atenção', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013172'), '63013174', 'Primeiros Socorros', 2, 15, 15, 0, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013172'), '63013175', 'Educação em Saúde', 2, 15, 0, 15, 0, 0, 30, 0),

-- SEGUNDO PERÍODO
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013176'), '63013177', 'Anatomia Humana II', 5, 30, 30, 15, 0, 0, 75, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013176'), '63013178', 'Neuroanatomia', 5, 30, 30, 15, 0, 0, 75, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013176'), '63013179', 'Fisiologia Humana II', 4, 45, 0, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013176'), '63013180', 'Histologia Médica II', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013181'), '63013182', 'Genética', 2, 30, 0, 0, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013181'), '63013183', 'Bioquímica II', 3, 30, 15, 0, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013184'), '63013185', 'Integração Universidade, Serviço e Comunidade II', 6, 15, 0, 0, 75, 0, 90, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013184'), '63013186', 'Epidemiologia em Saúde', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013184'), '63013187', 'Formação Humana II', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013188'), '63013188', 'Semiologia I', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013189'), '63013189', 'Metodologia Científica', 2, 15, 0, 15, 0, 0, 30, 0),

-- TERCEIRO PERÍODO
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013190'), '63013191', 'Microbiologia Médica', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013190'), '63013192', 'Parasitologia Médica', 3, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013190'), '63013193', 'Imunologia Médica', 3, 30, 15, 0, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013194'), '63013195', 'Integração Universidade, Serviço e Comunidade III', 6, 15, 0, 0, 75, 0, 90, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013194'), '63013196', 'Tecnologia em Saúde', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013194'), '63013197', 'Atenção Primária à Saúde', 3, 15, 15, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013198'), '63013199', 'Formação Humana III', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013198'), '63013200', 'Farmacologia', 3, 30, 0, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013198'), '63013201', 'Patologia Geral', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013198'), '63013202', 'Semiologia II', 5, 30, 30, 15, 0, 0, 75, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013203'), '63013203', 'Pesquisa e Iniciação Científica', 2, 15, 0, 15, 0, 0, 30, 0),

-- QUARTO PERÍODO
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013204'), '63013206', 'Medicina de Família e Comunidade I', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013204'), '63013207', 'Diagnóstico por Imagem', 4, 45, 0, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013204'), '63013208', 'Procedimentos e Prática Interprofissional', 2, 15, 15, 0, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013209'), '63013210', 'Saúde e Meio Ambiente', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013209'), '63013211', 'Saúde em Comunidades Especiais', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013209'), '63013212', 'Medicina Alternativa e Complementar', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013213'), '63013214', 'Integração Universidade, Serviço e Comunidade IV', 6, 15, 0, 0, 75, 0, 90, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013213'), '63013215', 'Formação Humana IV', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013216'), '63013217', 'Farmacologia II', 3, 30, 0, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013216'), '63013218', 'Patologia Médica', 4, 45, 0, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013216'), '63013219', 'Semiologia III', 5, 30, 30, 15, 0, 0, 75, 0),

-- QUINTO PERÍODO
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013220'), '63013221', 'Saúde da Mulher I', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013220'), '63013222', 'Saúde da Criança I', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013223'), '63013224', 'Saúde Mental I', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013223'), '63013225', 'Endocrinologia', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013223'), '63013226', 'Nefrologia', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013223'), '63013227', 'Cardiologia I', 4, 15, 30, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013223'), '63013228', 'Pneumologia', 3, 15, 15, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013223'), '63013229', 'Hematologia', 3, 15, 15, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013223'), '63013230', 'Técnica Cirúrgica', 3, 30, 15, 0, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013231'), '63013231', 'Integração Universidade, Serviço e Comunidade V', 6, 15, 0, 0, 75, 0, 90, 0),

-- SEXTO PERÍODO
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013232'), '63013233', 'Saúde da Mulher II', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013232'), '63013234', 'Saúde da Criança II', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013235'), '63013236', 'Medicina Legal', 3, 30, 0, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013235'), '63013237', 'Medicina de Família e Comunidade II', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013238'), '63013239', 'Saúde Mental II', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013238'), '63013240', 'Reumatologia', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013238'), '63013241', 'Dermatologia', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013238'), '63013242', 'Gastroenterologia', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013238'), '63013243', 'Cirurgia I', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013244'), '63013244', 'Integração Universidade, Serviço e Comunidade VI', 6, 15, 0, 0, 75, 0, 90, 0),

-- SÉTIMO PERÍODO
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013245'), '63013246', 'Saúde da Mulher III', 3, 15, 15, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013245'), '63013247', 'Saúde da Criança III', 3, 15, 15, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013248'), '63013249', 'Ortopedia e Traumatologia', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013248'), '63013250', 'Urologia', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013248'), '63013251', 'Cirurgia II', 4, 30, 30, 0, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013248'), '63013252', 'Doenças Tropicais e Infecciosas', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013248'), '63013253', 'Urgência e Emergência I', 3, 30, 15, 0, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013248'), '63013254', 'Saúde Mental III', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013255'), '63013255', 'Integração Universidade, Serviço e Comunidade VII', 6, 15, 0, 0, 75, 0, 90, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013256'), '63013256', 'Medicina de Família e Comunidade III', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013257'), '63013257', 'Projeto de Pesquisa', 2, 15, 0, 15, 0, 0, 30, 0),

-- OITAVO PERÍODO
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013258'), '63013258', 'Saúde do Idoso', 4, 30, 0, 15, 15, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013259'), '63013259', 'Oncologia e Cuidados Paliativos', 3, 30, 0, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013260'), '63013260', 'Integração Universidade, Serviço e Comunidade VIII', 6, 15, 0, 0, 75, 0, 90, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013261'), '63013262', 'Anestesiologia', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013261'), '63013263', 'Oftalmologia', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013261'), '63013264', 'Otorrinolaringologia', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013261'), '63013265', 'Cardiologia II', 4, 45, 15, 0, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013261'), '63013266', 'Urgência e Emergência II', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013261'), '63013267', 'Gestão em Saúde', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013261'), '63013268', 'Cirurgia III', 3, 30, 15, 0, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013269'), '63013269', 'Trabalho de Conclusão de Curso - TCC', 2, 15, 0, 15, 0, 0, 30, 0),

-- INTERNATO (ESTÁGIOS)
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013270'), '63013270', 'Estágio Supervisionado I', 44, 90, 0, 0, 0, 570, 660, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013271'), '63013271', 'Estágio Supervisionado II', 44, 90, 0, 0, 0, 570, 660, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013272'), '63013272', 'Estágio Supervisionado III', 43, 90, 0, 0, 0, 555, 645, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013273'), '63013273', 'Estágio Supervisionado IV', 43, 90, 0, 0, 0, 555, 645, 0),

-- DISCIPLINAS OPTATIVAS
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'OPT'), '63013274', 'Bioestatística', 2, 15, 0, 15, 0, 0, 30, 1),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'OPT'), '63013275', 'Biotecnologia', 2, 15, 0, 15, 0, 0, 30, 1),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'OPT'), '63013276', 'Sócio-emocional', 2, 15, 0, 15, 0, 0, 30, 1),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'OPT'), '63013277', 'Inglês Instrumental', 2, 15, 0, 15, 0, 0, 30, 1),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'OPT'), '63013278', 'Libras', 2, 15, 0, 15, 0, 0, 30, 1),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'OPT'), '63013279', 'Inteligência Artificial na Área Médica', 2, 15, 0, 15, 0, 0, 30, 1),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'OPT'), '63013280', 'Nutrologia', 2, 15, 0, 15, 0, 0, 30, 1),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'OPT'), '63013281', 'Empreendedorismo', 2, 15, 0, 15, 0, 0, 30, 1);

-- =========================================
-- 5. RELAÇÕES DE PRÉ-REQUISITOS (Exemplos Mapeados)
-- =========================================
-- O documento faz referência a requisitos lógicos de matérias/módulos passados.
-- Abaixo mapeamos os principais vínculos diretos conforme a lógica da tabela:

INSERT INTO SubjectPrerequisite (TargetSubjectId, RequiredSubjectId) VALUES
-- Fisiologia II (2ºP) exige Fisiologia I (1ºP)
((SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = '63013179'), (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = '63013163')),

-- Anatomia II (2ºP) exige Anatomia I (1ºP)
((SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = '63013177'), (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = '63013162')),

-- Semiologia I (2ºP) exige Anatomia I e Fisiologia I
((SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = '63013188'), (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = '63013162')),
((SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = '63013188'), (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = '63013163')),

-- Farmacologia II (4ºP) exige Farmacologia I (3ºP)
((SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = '63013217'), (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = '63013200')),

-- Estágio II (10ºP) exige Estágio I (9ºP)
((SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = '63013271'), (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = '63013270')),

-- Estágio III (11ºP) exige Estágio II (10ºP)
((SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = '63013272'), (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = '63013271')),

-- Estágio IV (12ºP) exige Estágio III (11ºP)
((SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = '63013273'), (SELECT SubjectId FROM AcademicSubject WHERE SubjectCode = '63013272'));
GO