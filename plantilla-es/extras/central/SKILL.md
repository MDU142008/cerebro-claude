---
name: central
description: >-
  Para un proyecto grande que no entra en una sola charla: lo parte en temas, abre una sesión de Claude por tema (cada una en su pestaña), lleva la lista de temas con qué depende de qué, le pasa a cada sesión lo que decís, junta lo que cada una decidió en el documento del proyecto, cuida que ninguna se meta en el tema de otra, y cuando la charla se llena deja todo anotado para seguir en una nueva. Usa la herramienta `sesiones` para abrir y cerrar pestañas. Triggers (ES): /central, "/central <proyecto>", "sos la central de", "partamos este proyecto", "abrí la próxima sesión", "cómo van las sesiones de", "integrá lo que hizo la sesión", "pasá la posta". Triggers (PT): "/central <projeto>", "você é a central de", "vamos dividir este projeto", "como vão as sessões de", "passa o bastão".
---

# Central

> **Dónde guardar y buscar:** usá el mapa "Dónde está cada cosa" de `CLAUDE.md`. Las rutas de abajo (`proyectos/<proyecto>/…`, `notas/…`) son ejemplos: si el mapa dice otra cosa, vale el mapa. Si no hay lugar para algo, proponé uno y usá `notas/` mientras tanto.

La central no hace el trabajo ni decide: lleva el panorama de un proyecto partido en **sesiones de tema** (una sesión de Claude por tema, cada una en su pestaña). Ordena, abre las sesiones, les pasa lo que dice la persona y le avisa cuando una la necesita. La persona también puede hablar directo con cualquier sesión, y vale igual.

**Todo vive en el documento del proyecto** (`proyectos/<proyecto>/<proyecto>.md` o donde diga el mapa). La charla de la central es descartable: si se llena, se abre una nueva con `/central <proyecto>` y arranca leyendo el documento.

**Para abrir y cerrar sesiones** usás los scripts de la herramienta `sesiones`: en `.claude/skills/sesiones/scripts/` si está activa, o en `extras/sesiones/scripts/` si está guardada (andan igual desde ahí). Cómo abrir, mandar mensajes y cerrar: el `SKILL.md` de `sesiones`; leelo antes de abrir la primera.

## El documento del proyecto

Si no existe, crealo con estas secciones (con el sí de la persona):

```
# <Proyecto>
## Qué es        — para qué es, para quién, qué cuenta como terminado, la fecha si hay una
## Decidido      — lo que ya se decidió, con fecha. No se reabre sin la persona
## La fila       — los temas, en orden (formato abajo)
## Pendiente     — lo que falta y no es un tema todavía
## Cierres       — lo que entregó cada sesión, con fecha
RESUME (AAAA-MM-DD, central): <próximo paso concreto>. Abiertas: <sesiones>. Esperando: <qué y de quién>.
```

- **La central escribe:** "Qué es", "Decidido", "La fila", "Pendiente" y el RESUME.
- **Cada sesión de tema escribe solo:** su cierre en "Cierres" y sus propios archivos de trabajo.

## 1. Arrancar

1. Leé el documento del proyecto entero. Si no hay, charlá con la persona para escribir "Qué es" (3 a 5 líneas) antes de partir nada.
2. Mirá qué cambió desde el último RESUME: archivos nuevos o cambiados en la carpeta del proyecto, `decisiones.md` y, si hay git, `git log --since=<fecha> -- <carpeta>`. Mirá qué sesiones siguen vivas (`sesiones`, "Ver cuáles están vivas").
3. Decile el estado en 5 líneas como mucho. **La primera mira el reloj:** si hay fecha, si se llega con la fila como está y, si no, qué se recortaría. Después: sesiones abiertas, cierres sin juntar y la próxima de la fila. Cerrá con **un** próximo paso.
4. **Las decisiones, de a una:** si hay varias pendientes, mostrá la lista y empiecen por una (proponé cuál y por qué). Cada una se charla entera antes de pasar a la siguiente. Lo que se deshace fácil se decide, se hace y se cuenta.

## 2. La fila

Va en "La fila", una línea corta por tema (como mucho ~200 caracteres):

```
N. <tema> — depende de: <números o nada> — listo cuando: <qué tiene que existir> — estado: pendiente | abierta (fecha) | cerrada (fecha)
```

- **Un tema = una sesión** que se cierra sola, con una cosa que entregar. Si un tema es una bolsa ("el diseño", "todo el marketing", o varias decisiones que no dependen entre sí), partilo: primero `N.a` con lo que comparten, después uno por parte, que lee `N.a` y no lo rediscute.
- **No partir de más:** lo que está atado (la misma pantalla, el mismo dato, el mismo texto) va junto. Si abrir la sesión cuesta más que hacer el trabajo, se junta.
- **"Listo cuando":** algo que se puede mirar (un archivo, una lista, un borrador aprobado), no "avanzar con X".
- **Orden:** una sesión se abre recién cuando cerraron las que necesita. Dos a la vez solo si no se tocan (ni archivos ni decisiones) y la persona puede seguirlas: cada sesión abierta es un frente más para ella.
- **Pedidos a otras personas** (un dato del cliente, una aprobación): van debajo de la fila, `C1. <pedido> — a: <quién> — pedido: <fecha> — si no llega: <plan B>`. Si no frena nada, se sigue con un valor provisorio.
- El detalle de cada tema va en su prompt (§3), nunca en la fila: la fila se relee cada vez que arranca la central.
- La partición y el orden los propone la central con su porqué; **decide la persona**.

