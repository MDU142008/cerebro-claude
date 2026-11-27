# Comandos do adb (referência)

Funcionam igual no PowerShell e no Bash. O que vai entre aspas depois de `adb shell` roda no celular (por isso ali o `grep` funciona).

## Mexer

```
adb shell input tap X Y
adb shell input swipe 540 1800 540 600 300      # deslizar para cima = descer na página
adb shell input text "ola%smundo"               # %s = espaço. Só letras sem acento: para acentos, a pessoa digita
adb shell input keyevent KEYCODE_BACK           # também KEYCODE_HOME, KEYCODE_ENTER, KEYCODE_APP_SWITCH
adb shell am start -a android.intent.action.VIEW -d "https://exemplo.com"
adb shell am start -a android.intent.action.VIEW -d "market://details?id=<pacote>"   # o app na Play Store
adb shell monkey -p <pacote> -c android.intent.category.LAUNCHER 1                   # abrir um app
adb shell "pm list packages | grep <parte do nome>"                                  # procurar o pacote
adb shell "pm list packages -3"                                                      # apps instalados pela pessoa
adb shell "dumpsys window | grep mCurrentFocus"                                      # qual app está na frente
adb shell wm size                                                                    # tamanho da tela, para calcular toques
```

## Ver

```
adb shell uiautomator dump /sdcard/ui.xml
adb pull /sdcard/ui.xml "$env:TEMP\celular\ui.xml"

# Print: primeiro no celular e depois para o computador (no PowerShell, "adb exec-out ... > x.png" estraga a imagem)
adb shell screencap -p /sdcard/celular-print.png
adb pull /sdcard/celular-print.png "$env:TEMP\celular\print.png"

# Gravar a tela (até 180 segundos; para antes com Ctrl+C)
adb shell screenrecord --time-limit 30 /sdcard/celular-grav.mp4
adb pull /sdcard/celular-grav.mp4 "$env:TEMP\celular\grav.mp4"

# Ver a tela ao vivo no computador
scrcpy
```

Crie a pasta antes: `New-Item -ItemType Directory -Force "$env:TEMP\celular"`. No Bash, o caminho é `"$TEMP/celular/..."`.

## Testar coisas (anote o valor antes e restaure ao soltar)

```
adb shell cmd uimode night yes          # modo escuro (no = claro)
adb shell settings put system font_scale 1.3   # letra maior nos apps (normal: 1.0). Não aumenta páginas web: para isso, Chrome → Configurações → Acessibilidade → Zoom
adb shell "logcat -d -t 200 | grep -i -E 'chromium|console|error'"   # erros de uma página ou app
```

## Testar uma página que roda no computador

```
adb reverse tcp:5173 tcp:5173      # o celular abre http://localhost:5173 e vê o computador
adb reverse --remove-all           # ao terminar
```

## Ajustes de tela (os que se anotam e restauram)

```
adb shell settings get system screen_off_timeout       # em milissegundos (30000 = 30 s)
adb shell settings get global stay_on_while_plugged_in
adb shell cmd uimode night                             # diz "Night mode: yes" ou "no"
adb shell settings get system font_scale
adb shell getprop ro.product.model                     # o modelo do celular
```
