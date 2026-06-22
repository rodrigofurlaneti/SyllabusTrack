export type CompletionStatus = 'Pending' | 'InProgress' | 'Completed' | 'Failed'

export interface UpdateProgressRequest {
  completionStatus: CompletionStatus
  semesterTaken: string | null
  finalGrade: number | null
}
