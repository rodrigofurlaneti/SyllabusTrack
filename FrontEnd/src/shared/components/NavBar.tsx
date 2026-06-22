import { Link, NavLink, useNavigate } from 'react-router-dom'
import { useAuthStore } from '../../core/auth/authStore'

const navItems = [
  { to: '/dashboard', label: 'Dashboard' },
  { to: '/curriculum', label: 'Grade Curricular' },
  { to: '/progress', label: 'Progresso' },
  { to: '/recommendations', label: 'Proximos Cursos' },
]

export function NavBar() {
  const user = useAuthStore((s) => s.user)
  const logout = useAuthStore((s) => s.logout)
  const navigate = useNavigate()

  function handleLogout() {
    logout()
    navigate('/login')
  }

  return (
    <header className="sticky top-0 z-10 border-b border-gray-200 bg-white shadow-sm">
      <div className="mx-auto flex h-14 max-w-7xl items-center justify-between px-4 sm:px-6">
        <Link to="/dashboard" className="flex items-center gap-2">
          <span className="text-lg font-bold tracking-tight text-primary-600">SyllabusTrack</span>
        </Link>

        <nav className="hidden items-center gap-1 sm:flex">
          {navItems.map(({ to, label }) => (
            <NavLink
              key={to}
              to={to}
              className={({ isActive }) =>
                'rounded-md px-3 py-1.5 text-sm font-medium transition-colors ' +
                (isActive ? 'bg-primary-50 text-primary-700' : 'text-gray-600 hover:bg-gray-100 hover:text-gray-900')
              }
            >
              {label}
            </NavLink>
          ))}
        </nav>

        <div className="flex items-center gap-3">
          <span className="hidden text-sm text-gray-500 sm:block">
            {user?.fullName ?? user?.username}
          </span>
          <button
            onClick={handleLogout}
            className="rounded-md border border-gray-200 px-3 py-1.5 text-sm font-medium text-gray-700 hover:bg-gray-100 transition-colors"
          >
            Sair
          </button>
        </div>
      </div>

      <nav className="flex gap-1 overflow-x-auto px-4 pb-2 sm:hidden">
        {navItems.map(({ to, label }) => (
          <NavLink
            key={to}
            to={to}
            className={({ isActive }) =>
              'rounded-md px-3 py-1.5 text-sm font-medium whitespace-nowrap transition-colors ' +
              (isActive ? 'bg-primary-50 text-primary-700' : 'text-gray-600 hover:bg-gray-100')
            }
          >
            {label}
          </NavLink>
        ))}
      </nav>
    </header>
  )
}
