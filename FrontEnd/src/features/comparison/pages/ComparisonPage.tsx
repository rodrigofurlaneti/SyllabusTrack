import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { curriculumApi } from '../../curriculum/api/curriculumApi'
import { useComparison } from '../hooks/useComparison'
import type { ComparedSubjectItem } from '../api/comparisonApi'

// ─── helpers ──────────────────────────────────────────────────────────────────

function pctColor(pct: number) {
  if (pct >= 60) return { bar: 'bg-green-500',  text: 'text-green-700',  badge: 'bg-green-100 text-green-800' }
  if (pct >= 30) return { bar: 'bg-yellow-400', text: 'text-yellow-700', badge: 'bg-yellow-100 text-yellow-800' }
  return          { bar: 'bg-red-400',    text: 'text-red-700',    badge: 'bg-red-100 text-red-800' }
}

function PercentBar({ label, pct, sublabel }: { label: string; pct: number; sublabel: string }) {
  const c = pctColor(pct)
  return (
    <div className="rounded-xl border border-gray-200 bg-white p-5 shadow-sm">
      <div className="flex items-center justify-between mb-2">
        <span className="text-sm font-medium text-gray-700">{label}</span>
        <span className={`rounded-full px-3 py-0.5 text-sm font-bold ${c.badge}`}>
          {pct.toFixed(1)}%
        </span>
      </div>
      <div className="h-3 w-full overflow-hidden rounded-full bg-gray-100">
        <div
          className={`h-3 rounded-full transition-all duration-700 ${c.bar}`}
          style={{ width: `${Math.min(pct, 100)}%` }}
        />
      </div>
      <p className="mt-1.5 text-xs text-gray-500">{sublabel}</p>
    </div>
  )
}

function SubjectList({
  title,
  subjects,
  icon,
  colorClass,
}: {
  title: string
  subjects: ComparedSubjectItem[]
  icon: string
  colorClass: string
}) {
  const byTerm = subjects.reduce<Record<number, ComparedSubjectItem[]>>((acc, s) => {
    ;(acc[s.termNumber] ??= []).push(s)
    return acc
  }, {})

  return (
    <div className="rounded-xl border border-gray-200 bg-white shadow-sm overflow-hidden">
      <div className={`px-5 py-3 flex items-center gap-2 ${colorClass}`}>
        <span className="text-base">{icon}</span>
        <span className="font-semibold text-sm">{title}</span>
        <span className="ml-auto text-xs font-medium opacity-80">
          {subjects.length} disciplina{subjects.length !== 1 ? 's' : ''}
        </span>
      </div>
      {subjects.length === 0 ? (
        <p className="px-5 py-6 text-center text-sm text-gray-400">Nenhuma disciplina nesta categoria.</p>
      ) : (
        <div className="divide-y divide-gray-100">
          {Object.entries(byTerm)
            .sort(([a], [b]) => Number(a) - Number(b))
            .map(([term, items]) => (
              <div key={term}>
                <p className="px-5 py-1.5 text-xs font-semibold text-gray-400 uppercase tracking-wide bg-gray-50">
                  {Number(term)}º Semestre
                </p>
                {items.map((s) => (
                  <div
                    key={s.subjectName}
                    className="flex items-center justify-between px-5 py-2.5 hover:bg-gray-50 transition-colors"
                  >
                    <span className="text-sm text-gray-800 truncate pr-4">{s.subjectName}</span>
                    <span className="flex-shrink-0 text-xs text-gray-500">{s.hours}h</span>
                  </div>
                ))}
              </div>
            ))}
        </div>
      )}
    </div>
  )
}

// ─── main page ────────────────────────────────────────────────────────────────

