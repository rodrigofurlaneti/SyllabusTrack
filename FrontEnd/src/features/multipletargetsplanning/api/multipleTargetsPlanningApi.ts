import { apiClient } from '../../../core/api/client'
import type { SemesterPlanItem } from '../../planning/api/planningApi'
import type { SourceProgramSummary } from '../../multipleplanning/api/multiplePlanningApi'

// Re-export for convenience
export type { SourceProgramSummary }

export interface TargetProgramResult {
  targetProgramId: number
  targetProgramName: string
  targetInstitutionName: string
  targetTotalSemesters: number
  targetTotalSubjects: number
  targetTotalHours: number
  matchedSubjects: number
  matchedHours: number
  remainingSubjects: number
  remainingHours: number
  subjectMatchPercentage: number
  hoursMatchPercentage: number
  effectiveSemestersNeeded: number
  semestersFullyCreditable: number
  estimatedYears: number
  originalYears: number
  yearsSaved: number
  semesterPlans: SemesterPlanItem[]
}

export interface MultipleTargetsPlanningResult {
  sourcePrograms: SourceProgramSummary[]
  targetResults: TargetProgramResult[]
}

export const multipleTargetsPlanningApi = {
  getMultipleTargetsPlan: (
    sourceProgramIds: number[],
    targetProgramIds: number[],
  ) =>
    apiClient
      .post<MultipleTargetsPlanningResult>('/programs/planning/multiple-targets', {
        sourceProgramIds,
        targetProgramIds,
      })
      .then((r) => r.data),
}
