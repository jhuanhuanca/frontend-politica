<script setup lang="ts">
import { onMounted } from 'vue'
import AuthModal from '@/components/magazine/AuthModal.vue'
import SiteHeader from '@/components/magazine/SiteHeader.vue'
import TrendingBar from '@/components/magazine/TrendingBar.vue'
import SiteFooter from '@/components/magazine/SiteFooter.vue'
import { useAuthStore } from '@/stores/auth'
import { useCatalogStore } from '@/stores/catalog'

const auth = useAuthStore()
const catalog = useCatalogStore()

onMounted(async () => {
  await Promise.all([auth.hydrate(), catalog.fetchHome()])
})

function toTop(): void {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}
</script>

<template>
  <div class="site-shell" style="background: #fff">
    <SiteHeader />
    <TrendingBar />
    <main>
      <RouterView />
    </main>
    <SiteFooter />
  </div>
  <button class="back-top" type="button" aria-label="Volver arriba" @click="toTop">↑</button>
  <AuthModal />
</template>
