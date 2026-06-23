import { useQuery } from '@tanstack/react-query'
import { planningApi } from '../api/planningApi'

export function usePlanning(sourceProgramId?: number, targetProgramId?: number) {
  return useQuery({
    queryKey: ['planning', sourceProgramId, targetProgramId],
    queryFn: () => planningApi.getPlan(sourceProgramId!, targetProgramId!),
    enabled: !!sourceProgramId && !!targetProgramId && sourceProgramId !== targetProgramId,
    staleTime: 5 * 60 * 1000,
  })
}
