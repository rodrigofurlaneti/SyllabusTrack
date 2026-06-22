import { useQuery } from '@tanstack/react-query'
import { curriculumApi } from '../api/curriculumApi'
import { useAuthStore } from '../../../core/auth/authStore'
import { dashboardApi } from '../../dashboard/api/dashboardApi'

export function useCurriculum() {
  const studentId = useAuthStore((s) => s.user?.studentId ?? 0)

  const enrollmentsQuery = useQuery({
    queryKey: ['enrollments', studentId],
    queryFn: () => dashboardApi.getEnrollmentsByStudent(studentId),
    enabled: studentId > 0,
  })

  const programId = enrollmentsQuery.data?.[0]?.programId

  const programQuery = useQuery({
    queryKey: ['program', programId],
    queryFn: () => curriculumApi.getProgramById(programId!),
    enabled: !!programId,
  })

  const institutionsQuery = useQuery({
    queryKey: ['institutions'],
    queryFn: curriculumApi.getInstitutions,
  })

  const institution = institutionsQuery.data?.find(
    (i) => i.institutionId === programQuery.data?.institutionId,
  )

  return {
    enrollment: enrollmentsQuery.data?.[0],
    program: programQuery.data,
    institution,
    isLoading: enrollmentsQuery.isLoading || programQuery.isLoading,
    error: enrollmentsQuery.error ?? programQuery.error,
  }
}
