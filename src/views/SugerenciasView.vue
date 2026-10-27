<script setup lang="ts">
import { onMounted, reactive, ref, watch } from 'vue'
import LoginWidget from '@/components/magazine/LoginWidget.vue'
import MagazinePanel from '@/components/magazine/MagazinePanel.vue'
import { api, validationMessage } from '@/services/api'
import { useAuthStore } from '@/stores/auth'
import { CATEGORY_LABELS, categoryLabel } from '@/utils/content'
import { formatDate } from '@/utils/dates'
import type { Paginated, Suggestion } from '@/types/models'

const auth = useAuthStore()
const kind = ref<'debate' | 'vote'>('debate')
const loading = ref(false)
const sending = ref(false)
const error = ref('')
const ok = ref('')
const mine = ref<Suggestion[]>([])

const form = reactive({
  title: '',
  description: '',
  category: 'politica',
  target_signatures: 1000,
})

const statusLabel: Record<Suggestion['status'], string> = {
  pending: 'En revisión',
  accepted: 'Publicada',
  rejected: 'No publicada',
}

async function loadMine(): Promise<void> {
  if (!auth.isAuthenticated) {
    mine.value = []
    return
  }

  loading.value = true
  error.value = ''
  try {
    const { data } = await api.get<Paginated<Suggestion>>('/suggestions')
    mine.value = data.data
  } catch (err) {
    error.value = validationMessage(err, 'No se pudieron cargar tus sugerencias.')
  } finally {
    loading.value = false
  }
}

async function submit(): Promise<void> {
  if (!auth.isAuthenticated) {
    auth.openAuthModal('register')
    return
  }

  sending.value = true
  error.value = ''
  ok.value = ''
  try {
    const payload =
      kind.value === 'debate'
        ? {
            type: 'debate',
            title: form.title.trim(),
            description: form.description.trim(),
            category: form.category || null,
          }
        : {
            type: 'vote',
            title: form.title.trim(),
            description: form.description.trim(),
            target_signatures: Number(form.target_signatures) || 1000,
          }

    const { data } = await api.post<{ data: Suggestion }>('/suggestions', payload)
    mine.value.unshift(data.data)
    form.title = ''
    form.description = ''
    form.target_signatures = 1000
    ok.value = 'Listo. La revisión llega al administrador y, si se publica, aparece en la plataforma.'
  } catch (err) {
    error.value = validationMessage(err, 'No se pudo enviar la sugerencia.')
  } finally {
    sending.value = false
  }
}

function publishedLink(item: Suggestion): string | null {
  if (item.debate_id) {
    return `/debates/${item.debate_id}`
  }
  if (item.vote_topic_id) {
    return `/votaciones/${item.vote_topic_id}`
  }
  return null
}

watch(
  () => auth.isAuthenticated,
  () => {
    void loadMine()
  },
)

onMounted(loadMine)
</script>

<template>
  <div class="page-block">
    <div class="row split-page">
      <article class="article">
        <MagazinePanel title="Sugerencias">
          <h1>Proponé el próximo debate o votación</h1>
          <p>
            La agenda no la cierra una dirigencia. Si hay un tema que hay que discutir o una firma que hay
            que juntar, proponelo acá. El administrador revisa y, si entra, se publica en Debates o
            Votaciones.
          </p>

          <p v-if="!auth.isAuthenticated" class="form-lead">
            Entrá con tu cuenta a la derecha para enviar una propuesta.
          </p>

          <div class="suggest-tabs">
            <button type="button" :class="{ active: kind === 'debate' }" @click="kind = 'debate'">
              Debate
            </button>
            <button type="button" :class="{ active: kind === 'vote' }" @click="kind = 'vote'">
              Votación
            </button>
          </div>

          <form class="auth-form" @submit.prevent="submit">
            <p v-if="error" class="form-error">{{ error }}</p>
            <p v-if="ok" class="form-success">{{ ok }}</p>
            <input v-model="form.title" type="text" :placeholder="kind === 'debate' ? 'Título del debate' : 'Título de la votación'" required maxlength="255" />
            <textarea
              v-model="form.description"
              :placeholder="kind === 'debate' ? '¿Qué hay que discutir y por qué ahora?' : '¿Qué se firma y cuál es la meta política?'"
              required
              maxlength="5000"
              rows="5"
            />
            <select v-if="kind === 'debate'" v-model="form.category">
              <option v-for="(label, key) in CATEGORY_LABELS" :key="key" :value="key">{{ label }}</option>
            </select>
            <input
              v-else
              v-model.number="form.target_signatures"
              type="number"
              min="10"
              max="10000000"
              placeholder="Meta de firmas"
            />
            <button type="submit" :disabled="sending">
              {{ sending ? 'Enviando…' : kind === 'debate' ? 'Sugerir debate' : 'Sugerir votación' }}
            </button>
          </form>
        </MagazinePanel>

        <MagazinePanel v-if="auth.isAuthenticated" title="Tus propuestas">
          <p v-if="loading">Cargando…</p>
          <p v-else-if="!mine.length">Todavía no enviaste ninguna sugerencia.</p>
          <ul v-else class="suggest-list">
            <li v-for="item in mine" :key="item.id" class="suggest-item">
              <div class="suggest-item__head">
                <strong>{{ item.title }}</strong>
                <span class="suggest-badge" :class="`suggest-badge--${item.status}`">{{ statusLabel[item.status] }}</span>
              </div>
              <small class="meta">
                {{ item.type === 'debate' ? 'Debate' : 'Votación' }}
                <template v-if="item.category"> · {{ categoryLabel(item.category) }}</template>
                · {{ formatDate(item.created_at) }}
              </small>
              <p>{{ item.description }}</p>
              <p v-if="item.admin_note" class="form-lead">Nota: {{ item.admin_note }}</p>
              <RouterLink v-if="publishedLink(item)" :to="publishedLink(item)!">Ver publicado</RouterLink>
            </li>
          </ul>
        </MagazinePanel>
      </article>
      <aside>
        <LoginWidget />
      </aside>
    </div>
  </div>
</template>
