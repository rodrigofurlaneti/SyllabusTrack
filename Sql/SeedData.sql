-- ============================================================
-- SyllabusTrack — Seed de Dados Completo
-- Instituições: UnirG + FAM Centro Universitário
-- Gerado: 2026-06-23
-- ============================================================
USE SyllabusTrackDb;
GO

-- ============================================================
-- BLOCO 1: UnirG — Medicina (Matriz Curricular Nº 5)
-- 12 Períodos | Bacharelado
-- ============================================================

INSERT INTO EducationalInstitution (InstitutionName, InstitutionAcronym, CampusLocation)
VALUES ('Fundação UnirG - Universidade de Gurupi', 'UnirG', 'Campus Gurupi');

DECLARE @UnirGId INT = SCOPE_IDENTITY();

INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@UnirGId, 'Medicina', 'Matriz Curricular Nº 5 - Matriz Unificada', 12);

DECLARE @MedUnirGId INT = SCOPE_IDENTITY();

INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@MedUnirGId, 1,  'Primeiro Período'),
(@MedUnirGId, 2,  'Segundo Período'),
(@MedUnirGId, 3,  'Terceiro Período'),
(@MedUnirGId, 4,  'Quarto Período'),
(@MedUnirGId, 5,  'Quinto Período'),
(@MedUnirGId, 6,  'Sexto Período'),
(@MedUnirGId, 7,  'Sétimo Período'),
(@MedUnirGId, 8,  'Oitavo Período'),
(@MedUnirGId, 9,  'Nono Período (Estágio I)'),
(@MedUnirGId, 10, 'Décimo Período (Estágio II)'),
(@MedUnirGId, 11, 'Décimo Primeiro Período (Estágio III)'),
(@MedUnirGId, 12, 'Décimo Segundo Período (Estágio IV)');

DECLARE @T1  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MedUnirGId AND TermNumber = 1);
DECLARE @T2  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MedUnirGId AND TermNumber = 2);
DECLARE @T3  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MedUnirGId AND TermNumber = 3);
DECLARE @T4  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MedUnirGId AND TermNumber = 4);
DECLARE @T5  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MedUnirGId AND TermNumber = 5);
DECLARE @T6  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MedUnirGId AND TermNumber = 6);
DECLARE @T7  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MedUnirGId AND TermNumber = 7);
DECLARE @T8  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MedUnirGId AND TermNumber = 8);
DECLARE @T9  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MedUnirGId AND TermNumber = 9);
DECLARE @T10 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MedUnirGId AND TermNumber = 10);
DECLARE @T11 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MedUnirGId AND TermNumber = 11);
DECLARE @T12 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MedUnirGId AND TermNumber = 12);

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
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013161' AND TermId = @T1), '63013162', 'Anatomia Humana I', 6, 30, 45, 15, 0, 0, 90, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013161' AND TermId = @T1), '63013163', 'Fisiologia Humana I', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013161' AND TermId = @T1), '63013164', 'Histologia Médica', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013165' AND TermId = @T1), '63013166', 'Biologia Celular e Molecular', 3, 30, 0, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013165' AND TermId = @T1), '63013167', 'Embriologia', 3, 30, 0, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013165' AND TermId = @T1), '63013168', 'Bioquímica I', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013169' AND TermId = @T1), '63013170', 'Integração Universidade, Serviço e Comunidade I', 6, 15, 0, 0, 75, 0, 90, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013169' AND TermId = @T1), '63013171', 'Formação Humana I', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013172' AND TermId = @T1), '63013173', 'Rede de Atenção', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013172' AND TermId = @T1), '63013174', 'Primeiros Socorros', 2, 15, 15, 0, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013172' AND TermId = @T1), '63013175', 'Educação em Saúde', 2, 15, 0, 15, 0, 0, 30, 0),

-- SEGUNDO PERÍODO
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013176' AND TermId = @T2), '63013177', 'Anatomia Humana II', 5, 30, 30, 15, 0, 0, 75, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013176' AND TermId = @T2), '63013178', 'Neuroanatomia', 5, 30, 30, 15, 0, 0, 75, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013176' AND TermId = @T2), '63013179', 'Fisiologia Humana II', 4, 45, 0, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013176' AND TermId = @T2), '63013180', 'Histologia Médica II', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013181' AND TermId = @T2), '63013182', 'Genética', 2, 30, 0, 0, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013181' AND TermId = @T2), '63013183', 'Bioquímica II', 3, 30, 15, 0, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013184' AND TermId = @T2), '63013185', 'Integração Universidade, Serviço e Comunidade II', 6, 15, 0, 0, 75, 0, 90, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013184' AND TermId = @T2), '63013186', 'Epidemiologia em Saúde', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013184' AND TermId = @T2), '63013187', 'Formação Humana II', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013188' AND TermId = @T2), '63013188', 'Semiologia I', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013189' AND TermId = @T2), '63013189', 'Metodologia Científica', 2, 15, 0, 15, 0, 0, 30, 0),

