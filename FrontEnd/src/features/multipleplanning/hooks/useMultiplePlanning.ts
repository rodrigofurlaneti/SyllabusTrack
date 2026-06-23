import { useMutation } from '@tanstack/react-query'
import { multiplePlanningApi } from '../api/multiplePlanningApi'

export function useMultiplePlanning() {
  return useMutation({
    mutationFn: ({
      sourceProgramIds,
      targetProgramId,
    }: {
      sourceProgramIds: number[]
      targetProgramId: number
    }) => multiplePlanningApi.getMultiplePlan(sourceProgramIds, targetProgramId),
  })
}
