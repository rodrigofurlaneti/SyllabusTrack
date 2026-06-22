import { useCurriculum } from '../hooks/useCurriculum'
import { useDashboard } from '../../dashboard/hooks/useDashboard'
import { FullPageSpinner } from '../../../shared/components/Spinner'
import { StatusBadge } from '../../../shared/components/StatusBadge'
import type { Status } from '../../../shared/components/StatusBadge'
import type { ProgressResponse } from '../../dashboard/api/dashboardApi'

/** Agrupa disciplinas do enrollment por "semestre cursado" ou usa índice como fallback */
function groupBySemester(progress: ProgressResponse[], totalSemesters: number) {
  const map = new Map<string, ProgressResponse[]>()

  for (let i = 1; i <= totalSemesters; i++) {
    map.set(`${i}º Semestre`, [])
  }

  for (const p of progress) {
    const key = p.semesterTaken
      ? `${p.semesterTaken}`
      : `Sem período definido`

    if (!map.has(key)) map.set(key, [])
    map.get(key)!.push(p)
  }

  return Array.from(map.entries()).filter(([, items]) => items.length > 0)
}

function statusColor(status: Status) {
  const map: Record<Status, string> = {
    Pending:    'border-l-gray-300',
    InProgress: 'border-l-blue-400',
    Completed:  'border-l-emerald-400',
    Failed:     'border-l-red-400',
  }
  return map[status] ?? 'border-l-gray-300'
}

export function CurriculumPage() {
  const { program, institution, enrollment, isLoading } = useCurriculum()
  const { data: enrollments } = useDashboard()

  if (isLoading) return <FullPageSpinner />

  if (!program || !enrollment) {
    return (
      <div className="rounded-xl border border-gray-200 bg-white p-10 text-center">
        <p className="text-gray-500">Nenhuma grade curricular encontrada.</p>
        <p className="mt-1 text-sm text-gray-400">
          Você precisa estar matriculado em um curso para ver a grade.
        </p>
      </div>
    )
  }

  const progress = enrollments?.[0]?.progress ?? []
  const groups = groupBySemester(progress, program.totalSemesters)

  const completedCount = progress.filter((p) => p.completionStatus === 'Completed').length
  const pct = progress.length > 0 ? Math.round((completedCount / progress.length) * 100) : 0

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Grade Curricular</h1>
        <p className="mt-0.5 text-sm text-gray-500">
          Visualize todas as disciplinas do seu curso por semestre
        </p>
      </div>

      {/* Course info card */}
      <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
        <div className="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
          <div>
            <p className="text-xs font-medium uppercase tracking-wider text-gray-400">
              {institution?.institutionAcronym ?? institution?.institutionName}
            </p>
            <h2 className="mt-1 text-xl font-bold text-gray-900">{program.programName}</h2>
            <p className="mt-0.5 text-sm text-gray-500">
              Grade {program.curriculumVersion} · {program.totalSemesters} semestres
            </p>
          </div>

          <div className="min-w-[140px]">
            <div className="mb-1 flex items-center justify-between text-xs text-gray-500">
              <span>Conclusão</span>
              <span className="font-semibold text-primary-600">{pct}%</span>
            </div>
            <div className="h-2 w-full overflow-hidden rounded-full bg-gray-100">
              <div
                className="h-full rounded-full bg-primary-500 transition-all"
                style={{ width: `${pct}%` }}
              />
            </div>
            <p className="mt-1 text-xs text-gray-400 text-right">
              {completedCount}/{progress.length} disciplinas
            </p>
          </div>
        </div>
      </div>

      {/* Legenda */}
      <div className="flex flex-wrap items-center gap-4">
        <p className="text-xs font-medium text-gray-500 uppercase tracking-wider">Legenda:</p>
        {(['Pending', 'InProgress', 'Completed', 'Failed'] as Status[]).map((s) => (
          <StatusBadge key={s} status={s} />
        ))}
      </div>

      {/* Grade por semestre */}
      {groups.length === 0 ? (
        <div className="rounded-xl border border-dashed border-gray-300 bg-white p-10 text-center">
          <p className="text-sm text-gray-500">
            Nenhuma disciplina registrada no seu progresso ainda.
          </p>
        </div>
      ) : (
        <div className="space-y-4">
          {groups.map(([semester, subjects]) => (
            <div key={semester} className="rounded-xl border border-gray-200 bg-white shadow-sm">
              {/* Semester header */}
              <div className="border-b border-gray-100 px-5 py-3">
                <h3 className="text-sm font-semibold text-gray-700">{semester}</h3>
                <p className="text-xs text-gray-400">
                  {subjects.filter((s) => s.completionStatus === 'Completed').length} de{' '}
                  {subjects.length} concluídas
                </p>
              </div>

              {/* Subject list */}
              <ul className="divide-y divide-gray-50">
                {subjects.map((subject) => (
                  <li
                    key={subject.progressId}
                    className={`flex items-center justify-between border-l-4 px-5 py-3 ${statusColor(subject.completionStatus as Status)}`}
                  >
                    <div>
                      <p className="text-sm font-medium text-gray-800">
                        {subject.subjectName ?? `Disciplina #${subject.subjectId}`}
                      </p>
                    </div>
                    <div className="flex items-center gap-3">
                      {subject.finalGrade != null && (
                        <span
                          className={`text-sm font-bold ${
                            subject.finalGrade >= 5 ? 'text-emerald-600' : 'text-red-600'
                          }`}
                        >
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
