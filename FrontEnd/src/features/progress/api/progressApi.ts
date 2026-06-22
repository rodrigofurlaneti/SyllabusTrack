import { apiClient } from '../../../core/api/client'
import type { UpdateProgressRequest } from '../types/progress.types'

export const progressApi = {
  update(enrollmentId: number, progressId: number, body: UpdateProgressRequest) {
    return apiClient
      .put(`/enrollments/${enrollmentId}/progress/${progressId}`, body)
      .then((r) => r.data)
  },
  create(enrollmentId: number, body: { subjectId: number } & UpdateProgressRequest) {
    return apiClient
      .post(`/enrollments/${enrollmentId}/progress`, body)
      .then((r) => r.data)
  },
}
