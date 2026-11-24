---
name: innovar
description: >-
  Usala cuando querés un ángulo nuevo para un problema del negocio mirando cómo lo resuelven OTROS rubros (hotelería, gimnasios, suscripciones, eventos, lo que sea que tenga la misma estructura), con búsqueda web real; devuelve 2-3 ideas concretas para trasladar, con fuente, y recomienda una. No es para armar una idea desde cero ni para atacarla (eso es /roast). Triggers (ES): /innovar, "cruzá rubros", "cómo resuelven esto en otros rubros", "traeme ideas de afuera", "esto necesita un ángulo nuevo", "qué hacen otras industrias con esto". Triggers (PT): "cruza setores", "como outros setores resolvem isso", "me traz ideias de fora", "isso precisa de um ângulo novo", "o que outras indústrias fazem com isso".
---

# Innovar

> **Dónde guardar y buscar:** usá el mapa "Dónde está cada cosa" de `CLAUDE.md`. Las rutas de abajo (`empresa/…`, `proyectos/…`, `notas/…`) son ejemplos: si el mapa dice otra cosa, vale el mapa. Si no hay lugar para algo, proponé uno y usá `notas/` mientras tanto.

## De qué se trata

Varios investigadores (subagentes en paralelo) buscan en la web cómo rubros ajenos resuelven un problema con la misma estructura que el tuyo, y al final vos traducís eso al negocio y devolvés 2-3 ideas concretas, recomendando una. **La variedad sale del MATERIAL, no del rol:** cinco agentes con "sombreros" distintos son el mismo modelo con los mismos sesgos; lo que los hace distintos es que cada uno lea sobre un rubro distinto.

**La señal es la idea rara con fuente, no lo que todos repiten** (excepción: si dos rubros llegan a lo mismo y las fuentes lo confirman, eso es fuerte; ver paso 2). Prohibido "promediar": cada idea se presenta como la trajo su investigador, con su rubro y su fuente.

**La idea cruzada no es el producto: la mejor jugada lo es.** Si lo que gana es la práctica normal del rubro (sobre todo si el usuario no la está haciendo), el resultado lo dice PRIMERO: "acá no innoves: hacé X". Inventar un cruce para justificar la corrida es hacer teatro.

## Cuándo usarla y cuándo no

- **Sí:** un problema real con ESTRUCTURA (un proceso, incentivos, cómo se mueve la plata o la gente) donde lo normal del rubro no alcanza o se busca un ángulo nuevo. Ej.: "los alumnos compran el curso y no lo terminan", "el cliente nos llama solo para el lanzamiento y después desaparece".
- **No:** para armar una idea desde cero (charla normal); para atacar algo ya armado (`/roast`); para decisiones de gusto o nombres (no hay mecanismo que trasladar); para preguntas de datos (`/investigar`).

## El proceso

### Paso 0 — Abstraer y elegir rubros (lo hacés vos, barato) — OBLIGATORIO

> El cruce es tan bueno como la abstracción. Si mandás el problema crudo salen analogías de superficie ("hotelería → programa de puntos"). Y si no la escribís, cada investigador abstrae a su manera con el MISMO cerebro, y se parecen todos.

1. **Llevá el problema a su forma estructural.** No "cómo consigo más alumnos" sino "cómo convertís compradores de una sola vez en recurrentes cuando el producto se consume una sola vez". Una o dos frases, sin el rubro adentro. Si ayuda, leé el archivo del proyecto o área que corresponde (según el mapa), el cliente (`empresa/clientes/<cliente>.md`) o el proyecto (`proyectos/<nombre>.md`).
2. **Anotá cómo lo resuelve hoy el rubro** (lanzamientos digitales, infoproductos): por lo que cuenta el usuario o con 1 búsqueda rápida. Es la línea de base para después decir "esto ya se usa acá". Si la línea de base sola ya resuelve el problema y el usuario no la está haciendo, decilo en el punto de control: capaz acá no hay que innovar.
3. **Elegí 5 rubros a partir de la abstracción** ("¿qué otros rubros tienen esta misma estructura?"): 2 cercanos, 2 a media distancia, 1 lejano (la distancia media suele dar lo mejor; el lejano es la apuesta). Solo rubros con información pública que se pueda buscar.
4. **PUNTO DE CONTROL — mostrale al usuario y esperá su OK:** la abstracción, la línea de base y los 5 rubros. Puede vetar, cambiar o sumar. 30 segundos acá salvan toda la corrida.

### Paso 1 — Investigadores (uno por rubro aprobado, en paralelo)

Con la herramienta `Agent`, todos en un solo mensaje, sin ver lo que hacen los otros: `subagent_type: "general-purpose"` y **`model: "sonnet"` escrito siempre**.

Prompt por investigador (reemplazá `[RUBRO]` y `[ABSTRACCIÓN]`):

