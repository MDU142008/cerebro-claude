---
name: pesquisar
description: >-
  Pesquisa de negócio com fontes reais e verificadas: mercado, concorrência, fornecedores e ferramentas, preços ("quanto cobram"), como os melhores fazem, e vídeos do YouTube sobre o tema (ele mesmo procura, sem você passar links). Vai à fonte original (site oficial, página de preços, relatório) em vez de blogs, marca quem vende o que recomenda, comprova o dado que decide e salva o resultado em notas/. Gatilhos: /pesquisar, "pesquisa isso", "pesquisa a fundo", "faz uma pesquisa", "procura em mais lugares", "o que os melhores fazem", "como a concorrência faz", "quanto cobram", "quanto cobram todos que fazem X", "qual ferramenta usar para", "compara fornecedores", "procura vídeos sobre", "o que dizem no YouTube sobre", "pesquisa em massa". NÃO é para um vídeo específico que você já tem (isso é o /video, se estiver ativado). Em espanhol: "investigá", "investigá a fondo", "hacé un research", "cuánto cobran", "comparame proveedores", "buscá videos de".
---

# Pesquisar

> **Onde salvar e procurar:** use o mapa "Onde está cada coisa" do `CLAUDE.md`. Os caminhos abaixo (`empresa/…`, `projetos/…`, `notas/…`) são exemplos: se o mapa disser outra coisa, vale o mapa. Se não houver lugar para algo, proponha um e use `notas/` enquanto isso.

Sem instruções, o modelo pesquisa com honestidade, mas pouco: faz poucas buscas, cita blogs de vendedores tendo a página oficial à mão e deixa "a verificar" coisas que podia abrir. **O que resolve isso são 8 regras curtas no prompt de cada agente, mais uma linha que você escreve: o dado que decide.** Dar um guia longo para o agente ler não melhora o resultado: mais texto, pior pesquisa.

## Antes de lançar: o dado que decide

Escreva no prompt, em uma linha, **o que precisa ser verdade para a resposta servir**, e como comprovar isso. Sem essa linha o agente não sabe o que olhar e testa a coisa errada. Exemplos: "o preço do plano para 10 usuários na página oficial de preços, não numa matéria"; "que a plataforma pague produtores no Brasil e em que moeda, segundo a central de ajuda dela"; "quantos alunos o lançamento teve segundo o próprio produtor, não segundo um terceiro".

## As regras (copie inteiras em cada prompt de pesquisa; você também segue)

```
1. Fonte original, lida inteira: o site oficial, a página de preços oficial, os termos e a central de ajuda, o relatório do órgão oficial, o perfil ou a loja real do concorrente, o vídeo de quem faz. Blogs, matérias de imprensa e revendedores só servem para encontrá-la.
2. O que sustenta a resposta, você abre. Deixar "a verificar" algo decisivo que você podia abrir não é uma entrega.
3. Comprove o que vai recomendar e o dado que decide ({dado que decide}) na própria fonte: a linha da tabela de preços, o parágrafo dos termos, a página do produto. Não num resumo.
4. Desconfie da sua memória: cada preço ou dado com a data da fonte. Os preços mudam com frequência.
5. Cada dado com link e marca [MEDIDO] / [DOCUMENTADO] / [OPINIÃO]; [VENDEDOR] se a fonte vende o que recomenda (procure quem a publica fora do próprio site).
6. Pare quando o dado que decide estiver comprovado e 3 ou mais fontes originais responderem, ou quando 2 buscas seguidas repetirem a mesma coisa. Sem limite de buscas: o freio é a qualidade, não o número. Zero subagentes.
7. Nada inventado. O que você não encontrar vai para "Lacunas". "Não há evidência sólida de X" é um achado.
8. Busque em inglês por padrão (é onde está a maioria das ferramentas e da prática), e some o idioma do lugar quando o tema for local: português para o Brasil, espanhol para a Argentina e a América Latina. As buscas no idioma da fonte; a entrega, em português.
```

Para buscar e ler: `WebSearch` e `WebFetch`. Se uma página não abrir (pede login ou bloqueia), diga isso e procure outra fonte; nunca invente o que ela diria.

## Tamanho

| Tamanho | Quando | Como |
|---|---|---|
| **Um** (padrão) | quase tudo: "quanto custa X?", "qual ferramenta eu uso?", "como tal concorrente faz?" | 1 agente com as regras; se for um dado pontual, você mesmo busca |
| **Partes** | 2 ou mais partes **independentes** (dois concorrentes, Brasil e Argentina, dois fornecedores) | 1 agente por parte, em paralelo |
| **Censo** | a pergunta pede números de muitos casos ("quanto cobram 50 agências", "que preço têm 100 cursos do setor") | muitos casos → checagem por sorteio → a fundo: ver §Censo |
| **Grande** | decisão cara de desfazer (dinheiro, contratar, trocar de fornecedor) ou tema amplo | rodadas: primeiro amplo, depois perguntas dirigidas às lacunas, verificador no final. Siga sozinho entre as rodadas; mostre ao usuário o que encontrou sem parar para esperar um OK |

- Dividir em vários agentes só rende se as partes forem independentes; se uma depende da outra, mais agentes pioram o resultado.
- Todos os agentes com a ferramenta `Agent`, `subagent_type: "general-purpose"` e **`model: "sonnet"` sempre escrito**. A síntese e o cruzamento com o negócio quem faz é você.
- Prompts prontos em `reference/prompts.md`.

## Censo: muitos casos primeiro, os que importam depois

