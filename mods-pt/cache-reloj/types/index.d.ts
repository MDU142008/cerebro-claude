/** El último pedido de la conversación principal que el modelo contestó. */
export type Pedido = {
  /** Cuándo salió el pedido (ms): desde ahí cuenta la vida del caché. */
  at: number
  /** Cuánto dura lo que ese pedido dejó en caché. */
  ttl: '5m' | '1h'
  /** true si la respuesta no informó la duración y se supuso por el tipo de cuenta. */
  esTtlSupuesto: boolean
  /** El modelo que contestó (para el precio). */
  modelo: string
  /** El modelo de la sesión al mandar el pedido (para notar un cambio con /model). */
  modeloSesion: string
  /** Tokens que el próximo pedido vuelve a mandar. */
  tokens: number
}

declare module 'claude-code' {
  interface PluginState {
    'cache-reloj': {
      pedido: Pedido | null
      ahora: number
      modeloActual: string
      avisado: number
    }
  }
}
