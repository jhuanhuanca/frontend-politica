/// <reference types="vite/client" />

import type { Directive } from 'vue'
import type { RevealBinding } from './directives/reveal'

declare module 'vue' {
  interface GlobalDirectives {
    reveal: Directive<HTMLElement, RevealBinding>
  }
}

interface ImportMetaEnv {
  readonly VITE_API_URL: string
  readonly VITE_SITE_URL?: string
  readonly VITE_REVERB_APP_KEY?: string
  readonly VITE_REVERB_HOST?: string
  readonly VITE_REVERB_PORT?: string
  readonly VITE_REVERB_SCHEME?: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}

declare module 'vue-router' {
  interface RouteMeta {
    theme?: 'noir'
    requiresAdmin?: boolean
    adminGuest?: boolean
  }
}

declare module '*.vue' {
  import type { DefineComponent } from 'vue'
  const component: DefineComponent<object, object, unknown>
  export default component
}
