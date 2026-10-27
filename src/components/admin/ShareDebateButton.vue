<script setup lang="ts">
import { computed, ref } from 'vue'
import { copyToClipboard, debatePublicUrl, socialShareLinks } from '@/utils/share'

const props = defineProps<{
  debateId: number
  title: string
}>()

const open = ref(false)
const copied = ref(false)
const url = computed(() => debatePublicUrl(props.debateId))
const social = computed(() => socialShareLinks(props.title, url.value))

function show(): void {
  copied.value = false
  open.value = true
}

async function copy(): Promise<void> {
  copied.value = await copyToClipboard(url.value)
}

function close(): void {
  open.value = false
  copied.value = false
}
</script>

<template>
  <button class="admin-btn admin-btn--ghost" type="button" @click="show">Compartir</button>

  <Teleport to="body">
    <div v-if="open" class="share-overlay" @click.self="close">
      <div class="share-card" role="dialog" aria-labelledby="share-title">
        <h3 id="share-title">Compartir debate</h3>
        <p>{{ title }}</p>
        <label>
          Enlace público
          <input :value="url" type="text" readonly @focus="($event.target as HTMLInputElement).select()" />
        </label>
        <button class="admin-btn" type="button" @click="copy">
          {{ copied ? 'Enlace copiado' : 'Copiar enlace' }}
        </button>
        <div class="share-networks">
          <a class="admin-btn admin-btn--ghost" :href="social.whatsapp" target="_blank" rel="noopener noreferrer">
            WhatsApp
          </a>
          <a class="admin-btn admin-btn--ghost" :href="social.facebook" target="_blank" rel="noopener noreferrer">
            Facebook
          </a>
          <a class="admin-btn admin-btn--ghost" :href="social.x" target="_blank" rel="noopener noreferrer">
            X
          </a>
        </div>
        <button class="admin-btn admin-btn--ghost" type="button" @click="close">Cerrar</button>
      </div>
    </div>
  </Teleport>
</template>

<style scoped>
.share-overlay {
  position: fixed;
  inset: 0;
  z-index: 80;
  display: grid;
  place-items: center;
  padding: 24px;
  background: rgb(0 0 0 / 55%);
}

.share-card {
  width: min(460px, 100%);
  display: grid;
  gap: 12px;
  background: #fff;
  color: var(--ink);
  border: 1px solid rgba(11, 61, 145, 0.12);
  padding: 24px;
}

.share-card h3 {
  font-family: 'Bebas Neue', sans-serif;
  font-size: 28px;
  margin: 0;
  letter-spacing: 0.03em;
  color: var(--navy);
}

.share-card p {
  margin: 0;
  color: var(--muted);
  font-size: 15px;
}

.share-card label {
  display: grid;
  gap: 6px;
  font-size: 13px;
  color: var(--ink);
}

.share-card input {
  background: var(--page);
  color: var(--ink);
  border: 1px solid rgba(11, 61, 145, 0.2);
  padding: 10px 12px;
  font: inherit;
}

.share-networks {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}
</style>
