<script setup lang="ts">
import { computed } from 'vue'
import type { Debate } from '@/types/models'
import { coverUrl, formatDate } from '@/utils/content'

const props = withDefaults(
  defineProps<{
    debate: Debate
    compact?: boolean
  }>(),
  { compact: false },
)

const image = computed(() => coverUrl(props.debate))
</script>

<template>
  <RouterLink :to="`/debates/${debate.id}`" class="overlay-card">
    <img :src="image" :alt="debate.title" />
    <div class="details">
      <h3>{{ debate.title }}</h3>
      <small v-if="!compact" class="meta">
        <span>
          <svg viewBox="0 0 24 24" aria-hidden="true"><rect x="3" y="5" width="18" height="16" rx="2" /><path d="M3 10h18M8 3v4M16 3v4" /></svg>
          {{ formatDate(debate.created_at) }}
        </span>
        <span>
          <svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="8" r="3.5" /><path d="M5 20c1.2-3.5 3.8-5 7-5s5.8 1.5 7 5" /></svg>
          {{ debate.author?.nick ?? 'Redacción' }}
        </span>
        <span>
          <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 6h14v10H9l-4 4V6z" /></svg>
          {{ debate.messages_count ?? 0 }}
        </span>
      </small>
    </div>
  </RouterLink>
</template>
