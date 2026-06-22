import { apiClient } from '../../../core/api/client'

export interface ProgressResponse {
  progressId: number
  subjectId: number
  subjectCode: string
  subjectName: string
  completionStatus: 'Pending' | 'InProgress' | 'Completed' | 'Failed'
  semesterTaken: string | null
  finalGrade: number | null
}

export interface EnrollmentResponse {
  enrollmentId: number
  studentId: number
  programId: number
  programName: string
  institutionName: string
  institutionAcronym: string
  totalSemesters: number
  enrollmentStatus: string
  progresses: ProgressResponse[]
}

export const dashboardApi = {
  getEnrollmentsByStudent(studentId: number) {
    return apiClient
      .get<EnrollmentResponse[]>('/enrollments/student/' + String(studentId))
      .then((r) => r.data)
  },
}
