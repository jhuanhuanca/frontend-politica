<script setup lang="ts">
import OverlayCard from '@/components/magazine/OverlayCard.vue'
import type { Debate } from '@/types/models'

defineProps<{
  debates: Debate[]
}>()
</script>

<template>
  <section>
    <div v-if="!debates.length" class="row" style="padding: 40px 0; text-align: center; color: var(--muted)" v-reveal>
      Todavía no hay debates en portada. Volvé en un rato.
    </div>
    <div v-else class="hero-strip">
      <OverlayCard
        v-for="(debate, i) in debates.slice(0, 5)"
        :key="debate.id"
        v-reveal="{ delay: i * 90 }"
        :debate="debate"
      />
    </div>
  </section>
</template>
