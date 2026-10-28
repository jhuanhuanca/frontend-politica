<script setup lang="ts">
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import '@/styles/admin.css'

const router = useRouter()
const auth = useAuthStore()

onMounted(() => {
  document.documentElement.classList.remove('theme-noir')
})

async function logout(): Promise<void> {
  await auth.logout()
  await router.push({ name: 'admin-login' })
}
</script>

<template>
  <div class="admin-body">
    <div class="admin-shell">
      <aside class="admin-side">
        <div class="admin-brand">
          <img src="/brand/enagenda-logo.png" alt="EnAgenda" />
        </div>
        <nav class="admin-nav">
          <RouterLink :to="{ name: 'admin-home' }">Resumen</RouterLink>
          <RouterLink :to="{ name: 'admin-debates' }">Debates</RouterLink>
          <RouterLink :to="{ name: 'admin-users' }">Usuarios</RouterLink>
          <RouterLink :to="{ name: 'admin-suggestions' }">Sugerencias</RouterLink>
          <RouterLink :to="{ name: 'admin-militants' }">Militantes</RouterLink>
          <RouterLink :to="{ name: 'admin-votes' }">Votos y firmas</RouterLink>
          <RouterLink :to="{ name: 'admin-ads' }">Anuncios</RouterLink>
        </nav>
        <div class="admin-side__foot">
          <span class="admin-muted" style="margin: 0">{{ auth.user?.nick }}</span>
          <RouterLink to="/">Ver sitio</RouterLink>
          <button type="button" @click="logout">Salir</button>
        </div>
      </aside>
      <section class="admin-main">
        <RouterView />
      </section>
    </div>
  </div>
</template>
