import { Routes, Route, Navigate } from 'react-router-dom'
import { ProtectedRoute } from '../auth/ProtectedRoute'
import { Layout } from '../../shared/components/Layout'
import { LoginPage } from '../../features/auth/pages/LoginPage'
import { RegisterPage } from '../../features/auth/pages/RegisterPage'
import { DashboardPage } from '../../features/dashboard/pages/DashboardPage'
import { CurriculumPage } from '../../features/curriculum/pages/CurriculumPage'
import { ProgressPage } from '../../features/progress/pages/ProgressPage'
import { RecommendationsPage } from '../../features/recommendations/pages/RecommendationsPage'
import { ComparisonPage } from '../../features/comparison/pages/ComparisonPage'
import { PlanningPage } from '../../features/planning/pages/PlanningPage'
import { MultiplePlanningPage } from '../../features/multipleplanning/pages/MultiplePlanningPage'
import { MultipleTargetsPlanningPage } from '../../features/multipletargetsplanning/pages/MultipleTargetsPlanningPage'

export function AppRouter() {
  return (
    <Routes>
      <Route path="/login" element={<LoginPage />} />
      <Route path="/register" element={<RegisterPage />} />

      <Route element={<ProtectedRoute />}>
        <Route element={<Layout />}>
          <Route path="/dashboard"          element={<DashboardPage />} />
          <Route path="/curriculum"         element={<CurriculumPage />} />
          <Route path="/progress"           element={<ProgressPage />} />
          <Route path="/recommendations"    element={<RecommendationsPage />} />
          <Route path="/comparison"         element={<ComparisonPage />} />
          <Route path="/planning"           element={<PlanningPage />} />
          <Route path="/multiple-planning"         element={<MultiplePlanningPage />} />
          <Route path="/multiple-targets-planning" element={<MultipleTargetsPlanningPage />} />
        </Route>
      </Route>

      <Route path="/" element={<Navigate to="/dashboard" replace />} />
      <Route path="*" element={<Navigate to="/dashboard" replace />} />
    </Routes>
  )
}
