---
name: inovar
description: >-
  Use quando você quer um ângulo novo para um problema do negócio olhando como OUTROS setores resolvem (hotelaria, academias, assinaturas, eventos, o que tiver a mesma estrutura), com busca real na web; devolve 2-3 ideias concretas para trazer, com fonte, e recomenda uma. Não é para montar uma ideia do zero nem para atacá-la (isso é o /roast). Gatilhos: /inovar, "cruza setores", "como outros setores resolvem isso", "me traz ideias de fora", "isso precisa de um ângulo novo", "o que outras indústrias fazem com isso". Em espanhol: "cruzá rubros", "traeme ideas de afuera", "esto necesita un ángulo nuevo".
---

# Inovar

> **Onde salvar e procurar:** use o mapa "Onde está cada coisa" do `CLAUDE.md`. Os caminhos abaixo (`empresa/…`, `projetos/…`, `notas/…`) são exemplos: se o mapa disser outra coisa, vale o mapa. Se não houver lugar para algo, proponha um e use `notas/` enquanto isso.

## Do que se trata

Vários pesquisadores (subagentes em paralelo) buscam na web como setores de fora resolvem um problema com a mesma estrutura que o seu, e no final você traduz isso para o negócio e devolve 2-3 ideias concretas, recomendando uma. **A variedade vem do MATERIAL, não do papel:** cinco agentes com "chapéus" diferentes são o mesmo modelo com os mesmos vieses; o que os torna diferentes é cada um ler sobre um setor diferente.

**O sinal é a ideia rara com fonte, não o que todo mundo repete** (exceção: se dois setores chegam à mesma coisa e as fontes confirmam, isso é forte; ver passo 2). Proibido "tirar a média": cada ideia é apresentada como o pesquisador trouxe, com o setor e a fonte dela.

**A ideia cruzada não é o produto: a melhor jogada é.** Se o que ganha é a prática normal do setor (principalmente se o usuário não está fazendo), o resultado diz isso PRIMEIRO: "aqui não inove: faça X". Inventar um cruzamento para justificar a rodada é fazer teatro.

## Quando usar e quando não

- **Sim:** um problema real com ESTRUTURA (um processo, incentivos, como o dinheiro ou as pessoas se movem) em que o normal do setor não basta ou se busca um ângulo novo. Ex.: "os alunos compram o curso e não terminam", "o cliente nos chama só para o lançamento e depois some".
- **Não:** para montar uma ideia do zero (conversa normal); para atacar algo já montado (`/roast`); para decisões de gosto ou nomes (não há mecanismo para trazer); para perguntas de dados (`/pesquisar`).

## O processo

### Passo 0 — Abstrair e escolher setores (quem faz é você, barato) — OBRIGATÓRIO

> O cruzamento é tão bom quanto a abstração. Se você manda o problema cru, saem analogias de superfície ("hotelaria → programa de pontos"). E se você não escreve a abstração, cada pesquisador abstrai do seu jeito com o MESMO cérebro, e todos ficam parecidos.

1. **Leve o problema para a forma estrutural.** Não "como consigo mais alunos", mas "como transformar compradores de uma vez só em recorrentes quando o produto é consumido uma vez só". Uma ou duas frases, sem o setor dentro. Se ajudar, leia o arquivo do projeto ou da área correspondente (segundo o mapa), o cliente (`empresa/clientes/<cliente>.md`) ou o projeto (`projetos/<nome>.md`).
2. **Anote como o setor resolve isso hoje** (lançamentos digitais, infoprodutos): pelo que o usuário conta ou com 1 busca rápida. É a linha de base para depois dizer "isso já se usa aqui". Se a linha de base sozinha já resolve o problema e o usuário não está fazendo, diga isso no ponto de controle: talvez aqui não seja preciso inovar.
3. **Escolha 5 setores a partir da abstração** ("que outros setores têm esta mesma estrutura?"): 2 próximos, 2 a meia distância, 1 distante (a meia distância costuma dar o melhor; o distante é a aposta). Só setores com informação pública que dê para buscar.
4. **PONTO DE CONTROLE — mostre ao usuário e espere o OK dele:** a abstração, a linha de base e os 5 setores. Ele pode vetar, trocar ou somar. 30 segundos aqui salvam a rodada inteira.

### Passo 1 — Pesquisadores (um por setor aprovado, em paralelo)

Com a ferramenta `Agent`, todos numa só mensagem, sem ver o que os outros fazem: `subagent_type: "general-purpose"` e **`model: "sonnet"` sempre escrito**.

Prompt por pesquisador (substitua `[SETOR]` e `[ABSTRAÇÃO]`):

