---
name: reuniao
description: >-
  Antes de uma reunião: monta a preparação (com quem, o que aconteceu da última vez, o que está pendente, o que perguntar, o que decidir). Depois: transforma as notas ou a transcrição em resumo, decisões e tarefas, e salva no cliente ou projeto. Usa Calendar, Gmail e Drive se estiverem conectados. Gatilhos: /reuniao, "prepara a reunião com", "tenho reunião com", "aqui vão as notas da reunião", "resume esta reunião", "resumo da reunião". Em espanhol: "preparame la reunión con", "tengo reunión con", "resumí esta reunión".
---

# Reunião

> **Onde salvar e procurar:** use o mapa "Onde está cada coisa" do `CLAUDE.md`. Os caminhos abaixo (`empresa/…`, `projetos/…`, `notas/…`) são exemplos: se o mapa disser outra coisa, vale o mapa. Se não houver lugar para algo, proponha um e use `notas/` enquanto isso.

## Antes ("prepara a reunião com X")

1. Procure a reunião na agenda (se estiver conectada): horário, quem vai.
2. Junte o que existe: `empresa/clientes/<x>.md` ou `projetos/<x>.md`, as notas de reuniões anteriores em `notas/`, os últimos e-mails com essa pessoa (se o Gmail estiver conectado).
3. Entregue em uma tela:
   - **Com quem e para quê** (1 linha)
   - **Onde paramos da última vez** (2-3 linhas)
   - **Pendências de cada lado**
   - **O que perguntar** (no máximo 5)
   - **O que precisa sair decidido** (1-2)

## Depois ("aqui vão as notas" / cola uma transcrição)

1. Monte: **Resumo** (3 linhas), **Decisões**, **Tarefas** (quem, o quê, para quando) e **Em aberto**.
2. Mostre e pergunte se falta algo.
3. Salve em `notas/AAAA-MM-DD-reuniao-<com-quem>.md`, atualize o **Estado** e as **Pendências** do cliente ou projeto e, se houve decisões da pessoa, adicione no final de `decisoes.md`.
4. Se for preciso enviar um e-mail de acompanhamento, escreva o rascunho e **espere o sim dela antes de enviar**.
