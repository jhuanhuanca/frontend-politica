import { onUnmounted, watch, type Ref } from 'vue'
import { getEcho, isEchoConnected } from '@/services/echo'
import { useCatalogStore } from '@/stores/catalog'
import type { DebateMessage } from '@/types/models'

export function useDebateRealtime(
  debateId: Ref<number>,
  onMessage: (message: DebateMessage) => void,
): void {
  const catalog = useCatalogStore()
  let channelName: string | null = null
  let pollId: number | null = null

  function leaveChannel(): void {
    if (!channelName) {
      return
    }
    getEcho()?.leave(channelName)
    channelName = null
  }

  function listen(): void {
    leaveChannel()
    const id = debateId.value
    if (!Number.isFinite(id) || id <= 0) {
      return
    }

    const echo = getEcho()
    if (!echo) {
      return
    }

    channelName = `debate.${id}`
    echo.channel(channelName).listen('.message.sent', (payload: { message?: DebateMessage }) => {
      if (payload.message) {
        onMessage(payload.message)
      }
    })
  }

  async function poll(): Promise<void> {
    const id = debateId.value
    if (!Number.isFinite(id) || id <= 0 || isEchoConnected()) {
      return
    }

    try {
      const list = await catalog.fetchMessages(id)
      list.forEach(onMessage)
    } catch {
      // El hilo se reintenta en el próximo ciclo.
    }
  }

  watch(
    debateId,
    () => {
      listen()
    },
    { immediate: true },
  )

  pollId = window.setInterval(() => {
    void poll()
  }, 4000)

  onUnmounted(() => {
    leaveChannel()
    if (pollId) {
      window.clearInterval(pollId)
    }
  })
}
