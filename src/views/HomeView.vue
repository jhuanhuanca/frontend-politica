<script setup lang="ts">
import { computed } from 'vue'
import AdSlot from '@/components/magazine/AdSlot.vue'
import HeroCarousel from '@/components/magazine/HeroCarousel.vue'
import LoginWidget from '@/components/magazine/LoginWidget.vue'
import MagazinePanel from '@/components/magazine/MagazinePanel.vue'
import OverlayCard from '@/components/magazine/OverlayCard.vue'
import PostListItem from '@/components/magazine/PostListItem.vue'
import WidgetBox from '@/components/magazine/WidgetBox.vue'
import { useCatalogStore } from '@/stores/catalog'
import { categoryLabel, coverUrl } from '@/utils/content'

const catalog = useCatalogStore()

const categoryBlocks = computed(() => {
  const preferred = ['economia', 'politica', 'salud', 'educacion']
  const cats = preferred.filter((cat) => catalog.byCategory(cat).length)
  if (cats.length) {
    return cats.slice(0, 3)
  }
  return catalog.categories.slice(0, 3)
})
</script>

<template>
  <HeroCarousel :debates="catalog.hero" />

  <div class="page-body">
    <div class="row magazine-grid">
      <aside>
        <div class="social-blocks">
          <a class="fb" href="#" aria-label="Facebook" v-reveal="{ from: 'left', delay: 0 }">f</a>
          <a class="x" href="#" aria-label="X" v-reveal="{ from: 'left', delay: 80 }">x</a>
          <a class="yt" href="#" aria-label="YouTube" v-reveal="{ from: 'left', delay: 160 }">▶</a>
        </div>
        <WidgetBox title="Anuncio" from="left">
          <AdSlot placement="left" />
        </WidgetBox>
        <WidgetBox title="Últimos debates" from="left" :delay="40">
          <PostListItem v-for="debate in catalog.latest.slice(0, 5)" :key="debate.id" :debate="debate" />
        </WidgetBox>
        <WidgetBox title="Categorías" from="left" :delay="80">
          <ul class="cat-list">
            <li v-for="cat in catalog.categories" :key="cat">
              <RouterLink :to="{ path: '/debates', query: { categoria: cat } }">
                {{ categoryLabel(cat) }}
              </RouterLink>
            </li>
          </ul>
        </WidgetBox>
      </aside>

      <section>
        <MagazinePanel title="Destacados">
          <div class="featured-pair">
            <OverlayCard v-for="debate in catalog.featured" :key="debate.id" :debate="debate" />
          </div>
        </MagazinePanel>

        <MagazinePanel v-for="(cat, i) in categoryBlocks" :key="cat" :title="categoryLabel(cat)">
          <div class="metro" :class="{ 'metro-alt': i === 1 }">
            <OverlayCard
              v-for="debate in catalog.byCategory(cat, 6)"
              :key="debate.id"
              :debate="debate"
            />
          </div>
        </MagazinePanel>

        <MagazinePanel title="Votaciones abiertas">
          <div class="card-row">
            <article v-for="topic in catalog.topics.slice(0, 3)" :key="topic.id" class="thumb-card">
              <RouterLink :to="`/votaciones/${topic.id}`">
                <img :src="coverUrl({ id: topic.id, image_url: null }, 3)" :alt="topic.title" />
              </RouterLink>
              <h3>
                <RouterLink :to="`/votaciones/${topic.id}`">{{ topic.title }}</RouterLink>
              </h3>
              <small class="meta">{{ topic.signatures_count }} / {{ topic.target_signatures }} firmas</small>
            </article>
          </div>
        </MagazinePanel>
      </section>

      <aside>
        <LoginWidget />
        <WidgetBox title="Firmá ahora" from="right" :delay="40">
          <article v-for="topic in catalog.topics.slice(0, 3)" :key="topic.id" class="post-mini">
            <div>
              <h3>
                <RouterLink :to="`/votaciones/${topic.id}`">{{ topic.title }}</RouterLink>
              </h3>
              <div class="progress"><span :style="{ width: `${(topic.progress ?? 0) * 100}%` }" /></div>
              <div class="meta">{{ topic.signatures_count }} firmas</div>
            </div>
          </article>
        </WidgetBox>
        <WidgetBox title="Contra la Viejocracia" from="right" :delay="80">
          <p style="font-size: 14px; color: var(--ink); line-height: 1.6">
            El poder no es una herencia: es un préstamo del pueblo. Bolivia tiene la población más
            joven de su historia y una dirigencia que se atrinchera. Sumate a Soberanía Creativa
            Responsable.
          </p>
          <p style="margin: 12px 0 0">
            <RouterLink to="/viejocracia">Leer el manifiesto</RouterLink>
            &nbsp;·&nbsp;
            <RouterLink to="/sugerencias">Sugerir un tema</RouterLink>
          </p>
        </WidgetBox>
        <WidgetBox title="Anuncio" from="right" :delay="120">
          <AdSlot placement="right" />
        </WidgetBox>
      </aside>
    </div>

    <div class="row" style="padding: 10px 0 40px" v-reveal>
      <AdSlot wide />
    </div>
  </div>
</template>
