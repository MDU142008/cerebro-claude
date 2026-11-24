---
name: fechar
description: >-
  Fechamento da sessão: salva o que é novo da conversa no arquivo certo (cliente, projeto, decisões, notas) e deixa escrito o próximo passo. Usar ao terminar uma tarefa ou antes de fechar o terminal. Gatilhos: /fechar, "vamos fechar", "salva tudo", "vou sair", "por hoje é isso", "anota isso". Em espanhol: "cerremos", "guardá todo", "me voy", "listo por hoy".
---

# Fechar

> **Onde salvar e procurar:** use o mapa "Onde está cada coisa" do `CLAUDE.md`. Os caminhos abaixo (`empresa/…`, `projetos/…`, `notas/…`) são exemplos: se o mapa disser outra coisa, vale o mapa. Se não houver lugar para algo, proponha um e use `notas/` enquanto isso.

O que não fica escrito se perde: a próxima sessão começa sem lembrar desta conversa. O seu trabalho é deixar nos arquivos o que importa.

## Passos

1. **Revise a conversa** e separe o que é novo em:
   - Algo de um cliente → `empresa/clientes/<cliente>.md` (atualize a linha de **Estado** com a data de hoje e as pendências).
   - Algo de uma coisa em andamento → `projetos/<nome>.md` (se não existir e for algo que vai continuar, crie com **Estado** no topo).
   - Uma decisão → adicione no final de `decisoes.md` (`## AAAA-MM-DD — tema` + **Decidi**, **Por quê**, **O que muda**). Nunca edite nem apague decisões antigas.
   - Algo de uma área ou de um projeto (trabalho, dinheiro, saúde, o que for) → o arquivo dele segundo o mapa.
   - Algo de como a pessoa quer trabalhar ("não faça X", "prefiro Y") → `CLAUDE.md`, em "Como quero que você fale comigo". Só se ela disse com clareza.
   - Todo o resto que valha a pena (resumo de uma reunião, uma ideia) → `notas/AAAA-MM-DD-<tema>.md`.
2. **Escreva curto**, nas palavras da pessoa. Substitua o que é antigo e já não vale nos arquivos de estado; não acumule histórico ali (o histórico vai em `decisoes.md` e `notas/`).
3. **Salve uma foto** para poder voltar atrás: `git add -A` e `git commit -m "<data> — <tema em 5 palavras>"`. Se o git não estiver instalado ou falhar, siga em frente e avise em uma linha.
4. **Diga a ela em 3 linhas:** o que você salvou e onde, o que ficou em aberto e **o próximo passo concreto** (um só).

## Não

- Não invente o que não foi dito. Se não ficou claro se algo foi decidido, pergunte antes de anotar como decisão.
- Não escreva senhas, chaves nem números de cartão em nenhum arquivo, mesmo que apareçam na conversa.
