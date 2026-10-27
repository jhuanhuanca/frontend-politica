<script setup lang="ts">
import { computed, reactive, ref } from 'vue'
import { api, validationMessage } from '@/services/api'
import { DEPARTMENTS } from '@/utils/bolivia'
import '@/styles/viejocracia.css'

const fronts = [
  {
    code: 'FRENTE 01',
    title: 'Clase política tradicional',
    teaser:
      'Desde 2006, oficialismo y oposición histórica han sido ocupados por las mismas figuras, formadas en el mismo ciclo político de los ochenta y noventa. Cambian las siglas; no cambia quién decide.',
    body: 'La Viejocracia política no necesita ganar cada elección: necesita controlar el acceso a las candidaturas, las alianzas y el relato de “experiencia”. Sobrevive a crisis y a promesas de cambio porque no compite por resultados: compite por antigüedad, lealtad acumulada y quién reparte los cargos.',
  },
  {
    code: 'FRENTE 02',
    title: 'Sindicatos y corporativo',
    teaser:
      'COB, federaciones y cooperativas: dirigencias que se perpetúan por control de bases, no por resultados. Ascenso por lealtad y antigüedad, no por representación real de las nuevas generaciones.',
    body: 'Cuando el mandato se vuelve eterno, la representación se vuelve trámite. Las nuevas generaciones pagan cuotas y disciplina, pero no deciden. Renovar acá no es atacar al sindicato: es devolverle el poder a quienes trabajan hoy, no a quienes lo administran desde hace décadas.',
  },
  {
    code: 'FRENTE 03',
    title: 'Élites y herencia de poder',
    teaser:
      'Un número reducido de apellidos concentra capital, crédito y oportunidades, transmitidos de generación en generación. El problema no es que existan grandes empresarios: es que el acceso se hereda en vez de ganarse.',
    body: 'La herencia de poder económico se cruza con la política: crédito, contratos y redes se cierran alrededor de los mismos apellidos. Un país joven no puede crecer si las puertas se abren por linaje y no por mérito, creación o trabajo.',
  },
  {
    code: 'FRENTE 04',
    title: 'La mentalidad conservadora',
    teaser:
      'El frente más importante y menos visible: la Viejocracia también es una forma de pensar, no solo una edad. Combatirla no es cambiar caras viejas por caras jóvenes con el mismo libreto — es cambiar el libreto.',
    body: 'Se puede ser joven y viejócrata. Se puede ser mayor y renovador. El enemigo no es el año de nacimiento: es el atrincheramiento, la idea de que el cargo eterno es experiencia y que pedir recambio es falta de respeto.',
  },
]

const pillars = [
  {
    n: '01',
    title: 'Justicia universal',
    active: false,
    text: 'Las mismas reglas para todos. Sin privilegio de antigüedad, sin impunidad de cúpula, sin atajos de apellido.',
  },
  {
    n: '02',
    title: 'Responsabilidad ciudadana',
    active: true,
    text: 'El poder es un préstamo del pueblo. Quien lo ejerce rinde cuentas, no lo hereda ni lo eterniza.',
  },
  {
    n: '03',
    title: 'Educación superior',
    active: false,
    text: 'Formar liderazgo nuevo en los nueve departamentos, sin filtro de apellido ni peaje de lealtad.',
  },
  {
    n: '04',
    title: 'Revolución íntima',
    active: false,
    text: 'Cambiar el libreto interno. No basta con caras nuevas si el mandato sigue siendo el mismo: atrincherarse.',
  },
  {
    n: '05',
    title: 'Horizontalidad creativa',
    active: true,
    text: 'Las decisiones no bajan de una cúpula. Se construyen con quien va a vivir las consecuencias.',
  },
  {
    n: '06',
    title: 'Política empírica',
    active: false,
    text: 'Resultados medibles, no lealtad acumulada. Un cargo eterno no es experiencia: es un bloqueo.',
  },
  {
    n: '07',
    title: 'Coraje no conforme',
    active: true,
    text: 'Decir que no al atrincheramiento. La juventud no pide permiso para gobernar bien.',
  },
]

