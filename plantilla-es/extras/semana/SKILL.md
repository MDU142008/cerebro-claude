---
name: semana
description: >-
  Repaso semanal (10 minutos): qué se hizo, qué se trabó, cómo está cada cliente y proyecto, qué decisiones quedaron abiertas y las prioridades de la semana que viene; además ordena los archivos del cerebro. Triggers (ES/PT): /semana, "repaso de la semana", "cómo fue la semana", "planeemos la semana", "revisão da semana", "planejar a semana".
---

# Semana

> **Dónde guardar y buscar:** usá el mapa "Dónde está cada cosa" de `CLAUDE.md`. Las rutas de abajo (`empresa/…`, `proyectos/…`, `notas/…`) son ejemplos: si el mapa dice otra cosa, vale el mapa. Si no hay lugar para algo, proponé uno y usá `notas/` mientras tanto.

## Pasos

1. **Qué pasó:** leé `notas/` de los últimos 7 días, `decisiones.md` (lo agregado esta semana) y el historial de `git log --since="7 days ago" --oneline` si existe. Resumí en 5 líneas.
2. **Cada cliente y proyecto:** una línea por archivo de `empresa/clientes/` y `proyectos/`, con su estado. Marcá los que no se tocaron en 2 semanas o más ("¿sigue activo?").
3. **Abierto:** decisiones que siguen abiertas en `decisiones.md` y pendientes que vencieron.
4. **La semana que viene:** con el calendario (si está conectado), proponé las 3 prioridades y en qué día va cada una. La persona decide.
5. **Orden:** proponé (no lo hagas sin su sí) archivar lo terminado (mover a `archivo/`, nunca borrar) y juntar notas repetidas.
6. Guardá el repaso en `notas/AAAA-MM-DD-semana.md` y hacé `/cierre`.
