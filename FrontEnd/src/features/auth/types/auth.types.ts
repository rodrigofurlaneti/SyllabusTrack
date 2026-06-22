export interface LoginRequest {
  emailOrUsername: string
  password: string
}

export interface LoginResponse {
  token: string
}

export interface RegisterRequest {
  fullName: string
  username: string
  email: string
  phoneNumber: string
  password: string
}

export interface RegisterResponse {
  studentId: number
}