-- TERCEIRO PERÍODO
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013190' AND TermId = @T3), '63013191', 'Microbiologia Médica', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013190' AND TermId = @T3), '63013192', 'Parasitologia Médica', 3, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013190' AND TermId = @T3), '63013193', 'Imunologia Médica', 3, 30, 15, 0, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013194' AND TermId = @T3), '63013195', 'Integração Universidade, Serviço e Comunidade III', 6, 15, 0, 0, 75, 0, 90, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013194' AND TermId = @T3), '63013196', 'Tecnologia em Saúde', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013194' AND TermId = @T3), '63013197', 'Atenção Primária à Saúde', 3, 15, 15, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013198' AND TermId = @T3), '63013199', 'Formação Humana III', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013198' AND TermId = @T3), '63013200', 'Farmacologia', 3, 30, 0, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013198' AND TermId = @T3), '63013201', 'Patologia Geral', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013198' AND TermId = @T3), '63013202', 'Semiologia II', 5, 30, 30, 15, 0, 0, 75, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013203' AND TermId = @T3), '63013203', 'Pesquisa e Iniciação Científica', 2, 15, 0, 15, 0, 0, 30, 0),

-- QUARTO PERÍODO
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013204' AND TermId = @T4), '63013206', 'Medicina de Família e Comunidade I', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013204' AND TermId = @T4), '63013207', 'Diagnóstico por Imagem', 4, 45, 0, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013204' AND TermId = @T4), '63013208', 'Procedimentos e Prática Interprofissional', 2, 15, 15, 0, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013209' AND TermId = @T4), '63013210', 'Saúde e Meio Ambiente', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013209' AND TermId = @T4), '63013211', 'Saúde em Comunidades Especiais', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013209' AND TermId = @T4), '63013212', 'Medicina Alternativa e Complementar', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013213' AND TermId = @T4), '63013214', 'Integração Universidade, Serviço e Comunidade IV', 6, 15, 0, 0, 75, 0, 90, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013213' AND TermId = @T4), '63013215', 'Formação Humana IV', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013216' AND TermId = @T4), '63013217', 'Farmacologia II', 3, 30, 0, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013216' AND TermId = @T4), '63013218', 'Patologia Médica', 4, 45, 0, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013216' AND TermId = @T4), '63013219', 'Semiologia III', 5, 30, 30, 15, 0, 0, 75, 0),

-- QUINTO PERÍODO
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013220' AND TermId = @T5), '63013221', 'Saúde da Mulher I', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013220' AND TermId = @T5), '63013222', 'Saúde da Criança I', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013223' AND TermId = @T5), '63013224', 'Saúde Mental I', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013223' AND TermId = @T5), '63013225', 'Endocrinologia', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013223' AND TermId = @T5), '63013226', 'Nefrologia', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013223' AND TermId = @T5), '63013227', 'Cardiologia I', 4, 15, 30, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013223' AND TermId = @T5), '63013228', 'Pneumologia', 3, 15, 15, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013223' AND TermId = @T5), '63013229', 'Hematologia', 3, 15, 15, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013223' AND TermId = @T5), '63013230', 'Técnica Cirúrgica', 3, 30, 15, 0, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013231' AND TermId = @T5), '63013231', 'Integração Universidade, Serviço e Comunidade V', 6, 15, 0, 0, 75, 0, 90, 0),

-- SEXTO PERÍODO
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013232' AND TermId = @T6), '63013233', 'Saúde da Mulher II', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013232' AND TermId = @T6), '63013234', 'Saúde da Criança II', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013235' AND TermId = @T6), '63013236', 'Medicina Legal', 3, 30, 0, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013235' AND TermId = @T6), '63013237', 'Medicina de Família e Comunidade II', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013238' AND TermId = @T6), '63013239', 'Saúde Mental II', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013238' AND TermId = @T6), '63013240', 'Reumatologia', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013238' AND TermId = @T6), '63013241', 'Dermatologia', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013238' AND TermId = @T6), '63013242', 'Gastroenterologia', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013238' AND TermId = @T6), '63013243', 'Cirurgia I', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013244' AND TermId = @T6), '63013244', 'Integração Universidade, Serviço e Comunidade VI', 6, 15, 0, 0, 75, 0, 90, 0),

-- SÉTIMO PERÍODO
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013245' AND TermId = @T7), '63013246', 'Saúde da Mulher III', 3, 15, 15, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013245' AND TermId = @T7), '63013247', 'Saúde da Criança III', 3, 15, 15, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013248' AND TermId = @T7), '63013249', 'Ortopedia e Traumatologia', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013248' AND TermId = @T7), '63013250', 'Urologia', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013248' AND TermId = @T7), '63013251', 'Cirurgia II', 4, 30, 30, 0, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013248' AND TermId = @T7), '63013252', 'Doenças Tropicais e Infecciosas', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013248' AND TermId = @T7), '63013253', 'Urgência e Emergência I', 3, 30, 15, 0, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013248' AND TermId = @T7), '63013254', 'Saúde Mental III', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013255' AND TermId = @T7), '63013255', 'Integração Universidade, Serviço e Comunidade VII', 6, 15, 0, 0, 75, 0, 90, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013256' AND TermId = @T7), '63013256', 'Medicina de Família e Comunidade III', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013257' AND TermId = @T7), '63013257', 'Projeto de Pesquisa', 2, 15, 0, 15, 0, 0, 30, 0),