```
Você pesquisa como o setor de [SETOR] resolve este problema:

[ABSTRAÇÃO]

REGRAS:
- BUSQUE NA WEB DE VERDADE, é obrigatório: WebSearch e WebFetch. NÃO responda de memória: um mecanismo sem fonte real não serve e é descartado.
- Traga 1-2 MECANISMOS concretos: COMO funcionam, o que aproveitam. Não o rótulo ("usam gamificação" não vale; "dão um prêmio surpresa a cada tantas visitas porque Y" vale).
- Para cada mecanismo: (a) como funciona, concreto; (b) a CONDIÇÃO que faz funcionar: o que esse setor tem para que dê certo; (c) fonte com link; (d) um exemplo real de quem usa.
- Desconfie das suas próprias fontes: marque o quão sólida é cada uma. Priorize a fonte original ou a de alguém que trabalha nesse setor; matérias de marketing do tipo "10 estratégias" NÃO contam como fonte.
- Não traduza para o problema original nem recomende nada: a sua entrega é o material cru do setor.
- Zero subagentes.

DEVOLVA curto: para cada mecanismo, os 4 pontos. O seu texto final É a sua entrega.
```

### Passo 2 — Traduzir para o negócio (quem faz é você, sem agentes)

- **Traduza cada mecanismo para o problema real** (aqui sim, com todo o contexto do usuário): o que isso seria aqui, concreto?
- **Cheque a condição que faz funcionar:** ela se cumpre no caso do usuário? Se não se cumpre, a ideia morre ali (o erro clássico: copiar algo que só funciona com milhares de clientes quando você tem vinte). Diga isso em uma linha, sem maquiar.
- **PROIBIDO MISTURAR:** nada de liquidificar mecanismos numa recomendação morna. Cada ideia mantém o seu setor, o seu mecanismo e a sua fonte.
- **Se dois setores chegam à mesma coisa, não descarte: cheque contra as fontes.** Abra cada fonte citada (`WebFetch`) e confirme que o mecanismo está NA fonte, não só no resumo do pesquisador. Está nas fontes dos dois? Candidata FORTE. Só nos resumos? É o modelo repetindo o que já sabia: fora.

### Passo 3 — Já existe no setor? (1 busca por ideia)

Para cada ideia viva: **alguém do setor do usuário já faz isso?** Com uma busca real, não com opinião.

- Se já se usa no setor, NÃO é inovação. Se é uma boa prática que o usuário não faz, vai na linha dela no resultado; nunca é descartada em silêncio.
- Se não aparece, é candidata.

### Passo 4 — Entrega

2-3 ideias no máximo e **você recomenda UMA** com o porquê (nunca um cardápio de pesos iguais). O usuário escolhe.

Antes de entregar, **abra a fonte da RECOMENDADA e de cada ALTERNATIVA** (`WebFetch`) e confirme que o mecanismo está NA fonte. Se a fonte NÃO o sustenta, essa ideia morre (vai para DESCARTADAS com a causa "a fonte não sustenta") e sobe a alternativa que foi verificada.

Se não sobrar nenhuma ideia viva: sem bloco RECOMENDADA, você entrega "não há cruzamento que se sustente: <a melhor jogada>" + DESCARTADAS completas. Nunca ressuscite uma ideia morta para encher o formato.

Se o que ganha é o normal do setor, o resultado começa com isso ("aqui não inove: faça X") e as ideias cruzadas ficam embaixo. Uma ideia que vai ser feita de verdade pode passar depois pelo `/roast` (só a escolhida); se o "primeiro passo barato" dela custa menos que um roast, teste direto.

## Resultado (formato fixo)

```
Inovar: <problema>

ABSTRAÇÃO USADA: <a forma estrutural>

RECOMENDADA — <setor> → <mecanismo>
  Como funciona lá:          <2-3 linhas + fonte com link>
  O que seria aqui:          <a tradução concreta para o negócio>
  O que faz funcionar:       <a condição e por que ela se cumpre aqui>
  Primeiro passo barato:     <o que testar em 48 h sem investir>
  Por que esta:              <1 linha>

ALTERNATIVA — <mesmo formato, mais 1-2>

JÁ EXISTE NO SEU SETOR (não é inovação, mas você não está fazendo): <se for o caso, 1 linha cada>
DESCARTADAS: <setor → mecanismo → por que morreu (a condição não se cumpre / o modelo repetindo / já é prática do setor / a fonte não sustenta), 1 linha cada>
```

Só leitura: não escreva nada por conta própria. No final, ofereça anotar a ideia escolhida no final de `decisoes.md` (só se adiciona embaixo, nunca se apaga) ou salvar o resultado em `notas/AAAA-MM-DD-inovar-<tema>.md`.

## Sinais de alerta — PARE

- Você lançou os pesquisadores sem o OK do usuário à abstração e aos setores → pare e faça isso.
- Um pesquisador trouxe mecanismos sem fonte → não entram; ou consegue o link ou cai fora.
- Você descartou uma coincidência entre setores sem checar as fontes → pode estar jogando fora a melhor ideia.
- Você misturou dois mecanismos "para arredondar" → isso é tirar a média; apresente separados.
- Uma ideia chegou ao resultado sem checar a condição que a faz funcionar → volte ao passo 2.
- Você tirou em silêncio um "isso já se usa no setor" → vai visível na linha dele.
- Você entregou uma ideia fraca quando a prática normal era a jogada → diga "faça o normal" no topo de tudo.
- Você lançou um agente sem `model:` escrito → coloque sempre (`"sonnet"`).