const quotes = [
  'El poder no es una herencia: es un préstamo del pueblo',
  'La edad no es el enemigo. El atrincheramiento sí',
  'Un cargo eterno no es experiencia: es un bloqueo',
  'Renovar no es destruir: es oxigenar',
  'Nadie debería esperar veinte años para tener voz',
  'La juventud no pide permiso para gobernar bien',
]

const actions = [
  'Límites de mandato y renovación obligatoria en dirigencias sindicales, gremiales y de cooperativas',
  'Cuotas de renovación generacional: mínimo de candidatos menores de 35 en cada nivel de SCR',
  'Transparencia obligatoria de patrimonio y trayectoria de todo candidato y dirigente',
  'Escuela de Nuevos Liderazgos SCR en los nueve departamentos, sin filtro de apellido',
  'Plataforma pública de Fiscalización Generacional: cuánto tiempo lleva cada dirigente en su cargo',
  'Debates abiertos donde los nuevos liderazgos midan ideas con la vieja guardia, en redes y territorio',
]

const currentYear = new Date().getFullYear()
const years = Array.from({ length: 83 }, (_, i) => currentYear - 18 - i)

const openFront = ref<number | null>(null)
const activePillar = ref<number | null>(null)
const quizChoice = ref<number | null>(null)
const joinForm = reactive({
  full_name: '',
  ci: '',
  email: '',
  phone: '',
  city: '',
  department: '',
  birth_year: '',
  consent: false,
})
const joinLoading = ref(false)
const joinError = ref('')
const joined = ref(false)
const joinMessage = ref('')

const quizResult = computed(() => {
  if (quizChoice.value === 0) {
    return 'Viejocracia instalada: el código se ejecuta en piloto automático.'
  }
  if (quizChoice.value === 1) {
    return 'El código viejo se está craqueando. Falta el plan, no la bronca.'
  }
  if (quizChoice.value === 2) {
    return 'Renovación activa. Ese es el coraje no conforme.'
  }
  return ''
})

const selectedPillar = computed(() =>
  activePillar.value === null ? null : pillars[activePillar.value],
)

function toggleFront(index: number): void {
  openFront.value = openFront.value === index ? null : index
}

function selectPillar(index: number): void {
  activePillar.value = activePillar.value === index ? null : index
}

async function submitJoin(): Promise<void> {
  joinLoading.value = true
  joinError.value = ''

  try {
    const { data } = await api.post<{ message: string }>('/militants', {
      full_name: joinForm.full_name,
      ci: joinForm.ci,
      email: joinForm.email,
      phone: joinForm.phone,
      city: joinForm.city,
      department: joinForm.department,
      birth_year: Number(joinForm.birth_year),
      consent: joinForm.consent,
    })
    joinMessage.value = data.message
    joined.value = true
  } catch (err) {
    joinError.value = validationMessage(err, 'No se pudo completar el registro.')
  } finally {
    joinLoading.value = false
  }
}
</script>

