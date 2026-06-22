import { useState } from 'react'
import { useDashboard } from '../../dashboard/hooks/useDashboard'
import { FullPageSpinner } from '../../../shared/components/Spinner'
import { StatusBadge } from '../../../shared/components/StatusBadge'
import type { Status } from '../../../shared/components/StatusBadge'
import type { EnrollmentResponse, ProgressResponse } from '../../dashboard/api/dashboardApi'

function semesterFromCode(code: string): number {
  const match = code.match(/-(\d)\d{2}$/)
  return match ? parseInt(match[1], 10) : 0
}

function groupBySemester(
  progresses: ProgressResponse[],
  totalSemesters: number,
): Array<[string, ProgressResponse[]]> {
  const map = new Map<string, ProgressResponse[]>()
  for (let i = 1; i <= totalSemesters; i++) {
    map.set(i + 'º Semestre', [])
  }
  for (const p of progresses) {
    const sem = semesterFromCode(p.subjectCode)
    const key = sem > 0 ? sem + 'º Semestre' : 'Sem período definido'
    if (!map.has(key)) map.set(key, [])
    map.get(key)!.push(p)
  }
  return Array.from(map.entries()).filter(([, items]) => items.length > 0)
}

function borderColor(status: Status) {
  if (status === 'Completed')  return 'border-l-emerald-400'
  if (status === 'InProgress') return 'border-l-blue-400'
  if (status === 'Failed')     return 'border-l-red-400'
  return 'border-l-gray-300'
}

function CurriculumView({ enrollment }: { enrollment: EnrollmentResponse }) {
  const progress = enrollment.progresses
  const groups = groupBySemester(progress, enrollment.totalSemesters)
  const completedCount = progress.filter((p) => p.completionStatus === 'Completed').length
  const pct = progress.length > 0 ? Math.round((completedCount / progress.length) * 100) : 0

  return (
    <div className="space-y-4">
      <div className="rounded-xl border border-gray-200 bg-white p-5 shadow-sm">
        <div className="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
          <div>
            <p className="text-xs font-medium uppercase tracking-wider text-gray-400">
              {enrollment.institutionAcronym || enrollment.institutionName}
            </p>
            <h2 className="mt-0.5 text-xl font-bold text-gray-900">{enrollment.programName}</h2>
            <p className="mt-0.5 text-sm text-gray-500">
              {enrollment.institutionName} · {enrollment.totalSemesters} semestres
            </p>
          </div>
          <div className="min-w-[140px]">
            <div className="mb-1 flex items-center justify-between text-xs text-gray-500">
              <span>Conclusão</span>
              <span className="font-semibold text-primary-600">{pct}%</span>
            </div>
            <div className="h-2 w-full overflow-hidden rounded-full bg-gray-100">
              <div className="h-full rounded-full bg-primary-500 transition-all" style={{ width: pct + '%' }} />
            </div>
            <p className="mt-1 text-right text-xs text-gray-400">
              {completedCount}/{progress.length} disciplinas
            </p>
          </div>
        </div>
      </div>

      <div className="flex flex-wrap items-center gap-4">
        <p className="text-xs font-medium uppercase tracking-wider text-gray-500">Legenda:</p>
        {(['Pending', 'InProgress', 'Completed', 'Failed'] as Status[]).map((s) => (
          <StatusBadge key={s} status={s} />
        ))}
      </div>

      {groups.length === 0 ? (
        <div className="rounded-xl border border-dashed border-gray-300 bg-white p-10 text-center">
          <p className="text-sm text-gray-500">Nenhuma disciplina registrada ainda.</p>
        </div>
      ) : (
        <div className="space-y-4">
          {groups.map(([semester, subjects]) => (
            <div key={semester} className="rounded-xl border border-gray-200 bg-white shadow-sm">
              <div className="border-b border-gray-100 px-5 py-3">
                <h3 className="text-sm font-semibold text-gray-700">{semester}</h3>
                <p className="text-xs text-gray-400">
                  {subjects.filter((s) => s.completionStatus === 'Completed').length} de {subjects.length} concluídas
                </p>
              </div>
              <ul className="divide-y divide-gray-50">
                {subjects.map((subject) => (
                  <li
                    key={subject.progressId}
                    className={'flex items-center justify-between border-l-4 px-5 py-3 ' + borderColor(subject.completionStatus as Status)}
                  >
                    <div>
                      <p className="text-sm font-medium text-gray-800">
                        {subject.subjectName || 'Disciplina #' + subject.subjectId}
                      </p>
                      {subject.subjectCode && (
                        <p className="text-xs text-gray-400">{subject.subjectCode}</p>
                      )}
                    </div>
                    <div className="flex items-center gap-3">
                      {subject.finalGrade != null && (
                        <span className={'text-sm font-bold ' + (subject.finalGrade >= 5 ? 'text-emerald-600' : 'text-red-600')}>
                          {subject.finalGrade.toFixed(1)}
                        </span>
                      )}
                      <StatusBadge status={subject.completionStatus as Status} />
                    </div>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

export function CurriculumPage() {
  const { data: enrollments, isLoading } = useDashboard()
  const [selectedId, setSelectedId] = useState<number | null>(null)

  if (isLoading) return <FullPageSpinner />

  if (!enrollments?.length) {
    return (
      <div className="rounded-xl border border-gray-200 bg-white p-10 text-center">
        <p className="text-gray-500">Nenhuma grade curricular encontrada.</p>
        <p className="mt-1 text-sm text-gray-400">
          Você precisa estar matriculado em um curso para ver a grade.
        </p>
      </div>
    )
  }

  const activeId = selectedId ?? enrollments[0].enrollmentId
  const activeEnrollment = enrollments.find((e) => e.enrollmentId === activeId) ?? enrollments[0]

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Grade Curricular</h1>
        <p className="mt-0.5 text-sm text-gray-500">
          Visualize todas as disciplinas do seu curso por semestre
        </p>
      </div>

      {enrollments.length > 1 && (
        <div className="flex flex-wrap gap-2">
          {enrollments.map((e) => {
            const isActive = e.enrollmentId === activeId
            return (
              <button
                key={e.enrollmentId}
                onClick={() => setSelectedId(e.enrollmentId)}
                className={'rounded-xl border px-4 py-2.5 text-left transition-colors ' + (isActive ? 'border-primary-500 bg-primary-50 shadow-sm' : 'border-gray-200 bg-white hover:bg-gray-50')}
              >
                <p className={'text-xs font-medium uppercase tracking-wider ' + (isActive ? 'text-primary-500' : 'text-gray-400')}>
                  {e.institutionAcronym || e.institutionName}
                </p>
                <p className={'mt-0.5 text-sm font-semibold ' + (isActive ? 'text-primary-700' : 'text-gray-700')}>
                  {e.programName}
                </p>
              </button>
            )
          })}
        </div>
      )}

      <CurriculumView enrollment={activeEnrollment} />
    </div>
  )
}
