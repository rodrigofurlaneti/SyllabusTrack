import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { Link } from 'react-router-dom'
import { useRegister } from '../hooks/useRegister'
import { Spinner } from '../../../shared/components/Spinner'

const schema = z
  .object({
    fullName: z.string().min(2, 'Nome muito curto'),
    username: z.string().min(3, 'Mínimo 3 caracteres').max(50),
    email: z.string().email('E-mail inválido'),
    phoneNumber: z.string().min(10, 'Informe o número com DDD'),
    password: z.string().min(6, 'Mínimo 6 caracteres'),
    confirmPassword: z.string(),
  })
  .refine((v) => v.password === v.confirmPassword, {
    message: 'As senhas não coincidem',
    path: ['confirmPassword'],
  })

type FormData = z.infer<typeof schema>

const fields = [
  { name: 'fullName' as const,        label: 'Nome completo',    type: 'text',     placeholder: 'João da Silva' },
  { name: 'username' as const,        label: 'Nome de usuário',  type: 'text',     placeholder: 'joaosilva' },
  { name: 'email' as const,           label: 'E-mail',           type: 'email',    placeholder: 'joao@email.com' },
  { name: 'phoneNumber' as const,     label: 'Celular',          type: 'tel',      placeholder: '(11) 99999-9999' },
  { name: 'password' as const,        label: 'Senha',            type: 'password', placeholder: '••••••••' },
  { name: 'confirmPassword' as const, label: 'Confirmar senha',  type: 'password', placeholder: '••••••••' },
]

export function RegisterPage() {
  const { mutate, isPending, error, isSuccess } = useRegister()

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<FormData>({ resolver: zodResolver(schema) })

  const onSubmit = ({ confirmPassword: _c, ...data }: FormData) => mutate(data)

  const apiError = (error as { response?: { data?: { detail?: string } } })?.response?.data?.detail

  return (
    <div className="flex min-h-screen items-center justify-center bg-gray-50 px-4 py-10">
      <div className="w-full max-w-sm">
        {/* Logo */}
        <div className="mb-8 text-center">
          <h1 className="text-2xl font-bold tracking-tight text-primary-600">SyllabusTrack</h1>
          <p className="mt-1 text-sm text-gray-500">Crie sua conta e comece a acompanhar</p>
        </div>

        <div className="rounded-xl border border-gray-200 bg-white p-8 shadow-sm">
          <h2 className="mb-6 text-lg font-semibold text-gray-900">Criar conta</h2>

          {isSuccess && (
            <div className="mb-4 rounded-lg bg-emerald-50 p-3 text-sm text-emerald-700 ring-1 ring-emerald-200">
              Conta criada! Redirecionando para o login...
            </div>
          )}

          {apiError && (
            <div className="mb-4 rounded-lg bg-red-50 p-3 text-sm text-red-700 ring-1 ring-red-200">
              {apiError}
            </div>
          )}

          <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
            {fields.map(({ name, label, type, placeholder }) => (
              <div key={name}>
                <label className="mb-1 block text-sm font-medium text-gray-700">{label}</label>
                <input
                  {...register(name)}
                  type={type}
                  placeholder={placeholder}
                  className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm outline-none transition focus:border-primary-500 focus:ring-2 focus:ring-primary-100"
                />
                {errors[name] && (
                  <p className="mt-1 text-xs text-red-600">{errors[name]?.message}</p>
                )}
              </div>
            ))}

            <button
              type="submit"
              disabled={isPending}
              className="flex w-full items-center justify-center gap-2 rounded-lg bg-primary-600 px-4 py-2 text-sm font-medium text-white hover:bg-primary-700 disabled:opacity-60 transition-colors"
            >
              {isPending && <Spinner size="sm" />}
              {isPending ? 'Criando...' : 'Criar conta'}
            </button>
          </form>
        </div>

        <p className="mt-4 text-center text-sm text-gray-500">
          Já tem conta?{' '}
          <Link to="/login" className="font-medium text-primary-600 hover:underline">
            Entrar
          </Link>
        </p>
      </div>
    </div>
  )
}
