<script setup lang="ts">
import { ref } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { DEPARTMENTS } from '@/utils/bolivia'
import { PRIVACY_SECTIONS } from '@/content/privacy'

const props = withDefaults(
  defineProps<{
    initialMode?: 'login' | 'register'
  }>(),
  { initialMode: 'login' },
)

const emit = defineEmits<{
  done: []
}>()

const auth = useAuthStore()
const mode = ref<'login' | 'register'>(props.initialMode)
const username = ref('')
const password = ref('')
const nick = ref('')
const email = ref('')
const department = ref('')
const privacyAccepted = ref(false)
const showPrivacy = ref(false)

async function submitLogin(): Promise<void> {
  const ok = await auth.login(username.value, password.value)
  if (ok) {
    emit('done')
  }
}

async function submitRegister(): Promise<void> {
  if (!privacyAccepted.value) {
    auth.error = 'Tenés que aceptar las políticas de privacidad y el tratamiento de tus datos.'
    return
  }

  const ok = await auth.register({
    nick: nick.value,
    email: email.value,
    password: password.value,
    department: department.value,
    privacy_accepted: true,
  })
  if (ok) {
    emit('done')
  }
}

async function saveDepartment(): Promise<void> {
  if (!department.value) {
    return
  }
  const ok = await auth.updateDepartment(department.value)
  if (ok) {
    emit('done')
  }
}

function switchMode(next: 'login' | 'register'): void {
  mode.value = next
  auth.error = ''
}
</script>

<template>
  <div v-if="auth.user" class="auth-form">
    <p>
      Hola, <strong>{{ auth.user.nick }}</strong>. Ya estás dentro: comentá, firmá o
      <RouterLink to="/sugerencias">sugerí un tema</RouterLink>.
    </p>
    <p v-if="auth.user.department" class="form-lead">Departamento: {{ auth.user.department }}</p>
    <form v-else @submit.prevent="saveDepartment">
        <p class="form-lead">Falta tu departamento para el mapa de la comunidad.</p>
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
      <a @click="switchMode('register')">¿No tenés cuenta? Crear una</a>
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

    <label class="consent-line">
      <input v-model="privacyAccepted" type="checkbox" required />
      <span>
        Acepto las
        <button class="privacy-toggle" type="button" @click="showPrivacy = !showPrivacy">
          políticas de privacidad y recolección de datos
        </button>
        para crear mi cuenta.
      </span>
    </label>
    <div v-if="showPrivacy" class="privacy-box">
      <p v-for="section in PRIVACY_SECTIONS" :key="section.title">
        <strong>{{ section.title }}.</strong>
        {{ section.body }}
      </p>
      <RouterLink to="/privacidad" @click="emit('done')">Ver política completa</RouterLink>
    </div>

    <button type="submit" :disabled="auth.loading || !privacyAccepted">
      {{ auth.loading ? 'Creando…' : 'Registrarme' }}
    </button>
    <div class="auth-links">
      <a @click="switchMode('login')">¿Ya tenés cuenta? Ingresar</a>
    </div>
  </form>
</template>
