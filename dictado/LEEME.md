# Dictado por voz (Ctrl+Win)

Aprietás **Ctrl+Win** una vez y hablás. Lo volvés a apretar y el texto aparece pegado donde esté el cursor (en Claude, en un mail, donde sea). Usa Whisper de Groq.

- **La clave de Groq es tuya.** Creás tu cuenta en https://console.groq.com, generás una clave en "API Keys" y la guardás con `guardar-clave.ps1`. Se guarda solo en `.env`, en tu compu. Claude no la ve y no se sube a ningún lado.
- **El idioma y las palabras que más usás** están en `config.json` (`idioma`: `es` o `pt`; `palabras`: términos que querés que reconozca bien).
- **Arranca solo** al prender la compu, en la bandeja del sistema. Para salir: clic en el ícono → Salir.

Lo instala Claude (paso "Dictado" de `INSTALAR.md`). Si algo falla, pedíselo a Claude.