<template>
  <div class="vc">
    <section class="vc-hero">
      <video class="vc-hero-video" autoplay muted loop playsinline>
        <source src="/videos/viejocracia.mp4" type="video/mp4" />
      </video>
      <div class="vc-hero-mask" />
      <div class="vc-hero-copy">
        <p class="vc-kicker">Agrupación Ciudadana · Soberanía Creativa Responsable</p>
        <h1>Viejocracia</h1>
        <p class="vc-lead">El código viejo se está craqueando.</p>
        <p class="vc-hero-text">
          No es una guerra de edad. Es una guerra contra la herencia del poder. Bolivia tiene la
          población más joven de su historia — y la dirigencia más envejecida en su forma de mandar.
        </p>
        <a class="vc-scroll" href="#preambulo">Deslizá para romper el código</a>
      </div>
    </section>

    <div class="vc-wrap">
      <section id="preambulo" class="vc-block" v-reveal>
        <p class="vc-label">Preámbulo</p>
        <blockquote class="vc-quote-plain">
          “Bolivia tiene la población más joven de su historia democrática reciente y, al mismo
          tiempo, la clase dirigente más envejecida en su forma de ejercer el poder.”
        </blockquote>
        <p>
          No hablamos de una guerra de edades. Hablamos de un sistema: uno donde el poder político,
          sindical y económico se hereda en lugar de ganarse, se atrinchera en lugar de renovarse, y
          confunde la permanencia con el mérito. A ese sistema lo llamamos Viejocracia.
        </p>
        <p>
          Este no es un partido nuevo. Es el nombre del problema. Soberanía Creativa Responsable es
          la respuesta — siete pilares para reconstruir Bolivia desde la gente, con la gente y para
          la gente.
        </p>
      </section>

      <section class="vc-block" v-reveal>
        <p class="vc-label">— 01 — El diagnóstico</p>
        <h2>¿Qué es la Viejocracia?</h2>
        <p>
          La concentración y el atrincheramiento del poder en manos de una misma cúpula
          generacional, capaz de sobrevivir a cualquier ciclo electoral, cualquier crisis y
          cualquier promesa de cambio — porque no compite por resultados: compite por antigüedad,
          lealtad acumulada y control de quién reparte los cargos.
        </p>
        <p class="vc-callout">La Viejocracia no se mide en años. Se mide en atrincheramiento.</p>
        <p>
          No es un fenómeno exclusivo de Bolivia. En otros países se ha documentado cómo una
          generación numerosa, al envejecer, termina concentrando voto, riqueza y cargos,
          posponiendo los costos de sus propias decisiones porque no vivirá para pagarlos. En
          Bolivia el mecanismo cambia de forma, no de fondo: la misma cohorte política sigue
          decidiendo el rumbo del país, ya sea desde el oficialismo, la oposición histórica, la
          dirigencia sindical o las cúpulas económicas.
        </p>
      </section>

      <section class="vc-block" v-reveal>
        <p class="vc-label">— 02 — Los cuatro frentes</p>
        <h2>La Viejocracia opera en cuatro frentes que se protegen entre sí</h2>
        <p class="vc-hint">Tocá cada panel para abrirlo.</p>
        <div class="vc-fronts">
          <article v-for="(front, i) in fronts" :key="front.code" class="vc-front">
            <button type="button" :class="{ open: openFront === i }" @click="toggleFront(i)">
              <span>{{ front.code }}</span>
              <strong>{{ front.title }}</strong>
              <p>{{ front.teaser }}</p>
              <em>{{ openFront === i ? '− Cerrar' : '+ Tocar para expandir' }}</em>
            </button>
            <div v-if="openFront === i" class="vc-front-body">{{ front.body }}</div>
          </article>
        </div>
      </section>

      <section class="vc-block" v-reveal>
        <p class="vc-label">— 03 — La brecha real</p>
        <h2>Bolivia es joven. Pero no gobierna joven.</h2>
        <p class="vc-hint">Censo Nacional de Población y Vivienda 2024 (INE) · Proyección ONU-DESA, revisión 2024.</p>
        <div class="vc-stats">
          <article>
            <strong>11.365.333</strong>
            <span>Habitantes en Bolivia</span>
          </article>
          <article>
            <strong>25.0 años</strong>
            <span>Edad mediana del país</span>
          </article>
          <article>
            <strong>57%</strong>
            <span>Población entre 18 y 59 años</span>
          </article>
        </div>
      </section>

      <section class="vc-block" v-reveal>
        <p class="vc-label">— 04 — La maquinaria SCR</p>
        <h2>Viejocracia activa tres de los siete pilares</h2>
        <p class="vc-hint">Los siete engranajes de la Soberanía Creativa Responsable. Tres se encienden con Viejocracia — tocalos para ver por qué.</p>
        <div class="vc-pillars">
          <button
            v-for="(pillar, i) in pillars"
            :key="pillar.n"
            type="button"
            class="vc-gear"
            :class="{ on: pillar.active, selected: activePillar === i }"
            @click="selectPillar(i)"
          >
            <small>PILAR {{ pillar.n }}</small>
            <span>{{ pillar.title }}</span>
          </button>
        </div>
        <p class="vc-hint">{{ selectedPillar ? selectedPillar.text : 'Tocá un engranaje para ver su función.' }}</p>
      </section>
    </div>

    <div class="vc-marquee" aria-hidden="true">
      <div class="vc-marquee-track">
        <span v-for="(quote, i) in [...quotes, ...quotes]" :key="i">{{ quote }}</span>
      </div>
    </div>

    <div class="vc-wrap">
      <section class="vc-block" v-reveal>
        <p class="vc-label">— 05 — Autodiagnóstico</p>
        <h2>¿Tenés Viejocracia corriendo en tu código?</h2>
        <p class="vc-q">1. Cuando ves que en tu sindicato, junta o gremio manda la misma persona hace años…</p>
        <div class="vc-answers">
          <button type="button" :class="{ on: quizChoice === 0 }" @click="quizChoice = 0">
            Ya me acostumbré, así es esto acá
          </button>
          <button type="button" :class="{ on: quizChoice === 1 }" @click="quizChoice = 1">
            Me da bronca pero no sé qué hacer
          </button>
          <button type="button" :class="{ on: quizChoice === 2 }" @click="quizChoice = 2">
            Ya estoy armando cómo cambiarlo
          </button>
        </div>
        <p v-if="quizResult" class="vc-callout">{{ quizResult }}</p>
      </section>

      <section class="vc-block" v-reveal>
        <p class="vc-label">— 06 — Plan de acción</p>
        <h2>Propuestas verificables, no solo consignas</h2>
        <ol class="vc-plan">
          <li v-for="(item, i) in actions" :key="item">
            <span>[{{ String(i + 1).padStart(2, '0') }}]</span>
            {{ item }}
          </li>
        </ol>
      </section>

      <section class="vc-message" v-reveal>
        <p class="vc-label">— 07 — El mensaje</p>
        <h2>Bolivia es joven. Que la gobiernen los que van a vivir sus consecuencias.</h2>
      </section>

      <section class="vc-block vc-activate" v-reveal>
        <p class="vc-label">— 08 — Activación</p>
        <h2>Bolivia no necesita esperar a que la vieja guardia se jubile.</h2>
        <p>
          Necesita una generación dispuesta a asumir la responsabilidad de gobernar antes de que se
          le agote la paciencia.
        </p>
        <form v-if="!joined" class="vc-form" @submit.prevent="submitJoin">
          <p class="vc-form-title">Únete a SCR</p>
          <p v-if="joinError" class="vc-form-error">{{ joinError }}</p>
          <input v-model="joinForm.full_name" type="text" placeholder="Nombre completo" required maxlength="120" />
          <input v-model="joinForm.ci" type="text" placeholder="CI" required maxlength="20" />
          <input v-model="joinForm.email" type="email" placeholder="Email" required maxlength="255" />
          <input v-model="joinForm.phone" type="tel" placeholder="Celular" required maxlength="20" />
          <input v-model="joinForm.city" type="text" placeholder="Ciudad" required maxlength="80" />
          <select v-model="joinForm.department" required>
            <option value="" disabled>Departamento</option>
            <option v-for="department in DEPARTMENTS" :key="department" :value="department">
              {{ department }}
            </option>
          </select>
          <select v-model="joinForm.birth_year" required>
            <option value="" disabled>Año de nacimiento</option>
            <option v-for="year in years" :key="year" :value="year">{{ year }}</option>
          </select>
          <label class="vc-consent">
            <input v-model="joinForm.consent" type="checkbox" required />
            Acepto el tratamiento de estos datos para que se pongan en contacto conmigo.
          </label>
          <button type="submit" :disabled="joinLoading">
            {{ joinLoading ? 'Enviando…' : 'Activar mi renovación' }}
          </button>
        </form>
        <p v-else class="vc-callout">{{ joinMessage }}</p>
      </section>
    </div>

    <footer class="vc-foot">
      <p>Agrupación Ciudadana Soberanía Creativa Responsable</p>
      <p>Por una Bolivia justa, creativa y libre — Bolivia, 2026</p>
    </footer>
  </div>
</template>
