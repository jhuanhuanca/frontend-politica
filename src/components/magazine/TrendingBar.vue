<script setup lang="ts">
import { computed, ref } from 'vue'
import SearchModal from '@/components/magazine/SearchModal.vue'
import { useCatalogStore } from '@/stores/catalog'
import { formatDate } from '@/utils/content'

const catalog = useCatalogStore()
const index = ref(0)
const searchOpen = ref(false)

const current = computed(() => catalog.trending[index.value] ?? catalog.trending[0])

function prev(): void {
  if (!catalog.trending.length) return
  index.value = (index.value - 1 + catalog.trending.length) % catalog.trending.length
}

function next(): void {
  if (!catalog.trending.length) return
  index.value = (index.value + 1) % catalog.trending.length
}
</script>

<template>
  <div class="trending-bar row" v-reveal="{ from: 'fade', delay: 80 }">
    <div class="trending-label">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <path d="M13 2 4 14h7l-1 8 9-12h-7l1-8z" />
      </svg>
      TRENDING
    </div>
    <div class="ticker" v-if="current">
      <RouterLink :to="`/debates/${current.id}`">{{ current.title }}</RouterLink>
      <small>{{ formatDate(current.created_at) }}</small>
    </div>
    <div class="ticker" v-else>Cargando titulares…</div>
    <div class="header-tools">
      <button class="icon-btn" type="button" aria-label="Anterior" @click="prev">‹</button>
      <button class="icon-btn" type="button" aria-label="Siguiente" @click="next">›</button>
      <div class="social-mini">
        <a href="#" aria-label="Facebook">f</a>
        <a href="#" aria-label="Instagram">ig</a>
        <a href="#" aria-label="X">x</a>
        <a href="#" aria-label="LinkedIn">in</a>
      </div>
      <button class="icon-btn" type="button" aria-label="Buscar" @click="searchOpen = true">⌕</button>
    </div>
  </div>

  <SearchModal v-model="searchOpen" />
</template>
