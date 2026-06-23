import { apiClient } from '../../../core/api/client'

export interface PlannedSubjectItem {
  subjectName: string
  hours: number
  isMatched: boolean
}

export interface SemesterPlanItem {
  termNumber: number
  totalSubjects: number
  totalHours: number
  matchedSubjects: number
  matchedHours: number
  remainingSubjects: number
  remainingHours: number
  subjectMatchPercentage: number
  isFullyCreditable: boolean
  subjects: PlannedSubjectItem[]
}

export interface AcademicPlanningResult {
  sourceProgramId: number
  sourceProgramName: string
  sourceInstitutionName: string
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

export const planningApi = {
  getPlan: (sourceProgramId: number, targetProgramId: number) =>
    apiClient
      .get<AcademicPlanningResult>(`/programs/${sourceProgramId}/planning/${targetProgramId}`)
      .then((r) => r.data),
}
