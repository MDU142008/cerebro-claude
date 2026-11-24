---
name: investigar
description: >-
  Investigación de negocio con fuentes reales y verificadas: mercado, competencia, proveedores y herramientas, precios ("cuánto cobran"), cómo lo hacen los mejores, y videos de YouTube sobre el tema (los busca solo, sin que le pases links). Va a la fuente original (sitio oficial, página de precios, informe) en vez de blogs, marca quién vende lo que recomienda, comprueba el dato que decide y guarda el resultado en notas/. Triggers (ES): /investigar, "investigá", "investigá a fondo", "hacé un research", "buscá en más lugares", "qué hacen los mejores", "cómo lo hace la competencia", "cuánto cobran", "cuánto cobran todos los que hacen X", "qué herramienta uso para", "comparame proveedores", "buscá videos de", "qué dicen en YouTube sobre", "investigación en masa". Triggers (PT): "pesquisa isso", "pesquisa a fundo", "faz uma pesquisa", "o que os melhores fazem", "como a concorrência faz", "quanto cobram", "qual ferramenta usar", "compara fornecedores", "procura vídeos sobre", "o que dizem no YouTube sobre". NO para un video puntual que ya tenés (eso es /video, si está activada).
---

# Investigar

> **Dónde guardar y buscar:** usá el mapa "Dónde está cada cosa" de `CLAUDE.md`. Las rutas de abajo (`empresa/…`, `proyectos/…`, `notas/…`) son ejemplos: si el mapa dice otra cosa, vale el mapa. Si no hay lugar para algo, proponé uno y usá `notas/` mientras tanto.

Sin instrucciones, el modelo investiga honesto pero corto: hace pocas búsquedas, cita blogs de vendedores teniendo la página oficial a mano y deja "a verificar" cosas que podía abrir. **Lo que lo arregla son 8 reglas cortas en el prompt de cada agente, más una línea que escribís vos: el dato que decide.** Darle a leer una guía larga al agente no mejora el resultado: más texto, peor investigación.

## Antes de lanzar: el dato que decide

Escribí en el prompt, en una línea, **qué tiene que ser cierto para que la respuesta sirva**, y cómo comprobarlo. Sin esa línea el agente no sabe qué mirar y prueba lo equivocado. Ejemplos: "el precio del plan para 10 usuarios en la página oficial de precios, no en una nota"; "que la plataforma pague a productores en Argentina y en qué moneda, según su centro de ayuda"; "cuántos alumnos tuvo el lanzamiento según el propio productor, no según un tercero".

## Las reglas (copialas enteras en cada prompt de investigación; vos también las seguís)

```
1. Fuente original, leída entera: el sitio oficial, la página de precios oficial, los términos y el centro de ayuda, el informe del organismo, el perfil o la tienda real del competidor, el video de quien lo hace. Blogs, notas de prensa y revendedores solo sirven para encontrarla.
2. Lo que sostiene la respuesta, lo abrís. Dejar "a verificar" algo decisivo que podías abrir no es una entrega.
3. Comprobá lo que vas a recomendar y el dato que decide ({dato que decide}) en la fuente misma: la fila de la tabla de precios, el párrafo de los términos, la página del producto. No en un resumen.
4. Desconfiá de tu memoria: cada precio o dato con la fecha de la fuente. Los precios cambian seguido.
5. Cada dato con link y marca [MEDIDO] / [DOCUMENTADO] / [OPINIÓN]; [VENDEDOR] si la fuente vende lo que recomienda (buscá quién la publica afuera de su propio sitio).
6. Pará cuando el dato que decide está comprobado y 3 o más fuentes originales responden, o cuando 2 búsquedas seguidas repiten lo mismo. Sin tope de búsquedas: el freno es la calidad, no el número. Cero subagentes.
7. Nada inventado. Lo que no encontrás va a "Huecos". "No hay evidencia sólida de X" es un hallazgo.
8. Buscá en inglés por defecto (ahí está la mayoría de las herramientas y la práctica), y sumá el idioma del lugar cuando el tema es local: español para Argentina y Latinoamérica, portugués para Brasil. Las búsquedas en el idioma de la fuente; la entrega, en español.
```

Para buscar y leer: `WebSearch` y `WebFetch`. Si una página no abre (pide login o bloquea), decilo y buscá otra fuente; nunca inventes lo que diría.

## Tamaño

| Tamaño | Cuándo | Cómo |
|---|---|---|
| **Uno** (por defecto) | casi todo: "¿cuánto cuesta X?", "¿qué herramienta uso?", "¿cómo lo hace tal competidor?" | 1 agente con las reglas; si es un dato puntual, lo buscás vos mismo |
| **Partes** | 2 o más partes **independientes** (dos competidores, Argentina y Brasil, dos proveedores) | 1 agente por parte, en paralelo |
| **Censo** | la pregunta pide números de muchos casos ("cuánto cobran 50 agencias", "qué precio tienen 100 cursos del rubro") | muchos casos → control al azar → a fondo: ver §Censo |
| **Grande** | decisión cara de deshacer (plata, contratar, cambiar de proveedor) o tema amplio | rondas: primero amplio, después preguntas dirigidas a los huecos, verificador al final. Seguí solo entre rondas; mostrale al usuario lo encontrado sin frenar a esperar un OK |

- Repartir en varios agentes solo rinde si las partes son independientes; si una depende de la otra, más agentes empeoran el resultado.
- Todos los agentes con la herramienta `Agent`, `subagent_type: "general-purpose"` y **`model: "sonnet"` escrito siempre**. La síntesis y el cruce con el negocio los hacés vos.
- Prompts listos en `reference/prompts.md`.

