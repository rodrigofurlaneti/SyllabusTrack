import { apiClient } from '../../../core/api/client'
import type { SemesterPlanItem } from '../../planning/api/planningApi'

export interface SourceProgramSummary {
  programId: number
  programName: string
  institutionName: string
}

export interface MultiplePlanningResult {
  sourcePrograms: SourceProgramSummary[]
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

export const multiplePlanningApi = {
  getMultiplePlan: (sourceProgramIds: number[], targetProgramId: number) =>
    apiClient
      .post<MultiplePlanningResult>('/programs/planning/multiple', {
        sourceProgramIds,
        targetProgramId,
      })
      .then((r) => r.data),
}
