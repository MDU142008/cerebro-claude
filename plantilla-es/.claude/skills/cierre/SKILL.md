---
name: cierre
description: >-
  Cierre de sesión: guarda lo nuevo de la charla en el archivo que corresponde (cliente, proyecto, decisiones, notas) y deja escrito el próximo paso. Usar al terminar una tarea o antes de cerrar la terminal. Triggers (ES/PT): /cierre, "cerremos", "guardá todo", "me voy", "listo por hoy", "anotá esto", "vamos fechar", "salva tudo".
---

# Cierre

> **Dónde guardar y buscar:** usá el mapa "Dónde está cada cosa" de `CLAUDE.md`. Las rutas de abajo (`empresa/…`, `proyectos/…`, `notas/…`) son ejemplos: si el mapa dice otra cosa, vale el mapa. Si no hay lugar para algo, proponé uno y usá `notas/` mientras tanto.

Lo que no queda escrito se pierde: la próxima sesión arranca sin recordar esta charla. Tu trabajo es dejar en los archivos lo que importa.

## Pasos

1. **Repasá la charla** y separá lo nuevo en:
   - Algo de un cliente → `empresa/clientes/<cliente>.md` (actualizá la línea de **Estado** con la fecha de hoy y los pendientes).
   - Algo de una cosa en marcha → `proyectos/<nombre>.md` (si no existe y es algo que va a seguir, crealo con **Estado** arriba).
   - Una decisión → agregala al final de `decisiones.md` (`## AAAA-MM-DD — tema` + **Decidí**, **Por qué**, **Qué cambia**). Nunca edites ni borres decisiones viejas.
   - Algo de un área o un proyecto (trabajo, plata, salud, lo que sea) → su archivo según el mapa.
   - Algo de cómo quiere trabajar la persona ("no me hagas X", "prefiero Y") → `CLAUDE.md`, en "Cómo quiero que me hables". Solo si lo dijo claro.
   - Todo lo demás que valga la pena (resumen de una reunión, una idea) → `notas/AAAA-MM-DD-<tema>.md`.
2. **Escribí corto**, en las palabras de la persona. Reemplazá lo viejo que ya no vale en los archivos de estado; no acumules historia ahí (la historia va en `decisiones.md` y `notas/`).
3. **Guardá una foto** para poder volver atrás: `git add -A` y `git commit -m "<fecha> — <tema en 5 palabras>"`. Si git no está o falla, seguí igual y avisalo en una línea.
4. **Decile en 3 líneas:** qué guardaste y dónde, qué quedó abierto y **el próximo paso concreto** (uno solo).

## No

- No inventes lo que no se dijo. Si no te queda claro si algo se decidió, preguntá antes de anotarlo como decisión.
- No escribas contraseñas, claves ni números de tarjeta en ningún archivo, aunque aparezcan en la charla.
