---
name: hoje
description: >-
  Resumo do dia: e-mails que pedem resposta, reuniões de hoje com o que é preciso levar, e pendências de clientes e projetos; fecha com as 3 coisas mais importantes. Usa Gmail e Google Calendar se estiverem conectados. Gatilhos: /hoje, "o que eu tenho hoje", "bom dia", "vamos começar o dia", "o que está pendente". Em espanhol: "qué tengo hoy", "buen día", "arranquemos el día".
---

# Hoje

> **Onde salvar e procurar:** use o mapa "Onde está cada coisa" do `CLAUDE.md`. Os caminhos abaixo (`empresa/…`, `projetos/…`, `notas/…`) são exemplos: se o mapa disser outra coisa, vale o mapa. Se não houver lugar para algo, proponha um e use `notas/` enquanto isso.

Você monta o começo do dia em menos de uma tela.

## Passos

1. **Agenda (se estiver conectada):** as reuniões de hoje, com horário. Para cada uma com um cliente, procure o arquivo dele em `empresa/clientes/` e some em uma linha o que está pendente com ele.
2. **E-mails (se o Gmail estiver conectado):** os das últimas 24 h (ou desde sexta, se for segunda) que **pedem uma resposta ou uma ação**. Ignore newsletters, notificações automáticas e promoções. Para cada um: de quem, o que pede, em uma linha.
3. **Pendências:** leia a linha de **Estado** e as **Pendências** de `empresa/clientes/*.md` e `projetos/*.md`. Traga só o que vence ou está travado.
4. **As 3 de hoje:** feche com as 3 coisas mais importantes para hoje, em ordem, e por que a primeira é a primeira.

## Se faltar um conector

Se o Gmail ou o Calendar não aparecerem, faça o resumo com os arquivos e diga em uma linha: "Para somar e-mails e reuniões, conecte o Gmail e o Google Calendar em claude.ai → Configurações → Conectores, e depois escreva /mcp aqui."

## Regras

- **Você só lê.** Não responda e-mails, não aceite convites, não marque nada como lido. Se a pessoa pedir "responde para ele", escreva o rascunho, mostre e espere o sim dela antes de enviar.
- Formato: títulos curtos (**Reuniões**, **E-mails**, **Pendências**, **As 3 de hoje**) e uma linha por item.
