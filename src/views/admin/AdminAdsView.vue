<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { useAdminStore } from '@/stores/admin'
import { useCatalogStore } from '@/stores/catalog'
import { rewriteMedia } from '@/utils/content'
import type { Ad, AdSlotName } from '@/types/models'

const admin = useAdminStore()
const catalog = useCatalogStore()
const ads = ref<Ad[]>([])
const loading = ref(false)
const savingSlot = ref<AdSlotName | null>(null)

const forms = reactive<Record<AdSlotName, { title: string; link_url: string; image: File | null; preview: string | null }>>({
  left: { title: '', link_url: '', image: null, preview: null },
  right: { title: '', link_url: '', image: null, preview: null },
})

const slots: Array<{ key: AdSlotName; title: string; hint: string }> = [
  { key: 'left', title: 'Espacio izquierdo', hint: 'Columna de la izquierda en la portada.' },
  { key: 'right', title: 'Espacio derecho', hint: 'Columna de la derecha en la portada.' },
]

const bySlot = computed(() => ({
  left: ads.value.filter((item) => item.slot === 'left'),
  right: ads.value.filter((item) => item.slot === 'right'),
}))

async function load(): Promise<void> {
  loading.value = true
  admin.error = ''
  try {
    ads.value = await admin.fetchAds()
    await catalog.fetchHome()
  } catch (err) {
    admin.setError(err, 'No se pudieron cargar los anuncios.')
  } finally {
    loading.value = false
  }
}

function onFile(slot: AdSlotName, event: Event): void {
  const input = event.target as HTMLInputElement
  const file = input.files?.[0] ?? null
  forms[slot].image = file
  forms[slot].preview = file ? URL.createObjectURL(file) : null
}

async function submit(slot: AdSlotName): Promise<void> {
  if (!forms[slot].image) {
    admin.error = 'Subí una imagen para el anuncio.'
    return
  }

  savingSlot.value = slot
  admin.error = ''
  try {
    const form = new FormData()
    form.append('slot', slot)
    form.append('title', forms[slot].title)
    if (forms[slot].link_url) {
      form.append('link_url', forms[slot].link_url)
    }
    form.append('image', forms[slot].image)
    await admin.saveAd(form)
    forms[slot].title = ''
    forms[slot].link_url = ''
    forms[slot].image = null
    forms[slot].preview = null
    await load()
  } catch (err) {
    admin.setError(err, 'No se pudo guardar el anuncio.')
  } finally {
    savingSlot.value = null
  }
}

async function toggle(item: Ad): Promise<void> {
  try {
    const updated = await admin.updateAd(item.id, { is_active: !item.is_active })
    ads.value = ads.value.map((ad) => (ad.id === item.id ? updated : ad))
    await catalog.fetchHome()
  } catch (err) {
    admin.setError(err, 'No se pudo actualizar el anuncio.')
  }
}

async function remove(item: Ad): Promise<void> {
  if (!window.confirm('¿Quitar este anuncio?')) {
    return
  }

  try {
    await admin.deleteAd(item.id)
    await load()
  } catch (err) {
    admin.setError(err, 'No se pudo eliminar el anuncio.')
  }
}

onMounted(load)
</script>

<template>
  <div>
    <h1>Anuncios</h1>
    <p class="admin-muted">
      Subí avisos a los dos espacios de la portada. Si hay más de uno en el mismo espacio, rotan cada 10
      segundos.
    </p>
    <p v-if="admin.error" class="admin-error">{{ admin.error }}</p>
    <p v-if="loading">Cargando…</p>

    <div v-else class="admin-ads-grid">
      <section v-for="space in slots" :key="space.key" class="admin-ad-space">
        <h2>{{ space.title }}</h2>
        <p class="admin-muted">{{ space.hint }}</p>

        <div v-if="!bySlot[space.key].length" class="admin-muted">Todavía no hay avisos en este espacio.</div>
        <ul class="admin-ad-list">
          <li v-for="item in bySlot[space.key]" :key="item.id">
            <img v-if="item.image_url" :src="rewriteMedia(item.image_url)" :alt="item.title || 'Anuncio'" />
            <div>
              <strong>{{ item.title || 'Sin título' }}</strong>
              <small v-if="item.link_url">{{ item.link_url }}</small>
              <small>{{ item.is_active ? 'Visible' : 'Oculto' }}</small>
            </div>
            <div class="admin-actions">
              <button class="admin-btn admin-btn--ghost" type="button" @click="toggle(item)">
                {{ item.is_active ? 'Ocultar' : 'Mostrar' }}
              </button>
              <button class="admin-btn admin-btn--danger" type="button" @click="remove(item)">Borrar</button>
            </div>
          </li>
        </ul>

        <form class="admin-form" @submit.prevent="submit(space.key)">
          <label>
            Título
            <input v-model="forms[space.key].title" type="text" maxlength="120" placeholder="Opcional" />
          </label>
          <label>
            Enlace
            <input v-model="forms[space.key].link_url" type="url" placeholder="https://" />
          </label>
          <label>
            Imagen
            <input type="file" accept="image/*" required @change="onFile(space.key, $event)" />
          </label>
          <img v-if="forms[space.key].preview" :src="forms[space.key].preview ?? undefined" alt="" class="admin-ad-preview" />
          <button class="admin-btn" type="submit" :disabled="savingSlot === space.key">
            {{ savingSlot === space.key ? 'Subiendo…' : 'Subir anuncio' }}
          </button>
        </form>
      </section>
    </div>
  </div>
</template>
