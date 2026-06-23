import { useMutation } from '@tanstack/react-query'
import { multipleTargetsPlanningApi } from '../api/multipleTargetsPlanningApi'

export function useMultipleTargetsPlanning() {
  return useMutation({
    mutationFn: ({
      sourceProgramIds,
      targetProgramIds,
    }: {
      sourceProgramIds: number[]
      targetProgramIds: number[]
    }) =>
      multipleTargetsPlanningApi.getMultipleTargetsPlan(
        sourceProgramIds,
        targetProgramIds,
      ),
  })
}
