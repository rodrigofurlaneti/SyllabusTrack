namespace SyllabusTrack.Application.Features.AcademicPlanning;

/// <summary>
/// Resultado do planejamento acadêmico: quanto tempo falta para concluir o curso-alvo
/// dado que o curso de referência já foi (ou será) concluído.
/// </summary>
public sealed record AcademicPlanningResponse(
    // Cursos
    int     SourceProgramId,
    string  SourceProgramName,
    string  SourceInstitutionName,
    int     TargetProgramId,
    string  TargetProgramName,
    string  TargetInstitutionName,

    // Totais do curso-alvo
    int     TargetTotalSemesters,
    int     TargetTotalSubjects,
    int     TargetTotalHours,

    // Aproveitamento global
    int     MatchedSubjects,
    int     MatchedHours,
    int     RemainingSubjects,
    int     RemainingHours,
    decimal SubjectMatchPercentage,
    decimal HoursMatchPercentage,

    // Estimativa de tempo
    int     EffectiveSemestersNeeded,   // semestres com ≥1 disciplina restante
    int     SemestersFullyCreditable,   // semestres 100% aproveitados (pularão)
    decimal EstimatedYears,             // EffectiveSemestersNeeded / 2
    decimal OriginalYears,              // TargetTotalSemesters / 2
    decimal YearsSaved,                 // OriginalYears - EstimatedYears

    // Breakdown por semestre
    IReadOnlyCollection<SemesterPlanItem> SemesterPlans
);

/// <summary>
/// Situação de um semestre do curso-alvo no contexto do aproveitamento.
/// </summary>
public sealed record SemesterPlanItem(
    int     TermNumber,
    int     TotalSubjects,
    int     TotalHours,
    int     MatchedSubjects,
    int     MatchedHours,
    int     RemainingSubjects,
    int     RemainingHours,
    decimal SubjectMatchPercentage,
    /// <summary>true quando todas as disciplinas do semestre são aproveitadas.</summary>
    bool    IsFullyCreditable,
    IReadOnlyCollection<PlannedSubjectItem> Subjects
);

/// <summary>Disciplina do curso-alvo com status de aproveitamento.</summary>
public sealed record PlannedSubjectItem(
    string SubjectName,
    int    Hours,
    bool   IsMatched
);
