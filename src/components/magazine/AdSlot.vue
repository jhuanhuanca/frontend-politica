<script setup lang="ts">
withDefaults(
  defineProps<{
    label?: string
    wide?: boolean
    header?: boolean
  }>(),
  { wide: false, header: false },
)
</script>

<template>
  <div
    class="ad-slot"
    :class="{
      'ad-wide': wide,
      'ad-box': !wide && !header,
      'ad-header': header,
    }"
  >
    {{ label ?? 'Espacio publicitario' }}
  </div>
</template>
