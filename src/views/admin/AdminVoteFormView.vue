<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAdminStore } from '@/stores/admin'
import { useCatalogStore } from '@/stores/catalog'
import { formatDate, toDatetimeLocal } from '@/utils/dates'
import type { AdminSignature, Paginated } from '@/types/models'

const route = useRoute()
const router = useRouter()
const admin = useAdminStore()
const catalog = useCatalogStore()

const id = computed(() => {
  const value = Number(route.params.id)
  return Number.isFinite(value) && value > 0 ? value : null
})

const title = ref('')
const description = ref('')
const target = ref(100)
const deadline = ref('')
const status = ref('open')
const saving = ref(false)
const signatures = ref<Paginated<AdminSignature> | null>(null)
const signPage = ref(1)

async function loadSignatures(): Promise<void> {
  if (!id.value) {
    return
  }
  signatures.value = await admin.fetchSignatures(id.value, signPage.value)
}

onMounted(async () => {
  admin.error = ''
  if (!id.value) {
    return
  }

  try {
    const topic = await catalog.fetchTopic(id.value)
    title.value = topic.title
    description.value = topic.description ?? ''
    target.value = topic.target_signatures
    deadline.value = toDatetimeLocal(topic.deadline)
    status.value = topic.status
    await loadSignatures()
  } catch (err) {
    admin.setError(err, 'No se pudo cargar la votación.')
  }
})

async function submit(): Promise<void> {
  saving.value = true
  admin.error = ''
  try {
    const payload: Record<string, unknown> = {
      title: title.value,
      description: description.value || null,
      target_signatures: Number(target.value),
      status: status.value,
      deadline: deadline.value ? new Date(deadline.value).toISOString() : null,
    }
    if (!id.value) {
      delete payload.status
    }
    await admin.saveTopic(payload, id.value ?? undefined)
    await router.push({ name: 'admin-votes' })
  } catch (err) {
    admin.setError(err, 'No se pudo guardar la votación.')
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <div>
    <h1>{{ id ? 'Votación y firmas' : 'Nueva votación' }}</h1>
    <p v-if="admin.error" class="admin-error">{{ admin.error }}</p>
    <form class="admin-form" @submit.prevent="submit">
      <label>
        Título
        <input v-model="title" type="text" required maxlength="255" />
      </label>
      <label>
        Descripción
        <textarea v-model="description"></textarea>
      </label>
      <label>
        Meta de firmas
        <input v-model.number="target" type="number" min="0" />
      </label>
      <label>
        Fecha límite
        <input v-model="deadline" type="datetime-local" />
      </label>
      <label v-if="id">
        Estado
        <select v-model="status">
          <option value="open">Abierta</option>
          <option value="closed">Cerrada</option>
          <option value="achieved">Lograda</option>
        </select>
      </label>
      <div class="admin-actions">
        <button class="admin-btn" type="submit" :disabled="saving">
          {{ saving ? 'Guardando…' : 'Guardar' }}
        </button>
        <RouterLink class="admin-btn admin-btn--ghost" :to="{ name: 'admin-votes' }">Volver</RouterLink>
      </div>
    </form>

    <template v-if="id">
      <h1 style="margin-top: 40px">Firmas</h1>
      <div class="admin-table-wrap">
        <table class="admin-table">
          <thead>
            <tr>
              <th>Nick</th>
              <th>Email</th>
              <th>Fecha</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="!(signatures?.data.length)">
              <td colspan="3">Todavía no hay firmas.</td>
            </tr>
            <tr v-for="item in signatures?.data ?? []" :key="item.id">
              <td>{{ item.user?.nick ?? '—' }}</td>
              <td>{{ item.user?.email ?? '—' }}</td>
              <td>{{ formatDate(item.created_at) }}</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div v-if="signatures?.meta && signatures.meta.last_page > 1" class="admin-pager">
        <button
          class="admin-btn admin-btn--ghost"
          type="button"
          :disabled="signPage <= 1"
          @click="signPage -= 1; loadSignatures()"
        >
          Anterior
        </button>
        <span>{{ signPage }} / {{ signatures.meta.last_page }}</span>
        <button
          class="admin-btn admin-btn--ghost"
          type="button"
          :disabled="signPage >= signatures.meta.last_page"
          @click="signPage += 1; loadSignatures()"
        >
          Siguiente
        </button>
      </div>
    </template>
  </div>
</template>
