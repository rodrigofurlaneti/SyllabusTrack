import { apiClient } from '../../../core/api/client'
import type { LoginRequest, LoginResponse, RegisterRequest, RegisterResponse } from '../types/auth.types'

export const authApi = {
  login(body: LoginRequest) {
    return apiClient.post<LoginResponse>('/auth/login', body).then((r) => r.data)
  },
  register(body: RegisterRequest) {
    return apiClient.post<RegisterResponse>('/auth/register', body).then((r) => r.data)
  },
}
