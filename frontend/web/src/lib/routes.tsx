import toast from 'react-hot-toast'
import { createBrowserRouter, Navigate } from 'react-router-dom'

import Navbar from './components/navbar'
import LoginPage from './pages/auth/presentation/Login'
import AddItem from './pages/home/presentation/AddItem'
import Bill from './pages/home/presentation/Bill'
import Home from './pages/home/presentation/Home'
import Profile from './pages/home/presentation/Profile'
import Transactions from './pages/home/presentation/Transactions'
import appState from './utils/LocalStorage'

const ProtectedRoute = ({ children }: { children: React.ReactElement }) => {
  if (!appState.isLoggedIn) {
    toast.error('Log-in to access this route', {
      icon: '🪵'
    })
    return <Navigate to="/" />
  }

  return (
    <>
      <Navbar />
      {children}
    </>
  )
}

const router = createBrowserRouter([
  {
    path: '/auth',
    element: <LoginPage />
  },

  {
    path: '/home',
    element: (
      <ProtectedRoute>
        <Home />
      </ProtectedRoute>
    )
  },
  {
    path: '/add',
    element: (
      <ProtectedRoute>
        <AddItem />
      </ProtectedRoute>
    )
  },
  {
    path: '/bill',
    element: (
      <ProtectedRoute>
        <Bill />
      </ProtectedRoute>
    )
  },
  {
    path: '/transactions',
    element: (
      <ProtectedRoute>
        <Transactions />
      </ProtectedRoute>
    )
  },
  {
    path: '/profile',
    element: (
      <ProtectedRoute>
        <Profile />
      </ProtectedRoute>
    )
  },
  {
    path: '*',
    element: <LoginPage />
  }
])

export default router
