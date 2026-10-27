<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useAdminStore } from '@/stores/admin'
import { formatDate } from '@/utils/dates'
import { DEPARTMENTS } from '@/utils/bolivia'
import type { AdminUser, Paginated } from '@/types/models'

const admin = useAdminStore()
const search = ref('')
const department = ref('')
const page = ref(1)
const list = ref<Paginated<AdminUser> | null>(null)
const loading = ref(false)

async function load(): Promise<void> {
  loading.value = true
  admin.error = ''
  try {
    list.value = await admin.fetchUsers({
      search: search.value || undefined,
      department: department.value || undefined,
      page: page.value,
    })
  } catch (err) {
    admin.setError(err, 'No se pudieron cargar los usuarios.')
  } finally {
    loading.value = false
  }
}

onMounted(load)
</script>

<template>
  <div>
    <h1>Usuarios</h1>
    <p class="admin-muted">Cuentas de la revista. El departamento sirve para armar vocerías territoriales.</p>
    <p v-if="admin.error" class="admin-error">{{ admin.error }}</p>
    <form class="admin-toolbar" @submit.prevent="page = 1; load()">
      <input v-model="search" type="search" placeholder="Nick o email" />
      <select v-model="department">
        <option value="">Todos los departamentos</option>
        <option v-for="item in DEPARTMENTS" :key="item" :value="item">{{ item }}</option>
        <option value="none">Sin departamento</option>
      </select>
      <button class="admin-btn admin-btn--ghost" type="submit">Filtrar</button>
    </form>
    <p v-if="loading">Cargando…</p>
    <div v-else class="admin-table-wrap">
      <table class="admin-table">
        <thead>
          <tr>
            <th>Nick</th>
            <th>Email</th>
            <th>Departamento</th>
            <th>Rol</th>
            <th>Debates</th>
            <th>Comentarios</th>
            <th>Firmas</th>
            <th>Sugerencias</th>
            <th>Alta</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in list?.data ?? []" :key="item.id">
            <td>{{ item.nick }}</td>
            <td>{{ item.email }}</td>
            <td>{{ item.department ?? '—' }}</td>
            <td>
              <span v-if="item.is_admin" class="admin-badge">Administrador</span>
              <span v-else>Usuario</span>
            </td>
            <td>{{ item.debates_count ?? 0 }}</td>
            <td>{{ item.messages_count ?? 0 }}</td>
            <td>{{ item.signatures_count ?? 0 }}</td>
            <td>{{ item.suggestions_count ?? 0 }}</td>
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
