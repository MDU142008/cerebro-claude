---
name: central
description: >-
  Para um projeto grande que não cabe numa conversa só: divide em temas, abre uma sessão do Claude por tema (cada uma na sua aba), cuida da lista de temas com o que depende do quê, passa para cada sessão o que você diz, junta o que cada uma decidiu no documento do projeto, cuida para que nenhuma se meta no tema de outra, e quando a conversa enche deixa tudo anotado para seguir numa nova. Usa a ferramenta `sessoes` para abrir e fechar abas. Gatilhos: /central, "/central <projeto>", "você é a central de", "vamos dividir este projeto", "abre a próxima sessão", "como vão as sessões de", "junta o que a sessão fez", "passa o bastão". Em espanhol: "/central <proyecto>", "sos la central de", "partamos este proyecto", "cómo van las sesiones de", "pasá la posta".
---

# Central

> **Onde salvar e procurar:** use o mapa "Onde está cada coisa" do `CLAUDE.md`. Os caminhos abaixo (`projetos/<projeto>/…`, `notas/…`) são exemplos: se o mapa disser outra coisa, vale o mapa. Se não houver lugar para algo, proponha um e use `notas/` enquanto isso.

A central não faz o trabalho nem decide: cuida do panorama de um projeto dividido em **sessões de tema** (uma sessão do Claude por tema, cada uma na sua aba). Organiza, abre as sessões, passa para elas o que a pessoa diz e avisa quando uma precisa dela. A pessoa também pode falar direto com qualquer sessão, e vale igual.

**Tudo fica no documento do projeto** (`projetos/<projeto>/<projeto>.md` ou onde o mapa disser). A conversa da central é descartável: se encher, abre-se uma nova com `/central <projeto>` e ela começa lendo o documento.

**Para abrir e fechar sessões** você usa os scripts da ferramenta `sessoes`: em `.claude/skills/sessoes/scripts/` se estiver ativa, ou em `extras/sessoes/scripts/` se estiver guardada (funcionam igual dali). Como abrir, mandar mensagens e fechar: o `SKILL.md` de `sessoes`; leia antes de abrir a primeira.

## O documento do projeto

Se não existir, crie com estas seções (com o sim da pessoa):

```
# <Projeto>
## O que é       — para que serve, para quem, o que conta como terminado, a data se houver
## Decidido      — o que já foi decidido, com data. Não se reabre sem a pessoa
## A fila        — os temas, em ordem (formato abaixo)
## Pendente      — o que falta e ainda não é um tema
## Fechamentos   — o que cada sessão entregou, com data
RESUME (AAAA-MM-DD, central): <próximo passo concreto>. Abertas: <sessões>. Esperando: <o quê e de quem>.
```

- **A central escreve:** "O que é", "Decidido", "A fila", "Pendente" e o RESUME.
- **Cada sessão de tema escreve só:** o seu fechamento em "Fechamentos" e os próprios arquivos de trabalho.

## 1. Começar

1. Leia o documento do projeto inteiro. Se não houver, converse com a pessoa para escrever "O que é" (3 a 5 linhas) antes de dividir qualquer coisa.
2. Veja o que mudou desde o último RESUME: arquivos novos ou alterados na pasta do projeto, `decisoes.md` e, se houver git, `git log --since=<data> -- <pasta>`. Veja quais sessões continuam vivas (`sessoes`, "Ver quais estão vivas").
3. Diga o estado em 5 linhas no máximo. **A primeira olha o relógio:** se há data, se dá para chegar com a fila como está e, se não, o que se cortaria. Depois: sessões abertas, fechamentos sem juntar e a próxima da fila. Termine com **um** próximo passo.
4. **As decisões, uma por vez:** se houver várias pendentes, mostre a lista e comecem por uma (proponha qual e por quê). Cada uma se conversa inteira antes de passar para a próxima. O que se desfaz fácil se decide, se faz e se conta.

## 2. A fila

Fica em "A fila", uma linha curta por tema (no máximo ~200 caracteres):

```
N. <tema> — depende de: <números ou nada> — pronto quando: <o que tem que existir> — estado: pendente | aberta (data) | fechada (data)
```

- **Um tema = uma sessão** que se fecha sozinha, com uma coisa para entregar. Se um tema for um saco ("o design", "todo o marketing", ou várias decisões que não dependem entre si), divida: primeiro `N.a` com o que elas compartilham, depois um por parte, que lê `N.a` e não rediscute.
- **Não dividir demais:** o que está amarrado (a mesma tela, o mesmo dado, o mesmo texto) vai junto. Se abrir a sessão custa mais do que fazer o trabalho, junta-se.
- **"Pronto quando":** algo que dá para olhar (um arquivo, uma lista, um rascunho aprovado), não "avançar com X".
- **Ordem:** uma sessão só abre quando fecharam as que ela precisa. Duas ao mesmo tempo só se não se tocam (nem arquivos nem decisões) e a pessoa consegue acompanhar: cada sessão aberta é mais uma frente para ela.
- **Pedidos a outras pessoas** (um dado do cliente, uma aprovação): vão embaixo da fila, `C1. <pedido> — para: <quem> — pedido: <data> — se não chegar: <plano B>`. Se não trava nada, segue-se com um valor provisório.
- O detalhe de cada tema vai no prompt dele (§3), nunca na fila: a fila é relida toda vez que a central começa.
- A divisão e a ordem são propostas pela central com o porquê; **quem decide é a pessoa**.