## Censo: muchos casos primero, los que importan después

Solo cuando la pregunta lo pide (decidir con números de muchos casos). Lo demás de la skill no cambia.

1. **Columnas antes de buscar**, cada fila con `url` y `fecha_observada`. Ejemplo para agencias: nombre, país, servicios, precio publicado, modelo de cobro (fijo / porcentaje / mixto), url.
2. **Muchos casos, 50-200 filas a un CSV:** uno o varios agentes `sonnet` con el prompt "Censo: recolector" de `reference/prompts.md`. Un archivo CSV por tabla, en `notas/AAAA-MM-DD-<tema>/`.
3. **Control al azar:** volvé a abrir ~10% de las filas, elegidas al azar (no las que te parecen raras). Si falla más de 1 de cada 4, la tabla se rehace.
4. **A fondo:** el método de siempre sobre los 5-10 casos que más se parecen a lo que se va a decidir. **La tabla sola no alcanza para decidir:** la mirada a fondo encuentra lo que la tabla aplana (niveles de precio que faltan, un precio en dólares anotado como pesos).

## Videos: una lista grande, después el filtro

En preguntas de **práctica** ("cómo lo hacen los que lo hacen", lanzamientos, embudos, herramientas, ventas), un video de alguien mostrando su trabajo **es** fuente original, y muchas veces lo mejor que hay. No esperes a que te pasen links: buscalos.

Necesita `yt-dlp` (si falta: `python -m pip install --user yt-dlp`). Los scripts ya lo llaman bien; si alguna vez lo usás a mano, siempre como `python -m yt_dlp`, nunca `yt-dlp` a secas (no está en el PATH). Si no se puede instalar, saltá esta parte y decilo en "Huecos".

1. **Lista grande:** `python .claude/skills/investigar/scripts/find_videos.py "búsqueda 1" ... "búsqueda 7"`, con 5-8 búsquedas generales del tema, en inglés y también en español o portugués si el tema es de Latinoamérica. Devuelve 50-250 candidatos de los últimos 24 meses, sin shorts, ordenados por señal (vistas por día y vistas por suscriptor).
2. **Filtro (lo hacés vos):** elegí 6-10 leyendo títulos y canales, no solo el puntaje. Priorizá a quien muestra su proceso o un caso real por encima de las listas de "10 tips", y marcá [VENDEDOR] si vende un curso o tiene un sponsor de lo que recomienda.
3. **Subtítulos:** `python .claude/skills/investigar/scripts/get-transcript.py "<URL>"` (los guarda en una carpeta temporal y te dice dónde). Si YouTube bloquea (error 429), esperá unos minutos o probá `WebFetch` sobre la URL y anotá que fue de respaldo. Si son muchos videos, un agente `sonnet` cada 2-3 videos, que devuelva **solo lo aplicable, con su minuto `[m:ss]`**, no un resumen.

## Dónde buscar, según el tema

- **Precios y competencia:** el sitio del competidor y su página de precios, su Instagram o su página de ventas, MercadoLibre si vende ahí; siempre con link y fecha. Nunca porcentajes genéricos sacados de notas.
- **Plataformas y proveedores** (de cursos, pagos, email, WhatsApp, anuncios): la página de precios oficial, los términos y el centro de ayuda. Los revendedores y "partners" son [VENDEDOR] y suelen cobrar más que el original.
- **Mercado:** un "estudio de mercado" de una consultora que vende el servicio es [VENDEDOR]. Un tamaño de mercado sin explicar cómo se calculó, se descarta. Datos oficiales (INDEC, Banco Central, organismos de Brasil), por link al documento.
- **Cómo lo hacen los mejores:** el propio material del que lo hace (su video, su página de ventas, su entrevista), no lo que otro dice de él.

## Después de la primera pasada

- **Repreguntá una vez sobre lo leído:** contradicciones, la fuente que se citó y nadie abrió. Rinde más que sumar agentes al principio.
- Antes de entregar, abrí vos mismo 1-2 datos clave. Si dos fuentes se contradicen en un número, resolvelo en la original.
- **Verificador** (`reference/prompts.md`): solo en tamaño Grande o si el usuario lo pide. Vuelve a abrir las fuentes de las 10-20 afirmaciones que sostienen la conclusión.

## Resultado

**El producto es qué cambia para el negocio, no el resumen.** Antes de escribir, leé el archivo del proyecto o área que corresponde (según el mapa) y, si aplica, el cliente (`empresa/clientes/<cliente>.md`), el proyecto (`proyectos/<nombre>.md`) y `decisiones.md`: si lo que encontraste contradice algo ya decidido, eso va arriba.

Guardalo en **`notas/AAAA-MM-DD-<tema>.md`** (fecha de hoy, tema corto con guiones, ej. `notas/2026-11-25-precios-agencias-lanzamiento.md`). Las notas de los agentes y los CSV, en una carpeta con el mismo nombre: `notas/AAAA-MM-DD-<tema>/`.

```markdown
# {Tema} ({fecha})
**Respuesta:** {1-3 líneas, en palabras simples}
**Para el negocio:** {qué cambia, qué contradice algo ya decidido, próximo paso concreto}
## Evidencia      (afirmación · fuente con link · marca)
## Huecos         (lo que no se encontró o no se pudo abrir)
## Costo          (tamaño, cuántos agentes, cuántas búsquedas)
```

En el chat: la respuesta y qué cambia para el negocio en 5 líneas como mucho, dónde quedó guardado y **un** próximo paso.

## Relación con otras skills

- **`/roast`** ataca la conclusión cuando la decisión es cara.
- **`/video`** (si está activada) es para un video puntual que el usuario ya tiene.
