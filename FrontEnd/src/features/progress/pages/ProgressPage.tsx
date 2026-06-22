import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { useDashboard } from '../../dashboard/hooks/useDashboard'
import { useUpsertProgress } from '../hooks/useProgress'
import { FullPageSpinner, Spinner } from '../../../shared/components/Spinner'
import { StatusBadge } from '../../../shared/components/StatusBadge'
import type { Status } from '../../../shared/components/StatusBadge'
import type { EnrollmentResponse, ProgressResponse } from '../../dashboard/api/dashboardApi'
import type { CompletionStatus } from '../types/progress.types'

const ALL_STATUSES: Status[] = ['Pending', 'InProgress', 'Completed', 'Failed']

const schema = z.object({
  completionStatus: z.enum(['Pending', 'InProgress', 'Completed', 'Failed']),
  semesterTaken: z.string().optional(),
  finalGrade: z.preprocess(
    (v) => (v === '' || v === null || v === undefined ? null : Number(v)),
    z.number().min(0).max(10).nullable(),
  ),
})

type FormData = z.infer<typeof schema>

interface EditModalProps {
  subject: ProgressResponse
  enrollmentId: number
  onClose: () => void
}

function EditModal({ subject, enrollmentId, onClose }: EditModalProps) {
  const { mutate, isPending, isSuccess, error } = useUpsertProgress(enrollmentId)

  const { register, handleSubmit, watch, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(schema),
    defaultValues: {
      completionStatus: subject.completionStatus as CompletionStatus,
      semesterTaken: subject.semesterTaken ?? '',
      finalGrade: subject.finalGrade ?? (null as unknown as number),
    },
  })

  const status = watch('completionStatus')

  const onSubmit = (data: FormData) => {
    mutate({
      subjectId: subject.subjectId,
      completionStatus: data.completionStatus as CompletionStatus,
      semesterTaken: data.semesterTaken || null,
      finalGrade: data.finalGrade,
    })
  }

  if (isSuccess) setTimeout(onClose, 600)

  const apiError = (error as { response?: { data?: { detail?: string } } })?.response?.data?.detail

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 px-4">
      <div className="w-full max-w-sm rounded-xl border border-gray-200 bg-white p-6 shadow-xl">
        <h3 className="mb-1 text-base font-semibold text-gray-900">Atualizar progresso</h3>
        <p className="mb-5 text-sm text-gray-500">
          {subject.subjectName || 'Disciplina #' + subject.subjectId}
        </p>

        {isSuccess && (
          <div className="mb-4 rounded-lg bg-emerald-50 p-3 text-sm text-emerald-700">
            Atualizado com sucesso!
          </div>
        )}
        {apiError && (
          <div className="mb-4 rounded-lg bg-red-50 p-3 text-sm text-red-700">{apiError}</div>
        )}

        <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">Status</label>
            <select
              {...register('completionStatus')}
              className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm outline-none focus:border-primary-500 focus:ring-2 focus:ring-primary-100"
            >
              <option value="Pending">Pendente</option>
              <option value="InProgress">Em Andamento</option>
              <option value="Completed">Concluída</option>
              <option value="Failed">Reprovada</option>
            </select>
          </div>

          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">
              Semestre cursado <span className="text-gray-400">(opcional)</span>
            </label>
            <input
              {...register('semesterTaken')}
              type="text"
              placeholder="ex: 2024.1"
              className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm outline-none focus:border-primary-500 focus:ring-2 focus:ring-primary-100"
            />
          </div>

          {(status === 'Completed' || status === 'Failed') && (
            <div>
              <label className="mb-1 block text-sm font-medium text-gray-700">
                Nota final <span className="text-gray-400">(0.0 – 10.0)</span>
              </label>
              <input
                {...register('finalGrade')}
                type="number"
                step="0.1"
                min="0"
                max="10"
                placeholder="7.5"
                className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm outline-none focus:border-primary-500 focus:ring-2 focus:ring-primary-100"
              />
              {errors.finalGrade && (
                <p className="mt-1 text-xs text-red-600">{errors.finalGrade.message as string}</p>
              )}
            </div>
          )}

          <div className="flex gap-3 pt-2">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 rounded-lg border border-gray-200 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 transition-colors"
            >
              Cancelar
            </button>
            <button
              type="submit"
              disabled={isPending}
              className="flex flex-1 items-center justify-center gap-2 rounded-lg bg-primary-600 px-4 py-2 text-sm font-medium text-white hover:bg-primary-700 disabled:opacity-60 transition-colors"
            >
              {isPending && <Spinner size="sm" />}
              {isPending ? 'Salvando...' : 'Salvar'}
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}

