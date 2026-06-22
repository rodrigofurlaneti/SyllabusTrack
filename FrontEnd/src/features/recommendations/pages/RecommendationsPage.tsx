import { useAuthStore } from '../../../core/auth/authStore'
import { useRecommendations } from '../hooks/useRecommendations'
import type { ProgramRecommendation } from '../api/recommendationsApi'

const MEDALS = ['🥇', '🥈', '🥉']

function matchColor(pct: number) {
  if (pct >= 60) return { bar: 'bg-green-500', badge: 'bg-green-100 text-green-800' }
  if (pct >= 30) return { bar: 'bg-yellow-400', badge: 'bg-yellow-100 text-yellow-800' }
  return { bar: 'bg-red-400', badge: 'bg-red-100 text-red-800' }
}

function RecommendationCard({
  item,
  rank,
}: {
  item: ProgramRecommendation
  rank: number
}) {
  const colors = matchColor(item.matchPercentage)
  const medal = MEDALS[rank] ?? null

  return (
    <div className="rounded-xl border border-gray-200 bg-white p-5 shadow-sm hover:shadow-md transition-shadow">
      {/* Header */}
      <div className="flex items-start justify-between gap-3">
        <div className="flex items-center gap-2 min-w-0">
          {medal && <span className="text-2xl flex-shrink-0">{medal}</span>}
          {!medal && (
            <span className="flex h-7 w-7 flex-shrink-0 items-center justify-center rounded-full bg-gray-100 text-xs font-bold text-gray-600">
              {rank + 1}
            </span>
          )}
          <div className="min-w-0">
            <h3 className="truncate text-base font-semibold text-gray-900">
              {item.programName}
            </h3>
            <p className="text-xs text-gray-500">
              {item.institutionName} · {item.curriculumVersion}
            </p>
          </div>
        </div>

        {/* Badge percentual */}
        <span
          className={`flex-shrink-0 rounded-full px-2.5 py-0.5 text-sm font-bold ${colors.badge}`}
        >
          {item.matchPercentage.toFixed(1)}%
        </span>
      </div>

      {/* Barra de progresso */}
      <div className="mt-4">
        <div className="mb-1 flex justify-between text-xs text-gray-500">
          <span>Aproveitamento</span>
          <span>
            {item.matchedSubjects} / {item.totalSubjects} disciplinas
          </span>
        </div>
        <div className="h-2 w-full overflow-hidden rounded-full bg-gray-100">
          <div
            className={`h-2 rounded-full transition-all ${colors.bar}`}
            style={{ width: `${Math.min(item.matchPercentage, 100)}%` }}
          />
        </div>
      </div>

      {/* Detalhes */}
      <div className="mt-3 flex gap-4 text-xs text-gray-500">
        <span>
          <span className="font-medium text-green-600">{item.matchedSubjects}</span>{' '}
          já cursadas
        </span>
        <span>
          <span className="font-medium text-gray-700">{item.remainingSubjects}</span>{' '}
          restantes
        </span>
        <span>
          <span className="font-medium text-gray-700">{item.totalSemesters}</span>{' '}
          semestres
        </span>
      </div>
    </div>
  )
}

export function RecommendationsPage() {
  const user = useAuthStore((s) => s.user)
  const { data, isLoading, isError } = useRecommendations(user?.studentId)

  return (
    <div className="mx-auto max-w-4xl space-y-6">
      {/* Cabeçalho */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900">
          🎓 Ranking de Cursos
        </h1>
        <p className="mt-1 text-sm text-gray-500">
          Cursos ordenados pelo aproveitamento das disciplinas que você já
          concluiu. Quanto maior o percentual, menos matérias você precisará
          cursar do zero.
        </p>
      </div>

      {/* Legenda */}
      <div className="flex flex-wrap gap-3 text-xs">
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

      {/* Estados */}
      {isLoading && (
        <div className="flex items-center justify-center py-16 text-gray-400">
          <svg className="mr-2 h-5 w-5 animate-spin" viewBox="0 0 24 24" fill="none">
            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
            <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z" />
          </svg>
          Calculando aproveitamento…
        </div>
      )}

      {isError && (
        <div className="rounded-lg bg-red-50 p-4 text-sm text-red-700">
          Erro ao carregar recomendações. Tente novamente.
        </div>
      )}

      {!isLoading && !isError && data?.length === 0 && (
        <div className="rounded-lg bg-gray-50 p-8 text-center text-sm text-gray-500">
          Nenhum curso disponível para recomendação.
        </div>
      )}

      {/* Ranking */}
      {data && data.length > 0 && (
        <div className="space-y-3">
          {data.map((item, idx) => (
            <RecommendationCard key={item.programId} item={item} rank={idx} />
          ))}
        </div>
      )}

      {/* Rodapé informativo */}
      {data && data.length > 0 && (
        <p className="text-center text-xs text-gray-400">
          {data.length} cursos analisados · Baseado em {' '}
          {data[0]
            ? `comparação por nome de disciplina`
            : ''}{' '}
          · Disciplinas Reprovadas não são contadas como concluídas
        </p>
      )}
    </div>
  )
}
