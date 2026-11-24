import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register, TurnUsage } from 'claude-code'

import type { Pedido } from '../types'

const pedido = atom({ plugin: 'cache-reloj', key: 'pedido' } as const, null)
const ahora = atom({ plugin: 'cache-reloj', key: 'ahora' } as const, 0)
const modeloActual = atom({ plugin: 'cache-reloj', key: 'modeloActual' } as const, '')
const avisado = atom({ plugin: 'cache-reloj', key: 'avisado' } as const, 0)

export const TTL_MS = { '5m': 300_000, '1h': 3_600_000 } as const
/** Avisa cuando queda esto o menos. */
export const AVISO_MS = 5 * 60_000
/** Por debajo de este contexto no avisa: re-leerlo cuesta poco. */
export const AVISO_DESDE_TOKENS = 50_000

// US$ por millón de tokens al ESCRIBIR el caché, precio de lista de la API
// (platform.claude.com/docs/en/about-claude/pricing, leído el 2026-11-22).
// En la suscripción no se cobra en dólares: es una referencia de tamaño.
const ESCRITURA: { clave: string; m5: number; h1: number }[] = [
  { clave: 'fable-5-2', m5: 10, h1: 16 },
  { clave: 'opus-5-5', m5: 5, h1: 8 },
  { clave: 'sonnet-5-5', m5: 2.5, h1: 4 },
]

/** Cuánto costaría, a precio de API, volver a escribir el contexto en caché. */
export const costoFrio = (p: Pick<Pedido, 'modelo' | 'tokens' | 'ttl'>) => {
  const haiku = p.modelo.includes('haiku-5-5')
  const fila = haiku
    ? p.tokens > 100_000
      ? { m5: 0.625, h1: 1 }
      : { m5: 0.125, h1: 0.2 }
    : ESCRITURA.find(f => p.modelo.includes(f.clave))
  if (fila === undefined) return undefined
  return (p.tokens / 1_000_000) * (p.ttl === '1h' ? fila.h1 : fila.m5)
}

/** Cuánto dura lo que dejó en caché una respuesta, según lo que informó. */
export const ttlDe = (
  u: Pick<TurnUsage, 'ephemeral_5m_input_tokens' | 'ephemeral_1h_input_tokens'>,
  previo: Pick<Pedido, 'ttl' | 'esTtlSupuesto'> | null,
  esSuscripcion: boolean,
): Pick<Pedido, 'ttl' | 'esTtlSupuesto'> => {
  // Si escribió de las dos duraciones, manda la más corta.
  if ((u.ephemeral_5m_input_tokens ?? 0) > 0) return { ttl: '5m', esTtlSupuesto: false }
  if ((u.ephemeral_1h_input_tokens ?? 0) > 0) return { ttl: '1h', esTtlSupuesto: false }
  // Solo leyó: vale lo de la última escritura.
  if (previo !== null) return previo
  return { ttl: esSuscripcion ? '1h' : '5m', esTtlSupuesto: true }
}

export type Estado =
  | { tipo: 'caliente'; minutos: number; color: 'green' | 'yellow' | 'red' }
  | { tipo: 'frio' }
  | { tipo: 'otro-modelo' }

export const estadoDe = (p: Pedido, now: number, modelo: string): Estado => {
  if (modelo !== '' && p.modeloSesion !== '' && modelo !== p.modeloSesion) {
    return { tipo: 'otro-modelo' }
  }
  const quedan = p.at + TTL_MS[p.ttl] - now
  if (quedan <= 0) return { tipo: 'frio' }
  return {
    tipo: 'caliente',
    minutos: Math.ceil(quedan / 60_000),
    color: quedan <= AVISO_MS ? 'red' : quedan <= 2 * AVISO_MS ? 'yellow' : 'green',
  }
}

const miles = (n: number) => `${Math.round(n / 1000)}k`
const usd = (n: number) => `US$${n.toFixed(2).replace('.', ',')}`

export const relectura = (p: Pedido) => {
  const costo = costoFrio(p)
  return costo === undefined
    ? `${miles(p.tokens)} tokens`
    : `${miles(p.tokens)} tokens (≈${usd(costo)} a preço de API)`
}

