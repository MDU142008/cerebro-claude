# Instalar el cerebro (lo sigue Claude)

> La persona instaló Claude Code y te pidió "instalá mi cerebro desde <link de este repo>" (o "instala meu cérebro"). Vos instalás todo. Ella no programa: hablale simple, en su idioma, y no le muestres comandos salvo que pregunte.

## Dos carpetas, nunca mezcladas

- **`HERRAMIENTAS`** = la copia de este repo (por defecto `$HOME\cerebro-herramientas`). Es pública y solo trae plantillas y herramientas. **Nunca se guarda nada de la persona acá y nunca se sube nada desde acá.**
- **`DESTINO`** = su cerebro (por defecto `$HOME\cerebro`). Tiene su propio git, solo en su compu. **Nunca va adentro de `HERRAMIENTAS` ni se sube a este repo.**

## 0. Antes de empezar

1. **Idioma.** Preguntá: **"¿En qué idioma querés todo tu sistema? / Em que idioma você quer todo o seu sistema?"** (español o português). Desde ahí, todo lo que sigue sale de esa respuesta, y le hablás en ese idioma:

   | | Español | Português |
   |---|---|---|
   | `IDIOMA` | `es` | `pt` |
   | Acceso directo | `Mi cerebro` | `Meu cérebro` |
   | Primer comando | `/empezar` | `/comecar` |

2. Decile en 3 líneas:
   - "Voy a instalar tu sistema: la carpeta, las herramientas, el dictado por voz y un acceso directo. Tarda unos 20 minutos."
   - "**Te voy a pedir permiso para cada paso.** Leé lo que dice y, si es lo que te conté, decí que sí. Es la regla número 1 con Claude: nunca apruebes algo que no entendés; preguntame."
   - "Si algo falla, lo arreglo yo o te explico qué pasó."

**Modo prueba:** si existe `HERRAMIENTAS\.prueba`, leelo. Trae `DESTINO=`, `CLAUDE_DIR=` (en lugar de `~\.claude`) y `DICTADO=`. En ese modo:
- antes de cada comando `claude plugin` o `claude mcp`, poné `$env:CLAUDE_CONFIG_DIR='<CLAUDE_DIR>'`;
- no crees accesos directos, no abras la ventana de la clave y no arranques el dictado.

Fuera del modo prueba: `CLAUDE_DIR = $HOME\.claude` y `DICTADO = $env:LOCALAPPDATA\dictado`.

Usá PowerShell. Un paso por vez. Si un paso falla, leé el error, probá **una** alternativa razonable y, si sigue fallando, anotalo y seguí con el siguiente (salvo los pasos 1 y 2, sin los cuales no hay cerebro). Después de instalar algo con winget, refrescá el PATH: `$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')`.

## 1. Programas y repo

1. Chequeá con `Get-Command` qué hay. Instalá solo lo que falte con `winget install --id <id> -e --silent --accept-package-agreements --accept-source-agreements`. Si falta winget, pedile que instale "Instalador de aplicaciones" (App Installer) desde la Microsoft Store.
   - **Git** (`Git.Git`): para bajar este repo y guardar el historial del cerebro.
   - **Python** (`Python.Python.3.13`, con `--override "/quiet InstallAllUsers=0 PrependPath=1 Include_launcher=1"`) y después `python -m pip install --user --upgrade yt-dlp`. Ojo: el `python` que trae Windows abre la Microsoft Store y no sirve; `python --version` tiene que decir `Python 3`.
   - **uv** (`astral-sh.uv`): para Windows MCP.
   - **Node.js** (`OpenJS.NodeJS.LTS`): para Playwright (`npx --version`).
2. **El repo.** Si `HERRAMIENTAS` no existe: `git clone <link> "$HOME\cerebro-herramientas"`. Si ya existe: `git -C "<HERRAMIENTAS>" pull --ff-only`. Si la conversación arrancó adentro de una copia del repo (este archivo está en la carpeta actual), esa es `HERRAMIENTAS`.

