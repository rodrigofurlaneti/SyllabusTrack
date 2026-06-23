import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { curriculumApi } from '../../curriculum/api/curriculumApi'
import { usePlanning } from '../hooks/usePlanning'
import type { SemesterPlanItem } from '../api/planningApi'

// ─── helpers ──────────────────────────────────────────────────────────────────

function semesterStatus(s: SemesterPlanItem): 'full' | 'partial' | 'none' {
  if (s.isFullyCreditable)        return 'full'
  if (s.matchedSubjects > 0)      return 'partial'
  return 'none'
}

const STATUS_CONFIG = {
  full:    { bg: 'bg-green-50',  border: 'border-green-300',  badge: 'bg-green-500 text-white',  label: '100% Creditado',   dot: 'bg-green-500'  },
  partial: { bg: 'bg-yellow-50', border: 'border-yellow-300', badge: 'bg-yellow-400 text-white', label: 'Parcial',          dot: 'bg-yellow-400' },
  none:    { bg: 'bg-red-50',    border: 'border-red-200',    badge: 'bg-red-400 text-white',    label: 'Sem aproveitamento', dot: 'bg-red-400'  },
}

function PctBar({ pct, colorClass }: { pct: number; colorClass: string }) {
  return (
    <div className="h-2 w-full overflow-hidden rounded-full bg-gray-100">
      <div className={`h-2 rounded-full transition-all duration-700 ${colorClass}`}
           style={{ width: `${Math.min(pct, 100)}%` }} />
    </div>
  )
}

// ─── Semester card ─────────────────────────────────────────────────────────────

