<script setup lang="ts">
import type { Debate } from '@/types/models'
import { coverUrl, formatDate } from '@/utils/content'

defineProps<{
  debate: Debate
  views?: number
}>()
</script>

<template>
  <article class="post-mini">
    <RouterLink :to="`/debates/${debate.id}`">
      <img :src="coverUrl(debate)" :alt="debate.title" />
    </RouterLink>
    <div>
      <h3>
        <RouterLink :to="`/debates/${debate.id}`">{{ debate.title }}</RouterLink>
      </h3>
      <div class="meta">
        <span>
          <svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="8" /><path d="M12 8v5l3 2" /></svg>
          {{ formatDate(debate.created_at) }}
        </span>
        <span>
          <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M2 12s4-6 10-6 10 6 10 6-4 6-10 6S2 12 2 12z" /><circle cx="12" cy="12" r="2.5" /></svg>
          {{ views ?? debate.messages_count ?? 0 }}
        </span>
      </div>
    </div>
  </article>
</template>
