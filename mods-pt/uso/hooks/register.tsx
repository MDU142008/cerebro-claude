import { atom, read, update } from 'claude-code'
import type { Register, SessionContextUsage, SessionRateLimit } from 'claude-code'

import type { Lectura } from '../types'

const lectura = atom({ plugin: 'uso', key: 'lectura' } as const, null)
const ahora = atom({ plugin: 'uso', key: 'ahora' } as const, 0)

const NOMBRES: Record<string, string> = {
  five_hour: '5h',
  seven_day: 'semana',
  seven_day_opus: 'semana Opus',
  seven_day_sonnet: 'semana Sonnet',
  spend_limit: 'gasto',
}

export const aLectura = (u: {
  context: SessionContextUsage
  rateLimits: SessionRateLimit[]
}): Lectura => ({
  contextPercent: u.context.percent,
  contextTokens: u.context.tokens,
  contextWindow: u.context.window,
  ventanas: u.rateLimits.map(({ kind, percentUsed, resetsAt }) => ({
    kind,
    percentUsed,
    resetsAt,
  })),
})

export const color = (percent: number) =>
  percent >= 90 ? 'red' : percent >= 70 ? 'yellow' : 'green'

export const faltan = (resetsAt: string | undefined, now: number) => {
  const ms = resetsAt === undefined ? NaN : Date.parse(resetsAt) - now
  if (!Number.isFinite(ms)) return undefined
  const min = Math.max(0, Math.round(ms / 60_000))
  const d = Math.floor(min / 1440)
  const h = Math.floor((min % 1440) / 60)
  const m = min % 60
  if (d > 0) return `${d}d ${h}h`
  if (h > 0) return `${h}h ${m}m`
  return `${m}m`
}

const miles = (n: number) => `${Math.round(n / 1000)}k`

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    // Lo que el status line ya sabe al arrancar (vacío hasta la primera respuesta).
    const usage = await $.session.usage()
    const t = await $.clock.now()
    await update($, lectura, () => aLectura(usage))
    await update($, ahora, () => t)
    // Tic por minuto para que "se libera en" no quede viejo con la sesión quieta.
    $.clock.every(60_000, () => {
      void $.clock.now().then(now => update($, ahora, () => now))
    })

    return next(e)
  })

  on('session.measure', async ($, e, next) => {
    const t = await $.clock.now()
    await update($, lectura, () => aLectura(e))
    await update($, ahora, () => t)

    return next(e)
  })

  on('ui.render', { component: 'AbovePrompt' }, async ($, e, next) => {
    if (e.props.hasSurvey) return next(e)

    const { Box, Text } = $.ui.resolve(e)
    const l = await read($, lectura)
    const now = await read($, ahora)
    const isAncho = (e.props.bodyColumns ?? 120) >= 90

    if (l === null || (l.contextPercent === undefined && l.ventanas.length === 0)) {
      return (
        <Box>
          <Text dimColor>contexto e cota: aparecem depois da primeira resposta</Text>
        </Box>
      )
    }

    const ctx = l.contextPercent

    return (
      <Box flexDirection="row" flexWrap="wrap">
        <Text dimColor>contexto </Text>
        {ctx === undefined ? (
          <Text dimColor>—</Text>
        ) : (
          <Text color={color(ctx)} bold>
            {ctx}%
          </Text>
        )}
        {isAncho && l.contextTokens !== undefined && (
          <Text dimColor>
            {' '}
            ({miles(l.contextTokens)}/{miles(l.contextWindow)})
          </Text>
        )}
        {l.ventanas.map(v => {
          const vuelve = isAncho ? faltan(v.resetsAt, now) : undefined
          return (
            <Box key={v.kind} flexDirection="row">
              <Text dimColor>{'  ·  '}{NOMBRES[v.kind] ?? v.kind} </Text>
              <Text color={color(v.percentUsed)} bold>
                {v.percentUsed}%
              </Text>
              {vuelve !== undefined && <Text dimColor> (libera em {vuelve})</Text>}
            </Box>
          )
        })}
      </Box>
    )
  })
}
