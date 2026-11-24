export type Ventana = { kind: string; percentUsed: number; resetsAt?: string }

export type Lectura = {
  contextPercent?: number
  contextTokens?: number
  contextWindow: number
  ventanas: Ventana[]
}

declare module 'claude-code' {
  interface PluginState {
    uso: { lectura: Lectura | null; ahora: number }
  }
}
