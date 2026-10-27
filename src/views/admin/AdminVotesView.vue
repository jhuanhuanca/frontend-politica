<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useAdminStore } from '@/stores/admin'
import { formatDate } from '@/utils/dates'
import type { Paginated, VoteTopic } from '@/types/models'

const admin = useAdminStore()
const page = ref(1)
const list = ref<Paginated<VoteTopic> | null>(null)
const loading = ref(false)

async function load(): Promise<void> {
  loading.value = true
  admin.error = ''
  try {
    list.value = await admin.fetchTopics(page.value)
  } catch (err) {
    admin.setError(err, 'No se pudieron cargar las votaciones.')
  } finally {
    loading.value = false
  }
}

async function remove(item: VoteTopic): Promise<void> {
  if (!window.confirm(`¿Eliminar la votación “${item.title}”?`)) {
    return
  }

  try {
    await admin.deleteTopic(item.id)
    await load()
  } catch (err) {
    admin.setError(err, 'No se pudo eliminar la votación.')
  }
}

onMounted(load)
</script>

<template>
  <div>
    <h1>Votos y firmas</h1>
    <p class="admin-muted">Crear votaciones y revisar quién firmó.</p>
    <p v-if="admin.error" class="admin-error">{{ admin.error }}</p>
    <div class="admin-toolbar">
      <RouterLink class="admin-btn" :to="{ name: 'admin-vote-new' }">Nueva votación</RouterLink>
    </div>
    <p v-if="loading">Cargando…</p>
    <div v-else class="admin-table-wrap">
      <table class="admin-table">
        <thead>
          <tr>
            <th>Título</th>
            <th>Firmas</th>
            <th>Meta</th>
            <th>Estado</th>
            <th>Cierre</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in list?.data ?? []" :key="item.id">
            <td>{{ item.title }}</td>
            <td>{{ item.signatures_count }}</td>
            <td>{{ item.target_signatures }}</td>
            <td>
              <span class="admin-badge" :class="`admin-badge--${item.status}`">{{ item.status }}</span>
            </td>
            <td>{{ formatDate(item.deadline) }}</td>
            <td class="admin-actions">
              <RouterLink class="admin-btn admin-btn--ghost" :to="{ name: 'admin-vote-edit', params: { id: item.id } }">
                Ver / editar
              </RouterLink>
              <button class="admin-btn admin-btn--danger" type="button" @click="remove(item)">Borrar</button>
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
