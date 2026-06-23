-- ============================================================
-- FAM Centro Universitário — Seed de Curso
-- Medicina — Bacharelado | 12 Semestres | 7860h
-- Matriz: 2025.2 V2
-- ============================================================
-- NOTA: A instituição FAM já deve existir no banco.
-- Este script referencia o InstitutionId existente.
-- SubjectCredits: horas / 20 (arredondado)
-- ============================================================
USE SyllabusTrackDb;
GO

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
