---
name: reunion
description: >-
  Antes de una reunión: arma la preparación (con quién, qué pasó la última vez, qué hay pendiente, qué preguntar, qué decidir). Después: convierte las notas o la transcripción en resumen, decisiones y tareas, y lo guarda en el cliente o proyecto. Usa Calendar, Gmail y Drive si están conectados. Triggers (ES/PT): /reunion, "preparame la reunión con", "tengo reunión con", "acá van las notas de la reunión", "resumí esta reunión", "prepara a reunião", "resumo da reunião".
---

# Reunión

> **Dónde guardar y buscar:** usá el mapa "Dónde está cada cosa" de `CLAUDE.md`. Las rutas de abajo (`empresa/…`, `proyectos/…`, `notas/…`) son ejemplos: si el mapa dice otra cosa, vale el mapa. Si no hay lugar para algo, proponé uno y usá `notas/` mientras tanto.

## Antes ("preparame la reunión con X")

1. Buscá la reunión en el calendario (si está conectado): hora, quiénes van.
2. Juntá lo que hay: `empresa/clientes/<x>.md` o `proyectos/<x>.md`, las notas de reuniones anteriores en `notas/`, los últimos mails con esa persona (si Gmail está conectado).
3. Entregá en una pantalla:
   - **Con quién y para qué** (1 línea)
   - **Dónde quedamos la última vez** (2-3 líneas)
   - **Pendientes de cada lado**
   - **Qué preguntar** (máximo 5)
   - **Qué hay que salir decidiendo** (1-2)

## Después ("acá van las notas" / pega una transcripción)

1. Armá: **Resumen** (3 líneas), **Decisiones**, **Tareas** (quién, qué, para cuándo) y **Abierto**.
2. Mostralo y preguntá si falta algo.
3. Guardá en `notas/AAAA-MM-DD-reunion-<con-quien>.md`, actualizá el **Estado** y los **Pendientes** del cliente o proyecto, y si hubo decisiones de la persona, agregalas al final de `decisiones.md`.
4. Si hay que mandar un mail de seguimiento, escribí el borrador y **esperá su sí antes de mandarlo**.
