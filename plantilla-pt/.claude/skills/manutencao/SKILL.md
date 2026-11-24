---
name: manutencao
description: >-
  Revisão semanal de como o AIOS está montado, com os 4 C (Contexto, Conexões, Capacidades, Constância): nota sobre 100, o que está funcionando, os 3 ajustes que mais rendem, e arruma na hora o que é pequeno (arquivos bagunçados, mapa desatualizado) com o sim da pessoa. Gatilhos: /manutencao, "revisa meu AIOS", "como está meu cérebro", "o que falta no meu sistema", "organiza tudo", "manutenção". Em espanhol: "revisá mi AIOS", "cómo está mi cerebro", "ordená todo".
---

# Manutenção

> *Adaptado do `/audit` do kit AIS-OS de Nate Herk (MIT). The Four Cs of an AIOS™ é marca de Nate Herk. © 2026 Nate Herk.*

Você olha **como o AIOS está montado**, não o que automatizar. Uma vez por semana. A primeira vez é a base: depois dá para ver como a nota sobe.

## 1. Olhar (sem mexer em nada)

Leia o `CLAUDE.md` (principalmente o mapa "Onde está cada coisa"), `conexoes.md`, `decisoes.md`, as pastas do mapa, `.claude/skills/` e `extras/`, o `/mcp` (quais conectores e MCP funcionam) e `git log --oneline -20`.

## 2. Dar nota aos 4 C (25 pontos cada um)

**Contexto: o Claude conhece a pessoa e o trabalho dela?**
- `CLAUDE.md` completo, sem "(o /comecar preenche)" (5)
- Quem ela é, o que faz e como quer que falem com ela, claros (5)
- Os arquivos do mapa existem e estão em dia; as linhas de estado têm menos de 2 semanas (10)
- `decisoes.md` tem decisões das últimas 2 semanas (5)

**Conexões: ele chega nas coisas dela sem que ela cole nada?**
- Das fontes de `conexoes.md`, quantas estão conectadas de verdade (e funcionam no `/mcp`) (15, proporcional)
- `conexoes.md` existe e bate com o que funciona (5)
- Pelo menos uma conexão consegue escrever, não só ler (5)

**Capacidades: ele sabe fazer o trabalho dela?**
- Usa as ferramentas ativas: isso aparece nas notas e no histórico (10)
- Tem pelo menos uma ferramenta própria, criada para algo dela (10)
- Nenhuma ferramenta ativa sobra (5)

**Constância: é usado com frequência?**
- Houve sessões com `/fechar` em pelo menos 3 dos últimos 7 dias (git log) (15)
- Tem uma rotina fixa (por exemplo `/hoje` toda manhã ou esta revisão toda semana) (10)

## 3. Entregar (uma tela)

```
Seu AIOS: <total>/100  (Contexto <n> · Conexões <n> · Capacidades <n> · Constância <n>)
Funciona bem: <2 coisas>
Os 3 ajustes que mais rendem:
1. <o quê> — <por que importa> — <como, em uma linha>
2. …
3. …
```

Ordene os ajustes pelo que mais destrava: sem conexões, o Claude está cego; sem contexto, responde genérico. Se houver uma revisão anterior em `notas/`, mostre quanto subiu ou desceu.

## 4. Arrumar o que é pequeno (com o sim dela)

Proponha em uma lista e faça o que ela aprovar: atualizar o mapa do `CLAUDE.md` se houver pastas que não aparecem, mover para `arquivo/` o que terminou (nunca apagar), juntar notas repetidas, corrigir estados antigos perguntando como está cada coisa. O que é grande (uma conexão nova, uma ferramenta nova) não se faz aqui: fica como ajuste proposto.

Salve a revisão em `notas/AAAA-MM-DD-manutencao.md` e rode `/fechar`.
