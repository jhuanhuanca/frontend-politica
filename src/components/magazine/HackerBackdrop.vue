<script setup lang="ts">
import { onMounted, onUnmounted, ref } from 'vue'

const canvasRef = ref<HTMLCanvasElement | null>(null)
let frame = 0
let running = false
let drops: number[] = []

const GLYPHS = '01010101$#<>_/\\|[]{}ABCDEF01>_'

function paint(): void {
  const canvas = canvasRef.value
  if (!canvas || !running) {
    return
  }

  const ctx = canvas.getContext('2d')
  if (!ctx) {
    return
  }

  const width = canvas.width
  const height = canvas.height
  const size = 16
  const columns = Math.ceil(width / size)

  if (drops.length !== columns) {
    drops = Array.from({ length: columns }, () => Math.floor(Math.random() * (height / size)))
  }

  ctx.fillStyle = 'rgba(1, 4, 9, 0.18)'
  ctx.fillRect(0, 0, width, height)
  ctx.font = '14px Consolas, "Courier New", monospace'

  for (let i = 0; i < columns; i += 1) {
    const glyph = GLYPHS[Math.floor(Math.random() * GLYPHS.length)] ?? '0'
    const x = i * size
    const y = drops[i] * size
    const head = Math.random() > 0.92
    ctx.fillStyle = head
      ? '#F4F7FB'
      : i % 11 === 0
        ? '#0B3D91'
        : i % 7 === 0
          ? '#FF6A00'
          : i % 5 === 0
            ? '#009ED6'
            : '#00B3A4'
    ctx.fillText(glyph, x, y)

    if (y > height && Math.random() > 0.975) {
      drops[i] = 0
    } else {
      drops[i] += 1
    }
  }

  frame = window.requestAnimationFrame(paint)
}

function resize(): void {
  const canvas = canvasRef.value
  if (!canvas) {
    return
  }
  canvas.width = window.innerWidth
  canvas.height = window.innerHeight
  drops = []
}

onMounted(() => {
  running = true
  resize()
  window.addEventListener('resize', resize)
  frame = window.requestAnimationFrame(paint)
})

onUnmounted(() => {
  running = false
  window.cancelAnimationFrame(frame)
  window.removeEventListener('resize', resize)
})
</script>

<template>
  <Teleport to="body">
    <div class="hacker-backdrop" aria-hidden="true">
      <canvas ref="canvasRef" class="hacker-backdrop__rain" />
      <pre class="hacker-backdrop__term">C:\&gt; boot --community enagenda
[ok] stream binary 01001101 01000001 01010100 01010010 01001001 01011000
[ok] decrypt opinion.feed
&gt;_ lo que pasa. lo que piensas.</pre>
      <div class="hacker-backdrop__scan" />
    </div>
  </Teleport>
</template>