-- OITAVO PERÍODO
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013258' AND TermId = @T8), '63013258', 'Saúde do Idoso', 4, 30, 0, 15, 15, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013259' AND TermId = @T8), '63013259', 'Oncologia e Cuidados Paliativos', 3, 30, 0, 15, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013260' AND TermId = @T8), '63013260', 'Integração Universidade, Serviço e Comunidade VIII', 6, 15, 0, 0, 75, 0, 90, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013261' AND TermId = @T8), '63013262', 'Anestesiologia', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013261' AND TermId = @T8), '63013263', 'Oftalmologia', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013261' AND TermId = @T8), '63013264', 'Otorrinolaringologia', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013261' AND TermId = @T8), '63013265', 'Cardiologia II', 4, 45, 15, 0, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013261' AND TermId = @T8), '63013266', 'Urgência e Emergência II', 4, 30, 15, 15, 0, 0, 60, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013261' AND TermId = @T8), '63013267', 'Gestão em Saúde', 2, 15, 0, 15, 0, 0, 30, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013261' AND TermId = @T8), '63013268', 'Cirurgia III', 3, 30, 15, 0, 0, 0, 45, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013269' AND TermId = @T8), '63013269', 'Trabalho de Conclusão de Curso - TCC', 2, 15, 0, 15, 0, 0, 30, 0),

-- INTERNATO (ESTÁGIOS)
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013270' AND TermId = @T9), '63013270', 'Estágio Supervisionado I', 44, 90, 0, 0, 0, 570, 660, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013271' AND TermId = @T10), '63013271', 'Estágio Supervisionado II', 44, 90, 0, 0, 0, 570, 660, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013272' AND TermId = @T11), '63013272', 'Estágio Supervisionado III', 43, 90, 0, 0, 0, 555, 645, 0),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = '63013273' AND TermId = @T12), '63013273', 'Estágio Supervisionado IV', 43, 90, 0, 0, 0, 555, 645, 0),

-- DISCIPLINAS OPTATIVAS
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'OPT' AND TermId = @T1), '63013274', 'Bioestatística', 2, 15, 0, 15, 0, 0, 30, 1),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'OPT' AND TermId = @T1), '63013275', 'Biotecnologia', 2, 15, 0, 15, 0, 0, 30, 1),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'OPT' AND TermId = @T1), '63013276', 'Sócio-emocional', 2, 15, 0, 15, 0, 0, 30, 1),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'OPT' AND TermId = @T1), '63013277', 'Inglês Instrumental', 2, 15, 0, 15, 0, 0, 30, 1),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'OPT' AND TermId = @T1), '63013278', 'Libras', 2, 15, 0, 15, 0, 0, 30, 1),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'OPT' AND TermId = @T1), '63013279', 'Inteligência Artificial na Área Médica', 2, 15, 0, 15, 0, 0, 30, 1),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'OPT' AND TermId = @T1), '63013280', 'Nutrologia', 2, 15, 0, 15, 0, 0, 30, 1),
((SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'OPT' AND TermId = @T1), '63013281', 'Empreendedorismo', 2, 15, 0, 15, 0, 0, 30, 1);

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

-- ============================================================
-- BLOCO 2: FAM Centro Universitário — Cursos
-- ============================================================

-- ---- Seed_FAM_Courses.sql ----
-- ============================================================
-- FAM Centro Universitário — Seed de Cursos
-- Banco de Dados - EAD (Matriz 2023.1) + Análise e Desenvolvimento de Sistemas
-- ============================================================

-- ============================================================
-- 1. INSTITUIÇÃO
-- ============================================================
INSERT INTO EducationalInstitution (InstitutionName, InstitutionAcronym, CampusLocation)
VALUES ('FAM Centro Universitário', 'FAM', 'São Paulo - SP');

DECLARE @FamId INT = SCOPE_IDENTITY();


-- ============================================================
-- 2. CURSO: Banco de Dados - EAD
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Banco de Dados', 'Matriz 2023.1 - EAD', 5);

DECLARE @BDId INT = SCOPE_IDENTITY();

-- Semestres
INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@BDId, 1, '1º Semestre'),
(@BDId, 2, '2º Semestre'),
(@BDId, 3, '3º Semestre'),
(@BDId, 4, '4º Semestre'),
(@BDId, 5, '5º Semestre');

DECLARE @BD_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @BDId AND TermNumber = 1);
DECLARE @BD_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @BDId AND TermNumber = 2);
DECLARE @BD_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @BDId AND TermNumber = 3);
DECLARE @BD_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @BDId AND TermNumber = 4);
DECLARE @BD_T5 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @BDId AND TermNumber = 5);

-- Módulos (1 por semestre)
INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@BD_T1, 'BD-1A', 'MÓDULO/CICLO 1A', 400),
(@BD_T2, 'BD-1B', 'MÓDULO/CICLO 1B', 400),
(@BD_T3, 'BD-2A', 'MÓDULO/CICLO 2A', 400),
(@BD_T4, 'BD-2B', 'MÓDULO/CICLO 2B', 400),
(@BD_T5, 'BD-3A', 'MÓDULO/CICLO 3A', 320);