```
Investigás cómo el rubro de [RUBRO] resuelve este problema:

[ABSTRACCIÓN]

REGLAS:
- BUSCÁ EN LA WEB DE VERDAD, es obligatorio: WebSearch y WebFetch. NO respondas de memoria: un mecanismo sin fuente real no sirve y se descarta.
- Traé 1-2 MECANISMOS concretos: CÓMO funcionan, qué aprovechan. No la etiqueta ("usan gamificación" no vale; "dan un premio sorpresa cada tantas visitas porque Y" sí).
- Por cada mecanismo: (a) cómo funciona, concreto; (b) la CONDICIÓN que lo hace funcionar: qué tiene ese rubro para que ande; (c) fuente con link; (d) un ejemplo real de quién lo usa.
- Desconfiá de tus propias fuentes: marcá qué tan sólida es cada una. Priorizá la fuente original o la de alguien que trabaja en ese rubro; las notas de marketing tipo "10 estrategias" NO cuentan como fuente.
- No lo traduzcas al problema original ni recomiendes nada: tu entrega es el material crudo del rubro.
- Cero subagentes.

DEVOLVÉ corto: por cada mecanismo, los 4 puntos. Tu texto final ES tu entrega.
```

### Paso 2 — Traducir al negocio (lo hacés vos, sin agentes)

- **Traducí cada mecanismo al problema real** (acá sí, con todo el contexto del usuario): ¿qué sería esto acá, concreto?
- **Chequeá la condición que lo hace funcionar:** ¿se cumple en el caso del usuario? Si no se cumple, la idea muere ahí (el error clásico: copiar algo que solo funciona con miles de clientes cuando tenés veinte). Decilo en una línea, sin maquillarlo.
- **PROHIBIDO MEZCLAR:** nada de licuar mecanismos en una recomendación tibia. Cada idea mantiene su rubro, su mecanismo y su fuente.
- **Si dos rubros llegan a lo mismo, no lo descartes: chequealo contra las fuentes.** Abrí cada fuente citada (`WebFetch`) y confirmá que el mecanismo esté EN la fuente, no solo en el resumen del investigador. ¿Está en las fuentes de ambos? Candidata FUERTE. ¿Solo en los resúmenes? Es el modelo repitiendo lo que ya sabía: afuera.

### Paso 3 — ¿Ya existe en el rubro? (1 búsqueda por idea)

Por cada idea viva: **¿alguien del rubro del usuario ya hace esto?** Con una búsqueda real, no con opinión.

- Si ya se usa en el rubro, NO es innovación. Si es una buena práctica que el usuario no hace, va en su línea del resultado; nunca se descarta en silencio.
- Si no aparece, es candidata.

### Paso 4 — Entrega

2-3 ideas como mucho y **recomendás UNA** con el porqué (nunca un menú parejo). El usuario elige.

Antes de entregar, **abrí la fuente de la RECOMENDADA y de cada ALTERNATIVA** (`WebFetch`) y confirmá que el mecanismo esté EN la fuente. Si la fuente NO lo respalda, esa idea muere (a DESCARTADAS con la causa "la fuente no lo respalda") y subís la alternativa que sí se verificó.

Si no queda ninguna idea viva: sin bloque RECOMENDADA, entregás "no hay cruce que aguante: <la mejor jugada>" + DESCARTADAS completas. Nunca revivas una idea muerta para llenar el formato.

Si lo que gana es lo normal del rubro, el resultado arranca con eso ("acá no innoves: hacé X") y las ideas cruzadas quedan abajo. Una idea que va en serio a hacerse puede pasar después por `/roast` (solo la elegida); si su "primer paso barato" cuesta menos que un roast, probala directo.

## Resultado (formato fijo)

```
Innovar: <problema>

ABSTRACCIÓN USADA: <la forma estructural>

RECOMENDADA — <rubro> → <mecanismo>
  Cómo funciona allá:     <2-3 líneas + fuente con link>
  Qué sería acá:          <la traducción concreta al negocio>
  Qué la hace funcionar:  <la condición y por qué se cumple acá>
  Primer paso barato:     <qué probar en 48 h sin invertir>
  Por qué esta:           <1 línea>

ALTERNATIVA — <mismo formato, 1-2 más>

YA EXISTE EN TU RUBRO (no es innovación, pero no lo estás haciendo): <si aplica, 1 línea cada una>
DESCARTADAS: <rubro → mecanismo → por qué murió (no se cumple la condición / el modelo repitiendo / ya es práctica del rubro / la fuente no lo respalda), 1 línea cada una>
```

Solo lectura: no escribas nada por tu cuenta. Al final ofrecé anotar la idea elegida al final de `decisiones.md` (solo se agrega abajo, nunca se borra) o guardar el resultado en `notas/AAAA-MM-DD-innovar-<tema>.md`.

## Señales de alarma — FRENÁ

- Lanzaste los investigadores sin el OK del usuario a la abstracción y los rubros → pará y hacelo.
- Un investigador trajo mecanismos sin fuente → no entran; o consigue el link o se caen.
- Descartaste una coincidencia entre rubros sin chequear las fuentes → podés estar tirando la mejor idea.
- Mezclaste dos mecanismos "para redondear" → eso es promediar; presentalos separados.
- Una idea llegó al resultado sin chequear la condición que la hace funcionar → volvé al paso 2.
- Sacaste en silencio un "esto ya se usa en el rubro" → va visible en su línea.
- Entregaste una idea floja cuando la práctica normal era la jugada → decí "hacé lo normal" arriba de todo.
- Lanzaste un agente sin `model:` escrito → ponelo siempre (`"sonnet"`).
