-- =========================================
-- 0. CRIAÇÃO DO BANCO DE DADOS
-- =========================================
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'SyllabusTrackDb')
BEGIN
    CREATE DATABASE SyllabusTrackDb;
END
GO

USE SyllabusTrackDb;
GO

-- =========================================
-- 1. LIMPEZA (DROP) - Ordem Reversa
-- =========================================
-- Apaga as Procedures se existirem
DROP PROCEDURE IF EXISTS usp_ManageStudentProgress;
DROP PROCEDURE IF EXISTS usp_AuthenticateStudent;
DROP PROCEDURE IF EXISTS usp_ManageStudentAccount;
DROP PROCEDURE IF EXISTS usp_ManageEducationalInstitution;
GO

-- Apaga as Tabelas se existirem (A ordem importa devido às Foreign Keys)
DROP TABLE IF EXISTS StudentProgress;
DROP TABLE IF EXISTS StudentEnrollment;
DROP TABLE IF EXISTS StudentAccount;
DROP TABLE IF EXISTS SubjectPrerequisite;
DROP TABLE IF EXISTS AcademicSubject;
DROP TABLE IF EXISTS CourseModule;
DROP TABLE IF EXISTS AcademicTerm;
DROP TABLE IF EXISTS DegreeProgram;
DROP TABLE IF EXISTS EducationalInstitution;
GO

-- =========================================
-- 2. CRIAÇÃO DAS TABELAS
-- =========================================

CREATE TABLE EducationalInstitution (
    InstitutionId INT IDENTITY(1,1) PRIMARY KEY,
    InstitutionName VARCHAR(255) NOT NULL,
    InstitutionAcronym VARCHAR(50),
    CampusLocation VARCHAR(255),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE DegreeProgram (
    ProgramId INT IDENTITY(1,1) PRIMARY KEY,
    InstitutionId INT NOT NULL,
    ProgramName VARCHAR(255) NOT NULL,
    CurriculumVersion VARCHAR(100) NOT NULL,
    TotalSemesters INT NOT NULL,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (InstitutionId) REFERENCES EducationalInstitution(InstitutionId)
);
GO

CREATE TABLE AcademicTerm (
    TermId INT IDENTITY(1,1) PRIMARY KEY,
    ProgramId INT NOT NULL,
    TermNumber INT NOT NULL,
    TermDescription VARCHAR(100),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ProgramId) REFERENCES DegreeProgram(ProgramId)
);
GO

CREATE TABLE CourseModule (
    ModuleId INT IDENTITY(1,1) PRIMARY KEY,
    TermId INT NOT NULL,
    ModuleCode VARCHAR(50),
    ModuleName VARCHAR(255) NOT NULL,
    TotalModuleCredits INT,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (TermId) REFERENCES AcademicTerm(TermId)
);
GO

CREATE TABLE AcademicSubject (
    SubjectId INT IDENTITY(1,1) PRIMARY KEY,
    ModuleId INT NOT NULL,
    SubjectCode VARCHAR(50) NOT NULL,
    SubjectName VARCHAR(255) NOT NULL,
    SubjectCredits INT,
    TheoreticalHours INT DEFAULT 0,
    PracticalHours INT DEFAULT 0,
    StudyGroupHours INT DEFAULT 0,
    ExtensionHours INT DEFAULT 0,
    InternshipHours INT DEFAULT 0,
    TotalSubjectHours INT NOT NULL,
    IsOptional BIT DEFAULT 0,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ModuleId) REFERENCES CourseModule(ModuleId)
);
GO

CREATE TABLE SubjectPrerequisite (
    PrerequisiteId INT IDENTITY(1,1) PRIMARY KEY,
    TargetSubjectId INT NOT NULL,
    RequiredSubjectId INT NOT NULL,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (TargetSubjectId) REFERENCES AcademicSubject(SubjectId),
    FOREIGN KEY (RequiredSubjectId) REFERENCES AcademicSubject(SubjectId)
);
GO