DECLARE @BD_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'BD-1A');
DECLARE @BD_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'BD-1B');
DECLARE @BD_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'BD-2A');
DECLARE @BD_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'BD-2B');
DECLARE @BD_M5 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'BD-3A');

-- Disciplinas — Banco de Dados EAD
INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre (Módulo 1A)
(@BD_M1, 'BD-101', 'Comunicação e Linguagem',                         4, 80, 0),
(@BD_M1, 'BD-102', 'Paradigmas de Linguagens de Programação',         4, 80, 0),
(@BD_M1, 'BD-103', 'Algoritmos e Lógica de Programação',              4, 80, 0),
(@BD_M1, 'BD-104', 'Fundamentos Matemáticos da Computação',           4, 80, 0),
(@BD_M1, 'BD-105', 'Sistemas Computacionais',                          4, 80, 0),
-- 2º Semestre (Módulo 1B)
(@BD_M2, 'BD-201', 'Metodologia da Pesquisa Científica e Tecnológica',4, 80, 0),
(@BD_M2, 'BD-202', 'Estrutura e Modelagem de Dados',                   4, 80, 0),
(@BD_M2, 'BD-203', 'Banco de Dados',                                    4, 80, 0),
(@BD_M2, 'BD-204', 'Sistemas Operacionais',                             4, 80, 0),
(@BD_M2, 'BD-205', 'Redes de Computadores',                             4, 80, 0),
-- 3º Semestre (Módulo 2A)
(@BD_M3, 'BD-301', 'Antropologia: Identidade e Diversidade',           4, 80, 0),
(@BD_M3, 'BD-302', 'Análise e Projeto de Sistemas',                    4, 80, 0),
(@BD_M3, 'BD-303', 'Engenharia de Software',                            4, 80, 0),
(@BD_M3, 'BD-304', 'Big Data e Data Science',                           4, 80, 0),
(@BD_M3, 'BD-305', 'Inovação e Novas Tecnologias',                     4, 80, 0),
-- 4º Semestre (Módulo 2B)
(@BD_M4, 'BD-401', 'Meio Ambiente, Sociedade e Cidadania',             4, 80, 0),
(@BD_M4, 'BD-402', 'Sistemas Distribuídos e SOA',                      4, 80, 0),
(@BD_M4, 'BD-403', 'Programação Back-End',                             4, 80, 0),
(@BD_M4, 'BD-404', 'Programação em Banco de Dados',                    4, 80, 0),
(@BD_M4, 'BD-405', 'Administração de Banco de Dados',                  4, 80, 0),
-- 5º Semestre (Módulo 3A)
(@BD_M5, 'BD-501', 'Eletiva I',                                         4, 80, 1),
(@BD_M5, 'BD-502', 'Mineração de Dados',                                4, 80, 0),
(@BD_M5, 'BD-503', 'Otimização e Desempenho de Banco de Dados',        4, 80, 0),
(@BD_M5, 'BD-504', 'Banco de Dados em Ambientes de Alta Escalabilidade',4, 80, 0);


-- ============================================================
-- 3. CURSO: Análise e Desenvolvimento de Sistemas
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Análise e Desenvolvimento de Sistemas', 'Matriz 2023.1', 5);

DECLARE @AdsId INT = SCOPE_IDENTITY();

-- Semestres
INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@AdsId, 1, '1º Semestre'),
(@AdsId, 2, '2º Semestre'),
(@AdsId, 3, '3º Semestre'),
(@AdsId, 4, '4º Semestre'),
(@AdsId, 5, '5º Semestre');

DECLARE @ADS_T1 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @AdsId AND TermNumber = 1);
DECLARE @ADS_T2 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @AdsId AND TermNumber = 2);
DECLARE @ADS_T3 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @AdsId AND TermNumber = 3);
DECLARE @ADS_T4 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @AdsId AND TermNumber = 4);
DECLARE @ADS_T5 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @AdsId AND TermNumber = 5);

-- Módulos
INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@ADS_T1, 'ADS-1A', 'MÓDULO/CICLO 1A', 400),
(@ADS_T2, 'ADS-1B', 'MÓDULO/CICLO 1B', 400),
(@ADS_T3, 'ADS-2A', 'MÓDULO/CICLO 2A', 400),
(@ADS_T4, 'ADS-2B', 'MÓDULO/CICLO 2B', 400),
(@ADS_T5, 'ADS-3A', 'MÓDULO/CICLO 3A', 320);

DECLARE @ADS_M1 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ADS-1A');
DECLARE @ADS_M2 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ADS-1B');
DECLARE @ADS_M3 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ADS-2A');
DECLARE @ADS_M4 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ADS-2B');
DECLARE @ADS_M5 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'ADS-3A');

