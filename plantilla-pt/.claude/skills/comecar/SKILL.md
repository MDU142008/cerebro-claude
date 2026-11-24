---
name: comecar
description: >-
  Dia 1 do cérebro: uma conversa longa para conhecer a pessoa (quem ela é, o que faz, o que precisa guardar e de onde chega a informação) e, com isso, propor um AIOS feito sob medida (pastas, arquivos, conexões) e montá-lo com o sim dela. Usar na primeira vez (quando o CLAUDE.md diz "(não preenchido)") ou para redesenhar o cérebro. Pode rodar de novo: retoma o que já existe. Gatilhos: /comecar, "vamos começar", "monta meu cérebro", "me conhece", "me configura", "vamos redesenhar meu cérebro", "set me up", "onboard me". Em espanhol: "empecemos", "armá mi cerebro", "conoceme", "configurame".
---

# Começar: seu AIOS do zero

> *Adaptado do `/onboard` do kit AIS-OS de Nate Herk (MIT) e de The Three Ms of AI™. © 2026 Nate Herk. The Three Ms of AI™ é marca de Nate Herk.* O jeito de perguntar (rodadas com recomendação) vem do método *grill-me* de Matt Pocock (github.com/mattpocock/skills, MIT).

Você monta o sistema operacional de IA (AIOS) desta pessoa. Não existe estrutura pronta: **ela sai do que a pessoa conta**. Ela decide; você pergunta, propõe e monta.

**O AIOS é da pessoa, e a GUES é o eixo dele.** Ele é dono da GUES e o sistema vai estar centrado nisso: a proposta coloca a GUES no centro (os clientes, a equipe, os processos, os números, as decisões). Mas não é a única coisa: entra também o resto que importa para ele (outros negócios, dinheiro, saúde, família, aprendizado, ideias). A conversa começa pela pessoa e chega rápido, e a fundo, na GUES.

## Como conversar

- **É uma conversa, não um formulário.** Fale como um sócio curioso que quer entender de verdade: comente o que ele conta, pergunte de novo, peça exemplos ("como foi da última vez?"), siga o fio que ele abre. Muitas perguntas, sem pressa e sem limite: continue até conseguir descrever o trabalho dele melhor do que ele mesmo.
- **Poucas por vez** (1 a 3 por mensagem), na ordem em que surgem naturalmente. Quando houver uma decisão de desenho (não um dado da vida dele), use o formato de rodadas: `❓ **P1 - título**: a pergunta` e embaixo `➡️ sua recomendação e o porquê`, para ele responder "sim", "não" ou "outra coisa".
- **Tudo no idioma do sistema** (o que diz o `CLAUDE.md`, aqui o português): a conversa, os arquivos, os nomes das pastas. Se a pessoa escrever em outro idioma, responda nesse idioma, mas os arquivos continuam em português.
- **Os dados quem busca é você.** O que der para olhar (que conectores ele tem com `/mcp`, os arquivos dele, a agenda ou os e-mails se estiverem conectados), olhe em vez de perguntar, e conte o que viu.
- **Se ele disser sim para tudo, pare:** "isso é o que você quer ou o que eu propus? Este sistema é seu."
- **Salve conforme avança:** anote o que ele conta em `notas/AAAA-MM-DD-comecar.md` enquanto conversam, assim dá para parar e retomar. Se o arquivo já existe, leia e continue de onde parou.

Ao começar, em 3 linhas: "Vamos montar o seu sistema de IA. Primeiro quero te conhecer bem: quem você é, o que faz e o que precisa ter à mão. Depois te proponho como organizar tudo, sob medida, e montamos quando você disser que sim. Responda do jeito que sair."

## O que você precisa chegar a entender

Não é uma lista para ler em ordem: são os temas que a conversa precisa cobrir. Aprofunde onde houver mais.

### 1. Quem ele é
A vida dele, não só o cargo: o que faz, a que se dedica (pode ter mais de um negócio ou atividade), a história dele, o que importa para ele, como é a semana, que idiomas usa e com quem. As **áreas** dele (GUES primeiro; depois dinheiro, saúde, família, estudo, hobbies: as que ele citar) e os **projetos** dentro de cada uma. Comece pela pessoa com 2 ou 3 perguntas e passe logo para a GUES.

### 2. O que ele faz
**A GUES a fundo** (é a parte mais longa da conversa): o que vende e para quem, como ganha dinheiro, cada cliente, a equipe e quem faz o quê, como divide o trabalho com o sócio, os processos que se repetem, as ferramentas, os números que acompanha. Depois, cada outra coisa em que ele trabalha, em concreto: o que produz, para quem, com quem, como sabe se está indo bem, o que decide e o que delega, o que come o tempo dele. Para cada atividade, peça um exemplo real. Os clientes, a equipe, os sócios e fornecedores: quem são e o que ele precisa saber de cada um.

