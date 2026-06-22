type Status = 'Pending' | 'InProgress' | 'Completed' | 'Failed'

interface StatusBadgeProps {
  status: Status
}

const config: Record<Status, { label: string; classes: string }> = {
  Pending:    { label: 'Pendente',      classes: 'bg-gray-100 text-gray-600 ring-gray-200' },
  InProgress: { label: 'Em Andamento',  classes: 'bg-blue-50 text-blue-700 ring-blue-200' },
  Completed:  { label: 'Concluída',     classes: 'bg-emerald-50 text-emerald-700 ring-emerald-200' },
  Failed:     { label: 'Reprovada',     classes: 'bg-red-50 text-red-700 ring-red-200' },
}

export function StatusBadge({ status }: StatusBadgeProps) {
  const { label, classes } = config[status] ?? config.Pending
  return (
    <span className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ring-1 ring-inset ${classes}`}>
      {label}
    </span>
  )
}

export type { Status }