function SemesterCard({ sem }: { sem: SemesterPlanItem }) {
  const [open, setOpen] = useState(false)
  const status = semesterStatus(sem)
  const cfg    = STATUS_CONFIG[status]

  return (
    <div className={`rounded-xl border ${cfg.border} ${cfg.bg} overflow-hidden shadow-sm`}>
      {/* Header */}
      <button
        className="w-full flex items-center justify-between px-4 py-3 text-left hover:brightness-95 transition-all"
        onClick={() => setOpen((v) => !v)}
      >
        <div className="flex items-center gap-3 min-w-0">
          <span className={`flex-shrink-0 rounded-full px-2.5 py-0.5 text-xs font-bold ${cfg.badge}`}>
            {sem.termNumber}º Sem
          </span>
          <span className="text-sm font-medium text-gray-800">
            {sem.matchedSubjects}/{sem.totalSubjects} disciplinas creditadas
          </span>
          <span className="hidden sm:inline text-xs text-gray-500">
            ({sem.matchedHours}h / {sem.totalHours}h)
          </span>
        </div>

        <div className="flex items-center gap-2 flex-shrink-0">
          <span className="hidden sm:inline text-xs font-medium text-gray-600">
            {sem.subjectMatchPercentage.toFixed(0)}%
          </span>
          <svg
            className={`h-4 w-4 text-gray-400 transition-transform ${open ? 'rotate-180' : ''}`}
            viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2}
          >
            <path d="M6 9l6 6 6-6" />
          </svg>
        </div>
      </button>

      {/* Progress bar */}
      <div className="px-4 pb-2">
        <PctBar
          pct={sem.subjectMatchPercentage}
          colorClass={status === 'full' ? 'bg-green-500' : status === 'partial' ? 'bg-yellow-400' : 'bg-red-400'}
        />
      </div>

      {/* Subjects list */}
      {open && (
        <div className="border-t border-gray-200 bg-white divide-y divide-gray-50">
          {sem.subjects.map((s) => (
            <div
              key={s.subjectName}
              className="flex items-center justify-between px-4 py-2 text-sm"
            >
              <div className="flex items-center gap-2 min-w-0">
                <span className={`flex-shrink-0 text-base ${s.isMatched ? 'text-green-500' : 'text-red-400'}`}>
                  {s.isMatched ? '✓' : '✗'}
                </span>
                <span className={`truncate ${s.isMatched ? 'text-gray-600' : 'text-gray-800 font-medium'}`}>
                  {s.subjectName}
                </span>
              </div>
              <span className="flex-shrink-0 ml-4 text-xs text-gray-500">{s.hours}h</span>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

// ─── Main page ─────────────────────────────────────────────────────────────────

export function PlanningPage() {
  const [sourceId, setSourceId] = useState<number | undefined>()
  const [targetId, setTargetId] = useState<number | undefined>()
  const [submitted, setSubmitted] = useState(false)

  const programsQuery = useQuery({ queryKey: ['programs'],      queryFn: curriculumApi.getPrograms })
  const instQuery     = useQuery({ queryKey: ['institutions'],  queryFn: curriculumApi.getInstitutions })

  const programs     = programsQuery.data ?? []
  const institutions = instQuery.data ?? []

  function programLabel(id: number) {
    const p    = programs.find((x) => x.programId === id)
    if (!p) return ''
    const inst = institutions.find((i) => i.institutionId === p.institutionId)
    return inst ? `${p.programName} (${inst.institutionAcronym})` : p.programName
  }

  const { data, isLoading, isError } = usePlanning(
    submitted ? sourceId : undefined,
    submitted ? targetId : undefined,
  )

  const canCompare = !!sourceId && !!targetId && sourceId !== targetId

  return (
    <div className="mx-auto max-w-4xl space-y-6">

      {/* Cabeçalho */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900">🎓 Planejamento Acadêmico</h1>
        <p className="mt-1 text-sm text-gray-500">
          Informe o curso já concluído e o curso que deseja ingressar. O sistema calcula
          o aproveitamento por semestre e estima em quanto tempo você se formaria.
        </p>
      </div>

      {/* Seletores */}
      <div className="rounded-xl border border-gray-200 bg-white p-5 shadow-sm space-y-4">
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <div className="space-y-1">
            <label className="block text-xs font-semibold text-gray-600 uppercase tracking-wide">
              Curso Já Concluído
            </label>
            <p className="text-xs text-gray-400">O curso que você já fez (referência)</p>
            <select
              className="mt-1 w-full rounded-lg border border-gray-300 bg-white px-3 py-2.5 text-sm shadow-sm focus:border-primary-500 focus:outline-none focus:ring-1 focus:ring-primary-500 disabled:bg-gray-50"
              value={sourceId ?? ''}
              onChange={(e) => { setSourceId(e.target.value ? Number(e.target.value) : undefined); setSubmitted(false) }}
              disabled={programsQuery.isLoading}
            >
              <option value="">Selecione o curso...</option>
              {programs.map((p) => (
                <option key={p.programId} value={p.programId}>{programLabel(p.programId)}</option>
              ))}
            </select>
          </div>

          <div className="space-y-1">
            <label className="block text-xs font-semibold text-gray-600 uppercase tracking-wide">
              Curso que Deseja Cursar
            </label>
            <p className="text-xs text-gray-400">O curso-alvo para o planejamento</p>
            <select
              className="mt-1 w-full rounded-lg border border-gray-300 bg-white px-3 py-2.5 text-sm shadow-sm focus:border-primary-500 focus:outline-none focus:ring-1 focus:ring-primary-500 disabled:bg-gray-50"
              value={targetId ?? ''}
              onChange={(e) => { setTargetId(e.target.value ? Number(e.target.value) : undefined); setSubmitted(false) }}
              disabled={programsQuery.isLoading}
            >
              <option value="">Selecione o curso...</option>
              {programs.filter((p) => p.programId !== sourceId).map((p) => (
                <option key={p.programId} value={p.programId}>{programLabel(p.programId)}</option>
              ))}
            </select>
          </div>
        </div>

        <div className="flex items-center gap-3">
          <button
            onClick={() => setSubmitted(true)}
            disabled={!canCompare || isLoading}
            className="rounded-lg bg-primary-600 px-5 py-2 text-sm font-medium text-white transition-colors hover:bg-primary-700 disabled:cursor-not-allowed disabled:opacity-40"
          >
            {isLoading ? 'Calculando…' : 'Calcular Planejamento'}
          </button>
          {submitted && (
            <button onClick={() => setSubmitted(false)} className="text-sm text-gray-500 hover:text-gray-700 underline">
              Limpar
            </button>
          )}
        </div>
      </div>

      {/* Loading */}
      {isLoading && (
        <div className="flex items-center justify-center py-16 text-gray-400">
          <svg className="mr-2 h-5 w-5 animate-spin" viewBox="0 0 24 24" fill="none">
            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
            <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z" />
          </svg>
          Calculando planejamento acadêmico…
        </div>
      )}

      {isError && (
        <div className="rounded-lg bg-red-50 p-4 text-sm text-red-700">
          Erro ao calcular o planejamento. Verifique os cursos selecionados.
        </div>
      )}

      {data && !isLoading && (
        <>
          {/* ── Banner principal ── */}
          <div className="rounded-xl border border-primary-200 bg-gradient-to-r from-primary-50 to-indigo-50 px-6 py-5">
            <p className="text-xs font-semibold uppercase tracking-wide text-primary-600 mb-1">
              Estimativa de formatura
            </p>
            <p className="text-3xl font-bold text-gray-900">
              {data.estimatedYears === 0.5 ? '6 meses' : `${data.estimatedYears} ano${data.estimatedYears !== 1 ? 's' : ''}`}
            </p>
            <p className="mt-1 text-sm text-gray-600">
              para concluir <strong>{data.targetProgramName}</strong>
              {' '}({data.targetInstitutionName})
              {' '}aproveitando <strong>{data.sourceProgramName}</strong>
            </p>
            {data.yearsSaved > 0 && (
              <p className="mt-2 inline-flex items-center gap-1 rounded-full bg-green-100 px-3 py-1 text-xs font-medium text-green-800">
                🏃 {data.yearsSaved} ano{data.yearsSaved !== 1 ? 's' : ''} a menos que a duração original ({data.originalYears} anos)
              </p>
            )}
          </div>

          {/* ── Métricas ── */}
          <div className="grid grid-cols-2 gap-3 sm:grid-cols-4">
            {[
              { label: 'Semestres necessários', value: data.effectiveSemestersNeeded, sub: `de ${data.targetTotalSemesters}` },
              { label: 'Semestres creditados',  value: data.semestersFullyCreditable, sub: '100% aproveitados'               },
              { label: 'Disciplinas restantes', value: data.remainingSubjects,         sub: `de ${data.targetTotalSubjects}`  },
              { label: 'Horas restantes',       value: `${data.remainingHours}h`,      sub: `de ${data.targetTotalHours}h`   },
            ].map(({ label, value, sub }) => (
              <div key={label} className="rounded-xl border border-gray-200 bg-white p-4 shadow-sm text-center">
                <p className="text-2xl font-bold text-gray-900">{value}</p>
                <p className="mt-0.5 text-xs font-medium text-gray-600">{label}</p>
                <p className="text-xs text-gray-400">{sub}</p>
              </div>
            ))}
          </div>

          {/* ── Barras de aproveitamento ── */}
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
            {[
              {
                label:    'Aproveitamento por Disciplinas',
                pct:      data.subjectMatchPercentage,
                sublabel: `${data.matchedSubjects} de ${data.targetTotalSubjects} disciplinas já cobertas`,
              },
              {
                label:    'Aproveitamento por Carga Horária',
                pct:      data.hoursMatchPercentage,
                sublabel: `${data.matchedHours}h de ${data.targetTotalHours}h já cobertas`,
              },
            ].map(({ label, pct, sublabel }) => {
              const bar = pct >= 60 ? 'bg-green-500' : pct >= 30 ? 'bg-yellow-400' : 'bg-red-400'
              const bdg = pct >= 60 ? 'bg-green-100 text-green-800' : pct >= 30 ? 'bg-yellow-100 text-yellow-800' : 'bg-red-100 text-red-800'
              return (
                <div key={label} className="rounded-xl border border-gray-200 bg-white p-5 shadow-sm">
                  <div className="flex items-center justify-between mb-2">
                    <span className="text-sm font-medium text-gray-700">{label}</span>
                    <span className={`rounded-full px-3 py-0.5 text-sm font-bold ${bdg}`}>{pct.toFixed(1)}%</span>
                  </div>
                  <PctBar pct={pct} colorClass={bar} />
                  <p className="mt-1.5 text-xs text-gray-500">{sublabel}</p>
                </div>
              )
            })}
          </div>

          {/* ── Legenda ── */}
          <div className="flex flex-wrap gap-4 text-xs text-gray-500">
            {Object.entries(STATUS_CONFIG).map(([, cfg]) => (
              <span key={cfg.label} className="flex items-center gap-1.5">
                <span className={`inline-block h-2.5 w-2.5 rounded-full ${cfg.dot}`} />
                {cfg.label}
              </span>
            ))}
          </div>

          {/* ── Timeline por semestre ── */}
          <div>
            <h2 className="text-base font-semibold text-gray-800 mb-3">
              📅 Plano por Semestre — clique para ver as disciplinas
            </h2>
            <div className="space-y-2">
              {data.semesterPlans.map((sem) => (
                <SemesterCard key={sem.termNumber} sem={sem} />
              ))}
            </div>
          </div>

          <p className="text-center text-xs text-gray-400">
            Aproveitamento calculado por correspondência de nome de disciplina (case-insensitive).
            Disciplinas com 0h desconsideradas. 1 ano = 2 semestres letivos.
          </p>
        </>
      )}
    </div>
  )
}