-- Disciplinas — ADS
-- Obs: Projetos Interdisciplinares = 0h (atividade integradora, sem CH própria)
INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES
-- 1º Semestre (Módulo 1A)
(@ADS_M1, 'ADS-101', 'Comunicação e Linguagem',                        4,  80, 0),
(@ADS_M1, 'ADS-102', 'Paradigmas de Linguagens de Programação',        4,  80, 0),
(@ADS_M1, 'ADS-103', 'Algoritmos e Lógica de Programação',             4,  80, 0),
(@ADS_M1, 'ADS-104', 'Fundamentos Matemáticos da Computação',          4,  80, 0),
(@ADS_M1, 'ADS-105', 'Sistemas Computacionais',                         4,  80, 0),
(@ADS_M1, 'ADS-106', 'Projeto Interdisciplinar 1A',                     0,   0, 0),
-- 2º Semestre (Módulo 1B)
(@ADS_M2, 'ADS-201', 'Metodologia da Pesquisa Científica e Tecnológica',4, 80, 0),
(@ADS_M2, 'ADS-202', 'Sistemas Operacionais',                           4,  80, 0),
(@ADS_M2, 'ADS-203', 'Banco de Dados',                                   4,  80, 0),
(@ADS_M2, 'ADS-204', 'Estrutura e Modelagem de Dados',                  4,  80, 0),
(@ADS_M2, 'ADS-205', 'Redes de Computadores',                           4,  80, 0),
(@ADS_M2, 'ADS-206', 'Projeto Interdisciplinar 1B',                     0,   0, 0),
-- 3º Semestre (Módulo 2A)
(@ADS_M3, 'ADS-301', 'Antropologia: Identidade e Diversidade',          4,  80, 0),
(@ADS_M3, 'ADS-302', 'Engenharia de Software',                           4,  80, 0),
(@ADS_M3, 'ADS-303', 'Programação Orientada a Objetos',                 4,  80, 0),
(@ADS_M3, 'ADS-304', 'Análise e Projeto de Sistemas',                   4,  80, 0),
(@ADS_M3, 'ADS-305', 'Internet das Coisas (IOT) e Novas Tecnologias',  4,  80, 0),
(@ADS_M3, 'ADS-306', 'Projeto Interdisciplinar 2A',                     0,   0, 0),
-- 4º Semestre (Módulo 2B)
(@ADS_M4, 'ADS-401', 'Meio Ambiente, Sociedade e Cidadania',            4,  80, 0),
(@ADS_M4, 'ADS-402', 'Eletiva I',                                        4,  80, 1),
(@ADS_M4, 'ADS-403', 'Gerenciamento e Gestão de Projetos',              4,  80, 0),
(@ADS_M4, 'ADS-404', 'Aplicações para Banco de Dados e Data Science',  4,  80, 0),
(@ADS_M4, 'ADS-405', 'Qualidade de Software',                           4,  80, 0),
(@ADS_M4, 'ADS-406', 'Projeto Interdisciplinar 2B',                     0,   0, 0),
-- 5º Semestre (Módulo 3A)
(@ADS_M5, 'ADS-501', 'Eletiva II',                                       4,  80, 1),
(@ADS_M5, 'ADS-502', 'Desenvolvimento Mobile',                           4,  80, 0),
(@ADS_M5, 'ADS-503', 'Programação Back-End',                            4,  80, 0),
(@ADS_M5, 'ADS-504', 'Interfaces Digitais: Front-End',                  4,  80, 0),
(@ADS_M5, 'ADS-505', 'Projeto Interdisciplinar 3A',                     0,   0, 0);


-- ============================================================
-- 4. VERIFICAÇÃO
-- ============================================================
SELECT
    i.InstitutionName,
    p.ProgramName,
    p.CurriculumVersion,
    COUNT(DISTINCT t.TermId)   AS Semestres,
    COUNT(DISTINCT m.ModuleId) AS Modulos,
    COUNT(s.SubjectId)         AS Disciplinas,
    SUM(s.TotalSubjectHours)   AS CargaHorariaTotal
FROM EducationalInstitution i
JOIN DegreeProgram   p ON p.InstitutionId = i.InstitutionId
JOIN AcademicTerm    t ON t.ProgramId     = p.ProgramId
JOIN CourseModule    m ON m.TermId        = t.TermId
JOIN AcademicSubject s ON s.ModuleId      = m.ModuleId
WHERE i.InstitutionAcronym = 'FAM'
GROUP BY i.InstitutionName, p.ProgramName, p.CurriculumVersion
ORDER BY p.ProgramName;

GO

-- ---- Seed_FAM_Courses_Batch2.sql ----
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

GO

-- ---- Seed_FAM_IAML.sql ----
-- ============================================================
-- FAM Centro Universitário — Seed de Curso
-- Inteligência Artificial e Machine Learning
-- Superior em Tecnologia | 5 Semestres | 2025h
-- ============================================================

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

GO

-- ---- Seed_FAM_Medicina.sql ----
-- ============================================================
-- FAM Centro Universitário — Seed de Curso
-- Medicina — Bacharelado | 12 Semestres | 7860h
-- Matriz: 2025.2 V2
-- ============================================================
-- NOTA: A instituição FAM já deve existir no banco.
-- Este script referencia o InstitutionId existente.
-- SubjectCredits: horas / 20 (arredondado)
-- ============================================================

DECLARE @FamId INT = (SELECT InstitutionId FROM EducationalInstitution WHERE InstitutionAcronym = 'FAM');

