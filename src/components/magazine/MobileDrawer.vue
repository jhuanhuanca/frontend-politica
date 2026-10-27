<script setup lang="ts">
import { onUnmounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const props = defineProps<{
  open: boolean
}>()

const emit = defineEmits<{
  close: []
}>()

const route = useRoute()
const auth = useAuthStore()

const links = [
  { to: '/debates', label: 'Debates' },
  { to: '/viejocracia', label: 'Viejocracia' },
  { to: '/votaciones', label: 'Votaciones' },
  { to: '/sugerencias', label: 'Sugerencias' },
]

watch(
  () => props.open,
  (value) => {
    document.body.classList.toggle('drawer-open', value)
  },
)

watch(
  () => route.fullPath,
  () => emit('close'),
)

onUnmounted(() => {
  document.body.classList.remove('drawer-open')
})

function openLogin(): void {
  auth.openAuthModal('login')
  emit('close')
}
</script>

<template>
  <Teleport to="body">
    <Transition name="drawer">
      <div v-if="open" class="drawer-root" @click.self="emit('close')">
        <button class="drawer-close" type="button" aria-label="Cerrar menú" @click="emit('close')">
          ×
        </button>
        <aside class="drawer-panel" role="dialog" aria-modal="true" aria-label="Menú">
          <nav class="drawer-nav">
            <RouterLink to="/" class="drawer-home" @click="emit('close')">Inicio</RouterLink>
            <RouterLink v-for="link in links" :key="link.to" :to="link.to" @click="emit('close')">
              {{ link.label }}
            </RouterLink>
            <RouterLink v-if="auth.user" to="/sugerencias" @click="emit('close')">
              {{ auth.user.nick }}
            </RouterLink>
            <a v-else href="#entrar" @click.prevent="openLogin">
              Entrar
            </a>
          </nav>
          <div class="drawer-foot">
            <div class="social-mini drawer-social">
              <a href="#" aria-label="Facebook">f</a>
              <a href="#" aria-label="Instagram">ig</a>
              <a href="#" aria-label="X">x</a>
              <a href="#" aria-label="LinkedIn">in</a>
            </div>
            <p>© {{ new Date().getFullYear() }} Todos los derechos reservados</p>
          </div>
        </aside>
      </div>
    </Transition>
  </Teleport>
</template>
