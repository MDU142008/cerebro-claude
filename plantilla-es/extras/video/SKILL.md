---
name: video
description: >-
  Usala cuando pegás un link de YouTube o Vimeo y querés que Claude lo "vea": baja los subtítulos reales del video (no adivina por el título), saca las ideas que sirven para el negocio con su minuto, y te dice qué hacer con eso. Solo videos online con subtítulos (no archivos de la computadora ni audios). Triggers (ES): /video, "mirá este video", "qué dice este video", "sacá las ideas de esto", "resumime este video", "vi esto y quiero aplicarlo", "transcribí este video", o un link de YouTube pegado solo. Triggers (PT): "assiste esse vídeo", "o que diz esse vídeo", "tira as ideias disso", "resume esse vídeo", "vi isso e quero aplicar", "transcreve esse vídeo".
---

# Video

> **Dónde guardar y buscar:** usá el mapa "Dónde está cada cosa" de `CLAUDE.md`. Las rutas de abajo (`empresa/…`, `proyectos/…`, `notas/…`) son ejemplos: si el mapa dice otra cosa, vale el mapa. Si no hay lugar para algo, proponé uno y usá `notas/` mientras tanto.

## De qué se trata

Claude no puede ver un video, pero sí leer sus **subtítulos** (casi siempre alcanzan). Esta skill baja los subtítulos reales del video: no adivina el contenido desde el título.

**El resumen NO es el producto.** Un resumen lo hace cualquiera. El producto es el cruce: qué de esto aplica al negocio, a un cliente o a un proyecto en marcha, qué contradice algo ya decidido, y cuál es la próxima acción concreta. Si el video no aporta nada aplicable, decilo: "esto no te sirve, seguí" es una entrega válida.

## Paso 1 — Bajar los subtítulos

```
python .claude/skills/video/get-transcript.py "<URL>"
```

- Necesita `yt-dlp`. Si dice que falta: `python -m pip install --user yt-dlp` y volvé a correrlo. Si alguna vez lo usás a mano, siempre como `python -m yt_dlp`, nunca `yt-dlp` a secas (no está en el PATH).
- Idioma: elige solo. Prefiere subtítulos hechos a mano antes que automáticos, y el idioma original del video (español → portugués → inglés). Para forzar uno: agregá `--lang es` (o `pt`, `en`).
- Los guarda en una carpeta temporal de Windows y te dice la ruta exacta. **No los guardes en el cerebro:** el texto completo es descartable; lo que se guarda son las ideas (paso 3).
- Si dice "sin subtítulos disponibles", avisale al usuario: este video no se puede leer con esta skill. No inventes el contenido.
- Si YouTube bloquea (error 429 o "confirm you're not a bot"), esperá unos minutos y repetí; si sigue, probá `WebFetch` sobre la URL y aclará que fue de respaldo.

## Paso 2 — Leerlo (según el largo)

El script dice cuántas palabras salieron:

- **Menos de 15.000 palabras** (hasta ~1 hora de video) → leelo entero con Read. Es lo normal.
- **Más de 15.000 palabras** (cursos, lives largos) → NO lo leas entero de una. Lanzá agentes en paralelo con la herramienta `Agent`, `subagent_type: "general-purpose"` y **`model: "sonnet"` escrito siempre**, uno por tramo, cada uno con su rango de líneas y la consigna de devolver **solo lo aplicable a <el tema del usuario>, con el minuto**, no un resumen del tramo. Después cruzás vos.

Las marcas `**[m:ss]**` del texto son el minuto del video: cuando cites algo, poné el minuto para que el usuario lo vaya a ver.

## Paso 3 — Entrega

Antes de escribir, mirá el archivo del proyecto o área que corresponde (según el mapa), `decisiones.md` y, si el video es sobre un cliente o un proyecto, su archivo (`empresa/clientes/<cliente>.md`, `proyectos/<nombre>.md`). Si el video contradice algo ya decidido, eso va arriba de todo.

```
Video: <título> — <canal> (<duración>)

LA IDEA CENTRAL: <en una línea, qué sostiene el video>

TE SIRVE:
  <idea> [m:ss] → en <el negocio / cliente / proyecto> sería <esto concreto>
  (1-3 como mucho, ordenadas por lo que más mueve la aguja)

OJO: <lo que contradice algo que ya decidiste, o dónde el que habla está vendiendo algo (un curso, una herramienta), si aplica>
NO TE SIRVE: <lo que se puede saltear, 1 línea>

PRÓXIMO PASO: <UNA acción concreta, no un menú>
```

Al final ofrecé guardar las ideas en `notas/AAAA-MM-DD-video-<tema>.md` (fecha de hoy, tema corto con guiones).

## Señales de alarma — FRENÁ

- Resumiste el video sin cruzarlo con el negocio → eso lo hace cualquier resumidor; no lo entregues así.
- Contestaste sobre el video sin correr el script → estás adivinando por el título. Corré el script.
- Guardaste el texto completo del video en el cerebro → va a la carpeta temporal; al cerebro van solo las ideas.
- Leíste a mano un texto de 100.000 palabras en vez de repartirlo en agentes → gastaste de más.
- Entregaste 5 ideas parejas → es un menú. Recortá a 1-3 y jugate por una.
