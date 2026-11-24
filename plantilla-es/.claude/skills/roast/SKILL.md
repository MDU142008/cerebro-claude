---
name: roast
description: >-
  Usala cuando querés que te destrocen una idea, plan, oferta, precio o decisión que ya tenés armada: un panel de críticos duros, sin chupamedias, que busca los agujeros con evidencia y te da un veredicto (matar, arreglar o lanzar). También cuando sospechás que la IA te está diciendo que sí a todo. Triggers (ES): /roast, "roasteá esto", "destrozá esto", "encontrá los agujeros", "por qué esto NO va a funcionar", "sé brutal", "matá esta idea", "criticá esta oferta". Triggers (PT): "detona essa ideia", "acha os furos", "por que isso NÃO vai funcionar", "seja brutal", "mata essa ideia", "critica essa oferta".
---

# Roast

> **Dónde guardar y buscar:** usá el mapa "Dónde está cada cosa" de `CLAUDE.md`. Las rutas de abajo (`empresa/…`, `proyectos/…`, `notas/…`) son ejemplos: si el mapa dice otra cosa, vale el mapa. Si no hay lugar para algo, proponé uno y usá `notas/` mientras tanto.

## De qué se trata

Un panel de hasta 5 críticos (subagentes en paralelo, `model: "opus"`) que pone a prueba una idea, plan, oferta o decisión que el usuario YA tiene, y devuelve un veredicto accionable. Al final, un auditor independiente revisa que el veredicto no haya suavizado nada.

**Por qué existe: para que la IA no te diga que sí a todo.** Los modelos tienden a complacer, y cuanto más conocen al usuario, más le dicen que sí. Roast está armado para lo contrario. **Por defecto, máxima crítica**, con dos reglas que la hacen honesta:
- **Con evidencia, no con tono.** Inventar problemas para *sonar* duro es tan complaciente como decir que sí. Un problema real con evidencia vale más que uno inventado con palabras filosas.
- **Sin olvidarse de lo que ya está trabajado.** Se critica todo, incluso lo que el usuario da por decidido, pero SIEMPRE marcando qué ya estaba dicho (nunca presentes lo ya trabajado como descubrimiento nuevo).

## Cuándo usarla y cuándo no

- **Sí:** antes de comprometerte con algo que ya está armado (una oferta para un cliente, un precio, un lanzamiento, una contratación); cuando sospechás que te dicen que sí de más.
- **No:** para armar una idea desde cero (eso es una charla normal); para buscar cómo resuelven el problema otros rubros (`/innovar`, si está activada); para una pregunta de datos (`/investigar`).

## El proceso

### Paso 1 — Preparar el briefing (OBLIGATORIO antes de lanzar nada; barato, sin agentes)

> Saltar este paso es la falla número uno: un briefing torcido hace que 5 críticos destrocen con total convicción algo que no es lo que el usuario planteó. **No se lanza el panel sin completar los 4 puntos.**

1. **Cargá lo que ya está escrito.** Si la idea tiene archivo (`proyectos/<nombre>.md`, el archivo del proyecto o área que corresponde (según el mapa), `empresa/clientes/<cliente>.md`) o hay algo en `decisiones.md`, leelo. Nunca de memoria. Si es una idea nueva sin archivo, seguí.
2. **Separá en dos baldes:** `DECIDIDO/RESUELTO` (lo ya cerrado y cómo se cubrieron los riesgos) y `ABIERTO` (lo que falta cerrar).
3. **Chequeá los supuestos:** los de hecho, contra lo escrito; los de interpretación, con UNA pregunta al usuario si hay duda.
4. **PUNTO DE CONTROL — mostrale al usuario y esperá su OK:** el briefing, los dos baldes, qué críticos vas a correr y **negociá el modo**: "estas soluciones me parecen frágiles, ¿las ataco o las respeto?". Por defecto se ataca todo; el usuario puede acotar.

