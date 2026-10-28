<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAdminStore } from '@/stores/admin'
import { useCatalogStore } from '@/stores/catalog'
import { CATEGORY_LABELS, rewriteMedia } from '@/utils/content'
import type { Debate } from '@/types/models'

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
const category = ref('sociedad')
const status = ref('open')
const videoUrl = ref('')
const imageCredit = ref('')
const image = ref<File | null>(null)
const saving = ref(false)
const preview = ref<string | null>(null)

onMounted(async () => {
  admin.error = ''
  if (!id.value) {
    return
  }

  try {
    const debate: Debate = await catalog.fetchDebate(id.value)
    title.value = debate.title
    description.value = debate.description ?? ''
    category.value = debate.category ?? 'sociedad'
    status.value = debate.status
    videoUrl.value = debate.video_url ?? ''
    imageCredit.value = debate.image_credit ?? ''
    preview.value = debate.image_url ? rewriteMedia(debate.image_url) : null
  } catch (err) {
    admin.setError(err, 'No se pudo cargar el debate.')
  }
})

function onFile(event: Event): void {
  const input = event.target as HTMLInputElement
  image.value = input.files?.[0] ?? null
  if (image.value) {
    preview.value = URL.createObjectURL(image.value)
  }
}

async function submit(): Promise<void> {
  saving.value = true
  admin.error = ''
  try {
    const form = new FormData()
    form.append('title', title.value)
    form.append('description', description.value)
    form.append('category', category.value)
    form.append('status', status.value)
    form.append('image_credit', imageCredit.value)
    if (videoUrl.value) {
      form.append('video_url', videoUrl.value)
    }
    if (image.value) {
      form.append('image', image.value)
    }
    await admin.saveDebate(form, id.value ?? undefined)
    await router.push({ name: 'admin-debates' })
  } catch (err) {
    admin.setError(err, 'No se pudo guardar el debate.')
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <div>
    <h1>{{ id ? 'Editar debate' : 'Nuevo debate' }}</h1>
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
        Categoría
        <select v-model="category">
          <option v-for="(label, key) in CATEGORY_LABELS" :key="key" :value="key">{{ label }}</option>
        </select>
      </label>
      <label>
        Estado
        <select v-model="status">
          <option value="open">Abierto</option>
          <option value="closed">Cerrado</option>
          <option value="moderated">Moderado</option>
        </select>
      </label>
      <label>
        Crédito de imagen
        <input v-model="imageCredit" type="text" maxlength="255" />
      </label>
      <label>
        Video (URL)
        <input v-model="videoUrl" type="url" placeholder="https://" />
      </label>
      <label>
        Portada
        <input type="file" accept="image/*" @change="onFile" />
      </label>
      <img v-if="preview" :src="preview" alt="" style="max-width: 320px" />
      <div class="admin-actions">
        <button class="admin-btn" type="submit" :disabled="saving">
          {{ saving ? 'Guardando…' : 'Guardar' }}
        </button>
        <RouterLink class="admin-btn admin-btn--ghost" :to="{ name: 'admin-debates' }">Cancelar</RouterLink>
      </div>
    </form>
  </div>
</template>
