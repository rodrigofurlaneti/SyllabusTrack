import { useQuery } from '@tanstack/react-query'
import { recommendationsApi } from '../api/recommendationsApi'

export function useRecommendations(studentId: number | undefined) {
  return useQuery({
    queryKey: ['recommendations', studentId],
    queryFn: () => recommendationsApi.getByStudent(studentId!),
    enabled: !!studentId,
    staleTime: 1000 * 60 * 5, // 5 min — raramente muda
  })
}