## 2. Su cerebro

1. Preguntale su nombre (una vez).
2. Copiá la plantilla **sin pisar nada**: `powershell -NoProfile -ExecutionPolicy Bypass -File "<HERRAMIENTAS>\herramientas\copiar-plantilla.ps1" -Plantilla "<HERRAMIENTAS>\plantilla-<IDIOMA>" -Destino "<DESTINO>"`. El script lleva el registro que después usa `/actualizar` para no pisar lo suyo.
3. Escribí `<DESTINO>\.claude\origen.json`: `{"repo": "<HERRAMIENTAS>", "idioma": "<IDIOMA>"}`.
4. Si `DESTINO` no tiene `.git`, en esa carpeta corré:
   - `git init`
   - `git config core.autocrlf false`
   - `git config user.name "<nombre>"`
   - `git config user.email cerebro@local`
   - `git add -A`
   - `git commit -m "Cerebro nuevo"` (en portugués, `"Cérebro novo"`)

   Este git es solo local: **no le agregues ningún remoto.**

## 3. Barras de uso y caché (mods)

1. Copiá `<HERRAMIENTAS>\mods-<IDIOMA>\uso` y `cache-reloj` a `<CLAUDE_DIR>\mods\`.
2. En `<CLAUDE_DIR>\settings.json`, primero hacé una copia (`settings.json.antes-del-cerebro`).
3. Después agregá las dos carpetas a `env.CLAUDE_CODE_PLUGIN_DIRS`, separadas por `;`. **Conservá** lo que ya hubiera ahí y el resto del archivo.
4. Si el archivo no existe, crealo con solo eso. Guardalo en UTF-8 sin BOM.

## 4. Plugins oficiales

1. `claude plugin marketplace add anthropics/claude-plugins-official` (si ya está, seguí).
2. `claude plugin install playwright@claude-plugins-official`
3. `claude plugin install skill-creator@claude-plugins-official`

## 5. Windows MCP

Solo si hay `uvx`: `claude mcp add -s user windows-mcp -e ANONYMIZED_TELEMETRY=false -- uvx windows-mcp serve`. Si dice que ya existe, seguí. Decile en una línea qué es: "deja que Claude maneje programas de tu compu, siempre pidiéndote permiso".

## 6. Dictado por voz (Ctrl+Win)

Contale en 2 líneas: "Apretás Ctrl+Win, hablás, lo volvés a apretar y el texto se pega donde esté el cursor. Usa Groq, que tiene un plan gratis; la cuenta y la clave son tuyas."

1. Copiá `<HERRAMIENTAS>\dictado\*` a `DICTADO`. **No pises** un `.env` ni un `config.json` que ya existan.
2. En `DICTADO`:
   - `python -m venv .venv`
   - `.venv\Scripts\python.exe -m pip install -r requirements.txt` (tarda unos minutos; avisale).
3. Si no existe `config.json`, crealo: `{"idioma": "<IDIOMA>", "palabras": ""}`. Preguntale qué palabras o nombres usa mucho (clientes, productos, herramientas) y ponelas en `palabras`, separadas por comas, para que el dictado las reconozca bien.
4. **La clave de Groq. Vos nunca la ves ni la escribís.**
   1. Explicale:
      - "Entrá a https://console.groq.com y creá tu cuenta (con Google es más rápido)."
      - "Andá a **API Keys** → **Create API Key**, ponele de nombre 'dictado' y copiala. Empieza con `gsk_`."
      - "No me la pegues a mí: te abro una ventanita para que la pegues ahí."
   2. Cuando diga que la tiene copiada, abrí la ventana: `Start-Process powershell -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File','"<DICTADO>\guardar-clave.ps1"'`.
   3. Esperá a que te diga que dice "Listo". Para comprobar, usá **solo** `Select-String -Quiet -Path "<DICTADO>\.env" -Pattern '^GROQ_API_KEY=gsk_'`, que responde True o False. Nunca leas, muestres ni copies el `.env`.
   4. Si la clave no está, no frenes la instalación: el dictado queda para después ("pedime 'guardá mi clave del dictado'").
