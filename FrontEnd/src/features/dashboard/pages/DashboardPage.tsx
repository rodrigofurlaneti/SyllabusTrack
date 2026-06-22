import { useDashboard } from '../hooks/useDashboard'
import { useAuthStore } from '../../../core/auth/authStore'
import { FullPageSpinner } from '../../../shared/components/Spinner'
import { StatusBadge } from '../../../shared/components/StatusBadge'
import type { Status } from '../../../shared/components/StatusBadge'
import { Link } from 'react-router-dom'

interface StatCardProps {
  label: string
  value: number
  color: string
}

function StatCard({ label, value, color }: StatCardProps) {
  return (
    <div className={`rounded-xl border bg-white p-5 shadow-sm ${color}`}>
      <p className="text-sm font-medium text-gray-500">{label}</p>
      <p className="mt-1 text-3xl font-bold text-gray-900">{value}</p>
    </div>
  )
}

export function DashboardPage() {
  const user = useAuthStore((s) => s.user)
  const { data: enrollments, isLoading, error } = useDashboard()

  if (isLoading) return <FullPageSpinner />

  if (error || !enrollments?.length) {
    return (
      <div className="rounded-xl border border-gray-200 bg-white p-10 text-center">
        <p className="text-gray-500">Nenhuma matrícula encontrada.</p>
        <p className="mt-1 text-sm text-gray-400">
          Peça ao administrador para cadastrar sua matrícula no sistema.
        </p>
      </div>
    )
  }

  // Usa a matrícula mais recente
  const enrollment = enrollments[0]
  const progress = enrollment.progresses ?? []

  const stats = {
    total: progress.length,
    completed: progress.filter((p) => p.completionStatus === 'Completed').length,
    inProgress: progress.filter((p) => p.completionStatus === 'InProgress').length,
    pending: progress.filter((p) => p.completionStatus === 'Pending').length,
    failed: progress.filter((p) => p.completionStatus === 'Failed').length,
  }

  const pct = stats.total > 0 ? Math.round((stats.completed / stats.total) * 100) : 0

  const recent = [...progress]
    .filter((p) => p.completionStatus !== 'Pending')
    .slice(0, 5)

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900">
          Olá, {user?.fullName?.split(' ')[0] ?? 'estudante'} 👋
        </h1>
        <p className="mt-0.5 text-sm text-gray-500">
          Matrícula #{enrollment.enrollmentId} · Status:{' '}
          <span className="font-medium text-gray-700">{enrollment.enrollmentStatus}</span>
        </p>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 gap-4 sm:grid-cols-4">
        <StatCard label="Concluídas"     value={stats.completed}  color="border-emerald-100" />
        <StatCard label="Em Andamento"   value={stats.inProgress} color="border-blue-100" />
        <StatCard label="Pendentes"      value={stats.pending}    color="border-gray-100" />
        <StatCard label="Reprovadas"     value={stats.failed}     color="border-red-100" />
      </div>

      {/* Progress bar */}
      <div className="rounded-xl border border-gray-200 bg-white p-5 shadow-sm">
        <div className="mb-2 flex items-center justify-between">
          <p className="text-sm font-medium text-gray-700">Progresso geral do curso</p>
          <p className="text-sm font-semibold text-primary-600">{pct}%</p>
        </div>
        <div className="h-2.5 w-full overflow-hidden rounded-full bg-gray-100">
          <div
            className="h-full rounded-full bg-primary-500 transition-all duration-500"
            style={{ width: `${pct}%` }}
          />
        </div>
        <p className="mt-2 text-xs text-gray-400">
          {stats.completed} de {stats.total} disciplinas concluídas
        </p>
      </div>

      {/* Recent activity */}
      <div className="rounded-xl border border-gray-200 bg-white shadow-sm">
        <div className="flex items-center justify-between border-b border-gray-100 px-5 py-4">
          <h2 className="text-sm font-semibold text-gray-900">Atividade recente</h2>
          <Link to="/progress" className="text-xs text-primary-600 hover:underline">
            Ver todas →
          </Link>
        </div>

        {recent.length === 0 ? (
          <p className="px-5 py-8 text-center text-sm text-gray-400">
            Nenhuma disciplina iniciada ainda.
          </p>
        ) : (
          <ul className="divide-y divide-gray-50">
            {recent.map((p) => (
              <li key={p.progressId} className="flex items-center justify-between px-5 py-3">
                <div>
                  <p className="text-sm font-medium text-gray-800">
                    {p.subjectName ?? `Disciplina #${p.subjectId}`}
                  </p>
                  {p.semesterTaken && (
                    <p className="text-xs text-gray-400">{p.semesterTaken}</p>
                  )}
                </div>
                <div className="flex items-center gap-3">
                  {p.finalGrade != null && (
                    <span className="text-sm font-semibold text-gray-700">
                      {p.finalGrade.toFixed(1)}
                    </span>
                  )}
                  <StatusBadge status={p.completionStatus as Status} />
                </div>
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  )
}
