import { createRouter, createWebHistory } from 'vue-router'
import MagazineLayout from '@/layouts/MagazineLayout.vue'
import HomeView from '@/views/HomeView.vue'
import DebatesView from '@/views/DebatesView.vue'
import DebateShowView from '@/views/DebateShowView.vue'
import VotacionesView from '@/views/VotacionesView.vue'
import VotacionShowView from '@/views/VotacionShowView.vue'
import SugerenciasView from '@/views/SugerenciasView.vue'
import { useAuthStore } from '@/stores/auth'

export const router = createRouter({
  history: createWebHistory(),
  scrollBehavior(to) {
    if (to.hash) {
      return { el: to.hash }
    }
    return { top: 0 }
  },
  routes: [
    {
      path: '/',
      component: MagazineLayout,
      children: [
        { path: '', name: 'home', component: HomeView },
        { path: 'viejocracia', redirect: { name: 'home' } },
        { path: 'debates', name: 'debates', component: DebatesView },
        { path: 'debates/:id', name: 'debate', component: DebateShowView },
        { path: 'votaciones', name: 'votaciones', component: VotacionesView },
        { path: 'votaciones/:id', name: 'votacion', component: VotacionShowView },
        { path: 'sugerencias', name: 'sugerencias', component: SugerenciasView },
        { path: 'privacidad', name: 'privacidad', component: () => import('@/views/PrivacyView.vue') },
        { path: 'militancia', redirect: { name: 'sugerencias' } },
      ],
    },
    {
      path: '/admin/login',
      name: 'admin-login',
      component: () => import('@/views/admin/AdminLoginView.vue'),
      meta: { adminGuest: true },
    },
    {
      path: '/admin',
      component: () => import('@/layouts/AdminLayout.vue'),
      meta: { requiresAdmin: true },
      children: [
        { path: '', name: 'admin-home', component: () => import('@/views/admin/AdminHomeView.vue') },
        { path: 'debates', name: 'admin-debates', component: () => import('@/views/admin/AdminDebatesView.vue') },
        { path: 'debates/nuevo', name: 'admin-debate-new', component: () => import('@/views/admin/AdminDebateFormView.vue') },
        { path: 'debates/:id/editar', name: 'admin-debate-edit', component: () => import('@/views/admin/AdminDebateFormView.vue') },
        { path: 'usuarios', name: 'admin-users', component: () => import('@/views/admin/AdminUsersView.vue') },
        { path: 'militantes', name: 'admin-militants', component: () => import('@/views/admin/AdminMilitantsView.vue') },
        { path: 'sugerencias', name: 'admin-suggestions', component: () => import('@/views/admin/AdminSuggestionsView.vue') },
        { path: 'votaciones', name: 'admin-votes', component: () => import('@/views/admin/AdminVotesView.vue') },
        { path: 'votaciones/nueva', name: 'admin-vote-new', component: () => import('@/views/admin/AdminVoteFormView.vue') },
        { path: 'votaciones/:id', name: 'admin-vote-edit', component: () => import('@/views/admin/AdminVoteFormView.vue') },
        { path: 'anuncios', name: 'admin-ads', component: () => import('@/views/admin/AdminAdsView.vue') },
      ],
    },
  ],
})

router.beforeEach(async (to) => {
  const auth = useAuthStore()

  if (auth.token && !auth.user) {
    await auth.hydrate()
  }

  if (to.meta.requiresAdmin && !auth.isAdmin) {
    return { name: 'admin-login', query: { redirect: to.fullPath } }
  }

  if (to.meta.adminGuest && auth.isAdmin) {
    return { name: 'admin-home' }
  }
})
