using Moq;
using SyllabusTrack.Application.Features.AcademicPlanning;
using SyllabusTrack.Application.Features.CourseComparison;
using SyllabusTrack.Application.Features.MultiplePlanning;
using SyllabusTrack.Application.Features.MultipleTargetsPlanning;
using SyllabusTrack.Domain.Shared;

namespace SyllabusTrack.Specs.Support;

/// <summary>
/// Shared state for all planning and comparison scenarios.
/// </summary>
public sealed class PlanningContext
{
    // ── Mocks ─────────────────────────────────────────────────────────────────
    public Mock<IAcademicPlanningRepository>         AcademicPlanRepo     { get; } = new();
    public Mock<ICourseComparisonRepository>         ComparisonRepo       { get; } = new();
    public Mock<IMultiplePlanningRepository>         MultiplePlanRepo     { get; } = new();
    public Mock<IMultipleTargetsPlanningRepository>  MultipleTargetsRepo  { get; } = new();

    // ── Query inputs ──────────────────────────────────────────────────────────
    public int SourceProgramId   { get; set; }
    public int TargetProgramId   { get; set; }
    public IReadOnlyCollection<int> SourceProgramIds { get; set; } = Array.Empty<int>();
    public IReadOnlyCollection<int> TargetProgramIds { get; set; } = Array.Empty<int>();

    // ── Results ───────────────────────────────────────────────────────────────
    public Result<AcademicPlanningResponse>?        AcademicPlanResult    { get; set; }
    public Result<CourseComparisonResponse>?        ComparisonResult      { get; set; }
    public Result<MultiplePlanningResponse>?        MultiplePlanResult    { get; set; }
    public Result<MultipleTargetsPlanningResponse>? MultipleTargetsResult { get; set; }
}
