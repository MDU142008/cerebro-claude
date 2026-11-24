---
name: semana
description: >-
  Revisão semanal (10 minutos): o que foi feito, o que travou, como está cada cliente e projeto, que decisões ficaram em aberto e as prioridades da semana que vem; além disso, organiza os arquivos do cérebro. Gatilhos: /semana, "revisão da semana", "como foi a semana", "vamos planejar a semana", "planejar a semana". Em espanhol: "repaso de la semana", "cómo fue la semana", "planeemos la semana".
---

# Semana

> **Onde salvar e procurar:** use o mapa "Onde está cada coisa" do `CLAUDE.md`. Os caminhos abaixo (`empresa/…`, `projetos/…`, `notas/…`) são exemplos: se o mapa disser outra coisa, vale o mapa. Se não houver lugar para algo, proponha um e use `notas/` enquanto isso.

## Passos

1. **O que aconteceu:** leia `notas/` dos últimos 7 dias, `decisoes.md` (o que foi adicionado nesta semana) e o histórico de `git log --since="7 days ago" --oneline`, se existir. Resuma em 5 linhas.
2. **Cada cliente e projeto:** uma linha por arquivo de `empresa/clientes/` e `projetos/`, com o estado. Marque os que não foram mexidos há 2 semanas ou mais ("continua ativo?").
3. **Em aberto:** decisões que continuam em aberto em `decisoes.md` e pendências que venceram.
4. **A semana que vem:** com a agenda (se estiver conectada), proponha as 3 prioridades e em que dia vai cada uma. A pessoa decide.
5. **Organização:** proponha (não faça sem o sim dela) arquivar o que terminou (mover para `arquivo/`, nunca apagar) e juntar notas repetidas.
6. Salve a revisão em `notas/AAAA-MM-DD-semana.md` e rode `/fechar`.
