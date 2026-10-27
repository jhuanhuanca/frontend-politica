<script setup lang="ts">
import { ref, watch } from 'vue'
import { useRouter } from 'vue-router'

const open = defineModel<boolean>({ default: false })
const router = useRouter()
const query = ref('')

watch(open, (value) => {
  if (value) {
    query.value = ''
  }
})

function submit(): void {
  open.value = false
  router.push({ path: '/debates', query: query.value ? { q: query.value } : {} })
}
</script>

<template>
  <div v-if="open" class="search-modal" @click.self="open = false">
    <form @submit.prevent="submit">
      <input v-model="query" type="search" placeholder="Buscar debates…" autofocus />
      <button class="btn-accent" type="submit" style="margin-top: 10px">Buscar</button>
    </form>
  </div>
</template>