5. **Que arranque solo:** creá un acceso directo `dictado.lnk` en `[Environment]::GetFolderPath('Startup')`, con `TargetPath` = `<DICTADO>\.venv\Scripts\pythonw.exe`, `Arguments` = `"<DICTADO>\main.py"` y `WorkingDirectory` = `<DICTADO>`.
6. Arrancalo ahora con `Start-Process "<DICTADO>\.venv\Scripts\pythonw.exe" -ArgumentList '"<DICTADO>\main.py"' -WorkingDirectory "<DICTADO>"`. Pedile que pruebe: Ctrl+Win, que diga una frase y Ctrl+Win otra vez, acá en el chat.

## 7. Acceso directo

`Mi cerebro` o `Meu cérebro` en el escritorio, que abre PowerShell con `claude` en `DESTINO`:

```powershell
$sh = New-Object -ComObject WScript.Shell
$l = $sh.CreateShortcut((Join-Path ([Environment]::GetFolderPath('Desktop')) '<Acceso directo>.lnk'))
$l.TargetPath = (Get-Command powershell).Source
$l.Arguments = '-NoExit -NoProfile -Command "claude"'
$l.WorkingDirectory = '<DESTINO>'
$l.Save()
```

## 8. Verificación

Comprobá cada cosa (no la des por hecha) y mostrá una tabla, una línea por fila, con ✅ o ❌:

- **Cerebro:**
  - existen `<DESTINO>\CLAUDE.md`, `<DESTINO>\.claude\skills\<empezar o comecar>\SKILL.md`, `<DESTINO>\.claude\plantilla.json` y `<DESTINO>\.claude\origen.json`;
  - `git -C <DESTINO> log --oneline` tiene al menos 1 commit;
  - `git -C <DESTINO> remote` sale vacío.
- **Separación:** `DESTINO` no está adentro de `HERRAMIENTAS`, y `git -C <HERRAMIENTAS> status --short` no muestra archivos de la persona.
- **Mods:** `<CLAUDE_DIR>\settings.json` es JSON válido e incluye las 2 carpetas de mods, que existen.
- **Plugins:** `claude plugin list` muestra `playwright` y `skill-creator`.
- **MCP:** `claude mcp list` muestra `windows-mcp` y `playwright` conectados. La primera vez Windows MCP descarga sus archivos: si sale "no conectado", esperá 30 segundos y probá otra vez antes de marcar ❌.
- **Dictado:** `<DICTADO>\.venv\Scripts\python.exe -c "import groq, sounddevice, pynput, PySide6"` responde sin error; la clave está guardada (`Select-String -Quiet`); el acceso directo de inicio existe. En modo prueba, la clave y el inicio no aplican.
- **Escritorio:** el acceso directo existe (no aplica en modo prueba).
- **Videos:** `python -m yt_dlp --version` responde.

Si algo dio ❌, decí en una línea qué significa para ella (por ejemplo, "sin esto no anda `/video`; lo demás sí") y qué hacer.

## Al terminar (corto, en su idioma)

1. "Listo. Cerrá esta ventana y abrí **Mi cerebro** (o **Meu cérebro**) en el escritorio."
2. "Ahí escribí **/empezar** (o **/comecar**): armamos juntos tu sistema."
3. "Dos cosas a mano:
   - En claude.ai → Configuración → Conectores, conectá Gmail, Google Calendar, Drive y ClickUp.
   - Para usar tu Chrome, instalá la extensión 'Claude' desde la Chrome Web Store y en Claude escribí `/chrome`."
4. "Cuando haya herramientas nuevas, decime **'actualizá las herramientas'** (o **'atualiza as ferramentas'**): traigo lo nuevo sin tocar nada tuyo."

## Respaldo

Si esta forma no anda, `instalar-cerebro.cmd` (en esta carpeta) instala lo básico con doble clic; no incluye el dictado.
