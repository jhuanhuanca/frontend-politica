<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useAdminStore } from '@/stores/admin'
import { categoryLabel } from '@/utils/content'
import { formatDate } from '@/utils/dates'
import type { Paginated, Suggestion } from '@/types/models'

const admin = useAdminStore()
const search = ref('')
const status = ref('pending')
const type = ref('')
const page = ref(1)
const list = ref<Paginated<Suggestion> | null>(null)
const loading = ref(false)
const acting = ref<number | null>(null)

const statusLabel: Record<Suggestion['status'], string> = {
  pending: 'Pendiente',
  accepted: 'Publicada',
  rejected: 'Rechazada',
}

async function load(): Promise<void> {
  loading.value = true
  admin.error = ''
  try {
    list.value = await admin.fetchSuggestions({
      search: search.value || undefined,
      status: status.value || undefined,
      type: type.value || undefined,
      page: page.value,
    })
  } catch (err) {
    admin.setError(err, 'No se pudieron cargar las sugerencias.')
  } finally {
    loading.value = false
  }
}

async function publish(item: Suggestion): Promise<void> {
  const kind = item.type === 'debate' ? 'debate' : 'votación'
  if (!window.confirm(`¿Publicar “${item.title}” como ${kind}?`)) {
    return
  }

  acting.value = item.id
  try {
    const updated = await admin.publishSuggestion(item.id)
    if (status.value && updated.status !== status.value) {
      await load()
    } else {
      Object.assign(item, updated)
    }
  } catch (err) {
    admin.setError(err, 'No se pudo publicar la sugerencia.')
  } finally {
    acting.value = null
  }
}

async function reject(item: Suggestion): Promise<void> {
  const note = window.prompt('Motivo para no publicarla (opcional):')
  if (note === null) {
    return
  }

  acting.value = item.id
  try {
    const updated = await admin.rejectSuggestion(item.id, note)
    if (status.value && updated.status !== status.value) {
      await load()
    } else {
      Object.assign(item, updated)
    }
  } catch (err) {
    admin.setError(err, 'No se pudo rechazar la sugerencia.')
  } finally {
    acting.value = null
  }
}

onMounted(load)
</script>

<template>
  <div>
    <h1>Sugerencias</h1>
    <p class="admin-muted">Los usuarios proponen debates y votaciones. Acá se publican o se descartan.</p>
    <p v-if="admin.error" class="admin-error">{{ admin.error }}</p>
    <form class="admin-toolbar" @submit.prevent="page = 1; load()">
      <input v-model="search" type="search" placeholder="Buscar título" />
      <select v-model="type">
        <option value="">Todos los tipos</option>
        <option value="debate">Debates</option>
        <option value="vote">Votaciones</option>
      </select>
      <select v-model="status">
        <option value="">Todos los estados</option>
        <option value="pending">Pendientes</option>
        <option value="accepted">Publicadas</option>
        <option value="rejected">Rechazadas</option>
      </select>
      <button class="admin-btn admin-btn--ghost" type="submit">Filtrar</button>
    </form>
    <p v-if="loading">Cargando…</p>
    <div v-else class="admin-table-wrap">
      <table class="admin-table">
        <thead>
          <tr>
            <th>Propuesta</th>
            <th>Tipo</th>
            <th>Usuario</th>
            <th>Estado</th>
            <th>Fecha</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in list?.data ?? []" :key="item.id">
            <td>
              <strong>{{ item.title }}</strong>
              <p class="admin-muted" style="margin: 6px 0 0">{{ item.description }}</p>
              <small v-if="item.category">{{ categoryLabel(item.category) }}</small>
              <small v-else-if="item.target_signatures">Meta: {{ item.target_signatures }} firmas</small>
              <p v-if="item.admin_note" class="admin-muted" style="margin: 6px 0 0">Nota: {{ item.admin_note }}</p>
            </td>
            <td>{{ item.type === 'debate' ? 'Debate' : 'Votación' }}</td>
            <td>{{ item.user?.nick ?? '—' }}</td>
            <td>
              <span class="admin-badge" :class="`admin-badge--${item.status}`">{{ statusLabel[item.status] }}</span>
            </td>
            <td>{{ formatDate(item.created_at) }}</td>
            <td class="admin-actions">
              <template v-if="item.status === 'pending'">
                <button class="admin-btn" type="button" :disabled="acting === item.id" @click="publish(item)">
                  Publicar
                </button>
                <button class="admin-btn admin-btn--danger" type="button" :disabled="acting === item.id" @click="reject(item)">
                  Rechazar
                </button>
              </template>
              <RouterLink
                v-else-if="item.debate_id"
                class="admin-btn admin-btn--ghost"
                :to="{ name: 'admin-debate-edit', params: { id: item.debate_id } }"
              >
                Ver debate
              </RouterLink>
              <RouterLink
                v-else-if="item.vote_topic_id"
                class="admin-btn admin-btn--ghost"
                :to="{ name: 'admin-vote-edit', params: { id: item.vote_topic_id } }"
              >
                Ver votación
              </RouterLink>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div v-if="list?.meta && list.meta.last_page > 1" class="admin-pager">
      <button class="admin-btn admin-btn--ghost" type="button" :disabled="page <= 1" @click="page -= 1; load()">
        Anterior
      </button>
      <span>{{ page }} / {{ list.meta.last_page }}</span>
      <button
        class="admin-btn admin-btn--ghost"
        type="button"
        :disabled="page >= list.meta.last_page"
        @click="page += 1; load()"
      >
        Siguiente
      </button>
    </div>
  </div>
</template>
