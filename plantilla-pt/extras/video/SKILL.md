---
name: video
description: >-
  Use quando você cola um link do YouTube ou do Vimeo e quer que o Claude "assista": baixa as legendas reais do vídeo (não adivinha pelo título), tira as ideias que servem para o negócio com o minuto de cada uma, e te diz o que fazer com isso. Só vídeos online com legendas (não arquivos do computador nem áudios). Gatilhos: /video, "assiste esse vídeo", "o que diz esse vídeo", "tira as ideias disso", "resume esse vídeo", "vi isso e quero aplicar", "transcreve esse vídeo", ou um link do YouTube colado sozinho. Em espanhol: "mirá este video", "qué dice este video", "sacá las ideas de esto", "resumime este video".
---

# Vídeo

> **Onde salvar e procurar:** use o mapa "Onde está cada coisa" do `CLAUDE.md`. Os caminhos abaixo (`empresa/…`, `projetos/…`, `notas/…`) são exemplos: se o mapa disser outra coisa, vale o mapa. Se não houver lugar para algo, proponha um e use `notas/` enquanto isso.

## Do que se trata

O Claude não consegue ver um vídeo, mas consegue ler as **legendas** (quase sempre bastam). Esta skill baixa as legendas reais do vídeo: não adivinha o conteúdo pelo título.

**O resumo NÃO é o produto.** Um resumo qualquer um faz. O produto é o cruzamento: o que disso se aplica ao negócio, a um cliente ou a um projeto em andamento, o que contradiz algo já decidido, e qual é a próxima ação concreta. Se o vídeo não traz nada aplicável, diga isso: "isso não te serve, segue em frente" é uma entrega válida.

## Passo 1 — Baixar as legendas

```
python .claude/skills/video/get-transcript.py "<URL>"
```

- Precisa do `yt-dlp`. Se disser que falta: `python -m pip install --user yt-dlp` e rode de novo. Se algum dia você usar na mão, sempre como `python -m yt_dlp`, nunca `yt-dlp` sozinho (não está no PATH).
- Idioma: escolhe sozinho. Prefere legendas feitas à mão antes das automáticas, e o idioma original do vídeo (espanhol → português → inglês). Para forçar um: adicione `--lang pt` (ou `es`, `en`).
- Salva numa pasta temporária do Windows e te diz o caminho exato. **Não salve no cérebro:** o texto completo é descartável; o que se guarda são as ideias (passo 3).
- Se disser "sem legendas disponíveis", avise o usuário: este vídeo não pode ser lido com esta skill. Não invente o conteúdo.
- Se o YouTube bloquear (erro 429 ou "confirm you're not a bot"), espere alguns minutos e repita; se continuar, tente `WebFetch` na URL e deixe claro que foi o plano B.

## Passo 2 — Ler (segundo o tamanho)

O script diz quantas palavras saíram:

- **Menos de 15.000 palavras** (até ~1 hora de vídeo) → leia inteiro com Read. É o normal.
- **Mais de 15.000 palavras** (cursos, lives longas) → NÃO leia inteiro de uma vez. Lance agentes em paralelo com a ferramenta `Agent`, `subagent_type: "general-purpose"` e **`model: "sonnet"` sempre escrito**, um por trecho, cada um com o seu intervalo de linhas e a instrução de devolver **só o que se aplica a <o tema do usuário>, com o minuto**, não um resumo do trecho. Depois quem cruza é você.

As marcas `**[m:ss]**` do texto são o minuto do vídeo: quando citar algo, coloque o minuto para o usuário ir ver.

## Passo 3 — Entrega

Antes de escrever, olhe o arquivo do projeto ou da área correspondente (segundo o mapa), `decisoes.md` e, se o vídeo for sobre um cliente ou um projeto, o arquivo dele (`empresa/clientes/<cliente>.md`, `projetos/<nome>.md`). Se o vídeo contradiz algo já decidido, isso vai no topo de tudo.

```
Vídeo: <título> — <canal> (<duração>)

A IDEIA CENTRAL: <em uma linha, o que o vídeo defende>

SERVE PARA VOCÊ:
  <ideia> [m:ss] → em <o negócio / cliente / projeto> seria <isto, concreto>
  (1-3 no máximo, ordenadas pelo que mais move o ponteiro)

ATENÇÃO: <o que contradiz algo que você já decidiu, ou onde quem fala está vendendo algo (um curso, uma ferramenta), se for o caso>
NÃO SERVE: <o que dá para pular, 1 linha>

PRÓXIMO PASSO: <UMA ação concreta, não um cardápio>
```

No final, ofereça salvar as ideias em `notas/AAAA-MM-DD-video-<tema>.md` (data de hoje, tema curto com hífens).

## Sinais de alerta — PARE

- Você resumiu o vídeo sem cruzar com o negócio → isso qualquer resumidor faz; não entregue assim.
- Você respondeu sobre o vídeo sem rodar o script → está adivinhando pelo título. Rode o script.
- Você salvou o texto completo do vídeo no cérebro → ele vai para a pasta temporária; no cérebro ficam só as ideias.
- Você leu na mão um texto de 100.000 palavras em vez de dividir entre agentes → gastou demais.
- Você entregou 5 ideias do mesmo peso → isso é um cardápio. Corte para 1-3 e aposte em uma.
