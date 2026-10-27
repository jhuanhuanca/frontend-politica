<script setup lang="ts">
import { watch } from 'vue'
import { useAuthStore } from '@/stores/auth'
import AuthForm from '@/components/magazine/AuthForm.vue'

const auth = useAuthStore()

watch(
  () => auth.authModalOpen,
  (open) => {
    document.body.classList.toggle('auth-modal-open', open)
  },
)

function close(): void {
  auth.closeAuthModal()
}
</script>

<template>
  <Teleport to="body">
    <div v-if="auth.authModalOpen" class="auth-modal" @click.self="close">
      <div class="auth-modal__card" role="dialog" aria-modal="true" aria-labelledby="auth-modal-title">
        <button class="auth-modal__close" type="button" aria-label="Cerrar" @click="close">×</button>
        <h2 id="auth-modal-title">
          {{ auth.authModalMode === 'register' ? 'Creá tu cuenta para comentar' : 'Entrá al debate' }}
        </h2>
        <p class="form-lead">
          {{
            auth.authModalMode === 'register'
              ? 'Para publicar un argumento necesitás una cuenta. Es gratis y el nick es lo que se ve en el hilo.'
              : 'Usá tu nick o correo para entrar.'
          }}
        </p>
        <AuthForm :key="auth.authModalMode" :initial-mode="auth.authModalMode" @done="close" />
      </div>
    </div>
  </Teleport>
</template>
