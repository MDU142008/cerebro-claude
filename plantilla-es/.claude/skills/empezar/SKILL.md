---
name: empezar
description: >-
  Día 1 del cerebro: una charla larga para conocer a la persona (quién es, qué hace, qué tiene que guardar y de dónde le llega la información) y, con eso, proponerle un AIOS hecho a su medida (carpetas, archivos, conexiones) y armarlo con su sí. Usar la primera vez (cuando CLAUDE.md dice "(sin completar)") o para rediseñar el cerebro. Se puede volver a correr: retoma lo que ya está. Triggers (ES/PT): /empezar, "empecemos", "armá mi cerebro", "set me up", "onboard me", "conoceme", "configurame", "rediseñemos mi cerebro", "vamos começar", "monta meu cérebro", "me conhece".
---

# Empezar: tu AIOS desde cero

> *Adaptado del `/onboard` del kit AIS-OS de Nate Herk (MIT) y de The Three Ms of AI™. © 2026 Nate Herk. The Three Ms of AI™ es marca de Nate Herk.* La forma de preguntar (rondas con recomendación) viene del método *grill-me* de Matt Pocock (github.com/mattpocock/skills, MIT).

Armás el sistema operativo de IA (AIOS) de esta persona. No hay estructura de antemano: **sale de lo que ella cuenta**. Ella decide; vos preguntás, proponés y armás.

**El AIOS es de la persona, y GUES es su eje.** Es dueño de GUES y va a estar centrado en eso: la propuesta pone a GUES en el centro (sus clientes, su equipo, sus procesos, sus números, sus decisiones). Pero no es lo único: entra también lo demás que le importe (otros negocios, plata, salud, familia, aprendizaje, ideas). La charla arranca por la persona y llega rápido, y a fondo, a GUES.

## Cómo se charla

- **Es una conversación, no un formulario.** Hablá como un socio curioso que quiere entender de verdad: comentá lo que te cuenta, repreguntá, pedí ejemplos ("¿cómo fue la última vez?"), seguí el hilo que abre. Muchas preguntas, sin apuro y sin tope: seguí hasta que puedas describir su trabajo mejor que ella.
- **De a pocas por vez** (1 a 3 por mensaje), en el orden en que salen naturalmente. Cuando hay una decisión de diseño (no un dato de su vida), usá el formato de rondas: `❓ **P1 - título**: la pregunta` y debajo `➡️ tu recomendación y su porqué`, para que conteste "sí", "no" u "otra cosa".
- **Todo en el idioma del sistema** (el que dice `CLAUDE.md`): la charla, los archivos, los nombres de carpetas. Si la persona escribe en otro idioma, contestale en ese, pero los archivos siguen en el idioma del sistema.
- **Los datos los buscás vos.** Lo que se pueda mirar (qué conectores tiene con `/mcp`, sus archivos, su calendario o sus mails si están conectados), miralo en lugar de preguntarlo, y contale qué viste.
- **Si dice que sí a todo, frená:** "¿eso es lo que querés vos o lo que te propuse yo? Este sistema es tuyo."
- **Guardá a medida que avanza:** anotá lo que cuenta en `notas/AAAA-MM-DD-empezar.md` mientras hablan, así se puede cortar y retomar. Si ya existe, leelo y seguí desde donde quedó.

Al arrancar, en 3 líneas: "Vamos a armar tu sistema de IA. Primero quiero conocerte bien: quién sos, qué hacés y qué tenés que tener a mano. Después te propongo cómo organizarlo, a tu medida, y lo armamos cuando me digas que sí. Contestá como te salga."

## Qué tenés que llegar a entender

No es una lista para leer en orden: son los temas que la charla tiene que cubrir. Profundizá donde haya más.

### 1. Quién es
Su vida, no solo su cargo: qué hace, a qué se dedica (puede tener más de un negocio o actividad), su historia, qué le importa, cómo es su semana, qué idiomas usa y con quién. Sus **áreas** (GUES primero; después plata, salud, familia, estudio, hobbies: las que él nombre) y los **proyectos** dentro de cada una. Arrancá por la persona con 2 o 3 preguntas y pasá enseguida a GUES.

### 2. Qué hace
**GUES a fondo** (es la parte más larga de la charla): qué vende y a quién, cómo gana plata, cada cliente, el equipo y quién hace qué, cómo se reparte el trabajo con su socio, los procesos que se repiten, las herramientas, los números que mira. Después, cada otra cosa en la que trabaja, en concreto: qué produce, para quién, con quién, cómo sabe si le va bien, qué decide y qué delega, qué le come el tiempo. Para cada actividad, que te cuente un ejemplo real. Sus clientes, su equipo, sus socios y proveedores: quiénes son y qué tiene que saber de cada uno.

