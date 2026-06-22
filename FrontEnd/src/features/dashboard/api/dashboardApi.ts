import { apiClient } from '../../../core/api/client'

export interface EnrollmentResponse {
  enrollmentId: number
  studentId: number
  programId: number
  enrollmentDate: string
  enrollmentStatus: string
  progress: ProgressResponse[]
}

export interface ProgressResponse {
  progressId: number
  subjectId: number
  subjectName: string
  completionStatus: 'Pending' | 'InProgress' | 'Completed' | 'Failed'
  semesterTaken: string | null
  finalGrade: number | null
}

export const dashboardApi = {
  getEnrollmentsByStudent(studentId: number) {
    return apiClient
      .get<EnrollmentResponse[]>(`/enrollments/student/${studentId}`)
      .then((r) => r.data)
  },
}
