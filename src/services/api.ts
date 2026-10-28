import axios, { AxiosError } from 'axios'
import { echoSocketId } from '@/services/echo'

const TOKEN_KEY = 'enagenda.token'

export function getStoredToken(): string | null {
  return localStorage.getItem(TOKEN_KEY)
}

export function setStoredToken(token: string | null): void {
  if (token) {
    localStorage.setItem(TOKEN_KEY, token)
  } else {
    localStorage.removeItem(TOKEN_KEY)
  }
}

export const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || '/api/v1',
  headers: {
    Accept: 'application/json',
  },
})

api.interceptors.request.use((config) => {
  const token = getStoredToken()
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  const socketId = echoSocketId()
  if (socketId) {
    config.headers['X-Socket-Id'] = socketId
  }
  return config
})

export function validationMessage(error: unknown, fallback = 'No se pudo completar la acción.'): string {
  if (error instanceof AxiosError) {
    const data = error.response?.data as
      | { message?: string; errors?: Record<string, string[]> }
      | undefined
    const first = data?.errors ? Object.values(data.errors)[0]?.[0] : undefined
    return first || data?.message || fallback
  }

  return fallback
}
