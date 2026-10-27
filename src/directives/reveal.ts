import type { Directive, DirectiveBinding } from 'vue'

export type RevealFrom = 'up' | 'down' | 'left' | 'right' | 'fade'

export type RevealBinding =
  | RevealFrom
  | number
  | {
      from?: RevealFrom
      delay?: number
    }
  | undefined

type RevealMeta = {
  from: RevealFrom
  delay: number
}

function prefersReducedMotion(): boolean {
  return window.matchMedia('(prefers-reduced-motion: reduce)').matches
}

function parse(value: RevealBinding): RevealMeta {
  if (typeof value === 'number') {
    return { from: 'up', delay: value }
  }
  if (typeof value === 'string') {
    return { from: value, delay: 0 }
  }
  return {
    from: value?.from ?? 'up',
    delay: value?.delay ?? 0,
  }
}

function paint(el: HTMLElement, value: RevealBinding): void {
  const { from, delay } = parse(value)
  el.classList.add('reveal')
  el.dataset.revealFrom = from
  el.style.setProperty('--reveal-delay', `${delay}ms`)
}

function show(el: HTMLElement): void {
  el.classList.add('is-inview')
  el.classList.remove('is-out-up', 'is-out-down')
}

function hide(el: HTMLElement, rect: DOMRectReadOnly): void {
  el.classList.remove('is-inview')
  el.classList.toggle('is-out-up', rect.top < 0)
  el.classList.toggle('is-out-down', rect.top >= 0)
}

let observer: IntersectionObserver | null = null

function getObserver(): IntersectionObserver {
  if (observer) {
    return observer
  }

  observer = new IntersectionObserver(
    (entries) => {
      for (const entry of entries) {
        const el = entry.target as HTMLElement
        if (entry.isIntersecting) {
          show(el)
        } else {
          hide(el, entry.boundingClientRect)
        }
      }
    },
    {
      threshold: 0.12,
      rootMargin: '0px 0px -8% 0px',
    },
  )

  return observer
}

function bind(el: HTMLElement, binding: DirectiveBinding<RevealBinding>): void {
  paint(el, binding.value)

  if (prefersReducedMotion()) {
    show(el)
    return
  }

  getObserver().observe(el)
}

export const reveal: Directive<HTMLElement, RevealBinding> = {
  beforeMount: bind,
  updated(el, binding) {
    paint(el, binding.value)
  },
  unmounted(el) {
    observer?.unobserve(el)
  },
}