-- ============================================================
-- 1. CURSO
-- ============================================================
INSERT INTO DegreeProgram (InstitutionId, ProgramName, CurriculumVersion, TotalSemesters)
VALUES (@FamId, 'Medicina', 'Matriz 2025.2', 12);

DECLARE @MEDId INT = SCOPE_IDENTITY();

-- ============================================================
-- 2. SEMESTRES
-- ============================================================
INSERT INTO AcademicTerm (ProgramId, TermNumber, TermDescription) VALUES
(@MEDId,  1, '1º Semestre'),
(@MEDId,  2, '2º Semestre'),
(@MEDId,  3, '3º Semestre'),
(@MEDId,  4, '4º Semestre'),
(@MEDId,  5, '5º Semestre'),
(@MEDId,  6, '6º Semestre'),
(@MEDId,  7, '7º Semestre'),
(@MEDId,  8, '8º Semestre'),
(@MEDId,  9, '9º Semestre'),
(@MEDId, 10, '10º Semestre'),
(@MEDId, 11, '11º Semestre'),
(@MEDId, 12, '12º Semestre');

DECLARE @MED_T1  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MEDId AND TermNumber = 1);
DECLARE @MED_T2  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MEDId AND TermNumber = 2);
DECLARE @MED_T3  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MEDId AND TermNumber = 3);
DECLARE @MED_T4  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MEDId AND TermNumber = 4);
DECLARE @MED_T5  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MEDId AND TermNumber = 5);
DECLARE @MED_T6  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MEDId AND TermNumber = 6);
DECLARE @MED_T7  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MEDId AND TermNumber = 7);
DECLARE @MED_T8  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MEDId AND TermNumber = 8);
DECLARE @MED_T9  INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MEDId AND TermNumber = 9);
DECLARE @MED_T10 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MEDId AND TermNumber = 10);
DECLARE @MED_T11 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MEDId AND TermNumber = 11);
DECLARE @MED_T12 INT = (SELECT TermId FROM AcademicTerm WHERE ProgramId = @MEDId AND TermNumber = 12);

-- ============================================================
-- 3. MÓDULOS
-- TotalModuleCredits = soma das horas das disciplinas do módulo
-- Módulos 1A–4B: eixos verticais (90+105+105) + HP + PIESC
-- Módulos 5A–6B: Internato (estágios supervisionados)
-- ============================================================
INSERT INTO CourseModule (TermId, ModuleCode, ModuleName, TotalModuleCredits) VALUES
(@MED_T1,  'MED-1A',  'Integralidade da saúde e seus princípios biológicos',                                          515),  -- 90+105+105+100+115
(@MED_T2,  'MED-1B',  'Homeostase e mecanismos de agressão e defesa',                                                  515),  -- 90+105+105+100+115
(@MED_T3,  'MED-2A',  'Desenvolvimento, interação e amadurecimento do ser humano',                                     515),  -- 90+105+105+100+115
(@MED_T4,  'MED-2B',  'Proliferação, ambiente e saúde reprodutiva',                                                    515),  -- 90+105+105+100+115
(@MED_T5,  'MED-3A',  'Distúrbios abdominais, infecciosos e inflamatórios',                                            615),  -- 90+105+105+200+115
(@MED_T6,  'MED-3B',  'Saúde mental, distúrbios hemodinâmicos e a consumpção',                                        615),  -- 90+105+105+200+115
(@MED_T7,  'MED-4A',  'Manifestações da interação do homem com o ambiente',                                            615),  -- 90+105+105+200+115
(@MED_T8,  'MED-4B',  'Criticidades dos processos de saúde-doença',                                                    615),  -- 90+105+105+200+115
(@MED_T9,  'MED-5A',  'Estágio Supervisionado do Internato Médico - Cuidados da criança, saúde da mulher e clínica médica',  720),  -- 4 x 180
(@MED_T10, 'MED-5B',  'Estágio Supervisionado do Internato Médico - Gestação, parto, clínica cirúrgica e atenção básica',   720),  -- 4 x 180
(@MED_T11, 'MED-6A',  'Estágio Supervisionado do Internato Médico - Saúde mental, urgência e emergência',               720),  -- 4 x 180
(@MED_T12, 'MED-6B',  'Estágio Supervisionado do Internato Médico - Saúde do adulto, outros cuidados e gestão',         820);  -- 4 x 180 + TCC 100

DECLARE @MED_M1  INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MED-1A');
DECLARE @MED_M2  INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MED-1B');
DECLARE @MED_M3  INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MED-2A');
DECLARE @MED_M4  INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MED-2B');
DECLARE @MED_M5  INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MED-3A');
DECLARE @MED_M6  INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MED-3B');
DECLARE @MED_M7  INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MED-4A');
DECLARE @MED_M8  INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MED-4B');
DECLARE @MED_M9  INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MED-5A');
DECLARE @MED_M10 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MED-5B');
DECLARE @MED_M11 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MED-6A');
DECLARE @MED_M12 INT = (SELECT ModuleId FROM CourseModule WHERE ModuleCode = 'MED-6B');

