import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { curriculumApi } from '../../curriculum/api/curriculumApi'
import { useMultipleTargetsPlanning } from '../hooks/useMultipleTargetsPlanning'
import type { SemesterPlanItem } from '../../planning/api/planningApi'
import type {
  MultipleTargetsPlanningResult,
  TargetProgramResult,
  SourceProgramSummary,
} from '../api/multipleTargetsPlanningApi'

// ─── helpers ──────────────────────────────────────────────────────────────────

function semesterStatus(s: SemesterPlanItem): 'full' | 'partial' | 'none' {
  if (s.isFullyCreditable)   return 'full'
  if (s.matchedSubjects > 0) return 'partial'
  return 'none'
}

const STATUS_CONFIG = {
  full:    { bg: 'bg-green-50',  border: 'border-green-300',  badge: 'bg-green-500 text-white',  label: '100% Creditado',     dot: 'bg-green-500'  },
  partial: { bg: 'bg-yellow-50', border: 'border-yellow-300', badge: 'bg-yellow-400 text-white', label: 'Parcial',            dot: 'bg-yellow-400' },
  none:    { bg: 'bg-red-50',    border: 'border-red-200',    badge: 'bg-red-400 text-white',    label: 'Sem aproveitamento', dot: 'bg-red-400'    },
}