/** Pone la hora al día, nota un /clear o un /model, y avisa si está por vencer. */
const tic = async ($: EngineInterface) => {
  const now = await $.clock.now()
  const usage = await $.session.usage()
  const modelo = await $.session.model()
  let p = await read($, pedido)

  // Un /clear arranca la sesión de nuevo: lo anterior ya no es de esta conversación.
  if (p !== null && usage.startedAt > p.at) {
    await update($, pedido, () => null)
    p = null
  }
  await update($, modeloActual, () => modelo)
  await update($, ahora, () => now)

  if (p === null || p.tokens < AVISO_DESDE_TOKENS) return
  const e = estadoDe(p, now, modelo)
  if (e.tipo !== 'caliente' || e.color !== 'red') return
  if ((await read($, avisado)) === p.at) return
  await update($, avisado, () => p.at)
  $.ui.toast(
    `O cache desta sessão vence em ~${e.minutos} min. Se você vai continuar aqui, mande uma mensagem antes; se não, a próxima relê ${relectura(p)}.`,
    { timeoutMs: 20_000 },
  )
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    await tic($)
    $.clock.every(60_000, () => {
      void tic($).catch(() => {})
    })

    return next(e)
  })

  // Cada pedido de la conversación principal renueva el caché desde que sale.
  on('turn.step', async function* ($, e, next) {
    if (e.agentId !== undefined) return yield* next(e)

    const at = await $.clock.now()
    const r = yield* next(e)

    try {
      const u = r.usage
      if (u !== null) {
        const previo = await read($, pedido)
        const esSuscripcion = (await $.session.usage()).rateLimits.length > 0
        const modeloSesion = await $.session.model()
        const nuevo: Pedido = {
          at,
          ...ttlDe(u, previo, esSuscripcion),
          modelo: u.model,
          modeloSesion,
          tokens:
            u.input_tokens +
            u.cache_read_input_tokens +
            u.cache_creation_input_tokens +
            u.output_tokens,
        }
        await update($, pedido, () => nuevo)
        await update($, modeloActual, () => modeloSesion)
        await update($, ahora, () => at)
      }
    } catch {
      // La banda es un adorno: nunca frena una respuesta.
    }

    return r
  })

  // Compactar cambia la conversación: lo medido antes ya no vale.
  on('session.compact', async ($, e, next) => {
    const r = await next(e)
    if (r.skip === undefined && e.trigger !== 'precompute') {
      // Si esto falla, la compactación sigue igual.
      await update($, pedido, () => null).catch(() => {})
    }

    return r
  })

  on('session.measure', async ($, e, next) => {
    const now = await $.clock.now()
    await update($, ahora, () => now)

    return next(e)
  })

  on('ui.render', { component: 'AbovePrompt' }, async ($, e, next) => {
    const p = await read($, pedido)
    if (e.props.hasSurvey || p === null) return next(e)

    const { Box, Text } = $.ui.resolve(e)
    const estado = estadoDe(p, await read($, ahora), await read($, modeloActual))
    const isAncho = (e.props.bodyColumns ?? 120) >= 90
    const aprox = p.esTtlSupuesto ? '~' : ''

    if (estado.tipo === 'caliente') {
      return (
        <Box flexDirection="row" flexWrap="wrap">
          <Text dimColor>cache </Text>
          <Text color={estado.color} bold>
            {aprox}
            {estado.minutos}m
          </Text>
          {isAncho && <Text dimColor>{'  ·  '}se vencer, a próxima mensagem relê {relectura(p)}</Text>}
        </Box>
      )
    }

    return (
      <Box flexDirection="row" flexWrap="wrap">
        <Text dimColor>cache </Text>
        <Text color={estado.tipo === 'frio' ? 'red' : 'yellow'} bold>
          {estado.tipo === 'frio' ? 'frio' : 'outro modelo'}
        </Text>
        <Text dimColor>{'  ·  '}a próxima mensagem relê {relectura(p)}</Text>
      </Box>
    )
  })
}
