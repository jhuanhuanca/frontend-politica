<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import CommentItem from '@/components/magazine/CommentItem.vue'
import MagazinePanel from '@/components/magazine/MagazinePanel.vue'
import { useDebateRealtime } from '@/composables/useDebateRealtime'
import { useAuthStore } from '@/stores/auth'
import { useCatalogStore } from '@/stores/catalog'
import { coverUrl, formatDate } from '@/utils/content'
import { validationMessage } from '@/services/api'
import type { CommentThread, Debate, DebateMessage } from '@/types/models'

const route = useRoute()
const catalog = useCatalogStore()
const auth = useAuthStore()
const debate = ref<Debate | null>(null)
const messages = ref<DebateMessage[]>([])
const content = ref('')
const error = ref('')
const sending = ref(false)
const replyTo = ref<DebateMessage | null>(null)
const debateId = computed(() => Number(route.params.id))

const countLabel = computed(() => {
  const n = messages.value.length
  if (n === 0) return 'Todavía no hay argumentos'
  if (n === 1) return '1 argumento'
  return `${n} argumentos`
})

const threads = computed(() => buildThreads(messages.value))

function ingest(incoming: DebateMessage): void {
  const id = Number(incoming.id)
  if (!Number.isFinite(id) || messages.value.some((item) => Number(item.id) === id)) {
    return
  }
  messages.value.push({
    ...incoming,
    id,
    parent_id: incoming.parent_id == null ? null : Number(incoming.parent_id),
  })
}

watch(
  debateId,
  async (id) => {
    if (!Number.isFinite(id) || id <= 0) {
      return
    }
    messages.value = []
    debate.value = await catalog.fetchDebate(id)
    const loaded = await catalog.fetchMessages(id)
    loaded.forEach(ingest)
  },
  { immediate: true },
)

useDebateRealtime(debateId, ingest)

function newestFirst(a: DebateMessage, b: DebateMessage): number {
  const timeA = new Date(a.created_at).getTime()
  const timeB = new Date(b.created_at).getTime()
  if (timeB !== timeA) {
    return timeB - timeA
  }

  return Number(b.id) - Number(a.id)
}

function buildThreads(list: DebateMessage[]): CommentThread[] {
  const normalized = list.map((message) => ({
    ...message,
    id: Number(message.id),
    parent_id: message.parent_id == null ? null : Number(message.parent_id),
  }))
  const byId = new Set(normalized.map((message) => message.id))
  const children = new Map<number, DebateMessage[]>()
  const roots: DebateMessage[] = []

  for (const message of normalized) {
    const parentId = message.parent_id
    if (parentId && byId.has(parentId)) {
      const bucket = children.get(parentId) ?? []
      bucket.push(message)
      children.set(parentId, bucket)
    } else {
      roots.push(message)
    }
  }

  for (const [key, bucket] of children) {
    children.set(key, bucket.sort(newestFirst))
  }

  const nest = (message: DebateMessage): CommentThread => ({
    message,
    children: (children.get(message.id) ?? []).map(nest),
  })

  return roots.sort(newestFirst).map(nest)
}

function requireAccount(): boolean {
  if (auth.isAuthenticated) {
    return true
  }
  auth.openAuthModal('register')
  return false
}

function toggleReply(message: DebateMessage): void {
  if (!requireAccount()) {
    return
  }
  replyTo.value = replyTo.value?.id === message.id ? null : message
}

function initial(nick: string): string {
  return (nick.trim().charAt(0) || '?').toUpperCase()
}

async function publish(text: string, parentId: number | null = null): Promise<void> {
  if (!requireAccount()) {
    return
  }

  if (!debate.value || !text.trim()) {
    return
  }

  error.value = ''
  sending.value = true
  try {
    const created = await catalog.postMessage(debate.value.id, text.trim(), parentId)
    messages.value.push(created)
    if (parentId) {
      replyTo.value = null
    } else {
      content.value = ''
    }
  } catch (err) {
    error.value = validationMessage(err, 'Iniciá sesión para participar.')
  } finally {
    sending.value = false
  }
}

async function send(): Promise<void> {
  await publish(content.value)
}

async function sendReply(text: string, parentId: number): Promise<void> {
  await publish(text, parentId)
}
</script>

<template>
  <div class="page-block">
    <div class="row article" v-if="debate">
      <figure class="article-cover-wrap">
        <img
          class="article-cover"
          :src="coverUrl(debate)"
          :alt="debate.title"
        />
        <figcaption v-if="debate.image_credit">{{ debate.image_credit }}</figcaption>
      </figure>
      <p class="meta article-meta">
        <span>{{ formatDate(debate.created_at) }}</span>
        <span>{{ debate.author?.nick }}</span>
      </p>
      <h1>{{ debate.title }}</h1>
      <p class="article-lead">{{ debate.description }}</p>
      <aside v-if="debate.sources?.length" class="article-sources">
        <strong>Fuentes de la noticia</strong>
        <ul>
          <li v-for="source in debate.sources" :key="source.url">
            <a :href="source.url" target="_blank" rel="noopener noreferrer">{{ source.name }}</a>
          </li>
        </ul>
      </aside>

      <MagazinePanel :title="`La conversación · ${countLabel}`">
        <div class="comment-stage">
          <p class="comment-invite">
            Primero leé el hilo. Después respondé o dejá tu argumento: el recambio se discute
            entre todos, no desde una cúpula.
          </p>

          <div v-if="!messages.length" class="comment-empty">
            <strong>El hilo está abierto.</strong>
            <p>Nadie argumentó todavía. El primero marca el tono del debate.</p>
          </div>

          <div
            v-else
            class="comment-feed"
            :class="{ 'is-scroll': threads.length > 5 }"
          >
            <ul class="comment-list">
              <CommentItem
                v-for="thread in threads"
                :key="thread.message.id"
                :thread="thread"
                :reply-to-id="replyTo?.id ?? null"
                :current-nick="auth.user?.nick"
                @reply="toggleReply"
                @cancel="replyTo = null"
                @send="sendReply"
              />
            </ul>
          </div>

          <form class="comment-composer" @submit.prevent="send">
            <div class="comment-composer-head">
              <span class="comment-avatar comment-avatar--you">{{
                initial(auth.user?.nick ?? 'Vos')
              }}</span>
              <div>
                <strong>{{ auth.isAuthenticated ? auth.user?.nick : 'Tu turno' }}</strong>
                <small>
                  {{
                    auth.isAuthenticated
                      ? 'Ya leíste el hilo. Ahora sumá un argumento nuevo.'
                      : 'Entrá con tu nick para responder o abrir un argumento.'
                  }}
                </small>
              </div>
            </div>
            <p v-if="error" class="form-error">{{ error }}</p>
            <textarea
              v-model="content"
              rows="4"
              :placeholder="
                auth.isAuthenticated
                  ? 'Tu argumento nuevo (si es una respuesta, usá Responder arriba)…'
                  : 'Leé los comentarios y prepará el tuyo. Entrá para publicarlo.'
              "
              :required="auth.isAuthenticated"
            />
            <div class="comment-composer-bar">
              <span>{{ content.trim().length }} caracteres</span>
              <button type="submit" :disabled="sending">
                {{
                  sending
                    ? 'Publicando…'
                    : auth.isAuthenticated
                      ? 'Publicar argumento'
                      : 'Entrar y comentar'
                }}
              </button>
            </div>
          </form>
        </div>
      </MagazinePanel>
    </div>
  </div>
</template>