function ProgressList({ enrollment }: { enrollment: EnrollmentResponse }) {
  const [filter, setFilter] = useState<Status | 'All'>('All')
  const [editing, setEditing] = useState<ProgressResponse | null>(null)

  const progress = enrollment.progresses
  const filtered = filter === 'All' ? progress : progress.filter((p) => p.completionStatus === filter)
  const counts = ALL_STATUSES.reduce(
    (acc, s) => ({ ...acc, [s]: progress.filter((p) => p.completionStatus === s).length }),
    {} as Record<Status, number>,
  )

  return (
    <div className="space-y-4">
      {editing && (
        <EditModal
          subject={editing}
          enrollmentId={enrollment.enrollmentId}
          onClose={() => setEditing(null)}
        />
      )}

      <div className="flex flex-wrap gap-2">
        <button
          onClick={() => setFilter('All')}
          className={'rounded-full border px-4 py-1.5 text-sm font-medium transition-colors ' + (filter === 'All' ? 'border-primary-600 bg-primary-50 text-primary-700' : 'border-gray-200 bg-white text-gray-600 hover:bg-gray-50')}
        >
          Todas ({progress.length})
        </button>
        {ALL_STATUSES.map((s) => (
          <button
            key={s}
            onClick={() => setFilter(s)}
            className={'rounded-full border px-4 py-1.5 text-sm font-medium transition-colors ' + (filter === s ? 'border-primary-600 bg-primary-50 text-primary-700' : 'border-gray-200 bg-white text-gray-600 hover:bg-gray-50')}
          >
            <StatusBadge status={s} /> {counts[s]}
          </button>
        ))}
      </div>

      {filtered.length === 0 ? (
        <div className="rounded-xl border border-dashed border-gray-300 bg-white p-10 text-center">
          <p className="text-sm text-gray-500">Nenhuma disciplina encontrada.</p>
        </div>
      ) : (
        <div className="rounded-xl border border-gray-200 bg-white shadow-sm">
          <ul className="divide-y divide-gray-50">
            {filtered.map((subject) => (
              <li
                key={subject.progressId}
                className="flex items-center justify-between px-5 py-4 hover:bg-gray-50 transition-colors"
              >
                <div className="min-w-0 flex-1">
                  <p className="truncate text-sm font-medium text-gray-800">
                    {subject.subjectName || 'Disciplina #' + subject.subjectId}
                  </p>
                  <div className="mt-1 flex items-center gap-2">
                    <StatusBadge status={subject.completionStatus as Status} />
                    {subject.semesterTaken && (
                      <span className="text-xs text-gray-400">{subject.semesterTaken}</span>
                    )}
                    {subject.subjectCode && (
                      <span className="text-xs text-gray-400">{subject.subjectCode}</span>
                    )}
                  </div>
                </div>
                <div className="ml-4 flex items-center gap-4">
                  {subject.finalGrade != null && (
                    <span className={'text-lg font-bold ' + (subject.finalGrade >= 5 ? 'text-emerald-600' : 'text-red-600')}>
                      {subject.finalGrade.toFixed(1)}
                    </span>
                  )}
                  <button
                    onClick={() => setEditing(subject)}
                    className="rounded-lg border border-gray-200 px-3 py-1.5 text-xs font-medium text-gray-600 hover:bg-gray-100 transition-colors"
                  >
                    Editar
                  </button>
                </div>
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  )
}

export function ProgressPage() {
  const { data: enrollments, isLoading } = useDashboard()
  const [selectedId, setSelectedId] = useState<number | null>(null)

  if (isLoading) return <FullPageSpinner />

  if (!enrollments?.length) {
    return (
      <div className="rounded-xl border border-gray-200 bg-white p-10 text-center">
        <p className="text-gray-500">Nenhuma matrícula encontrada.</p>
      </div>
    )
  }

  const activeId = selectedId ?? enrollments[0].enrollmentId
  const activeEnrollment = enrollments.find((e) => e.enrollmentId === activeId) ?? enrollments[0]

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Progresso por Disciplina</h1>
        <p className="mt-0.5 text-sm text-gray-500">
          Atualize o status e a nota de cada disciplina
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

      {enrollments.length === 1 && (
        <div className="flex items-center gap-2 text-sm text-gray-500">
          <span className="font-medium text-gray-700">
            {activeEnrollment.institutionAcronym || activeEnrollment.institutionName}
          </span>
          <span>·</span>
          <span>{activeEnrollment.programName}</span>
        </div>
      )}

      <ProgressList key={activeEnrollment.enrollmentId} enrollment={activeEnrollment} />
    </div>
  )
}