CREATE TABLE StudentAccount (
    StudentId INT IDENTITY(1,1) PRIMARY KEY,
    StudentFullName VARCHAR(255) NOT NULL,
    LoginUsername VARCHAR(50) UNIQUE NOT NULL,
    EmailAddress VARCHAR(255) UNIQUE NOT NULL,
    CellPhoneNumber VARCHAR(20) NOT NULL,
    AccountPassword VARCHAR(255) NOT NULL,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE StudentEnrollment (
    EnrollmentId INT IDENTITY(1,1) PRIMARY KEY,
    StudentId INT NOT NULL,
    ProgramId INT NOT NULL,
    EnrollmentDate DATE NOT NULL,
    EnrollmentStatus VARCHAR(50) NOT NULL,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (StudentId) REFERENCES StudentAccount(StudentId),
    FOREIGN KEY (ProgramId) REFERENCES DegreeProgram(ProgramId)
);
GO

CREATE TABLE StudentProgress (
    ProgressId INT IDENTITY(1,1) PRIMARY KEY,
    EnrollmentId INT NOT NULL,
    SubjectId INT NOT NULL,
    CompletionStatus VARCHAR(50) NOT NULL,
    SemesterTaken VARCHAR(20),
    FinalGrade DECIMAL(5,2),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (EnrollmentId) REFERENCES StudentEnrollment(EnrollmentId),
    FOREIGN KEY (SubjectId) REFERENCES AcademicSubject(SubjectId)
);
GO

-- =========================================
-- 3. CRIAÇÃO DAS STORED PROCEDURES
-- =========================================

CREATE PROCEDURE usp_ManageEducationalInstitution
    @Action CHAR(1), 
    @InstitutionId INT = NULL,
    @InstitutionName VARCHAR(255) = NULL,
    @InstitutionAcronym VARCHAR(50) = NULL,
    @CampusLocation VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Action = 'I'
    BEGIN
        INSERT INTO EducationalInstitution (InstitutionName, InstitutionAcronym, CampusLocation)
        VALUES (@InstitutionName, @InstitutionAcronym, @CampusLocation);
        SELECT SCOPE_IDENTITY() AS NewInstitutionId; 
    END
    ELSE IF @Action = 'U'
    BEGIN
        UPDATE EducationalInstitution
        SET InstitutionName = ISNULL(@InstitutionName, InstitutionName),
            InstitutionAcronym = ISNULL(@InstitutionAcronym, InstitutionAcronym),
            CampusLocation = ISNULL(@CampusLocation, CampusLocation),
            UpdatedAt = GETDATE()
        WHERE InstitutionId = @InstitutionId AND IsActive = 1;
    END
    ELSE IF @Action = 'D'
    BEGIN
        UPDATE EducationalInstitution
        SET IsActive = 0, UpdatedAt = GETDATE()
        WHERE InstitutionId = @InstitutionId;
    END
    ELSE IF @Action = 'S'
    BEGIN
        SELECT * FROM EducationalInstitution
        WHERE (@InstitutionId IS NULL OR InstitutionId = @InstitutionId) AND IsActive = 1;
    END
END;
GO

CREATE PROCEDURE usp_ManageStudentAccount
    @Action CHAR(1), 
    @StudentId INT = NULL,
    @StudentFullName VARCHAR(255) = NULL,
    @LoginUsername VARCHAR(50) = NULL,
    @EmailAddress VARCHAR(255) = NULL,
    @CellPhoneNumber VARCHAR(20) = NULL,
    @AccountPassword VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Action = 'I'
    BEGIN
        INSERT INTO StudentAccount (StudentFullName, LoginUsername, EmailAddress, CellPhoneNumber, AccountPassword)
        VALUES (@StudentFullName, @LoginUsername, @EmailAddress, @CellPhoneNumber, @AccountPassword);
        SELECT SCOPE_IDENTITY() AS NewStudentId;
    END
    ELSE IF @Action = 'U'
    BEGIN
        UPDATE StudentAccount
        SET StudentFullName = ISNULL(@StudentFullName, StudentFullName),
            LoginUsername = ISNULL(@LoginUsername, LoginUsername),
            EmailAddress = ISNULL(@EmailAddress, EmailAddress),
            CellPhoneNumber = ISNULL(@CellPhoneNumber, CellPhoneNumber),
            AccountPassword = ISNULL(@AccountPassword, AccountPassword),
            UpdatedAt = GETDATE()
        WHERE StudentId = @StudentId AND IsActive = 1;
    END
    ELSE IF @Action = 'D'
    BEGIN
        UPDATE StudentAccount
        SET IsActive = 0, UpdatedAt = GETDATE()
        WHERE StudentId = @StudentId;
    END
    ELSE IF @Action = 'S'
    BEGIN
        SELECT StudentId, StudentFullName, LoginUsername, EmailAddress, CellPhoneNumber, IsActive, CreatedAt, UpdatedAt 
        FROM StudentAccount
        WHERE (@StudentId IS NULL OR StudentId = @StudentId)
          AND (@LoginUsername IS NULL OR LoginUsername = @LoginUsername)
          AND (@EmailAddress IS NULL OR EmailAddress = @EmailAddress)
          AND IsActive = 1;
    END
END;
GO

CREATE PROCEDURE usp_AuthenticateStudent
    @LoginIdentifier VARCHAR(255), 
    @AccountPassword VARCHAR(255)  
AS
BEGIN
    SET NOCOUNT ON;

    SELECT StudentId, StudentFullName, LoginUsername, EmailAddress, CellPhoneNumber
    FROM StudentAccount
    WHERE (LoginUsername = @LoginIdentifier OR EmailAddress = @LoginIdentifier)
      AND AccountPassword = @AccountPassword 
      AND IsActive = 1;
END;
GO

CREATE PROCEDURE usp_ManageStudentProgress
    @Action CHAR(1),
    @ProgressId INT = NULL,
    @EnrollmentId INT = NULL,
    @SubjectId INT = NULL,
    @CompletionStatus VARCHAR(50) = NULL,
    @SemesterTaken VARCHAR(20) = NULL,
    @FinalGrade DECIMAL(5,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Action = 'I'
    BEGIN
        INSERT INTO StudentProgress (EnrollmentId, SubjectId, CompletionStatus, SemesterTaken, FinalGrade)
        VALUES (@EnrollmentId, @SubjectId, @CompletionStatus, @SemesterTaken, @FinalGrade);
        SELECT SCOPE_IDENTITY() AS NewProgressId;
    END
    ELSE IF @Action = 'U'
    BEGIN
        UPDATE StudentProgress
        SET CompletionStatus = ISNULL(@CompletionStatus, CompletionStatus),
            SemesterTaken = ISNULL(@SemesterTaken, SemesterTaken),
            FinalGrade = ISNULL(@FinalGrade, FinalGrade),
            UpdatedAt = GETDATE()
        WHERE ProgressId = @ProgressId AND IsActive = 1;
    END
    ELSE IF @Action = 'D'
    BEGIN
        UPDATE StudentProgress
        SET IsActive = 0, UpdatedAt = GETDATE()
        WHERE ProgressId = @ProgressId;
    END
    ELSE IF @Action = 'S'
    BEGIN
        SELECT * FROM StudentProgress
        WHERE (@ProgressId IS NULL OR ProgressId = @ProgressId)
          AND (@EnrollmentId IS NULL OR EnrollmentId = @EnrollmentId) 
          AND IsActive = 1;
    END
END;
GO