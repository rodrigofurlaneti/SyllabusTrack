import { useMutation, useQueryClient } from '@tanstack/react-query'
import { progressApi } from '../api/progressApi'
import { useAuthStore } from '../../../core/auth/authStore'
import type { CompletionStatus } from '../types/progress.types'

export function useUpsertProgress(enrollmentId: number) {
  const queryClient = useQueryClient()
  const studentId = useAuthStore((s) => s.user?.studentId ?? 0)

  return useMutation({
    mutationFn: (body: {
      subjectId: number
      completionStatus: CompletionStatus
      semesterTaken: string | null
      finalGrade: number | null
    }) => progressApi.upsert(enrollmentId, body),
    onSuccess() {
      queryClient.invalidateQueries({ queryKey: ['enrollments', studentId] })
    },
  })
}
