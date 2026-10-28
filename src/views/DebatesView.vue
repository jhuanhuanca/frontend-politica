<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import MagazinePanel from '@/components/magazine/MagazinePanel.vue'
import OverlayCard from '@/components/magazine/OverlayCard.vue'
import { useCatalogStore } from '@/stores/catalog'
import { categoryLabel } from '@/utils/content'

const route = useRoute()
const catalog = useCatalogStore()

const filtered = computed(() => {
  const cat = typeof route.query.categoria === 'string' ? route.query.categoria : ''
  const q = typeof route.query.q === 'string' ? route.query.q.toLowerCase() : ''
  return catalog.debates.filter((debate) => {
    const byCat = cat ? debate.category === cat : true
    const byQ = q ? debate.title.toLowerCase().includes(q) : true
    return byCat && byQ
  })
})

const heading = computed(() => {
  if (typeof route.query.categoria === 'string') {
    return categoryLabel(route.query.categoria)
  }
  if (typeof route.query.q === 'string' && route.query.q) {
    return `Resultados: ${route.query.q}`
  }
  return 'Todos los debates'
})
</script>

<template>
  <div class="page-block">
    <div class="row">
      <MagazinePanel :title="heading">
        <p v-if="!filtered.length">Todavía no hay debates en esta sección. Volvé pronto.</p>
        <div v-else class="metro">
          <OverlayCard v-for="debate in filtered" :key="debate.id" :debate="debate" />
        </div>
      </MagazinePanel>
    </div>
  </div>
</template>
