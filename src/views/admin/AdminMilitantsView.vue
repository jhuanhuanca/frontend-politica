<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useAdminStore } from '@/stores/admin'
import { formatDate } from '@/utils/dates'
import type { AdminMilitant, Paginated } from '@/types/models'

const admin = useAdminStore()
const search = ref('')
const status = ref('')
const page = ref(1)
const list = ref<Paginated<AdminMilitant> | null>(null)
const loading = ref(false)

const labels: Record<AdminMilitant['status'], string> = {
  pending: 'Pendiente',
  active: 'Activo',
  rejected: 'Rechazado',
}

async function load(): Promise<void> {
  loading.value = true
  admin.error = ''
  try {
    list.value = await admin.fetchMilitants({
      search: search.value || undefined,
      status: status.value || undefined,
      page: page.value,
    })
  } catch (err) {
    admin.setError(err, 'No se pudieron cargar los militantes.')
  } finally {
    loading.value = false
  }
}

async function changeStatus(item: AdminMilitant, next: AdminMilitant['status']): Promise<void> {
  try {
    const updated = await admin.updateMilitantStatus(item.id, next)
    item.status = updated.status
  } catch (err) {
    admin.setError(err, 'No se pudo actualizar el estado.')
  }
}

onMounted(load)
</script>

<template>
  <div>
    <h1>Militantes</h1>
    <p class="admin-muted">Padrón con datos personales. Solo visible aquí.</p>
    <p v-if="admin.error" class="admin-error">{{ admin.error }}</p>
    <form class="admin-toolbar" @submit.prevent="page = 1; load()">
      <input v-model="search" type="search" placeholder="Nombre, CI o email" />
      <select v-model="status">
        <option value="">Todos</option>
        <option value="pending">Pendientes</option>
        <option value="active">Activos</option>
        <option value="rejected">Rechazados</option>
      </select>
      <button class="admin-btn admin-btn--ghost" type="submit">Filtrar</button>
    </form>
    <p v-if="loading">Cargando…</p>
    <div v-else class="admin-table-wrap">
      <table class="admin-table">
        <thead>
          <tr>
            <th>Nombre</th>
            <th>CI</th>
            <th>Email</th>
            <th>Teléfono</th>
            <th>Ciudad</th>
            <th>Depto.</th>
            <th>Estado</th>
            <th>Alta</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in list?.data ?? []" :key="item.id">
            <td>{{ item.full_name }}</td>
            <td>{{ item.ci }}</td>
            <td>{{ item.email }}</td>
            <td>{{ item.phone }}</td>
            <td>{{ item.city }}</td>
            <td>{{ item.department }}</td>
            <td>
              <select :value="item.status" @change="changeStatus(item, ($event.target as HTMLSelectElement).value as AdminMilitant['status'])">
                <option value="pending">Pendiente</option>
                <option value="active">Activo</option>
                <option value="rejected">Rechazado</option>
              </select>
              <span class="admin-badge" :class="`admin-badge--${item.status}`">{{ labels[item.status] }}</span>
            </td>
            <td>{{ formatDate(item.created_at) }}</td>
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