### 3. Qué tiene que guardar
Qué querría que su AIOS sepa siempre sin que se lo repita: datos de la empresa y de los clientes, decisiones y por qué las tomó, procesos ("cómo hacemos X"), precios y números, contactos, ideas, reuniones, documentos, aprendizajes, su forma de escribir. Preguntá por qué cosas se le olvidan, qué le preguntan siempre a él y qué busca seguido. **Todo lo que quiera entra**: no recortes "para empezar".

### 4. De dónde le llega la información, y cómo se conecta
Para cada fuente (mail, calendario, WhatsApp, ClickUp, Drive, planillas, Hotmart, ActiveCampaign, Discord, grabaciones de reuniones, banco, la que sea): qué hay ahí, cuánto la usa y si querría que Claude la lea, la escriba o las dos. Y **explicale en una línea cómo se conectaría**:
- **Conector de claude.ai** (lo más simple: se activa en claude.ai → Configuración → Conectores y aparece solo acá). Hoy existen, por ejemplo, Gmail, Google Calendar, Google Drive y ClickUp. Fijate con `/mcp` cuáles ya tiene.
- **MCP** (un programa que le da a Claude acceso a una herramienta; algunos se instalan con un comando, como el de Windows que ya tiene).
- **Script o API** (Claude escribe un programa chico que usa la API de la herramienta con una clave que la persona guarda en su compu; sirve cuando no hay conector).
- **A mano** (pegar o exportar un archivo), mientras tanto.
Si no sabés si una herramienta tiene conector, MCP o API, buscalo antes de responder. **No conectes nada todavía**: queda anotado en el plan.

### 5. Cómo quiere trabajar con Claude
Cómo le gustan las respuestas, qué le molesta de una IA, qué decide solo y qué con su socio, qué no se hace nunca sin preguntarle (las reglas fijas de `CLAUDE.md` ya están: mandar, borrar, gastar plata, contraseñas). Si escribe mucho (mails, posts, mensajes), pedile que **pegue** 1 o 2 textos reales suyos, sin editar, para que Claude copie su forma de escribir.

## Proponer el AIOS a medida

Cuando entiendas los 5 temas, armá **una propuesta propia para esta persona**, no una plantilla. Mostrala en una pantalla:

- **El mapa de carpetas y archivos** (en árbol), pensado para cómo vive y trabaja ella: con GUES en el centro (lo más desarrollado del mapa) y sus otras áreas y proyectos alrededor. Por ejemplo, alguien que vive en reuniones puede tener una carpeta por cliente con sus reuniones; alguien que maneja varios negocios, una por negocio. Explicá en una línea por qué cada carpeta.
- **Qué va en `CLAUDE.md`** (lo que Claude lee siempre) y qué va en archivos aparte (lo que lee cuando hace falta).
- **Las conexiones** priorizadas: cuáles se hacen ya con conector, cuáles después con MCP o script.
- **Las herramientas**: cuáles de las activas (`.claude/skills/`) y de las guardadas (`extras/`) le sirven, y cuáles nuevas convendría crear más adelante (con `/herramientas`).

Preguntá: **"¿Lo armamos así? ¿Qué cambiarías?"** Ajustá hasta que diga que sí. No escribas nada antes.

## Armarlo (después del sí)

1. Creá las carpetas y archivos de la propuesta, ya llenos con lo que contó (en sus palabras), no vacíos.
2. `CLAUDE.md`: reemplazá todo lo que dice "(lo completa /empezar)" y el "(sin completar)" del título. La sección **"Dónde está cada cosa"** pasa a ser el mapa real de su AIOS: las demás herramientas lo usan para saber dónde guardar y buscar.
3. `conexiones.md`: una fila por fuente (qué es, cómo se conecta, estado: "conectado", "por conectar con conector", "por conectar con MCP/script", "a mano").
4. Si pegó textos suyos: `references/mi-forma-de-escribir.md`, con los textos tal cual.
5. `decisiones.md`: agregá `## AAAA-MM-DD — Diseño de mi AIOS` con lo que se decidió y por qué.
6. Herramientas: activá las que eligió (mover de `extras/` a `.claude/skills/`; avisale que Claude Code le va a pedir permiso para tocar `.claude` y que diga que sí).
7. Hacé `/cierre`, que guarda la primera foto.

## Al terminar (3 líneas)

1. "Listo: tu AIOS sabe quién sos, qué hacés y dónde está cada cosa." Mostrale su `CLAUDE.md` y que corrija una cosa.
2. "Probá ahora: preguntame **¿en qué me enfoco esta semana?**" Cuando lo haga, contestá solo con lo que hay en sus archivos: 3 puntos, el primero con su porqué, y cerrá con: *"¿Dónde podría entrar la IA acá? ¿Hasta qué punto se puede apoyar en ella para esto?"* (el *Default Shift* de los 3Ms).
3. "Mañana: conectamos la primera fuente de `conexiones.md`. En una semana: `/mantenimiento`, para ver cómo está armado tu AIOS y qué le falta."
