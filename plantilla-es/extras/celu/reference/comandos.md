# Comandos de adb (referencia)

Funcionan igual en PowerShell y en Bash. Lo que va entre comillas después de `adb shell` corre en el celu (por eso ahí sí anda `grep`).

## Moverse

```
adb shell input tap X Y
adb shell input swipe 540 1800 540 600 300      # deslizar hacia arriba = bajar en la página
adb shell input text "hola%smundo"              # %s = espacio. Solo letras sin acento: para acentos, que escriba la persona
adb shell input keyevent KEYCODE_BACK           # también KEYCODE_HOME, KEYCODE_ENTER, KEYCODE_APP_SWITCH
adb shell am start -a android.intent.action.VIEW -d "https://ejemplo.com"
adb shell am start -a android.intent.action.VIEW -d "market://details?id=<paquete>"   # la app en Play Store
adb shell monkey -p <paquete> -c android.intent.category.LAUNCHER 1                   # abrir una app
adb shell "pm list packages | grep <parte del nombre>"                                # buscar el paquete
adb shell "pm list packages -3"                                                       # apps instaladas por la persona
adb shell "dumpsys window | grep mCurrentFocus"                                       # qué app está adelante
adb shell wm size                                                                     # tamaño de la pantalla, para calcular toques
```

## Ver

```
adb shell uiautomator dump /sdcard/ui.xml
adb pull /sdcard/ui.xml "$env:TEMP\celu\ui.xml"

# Captura: primero en el celu y después a la compu (en PowerShell, "adb exec-out ... > x.png" rompe la imagen)
adb shell screencap -p /sdcard/celu-cap.png
adb pull /sdcard/celu-cap.png "$env:TEMP\celu\cap.png"

# Grabar la pantalla (hasta 180 segundos; se corta antes con Ctrl+C)
adb shell screenrecord --time-limit 30 /sdcard/celu-grab.mp4
adb pull /sdcard/celu-grab.mp4 "$env:TEMP\celu\grab.mp4"

# Ver la pantalla en vivo en la compu
scrcpy
```

Creá la carpeta antes: `New-Item -ItemType Directory -Force "$env:TEMP\celu"`. En Bash, la ruta es `"$TEMP/celu/..."`.

## Probar cosas (anotá el valor antes y restauralo al soltar)

```
adb shell cmd uimode night yes          # modo oscuro (no = claro)
adb shell settings put system font_scale 1.3   # letra más grande en las apps (normal: 1.0). No agranda páginas web: para eso, Chrome → Ajustes → Accesibilidad → Zoom
adb shell "logcat -d -t 200 | grep -i -E 'chromium|console|error'"   # errores de una página o app
```

## Probar una página que corre en la compu

```
adb reverse tcp:5173 tcp:5173      # el celu abre http://localhost:5173 y ve la compu
adb reverse --remove-all           # al terminar
```

## Ajustes de pantalla (los que se anotan y restauran)

```
adb shell settings get system screen_off_timeout       # en milisegundos (30000 = 30 s)
adb shell settings get global stay_on_while_plugged_in
adb shell cmd uimode night                             # dice "Night mode: yes" o "no"
adb shell settings get system font_scale
adb shell getprop ro.product.model                     # el modelo del celu
```
