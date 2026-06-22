-- ============================================================
-- FAM Centro Universitário — Seed de Cursos
-- Banco de Dados - EAD (Matriz 2023.1) + Análise e Desenvolvimento de Sistemas
-- ============================================================
USE SyllabusTrackDb;
GO

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
