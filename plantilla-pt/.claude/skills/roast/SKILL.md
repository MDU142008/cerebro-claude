---
name: roast
description: >-
  Use quando você quer que destruam uma ideia, plano, oferta, preço ou decisão que você já tem montada: um painel de críticos duros, sem puxa-saco, que procura os furos com evidência e te dá um veredito (matar, ajustar ou lançar). Também quando você desconfia que a IA está dizendo sim para tudo. Gatilhos: /roast, "detona essa ideia", "acha os furos", "por que isso NÃO vai funcionar", "seja brutal", "mata essa ideia", "critica essa oferta". Em espanhol: "roasteá esto", "destrozá esto", "encontrá los agujeros", "sé brutal", "matá esta idea".
---

# Roast

> **Onde salvar e procurar:** use o mapa "Onde está cada coisa" do `CLAUDE.md`. Os caminhos abaixo (`empresa/…`, `projetos/…`, `notas/…`) são exemplos: se o mapa disser outra coisa, vale o mapa. Se não houver lugar para algo, proponha um e use `notas/` enquanto isso.

## Do que se trata

Um painel de até 5 críticos (subagentes em paralelo, `model: "opus"`) que testa uma ideia, plano, oferta ou decisão que o usuário JÁ tem, e devolve um veredito acionável. No final, um auditor independente revisa se o veredito não suavizou nada.

**Por que existe: para a IA não dizer sim para tudo.** Os modelos tendem a agradar, e quanto mais conhecem o usuário, mais dizem sim. O roast foi montado para o contrário. **Por padrão, crítica máxima**, com duas regras que o tornam honesto:
- **Com evidência, não com tom.** Inventar problemas para *parecer* duro é tão bajulador quanto dizer sim. Um problema real com evidência vale mais do que um inventado com palavras afiadas.
- **Sem esquecer o que já foi trabalhado.** Critica-se tudo, inclusive o que o usuário dá por decidido, mas SEMPRE marcando o que já tinha sido dito (nunca apresente o que já foi trabalhado como descoberta nova).

## Quando usar e quando não

- **Sim:** antes de se comprometer com algo que já está montado (uma oferta para um cliente, um preço, um lançamento, uma contratação); quando você desconfia que estão te dizendo sim demais.
- **Não:** para montar uma ideia do zero (isso é uma conversa normal); para buscar como outros setores resolvem o problema (`/inovar`, se estiver ativado); para uma pergunta de dados (`/pesquisar`).

## O processo

### Passo 1 — Preparar o briefing (OBRIGATÓRIO antes de lançar qualquer coisa; barato, sem agentes)

> Pular este passo é a falha número um: um briefing torto faz 5 críticos destruírem com total convicção algo que não é o que o usuário propôs. **O painel não é lançado sem completar os 4 pontos.**

1. **Carregue o que já está escrito.** Se a ideia tem arquivo (`projetos/<nome>.md`, o arquivo do projeto ou da área correspondente (segundo o mapa), `empresa/clientes/<cliente>.md`) ou há algo em `decisoes.md`, leia. Nunca de memória. Se é uma ideia nova sem arquivo, siga.
2. **Separe em dois baldes:** `DECIDIDO/RESOLVIDO` (o que já está fechado e como os riscos foram cobertos) e `EM ABERTO` (o que falta fechar).
3. **Cheque as premissas:** as de fato, contra o que está escrito; as de interpretação, com UMA pergunta ao usuário se houver dúvida.
4. **PONTO DE CONTROLE — mostre ao usuário e espere o OK dele:** o briefing, os dois baldes, quais críticos você vai rodar e **negocie o modo**: "estas soluções me parecem frágeis, ataco ou respeito?". Por padrão ataca-se tudo; o usuário pode limitar.

### Passo 2 — Rodada 1: painel às cegas (em paralelo, `model: "opus"`)

Cada bloco de `personas.md` é um **prompt completo** (já traz dentro as regras contra a bajulação: não as tire). Para lançar: substitua `{BRIEFING}` pelo briefing **neutro, sem dizer de quem é** ("uma aposta de um negócio", NUNCA "a ideia de [nome]") e lance os que se aplicam numa só mensagem, em paralelo, com a ferramenta `Agent`, `subagent_type: "general-purpose"` e `model: "opus"` sempre escrito. **Dê um nome a cada agente** (`name: "contrarian"`, `"principles"`, …): sem nome não dá para retomá-lo na rodada 2.

Se o plano do usuário não tiver acesso ao Opus, use `model: "sonnet"` e diga isso no resultado.

**Quais críticos:** Contrarian + Principles SEMPRE; Expansionist se houver muito a ganhar; Researcher se houver um dado comprovável ou um mercado; Buyer se houver um cliente ou usuário final. Para algo pequeno, rode só Contrarian + Principles e veja se basta antes de somar.

**Às cegas em dois sentidos:** (a) não veem o que os outros dizem, assim opinam diferente; (b) não sabem de quem é a ideia, assim não têm a quem agradar.

### Passo 3 — Primeira síntese (quem faz é você, sem agentes)

- **Pese evidência, não segurança nem tom.** Uma afirmação muito segura sem respaldo não ganha de uma com dados.
- **Verifique as âncoras ANTES de pesar.** Contrarian e Principles apoiam cada golpe num caso real ou numa conta (ver `personas.md`). Se citam um caso, faça 1-2 buscas na web (`WebSearch` / `WebFetch`): existiu e aconteceu o que eles dizem? Se for verificado, pesa como evidência; se não aparecer ou os detalhes não baterem, pesa como ESPECULATIVO (um caso inventado é sinal pior do que nenhum: anote). Se é uma conta, refaça você mesmo com os números do briefing; se não fechar ou usar números que não saem do briefing, ESPECULATIVO. O ESPECULATIVO vai para o resultado, marcado, nunca escondido. O resultado de cada verificação acompanha a rodada 1 em tudo o que vem depois (rodada 2 e auditor).
- **Dê nota separada** a cada dimensão (falha / teto / lógica / dados / cliente), não em bloco.
- Veredito **MATAR / AJUSTAR / LANÇAR** + ações concretas + **marque NOVO vs JÁ SABIDO**.

