<script setup lang="ts">
import { computed, onMounted, onUnmounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import SiteHeader from '@/components/magazine/SiteHeader.vue'
import TrendingBar from '@/components/magazine/TrendingBar.vue'
import SiteFooter from '@/components/magazine/SiteFooter.vue'
import { useAuthStore } from '@/stores/auth'
import { useCatalogStore } from '@/stores/catalog'

const route = useRoute()
const auth = useAuthStore()
const catalog = useCatalogStore()

const isNoir = computed(() => route.meta.theme === 'noir')

onMounted(async () => {
  await Promise.all([auth.hydrate(), catalog.fetchHome()])
})

watch(
  isNoir,
  (value) => {
    document.documentElement.classList.toggle('theme-noir', value)
  },
  { immediate: true },
)

onUnmounted(() => {
  document.documentElement.classList.remove('theme-noir')
})

function toTop(): void {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}
</script>

<template>
  <div class="site-shell" :class="{ 'site-shell--noir': isNoir }">
    <SiteHeader />
    <TrendingBar v-if="!isNoir" />
    <main>
      <RouterView />
    </main>
    <SiteFooter v-if="!isNoir" />
  </div>
  <button class="back-top" type="button" aria-label="Volver arriba" @click="toTop">↑</button>
</template>
