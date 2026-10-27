<script setup lang="ts">
import LoginWidget from '@/components/magazine/LoginWidget.vue'
import MagazinePanel from '@/components/magazine/MagazinePanel.vue'
import MilitantRegister from '@/components/magazine/MilitantRegister.vue'
import { useAuthStore } from '@/stores/auth'

const auth = useAuthStore()
</script>

<template>
  <div class="page-block">
    <div class="row split-page">
      <article class="article">
        <MagazinePanel title="Militancia">
          <h1>Bolivia es joven. Que la gobiernen quienes van a vivir las consecuencias.</h1>
          <p>
            La Viejocracia no es una guerra de edades. Es un sistema: el poder político, sindical y
            económico se hereda en vez de ganarse, se atrinchera en vez de renovarse y confunde
            permanencia con mérito.
          </p>
          <p>
            Soberanía Creativa Responsable convoca a militantes en los nueve departamentos para
            oxigenar dirigencias, abrir debates y firmar lo que la vieja guardia pospone. El poder
            no es una herencia: es un préstamo del pueblo.
          </p>
          <p v-if="auth.user">
            Ya estás en el debate como <strong>{{ auth.user.nick }}</strong>. Completá el registro
            de abajo si querés militar en territorio: nos vamos a poner en contacto.
          </p>
          <p v-else>
            Entrá a la derecha para debatir y firmar. El formulario de abajo es para militar con
            SCR: no hace falta esperar a que la vieja guardia se jubile.
          </p>
        </MagazinePanel>

        <MilitantRegister />
      </article>
      <aside>
        <LoginWidget />
      </aside>
    </div>
  </div>
</template>
