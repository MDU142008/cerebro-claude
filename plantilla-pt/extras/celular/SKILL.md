---
name: celular
description: >-
  Controla o seu celular Android pelo computador, ligado por cabo: abre apps e páginas, toca nos botões pelo nome (lê o que está na tela, não adivinha), instala apps da Play Store, tira prints e grava a tela, conecta o celular e resolve quando ele desconecta, e no final deixa os seus ajustes como estavam. Gatilhos: /celular, "usa meu celular", "navega no meu celular", "conecta o celular", "abre X no celular", "instala X no celular", "tira prints do celular", "grava a tela do celular", "testa no meu celular", "o celular desconectou", "pronto com o celular". Em espanhol: "usá mi celu", "conectá el celu", "abrí X en el celu", "sacá capturas del celu", "se desconectó el celu".
---

# Celular

Controlar o celular Android da pessoa pelo computador com `adb`, como um navegador automático: lê-se o que está na tela (a árvore da interface) e toca-se pelo nome, sem adivinhar pixels. Comandos em detalhe: `.claude/skills/celular/reference/comandos.md`.

## 0. A primeira vez (uma vez só por computador e por celular)

1. **Programas no computador.** Se `adb version` não responder: `winget install --id Genymobile.scrcpy -e --silent --accept-package-agreements --accept-source-agreements` (traz o `adb` e o `scrcpy`, que mostra a tela do celular no computador). Atualize o PATH: `$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')` e teste `adb version` de novo. Se continuar sem aparecer, procure em `$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Genymobile.scrcpy*\*\adb.exe` e use esse caminho.
2. **Prepare o celular.** Explique para a pessoa, um passo por vez, e espere ela dizer "pronto" em cada um:
   - **Opções do desenvolvedor** (um menu escondido que precisa ser liberado uma vez): "Vá em **Configurações → Sobre o telefone**. No Samsung, entre também em **Informações do software**. Procure **Número de compilação** e toque 7 vezes seguidas. Vai pedir o PIN e dizer 'Você agora é um desenvolvedor' ou 'Modo desenvolvedor ativado'." No Xiaomi é **Versão da MIUI** (ou **Versão do HyperOS**) em vez de Número de compilação.
   - **Depuração USB** (deixa o computador mandar comandos para o celular): "Volte em **Configurações**. Lá embaixo (em alguns, dentro de **Sistema**) apareceu **Opções do desenvolvedor**. Entre e ligue **Depuração USB**." No Xiaomi, ligue também **Depuração USB (configurações de segurança)**: sem isso não dá para tocar na tela pelo computador.
   - **Samsung:** se tiver **Bloqueador automático** (Configurações → Segurança e privacidade → Bloqueador automático), precisa desligar enquanto o celular é usado pelo computador: ele bloqueia os comandos pelo cabo. No final, liga de novo (§4).
   - **O cabo:** tem que ser um que passa dados (alguns só carregam). Ligue no computador.
   - **O aviso:** no celular aparece "Permitir depuração USB?". Marque **Sempre permitir neste computador** e toque em **Permitir**.
3. Diga o que é em uma linha: "Com isso, o Claude pode mexer no seu celular pelo computador só quando ele está ligado no cabo e você pede. Dá para desligar quando quiser em Opções do desenvolvedor."

## 1. Conectar

1. `adb devices -l`:
   - `device`: pronto.
   - `unauthorized`: falta aceitar o aviso do passo 0. Se não aparecer: Opções do desenvolvedor → **Revogar autorizações de depuração USB**, desligar o cabo, ligar de novo e aceitar.
   - **vazio** com o cabo ligado: §5.
   - **Mais de um celular:** use `adb -s <série>` em cada comando (a série é a primeira coluna).
2. **Um por vez:** se outra sessão ou um agente estiver usando o celular, espere.
3. **Anote os ajustes originais, uma vez só.** Procure `notas/*-celular-ajustes.md`. Se não existir, leia estes valores e salve em `notas/AAAA-MM-DD-celular-ajustes.md` (com o modelo do celular, `adb shell getprop ro.product.model`):
   ```
   adb shell settings get system screen_off_timeout
   adb shell settings get global stay_on_while_plugged_in
   adb shell cmd uimode night
   adb shell settings get system font_scale
   ```
   Anota-se na primeira vez e não se sobrescreve depois: se uma sessão anterior caiu sem restaurar, o valor de agora já não é o original. Se a pessoa mudou algo de propósito ("agora uso modo escuro"), atualize o arquivo.
4. **Tela sempre ligada enquanto se usa:** `adb shell svc power stayon true` **e** `adb shell settings put system screen_off_timeout 1800000` (30 minutos). Em vários celulares (Samsung, por exemplo) só o `stayon` não basta e a tela apaga do mesmo jeito com o tempo de tela.
5. Se a pessoa quiser ver o que você faz: `Start-Process scrcpy` abre a tela do celular numa janela do computador.

## 2. Navegar