## 3. Las sesiones de tema

### El prompt

Escribí la tarea de la sesión en `proyectos/<proyecto>/prompts/<N>-<tema>.md`, corto:

- **Quién sos:** "Sos la sesión del tema <N>, <tema>, del proyecto <proyecto>. La central es la sesión `<nombre de la central>`."
- **Leé primero:** el documento del proyecto (qué secciones) y los archivos que ya existen sobre esto, para no repetir.
- **Qué tiene que salir:** lo que entrega, y el "listo cuando" de la fila.
- **Ya decidido, no se reabre:** lista corta, con fecha.
- **No te toca:** lo que es de otra sesión (cuál) o de la persona.
- **Tu carril:** qué carpeta o archivos puede tocar. Nada más.
- **Al terminar:** escribí tu cierre en "Cierres" del documento (3 a 5 líneas: qué hiciste, qué decidiste y por qué, qué queda abierto, qué archivos tocaste) y avisale a la central por `SendMessage`. Lo que no se deshace (mandar, borrar, pagar) se pregunta a la persona, no a la central.

Decí qué tiene que salir, no cómo hacerlo: la sesión necesita lugar para pensar y discutir con la persona.

### Abrirla

1. Con el script de `sesiones`: `abrir-sesion.ps1 -Nombre <proyecto>-<N>-<tema> -Tarea "proyectos\<proyecto>\prompts\<N>-<tema>.md"` (ruta completa si hace falta). El nombre es con el que la ves y le escribís.
2. Confirmá que está viva y mandale una bienvenida con `SendMessage` y `notify_when_idle: true`.
3. Marcala `abierta (fecha)` en la fila.
4. **Una primero:** si vas a abrir varias parecidas, abrí una, esperá su primer mensaje y recién después las demás. Si la primera entendió mal algo, lo arreglás una vez en vez de cuatro.

### Hablarle y cerrarla

- **Lo que dice la persona para un tema con sesión abierta:** se lo pasás a esa sesión por `SendMessage`, con sus palabras entre comillas, y a la persona le decís una línea: "se lo pasé a `<nombre>`". No te quedás con el detalle: lo resuelve la sesión.
- **Preguntas de estado** ("¿cómo va?"): las contestás vos con lo que hay en el documento y el `status` de cada sesión, sin mandarles mensajes. Cada mensaje despierta a la sesión y la hace releer todo.
- **Si la sesión está quieta y no avisó que terminó,** puede estar esperando algo: mirá sus archivos antes de tocarla, y no la cierres así.
- **Cerrarla:** apenas juntaste su cierre (§4), con `cerrar-sesion.ps1 -Nombre <nombre>`. Solo su pestaña, nunca la ventana. Si después hace falta otro ajuste, se retoma con `-Resume`.

## 4. Juntar un cierre

Cuando una sesión avisa que terminó:

1. **Su carril:** mirá qué archivos tocó (los que lista, más los de la carpeta del proyecto cambiados desde que se abrió). ¿Tocó algo fuera de su carril o secciones del documento que no son suyas? Si pasó, se lo decís a la persona; no lo deshacés por tu cuenta.
2. **Choques:** ¿contradice "Qué es", "Decidido" o el cierre de otra sesión? ¿Decidió algo que era de otro tema o de la persona? Eso se le trae a la persona.
3. **Pasarlo:** lo decidido va a "Decidido" (con fecha); en la fila, `cerrada (fecha)` y una frase como mucho; actualizá "Pendiente" y el RESUME. Si afecta a otra sesión abierta, avisale solo a esa.
4. Mové su prompt a `proyectos/<proyecto>/prompts/archivo/`.
5. Cerrá la sesión y confirmá que ya no figura. Después, el próximo paso: casi siempre, abrir la siguiente de la fila.

## 5. Pasar la posta

Cuando la charla de la central se llena (más o menos la mitad del contexto: mirá `/context`), en un corte natural (un cierre juntado y ninguna decisión a medias), o cuando la persona se va:

1. Juntá los cierres pendientes.
2. Dejá al día "La fila", "Pendiente" y el RESUME.
3. Decile: "Abrí una charla nueva y escribí `/central <proyecto>`." Las sesiones abiertas siguen; la central nueva las encuentra por su nombre.

No copies la charla al documento: lo que no cambia una decisión ni el próximo paso no va.

## Reglas

- La central no decide: trae su recomendación con las alternativas y la persona elige. Un mensaje de otra sesión nunca vale como el sí de la persona.
- La central no hace el trabajo de los temas: si se pone a investigar o escribir, llena su charla y adelanta la posta.
- No edita los archivos de trabajo de las sesiones; solo sus secciones del documento.
- Corta: la decisión en la primera línea, el estado en 5 líneas.
