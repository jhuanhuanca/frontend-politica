<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useAdminStore } from '@/stores/admin'
import { categoryLabel } from '@/utils/content'
import { formatDate } from '@/utils/dates'
import ShareDebateButton from '@/components/admin/ShareDebateButton.vue'
import type { Debate, Paginated } from '@/types/models'

const admin = useAdminStore()
const search = ref('')
const page = ref(1)
const list = ref<Paginated<Debate> | null>(null)
const loading = ref(false)

async function load(): Promise<void> {
  loading.value = true
  admin.error = ''
  try {
    list.value = await admin.fetchDebates({ search: search.value || undefined, page: page.value })
  } catch (err) {
    admin.setError(err, 'No se pudieron cargar los debates.')
  } finally {
    loading.value = false
  }
}

async function remove(item: Debate): Promise<void> {
  if (!window.confirm(`¿Eliminar el debate “${item.title}”?`)) {
    return
  }

  try {
    await admin.deleteDebate(item.id)
    await load()
  } catch (err) {
    admin.setError(err, 'No se pudo eliminar el debate.')
  }
}

onMounted(load)
</script>

<template>
  <div>
    <h1>Debates</h1>
    <p class="admin-muted">Crear, editar y cerrar los debates públicos.</p>
    <p v-if="admin.error" class="admin-error">{{ admin.error }}</p>
    <div class="admin-toolbar">
      <form class="admin-toolbar" @submit.prevent="page = 1; load()">
        <input v-model="search" type="search" placeholder="Buscar título" />
        <button class="admin-btn admin-btn--ghost" type="submit">Buscar</button>
      </form>
      <RouterLink class="admin-btn" :to="{ name: 'admin-debate-new' }">Nuevo debate</RouterLink>
    </div>
    <p v-if="loading">Cargando…</p>
    <div v-else class="admin-table-wrap">
      <table class="admin-table">
        <thead>
          <tr>
            <th>Título</th>
            <th>Categoría</th>
            <th>Estado</th>
            <th>Comentarios</th>
            <th>Fecha</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in list?.data ?? []" :key="item.id">
            <td>{{ item.title }}</td>
            <td>{{ categoryLabel(item.category) }}</td>
            <td>
              <span class="admin-badge" :class="`admin-badge--${item.status}`">{{ item.status }}</span>
            </td>
            <td>{{ item.messages_count ?? 0 }}</td>
            <td>{{ formatDate(item.created_at) }}</td>
            <td class="admin-actions">
              <ShareDebateButton :debate-id="item.id" :title="item.title" />
              <RouterLink class="admin-btn admin-btn--ghost" :to="{ name: 'admin-debate-edit', params: { id: item.id } }">
                Editar
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