### Paso 2 — Ronda 1: panel a ciegas (en paralelo, `model: "opus"`)

Cada bloque de `personas.md` es un **prompt completo** (ya trae adentro las reglas contra la complacencia: no las saques). Para lanzar: reemplazá `{BRIEFING}` por el briefing **neutral, sin decir de quién es** ("una apuesta de un negocio", NUNCA "la idea de [nombre]") y lanzá los que apliquen en un solo mensaje, en paralelo, con la herramienta `Agent`, `subagent_type: "general-purpose"` y `model: "opus"` escrito siempre. **Poné nombre a cada agente** (`name: "contrarian"`, `"principles"`, …): sin nombre no se lo puede retomar en la ronda 2.

Si el plan del usuario no tiene acceso a Opus, usá `model: "sonnet"` y decilo en el resultado.

**Qué críticos:** Contrarian + Principles SIEMPRE; Expansionist si hay mucho para ganar; Researcher si hay un dato comprobable o un mercado; Buyer si hay un cliente o usuario final. Para algo chico, corré solo Contrarian + Principles y fijate si alcanza antes de sumar.

**A ciegas en dos sentidos:** (a) no ven lo que dicen los otros, así opinan distinto; (b) no saben de quién es la idea, así no tienen a quién complacer.

### Paso 3 — Primera síntesis (la hacés vos, sin agentes)

- **Pesá evidencia, no seguridad ni tono.** Una afirmación muy segura sin respaldo no le gana a una con datos.
- **Verificá las anclas ANTES de pesar.** Contrarian y Principles apoyan cada golpe en un caso real o en una cuenta (ver `personas.md`). Si citan un caso, hacé 1-2 búsquedas web (`WebSearch` / `WebFetch`): ¿existió y pasó lo que dicen? Si se verifica, pesa como evidencia; si no aparece o los detalles no cierran, pesa como ESPECULATIVO (un caso inventado es peor señal que ninguno: anotalo). Si es una cuenta, rehacela vos con los números del briefing; si no cierra o usa números que no salen del briefing, ESPECULATIVO. Lo ESPECULATIVO va al resultado, marcado, nunca escondido. El resultado de cada verificación acompaña a la ronda 1 en todo lo que sigue (ronda 2 y auditor).
- **Puntuá por separado** cada dimensión (falla / techo / lógica / datos / cliente), no en bloque.
- Veredicto **MATAR / ARREGLAR / LANZAR** + acciones concretas + **marcá NUEVO vs YA SABIDO**.

### Paso 4 — Ronda 2: solo si hubo desacuerdo REAL en la ronda 1

Si los críticos coinciden, NO corras la ronda 2 (sería ruido caro). Si discrepan, cruzalos sobre el desacuerdo **retomando los MISMOS agentes de la ronda 1** (`SendMessage` al agente por su nombre, con el bloque "Ronda 2" de `personas.md`; un agente nuevo no tiene postura propia que defender y termina dándole la razón a todos). Cada uno ve lo que dijeron los otros + el resultado de la verificación, y ataca o defiende puntos concretos: en paralelo, sin buscar consenso, sin cambiar de postura por cortesía (solo por argumento). Después volvés a sintetizar.

### Paso 5 — Cuándo parar

Pará cuando lo que queda abierto deja de ser un desacuerdo de lógica (otra ronda ayuda) y pasa a ser un dato que no se sabe (ninguna ronda ayuda: buscá el dato o aceptá la apuesta). No hay ronda 3 de opinión. Si queda un dato decisivo y dudoso, buscalo (Researcher), no hagas otra ronda.

### Paso 6 — Auditoría del veredicto (sobre el veredicto final)

