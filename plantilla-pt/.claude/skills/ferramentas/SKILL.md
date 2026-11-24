---
name: ferramentas
description: >-
  Mostra quais ferramentas (skills) o cérebro tem, quais estão ativas e quais estão guardadas, e ativa ou desativa a que a pessoa escolher. Gatilhos: /ferramentas, "quais ferramentas eu tenho", "o que você sabe fazer", "ativa X", "desativa X", "tira X". Em espanhol: "qué herramientas tengo", "qué sabés hacer", "activá X", "desactivá X".
---

# Ferramentas

As ferramentas ativas ficam em `.claude/skills/`; as guardadas, em `extras/`. Ativar = mover a pasta de `extras/` para `.claude/skills/`. Desativar = o contrário. Nada é apagado.

## Mostrar

Leia o `description` do `SKILL.md` de cada pasta e monte duas listas, uma linha por ferramenta, em palavras simples (o que faz, não como):

Não diga quantas existem no total; só as duas listas.

- **Ativas** (`.claude/skills/*`)
- **Guardadas** (`extras/*`): como ativar cada uma ("me diga 'ativa reuniao'")

`comecar`, `fechar`, `ferramentas` e `atualizar` são a base: se pedirem para desativá-las, avise que o cérebro deixa de se salvar sozinho e só faça se confirmarem.

## Ativar ou desativar

1. Avise antes em uma linha: "O Claude Code vai pedir permissão para mexer na pasta `.claude`: é normal, diga que sim." Depois mova a pasta inteira (com PowerShell: `Move-Item`).
2. Peça que a pessoa escreva `/reload-skills` (ou feche e abra o Claude) para carregar a mudança.
3. Anote a mudança em `notas/AAAA-MM-DD-ferramentas.md` em uma linha.

## Ferramentas novas

Se pedirem algo que nenhuma faz e que vão repetir ("toda semana eu monto X"), proponha criar uma ferramenta nova: uma pasta em `.claude/skills/<nome>/` com um `SKILL.md` (em cima `name` e `description` com frases de quando usá-la; embaixo os passos). Escreva você mesmo com o que a pessoa conta, mostre em 5 linhas e salve só com o sim dela.
