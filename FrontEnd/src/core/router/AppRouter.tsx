import { Routes, Route, Navigate } from 'react-router-dom'
import { ProtectedRoute } from '../auth/ProtectedRoute'
import { Layout } from '../../shared/components/Layout'
import { LoginPage } from '../../features/auth/pages/LoginPage'
import { RegisterPage } from '../../features/auth/pages/RegisterPage'
import { DashboardPage } from '../../features/dashboard/pages/DashboardPage'
import { CurriculumPage } from '../../features/curriculum/pages/CurriculumPage'
import { ProgressPage } from '../../features/progress/pages/ProgressPage'
import { RecommendationsPage } from '../../features/recommendations/pages/RecommendationsPage'

export function AppRouter() {
  return (
    <Routes>
      <Route path="/login" element={<LoginPage />} />
      <Route path="/register" element={<RegisterPage />} />

      <Route element={<ProtectedRoute />}>
        <Route element={<Layout />}>
          <Route path="/dashboard" element={<DashboardPage />} />
          <Route path="/curriculum" element={<CurriculumPage />} />
          <Route path="/progress" element={<ProgressPage />} />
          <Route path="/recommendations" element={<RecommendationsPage />} />
        </Route>
      </Route>

      <Route path="/" element={<Navigate to="/dashboard" replace />} />
      <Route path="*" element={<Navigate to="/dashboard" replace />} />
    </Routes>
  )
}
