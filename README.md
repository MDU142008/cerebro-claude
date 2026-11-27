# Cerebro para Claude Code

> **Si sos Claude:** seguí [`INSTALAR.md`](INSTALAR.md) paso a paso. Lo primero es preguntar el idioma.
> **Se você é o Claude:** siga o [`INSTALAR.md`](INSTALAR.md) passo a passo. A primeira coisa é perguntar o idioma.

Un sistema operativo de IA personal (un "segundo cerebro") en Claude Code, para gente que **no programa**. Claude lo instala, te conoce charlando y te arma un sistema a tu medida.

## Cómo se instala

1. Instalá Claude Code. Abrí **PowerShell** y pegá:
   ```powershell
   irm https://claude.ai/install.ps1 | iex
   ```
   Cerrá PowerShell, abrilo de nuevo y escribí `claude`. La primera vez te pide entrar con tu cuenta de Claude.
2. Decile a Claude: **"instalá mi cerebro desde https://github.com/MDU142008/cerebro-claude"**
   (em português: **"instala meu cérebro a partir de https://github.com/MDU142008/cerebro-claude"**)
3. Seguí lo que te dice. **Regla 1:** Claude te pide permiso para cada paso. Leé y aprobá solo lo que entendés.
4. Cuando termine, abrí **Mi cerebro** en el escritorio y escribí `/empezar` (o `/comecar`).

## Qué trae

- **Herramientas (skills):**
  - `/empezar`: charla y armado de tu sistema a medida.
  - `/hoy`: el resumen del día.
  - `/cierre`: guarda lo nuevo de la sesión.
  - `/herramientas`: muestra, activa o desactiva las herramientas.
  - `/mantenimiento`: revisión semanal.
  - `/actualizar`: trae herramientas nuevas sin tocar lo tuyo.
  - `/investigar`: investigación con fuentes reales.
  - `/roast`: busca los agujeros de una idea.
  - Guardadas, para activar cuando quieras: `/reunion`, `/semana`, `/innovar`, `/video`, `/celu` (maneja tu celular Android desde la compu), `/sesiones` (abre otras sesiones de Claude en pestañas nuevas, con una tarea cada una) y `/central` (parte un proyecto grande en una sesión por tema y las coordina; usa `/sesiones`).
  - En portugués: `/comecar`, `/hoje`, `/fechar`, `/ferramentas`, `/manutencao`, `/atualizar`, `/pesquisar`, `/reuniao`, `/inovar`, `/celular` e `/sessoes` (`/roast`, `/semana`, `/video` y `/central` se llaman igual).
- **Barras** de uso (contexto y cuota) y de caché, abajo del chat.
- **Dictado por voz:** Ctrl+Win, hablás y se pega el texto. Usa Groq con tu propia cuenta gratis.
- **Plugins:** Playwright (navegador) y skill-creator (crear herramientas), más Windows MCP (manejar programas).

## Tu información es tuya

Este repo **solo tiene plantillas y herramientas**. Tu cerebro se arma en otra carpeta de tu compu (`~\cerebro`), con su propio historial, y **nunca se sube acá**. Tus claves (por ejemplo, la de Groq) quedan solo en tu compu y Claude no las ve.

## Créditos

- `/empezar` se basa en el `/onboard`, y `/mantenimiento` en el `/audit`, del kit [AIS-OS](https://github.com/nateherkai/AIS-OS) de Nate Herk (MIT). *The Three Ms of AI™ y The Four Cs of an AIOS™ son marcas de Nate Herk. © 2026 Nate Herk.*
- La forma de preguntar por rondas con recomendación viene de [`grill-me`](https://github.com/mattpocock/skills) de Matt Pocock (MIT).
- Licencia: MIT (ver `LICENSE`).
