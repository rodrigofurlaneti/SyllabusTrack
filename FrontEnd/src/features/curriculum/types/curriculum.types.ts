export interface ProgramResponse {
  programId: number
  institutionId: number
  programName: string
  curriculumVersion: string
  totalSemesters: number
  isActive: boolean
}

export interface InstitutionResponse {
  institutionId: number
  institutionName: string
  institutionAcronym: string
  campusLocation: string
}
