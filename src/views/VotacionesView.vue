<script setup lang="ts">
import MagazinePanel from '@/components/magazine/MagazinePanel.vue'
import { useCatalogStore } from '@/stores/catalog'
import { coverUrl } from '@/utils/content'

const catalog = useCatalogStore()
</script>

<template>
  <div class="page-block">
    <div class="row">
      <MagazinePanel title="Votaciones">
        <div class="card-row">
          <article v-for="topic in catalog.topics" :key="topic.id" class="thumb-card">
            <RouterLink :to="`/votaciones/${topic.id}`">
              <img :src="coverUrl({ id: topic.id, image_url: null }, 2)" :alt="topic.title" />
            </RouterLink>
            <h3>
              <RouterLink :to="`/votaciones/${topic.id}`">{{ topic.title }}</RouterLink>
            </h3>
            <div class="progress"><span :style="{ width: `${(topic.progress ?? 0) * 100}%` }" /></div>
            <small class="meta">{{ topic.signatures_count }} / {{ topic.target_signatures }} firmas</small>
          </article>
        </div>
      </MagazinePanel>
    </div>
  </div>
</template>
