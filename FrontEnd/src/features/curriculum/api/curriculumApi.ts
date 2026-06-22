import { apiClient } from '../../../core/api/client'
import type { ProgramResponse, InstitutionResponse } from '../types/curriculum.types'

export const curriculumApi = {
  getPrograms() {
    return apiClient.get<ProgramResponse[]>('/programs').then((r) => r.data)
  },
  getProgramById(id: number) {
    return apiClient.get<ProgramResponse>(`/programs/${id}`).then((r) => r.data)
  },
  getInstitutions() {
    return apiClient.get<InstitutionResponse[]>('/institutions').then((r) => r.data)
  },
}
