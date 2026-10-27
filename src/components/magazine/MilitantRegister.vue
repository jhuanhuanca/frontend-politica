<script setup lang="ts">
import { reactive, ref } from 'vue'
import WidgetBox from '@/components/magazine/WidgetBox.vue'
import { api, validationMessage } from '@/services/api'
import { DEPARTMENTS } from '@/utils/bolivia'

const currentYear = new Date().getFullYear()
const years = Array.from({ length: 83 }, (_, i) => currentYear - 18 - i)

const form = reactive({
  full_name: '',
  ci: '',
  email: '',
  phone: '',
  city: '',
  department: '',
  birth_year: '',
  consent: false,
})

const loading = ref(false)
const error = ref('')
const done = ref(false)
const message = ref('')

async function submit(): Promise<void> {
  loading.value = true
  error.value = ''

  try {
    const { data } = await api.post<{ message: string }>('/militants', {
      full_name: form.full_name,
      ci: form.ci,
      email: form.email,
      phone: form.phone,
      city: form.city,
      department: form.department,
      birth_year: Number(form.birth_year),
      consent: form.consent,
    })
    message.value = data.message
    done.value = true
  } catch (err) {
    error.value = validationMessage(err, 'No se pudo completar el registro.')
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <WidgetBox title="Sumate a SCR">
    <div v-if="done" class="form-success">
      <p>{{ message }}</p>
    </div>

    <form v-else class="auth-form" @submit.prevent="submit">
      <p class="form-lead">
        Dejá tus datos para coordinar en tu departamento. SCR se pone en contacto: el cargo eterno
        no es experiencia, es un bloqueo.
      </p>
      <p v-if="error" class="form-error">{{ error }}</p>

      <input v-model="form.full_name" type="text" placeholder="Nombre completo" required maxlength="120" />
      <input v-model="form.ci" type="text" placeholder="CI" required maxlength="20" />
      <input v-model="form.email" type="email" placeholder="Email" required maxlength="255" />
      <input v-model="form.phone" type="tel" placeholder="Celular" required maxlength="20" />
      <input v-model="form.city" type="text" placeholder="Ciudad" required maxlength="80" />

      <select v-model="form.department" required>
        <option value="" disabled>Departamento</option>
        <option v-for="department in DEPARTMENTS" :key="department" :value="department">
          {{ department }}
        </option>
      </select>

      <select v-model="form.birth_year" required>
        <option value="" disabled>Año de nacimiento</option>
        <option v-for="year in years" :key="year" :value="year">{{ year }}</option>
      </select>

      <label class="consent-line">
        <input v-model="form.consent" type="checkbox" required />
        Acepto el tratamiento de estos datos para que se pongan en contacto conmigo.
      </label>

      <button type="submit" :disabled="loading">
        {{ loading ? 'Enviando…' : 'Quiero militar' }}
      </button>
    </form>
  </WidgetBox>
</template>
