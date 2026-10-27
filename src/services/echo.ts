import Echo from 'laravel-echo'
import Pusher from 'pusher-js'

declare global {
  interface Window {
    Pusher: typeof Pusher
    Echo?: Echo<'reverb'>
  }
}

window.Pusher = Pusher

let echo: Echo<'reverb'> | null = null

export function getEcho(): Echo<'reverb'> | null {
  const key = import.meta.env.VITE_REVERB_APP_KEY
  if (!key) {
    return null
  }

  if (echo) {
    return echo
  }

  echo = new Echo({
    broadcaster: 'reverb',
    key,
    wsHost: import.meta.env.VITE_REVERB_HOST || window.location.hostname,
    wsPort: Number(import.meta.env.VITE_REVERB_PORT || 8080),
    wssPort: Number(import.meta.env.VITE_REVERB_PORT || 8080),
    forceTLS: (import.meta.env.VITE_REVERB_SCHEME || 'http') === 'https',
    enabledTransports: ['ws', 'wss'],
    Pusher,
  })

  window.Echo = echo
  return echo
}

export function echoSocketId(): string | null {
  return getEcho()?.socketId() ?? null
}

export function isEchoConnected(): boolean {
  return getEcho()?.connectionStatus() === 'connected'
}
