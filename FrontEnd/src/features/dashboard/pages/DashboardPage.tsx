import { useState } from 'react'
import { useDashboard } from '../hooks/useDashboard'
import { FullPageSpinner } from '../../../shared/components/Spinner'
import type { EnrollmentResponse } from '../api/dashboardApi'

function calcPct(num: number, den: number) {
  return den > 0 ? Math.round((num / den) * 100) : 0
}

interface StatCardProps {
  label: string
  value: number
  total: number
  color: string
  bgColor: string
}

function StatCard({ label, value, total, color, bgColor }: StatCardProps) {
  const p = calcPct(value, total)
  return (
    <div className="rounded-xl border border-gray-200 bg-white p-5 shadow-sm">
      <p className="text-xs font-medium uppercase tracking-wider text-gray-400">{label}</p>
      <p className={'mt-1 text-3xl font-bold ' + color}>{value}</p>
      <div className="mt-3">
        <div className="mb-1 flex justify-between text-xs text-gray-400">
          <span>{p}%</span>
          <span>de {total}</span>
        </div>
        <div className="h-1.5 w-full overflow-hidden rounded-full bg-gray-100">
          <div className={'h-full rounded-full transition-all ' + bgColor} style={{ width: p + '%' }} />
        </div>
      </div>
    </div>
  )
}

function CoursePanel({ enrollment }: { enrollment: EnrollmentResponse }) {
  const progress = enrollment.progresses
  const total = progress.length
  const completed  = progress.filter((p) => p.completionStatus === 'Completed').length
  const inProgress = progress.filter((p) => p.completionStatus === 'InProgress').length
  const failed     = progress.filter((p) => p.completionStatus === 'Failed').length
  const pending    = progress.filter((p) => p.completionStatus === 'Pending').length
  const overall    = calcPct(completed, total)

  const graded = progress.filter((p) => p.completionStatus === 'Completed' && p.finalGrade != null)
  const avgGrade =
    graded.length > 0
      ? (graded.reduce((s, p) => s + (p.finalGrade ?? 0), 0) / graded.length).toFixed(1)
      : null

  return (
    <div className="space-y-5">
      <div className="rounded-xl border border-gray-200 bg-white p-5 shadow-sm">
        <div className="flex items-start justify-between">
          <div>
            <p className="text-sm font-medium text-gray-500">Conclusão geral</p>
            <p className="text-4xl font-bold text-primary-600">{overall}%</p>
            <p className="mt-0.5 text-xs text-gray-400">
              {completed} de {total} disciplinas concluídas
            </p>
          </div>
          {avgGrade != null && (
            <div className="text-right">
              <p className="text-xs font-medium uppercase tracking-wider text-gray-400">Média</p>
              <p className="text-3xl font-bold text-emerald-600">{avgGrade}</p>
              <p className="text-xs text-gray-400">{graded.length} disciplinas</p>
            </div>
          )}
        </div>
        <div className="mt-4 h-2 w-full overflow-hidden rounded-full bg-gray-100">
          <div className="h-full rounded-full bg-primary-500 transition-all" style={{ width: overall + '%' }} />
        </div>
      </div>

      <div className="grid grid-cols-2 gap-3 sm:grid-cols-4">
        <StatCard label="Concluídas"   value={completed}  total={total} color="text-emerald-600" bgColor="bg-emerald-500" />
        <StatCard label="Em andamento" value={inProgress} total={total} color="text-blue-600"    bgColor="bg-blue-500"    />
        <StatCard label="Reprovadas"   value={failed}     total={total} color="text-red-600"     bgColor="bg-red-500"     />
        <StatCard label="Pendentes"    value={pending}    total={total} color="text-gray-600"    bgColor="bg-gray-400"    />
      </div>

      {graded.length > 0 && (
        <div className="rounded-xl border border-gray-200 bg-white shadow-sm">
          <div className="border-b border-gray-100 px-5 py-3">
            <h3 className="text-sm font-semibold text-gray-700">Melhores notas</h3>
          </div>
          <ul className="divide-y divide-gray-50">
            {[...graded]
              .sort((a, b) => (b.finalGrade ?? 0) - (a.finalGrade ?? 0))
              .slice(0, 5)
              .map((p) => (
                <li key={p.progressId} className="flex items-center justify-between px-5 py-3">
                  <div className="min-w-0">
                    <span className="truncate text-sm text-gray-700">{p.subjectName}</span>
                    {p.semesterTaken && (
                      <span className="ml-2 text-xs text-gray-400">{p.semesterTaken}</span>
                    )}
                  </div>
                  <span className={'ml-4 text-sm font-bold ' + ((p.finalGrade ?? 0) >= 5 ? 'text-emerald-600' : 'text-red-600')}>
                    {p.finalGrade?.toFixed(1)}
                  </span>
                </li>
              ))}
          </ul>
        </div>
      )}
    </div>
  )
}

export function DashboardPage() {
  const { data: enrollments, isLoading, isError } = useDashboard()
  const [selectedId, setSelectedId] = useState<number | null>(null)

  if (isLoading) return <FullPageSpinner />

  if (isError || !enrollments?.length) {
    return (
      <div className="rounded-xl border border-gray-200 bg-white p-10 text-center">
        <p className="text-gray-500">Nenhuma matrícula encontrada.</p>
        <p className="mt-1 text-sm text-gray-400">
          Você precisa estar matriculado em um curso para ver o dashboard.
        </p>
      </div>
    )
  }

  const activeId = selectedId ?? enrollments[0].enrollmentId
  const activeEnrollment = enrollments.find((e) => e.enrollmentId === activeId) ?? enrollments[0]

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
        <p className="mt-0.5 text-sm text-gray-500">
          {enrollments.length > 1
            ? 'Você está matriculado em ' + enrollments.length + ' cursos'
            : 'Acompanhe seu progresso no curso'}
        </p>
      </div>

      {enrollments.length > 1 && (
        <div className="flex flex-wrap gap-2">
          {enrollments.map((e) => {
            const isActive = e.enrollmentId === activeId
            const completedCount = e.progresses.filter((p) => p.completionStatus === 'Completed').length
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
                <p className={'text-xs ' + (isActive ? 'text-primary-500' : 'text-gray-400')}>
                  {e.totalSemesters} sem · {completedCount}/{e.progresses.length} concluídas
                </p>
              </button>
            )
          })}
        </div>
      )}

      {enrollments.length === 1 && (
        <div className="rounded-xl border border-gray-200 bg-white px-5 py-4 shadow-sm">
          <p className="text-xs font-medium uppercase tracking-wider text-gray-400">
            {activeEnrollment.institutionAcronym || activeEnrollment.institutionName}
          </p>
          <p className="mt-0.5 text-lg font-semibold text-gray-800">{activeEnrollment.programName}</p>
          <p className="text-xs text-gray-400">{activeEnrollment.totalSemesters} semestres · {activeEnrollment.institutionName}</p>
        </div>
      )}

      <CoursePanel enrollment={activeEnrollment} />
    </div>
  )
}
