import { defineStore } from 'pinia'
import { computed, ref } from 'vue'
import { api, setStoredToken, getStoredToken, validationMessage } from '@/services/api'
import type { AuthUser } from '@/types/models'

export const useAuthStore = defineStore('auth', () => {
  const token = ref<string | null>(getStoredToken())
  const user = ref<AuthUser | null>(null)
  const error = ref('')
  const loading = ref(false)

  const isAuthenticated = computed(() => Boolean(token.value))
  const isAdmin = computed(() => Boolean(user.value?.is_admin))

  async function hydrate(): Promise<void> {
    if (!token.value) {
      return
    }

    try {
      const { data } = await api.get<AuthUser>('/user')
      user.value = data
    } catch {
      logout()
    }
  }

  async function login(username: string, password: string): Promise<boolean> {
    loading.value = true
    error.value = ''

    try {
      const { data } = await api.post<{ token: string; user: AuthUser }>('/login', {
        username,
        password,
      })
      token.value = data.token
      user.value = data.user
      setStoredToken(data.token)
      return true
    } catch (err) {
      error.value = validationMessage(err, 'Credenciales incorrectas.')
      return false
    } finally {
      loading.value = false
    }
  }

  async function register(payload: {
    nick: string
    email: string
    password: string
    department: string
  }): Promise<boolean> {
    loading.value = true
    error.value = ''

    try {
      const { data } = await api.post<{ token: string; user: AuthUser }>('/register', payload)
      token.value = data.token
      user.value = data.user
      setStoredToken(data.token)
      return true
    } catch (err) {
      error.value = validationMessage(err, 'No se pudo crear la cuenta.')
      return false
    } finally {
      loading.value = false
    }
  }

  async function updateDepartment(department: string): Promise<boolean> {
    loading.value = true
    error.value = ''

    try {
      const { data } = await api.patch<AuthUser>('/user', { department })
      user.value = data
      return true
    } catch (err) {
      error.value = validationMessage(err, 'No se pudo guardar el departamento.')
      return false
    } finally {
      loading.value = false
    }
  }

  async function loginAdmin(username: string, password: string): Promise<boolean> {
    const ok = await login(username, password)
    if (!ok) {
      return false
    }

    if (!user.value?.is_admin) {
      error.value = 'Esta cuenta no es administrador.'
      await logout()
      return false
    }

    return true
  }

  async function logout(): Promise<void> {
    try {
      if (token.value) {
        await api.post('/logout')
      }
    } catch {
      // El token local se limpia igual.
    }

    token.value = null
    user.value = null
    setStoredToken(null)
  }

  return {
    token,
    user,
    error,
    loading,
    isAuthenticated,
    isAdmin,
    hydrate,
    login,
    loginAdmin,
    register,
    updateDepartment,
    logout,
  }
})
