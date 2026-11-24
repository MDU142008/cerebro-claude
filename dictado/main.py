"""voice-dictation v4 — toggle dictado -> Groq Whisper -> paste.

Overlay premium en Qt (HTML/CSS: glow real, vidrio, 60fps) — overlay.html.
Ctrl+Win una vez = grabar; Ctrl+Win de nuevo = cortar y pegar. Salir: icono -> Salir.
"""
import io
import os
import threading
import time
import wave

import numpy as np
import pyperclip
import pystray
import sounddevice as sd
from dotenv import load_dotenv
from groq import Groq
from PIL import Image, ImageDraw
from pynput import keyboard

os.environ.setdefault("QTWEBENGINE_CHROMIUM_FLAGS", "--enable-transparent-visuals")

from PySide6.QtCore import Qt, QTimer, QUrl
from PySide6.QtWidgets import QApplication
from PySide6.QtWebEngineWidgets import QWebEngineView

HERE = os.path.dirname(os.path.abspath(__file__))
HTML_PATH = os.path.join(HERE, "overlay.html")

# --- Config ---
# La clave de Groq vive en .env (al lado de este archivo, nunca en un repo).
# El idioma y las palabras frecuentes viven en config.json (lo crea el instalador).
load_dotenv(os.path.join(HERE, ".env"))
GROQ_API_KEY = os.environ.get("GROQ_API_KEY", "").strip()
MODEL = "whisper-large-v3"
_cfg = {}
try:
    import json
    with open(os.path.join(HERE, "config.json"), encoding="utf-8") as _f:
        _cfg = json.load(_f)
except Exception:
    _cfg = {}
LANGUAGE = _cfg.get("idioma", "es")
# El prompt sesga a Whisper hacia el vocabulario real de la persona: sin esto,
# los terminos en ingles o de nicho se decodifican como la palabra mas parecida.
# Tope de Whisper: ~224 tokens; lo que sobra se ignora en silencio.
_BASE = {
    "es": "Dictado en espanol sobre negocios, marketing digital y lanzamientos. ",
    "pt": "Ditado em portugues do Brasil sobre negocios, marketing digital e lancamentos. ",
}
_TERMINOS = ("Terminos frecuentes: Claude, Claude Code, CLAUDE.md, GUES, Hotmart, "
             "ActiveCampaign, ClickUp, Discord, WhatsApp, Google Drive, Gmail, "
             "lanzamiento, webinar, captura, checkout, upsell, lead, funnel, "
             "trafego, copy, VSL, Meta Ads, GTM, KPI, prompt, skill. ")
PROMPT = _BASE.get(LANGUAGE, _BASE["es"]) + _TERMINOS + _cfg.get("palabras", "")
SAMPLE_RATE = 16000
CHANNELS = 1
MIN_DURATION_S = 0.4
MIN_RMS = 250
CLIPBOARD_RESTORE_DELAY = 0.4
IDLE_TITLE = "voice-dictation — Ctrl+Win para dictar"
OVERLAY_W, OVERLAY_H = 320, 150

if not GROQ_API_KEY:
    raise SystemExit("Falta GROQ_API_KEY en el archivo .env del dictado (pedile a Claude que te ayude a guardarla)")

client = Groq(api_key=GROQ_API_KEY)
kbd = keyboard.Controller()

tray = None
overlay = None

# --- Estado (compartido entre threads) ---
_frames = []
_recording = False
_stream = None
_lock = threading.Lock()
_level = 0.0            # 0..1, lo lee el overlay
_ui_state = "idle"     # idle | rec | busy

# --- Hotkey = Ctrl + Win ---
_pressed = set()
_combo_active = False
CTRL_KEYS = {keyboard.Key.ctrl, keyboard.Key.ctrl_l, keyboard.Key.ctrl_r}
WIN_KEYS = {keyboard.Key.cmd, keyboard.Key.cmd_l, keyboard.Key.cmd_r}


def _combo_down():
    return (any(k in _pressed for k in CTRL_KEYS)
            and any(k in _pressed for k in WIN_KEYS))


# --- Icono de la bandeja ---
_COLORS = {"idle": (90, 110, 140), "rec": (178, 92, 255), "busy": (170, 120, 255)}


def _make_icon(state):
    img = Image.new("RGB", (64, 64), (28, 28, 30))
    ImageDraw.Draw(img).ellipse([14, 14, 50, 50], fill=_COLORS[state])
    return img


def set_state(state, title):
    global _ui_state
    _ui_state = state
    if tray is not None:
        tray.icon = _make_icon(state)
        tray.title = title


# --- Audio ---
def _audio_callback(indata, frames, time_info, status):
    global _level
    _frames.append(indata.copy())
    rms = float(np.sqrt(np.mean(indata.astype(np.float64) ** 2)))
    _level = min(1.0, rms / 4000.0)


