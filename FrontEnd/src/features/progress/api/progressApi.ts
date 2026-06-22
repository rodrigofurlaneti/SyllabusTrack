import { apiClient } from '../../../core/api/client'
import type { CompletionStatus } from '../types/progress.types'

export interface AddProgressBody {
  subjectId: number
  completionStatus: CompletionStatus
  semesterTaken: string | null
  finalGrade: number | null
}

export const progressApi = {
  // O backend tem apenas POST (upsert — cria ou atualiza por subjectId+enrollmentId)
  upsert(enrollmentId: number, body: AddProgressBody) {
    return apiClient
      .post(`/enrollments/${enrollmentId}/progress`, body)
      .then((r) => r.data)
  },
}