### 3. O que ele precisa guardar
O que ele gostaria que o AIOS soubesse sempre, sem precisar repetir: dados da empresa e dos clientes, decisões e por que as tomou, processos ("como fazemos X"), preços e números, contatos, ideias, reuniões, documentos, aprendizados, o jeito dele de escrever. Pergunte do que ele se esquece, o que sempre perguntam para ele e o que ele procura com frequência. **Tudo o que ele quiser entra**: não corte "para começar".

### 4. De onde chega a informação, e como se conecta
Para cada fonte (e-mail, agenda, WhatsApp, ClickUp, Drive, planilhas, Hotmart, ActiveCampaign, Discord, gravações de reuniões, banco, a que for): o que tem ali, quanto ele usa e se gostaria que o Claude lesse, escrevesse ou as duas coisas. E **explique em uma linha como seria conectada**:
- **Conector do claude.ai** (o mais simples: é ativado em claude.ai → Configurações → Conectores e aparece sozinho aqui). Hoje existem, por exemplo, Gmail, Google Calendar, Google Drive e ClickUp. Veja com `/mcp` quais ele já tem.
- **MCP** (um programa que dá ao Claude acesso a uma ferramenta; alguns se instalam com um comando, como o do Windows que ele já tem).
- **Script ou API** (o Claude escreve um programa pequeno que usa a API da ferramenta com uma chave que a pessoa guarda no computador dela; serve quando não há conector).
- **Na mão** (colar ou exportar um arquivo), enquanto isso.
Se você não sabe se uma ferramenta tem conector, MCP ou API, pesquise antes de responder. **Não conecte nada ainda**: fica anotado no plano.

### 5. Como ele quer trabalhar com o Claude
Como ele gosta das respostas, o que o incomoda numa IA, o que decide sozinho e o que decide com o sócio, o que nunca se faz sem perguntar para ele (as regras fixas do `CLAUDE.md` já estão lá: enviar, apagar, gastar dinheiro, senhas). Se ele escreve muito (e-mails, posts, mensagens), peça que ele **cole** 1 ou 2 textos reais dele, sem editar, para o Claude copiar o jeito dele de escrever.

## Propor o AIOS sob medida

Quando você entender os 5 temas, monte **uma proposta própria para esta pessoa**, não um modelo. Mostre em uma tela:

- **O mapa de pastas e arquivos** (em árvore), pensado para como ela vive e trabalha: com a GUES no centro (a parte mais desenvolvida do mapa) e as outras áreas e projetos em volta. Por exemplo, quem vive em reuniões pode ter uma pasta por cliente com as reuniões dele; quem toca vários negócios, uma por negócio. Explique em uma linha o porquê de cada pasta.
- **O que vai no `CLAUDE.md`** (o que o Claude lê sempre) e o que vai em arquivos separados (o que ele lê quando precisa).
- **As conexões** priorizadas: quais se fazem já com conector, quais depois com MCP ou script.
- **As ferramentas**: quais das ativas (`.claude/skills/`) e das guardadas (`extras/`) servem para ele, e quais novas valeria criar mais adiante (com `/ferramentas`).

Pergunte: **"Montamos assim? O que você mudaria?"** Ajuste até ele dizer que sim. Não escreva nada antes.

## Montar (depois do sim)

1. Crie as pastas e arquivos da proposta, já preenchidos com o que ele contou (nas palavras dele), não vazios.
2. `CLAUDE.md`: substitua tudo o que diz "(o /comecar preenche)" e o "(não preenchido)" do título. A seção **"Onde está cada coisa"** passa a ser o mapa real do AIOS dele: as outras ferramentas usam esse mapa para saber onde salvar e onde procurar.
3. `conexoes.md`: uma linha por fonte (o que é, como se conecta, estado: "conectado", "a conectar com conector", "a conectar com MCP/script", "na mão").
4. Se ele colou textos dele: `references/meu-jeito-de-escrever.md`, com os textos do jeito que vieram.
5. `decisoes.md`: adicione `## AAAA-MM-DD — Desenho do meu AIOS` com o que foi decidido e por quê.
6. Ferramentas: ative as que ele escolheu (mover de `extras/` para `.claude/skills/`; avise que o Claude Code vai pedir permissão para mexer em `.claude` e que ele deve dizer que sim).
7. Rode `/fechar`, que salva a primeira foto.

## Ao terminar (3 linhas)

1. "Pronto: seu AIOS sabe quem você é, o que faz e onde está cada coisa." Mostre o `CLAUDE.md` dele e peça que ele corrija uma coisa.
2. "Teste agora: me pergunte **em que eu foco esta semana?**" Quando ele fizer isso, responda só com o que está nos arquivos dele: 3 pontos, o primeiro com o porquê, e feche com: *"Onde a IA poderia entrar aqui? Até que ponto você pode se apoiar nela para isso?"* (o *Default Shift* dos 3Ms).
3. "Amanhã: conectamos a primeira fonte do `conexoes.md`. Em uma semana: `/manutencao`, para ver como o seu AIOS está montado e o que falta."