El único que NO está a ciegas sos **vos**: conocés al usuario, su historia y qué quiere escuchar. Ese es justo el punto donde la complacencia puede volver a entrar. Antes de entregar, lanzá un agente nuevo (`Agent`, `subagent_type: "general-purpose"`, `model: "opus"`, sin nombre del dueño ni contexto de la conversación) con los hallazgos crudos (1-2 líneas por crítico, anónimos) + tu veredicto completo, y este pedido fijo (no lo cambies):

> "Abajo van los hallazgos crudos de un panel de críticos y el veredicto que alguien escribió a partir de ellos. Revisá UNA sola cosa: ¿la etiqueta (MATAR/ARREGLAR/LANZAR) y el texto del veredicto reflejan fielmente qué tan graves son los hallazgos, o hay golpes suavizados, enterrados u omitidos? NO evalúes la idea en sí, solo si el veredicto es fiel a los hallazgos. Contestá en 2-3 líneas, concreto, citando el hallazgo puntual si encontrás algo suavizado."

- Su respuesta va **TEXTUAL** al resultado (línea AUDITORÍA). Si la resumís vos, se pierde el sentido.
- Si trae opiniones nuevas sobre la idea, quedan afuera (salvo que señale un hallazgo del panel que vos omitiste).
- Si marca algo suavizado de verdad, corregí la síntesis ANTES de entregar y decilo ("la auditoría me corrigió: …").

## Resultado (formato fijo)

```
Roast: <qué se evaluó>

VEREDICTO: MATAR / ARREGLAR / LANZAR — <una línea>

· Lo que te mata (Contrarian):   <la falla fatal> [caso verificado / cuenta / ESPECULATIVO]
· El techo (Expansionist):        <lo grande que se puede ganar>
· Lo que no cierra (Principles):  <el agujero lógico> [caso verificado / cuenta / ESPECULATIVO]
· Los datos (Researcher):         <el dato más duro + fuente con link>
· El cliente (Buyer):             <paga / no paga / qué lo frena>

QUÉ HACER AHORA: 1-3 acciones concretas
LA PRUEBA MÁS BARATA (48 h): <el experimento mínimo que prueba el supuesto
  más riesgoso ANTES de invertir más>
NÚMEROS (si es una idea de negocio): <precio aproximado · cuándo entra
  la primera plata, siendo realista>
NUEVO vs YA SABIDO: <qué es nuevo y qué ya estaba en los archivos>
AUDITORÍA (textual): <2-3 líneas>

▸ (abajo) lo que dijo cada crítico, crudo
```

Solo lectura: no escribas nada por tu cuenta. Al final ofrecé anotar el veredicto al final de `decisiones.md` (solo se agrega abajo, nunca se borra ni se edita lo anterior).

## Contra la complacencia (no se negocia)

- Los críticos corren **sin saber de quién es** la idea (paso 2).
- Por defecto, **máxima crítica**, pero **la dureza no es el producto: el problema real lo es.** No inventes fallas para cumplir con un pedido de brutalidad.
- Lo que el usuario ya invirtió (tiempo, plata) NO es razón para suavizar.

## Señales de alarma — FRENÁ

- Lanzaste el panel sin el briefing y el OK del usuario → pará y hacelo.
- Presentaste algo que ya estaba trabajado como "descubrimiento nuevo" → falta marcar nuevo vs ya sabido.
- Un crítico se ablandó porque "es del usuario" → se rompió la ceguera.
- El veredicto suena duro pero ningún golpe tiene evidencia → es dureza de cartón; volvé a pesar por evidencia.
- Usaste un caso citado sin verificarlo → verificalo o marcalo ESPECULATIVO.
- Corriste la ronda 2 sin desacuerdo real → ruido caro.
- Resumiste o recortaste la auditoría → va textual, aunque te deje mal parado. SOBRE TODO si te deja mal parado.
- Lanzaste un agente sin `model:` escrito → ponelo siempre.

## Los críticos

Ver `personas.md` (5 prompts). Contrarian + Principles siempre; Expansionist si hay mucho para ganar; Researcher si hay datos o mercado; Buyer si hay cliente.
