import { defineStore } from 'pinia'
import { ref } from 'vue'
import { api, validationMessage } from '@/services/api'
import type {
  AdminMilitant,
  AdminSignature,
  AdminSummary,
  AdminUser,
  Debate,
  Paginated,
  Suggestion,
  VoteTopic,
} from '@/types/models'

export const useAdminStore = defineStore('admin', () => {
  const summary = ref<AdminSummary | null>(null)
  const loading = ref(false)
  const error = ref('')

  async function fetchSummary(): Promise<void> {
    const { data } = await api.get<AdminSummary>('/admin/summary')
    summary.value = data
  }

  async function fetchUsers(
    params: { search?: string; department?: string; page?: number } = {},
  ): Promise<Paginated<AdminUser>> {
    const { data } = await api.get<Paginated<AdminUser>>('/admin/users', { params })
    return data
  }

  async function fetchMilitants(
    params: { search?: string; status?: string; page?: number } = {},
  ): Promise<Paginated<AdminMilitant>> {
    const { data } = await api.get<Paginated<AdminMilitant>>('/admin/militants', { params })
    return data
  }

  async function updateMilitantStatus(id: number, status: AdminMilitant['status']): Promise<AdminMilitant> {
    const { data } = await api.patch<{ data: AdminMilitant }>(`/admin/militants/${id}`, { status })
    return data.data
  }

  async function fetchDebates(params: { search?: string; page?: number } = {}): Promise<Paginated<Debate>> {
    const { data } = await api.get<Paginated<Debate>>('/debates', { params: { ...params, per_page: 20 } })
    return data
  }

  async function saveDebate(form: FormData, id?: number): Promise<Debate> {
    const { data } = id
      ? await api.post<{ data: Debate }>(`/debates/${id}`, form)
      : await api.post<{ data: Debate }>('/debates', form)
    return data.data
  }

  async function deleteDebate(id: number): Promise<void> {
    await api.delete(`/debates/${id}`)
  }

  async function fetchTopics(page = 1): Promise<Paginated<VoteTopic>> {
    const { data } = await api.get<Paginated<VoteTopic>>('/vote-topics', { params: { page } })
    return data
  }

  async function saveTopic(payload: Record<string, unknown>, id?: number): Promise<VoteTopic> {
    const { data } = id
      ? await api.patch<{ data: VoteTopic }>(`/vote-topics/${id}`, payload)
      : await api.post<{ data: VoteTopic }>('/vote-topics', payload)
    return data.data
  }

  async function deleteTopic(id: number): Promise<void> {
    await api.delete(`/vote-topics/${id}`)
  }

  async function fetchSignatures(topicId: number, page = 1): Promise<Paginated<AdminSignature>> {
    const { data } = await api.get<Paginated<AdminSignature>>(`/admin/vote-topics/${topicId}/signatures`, {
      params: { page },
    })
    return data
  }

  async function fetchSuggestions(
    params: { search?: string; status?: string; type?: string; page?: number } = {},
  ): Promise<Paginated<Suggestion>> {
    const { data } = await api.get<Paginated<Suggestion>>('/admin/suggestions', { params })
    return data
  }

  async function publishSuggestion(id: number): Promise<Suggestion> {
    const { data } = await api.post<{ data: Suggestion }>(`/admin/suggestions/${id}/publish`)
    return data.data
  }

  async function rejectSuggestion(id: number, adminNote?: string): Promise<Suggestion> {
    const { data } = await api.post<{ data: Suggestion }>(`/admin/suggestions/${id}/reject`, {
      admin_note: adminNote || null,
    })
    return data.data
  }

  function setError(err: unknown, fallback: string): void {
    error.value = validationMessage(err, fallback)
  }

  return {
    summary,
    loading,
    error,
    fetchSummary,
    fetchUsers,
    fetchMilitants,
    updateMilitantStatus,
    fetchDebates,
    saveDebate,
    deleteDebate,
    fetchTopics,
    saveTopic,
    deleteTopic,
    fetchSignatures,
    fetchSuggestions,
    publishSuggestion,
    rejectSuggestion,
    setError,
  }
})
