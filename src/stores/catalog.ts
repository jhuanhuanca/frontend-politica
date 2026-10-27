import { defineStore } from 'pinia'
import { computed, ref } from 'vue'
import { api } from '@/services/api'
import type { Debate, DebateMessage, Paginated, VoteTopic } from '@/types/models'

export const useCatalogStore = defineStore('catalog', () => {
  const debates = ref<Debate[]>([])
  const topics = ref<VoteTopic[]>([])
  const loading = ref(false)

  const latest = computed(() => debates.value.slice(0, 8))
  const featured = computed(() => debates.value.slice(0, 2))
  const hero = computed(() => debates.value.slice(0, 10))
  const trending = computed(() => debates.value.slice(0, 5))
  const popular = computed(() => [...debates.value].sort((a, b) => (b.messages_count ?? 0) - (a.messages_count ?? 0)).slice(0, 3))
  const random = computed(() => [...debates.value].slice().reverse().slice(0, 3))
  const categories = computed(() => {
    const set = new Set(debates.value.map((item) => item.category).filter(Boolean) as string[])
    return [...set]
  })

  function byCategory(category: string, limit = 6): Debate[] {
    return debates.value.filter((item) => item.category === category).slice(0, limit)
  }

  async function fetchHome(): Promise<void> {
    loading.value = true
    try {
      const [debatesRes, topicsRes] = await Promise.all([
        api.get<Paginated<Debate>>('/debates', { params: { per_page: 20 } }),
        api.get<Paginated<VoteTopic>>('/vote-topics'),
      ])
      debates.value = debatesRes.data.data
      topics.value = topicsRes.data.data
    } finally {
      loading.value = false
    }
  }

  async function fetchDebate(id: number): Promise<Debate> {
    const { data } = await api.get<{ data: Debate }>(`/debates/${id}`)
    return data.data
  }

  async function fetchMessages(id: number): Promise<DebateMessage[]> {
    const { data } = await api.get<Paginated<DebateMessage>>(`/debates/${id}/messages`, {
      params: { per_page: 100 },
    })
    return data.data
  }

  async function postMessage(id: number, content: string, parentId?: number | null): Promise<DebateMessage> {
    const { data } = await api.post<{ data: DebateMessage }>(`/debates/${id}/messages`, {
      content,
      parent_id: parentId ?? null,
    })
    return data.data
  }

  async function fetchTopic(id: number): Promise<VoteTopic> {
    const { data } = await api.get<{ data: VoteTopic }>(`/vote-topics/${id}`)
    return data.data
  }

  async function signTopic(id: number, ci?: string): Promise<VoteTopic> {
    await api.post(`/vote-topics/${id}/sign`, ci ? { ci } : {})
    return fetchTopic(id)
  }

  return {
    debates,
    topics,
    loading,
    latest,
    featured,
    hero,
    trending,
    popular,
    random,
    categories,
    byCategory,
    fetchHome,
    fetchDebate,
    fetchMessages,
    postMessage,
    fetchTopic,
    signTopic,
  }
})
