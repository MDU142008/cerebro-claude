---
name: actualizar
description: >-
  Trae las herramientas nuevas o mejoradas del repo de origen (skills, barras de uso y caché, dictado) sin pisar nada de lo tuyo: lo que cambiaste, lo que creaste y lo que borraste queda como está. Triggers (ES/PT): /actualizar, "actualizá las herramientas", "actualizá mi cerebro", "hay herramientas nuevas?", "traé lo nuevo", "atualiza as ferramentas".
---

# Actualizar

Las herramientas vienen de un repo (la carpeta de origen que dice `.claude/origen.json`). Tu cerebro es otra cosa y nunca se sube a ese repo. Actualizar = traer lo nuevo de allá **sin tocar lo tuyo**.

## Pasos

1. Leé `.claude/origen.json` (`repo`: dónde está la copia del repo; `idioma`: `es` o `pt`). Si no existe, preguntá dónde está la carpeta de las herramientas (suele ser `~\cerebro-herramientas`).
2. Traé lo nuevo: `git -C "<repo>" pull --ff-only`. Si dice que ya está al día, contalo y pará.
3. **Herramientas y plantilla:** `powershell -NoProfile -ExecutionPolicy Bypass -File "<repo>\herramientas\copiar-plantilla.ps1" -Plantilla "<repo>\plantilla-<idioma>" -Destino "<esta carpeta>"`. El script lleva un registro de cómo se instaló cada archivo: actualiza solo lo que no tocaste, trae lo nuevo, y deja quieto lo que cambiaste (TUYO) y lo que borraste (BORRADO).
4. **Barras de uso y caché:** copiá `<repo>\mods-<idioma>\uso` y `cache-reloj` encima de `~\.claude\mods\` (esas carpetas no son tuyas: se reemplazan enteras).
5. **Dictado** (si está instalado en `$env:LOCALAPPDATA\dictado`): copiá encima `main.py`, `overlay.html`, `requirements.txt`, `run.bat`, `guardar-clave.ps1` y `LEEME.md` desde `<repo>\dictado\`. **Nunca toques `.env` ni `config.json`.** Si cambió `requirements.txt`, corré `.venv\Scripts\python.exe -m pip install -r requirements.txt`. Reiniciá el dictado: cerrá el proceso `pythonw` que corre su `main.py` y arrancalo de nuevo con `Start-Process "<dictado>\.venv\Scripts\pythonw.exe" -ArgumentList '"<dictado>\main.py"' -WorkingDirectory "<dictado>"`.
6. Guardá una foto: `git add -A` y `git commit -m "Actualización de herramientas"`.
7. **Contá en pocas líneas, en palabras simples:** qué herramientas son nuevas (y qué hace cada una, leyendo su `description`), cuáles se mejoraron, cuáles no se tocaron porque las cambiaste vos ("si querés la versión nueva igual, decime y te muestro la diferencia") y si hay que escribir `/reload-skills` o reiniciar Claude para verlas.

## No

- No pises ni borres nada que el script marque como TUYO o BORRADO.
- No subas nada de esta carpeta al repo de origen: es privado y es tuyo.