```
adb shell uiautomator dump /sdcard/ui.xml
adb pull /sdcard/ui.xml "<pasta temporária>\ui.xml"
```
- Cada elemento traz `text`, `content-desc`, `resource-id` e `bounds="[x1,y1][x2,y2]"`. Procure o que você quer pelo texto ou pela descrição e toque no centro: `adb shell input tap X Y`.
- Espere 2 ou 3 segundos depois de cada ação e leia a árvore de novo para confirmar que aconteceu o que você queria.
- **Se a árvore vier vazia ou pobre** (alguns apps e jogos não mostram, ou sai "could not get idle state"): tire um print, olhe e toque por coordenadas.
- Abrir uma página: `adb shell am start -a android.intent.action.VIEW -d "<url>"`.
- Instalar da Play Store: `adb shell am start -a android.intent.action.VIEW -d "market://details?id=<pacote>"` e tocar em **Instalar** lendo a árvore. Se não souber o pacote, procure o app na Play Store pelo celular.
- Prints, gravações, escrever, deslizar, modo escuro e mais: `reference/comandos.md`.

## 3. Regras (não se negociam)

- **Nunca** pagar, comprar, assinar, começar testes grátis com cartão, confirmar reservas, publicar, mandar mensagens, seguir pessoas nem avaliar. Pare na tela anterior e avise.
- **Login:** nunca digite senhas nem códigos (de SMS, de e-mail, de verificação). Se o app oferecer "Continuar com o Google", pergunte à pessoa com qual conta e escolha na lista. Se pedir senha ou código, a pessoa digita no celular. No final, diga em quais apps se entrou.
- **Dados pessoais:** se um app pedir documento (CPF, RG), telefone, endereço, cartão ou fotos, pare ali e pergunte. Não abra apps de banco, carteiras nem meios de pagamento. Prints que mostram dados pessoais são apagados ou cobertos antes de salvar ou mostrar.
- **Permissões:** negue notificações, contatos e SMS, a não ser que a pessoa diga outra coisa. Localização, "só durante o uso", e só se o app não funcionar sem ela.
- **Ajustes:** só os do §1 e os de teste (modo escuro, letra), e sempre são restaurados. Apagar dados de um app (`pm clear`) ou desinstalar algo que já estava, só com o OK da pessoa.
- **Propaganda:** fecha-se pelo X, sem tocar no anúncio.
- **Apps novos:** anote cada app que você instalar. Ao soltar, pergunte se ela fica com eles ou se você desinstala (`adb shell pm uninstall <pacote>`). Os que já estavam não se tocam.
- **Arquivos:** prints e gravações vão para a pasta temporária (`$env:TEMP\celular`), não para o cérebro, a não ser que a pessoa peça para guardar algum. No final, são apagados do computador e do celular.
- **Tocou em algo por engano** (por exemplo, abriu "Excluir conta"): saia sem confirmar e avise.

## 4. Soltar (sempre, mesmo que a tarefa falhe)

Com os valores de `notas/*-celular-ajustes.md`:
```
adb shell svc power stayon false
adb shell settings put global stay_on_while_plugged_in <valor anotado>
adb shell settings put system screen_off_timeout <valor anotado>
adb shell cmd uimode night <yes ou no, conforme o anotado>
adb shell settings put system font_scale <valor anotado>
adb reverse --remove-all
adb forward --remove-all
adb shell rm -f /sdcard/ui.xml /sdcard/celular-*
adb shell input keyevent KEYCODE_HOME
```
Apague também `$env:TEMP\celular` no computador (menos o que a pessoa pediu para guardar). Depois diga "pronto, soltei o celular", quais apps ficaram instalados e, se for Samsung, que **ligue de novo o Bloqueador automático**.

## 5. Se desconectar

| O que acontece | Por quê | O que fazer |
|---|---|---|
| `adb devices` vazio com o cabo ligado | Cabo que só carrega, ou o celular em modo "só carregar" | Outro cabo; na notificação de USB do celular, escolher "Transferir arquivos" |
| Vazio num Samsung, e caiu sozinho | **Bloqueador automático**: bloqueia os comandos pelo cabo, desliga a depuração e liga sozinho de novo de tempos em tempos | A pessoa desliga (Configurações → Segurança e privacidade → Bloqueador automático) e liga de novo a Depuração USB |
| `unauthorized` | Não aceitou o aviso, ou mudou a chave do computador | Revogar autorizações, desligar o cabo, ligar e aceitar com "Sempre permitir" |
| "server version ... doesn't match this client" | Outro programa traz o próprio `adb` (Android Studio, apps para usar o celular como tela) | Feche esse programa ou use sempre o mesmo `adb`. `adb kill-server` resolve, mas derruba o outro programa: avise antes |
| `input tap` não faz nada ou dá erro de `INJECT_EVENTS` (Xiaomi) | Falta "Depuração USB (configurações de segurança)" | Ligar em Opções do desenvolvedor |
| Cai no meio de uma tarefa longa (Samsung) | O Bloqueador automático voltou sozinho | Antes de uma tarefa longa, a pessoa desliga a reativação automática na tela do Bloqueador |

**Para olhar o Bloqueador automático da Samsung sem mexer:** `adb shell settings get secure rampart_main_switch_enabled` (1 = ligado) e `adb shell settings get secure rampart_auto_enabled_switch_enabled` (1 = volta sozinho). Com `settings put` não muda: a Samsung ignora. Quem muda é a pessoa, pelo celular.

Se você perder o celular no meio de uma tarefa, teste `adb devices` a cada minuto por 10 minutos no máximo; depois feche o que tiver aberto e avise.

## 6. Com agentes

Se passar uma tarefa com o celular para um agente, passe estas regras (§3), como soltar (§4) e a pasta de saída. **Um agente só com o celular por vez.**
