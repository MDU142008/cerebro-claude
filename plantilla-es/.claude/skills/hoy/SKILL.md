---
name: hoy
description: >-
  Resumen del día: mails que piden respuesta, reuniones de hoy con lo que hay que llevar, y pendientes de clientes y proyectos; cierra con las 3 cosas más importantes. Usa Gmail y Google Calendar si están conectados. Triggers (ES/PT): /hoy, "qué tengo hoy", "arranquemos el día", "buen día", "qué hay pendiente", "o que tenho hoje", "bom dia".
---

# Hoy

> **Dónde guardar y buscar:** usá el mapa "Dónde está cada cosa" de `CLAUDE.md`. Las rutas de abajo (`empresa/…`, `proyectos/…`, `notas/…`) son ejemplos: si el mapa dice otra cosa, vale el mapa. Si no hay lugar para algo, proponé uno y usá `notas/` mientras tanto.

Armás el arranque del día en menos de una pantalla.

## Pasos

1. **Calendario (si está conectado):** las reuniones de hoy, con hora. Para cada una con un cliente, buscá su archivo en `empresa/clientes/` y sumá en una línea qué hay pendiente con él.
2. **Mails (si Gmail está conectado):** los de las últimas 24 h (o desde el viernes si es lunes) que **piden una respuesta o una acción**. Ignorá newsletters, notificaciones automáticas y promociones. Para cada uno: de quién, qué pide, en una línea.
3. **Pendientes:** leé la línea de **Estado** y los **Pendientes** de `empresa/clientes/*.md` y `proyectos/*.md`. Traé solo lo que vence o está trabado.
4. **Las 3 de hoy:** cerrá con las 3 cosas más importantes para hoy, en orden, y por qué la primera es la primera.

## Si falta un conector

Si Gmail o Calendar no aparecen, hacé el resumen con los archivos y decí en una línea: "Para sumar mails y reuniones, conectá Gmail y Google Calendar en claude.ai → Configuración → Conectores, y después escribí /mcp acá."

## Reglas

- **Solo leés.** No contestes mails, no aceptes invitaciones, no marques nada como leído. Si la persona pide "contestale", escribí el borrador, mostralo y esperá su sí antes de mandar.
- Formato: títulos cortos (**Reuniones**, **Mails**, **Pendientes**, **Las 3 de hoy**) y una línea por cosa.
