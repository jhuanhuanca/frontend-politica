<script setup lang="ts">
import LedgerTitle from '@/components/magazine/LedgerTitle.vue'

defineProps<{
  title: string
}>()
</script>

<template>
  <LedgerTitle :title="title" tag="h3" />
</template>
