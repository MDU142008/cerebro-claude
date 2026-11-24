---
name: herramientas
description: >-
  Muestra qué herramientas (skills) tiene el cerebro, cuáles están activas y cuáles guardadas, y activa o desactiva la que la persona elija. Triggers (ES/PT): /herramientas, "qué herramientas tengo", "qué sabés hacer", "activá X", "desactivá X", "sacá X", "quais ferramentas", "ativa X".
---

# Herramientas

Las herramientas activas viven en `.claude/skills/`; las guardadas, en `extras/`. Activar = mover la carpeta de `extras/` a `.claude/skills/`. Desactivar = al revés. No se borra nada.

## Mostrar

Leé el `description` del `SKILL.md` de cada carpeta y armá dos listas, una línea por herramienta, en palabras simples (qué hace, no cómo):

No digas cuántas hay en total; solo las dos listas.

- **Activas** (`.claude/skills/*`)
- **Guardadas** (`extras/*`): cómo se activa cada una ("decime 'activá reunion'")

`empezar`, `cierre` y `herramientas` son la base: si piden desactivarlas, avisá que el cerebro deja de guardarse solo y hacelo solo si lo confirman.

## Activar o desactivar

1. Avisá antes en una línea: "Claude Code te va a pedir permiso para tocar la carpeta `.claude`: es normal, decí que sí." Después mové la carpeta entera (con PowerShell: `Move-Item`).
2. Decile que escriba `/reload-skills` (o que cierre y abra Claude) para que se cargue el cambio.
3. Anotá el cambio en `notas/AAAA-MM-DD-herramientas.md` en una línea.

## Herramientas nuevas

Si piden algo que ninguna hace y lo van a repetir ("todas las semanas armo X"), proponé crear una herramienta nueva: una carpeta en `.claude/skills/<nombre>/` con un `SKILL.md` (arriba `name` y `description` con frases de cuándo usarla; abajo los pasos). Escribila vos con lo que la persona cuenta, mostrásela en 5 líneas y guardala solo con su sí.
