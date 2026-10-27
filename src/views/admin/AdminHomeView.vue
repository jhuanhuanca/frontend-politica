<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useAdminStore } from '@/stores/admin'
import type { AdminMonthlyPoint } from '@/types/models'

const admin = useAdminStore()
const stats = computed(() => admin.summary?.stats)
const departments = computed(() => stats.value?.departments ?? [])
const emptyDepartments = computed(() => departments.value.filter((item) => item.leaders.length === 0))

function barWidth(points: AdminMonthlyPoint[], total: number): string {
  const max = Math.max(...points.map((item) => item.total), 1)
  return `${Math.round((total / max) * 100)}%`
}

function sideLabel(side: string): string {
  if (side === 'izquierda') return 'Izquierda'
  if (side === 'derecha') return 'Derecha'
  return 'Centro'
}

onMounted(async () => {
  admin.error = ''
  try {
    await admin.fetchSummary()
  } catch (err) {
    admin.setError(err, 'No se pudo cargar el resumen.')
  }
})
</script>

<template>
  <div>
    <h1>Resumen</h1>
    <p class="admin-muted">
      Totales del sitio y actividad desde {{ stats?.from_label ?? 'agosto 2026' }}.
    </p>
    <p v-if="admin.error" class="admin-error">{{ admin.error }}</p>

    <div v-if="admin.summary" class="admin-cards">
      <div class="admin-card">
        <strong>{{ stats?.comments_this_month ?? 0 }}</strong>
        <span>Comentarios este mes</span>
      </div>
      <div class="admin-card">
        <strong>{{ stats?.users_this_month ?? 0 }}</strong>
        <span>Usuarios nuevos este mes</span>
      </div>
      <div class="admin-card">
        <strong>{{ stats?.militants_this_month ?? 0 }}</strong>
        <span>Militantes este mes</span>
      </div>
      <div class="admin-card">
        <strong>{{ stats?.votes_reached_goal ?? 0 }}</strong>
        <span>Votaciones que llegaron a la meta</span>
      </div>
      <RouterLink class="admin-card" :to="{ name: 'admin-suggestions' }">
        <strong>{{ admin.summary.suggestions_pending ?? 0 }}</strong>
        <span>Sugerencias pendientes</span>
      </RouterLink>
    </div>

    <section v-if="stats?.most_commented_debate" class="admin-highlight">
      <h2>Debate más comentado del mes</h2>
      <p>
        <strong>{{ stats.most_commented_debate.title }}</strong>
        — {{ stats.most_commented_debate.messages_count }} comentarios
      </p>
      <RouterLink class="admin-btn admin-btn--ghost" :to="{ name: 'admin-debate-edit', params: { id: stats.most_commented_debate.id } }">
        Ver debate
      </RouterLink>
    </section>

    <div v-if="stats" class="admin-stats-grid">
      <section class="admin-panel">
        <h2>Militantes por mes</h2>
        <p class="admin-muted">Desde {{ stats.from_label }}</p>
        <div class="admin-bars">
          <div v-for="row in stats.militants_by_month" :key="row.month" class="admin-bar-row">
            <span>{{ row.label }}</span>
            <div class="admin-bar-track">
              <div class="admin-bar-fill" :style="{ width: barWidth(stats.militants_by_month, row.total) }"></div>
            </div>
            <strong>{{ row.total }}</strong>
          </div>
        </div>
      </section>

      <section class="admin-panel">
        <h2>Usuarios nuevos por mes</h2>
        <p class="admin-muted">Desde {{ stats.from_label }}</p>
        <div class="admin-bars">
          <div v-for="row in stats.users_by_month" :key="row.month" class="admin-bar-row">
            <span>{{ row.label }}</span>
            <div class="admin-bar-track">
              <div class="admin-bar-fill" :style="{ width: barWidth(stats.users_by_month, row.total) }"></div>
            </div>
            <strong>{{ row.total }}</strong>
          </div>
        </div>
      </section>

      <section class="admin-panel">
        <h2>Comentarios por mes</h2>
        <p class="admin-muted">Desde {{ stats.from_label }}</p>
        <div class="admin-bars">
          <div v-for="row in stats.comments_by_month" :key="row.month" class="admin-bar-row">
            <span>{{ row.label }}</span>
            <div class="admin-bar-track">
              <div class="admin-bar-fill" :style="{ width: barWidth(stats.comments_by_month, row.total) }"></div>
            </div>
            <strong>{{ row.total }}</strong>
          </div>
        </div>
      </section>
    </div>

    <section v-if="stats?.spectrum?.length" class="admin-panel admin-panel--wide">
      <h2>Espectro político</h2>
      <p class="admin-muted">
        Modelo de muestra: izquierda, centro y derecha. Combina actividad real con una línea base de lectura.
      </p>
      <div class="spectrum-track">
        <div
          v-for="side in stats.spectrum"
          :key="side.key"
          class="spectrum-fill"
          :class="`spectrum-fill--${side.key}`"
          :style="{ width: `${side.percent}%` }"
        >
          {{ side.percent }}%
        </div>
      </div>
      <div class="spectrum-legend">
        <span v-for="side in stats.spectrum" :key="side.key" :class="`spectrum-dot spectrum-dot--${side.key}`">
          {{ side.label }} · {{ side.percent }}%
        </span>
      </div>
    </section>

    <section v-if="departments.length" class="admin-panel admin-panel--wide">
      <h2>Mapa territorial</h2>
      <p class="admin-muted">
        Usuarios, militantes y actividad por departamento. El puntaje de liderazgo suma comentarios (×2),
        debates tocados (×4), firmas (×3), sugerencias (×5) y sugerencias publicadas (×8).
      </p>
      <p v-if="stats?.unassigned_users" class="admin-muted">
        {{ stats.unassigned_users }} cuentas todavía no cargaron departamento.
      </p>
      <div class="dept-grid">
        <a
          v-for="dept in departments"
          :key="dept.slug"
          class="dept-card"
          :class="{ 'dept-card--empty': dept.leaders.length === 0 }"
          :href="`#dept-${dept.slug}`"
        >
          <h3>{{ dept.name }}</h3>
          <p>
            {{ dept.users }} usuarios · {{ dept.militants }} militantes
          </p>
          <p class="admin-muted" style="margin: 0">
            {{ dept.comments }} comentarios · {{ dept.signatures }} firmas · {{ dept.suggestions }} sugerencias
          </p>
          <strong v-if="dept.leaders[0]">{{ dept.leaders[0].nick }} · {{ dept.leaders[0].score }} pts</strong>
          <span v-else class="admin-muted">Sin referente todavía</span>
        </a>
      </div>
      <p v-if="emptyDepartments.length" class="admin-muted">
        Sin referentes claros:
        {{ emptyDepartments.map((item) => item.name).join(', ') }}.
      </p>
    </section>

    <section v-if="stats?.leaders?.length" class="admin-panel admin-panel--wide">
      <h2>Posibles representantes</h2>
      <p class="admin-muted">
        Ranking nacional para elegir vocerías. Las filas de muestra aparecen solo si todavía no hay actividad real.
      </p>
      <div class="admin-table-wrap">
        <table class="admin-table">
          <thead>
            <tr>
              <th>Persona</th>
              <th>Departamento</th>
              <th>Lado</th>
              <th>Debates</th>
              <th>Comentarios</th>
              <th>Firmas</th>
              <th>Sugerencias</th>
              <th>Puntaje</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in stats.leaders" :key="item.nick">
              <td>
                <strong>{{ item.name }}</strong>
                <div class="admin-muted" style="margin: 0">{{ item.nick }}</div>
              </td>
              <td>{{ item.department ?? 'Sin departamento' }}</td>
              <td>
                <span class="admin-badge" :class="`admin-badge--${item.side}`">{{ sideLabel(item.side) }}</span>
              </td>
              <td>{{ item.debates_touched }}</td>
              <td>{{ item.messages_count }}</td>
              <td>{{ item.signatures_count }}</td>
              <td>{{ item.suggestions_count }}<template v-if="item.accepted_suggestions_count"> / {{ item.accepted_suggestions_count }} pub.</template></td>
              <td>{{ item.score }}</td>
              <td>
                <span v-if="item.sample" class="admin-badge admin-badge--closed">Muestra</span>
                <span v-else class="admin-badge">Actividad real</span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <section v-if="departments.length" class="admin-panel admin-panel--wide">
      <h2>Referentes por departamento</h2>
      <p class="admin-muted">Hasta tres perfiles con más iniciativa y conversación en cada territorio.</p>
      <div class="dept-leaders">
        <article v-for="dept in departments" :id="`dept-${dept.slug}`" :key="dept.slug" class="dept-leader-block">
          <h3>{{ dept.name }}</h3>
          <p v-if="!dept.leaders.length" class="admin-muted">Todavía no hay una figura con actividad suficiente.</p>
          <ol v-else>
            <li v-for="item in dept.leaders" :key="item.nick">
              <strong>{{ item.nick }}</strong>
              <span>{{ item.score }} pts · {{ item.messages_count }} comentarios · {{ item.signatures_count }} firmas · {{ item.suggestions_count }} sugerencias</span>
            </li>
          </ol>
        </article>
      </div>
    </section>

    <section v-if="stats?.cleavages?.length" class="admin-panel admin-panel--wide">
      <h2>Otros clivajes de muestra</h2>
      <p class="admin-muted">Lecturas políticas adicionales para comparar lados, no son una votación formal.</p>
      <div class="cleavage-list">
        <div v-for="item in stats.cleavages" :key="item.key" class="cleavage-row">
          <h3>{{ item.label }}</h3>
          <div class="spectrum-track">
            <div class="spectrum-fill spectrum-fill--izquierda" :style="{ width: `${item.left_percent}%` }">
              {{ item.left }} {{ item.left_percent }}%
            </div>
            <div class="spectrum-fill spectrum-fill--derecha" :style="{ width: `${item.right_percent}%` }">
              {{ item.right }} {{ item.right_percent }}%
            </div>
          </div>
        </div>
      </div>
    </section>

    <section v-if="stats?.top_debates.length" class="admin-panel admin-panel--wide">
      <h2>Temas más comentados este mes</h2>
      <div class="admin-table-wrap">
        <table class="admin-table">
          <thead>
            <tr>
              <th>Debate</th>
              <th>Comentarios</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in stats.top_debates" :key="item.id">
              <td>
                <RouterLink :to="{ name: 'admin-debate-edit', params: { id: item.id } }">{{ item.title }}</RouterLink>
              </td>
              <td>{{ item.messages_count }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <section v-if="stats?.votes_reached.length" class="admin-panel admin-panel--wide">
      <h2>Votaciones que llegaron a la meta</h2>
      <div class="admin-table-wrap">
        <table class="admin-table">
          <thead>
            <tr>
              <th>Votación</th>
              <th>Firmas</th>
              <th>Meta</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in stats.votes_reached" :key="item.id">
              <td>
                <RouterLink :to="{ name: 'admin-vote-edit', params: { id: item.id } }">{{ item.title }}</RouterLink>
              </td>
              <td>{{ item.signatures_count }}</td>
              <td>{{ item.target_signatures }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <h2 v-if="admin.summary" class="admin-section-title">Totales generales</h2>
    <div v-if="admin.summary" class="admin-cards">
      <div class="admin-card">
        <strong>{{ admin.summary.debates }}</strong>
        <span>Debates</span>
      </div>
      <div class="admin-card">
        <strong>{{ admin.summary.users }}</strong>
        <span>Usuarios</span>
      </div>
      <div class="admin-card">
        <strong>{{ admin.summary.militants }}</strong>
        <span>Militantes</span>
      </div>
      <div class="admin-card">
        <strong>{{ admin.summary.militants_pending }}</strong>
        <span>Pendientes de padrón</span>
      </div>
      <div class="admin-card">
        <strong>{{ admin.summary.vote_topics }}</strong>
        <span>Votaciones</span>
      </div>
      <div class="admin-card">
        <strong>{{ admin.summary.signatures }}</strong>
        <span>Firmas</span>
      </div>
    </div>
  </div>
</template>