Só quando a pergunta pede (decidir com números de muitos casos). O resto da skill não muda.

1. **Colunas antes de buscar**, cada linha com `url` e `data_observada`. Exemplo para agências: nome, país, serviços, preço publicado, modelo de cobrança (fixo / porcentagem / misto), url.
2. **Muitos casos, 50-200 linhas num CSV:** um ou vários agentes `sonnet` com o prompt "Censo: coletor" de `reference/prompts.md`. Um arquivo CSV por tabela, em `notas/AAAA-MM-DD-<tema>/`.
3. **Checagem por sorteio:** abra de novo ~10% das linhas, escolhidas ao acaso (não as que parecem estranhas). Se falhar mais de 1 em cada 4, a tabela é refeita.
4. **A fundo:** o método de sempre sobre os 5-10 casos que mais se parecem com o que vai ser decidido. **A tabela sozinha não basta para decidir:** o olhar a fundo encontra o que a tabela achata (faixas de preço que faltam, um preço em dólares anotado como reais).

## Vídeos: uma lista grande, depois o filtro

Em perguntas de **prática** ("como fazem os que fazem", lançamentos, funis, ferramentas, vendas), um vídeo de alguém mostrando o próprio trabalho **é** fonte original, e muitas vezes é o melhor que existe. Não espere que te passem links: procure.

Precisa do `yt-dlp` (se faltar: `python -m pip install --user yt-dlp`). Os scripts já chamam ele do jeito certo; se algum dia você usar na mão, sempre como `python -m yt_dlp`, nunca `yt-dlp` sozinho (não está no PATH). Se não der para instalar, pule esta parte e diga isso em "Lacunas".

1. **Lista grande:** `python .claude/skills/pesquisar/scripts/find_videos.py "busca 1" ... "busca 7"`, com 5-8 buscas gerais do tema, em inglês e também em português ou espanhol se o tema for da América Latina. Devolve 50-250 candidatos dos últimos 24 meses, sem shorts, ordenados por sinal (views por dia e views por inscrito).
2. **Filtro (quem faz é você):** escolha 6-10 lendo títulos e canais, não só a pontuação. Priorize quem mostra o próprio processo ou um caso real acima das listas de "10 dicas", e marque [VENDEDOR] se a pessoa vende um curso ou tem um patrocinador do que recomenda.
3. **Legendas:** `python .claude/skills/pesquisar/scripts/get-transcript.py "<URL>"` (salva numa pasta temporária e te diz onde). Se o YouTube bloquear (erro 429), espere alguns minutos ou tente `WebFetch` na URL e anote que foi o plano B. Se forem muitos vídeos, um agente `sonnet` a cada 2-3 vídeos, que devolva **só o aplicável, com o minuto `[m:ss]`**, não um resumo.

## Onde procurar, segundo o tema

- **Preços e concorrência:** o site do concorrente e a página de preços dele, o Instagram ou a página de vendas, o Mercado Livre se ele vende lá; sempre com link e data. Nunca porcentagens genéricas tiradas de matérias.
- **Plataformas e fornecedores** (de cursos, pagamentos, e-mail, WhatsApp, anúncios): a página de preços oficial, os termos e a central de ajuda. Os revendedores e "parceiros" são [VENDEDOR] e costumam cobrar mais que o original.
- **Mercado:** um "estudo de mercado" de uma consultoria que vende o serviço é [VENDEDOR]. Um tamanho de mercado sem explicar como foi calculado é descartado. Dados oficiais (IBGE, Banco Central, órgãos do governo; INDEC se for Argentina), com link para o documento.
- **Como os melhores fazem:** o material próprio de quem faz (o vídeo, a página de vendas, a entrevista), não o que outra pessoa diz sobre ele.

## Depois da primeira passada

- **Pergunte de novo uma vez sobre o que foi lido:** contradições, a fonte que foi citada e ninguém abriu. Rende mais do que somar agentes no começo.
- Antes de entregar, abra você mesmo 1-2 dados-chave. Se duas fontes se contradizem num número, resolva na original.
- **Verificador** (`reference/prompts.md`): só no tamanho Grande ou se o usuário pedir. Abre de novo as fontes das 10-20 afirmações que sustentam a conclusão.

## Resultado

**O produto é o que muda para o negócio, não o resumo.** Antes de escrever, leia o arquivo do projeto ou da área correspondente (segundo o mapa) e, se for o caso, o cliente (`empresa/clientes/<cliente>.md`), o projeto (`projetos/<nome>.md`) e `decisoes.md`: se o que você encontrou contradiz algo já decidido, isso vai no topo.

Salve em **`notas/AAAA-MM-DD-<tema>.md`** (data de hoje, tema curto com hífens, ex. `notas/2026-11-25-precos-agencias-lancamento.md`). As notas dos agentes e os CSV, numa pasta com o mesmo nome: `notas/AAAA-MM-DD-<tema>/`.

```markdown
# {Tema} ({data})
**Resposta:** {1-3 linhas, em palavras simples}
**Para o negócio:** {o que muda, o que contradiz algo já decidido, próximo passo concreto}
## Evidência     (afirmação · fonte com link · marca)
## Lacunas       (o que não foi encontrado ou não deu para abrir)
## Custo         (tamanho, quantos agentes, quantas buscas)
```

No chat: a resposta e o que muda para o negócio em no máximo 5 linhas, onde ficou salvo e **um** próximo passo.

## Relação com outras skills

- **`/roast`** ataca a conclusão quando a decisão é cara.
- **`/video`** (se estiver ativado) é para um vídeo específico que o usuário já tem.