function PctBar({ pct, colorClass }: { pct: number; colorClass: string }) {
  return (
    <div className="h-2 w-full overflow-hidden rounded-full bg-gray-100">
      <div
        className={`h-2 rounded-full transition-all duration-700 ${colorClass}`}
        style={{ width: `${Math.min(pct, 100)}%` }}
      />
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
      <button
        className="w-full flex items-center justify-between px-4 py-3 text-left hover:brightness-95 transition-all"
        onClick={() => setOpen((v) => !v)}
      >
        <div className="flex items-center gap-3 min-w-0">
          <span className={`flex-shrink-0 rounded-full px-2.5 py-0.5 text-xs font-bold ${cfg.badge}`}>
            {sem.termNumber}º Sem
          </span>
          <span className="text-sm font-medium text-gray-800">
            {sem.matchedSubjects}/{sem.totalSubjects} creditadas
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

      <div className="px-4 pb-2">
        <PctBar
          pct={sem.subjectMatchPercentage}
          colorClass={
            status === 'full' ? 'bg-green-500' :
            status === 'partial' ? 'bg-yellow-400' : 'bg-red-400'
          }
        />
      </div>

      {open && (
        <div className="border-t border-gray-200 bg-white divide-y divide-gray-50">
          {sem.subjects.map((s) => (
            <div key={s.subjectName} className="flex items-center justify-between px-4 py-2 text-sm">
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

// ─── Source tag ────────────────────────────────────────────────────────────────

function SourceTag({ source }: { source: SourceProgramSummary }) {
  return (
    <span className="inline-flex items-center gap-1.5 rounded-full bg-primary-100 px-3 py-1 text-xs font-medium text-primary-800">
      <span className="h-1.5 w-1.5 rounded-full bg-primary-500" />
      {source.programName}
      <span className="text-primary-500">({source.institutionName})</span>
    </span>
  )
}

// ─── Target result card (accordion) ───────────────────────────────────────────

function TargetResultCard({
  result,
  index,
}: {
  result: TargetProgramResult
  index: number
}) {
  const [open, setOpen] = useState(index === 0) // primeiro aberto por padrão

  const pct     = result.subjectMatchPercentage
  const barColor = pct >= 60 ? 'bg-green-500' : pct >= 30 ? 'bg-yellow-400' : 'bg-red-400'
  const bdgColor = pct >= 60 ? 'bg-green-100 text-green-800' : pct >= 30 ? 'bg-yellow-100 text-yellow-800' : 'bg-red-100 text-red-800'

  return (
    <div className="rounded-xl border border-gray-200 bg-white shadow-sm overflow-hidden">
      {/* Header do card — clicável para expandir */}
      <button
        className="w-full flex items-center justify-between px-5 py-4 text-left hover:bg-gray-50 transition-colors"
        onClick={() => setOpen((v) => !v)}
      >
        <div className="flex items-center gap-3 min-w-0">
          <span className="flex-shrink-0 flex h-8 w-8 items-center justify-center rounded-full bg-primary-100 text-primary-700 text-sm font-bold">
            {index + 1}
          </span>
          <div className="min-w-0">
            <p className="font-semibold text-gray-900 truncate">{result.targetProgramName}</p>
            <p className="text-xs text-gray-500">{result.targetInstitutionName}</p>
          </div>
        </div>
        <div className="flex items-center gap-3 flex-shrink-0">
          <span className={`rounded-full px-3 py-0.5 text-sm font-bold ${bdgColor}`}>
            {pct.toFixed(1)}%
          </span>
          <span className="hidden sm:block text-sm text-gray-600">
            {result.estimatedYears === 0.5 ? '6 meses' : `${result.estimatedYears} ano${result.estimatedYears !== 1 ? 's' : ''}`}
          </span>
          <svg
            className={`h-4 w-4 text-gray-400 transition-transform ${open ? 'rotate-180' : ''}`}
            viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2}
          >
            <path d="M6 9l6 6 6-6" />
          </svg>
        </div>
      </button>

      {open && (
        <div className="border-t border-gray-100 px-5 py-4 space-y-4">

          {/* Estimativa rápida */}
          <div className="rounded-lg border border-primary-200 bg-gradient-to-r from-primary-50 to-indigo-50 px-4 py-3">
            <p className="text-2xl font-bold text-gray-900">
              {result.estimatedYears === 0.5
                ? '6 meses'
                : `${result.estimatedYears} ano${result.estimatedYears !== 1 ? 's' : ''}`}
            </p>
            <p className="text-sm text-gray-600">
              para concluir <strong>{result.targetProgramName}</strong>
            </p>
            {result.yearsSaved > 0 && (
              <p className="mt-1.5 inline-flex items-center gap-1 rounded-full bg-green-100 px-3 py-1 text-xs font-medium text-green-800">
                🏃 {result.yearsSaved} ano{result.yearsSaved !== 1 ? 's' : ''} a menos (duração original: {result.originalYears} anos)
              </p>
            )}
          </div>

          {/* Métricas */}
          <div className="grid grid-cols-2 gap-3 sm:grid-cols-4">
            {[
              { label: 'Semestres necessários', value: result.effectiveSemestersNeeded, sub: `de ${result.targetTotalSemesters}` },
              { label: 'Semestres creditados',  value: result.semestersFullyCreditable,  sub: '100% aproveitados'                },
              { label: 'Disciplinas restantes', value: result.remainingSubjects,          sub: `de ${result.targetTotalSubjects}` },
              { label: 'Horas restantes',       value: `${result.remainingHours}h`,       sub: `de ${result.targetTotalHours}h`  },
            ].map(({ label, value, sub }) => (
              <div key={label} className="rounded-lg border border-gray-200 bg-gray-50 p-3 text-center">
                <p className="text-xl font-bold text-gray-900">{value}</p>
                <p className="mt-0.5 text-xs font-medium text-gray-600">{label}</p>
                <p className="text-xs text-gray-400">{sub}</p>
              </div>
            ))}
          </div>

          {/* Barras de aproveitamento */}
          <div className="grid grid-cols-1 gap-3 sm:grid-cols-2">
            {[
              {
                label:    'Aproveitamento por Disciplinas',
                pct:      result.subjectMatchPercentage,
                sublabel: `${result.matchedSubjects} de ${result.targetTotalSubjects} cobertas`,
              },
              {
                label:    'Aproveitamento por Carga Horária',
                pct:      result.hoursMatchPercentage,
                sublabel: `${result.matchedHours}h de ${result.targetTotalHours}h cobertas`,
              },
            ].map(({ label, pct: p, sublabel }) => {
              const bar = p >= 60 ? 'bg-green-500' : p >= 30 ? 'bg-yellow-400' : 'bg-red-400'
              const bdg = p >= 60 ? 'bg-green-100 text-green-800' : p >= 30 ? 'bg-yellow-100 text-yellow-800' : 'bg-red-100 text-red-800'
              return (
                <div key={label} className="rounded-lg border border-gray-200 bg-white p-4">
                  <div className="flex items-center justify-between mb-1.5">
                    <span className="text-sm font-medium text-gray-700">{label}</span>
                    <span className={`rounded-full px-2.5 py-0.5 text-xs font-bold ${bdg}`}>{p.toFixed(1)}%</span>
                  </div>
                  <PctBar pct={p} colorClass={bar} />
                  <p className="mt-1 text-xs text-gray-500">{sublabel}</p>
                </div>
              )
            })}
          </div>

          {/* Legenda */}
          <div className="flex flex-wrap gap-3 text-xs text-gray-500">
            {Object.entries(STATUS_CONFIG).map(([, cfg]) => (
              <span key={cfg.label} className="flex items-center gap-1.5">
                <span className={`inline-block h-2.5 w-2.5 rounded-full ${cfg.dot}`} />
                {cfg.label}
              </span>
            ))}
          </div>

          {/* Timeline por semestre */}
          <div>
            <h3 className="text-sm font-semibold text-gray-700 mb-2">
              📅 Plano por Semestre
            </h3>
            <div className="space-y-2">
              {result.semesterPlans.map((sem) => (
                <SemesterCard key={sem.termNumber} sem={sem} />
              ))}
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

// ─── Consolidated plan ────────────────────────────────────────────────────────
// Disciplinas restantes deduplicadas entre TODOS os cursos-alvo.
// Se "Inglês Instrumental" falta em Curso A e Curso B, você faz UMA vez.

interface ConsolidatedSubject {
  subjectName: string
  hours: number
  targetNames: string[]  // em quais alvos esta disciplina aparece como restante
}

function buildConsolidatedPlan(targetResults: TargetProgramResult[]): {
  subjects: ConsolidatedSubject[]
  uniqueSubjects: number
  uniqueHours: number
  sharedCount: number
} {
  // Itera todos os alvos e coleta disciplinas NÃO creditadas, preservando nome original
  const list: ConsolidatedSubject[] = []
  const seen = new Map<string, ConsolidatedSubject>()

  for (const target of targetResults) {
    for (const sem of target.semesterPlans) {
      for (const s of sem.subjects) {
        if (s.isMatched) continue    // já coberta pelos cursos-fonte — ignorar
        const key = s.subjectName.trim().toLowerCase()
        if (!seen.has(key)) {
          const entry: ConsolidatedSubject = {
            subjectName: s.subjectName,
            hours: s.hours,
            targetNames: [],
          }
          seen.set(key, entry)
          list.push(entry)
        }
        const entry = seen.get(key)!
        if (!entry.targetNames.includes(target.targetProgramName)) {
          entry.targetNames.push(target.targetProgramName)
        }
      }
    }
  }

  // Compartilhadas primeiro (valem para mais alvos), depois por nome
  list.sort(
    (a, b) => b.targetNames.length - a.targetNames.length || a.subjectName.localeCompare(b.subjectName)
  )

  return {
    subjects:       list,
    uniqueSubjects: list.length,
    uniqueHours:    list.reduce((acc, s) => acc + s.hours, 0),
    sharedCount:    list.filter((s) => s.targetNames.length > 1).length,
  }
}

function ConsolidatedPlanPanel({ targetResults }: { targetResults: TargetProgramResult[] }) {
  const [open, setOpen] = useState(true)
  const { subjects, uniqueSubjects, uniqueHours, sharedCount } = buildConsolidatedPlan(targetResults)

  const totalRawSubjects = targetResults.reduce((acc, t) => acc + t.remainingSubjects, 0)
  const totalRawHours    = targetResults.reduce((acc, t) => acc + t.remainingHours, 0)
  const savedSubjects    = totalRawSubjects - uniqueSubjects
  const savedHours       = totalRawHours    - uniqueHours

  return (
    <div className="rounded-xl border-2 border-indigo-300 bg-white shadow-sm overflow-hidden">
      <button
        className="w-full flex items-center justify-between px-5 py-4 text-left hover:bg-indigo-50 transition-colors"
        onClick={() => setOpen((v) => !v)}
      >
        <div className="flex items-center gap-3">
          <span className="text-lg">📋</span>
          <div>
            <p className="font-bold text-gray-900">Plano Consolidado (matérias únicas)</p>
            <p className="text-xs text-gray-500">
              Deduplicado entre todos os cursos-alvo — o que você realmente precisa fazer
            </p>
          </div>
        </div>
        <svg
          className={`h-4 w-4 text-gray-400 transition-transform ${open ? 'rotate-180' : ''}`}
          viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2}
        >
          <path d="M6 9l6 6 6-6" />
        </svg>
      </button>

      {open && (
        <div className="border-t border-indigo-100 px-5 py-4 space-y-4">

          {/* Resumo de economia */}
          <div className="grid grid-cols-2 gap-3 sm:grid-cols-4">
            <div className="rounded-lg border border-indigo-200 bg-indigo-50 p-3 text-center">
              <p className="text-2xl font-bold text-indigo-700">{uniqueSubjects}</p>
              <p className="text-xs font-medium text-indigo-600">Matérias únicas</p>
              <p className="text-xs text-indigo-400">a cursar no total</p>
            </div>
            <div className="rounded-lg border border-indigo-200 bg-indigo-50 p-3 text-center">
              <p className="text-2xl font-bold text-indigo-700">{uniqueHours}h</p>
              <p className="text-xs font-medium text-indigo-600">Horas únicas</p>
              <p className="text-xs text-indigo-400">carga real</p>
            </div>
            {sharedCount > 0 ? (
              <>
                <div className="rounded-lg border border-green-200 bg-green-50 p-3 text-center">
                  <p className="text-2xl font-bold text-green-700">{sharedCount}</p>
                  <p className="text-xs font-medium text-green-600">Matérias compartilhadas</p>
                  <p className="text-xs text-green-400">valem para 2+ cursos</p>
                </div>
                <div className="rounded-lg border border-green-200 bg-green-50 p-3 text-center">
                  <p className="text-2xl font-bold text-green-700">{savedSubjects}</p>
                  <p className="text-xs font-medium text-green-600">Repetições evitadas</p>
                  <p className="text-xs text-green-400">({savedHours}h economizadas)</p>
                </div>
              </>
            ) : (
              <div className="col-span-2 rounded-lg border border-gray-200 bg-gray-50 p-3 text-center">
                <p className="text-sm text-gray-500">Nenhuma matéria em comum entre os cursos-alvo</p>
              </div>
            )}
          </div>

          {/* Legenda */}
          <div className="flex flex-wrap gap-3 text-xs text-gray-500">
            <span className="flex items-center gap-1.5">
              <span className="inline-block h-2.5 w-2.5 rounded-full bg-indigo-400" />
              Exclusiva de um curso
            </span>
            <span className="flex items-center gap-1.5">
              <span className="inline-block h-2.5 w-2.5 rounded-full bg-green-500" />
              Compartilhada (vale para 2+ cursos)
            </span>
          </div>

          {/* Lista de matérias únicas */}
          <div className="rounded-lg border border-gray-200 overflow-hidden">
            <div className="bg-gray-50 px-4 py-2 text-xs font-semibold text-gray-600 flex items-center justify-between">
              <span>Disciplina</span>
              <span>Cursos / Horas</span>
            </div>
            <div className="divide-y divide-gray-100 max-h-96 overflow-y-auto">
              {subjects.map((s) => {
                const isShared = s.targetNames.length > 1
                return (
                  <div key={s.subjectName} className={`flex items-start justify-between px-4 py-2.5 text-sm ${isShared ? 'bg-green-50' : 'bg-white'}`}>
                    <div className="flex items-start gap-2 min-w-0">
                      <span className={`mt-0.5 flex-shrink-0 h-2 w-2 rounded-full ${isShared ? 'bg-green-500' : 'bg-indigo-400'}`} />
                      <div className="min-w-0">
                        <p className={`font-medium truncate ${isShared ? 'text-green-900' : 'text-gray-800'}`}>
                          {s.subjectName}
                        </p>
                        {isShared && (
                          <p className="text-xs text-green-600 mt-0.5">
                            Serve para: {s.targetNames.join(' · ')}
                          </p>
                        )}
                        {!isShared && (
                          <p className="text-xs text-gray-400 mt-0.5">{s.targetNames[0]}</p>
                        )}
                      </div>
                    </div>
                    <span className="flex-shrink-0 ml-4 text-xs text-gray-500 font-medium">{s.hours}h</span>
                  </div>
                )
              })}
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

// ─── Result panel ──────────────────────────────────────────────────────────────

function ResultPanel({ data }: { data: MultipleTargetsPlanningResult }) {
  return (
    <>
      {/* Banner fontes */}
      <div className="rounded-xl border border-primary-200 bg-gradient-to-r from-primary-50 to-indigo-50 px-5 py-4">
        <p className="text-xs font-semibold uppercase tracking-wide text-primary-600 mb-2">
          Cursos de Referência ({data.sourcePrograms.length})
        </p>
        <div className="flex flex-wrap gap-2">
          {data.sourcePrograms.map((s) => (
            <SourceTag key={s.programId} source={s} />
          ))}
        </div>
        <p className="mt-2 text-xs text-gray-500">
          UNIÃO das disciplinas aplicada contra {data.targetResults.length} curso{data.targetResults.length !== 1 ? 's' : ''}-alvo abaixo.
        </p>
      </div>

      {/* Plano consolidado — aparece PRIMEIRO quando há mais de 1 alvo */}
      {data.targetResults.length > 1 && (
        <ConsolidatedPlanPanel targetResults={data.targetResults} />
      )}

      {/* Cards por curso-alvo */}
      <div className="space-y-3">
        {data.targetResults.map((r, i) => (
          <TargetResultCard key={r.targetProgramId} result={r} index={i} />
        ))}
      </div>

      <p className="text-center text-xs text-gray-400">
        Aproveitamento calculado por correspondência de nome de disciplina (case-insensitive).
        Disciplinas com 0h desconsideradas. Duplicatas entre cursos-fonte eliminadas automaticamente.
        1 ano = 2 semestres letivos.
      </p>
    </>
  )
}

// ─── Main page ─────────────────────────────────────────────────────────────────

export function MultipleTargetsPlanningPage() {
  const [selectedSourceIds, setSelectedSourceIds] = useState<number[]>([])
  const [selectedTargetIds, setSelectedTargetIds] = useState<number[]>([])

  const programsQuery = useQuery({ queryKey: ['programs'],     queryFn: curriculumApi.getPrograms })
  const instQuery     = useQuery({ queryKey: ['institutions'], queryFn: curriculumApi.getInstitutions })

  const programs     = programsQuery.data ?? []
  const institutions = instQuery.data ?? []

  const { mutate, data, isPending, isError, reset } = useMultipleTargetsPlanning()

  function programLabel(id: number) {
    const p    = programs.find((x) => x.programId === id)
    if (!p) return ''
    const inst = institutions.find((i) => i.institutionId === p.institutionId)
    return inst ? `${p.programName} (${inst.institutionAcronym})` : p.programName
  }

  function toggleSource(id: number) {
    setSelectedSourceIds((prev) =>
      prev.includes(id) ? prev.filter((x) => x !== id) : [...prev, id]
    )
    reset()
  }

  function toggleTarget(id: number) {
    setSelectedTargetIds((prev) =>
      prev.includes(id) ? prev.filter((x) => x !== id) : [...prev, id]
    )
    reset()
  }

  function handleCalculate() {
    if (selectedSourceIds.length === 0 || selectedTargetIds.length === 0) return
    mutate({ sourceProgramIds: selectedSourceIds, targetProgramIds: selectedTargetIds })
  }

  function handleClear() {
    setSelectedSourceIds([])
    setSelectedTargetIds([])
    reset()
  }

  const canCalculate = selectedSourceIds.length > 0 && selectedTargetIds.length > 0

  // Programas que não foram selecionados como fonte ficam disponíveis para alvo e vice-versa
  const sourceOptions = programs.filter((p) => !selectedTargetIds.includes(p.programId))
  const targetOptions = programs.filter((p) => !selectedSourceIds.includes(p.programId))

  function CheckboxGrid({
    options,
    selectedIds,
    onToggle,
    disabledIds,
  }: {
    options: typeof programs
    selectedIds: number[]
    onToggle: (id: number) => void
    disabledIds: number[]
  }) {
    if (programsQuery.isLoading) return <p className="text-sm text-gray-400">Carregando…</p>
    return (
      <div className="grid grid-cols-1 gap-2 sm:grid-cols-2 max-h-52 overflow-y-auto pr-1">
        {options.map((p) => {
          const isSelected = selectedIds.includes(p.programId)
          const isDisabled = disabledIds.includes(p.programId)
          return (
            <label
              key={p.programId}
              className={`flex items-center gap-3 rounded-lg border px-3 py-2.5 cursor-pointer transition-all select-none
                ${isDisabled ? 'opacity-40 cursor-not-allowed' : 'hover:bg-gray-50'}
                ${isSelected ? 'border-primary-400 bg-primary-50' : 'border-gray-200 bg-white'}`}
            >
              <input
                type="checkbox"
                className="h-4 w-4 rounded text-primary-600 focus:ring-primary-500"
                checked={isSelected}
                disabled={isDisabled}
                onChange={() => !isDisabled && onToggle(p.programId)}
              />
              <span className={`text-sm ${isSelected ? 'font-medium text-primary-800' : 'text-gray-700'}`}>
                {programLabel(p.programId)}
              </span>
            </label>
          )
        })}
      </div>
    )
  }

  return (
    <div className="mx-auto max-w-4xl space-y-6">

      {/* Cabeçalho */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900">🎓 Planejamento Multi-Alvo</h1>
        <p className="mt-1 text-sm text-gray-500">
          Selecione os cursos já concluídos e os cursos que deseja fazer.
          O sistema calcula o aproveitamento combinado contra cada curso-alvo e estima o tempo de formatura.
        </p>
      </div>

      {/* Seletores */}
      <div className="rounded-xl border border-gray-200 bg-white p-5 shadow-sm space-y-5">

        {/* Cursos concluídos — fontes */}
        <div>
          <label className="block text-xs font-semibold text-gray-600 uppercase tracking-wide mb-1">
            Cursos Já Concluídos{' '}
            {selectedSourceIds.length > 0 && (
              <span className="ml-1 rounded-full bg-primary-600 px-2 py-0.5 text-white text-xs">
                {selectedSourceIds.length}
              </span>
            )}
          </label>
          <p className="text-xs text-gray-400 mb-3">Selecione os cursos que você já cursou (referência)</p>
          <CheckboxGrid
            options={sourceOptions}
            selectedIds={selectedSourceIds}
            onToggle={toggleSource}
            disabledIds={selectedTargetIds}
          />
        </div>

        <div className="border-t border-gray-100" />

        {/* Cursos desejados — alvos */}
        <div>
          <label className="block text-xs font-semibold text-gray-600 uppercase tracking-wide mb-1">
            Cursos que Deseja Cursar{' '}
            {selectedTargetIds.length > 0 && (
              <span className="ml-1 rounded-full bg-indigo-600 px-2 py-0.5 text-white text-xs">
                {selectedTargetIds.length}
              </span>
            )}
          </label>
          <p className="text-xs text-gray-400 mb-3">Selecione um ou mais cursos-alvo para analisar</p>
          <CheckboxGrid
            options={targetOptions}
            selectedIds={selectedTargetIds}
            onToggle={toggleTarget}
            disabledIds={selectedSourceIds}
          />
        </div>

        {/* Ações */}
        <div className="flex items-center gap-3 pt-1">
          <button
            onClick={handleCalculate}
            disabled={!canCalculate || isPending}
            className="rounded-lg bg-primary-600 px-5 py-2 text-sm font-medium text-white transition-colors hover:bg-primary-700 disabled:cursor-not-allowed disabled:opacity-40"
          >
            {isPending ? 'Calculando…' : 'Calcular Planejamento'}
          </button>
          {(data || isError) && (
            <button
              onClick={handleClear}
              className="text-sm text-gray-500 hover:text-gray-700 underline"
            >
              Limpar
            </button>
          )}
        </div>

        {/* Dicas */}
        {selectedSourceIds.length === 0 && (
          <p className="text-xs text-amber-600 bg-amber-50 rounded-lg px-3 py-2">
            💡 Selecione ao menos um curso concluído e ao menos um curso-alvo para calcular.
          </p>
        )}
        {selectedSourceIds.length > 0 && selectedTargetIds.length === 0 && (
          <p className="text-xs text-blue-600 bg-blue-50 rounded-lg px-3 py-2">
            🎯 Agora selecione ao menos um curso que você quer fazer.
          </p>
        )}
      </div>

      {/* Loading */}
      {isPending && (
        <div className="flex items-center justify-center py-16 text-gray-400">
          <svg className="mr-2 h-5 w-5 animate-spin" viewBox="0 0 24 24" fill="none">
            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
            <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z" />
          </svg>
          Calculando planejamento multi-alvo…
        </div>
      )}

      {/* Erro */}
      {isError && (
        <div className="rounded-lg bg-red-50 p-4 text-sm text-red-700">
          Erro ao calcular o planejamento. Verifique os cursos selecionados.
        </div>
      )}

      {/* Resultado */}
      {data && !isPending && <ResultPanel data={data} />}
    </div>
  )
}