-- ============================================================
-- 4. DISCIPLINAS
-- Estrutura de cada semestre (1º ao 8º):
--   3 eixos verticais temáticos  (90h / 105h / 105h)
--   1 Habilidades Profissionais  (100h nos sem. 1-4 | 200h nos sem. 5-8)
--   1 Programa Interdisciplinar e Extensionista (115h)
-- Internato (9º ao 12º): disciplinas de 180h cada; TCC no 12º (100h)
-- SubjectCredits = horas/20 arredondado (90→5, 100→5, 105→5, 115→6, 180→9, 200→10, 100h TCC→5)
-- ============================================================
INSERT INTO AcademicSubject (ModuleId, SubjectCode, SubjectName, SubjectCredits, TotalSubjectHours, IsOptional) VALUES

-- 1º SEMESTRE — Integralidade da saúde e seus princípios biológicos
(@MED_M1, 'MED-101', 'Introdução à Medicina',                                                                                              5,  90, 0),
(@MED_M1, 'MED-102', 'Concepção e Origem da Vida',                                                                                         5, 105, 0),
(@MED_M1, 'MED-103', 'Processos Metabólicos',                                                                                              5, 105, 0),
(@MED_M1, 'MED-104', 'Fundamentos das Habilidades Profissionais Médicas',                                                                   5, 100, 0),
(@MED_M1, 'MED-105', 'PIESC - Políticas, Diretrizes do SUS e Saúde da Família',                                                            6, 115, 0),

-- 2º SEMESTRE — Homeostase e mecanismos de agressão e defesa
(@MED_M2, 'MED-201', 'Vida Celular',                                                                                                        5,  90, 0),
(@MED_M2, 'MED-202', 'Funções Orgânicas e a Homeostase',                                                                                   5, 105, 0),
(@MED_M2, 'MED-203', 'Agressão e Defesa',                                                                                                   5, 105, 0),
(@MED_M2, 'MED-204', 'Habilidades Profissionais Médicas Aplicadas',                                                                         5, 100, 0),
(@MED_M2, 'MED-205', 'PIESC - Processos de Trabalho em Saúde e Indicadores de Saúde',                                                      6, 115, 0),

-- 3º SEMESTRE — Desenvolvimento, interação e amadurecimento do ser humano
(@MED_M3, 'MED-301', 'Nascimento, Crescimento e Desenvolvimento',                                                                          5,  90, 0),
(@MED_M3, 'MED-302', 'Percepção, Consciência e Emoção',                                                                                    5, 105, 0),
(@MED_M3, 'MED-303', 'Processo de Envelhecimento',                                                                                         5, 105, 0),
(@MED_M3, 'MED-304', 'Habilidades Profissionais – Saúde da Criança, do Idoso e o Atendimento Pré Hospitalar',                              5, 100, 0),
(@MED_M3, 'MED-305', 'PIESC - Saúde da Criança e do Idoso',                                                                               6, 115, 0),

-- 4º SEMESTRE — Proliferação, ambiente e saúde reprodutiva
(@MED_M4, 'MED-401', 'Proliferação Celular',                                                                                               5,  90, 0),
(@MED_M4, 'MED-402', 'Saúde da Mulher, Sexualidade e Planejamento Familiar',                                                               5, 105, 0),
(@MED_M4, 'MED-403', 'Doenças Resultantes da Agressão ao Meio Ambiente',                                                                   5, 105, 0),
(@MED_M4, 'MED-404', 'Habilidades Profissionais – Saúde Reprodutiva, o Ambiente e os Fundamentos Aplicados à Urgência e Emergência',       5, 100, 0),
(@MED_M4, 'MED-405', 'PIESC - Saúde da Mulher',                                                                                           6, 115, 0),

-- 5º SEMESTRE — Distúrbios abdominais, infecciosos e inflamatórios
(@MED_M5, 'MED-501', 'Dor',                                                                                                                 5,  90, 0),
(@MED_M5, 'MED-502', 'Dor Abdominal, Diarréia, Vômitos e Icterícia',                                                                      5, 105, 0),
(@MED_M5, 'MED-503', 'Febre, Inflamação e Infecção',                                                                                       5, 105, 0),
(@MED_M5, 'MED-504', 'Habilidades Profissionais – Avaliação Motora e Neurológica, Raciocínio Clínico e Fundamentos Aplicados à U&E',      10, 200, 0),
(@MED_M5, 'MED-505', 'PIESC - Vigilância em Saúde',                                                                                       6, 115, 0),

-- 6º SEMESTRE — Saúde mental, distúrbios hemodinâmicos e a consumpção
(@MED_M6, 'MED-601', 'Problemas Mentais e do Comportamento',                                                                               5,  90, 0),
(@MED_M6, 'MED-602', 'Perda de Sangue',                                                                                                    5, 105, 0),
(@MED_M6, 'MED-603', 'Fadiga, Perda de Peso e Anemias',                                                                                   5, 105, 0),
(@MED_M6, 'MED-604', 'Habilidades Profissionais – Saúde Mental, Raciocínio Clínico e Procedimentos Aplicados às U&E',                    10, 200, 0),
(@MED_M6, 'MED-605', 'PIESC - Saúde Mental',                                                                                              6, 115, 0),

