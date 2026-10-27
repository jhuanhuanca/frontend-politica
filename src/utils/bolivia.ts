export const DEPARTMENTS = [
  'Chuquisaca',
  'La Paz',
  'Cochabamba',
  'Oruro',
  'Potosí',
  'Tarija',
  'Santa Cruz',
  'Beni',
  'Pando',
] as const

export type Department = (typeof DEPARTMENTS)[number]
