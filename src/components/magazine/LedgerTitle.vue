<script setup lang="ts">
withDefaults(
  defineProps<{
    title: string
    tag?: 'h3' | 'h4' | 'h6'
  }>(),
  { tag: 'h3' },
)
</script>

<template>
  <div class="ledger-title">
    <component :is="tag">{{ title }}</component>
  </div>
</template>