-- 7º SEMESTRE — Manifestações da interação do homem com o ambiente
(@MED_M7, 'MED-701', 'Locomoção e Preensão',                                                                                               5,  90, 0),
(@MED_M7, 'MED-702', 'Distúrbios Sensoriais, Motores e da Consciência',                                                                    5, 105, 0),
(@MED_M7, 'MED-703', 'Dispnéia, Dor Torácica e Edema',                                                                                    5, 105, 0),
(@MED_M7, 'MED-704', 'Habilidades Profissionais – As Habilidades Cirúrgicas e o Raciocínio Clínico',                                      10, 200, 0),
(@MED_M7, 'MED-705', 'PIESC - Assistência Domiciliar',                                                                                    6, 115, 0),

-- 8º SEMESTRE — Criticidades dos processos de saúde-doença
(@MED_M8, 'MED-801', 'Desordens Nutricionais e Metabólicas',                                                                               5,  90, 0),
(@MED_M8, 'MED-802', 'Manifestações Externas das Doenças e Iatrogenias',                                                                   5, 105, 0),
(@MED_M8, 'MED-803', 'Emergências',                                                                                                        5, 105, 0),
(@MED_M8, 'MED-804', 'Habilidades Profissionais - O Raciocínio Clínico e os Cenários de Urgências e Emergências',                         10, 200, 0),
(@MED_M8, 'MED-805', 'PIESC - Urgência e Emergência',                                                                                     6, 115, 0),

-- 9º SEMESTRE — Estágio Supervisionado do Internato Médico
(@MED_M9, 'MED-901', 'Cuidados na Atenção Básica - Cuidado Integral',                                                                      9, 180, 0),
(@MED_M9, 'MED-902', 'Cuidados em Saúde da Criança - Pediatria Geral',                                                                    9, 180, 0),
(@MED_M9, 'MED-903', 'Cuidados em Saúde do Adulto - Clínica Médica',                                                                      9, 180, 0),
(@MED_M9, 'MED-904', 'Cuidados em Saúde da Mulher – Ginecologia',                                                                         9, 180, 0),

-- 10º SEMESTRE — Estágio Supervisionado do Internato Médico
(@MED_M10, 'MED-1001', 'Cuidados na Atenção Básica - Práticas Integrativas',                                                               9, 180, 0),
(@MED_M10, 'MED-1002', 'Cuidados em Saúde da Criança – Neonatologia',                                                                     9, 180, 0),
(@MED_M10, 'MED-1003', 'Cuidados em Saúde do Adulto - Clínica Cirúrgica',                                                                 9, 180, 0),
(@MED_M10, 'MED-1004', 'Cuidados em Saúde da Mulher – Obstetrícia',                                                                       9, 180, 0),

-- 11º SEMESTRE — Estágio Supervisionado do Internato Médico
(@MED_M11, 'MED-1101', 'Cuidados na Atenção Básica - Manejo de Situações Críticas',                                                        9, 180, 0),
(@MED_M11, 'MED-1102', 'Cuidados em Saúde Mental e do Idoso',                                                                             9, 180, 0),
(@MED_M11, 'MED-1103', 'Urgências e Emergências - Adulto - Pronto Socorro, UTI, SAMU',                                                    9, 180, 0),
(@MED_M11, 'MED-1104', 'Urgências e Emergências – Criança - Pronto Socorro, UTI Pediátrica',                                              9, 180, 0),

-- 12º SEMESTRE — Estágio Supervisionado do Internato Médico
(@MED_M12, 'MED-1201', 'Saúde Coletiva, Planejamento e Gestão na Atenção Básica',                                                          9, 180, 0),
(@MED_M12, 'MED-1202', 'Cuidados em Saúde do Adulto – Anestesia, Ortopedia, Infectologia',                                                9, 180, 0),
(@MED_M12, 'MED-1203', 'Outros Cuidados em Medicina – Oncologia / Cuidados Paliativos / UTI',                                             9, 180, 0),
(@MED_M12, 'MED-1204', 'Optativo',                                                                                                         9, 180, 1),
(@MED_M12, 'MED-1205', 'TCC e Orientação',                                                                                                 5, 100, 0);

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
WHERE p.ProgramName = 'Medicina' AND i.InstitutionAcronym = 'FAM'
GROUP BY i.InstitutionName, p.ProgramName, p.CurriculumVersion;

GO

-- ---- Seed_FAM_Enfermagem.sql ----
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

GO

-- ---- Seed_FAM_Biomedicina.sql ----
-- ============================================================
-- FAM Centro Universitário — Seed de Curso
-- Biomedicina — Bacharelado | 8 Semestres | 3241h
-- ============================================================
-- NOTA: A instituição FAM já deve existir no banco.
-- SubjectCredits: 80h = 4 | 325h (estágio) = 16 | 40h (TCC) = 2 | 0h = 0
-- Projetos Interdisciplinares: 0h, 0 créditos (atividade integradora)
-- Eletiva I: IsOptional = 1
-- ============================================================

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

-- ============================================================
GO

-- FAM Centro Universitário — Seed de Cursos EAD
-- 17 Cursos | Matriz 2023.1
-- ============================================================

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

GO
