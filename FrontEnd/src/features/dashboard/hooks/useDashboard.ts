import { useQuery } from '@tanstack/react-query'
import { useAuthStore } from '../../../core/auth/authStore'
import { dashboardApi } from '../api/dashboardApi'

export function useDashboard() {
  const studentId = useAuthStore((s) => s.user?.studentId ?? 0)

  return useQuery({
    queryKey: ['enrollments', studentId],
    queryFn: () => dashboardApi.getEnrollmentsByStudent(studentId),
    enabled: studentId > 0,
  })
}
