<script setup lang="ts">
import { computed, onUnmounted, ref, watch } from 'vue'
import { useCatalogStore } from '@/stores/catalog'
import { rewriteMedia } from '@/utils/content'
import type { AdSlotName } from '@/types/models'

const props = withDefaults(
  defineProps<{
    placement?: AdSlotName
    label?: string
    wide?: boolean
    header?: boolean
  }>(),
  { wide: false, header: false },
)

const catalog = useCatalogStore()
const index = ref(0)
let timer: ReturnType<typeof setInterval> | null = null

const items = computed(() => (props.placement ? catalog.adsBySlot(props.placement) : []))
const current = computed(() => items.value[index.value] ?? null)

watch(
  items,
  (list) => {
    if (timer) {
      clearInterval(timer)
      timer = null
    }
    if (index.value >= list.length) {
      index.value = 0
    }
    if (list.length > 1) {
      timer = setInterval(() => {
        index.value = (index.value + 1) % list.length
      }, 10_000)
    }
  },
  { immediate: true },
)

onUnmounted(() => {
  if (timer) {
    clearInterval(timer)
  }
})
</script>

<template>
  <div
    class="ad-slot"
    :class="{
      'ad-wide': wide,
      'ad-box': !wide && !header,
      'ad-header': header,
      'has-ad': Boolean(current?.image_url),
    }"
  >
    <template v-if="current?.image_url">
      <component
        :is="current.link_url ? 'a' : 'div'"
        class="ad-slot__link"
        :href="current.link_url || undefined"
        :target="current.link_url ? '_blank' : undefined"
        :rel="current.link_url ? 'noopener noreferrer' : undefined"
      >
        <Transition name="ad-fade" mode="out-in">
          <img
            :key="current.id"
            class="ad-slot__image"
            :src="rewriteMedia(current.image_url)"
            :alt="current.title || 'Anuncio'"
          />
        </Transition>
      </component>
      <div v-if="items.length > 1" class="ad-slot__dots">
        <span
          v-for="(item, i) in items"
          :key="item.id"
          :class="{ active: i === index }"
        />
      </div>
    </template>
    <span v-else>{{ label ?? 'Espacio publicitario' }}</span>
  </div>
</template>
