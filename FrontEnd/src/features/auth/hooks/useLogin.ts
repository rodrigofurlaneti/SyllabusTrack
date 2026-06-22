import { useMutation } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { authApi } from '../api/authApi'
import { useAuthStore } from '../../../core/auth/authStore'

export function useLogin() {
  const login = useAuthStore((s) => s.login)
  const navigate = useNavigate()

  return useMutation({
    mutationFn: authApi.login,
    onSuccess(data) {
      login(data.token)
      navigate('/dashboard')
    },
  })
}
