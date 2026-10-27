<script setup lang="ts">
import MagazinePanel from '@/components/magazine/MagazinePanel.vue'
import { PRIVACY_SECTIONS } from '@/content/privacy'
</script>

<template>
  <div class="page-block">
    <div class="row article">
      <MagazinePanel title="Privacidad">
        <h1>Políticas de privacidad y recolección de datos</h1>
        <p>
          Viejocracia es una plataforma de participación ciudadana. Esta política explica qué datos
          pedimos al crear una cuenta, para qué los usamos y qué derechos tenés.
        </p>
        <section v-for="section in PRIVACY_SECTIONS" :key="section.title" class="privacy-section">
          <h2>{{ section.title }}</h2>
          <p>{{ section.body }}</p>
        </section>
        <p class="form-lead">
          Al registrarte marcás que leíste y aceptás esta política. Si cambia de forma relevante, lo
          avisaremos en el sitio.
        </p>
      </MagazinePanel>
    </div>
  </div>
</template>
