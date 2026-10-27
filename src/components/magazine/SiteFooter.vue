<script setup lang="ts">
import { computed, ref } from 'vue'
import LedgerTitle from '@/components/magazine/LedgerTitle.vue'
import OverlayCard from '@/components/magazine/OverlayCard.vue'
import PostListItem from '@/components/magazine/PostListItem.vue'
import { useCatalogStore } from '@/stores/catalog'

const catalog = useCatalogStore()
const email = ref('')
const joined = ref(false)
const slide = ref(0)

function subscribe(): void {
  joined.value = true
}

function nextSlide(): void {
  if (!catalog.hero.length) return
  slide.value = (slide.value + 1) % Math.min(catalog.hero.length, 4)
}

function prevSlide(): void {
  if (!catalog.hero.length) return
  const total = Math.min(catalog.hero.length, 4)
  slide.value = (slide.value - 1 + total) % total
}

const slideCount = computed(() => Math.min(catalog.hero.length, 4))
</script>

<template>
  <footer class="site-footer">
    <div class="row footer-grid">
      <div class="footer-widget" v-reveal="{ delay: 0 }">
        <LedgerTitle title="Debates populares" tag="h4" />
        <PostListItem v-for="debate in catalog.popular" :key="debate.id" :debate="debate" />
      </div>
      <div class="footer-widget" v-reveal="{ delay: 80 }">
        <LedgerTitle title="Al azar" tag="h4" />
        <PostListItem v-for="debate in catalog.random" :key="debate.id" :debate="debate" />
      </div>
      <div class="footer-widget" v-reveal="{ delay: 160 }">
        <LedgerTitle title="En portada" tag="h4" />
        <OverlayCard v-if="catalog.hero[slide]" :debate="catalog.hero[slide]" />
        <div class="hero-dots slideshow-nav">
          <button type="button" aria-label="Anterior" @click="prevSlide">‹</button>
          <button
            v-for="n in slideCount"
            :key="n"
            type="button"
            :class="{ active: slide === n - 1 }"
            :aria-label="`Diapositiva ${n}`"
            @click="slide = n - 1"
          />
          <button type="button" aria-label="Siguiente" @click="nextSlide">›</button>
        </div>
      </div>
      <div class="footer-widget newsletter" v-reveal="{ delay: 240 }">
        <LedgerTitle title="Boletín" tag="h4" />
        <p>Avisos de debates, firmas y llamados de Soberanía Creativa Responsable. Sin consigna vacía.</p>
        <form v-if="!joined" @submit.prevent="subscribe">
          <input v-model="email" type="email" placeholder="Tu email…" required />
          <button class="btn-accent" type="submit">Unirme</button>
        </form>
        <p v-else>Listo. Cuando haya un nuevo llamado, te escribimos.</p>
        <div style="margin-top: 28px">
          <LedgerTitle title="Redes" tag="h4" />
        </div>
        <div class="social-colored">
          <a class="bg-fb" href="#" aria-label="Facebook">f</a>
          <a class="bg-tw" href="#" aria-label="X">x</a>
          <a class="bg-ig" href="#" aria-label="Instagram">ig</a>
          <a class="bg-in" href="#" aria-label="LinkedIn">in</a>
          <a class="bg-yt" href="#" aria-label="YouTube">yt</a>
        </div>
      </div>
    </div>
    <div class="row footer-bar" v-reveal="{ from: 'fade' }">
      <span>© {{ new Date().getFullYear() }} Viejocracia. Participación ciudadana.</span>
      <nav>
        <RouterLink to="/">Inicio</RouterLink>
        <RouterLink to="/debates">Debates</RouterLink>
        <RouterLink to="/viejocracia">Viejocracia</RouterLink>
        <RouterLink to="/votaciones">Votaciones</RouterLink>
        <RouterLink to="/sugerencias">Sugerencias</RouterLink>
        <RouterLink to="/privacidad">Privacidad</RouterLink>
      </nav>
    </div>
  </footer>
</template>
