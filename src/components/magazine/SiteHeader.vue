<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import AdSlot from '@/components/magazine/AdSlot.vue'
import MobileDrawer from '@/components/magazine/MobileDrawer.vue'
import SearchModal from '@/components/magazine/SearchModal.vue'
import { useAuthStore } from '@/stores/auth'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()
const menuOpen = ref(false)
const searchOpen = ref(false)

const links = [
  { to: '/', label: 'Inicio' },
  { to: '/debates', label: 'Debates' },
  { to: '/viejocracia', label: 'Viejocracia' },
  { to: '/votaciones', label: 'Votaciones' },
  { to: '/sugerencias', label: 'Sugerencias' },
]

const sessionLabel = computed(() => (auth.user ? auth.user.nick : 'Entrar'))

onMounted(() => {
  menuOpen.value = false
})

function goAccount(): void {
  if (auth.isAuthenticated) {
    router.push('/sugerencias')
    return
  }
  if (route.path !== '/') {
    router.push({ path: '/', hash: 'login-widget' })
    return
  }
  document.getElementById('login-widget')?.scrollIntoView({ behavior: 'smooth' })
}

function isActive(to: string): boolean {
  if (to === '/') {
    return route.path === '/'
  }
  return route.path.startsWith(to)
}
</script>

<template>
  <header class="site-header" v-reveal="{ from: 'fade' }">
    <div class="row header-main">
      <button
        class="header-icon-btn header-search-btn"
        type="button"
        aria-label="Buscar"
        @click="searchOpen = true"
      >
        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.4">
          <circle cx="11" cy="11" r="7" />
          <path d="M20 20 16.5 16.5" />
        </svg>
      </button>

      <div class="header-left">
        <RouterLink to="/" class="logo">Viejo<span>cracia</span></RouterLink>
        <button
          class="header-icon-btn menu-toggle"
          type="button"
          aria-label="Menú"
          @click="menuOpen = true"
        >
          <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.4">
            <path d="M4 7h16M4 12h16M4 17h16" />
          </svg>
        </button>
        <ul class="main-nav">
          <li v-for="link in links" :key="link.to">
            <RouterLink :to="link.to" :class="{ 'router-link-active': isActive(link.to) }">
              {{ link.label }}
            </RouterLink>
          </li>
          <li>
            <a href="#login-widget" @click.prevent="goAccount">{{ sessionLabel }}</a>
          </li>
        </ul>
      </div>

      <div class="header-ad">
        <AdSlot header label="Espacio publicitario" />
      </div>
    </div>
  </header>

  <SearchModal v-model="searchOpen" />
  <MobileDrawer :open="menuOpen" @close="menuOpen = false" />
</template>
