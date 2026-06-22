import { useMutation, useQueryClient } from '@tanstack/react-query'
import { progressApi } from '../api/progressApi'
import { useAuthStore } from '../../../core/auth/authStore'

export function useUpdateProgress(enrollmentId: number) {
  const queryClient = useQueryClient()
  const studentId = useAuthStore((s) => s.user?.studentId ?? 0)

  return useMutation({
    mutationFn: ({
      progressId,
      ...body
    }: { progressId: number } & Parameters<typeof progressApi.update>[2]) =>
      progressApi.update(enrollmentId, progressId, body),
    onSuccess() {
      queryClient.invalidateQueries({ queryKey: ['enrollments', studentId] })
    },
  })
}
