---
name: atualizar
description: >-
  Traz as ferramentas novas ou melhoradas do repositório de origem (skills, barras de uso e cache, ditado) sem mexer em nada seu: o que você mudou, criou ou apagou fica como está. Gatilhos (PT/ES): /atualizar, "atualiza as ferramentas", "atualiza meu cérebro", "tem ferramenta nova?", "traz o que é novo", "actualizá las herramientas".
---

# Atualizar

As ferramentas vêm de um repositório (a pasta de origem indicada em `.claude/origen.json`). O seu cérebro é outra coisa e nunca é enviado para esse repositório. Atualizar = trazer o que é novo de lá **sem mexer no que é seu**.

## Passos

1. Leia `.claude/origen.json` (`repo`: onde está a cópia do repositório; `idioma`: `es` ou `pt`). Se não existir, pergunte onde está a pasta das ferramentas (normalmente `~\cerebro-herramientas`).
2. Traga o que é novo: `git -C "<repo>" pull --ff-only`. Se disser que já está atualizado, conte isso e pare.
3. **Ferramentas e modelo:** `powershell -NoProfile -ExecutionPolicy Bypass -File "<repo>\herramientas\copiar-plantilla.ps1" -Plantilla "<repo>\plantilla-<idioma>" -Destino "<esta pasta>"`. O script guarda um registro de como cada arquivo foi instalado: atualiza só o que você não mexeu, traz o que é novo e deixa quieto o que você mudou (TUYO) e o que você apagou (BORRADO).
4. **Barras de uso e cache:** copie `<repo>\mods-<idioma>\uso` e `cache-reloj` por cima de `~\.claude\mods\` (essas pastas não são suas: são substituídas inteiras).
5. **Ditado** (se estiver instalado em `$env:LOCALAPPDATA\dictado`): copie por cima `main.py`, `overlay.html`, `requirements.txt`, `run.bat`, `guardar-clave.ps1` e `LEEME.md` a partir de `<repo>\dictado\`. **Nunca mexa em `.env` nem em `config.json`.** Se `requirements.txt` mudou, rode `.venv\Scripts\python.exe -m pip install -r requirements.txt`. Reinicie o ditado: feche o processo `pythonw` que roda o `main.py` dele e inicie de novo com `Start-Process "<dictado>\.venv\Scripts\pythonw.exe" -ArgumentList '"<dictado>\main.py"' -WorkingDirectory "<dictado>"`.
6. Salve uma foto: `git add -A` e `git commit -m "Atualização das ferramentas"`.
7. **Conte em poucas linhas, com palavras simples:** quais ferramentas são novas (e o que cada uma faz, lendo a `description`), quais foram melhoradas, quais não foram tocadas porque você as mudou ("se quiser a versão nova mesmo assim, me diga que eu te mostro a diferença") e se é preciso digitar `/reload-skills` ou reiniciar o Claude para vê-las.

## Não

- Não sobrescreva nem apague nada que o script marque como TUYO ou BORRADO.
- Não envie nada desta pasta para o repositório de origem: ela é privada e é sua.