def start_recording():
    global _recording, _stream, _frames
    with _lock:
        if _recording:
            return
        _frames = []
        _recording = True
        _stream = sd.InputStream(
            samplerate=SAMPLE_RATE, channels=CHANNELS,
            dtype="int16", callback=_audio_callback,
        )
        _stream.start()
    set_state("rec", "Grabando... (Ctrl+Win para cortar)")


def stop_recording_and_transcribe():
    global _recording, _stream, _level
    with _lock:
        if not _recording:
            return
        _recording = False
        _stream.stop()
        _stream.close()
        _stream = None
        frames = list(_frames)
    _level = 0.0
    if not frames:
        set_state("idle", IDLE_TITLE)
        return
    audio = np.concatenate(frames, axis=0).flatten()
    duration = len(audio) / SAMPLE_RATE
    rms = float(np.sqrt(np.mean(audio.astype(np.float64) ** 2)))
    if duration < MIN_DURATION_S or rms < MIN_RMS:
        set_state("idle", IDLE_TITLE)
        return
    set_state("busy", "Transcribiendo...")
    try:
        text = transcribe(audio)
    except Exception as e:
        set_state("idle", "Error: " + str(e)[:50])
        return
    if text:
        paste(text)
    set_state("idle", IDLE_TITLE)


def transcribe(audio):
    buf = io.BytesIO()
    with wave.open(buf, "wb") as wf:
        wf.setnchannels(CHANNELS)
        wf.setsampwidth(2)
        wf.setframerate(SAMPLE_RATE)
        wf.writeframes(audio.tobytes())
    buf.seek(0)
    resp = client.audio.transcriptions.create(
        file=("audio.wav", buf.read()),
        model=MODEL, language=LANGUAGE, prompt=PROMPT,
        response_format="text", temperature=0.0,
    )
    text = resp if isinstance(resp, str) else getattr(resp, "text", "")
    return text.strip()


def paste(text):
    try:
        original = pyperclip.paste()
    except Exception:
        original = ""
    pyperclip.copy(text)
    time.sleep(0.05)
    with kbd.pressed(keyboard.Key.ctrl):
        kbd.press("v")
        kbd.release("v")

    def _restore():
        time.sleep(CLIPBOARD_RESTORE_DELAY)
        try:
            pyperclip.copy(original)
        except Exception:
            pass

    threading.Thread(target=_restore, daemon=True).start()


# --- Toggle ---
def toggle():
    if not _recording:
        start_recording()
    else:
        threading.Thread(target=stop_recording_and_transcribe, daemon=True).start()


def on_press(key):
    global _combo_active
    _pressed.add(key)
    if _combo_down() and not _combo_active:
        _combo_active = True
        toggle()


def on_release(key):
    global _combo_active
    _pressed.discard(key)
    if not _combo_down():
        _combo_active = False


# --- Overlay (Qt + QWebEngineView transparente, click-through) ---
class Overlay(QWebEngineView):
    def __init__(self):
        super().__init__()
        self.setWindowFlags(
            Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
            | Qt.Tool | Qt.WindowTransparentForInput
        )
        self.setAttribute(Qt.WA_TranslucentBackground, True)
        self.setAttribute(Qt.WA_ShowWithoutActivating, True)
        self.page().setBackgroundColor(Qt.transparent)
        self.resize(OVERLAY_W, OVERLAY_H)
        scr = QApplication.primaryScreen().geometry()
        self.move((scr.width() - OVERLAY_W) // 2, scr.height() - OVERLAY_H - 60)
        self.load(QUrl.fromLocalFile(HTML_PATH))


def _push():
    if _ui_state == "idle":
        if overlay.isVisible():
            overlay.hide()
    else:
        if not overlay.isVisible():
            overlay.show()
        overlay.page().runJavaScript(f"window.setLevel({_level:.3f}, '{_ui_state}')")


# --- Bandeja ---
def on_quit(icon, item):
    icon.stop()
    os._exit(0)


def _start_tray():
    global tray
    tray = pystray.Icon(
        "voice-dictation", _make_icon("idle"), IDLE_TITLE,
        menu=pystray.Menu(pystray.MenuItem("Salir", on_quit)),
    )
    tray.run()


def main():
    global overlay
    app = QApplication([])
    overlay = Overlay()

    listener = keyboard.Listener(on_press=on_press, on_release=on_release)
    listener.daemon = True
    listener.start()

    threading.Thread(target=_start_tray, daemon=True).start()

    timer = QTimer()
    timer.timeout.connect(_push)
    timer.start(33)

    app.exec()


if __name__ == "__main__":
    main()
