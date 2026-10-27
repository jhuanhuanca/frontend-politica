<script setup lang="ts">
import { ref } from 'vue'
import { useAuthStore } from '@/stores/auth'
import WidgetBox from '@/components/magazine/WidgetBox.vue'
import { DEPARTMENTS } from '@/utils/bolivia'

const auth = useAuthStore()
const mode = ref<'login' | 'register'>('login')
const username = ref('')
const password = ref('')
const nick = ref('')
const email = ref('')
const department = ref('')

async function submitLogin(): Promise<void> {
  await auth.login(username.value, password.value)
}

async function submitRegister(): Promise<void> {
  const ok = await auth.register({
    nick: nick.value,
    email: email.value,
    password: password.value,
    department: department.value,
  })
  if (ok) {
    mode.value = 'login'
  }
}

async function saveDepartment(): Promise<void> {
  if (!department.value) {
    return
  }
  await auth.updateDepartment(department.value)
}
</script>

<template>
  <WidgetBox id="login-widget" title="Entrá al debate" from="right">
    <div v-if="auth.user" class="auth-form">
      <p>
        Hola, <strong>{{ auth.user.nick }}</strong>. Ya estás dentro: debatí, firmá o
        <RouterLink to="/sugerencias">sugerí un tema</RouterLink>.
      </p>
      <p v-if="auth.user.department" class="form-lead">Departamento: {{ auth.user.department }}</p>
      <form v-else @submit.prevent="saveDepartment">
        <p class="form-lead">Falta tu departamento para el mapa de liderazgos.</p>
        <p v-if="auth.error" class="form-error">{{ auth.error }}</p>
        <select v-model="department" required>
          <option value="" disabled>Departamento</option>
          <option v-for="item in DEPARTMENTS" :key="item" :value="item">{{ item }}</option>
        </select>
        <button type="submit" :disabled="auth.loading">
          {{ auth.loading ? 'Guardando…' : 'Guardar departamento' }}
        </button>
      </form>
      <button type="button" @click="auth.logout()">Cerrar sesión</button>
    </div>

    <form v-else-if="mode === 'login'" class="auth-form" @submit.prevent="submitLogin">
      <p v-if="auth.error" class="form-error">{{ auth.error }}</p>
      <input v-model="username" type="text" placeholder="Usuario o email" required />
      <input v-model="password" type="password" placeholder="Contraseña" required />
      <button type="submit" :disabled="auth.loading">
        {{ auth.loading ? 'Entrando…' : 'Entrar ahora' }}
      </button>
      <div class="auth-links">
        <a @click="mode = 'register'">¿No tenés cuenta? Crear una</a>
      </div>
    </form>

    <form v-else class="auth-form" @submit.prevent="submitRegister">
      <p v-if="auth.error" class="form-error">{{ auth.error }}</p>
      <input v-model="nick" type="text" placeholder="Nick" required maxlength="40" />
      <input v-model="email" type="email" placeholder="Email" required />
      <select v-model="department" required>
        <option value="" disabled>Departamento</option>
        <option v-for="item in DEPARTMENTS" :key="item" :value="item">{{ item }}</option>
      </select>
      <input v-model="password" type="password" placeholder="Contraseña (mín. 8)" required minlength="8" />
      <button type="submit" :disabled="auth.loading">
        {{ auth.loading ? 'Creando…' : 'Registrarme' }}
      </button>
      <div class="auth-links">
        <a @click="mode = 'login'">¿Ya tenés cuenta? Ingresar</a>
      </div>
    </form>
  </WidgetBox>
</template>