### Passo 4 — Rodada 2: só se houve desacordo REAL na rodada 1

Se os críticos concordam, NÃO rode a rodada 2 (seria ruído caro). Se discordam, cruze-os sobre o desacordo **retomando os MESMOS agentes da rodada 1** (`SendMessage` para o agente pelo nome, com o bloco "Rodada 2" de `personas.md`; um agente novo não tem postura própria para defender e acaba dando razão a todos). Cada um vê o que os outros disseram + o resultado da verificação, e ataca ou defende pontos concretos: em paralelo, sem buscar consenso, sem mudar de posição por cortesia (só por argumento). Depois você sintetiza de novo.

### Passo 5 — Quando parar

Pare quando o que fica em aberto deixa de ser um desacordo de lógica (outra rodada ajuda) e passa a ser um dado que ninguém sabe (nenhuma rodada ajuda: busque o dado ou aceite a aposta). Não existe rodada 3 de opinião. Se sobrar um dado decisivo e duvidoso, busque-o (Researcher), não faça outra rodada.

### Passo 6 — Auditoria do veredito (sobre o veredito final)

O único que NÃO está às cegas é **você**: conhece o usuário, a história dele e o que ele quer ouvir. Esse é justamente o ponto em que a bajulação pode voltar a entrar. Antes de entregar, lance um agente novo (`Agent`, `subagent_type: "general-purpose"`, `model: "opus"`, sem nome do dono nem contexto da conversa) com os achados crus (1-2 linhas por crítico, anônimos) + o seu veredito completo, e este pedido fixo (não o mude):

> "Abaixo vão os achados crus de um painel de críticos e o veredito que alguém escreveu a partir deles. Revise UMA só coisa: o rótulo (MATAR/AJUSTAR/LANÇAR) e o texto do veredito refletem fielmente o quão graves são os achados, ou há golpes suavizados, enterrados ou omitidos? NÃO avalie a ideia em si, só se o veredito é fiel aos achados. Responda em 2-3 linhas, concreto, citando o achado específico se encontrar algo suavizado."

- A resposta dele vai **LITERAL** para o resultado (linha AUDITORIA). Se você resumir, perde o sentido.
- Se ele trouxer opiniões novas sobre a ideia, ficam de fora (a não ser que aponte um achado do painel que você omitiu).
- Se ele marcar algo suavizado de verdade, corrija a síntese ANTES de entregar e diga isso ("a auditoria me corrigiu: …").

## Resultado (formato fixo)

```
Roast: <o que foi avaliado>

VEREDITO: MATAR / AJUSTAR / LANÇAR — <uma linha>

· O que te mata (Contrarian):     <a falha fatal> [caso verificado / conta / ESPECULATIVO]
· O teto (Expansionist):          <o grande que dá para ganhar>
· O que não fecha (Principles):   <o furo lógico> [caso verificado / conta / ESPECULATIVO]
· Os dados (Researcher):          <o dado mais duro + fonte com link>
· O cliente (Buyer):              <paga / não paga / o que o trava>

O QUE FAZER AGORA: 1-3 ações concretas
O TESTE MAIS BARATO (48 h): <o experimento mínimo que testa a premissa
  mais arriscada ANTES de investir mais>
NÚMEROS (se for uma ideia de negócio): <preço aproximado · quando entra
  o primeiro dinheiro, sendo realista>
NOVO vs JÁ SABIDO: <o que é novo e o que já estava nos arquivos>
AUDITORIA (literal): <2-3 linhas>

▸ (embaixo) o que cada crítico disse, cru
```

Só leitura: não escreva nada por conta própria. No final, ofereça anotar o veredito no final de `decisoes.md` (só se adiciona embaixo, nunca se apaga nem se edita o anterior).

## Contra a bajulação (não se negocia)

- Os críticos rodam **sem saber de quem** é a ideia (passo 2).
- Por padrão, **crítica máxima**, mas **a dureza não é o produto: o problema real é.** Não invente falhas para cumprir um pedido de brutalidade.
- O que o usuário já investiu (tempo, dinheiro) NÃO é motivo para suavizar.

## Sinais de alerta — PARE

- Você lançou o painel sem o briefing e o OK do usuário → pare e faça isso.
- Você apresentou algo que já estava trabalhado como "descoberta nova" → falta marcar novo vs já sabido.
- Um crítico amoleceu porque "é do usuário" → a cegueira se quebrou.
- O veredito soa duro mas nenhum golpe tem evidência → é dureza de papelão; volte a pesar por evidência.
- Você usou um caso citado sem verificá-lo → verifique ou marque ESPECULATIVO.
- Você rodou a rodada 2 sem desacordo real → ruído caro.
- Você resumiu ou cortou a auditoria → ela vai literal, mesmo que te deixe mal. PRINCIPALMENTE se te deixar mal.
- Você lançou um agente sem `model:` escrito → coloque sempre.

## Os críticos

Ver `personas.md` (5 prompts). Contrarian + Principles sempre; Expansionist se houver muito a ganhar; Researcher se houver dados ou mercado; Buyer se houver cliente.
