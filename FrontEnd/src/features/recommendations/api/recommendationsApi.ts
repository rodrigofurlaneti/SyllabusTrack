import { apiClient } from '../../../core/api/client'

export interface ProgramRecommendation {
  programId: number
  programName: string
  curriculumVersion: string
  totalSemesters: number
  institutionName: string
  institutionAcronym: string
  totalSubjects: number
  matchedSubjects: number
  remainingSubjects: number
  matchPercentage: number
}

export const recommendationsApi = {
  getByStudent: (studentId: number) =>
    apiClient
      .get<ProgramRecommendation[]>(`/recommendations/student/${studentId}`)
      .then((r) => r.data),
}
