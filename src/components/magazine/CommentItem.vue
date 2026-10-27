<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { formatDate } from '@/utils/content'
import type { CommentThread, DebateMessage } from '@/types/models'

defineOptions({ name: 'CommentItem' })

const props = withDefaults(
  defineProps<{
    thread: CommentThread
    replyToId: number | null
    currentNick?: string
    replyToNick?: string
    depth?: number
  }>(),
  { depth: 0 },
)

const emit = defineEmits<{
  reply: [message: DebateMessage]
  cancel: []
  send: [content: string, parentId: number]
}>()

const draft = ref('')
const expanded = ref(false)

const nick = computed(() => props.thread.message.user?.nick ?? 'Anónimo')
const isOwn = computed(() => Boolean(props.currentNick && nick.value === props.currentNick))
const isReplying = computed(() => props.replyToId === props.thread.message.id)
const hue = computed(() => nickHue(nick.value))
const replyCount = computed(() => countReplies(props.thread.children))
const toggleLabel = computed(() => {
  if (!replyCount.value) {
    return ''
  }
  const noun = replyCount.value === 1 ? 'respuesta' : 'respuestas'
  return expanded.value ? `Ocultar ${replyCount.value} ${noun}` : `Ver ${replyCount.value} ${noun}`
})

watch(isReplying, (open) => {
  if (!open) {
    draft.value = ''
  }
})

watch(replyCount, (next, prev) => {
  if (prev !== undefined && next > prev) {
    expanded.value = true
  }
})

watch(
  () => props.replyToId,
  (id) => {
    if (id && id !== props.thread.message.id && threadContains(props.thread, id)) {
      expanded.value = true
    }
  },
  { immediate: true },
)

function countReplies(nodes: CommentThread[]): number {
  return nodes.reduce((total, node) => total + 1 + countReplies(node.children), 0)
}

function threadContains(node: CommentThread, id: number): boolean {
  if (node.message.id === id) {
    return true
  }
  return node.children.some((child) => threadContains(child, id))
}

function toggleReplies(): void {
  expanded.value = !expanded.value
}

function nickHue(name: string): number {
  let hash = 0
  for (const char of name) {
    hash = (hash * 31 + char.charCodeAt(0)) % 360
  }
  return hash
}

function initial(name: string): string {
  return (name.trim().charAt(0) || '?').toUpperCase()
}

function submitReply(): void {
  const text = draft.value.trim()
  if (!text) {
    return
  }
  emit('send', text, props.thread.message.id)
  draft.value = ''
}
</script>

<template>
  <li class="comment-thread" :class="`is-depth-${Math.min(depth, 4)}`">
    <article class="comment-card" :class="{ 'is-own': isOwn, 'is-reply': depth > 0 }" :style="{ '--nick': `${hue}` }">
      <span class="comment-avatar" :style="{ background: `hsl(${hue} 62% 42%)` }">
        {{ initial(nick) }}
      </span>
      <div class="comment-body">
        <div class="comment-meta">
          <strong :style="{ color: `hsl(${hue} 72% 36%)` }">{{ nick }}</strong>
          <em v-if="isOwn">Vos</em>
          <small v-if="replyToNick">respondió a {{ replyToNick }}</small>
          <small>{{ formatDate(thread.message.created_at) }}</small>
        </div>
        <p>{{ thread.message.content }}</p>
        <div class="comment-actions">
          <button class="comment-reply-btn" type="button" @click="emit('reply', thread.message)">
            {{ isReplying ? 'Cerrar respuesta' : 'Responder' }}
          </button>
          <button
            v-if="replyCount"
            class="comment-toggle-btn"
            type="button"
            :aria-expanded="expanded"
            @click="toggleReplies"
          >
            <span class="comment-toggle-chevron" :class="{ 'is-open': expanded }">▸</span>
            {{ toggleLabel }}
          </button>
        </div>

        <form v-if="isReplying" class="comment-reply-form" @submit.prevent="submitReply">
          <textarea v-model="draft" rows="3" :placeholder="`Respondé a ${nick}…`" required />
          <div class="comment-composer-bar">
            <button type="button" class="comment-cancel" @click="emit('cancel')">Cancelar</button>
            <button type="submit">Publicar respuesta</button>
          </div>
        </form>
      </div>
    </article>

    <ul v-if="thread.children.length && expanded" class="comment-replies">
      <CommentItem
        v-for="child in thread.children"
        :key="child.message.id"
        :thread="child"
        :reply-to-id="replyToId"
        :current-nick="currentNick"
        :reply-to-nick="nick"
        :depth="depth + 1"
        @reply="emit('reply', $event)"
        @cancel="emit('cancel')"
        @send="(content, parentId) => emit('send', content, parentId)"
      />
    </ul>
  </li>
</template>
