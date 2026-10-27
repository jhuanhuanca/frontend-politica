<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useCatalogStore } from '@/stores/catalog'
import { coverUrl, formatDate } from '@/utils/content'
import { validationMessage } from '@/services/api'
import type { VoteTopic } from '@/types/models'

const route = useRoute()
const catalog = useCatalogStore()
const auth = useAuthStore()
const topic = ref<VoteTopic | null>(null)
const ci = ref('')
const error = ref('')
const ok = ref('')

onMounted(async () => {
  topic.value = await catalog.fetchTopic(Number(route.params.id))
})

async function sign(): Promise<void> {
  if (!topic.value) {
    return
  }

  error.value = ''
  ok.value = ''
  try {
    topic.value = await catalog.signTopic(topic.value.id, ci.value || undefined)
    ok.value = 'Firma registrada.'
  } catch (err) {
    error.value = validationMessage(err, 'Iniciá sesión para firmar.')
  }
}
</script>

<template>
  <div class="page-block">
    <div class="row article" v-if="topic" v-reveal>
      <img
        :src="coverUrl({ id: topic.id, image_url: null }, 4)"
        :alt="topic.title"
        style="width: 100%; max-height: 320px; object-fit: cover; border-radius: 6px"
      />
      <p class="meta" style="margin-top: 16px">
        <span>{{ formatDate(topic.created_at) }}</span>
        <span>{{ topic.author?.nick }}</span>
      </p>
      <h1>{{ topic.title }}</h1>
      <p>{{ topic.description }}</p>
      <div class="progress"><span :style="{ width: `${(topic.progress ?? 0) * 100}%` }" /></div>
      <p>{{ topic.signatures_count }} de {{ topic.target_signatures }} firmas</p>

      <form class="composer" @submit.prevent="sign">
        <p v-if="error" class="form-error">{{ error }}</p>
        <p v-if="ok" style="color: var(--teal)">{{ ok }}</p>
        <input v-model="ci" type="text" placeholder="CI (opcional)" />
        <button type="submit">
          {{ auth.isAuthenticated ? 'Firmar esta propuesta' : 'Iniciar sesión para firmar' }}
        </button>
      </form>
    </div>
  </div>
</template>
