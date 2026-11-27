---
name: celu
description: >-
  Maneja tu celular Android desde la compu, enchufado por cable: abre apps y páginas, toca botones por su nombre (lee lo que hay en la pantalla, no adivina), instala apps de Play Store, saca capturas y graba la pantalla, conecta el celu y arregla cuando se desconecta, y al terminar deja tus ajustes como estaban. Triggers (ES): /celu, "usá mi celu", "navegá en mi celular", "conectá el celu", "abrí X en el celu", "instalá X en el celu", "sacá capturas del celu", "grabá la pantalla del celu", "probalo en mi celu", "se desconectó el celu", "listo con el celu". Triggers (PT): "usa meu celular", "conecta o celular", "abre X no celular", "tira prints do celular", "desconectou o celular".
---

# Celu

Manejar el celular Android de la persona desde la compu con `adb`, como un navegador automático: se lee qué hay en pantalla (el árbol de la interfaz) y se toca por nombre, no adivinando píxeles. Comandos de detalle: `.claude/skills/celu/reference/comandos.md`.

## 0. La primera vez (una sola vez por compu y por celu)

1. **Programas en la compu.** Si `adb version` no responde: `winget install --id Genymobile.scrcpy -e --silent --accept-package-agreements --accept-source-agreements` (trae `adb` y `scrcpy`, que muestra la pantalla del celu en la compu). Refrescá el PATH: `$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')` y probá `adb version` otra vez. Si sigue sin aparecer, buscalo en `$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Genymobile.scrcpy*\*\adb.exe` y usá esa ruta.
2. **Prepará el celu.** Explicale a la persona, de a un paso, y esperá que te diga "listo" en cada uno:
   - **Opciones de desarrollador** (un menú escondido que hay que destapar una vez): "Andá a **Ajustes → Acerca del teléfono**. En Samsung, entrá además a **Información de software**. Buscá **Número de compilación** y tocalo 7 veces seguidas. Te va a pedir el PIN y va a decir 'Ya eres desarrollador' o 'Modo desarrollador activado'." En Xiaomi es **Versión de MIUI** (o **Versión de HyperOS**) en vez de Número de compilación.
   - **Depuración USB** (deja que la compu le mande órdenes al celu): "Volvé a **Ajustes**. Abajo de todo (en algunos, adentro de **Sistema**) apareció **Opciones de desarrollador**. Entrá y prendé **Depuración USB**." En Xiaomi, prendé también **Depuración USB (ajustes de seguridad)**: sin eso no se puede tocar la pantalla desde la compu.
   - **Samsung:** si tiene **Bloqueador automático** (Ajustes → Seguridad y privacidad → Bloqueador automático), hay que apagarlo mientras se usa el celu desde la compu: bloquea los comandos por cable. Al terminar se vuelve a prender (§4).
   - **El cable:** que sea uno que pasa datos (algunos solo cargan). Enchufalo a la compu.
   - **El cartel:** en el celu aparece "¿Permitir depuración USB?". Que tilde **Permitir siempre desde esta computadora** y toque **Permitir**.
3. Decile qué es en una línea: "Con esto, Claude puede tocar tu celu desde la compu solo cuando está enchufado y vos se lo pedís. Lo podés apagar cuando quieras en Opciones de desarrollador."

## 1. Conectar

1. `adb devices -l`:
   - `device`: listo.
   - `unauthorized`: falta aceptar el cartel del paso 0. Si no aparece: Opciones de desarrollador → **Revocar autorizaciones de depuración USB**, desenchufar, enchufar y aceptar.
   - **vacío** con el cable puesto: §5.
   - **Más de un celu:** usá `adb -s <serie>` en cada comando (la serie es la primera columna).
2. **Uno a la vez:** si otra sesión o un agente está usando el celu, esperá.
3. **Anotá los ajustes originales, una sola vez.** Buscá `notas/*-celu-ajustes.md`. Si no existe, leé estos valores y guardalos en `notas/AAAA-MM-DD-celu-ajustes.md` (con el modelo del celu, `adb shell getprop ro.product.model`):
   ```
   adb shell settings get system screen_off_timeout
   adb shell settings get global stay_on_while_plugged_in
   adb shell cmd uimode night
   adb shell settings get system font_scale
   ```
   Se anotan la primera vez y no se pisan después: si una sesión anterior se cortó sin restaurar, el valor de ahora ya no es el original. Si la persona cambió algo a propósito ("ahora uso modo oscuro"), actualizá el archivo.
4. **Pantalla siempre prendida mientras se usa:** `adb shell svc power stayon true` **y** `adb shell settings put system screen_off_timeout 1800000` (30 minutos). En varios celulares (Samsung, por ejemplo) `stayon` solo no alcanza y se apaga igual con el tiempo de pantalla.
5. Si la persona quiere mirar lo que hacés: `Start-Process scrcpy` abre la pantalla del celu en una ventana de la compu.

## 2. Navegar