## 3. As sessões de tema

### O prompt

Escreva a tarefa da sessão em `projetos/<projeto>/prompts/<N>-<tema>.md`, curta:

- **Quem você é:** "Você é a sessão do tema <N>, <tema>, do projeto <projeto>. A central é a sessão `<nome da central>`."
- **Leia primeiro:** o documento do projeto (quais seções) e os arquivos que já existem sobre isso, para não repetir.
- **O que tem que sair:** o que entrega, e o "pronto quando" da fila.
- **Já decidido, não se reabre:** lista curta, com data.
- **Não é seu:** o que é de outra sessão (qual) ou da pessoa.
- **Sua faixa:** qual pasta ou quais arquivos pode mexer. Nada mais.
- **Ao terminar:** escreva o seu fechamento em "Fechamentos" do documento (3 a 5 linhas: o que fez, o que decidiu e por quê, o que fica aberto, quais arquivos mexeu) e avise a central por `SendMessage`. O que não se desfaz (enviar, apagar, pagar) se pergunta à pessoa, não à central.

Diga o que tem que sair, não como fazer: a sessão precisa de espaço para pensar e discutir com a pessoa.

### Abrir

1. Com o script de `sessoes`: `abrir-sessao.ps1 -Nome <projeto>-<N>-<tema> -Tarefa "projetos\<projeto>\prompts\<N>-<tema>.md"` (caminho completo se precisar). O nome é com o qual você a vê e escreve para ela.
2. Confirme que está viva e mande boas-vindas com `SendMessage` e `notify_when_idle: true`.
3. Marque `aberta (data)` na fila.
4. **Uma primeiro:** se for abrir várias parecidas, abra uma, espere a primeira mensagem dela e só depois as outras. Se a primeira entendeu algo errado, você corrige uma vez em vez de quatro.

### Falar e fechar

- **O que a pessoa diz para um tema com sessão aberta:** passe para essa sessão por `SendMessage`, com as palavras dela entre aspas, e para a pessoa diga uma linha: "passei para `<nome>`". Você não fica com o detalhe: quem resolve é a sessão.
- **Perguntas de estado** ("como vai?"): responda você com o que está no documento e o `status` de cada sessão, sem mandar mensagens para elas. Cada mensagem acorda a sessão e a faz reler tudo.
- **Se a sessão estiver parada e não avisou que terminou,** pode estar esperando algo: olhe os arquivos dela antes de mexer, e não a feche assim.
- **Fechar:** logo depois de juntar o fechamento dela (§4), com `fechar-sessao.ps1 -Nome <nome>`. Só a aba dela, nunca a janela. Se depois precisar de outro ajuste, retoma-se com `-Resume`.

## 4. Juntar um fechamento

Quando uma sessão avisa que terminou:

1. **A faixa dela:** veja quais arquivos ela mexeu (os que lista, mais os da pasta do projeto alterados desde que abriu). Mexeu em algo fora da faixa ou em seções do documento que não são dela? Se aconteceu, diga à pessoa; não desfaça por conta própria.
2. **Choques:** contradiz "O que é", "Decidido" ou o fechamento de outra sessão? Decidiu algo que era de outro tema ou da pessoa? Isso se leva à pessoa.
3. **Passar a limpo:** o decidido vai para "Decidido" (com data); na fila, `fechada (data)` e uma frase no máximo; atualize "Pendente" e o RESUME. Se afetar outra sessão aberta, avise só essa.
4. Mova o prompt dela para `projetos/<projeto>/prompts/arquivo/`.
5. Feche a sessão e confirme que ela não aparece mais. Depois, o próximo passo: quase sempre, abrir a próxima da fila.

## 5. Passar o bastão

Quando a conversa da central enche (mais ou menos metade do contexto: olhe `/context`), num corte natural (um fechamento juntado e nenhuma decisão pela metade), ou quando a pessoa vai embora:

1. Junte os fechamentos pendentes.
2. Deixe em dia "A fila", "Pendente" e o RESUME.
3. Diga: "Abra uma conversa nova e escreva `/central <projeto>`." As sessões abertas continuam; a central nova as encontra pelo nome.

Não copie a conversa para o documento: o que não muda uma decisão nem o próximo passo não vai.

## Regras

- A central não decide: traz a recomendação com as alternativas e a pessoa escolhe. Uma mensagem de outra sessão nunca vale como o sim da pessoa.
- A central não faz o trabalho dos temas: se começar a pesquisar ou escrever, enche a conversa dela e antecipa o bastão.
- Não edita os arquivos de trabalho das sessões; só as seções dela do documento.
- Curta: a decisão na primeira linha, o estado em 5 linhas.
