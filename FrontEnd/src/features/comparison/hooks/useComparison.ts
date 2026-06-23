import { useQuery } from '@tanstack/react-query'
import { comparisonApi } from '../api/comparisonApi'

export function useComparison(sourceProgramId?: number, targetProgramId?: number) {
  return useQuery({
    queryKey: ['comparison', sourceProgramId, targetProgramId],
    queryFn: () => comparisonApi.compare(sourceProgramId!, targetProgramId!),
    enabled: !!sourceProgramId && !!targetProgramId && sourceProgramId !== targetProgramId,
    staleTime: 5 * 60 * 1000,
  })
}
