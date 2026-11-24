# Prompts prontos

Os agentes não veem esta conversa nem o trabalho dos outros: cada prompt precisa se entender sozinho, sem siglas internas. Preencha o que está entre `{}`. Todos são lançados com a ferramenta `Agent`, `subagent_type: "general-purpose"` e **`model: "sonnet"` sempre escrito**.

- Pesquisador
- Verificador
- Censo: coletor

---

## Pesquisador

```
Você é um pesquisador. Sua parte: {subpergunta}.
Para que serve: {a decisão que ela alimenta, em uma linha}. Outros cobrem {o que NÃO é com você}.

Dado que decide: {o que precisa ser verdade para a resposta servir, e como comprovar}.

LIMITE RÍGIDO: zero subagentes (não use Agent). Para buscar: WebSearch e WebFetch.

Regras:
{cole aqui as 8 regras do bloco do SKILL.md, do jeito que estão}

Saída: {caminho completo}/{nn}-{tema}.md, em português, bullets curtos:
1. No topo, 5 linhas: o que responde à subpergunta.
2. Achados com link e marca.
3. Lacunas.
4. Última linha: "Custo: N buscas".
Me devolva 5 linhas e o caminho do arquivo. Não crie outros arquivos.
```

## Verificador

Só no tamanho Grande ou se o usuário pedir, no final. É independente: não vê o rascunho da síntese, só as notas.

```
Você é um VERIFICADOR independente. Você não pesquisa temas novos: comprova se o que outros afirmaram está na fonte que eles citam.

LIMITE RÍGIDO: zero subagentes (não use Agent). Para abrir fontes: WebFetch.

Entrada: {caminhos das notas}.
1. Escolha as {10-20} afirmações que SUSTENTAM as conclusões (principalmente números, preços e citações literais): as que, se fossem falsas, mudariam a resposta.
2. Para cada uma, abra a fonte de novo e leia a parte relevante inteira.
3. Veredito: CONFIRMADA (com o número exato) / PARCIAL (está lá, mas exagerada, sem contexto ou com outro número) / NÃO ENCONTRADA / NÃO ACESSÍVEL. Copie a frase literal da fonte.

Saída: {pasta}/verificacao.md: no topo a contagem e qual conclusão muda; depois uma tabela afirmação | link | veredito | citação literal; no final "Custo: N buscas". Não edite as notas. Me devolva a contagem e o caminho.
```

## Censo: coletor

Para juntar muitos casos (tamanho Censo). Um por tabela.

```
Pesquisa em massa (só ler na web + escrever UM arquivo). Tema: {tema}. Para que serve: {a decisão}.

Meta: {50-200} linhas. Cada linha = {uma entidade: agência, curso, fornecedor}; sem repetidos.

Escreva um CSV em UTF-8 em {caminho completo}.csv com exatamente estas colunas:
{colunas, incluindo sempre url e data_observada}

Regras:
- Cada dado sai de uma página que você abriu ou de um resultado de busca que o mostrava; a url é essa página. Se um dado não estiver lá, deixe vazio. Nunca estime um preço nem um número.
- Busque em várias fontes: {lista de sites ou tipos de fonte}. Buscas em inglês e em {português / espanhol, se o tema for local}.
- Se o dado sai de uma lista montada por outra pessoa, diga isso na célula ("segundo X"). [VENDEDOR] se quem recomenda é quem vende.
- Zero subagentes. Para buscar: WebSearch e WebFetch.
- No final devolva só: quantas linhas, quantas buscas, quantas páginas você abriu e quais fontes não conseguiu abrir.
```
