<script setup lang="ts">
import LedgerTitle from '@/components/magazine/LedgerTitle.vue'
import type { RevealFrom } from '@/directives/reveal'

withDefaults(
  defineProps<{
    title: string
    from?: RevealFrom
    delay?: number
  }>(),
  { from: 'up', delay: 0 },
)
</script>

<template>
  <section class="magazine-block" v-reveal="{ from, delay }">
    <LedgerTitle :title="title" tag="h3" />
    <div class="magazine-panel">
      <slot />
    </div>
  </section>
</template>