export function ComparisonPage() {
  const [sourceId, setSourceId] = useState<number | undefined>()
  const [targetId, setTargetId] = useState<number | undefined>()
  const [submitted, setSubmitted] = useState(false)

  const programsQuery = useQuery({
    queryKey: ['programs'],
    queryFn: curriculumApi.getPrograms,
  })

  const institutionsQuery = useQuery({
    queryKey: ['institutions'],
    queryFn: curriculumApi.getInstitutions,
  })

  const programs = programsQuery.data ?? []
  const institutions = institutionsQuery.data ?? []

  function programLabel(programId: number) {
    const p = programs.find((x) => x.programId === programId)
    if (!p) return ''
    const inst = institutions.find((i) => i.institutionId === p.institutionId)
    return inst ? `${p.programName} (${inst.institutionAcronym})` : p.programName
  }

  const { data, isLoading, isError } = useComparison(
    submitted ? sourceId : undefined,
    submitted ? targetId : undefined,
  )

  function handleCompare() {
    if (!sourceId || !targetId || sourceId === targetId) return
    setSubmitted(true)
  }

  function handleReset() {
    setSubmitted(false)
  }

  const matched   = data?.subjects.filter((s) => s.isMatched)  ?? []
  const remaining = data?.subjects.filter((s) => !s.isMatched) ?? []

  return (
    <div className="mx-auto max-w-4xl space-y-6">

      {/* Cabeçalho */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900">🔍 Comparação de Cursos</h1>
        <p className="mt-1 text-sm text-gray-500">
          Selecione um curso de referência e um curso-alvo para saber quanto do currículo
          você já cobriria ao concluir o curso de referência.
        </p>
      </div>

      {/* Seletores */}
      <div className="rounded-xl border border-gray-200 bg-white p-5 shadow-sm space-y-4">
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">

          {/* Curso de referência */}
          <div className="space-y-1">
            <label className="block text-xs font-semibold text-gray-600 uppercase tracking-wide">
              Curso de Referência
            </label>
            <p className="text-xs text-gray-400">O curso que você já cursou ou está cursando</p>
            <select
              className="mt-1 w-full rounded-lg border border-gray-300 bg-white px-3 py-2.5 text-sm shadow-sm focus:border-primary-500 focus:outline-none focus:ring-1 focus:ring-primary-500 disabled:bg-gray-50"
              value={sourceId ?? ''}
              onChange={(e) => {
                setSourceId(e.target.value ? Number(e.target.value) : undefined)
                setSubmitted(false)
              }}
              disabled={programsQuery.isLoading || institutionsQuery.isLoading}
            >
              <option value="">Selecione o curso...</option>
              {programs.map((p) => (
                <option key={p.programId} value={p.programId}>
                  {programLabel(p.programId)}
                </option>
              ))}
            </select>
          </div>

          {/* Curso-alvo */}
          <div className="space-y-1">
            <label className="block text-xs font-semibold text-gray-600 uppercase tracking-wide">
              Curso-Alvo
            </label>
            <p className="text-xs text-gray-400">O curso que você deseja ingressar</p>
            <select
              className="mt-1 w-full rounded-lg border border-gray-300 bg-white px-3 py-2.5 text-sm shadow-sm focus:border-primary-500 focus:outline-none focus:ring-1 focus:ring-primary-500 disabled:bg-gray-50"
              value={targetId ?? ''}
              onChange={(e) => {
                setTargetId(e.target.value ? Number(e.target.value) : undefined)
                setSubmitted(false)
              }}
              disabled={programsQuery.isLoading || institutionsQuery.isLoading}
            >
              <option value="">Selecione o curso...</option>
              {programs
                .filter((p) => p.programId !== sourceId)
                .map((p) => (
                  <option key={p.programId} value={p.programId}>
                    {programLabel(p.programId)}
                  </option>
                ))}
            </select>
          </div>
        </div>

        <div className="flex items-center gap-3">
          <button
            onClick={handleCompare}
            disabled={!sourceId || !targetId || sourceId === targetId || isLoading}
            className="rounded-lg bg-primary-600 px-5 py-2 text-sm font-medium text-white transition-colors hover:bg-primary-700 disabled:cursor-not-allowed disabled:opacity-40"
          >
            {isLoading ? 'Comparando…' : 'Comparar Cursos'}
          </button>
          {submitted && (
            <button
              onClick={handleReset}
              className="text-sm text-gray-500 hover:text-gray-700 underline"
            >
              Limpar
            </button>
          )}
        </div>

        {sourceId && targetId && sourceId === targetId && (
          <p className="text-xs text-red-500">Selecione cursos diferentes para comparar.</p>
        )}
      </div>

      {/* Loading */}
      {isLoading && (
        <div className="flex items-center justify-center py-16 text-gray-400">
          <svg className="mr-2 h-5 w-5 animate-spin" viewBox="0 0 24 24" fill="none">
            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
            <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z" />
          </svg>
          Comparando grades curriculares…
        </div>
      )}

      {/* Erro */}
      {isError && (
        <div className="rounded-lg bg-red-50 p-4 text-sm text-red-700">
          Erro ao comparar cursos. Verifique se os cursos selecionados estão cadastrados.
        </div>
      )}

      {/* Resultados */}
      {data && !isLoading && (
        <>
          {/* Cabeçalho do resultado */}
          <div className="rounded-xl border border-primary-100 bg-primary-50 px-5 py-4">
            <p className="text-sm text-primary-800">
              Ao concluir{' '}
              <strong>{data.sourceProgramName}</strong>
              {' '}({data.sourceInstitutionName}), você já cobriria{' '}
              <strong>{data.subjectMatchPercentage.toFixed(1)}%</strong> das disciplinas de{' '}
              <strong>{data.targetProgramName}</strong>
              {' '}({data.targetInstitutionName}).
            </p>
          </div>

          {/* Barras de progresso */}
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <PercentBar
              label="Aproveitamento por Disciplinas"
              pct={data.subjectMatchPercentage}
              sublabel={`${data.matchedSubjects} de ${data.targetTotalSubjects} disciplinas já cobertas`}
            />
            <PercentBar
              label="Aproveitamento por Carga Horária"
              pct={data.hoursMatchPercentage}
              sublabel={`${data.matchedHours}h de ${data.targetTotalHours}h já cobertas`}
            />
          </div>

          {/* Legenda */}
          <div className="flex flex-wrap gap-4 text-xs text-gray-500">
            <span className="flex items-center gap-1.5">
              <span className="inline-block h-2.5 w-2.5 rounded-full bg-green-500" />
              Alto aproveitamento (≥ 60%)
            </span>
            <span className="flex items-center gap-1.5">
              <span className="inline-block h-2.5 w-2.5 rounded-full bg-yellow-400" />
              Médio aproveitamento (30–60%)
            </span>
            <span className="flex items-center gap-1.5">
              <span className="inline-block h-2.5 w-2.5 rounded-full bg-red-400" />
              Baixo aproveitamento (&lt; 30%)
            </span>
          </div>

          {/* Listas de disciplinas */}
          <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">
            <SubjectList
              title="Disciplinas Já Cobertas"
              subjects={matched}
              icon="✅"
              colorClass="bg-green-50 text-green-800"
            />
            <SubjectList
              title="Disciplinas Pendentes"
              subjects={remaining}
              icon="📚"
              colorClass="bg-gray-50 text-gray-700"
            />
          </div>

          {/* Rodapé */}
          <p className="text-center text-xs text-gray-400">
            Comparação baseada em correspondência exata de nome de disciplina (sem diferenciação de maiúsculas/minúsculas).
            Disciplinas com carga horária zero são desconsideradas.
          </p>
        </>
      )}
    </div>
  )
}
