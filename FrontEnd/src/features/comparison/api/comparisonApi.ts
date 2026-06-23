import { apiClient } from '../../../core/api/client'

export interface ComparedSubjectItem {
  subjectName: string
  hours: number
  termNumber: number
  isMatched: boolean
}

export interface CourseComparisonResult {
  sourceProgramId: number
  sourceProgramName: string
  sourceInstitutionName: string
  targetProgramId: number
  targetProgramName: string
  targetInstitutionName: string
  targetTotalSubjects: number
  targetTotalHours: number
  matchedSubjects: number
  matchedHours: number
  remainingSubjects: number
  remainingHours: number
  subjectMatchPercentage: number
  hoursMatchPercentage: number
  subjects: ComparedSubjectItem[]
}

export const comparisonApi = {
  compare: (sourceProgramId: number, targetProgramId: number) =>
    apiClient
      .get<CourseComparisonResult>(`/programs/${sourceProgramId}/compare/${targetProgramId}`)
      .then((r) => r.data),
}
