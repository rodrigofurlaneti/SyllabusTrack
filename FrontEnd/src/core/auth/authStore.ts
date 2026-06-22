import { create } from 'zustand'
import { persist } from 'zustand/middleware'

interface AuthUser {
  studentId: number
  fullName: string
  username: string
  email: string
}

interface AuthState {
  token: string | null
  user: AuthUser | null
  isAuthenticated: boolean
  login: (token: string) => void
  logout: () => void
}

/** Decodifica o payload de um JWT sem validar a assinatura (validação é feita no servidor). */
function decodeJwtPayload(token: string): Record<string, unknown> {
  try {
    const base64 = token.split('.')[1].replace(/-/g, '+').replace(/_/g, '/')
    return JSON.parse(atob(base64))
  } catch {
    return {}
  }
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      token: null,
      user: null,
      isAuthenticated: false,

      login(token) {
        const payload = decodeJwtPayload(token)
        const user: AuthUser = {
          studentId: Number(payload['sub'] ?? payload['nameid'] ?? 0),
          fullName: String(payload['name'] ?? payload['unique_name'] ?? ''),
          username: String(payload['unique_name'] ?? ''),
          email: String(payload['email'] ?? ''),
        }
        set({ token, user, isAuthenticated: true })
      },

      logout() {
        set({ token: null, user: null, isAuthenticated: false })
      },
    }),
    { name: 'syllabustrack-auth' },
  ),
)
