<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import '@/styles/admin.css'

const auth = useAuthStore()
const route = useRoute()
const router = useRouter()
const username = ref('')
const password = ref('')

onMounted(() => {
  document.documentElement.classList.remove('theme-noir')
})

async function submit(): Promise<void> {
  const ok = await auth.loginAdmin(username.value, password.value)
  if (!ok) {
    return
  }

  const redirect = typeof route.query.redirect === 'string' ? route.query.redirect : ''
  await router.push(redirect.startsWith('/admin') ? redirect : { name: 'admin-home' })
}
</script>

<template>
  <div class="admin-login">
    <form class="admin-login__card admin-form" @submit.prevent="submit">
      <h1>Administración</h1>
      <p>Acceso exclusivo del administrador.</p>
      <p v-if="auth.error" class="admin-error">{{ auth.error }}</p>
      <label>
        Usuario o email
        <input v-model="username" type="text" autocomplete="username" required />
      </label>
      <label>
        Contraseña
        <input v-model="password" type="password" autocomplete="current-password" required />
      </label>
      <button class="admin-btn" type="submit" :disabled="auth.loading">
        {{ auth.loading ? 'Entrando…' : 'Entrar' }}
      </button>
    </form>
  </div>
</template>
