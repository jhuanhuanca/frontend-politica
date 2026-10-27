export function debatePublicUrl(id: number): string {
  const base = String(import.meta.env.VITE_SITE_URL || window.location.origin).replace(/\/$/, '')
  return `${base}/debates/${id}`
}

export function socialShareLinks(title: string, url: string): { whatsapp: string; facebook: string; x: string } {
  const text = `${title}\n${url}`

  return {
    whatsapp: `https://wa.me/?text=${encodeURIComponent(text)}`,
    facebook: `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(url)}`,
    x: `https://twitter.com/intent/tweet?text=${encodeURIComponent(title)}&url=${encodeURIComponent(url)}`,
  }
}

export async function copyToClipboard(value: string): Promise<boolean> {
  try {
    await navigator.clipboard.writeText(value)
    return true
  } catch {
    return false
  }
}
