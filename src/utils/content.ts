import type { Debate } from '@/types/models'

const COVERS = [
  'https://images.unsplash.com/photo-1685110485605-aecb3e4892df?auto=format&fit=crop&w=1200&q=80',
  'https://images.unsplash.com/photo-1544142447-e43d0fe04bf2?auto=format&fit=crop&w=1200&q=80',
  'https://images.unsplash.com/photo-1650700311346-dd9ad9e77114?auto=format&fit=crop&w=1200&q=80',
  'https://images.unsplash.com/photo-1690484815747-79b87f251a0d?auto=format&fit=crop&w=1200&q=80',
  'https://images.unsplash.com/photo-1596118769843-08e9ad381ab0?auto=format&fit=crop&w=1200&q=80',
  'https://images.unsplash.com/photo-1514907988683-d173529692b9?auto=format&fit=crop&w=1200&q=80',
  'https://images.unsplash.com/photo-1641736047534-afd0c9014a7c?auto=format&fit=crop&w=1200&q=80',
  'https://images.unsplash.com/photo-1650700312125-f0dfe9063a42?auto=format&fit=crop&w=1200&q=80',
  'https://images.unsplash.com/photo-1685110484156-c45303b95d01?auto=format&fit=crop&w=1200&q=80',
  'https://images.unsplash.com/photo-1595833855178-e2fd970421a5?auto=format&fit=crop&w=1200&q=80',
]

export const CATEGORY_LABELS: Record<string, string> = {
  economia: 'Economía',
  salud: 'Salud',
  educacion: 'Educación',
  politica: 'Política',
  seguridad: 'Seguridad',
  ambiente: 'Ambiente',
  infraestructura: 'Infraestructura',
}

export function categoryLabel(category: string | null | undefined): string {
  if (!category) {
    return 'General'
  }

  return CATEGORY_LABELS[category] ?? category
}

export function coverUrl(item: Pick<Debate, 'id' | 'image_url'>, offset = 0): string {
  if (item.image_url) {
    return rewriteMedia(item.image_url)
  }

  return COVERS[(item.id + offset) % COVERS.length]
}

function apiOrigin(): string {
  const apiUrl = String(import.meta.env.VITE_API_URL || '')
  if (!/^https?:\/\//i.test(apiUrl)) {
    return ''
  }

  try {
    return new URL(apiUrl).origin
  } catch {
    return ''
  }
}

export function rewriteMedia(url: string): string {
  try {
    const parsed = new URL(url, window.location.origin)
    if (parsed.pathname.startsWith('/storage')) {
      return `${apiOrigin()}${parsed.pathname}${parsed.search}`
    }
  } catch {
    return url
  }

  return url
}

export function formatDate(value: string | null | undefined): string {
  if (!value) {
    return ''
  }

  return new Intl.DateTimeFormat('es-BO', {
    day: 'numeric',
    month: 'long',
    year: 'numeric',
  }).format(new Date(value))
}