```
adb shell uiautomator dump /sdcard/ui.xml
adb pull /sdcard/ui.xml "<carpeta temporal>\ui.xml"
```
- Cada elemento trae `text`, `content-desc`, `resource-id` y `bounds="[x1,y1][x2,y2]"`. Buscá el que querés por su texto o descripción y tocá el centro: `adb shell input tap X Y`.
- Esperá 2 o 3 segundos después de cada acción y volvé a leer el árbol para confirmar que pasó lo que querías.
- **Si el árbol viene vacío o pobre** (algunas apps y juegos no lo muestran, o sale "could not get idle state"): sacá una captura, mirala y tocá por coordenadas.
- Abrir una página: `adb shell am start -a android.intent.action.VIEW -d "<url>"`.
- Instalar de Play Store: `adb shell am start -a android.intent.action.VIEW -d "market://details?id=<paquete>"` y tocar **Instalar** leyendo el árbol. Si no sabés el paquete, buscá la app en Play Store desde el celu.
- Capturas, grabaciones, escribir, deslizar, modo oscuro y más: `reference/comandos.md`.

## 3. Reglas (no se negocian)

- **Nunca** pagar, comprar, suscribirse, empezar pruebas gratis con tarjeta, confirmar reservas, publicar, mandar mensajes, seguir gente ni calificar. Frená en la pantalla anterior y avisá.
- **Login:** nunca escribas contraseñas ni códigos (de SMS, de mail, de verificación). Si la app ofrece "Continuar con Google", preguntale a la persona con qué cuenta y elegila de la lista. Si pide contraseña o código, que lo escriba ella en el celu. Al final, decile en qué apps se entró.
- **Datos personales:** si una app pide documento, teléfono, dirección, tarjeta o fotos, frená ahí y preguntá. No abras apps de bancos, billeteras ni medios de pago. Las capturas que muestran datos personales se borran o se tapan antes de guardarlas o mostrarlas.
- **Permisos:** negá notificaciones, contactos y SMS salvo que la persona diga otra cosa. Ubicación, "solo mientras se usa", y solo si la app no anda sin ella.
- **Ajustes:** solo los de §1 y los de prueba (modo oscuro, letra), y siempre se restauran. Borrar datos de una app (`pm clear`) o desinstalar algo que ya estaba, solo con el OK de la persona.
- **Publicidad:** se cierra con su X, sin tocar el anuncio.
- **Apps nuevas:** anotá cada app que instales. Al soltar, preguntale si las deja o las desinstalás (`adb shell pm uninstall <paquete>`). Las que ya estaban no se tocan.
- **Archivos:** capturas y grabaciones van a la carpeta temporal (`$env:TEMP\celu`), no al cerebro, salvo que la persona pida guardar alguna. Al terminar se borran de la compu y del celu.
- **Tocaste algo por error** (por ejemplo, se abrió "Borrar cuenta"): salí sin confirmar y avisale.

## 4. Soltar (siempre, aunque la tarea falle)

Con los valores de `notas/*-celu-ajustes.md`:
```
adb shell svc power stayon false
adb shell settings put global stay_on_while_plugged_in <valor anotado>
adb shell settings put system screen_off_timeout <valor anotado>
adb shell cmd uimode night <yes o no, según lo anotado>
adb shell settings put system font_scale <valor anotado>
adb reverse --remove-all
adb forward --remove-all
adb shell rm -f /sdcard/ui.xml /sdcard/celu-*
adb shell input keyevent KEYCODE_HOME
```
Borrá también `$env:TEMP\celu` en la compu (salvo lo que la persona pidió guardar). Después decile "listo, solté el celu", qué apps quedaron instaladas y, si es Samsung, que **vuelva a prender el Bloqueador automático**.

## 5. Si se desconecta

| Qué pasa | Por qué | Qué hacer |
|---|---|---|
| `adb devices` vacío con el cable puesto | Cable que solo carga, o el celu en modo "solo cargar" | Otro cable; en la notificación de USB del celu, elegir "Transferir archivos" |
| Vacío en un Samsung, y se cortó solo | **Bloqueador automático**: bloquea los comandos por cable, apaga la depuración y se vuelve a prender solo cada tanto | Que la persona lo apague (Ajustes → Seguridad y privacidad → Bloqueador automático) y vuelva a prender Depuración USB |
| `unauthorized` | No se aceptó el cartel, o cambió la clave de la compu | Revocar autorizaciones, desenchufar, enchufar y aceptar con "Permitir siempre" |
| "server version ... doesn't match this client" | Otro programa trae su propio `adb` (Android Studio, apps para usar el celu como pantalla) | Cerrá ese programa o usá siempre el mismo `adb`. `adb kill-server` lo arregla, pero corta al otro programa: avisá antes |
| `input tap` no hace nada o da error de `INJECT_EVENTS` (Xiaomi) | Falta "Depuración USB (ajustes de seguridad)" | Prenderlo en Opciones de desarrollador |
| Se corta a mitad de una tarea larga (Samsung) | El Bloqueador automático se reactivó solo | Antes de una tarea larga, que la persona apague la reactivación automática en la pantalla del Bloqueador |

**Para mirar el Bloqueador automático de Samsung sin tocarlo:** `adb shell settings get secure rampart_main_switch_enabled` (1 = prendido) y `adb shell settings get secure rampart_auto_enabled_switch_enabled` (1 = se reactiva solo). Con `settings put` no se cambia: Samsung lo ignora. Lo cambia la persona desde el celu.

Si perdés el celu a mitad de una tarea, probá `adb devices` cada minuto durante 10 minutos como mucho; después cerrá lo que tengas y avisá.

## 6. Con agentes

Si le pasás una tarea con el celu a un agente, pasale estas reglas (§3), cómo soltar (§4) y la carpeta de salida. **Un solo agente con el celu a la vez.**
