---
name: mantenimiento
description: >-
  Revisión semanal de cómo está armado el AIOS, con las 4 C (Contexto, Conexiones, Capacidades, Constancia): puntaje sobre 100, lo que anda bien, los 3 arreglos que más rinden, y arregla en el momento lo chico (archivos desordenados, mapa desactualizado) con el sí de la persona. Triggers (ES/PT): /mantenimiento, "revisá mi AIOS", "cómo está mi cerebro", "qué le falta a mi sistema", "ordená todo", "manutenção", "revisa meu sistema".
---

# Mantenimiento

> *Adaptado del `/audit` del kit AIS-OS de Nate Herk (MIT). The Four Cs of an AIOS™ es marca de Nate Herk. © 2026 Nate Herk.*

Mirás **cómo está armado** el AIOS, no qué automatizar. Una vez por semana. La primera vez es la base: después se ve cómo sube el puntaje.

## 1. Mirar (sin tocar nada)

Leé `CLAUDE.md` (sobre todo el mapa "Dónde está cada cosa"), `conexiones.md`, `decisiones.md`, las carpetas del mapa, `.claude/skills/` y `extras/`, `/mcp` (qué conectores y MCP andan) y `git log --oneline -20`.

## 2. Puntuar las 4 C (25 puntos cada una)

**Contexto: ¿Claude conoce a la persona y su trabajo?**
- `CLAUDE.md` completo, sin "(lo completa /empezar)" (5)
- Quién es, qué hace y cómo quiere que le hablen, claros (5)
- Los archivos del mapa existen y están al día; las líneas de estado tienen menos de 2 semanas (10)
- `decisiones.md` tiene decisiones de las últimas 2 semanas (5)

**Conexiones: ¿llega a sus cosas sin que pegue nada?**
- De las fuentes de `conexiones.md`, cuántas están conectadas de verdad (y andan en `/mcp`) (15, proporcional)
- `conexiones.md` existe y coincide con lo que anda (5)
- Al menos una conexión puede escribir, no solo leer (5)

**Capacidades: ¿sabe hacer su trabajo?**
- Usa las herramientas activas: se ven en las notas y en el historial (10)
- Tiene al menos una herramienta propia, creada para algo suyo (10)
- Ninguna herramienta activa sobra (5)

**Constancia: ¿se usa seguido?**
- Hubo sesiones con `/cierre` en al menos 3 días de los últimos 7 (git log) (15)
- Tiene una rutina fija (por ejemplo `/hoy` cada mañana o esta revisión cada semana) (10)

## 3. Entregar (una pantalla)

```
Tu AIOS: <total>/100  (Contexto <n> · Conexiones <n> · Capacidades <n> · Constancia <n>)
Anda bien: <2 cosas>
Los 3 arreglos que más rinden:
1. <qué> — <por qué importa> — <cómo, en una línea>
2. …
3. …
```

Ordená los arreglos por lo que más destraba: sin conexiones, Claude está ciego; sin contexto, contesta genérico. Si hay una revisión anterior en `notas/`, mostrá cuánto subió o bajó.

## 4. Arreglar lo chico (con su sí)

Proponé en una lista y hacé lo que apruebe: actualizar el mapa de `CLAUDE.md` si hay carpetas que no figuran, mover a `archivo/` lo terminado (nunca borrar), juntar notas repetidas, corregir estados viejos preguntando cómo está cada cosa. Lo grande (una conexión nueva, una herramienta nueva) no se hace acá: queda como arreglo propuesto.

Guardá la revisión en `notas/AAAA-MM-DD-mantenimiento.md` y hacé `/cierre`.
