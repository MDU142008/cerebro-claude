#!/usr/bin/env python3
"""Baja los subtitulos de un video de YouTube o Vimeo y los escribe como texto
con marcas de tiempo. NO descarga el video.

Uso:  python get-transcript.py <URL> [--out CARPETA] [--lang es]
Salida: <CARPETA>/<id-del-video>-transcript.md  +  un resumen en pantalla.
Por defecto la carpeta es una temporal de Windows (no ensucia tus archivos).

Necesita yt-dlp:  python -m pip install --user yt-dlp
"""
import argparse
import html
import os
import re
import sys
import tempfile
import xml.etree.ElementTree as ET

try:
    from yt_dlp import YoutubeDL
except ImportError:
    sys.exit("falta yt-dlp. Instalalo con:  python -m pip install --user yt-dlp")

PREFERRED = ["es", "pt", "en"]


def pick_track(info, forced=None):
    """Devuelve (idioma, url, es_automatico). Prioriza subtitulos hechos a mano
    sobre los automaticos, y dentro de cada grupo el idioma original del video."""
    manual = info.get("subtitles") or {}
    auto = info.get("automatic_captions") or {}
    orig = (info.get("language") or "").split("-")[0]
    order = ([forced] if forced else []) + ([orig] if orig else []) + PREFERRED

    for source, is_auto in ((manual, False), (auto, True)):
        for want in order:
            if not want:
                continue
            # exacto ('es'), original ('es-orig'), regional ('es-419'), pero NO
            # traducciones automaticas, que en YouTube vienen como 'es-en'.
            cands = [k for k in source
                     if k == want or k == f"{want}-orig"
                     or (k.startswith(f"{want}-") and not re.fullmatch(rf"{want}-[a-z]{{2}}", k))]
            if not cands:
                continue
            key = min(cands, key=lambda k: (0 if k.endswith("-orig") else 1, len(k)))
            fmts = source[key]
            fmt = next((f for f in fmts if f.get("ext") == "srv1"), None) or fmts[0]
            return key, fmt["url"], is_auto
    return None, None, None


def parse_srv1(raw):
    """srv1 es XML simple: <text start="0.0" dur="1.2">linea</text>."""
    root = ET.fromstring(raw)
    out = []
    for node in root.iter("text"):
        txt = html.unescape(html.unescape(node.text or "")).strip()
        txt = re.sub(r"\s+", " ", txt)
        if txt:
            out.append((float(node.get("start", 0)), txt))
    return out


def parse_vtt(raw):
    """Respaldo para Vimeo y otros que dan .vtt: saca tiempos y texto, sin repetidos."""
    out, last = [], None
    blocks = re.split(r"\n\s*\n", raw.replace("\r", ""))
    for b in blocks:
        m = re.search(r"(\d+:)?(\d{1,2}):(\d{2})[.,](\d{3})\s*-->", b)
        if not m:
            continue
        h = int((m.group(1) or "0:")[:-1])
        start = h * 3600 + int(m.group(2)) * 60 + int(m.group(3))
        lines = [l for l in b.split("\n") if "-->" not in l and l.strip() and not l.strip().isdigit()]
        txt = re.sub(r"<[^>]+>", "", " ".join(lines))
        txt = re.sub(r"\s+", " ", html.unescape(txt)).strip()
        if txt and txt != last:
            out.append((float(start), txt))
            last = txt
    return out


def to_markdown(info, cues, lang, is_auto):
    def stamp(sec):
        h, rem = divmod(int(sec), 3600)
        m, s = divmod(rem, 60)
        return f"{h}:{m:02d}:{s:02d}" if h else f"{m}:{s:02d}"

    dur = info.get("duration") or 0
    head = [
        f"# {info.get('title', 'sin titulo')}",
        "",
        f"- **Canal:** {info.get('uploader', '?')}",
        f"- **URL:** {info.get('webpage_url', '')}",
        f"- **Duracion:** {stamp(dur)}",
        f"- **Subtitulos:** `{lang}` ({'automaticos' if is_auto else 'hechos a mano'})",
        "",
        "---",
        "",
    ]

    body, buf, buf_start = [], [], None
    for start, txt in cues:
        if buf_start is None:
            buf_start = start
        buf.append(txt)
        if sum(len(t) for t in buf) > 450:
            body.append(f"**[{stamp(buf_start)}]** " + " ".join(buf))
            buf, buf_start = [], None
    if buf:
        body.append(f"**[{stamp(buf_start)}]** " + " ".join(buf))

    return "\n".join(head) + "\n\n".join(body) + "\n"


def main():
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    except AttributeError:
        pass
    ap = argparse.ArgumentParser()
    ap.add_argument("url")
    ap.add_argument("--out", default=os.path.join(tempfile.gettempdir(), "claude-videos"),
                    help="carpeta de salida (por defecto, una temporal)")
    ap.add_argument("--lang", default=None, help="forzar idioma, ej: es")
    args = ap.parse_args()

    ydl = YoutubeDL({"quiet": True, "no_warnings": True, "skip_download": True})
    info = ydl.extract_info(args.url, download=False)

    lang, url, is_auto = pick_track(info, args.lang)
    if not url:
        sys.exit(f"este video no tiene subtitulos disponibles: {info.get('title')}")

    raw = ydl.urlopen(url).read().decode("utf-8", "replace")
    if raw.lstrip().startswith("<"):
        cues = parse_srv1(raw)
    else:
        cues = parse_vtt(raw)
    if not cues:
        sys.exit("no se pudieron leer los subtitulos (formato inesperado)")

    md = to_markdown(info, cues, lang, is_auto)
    os.makedirs(args.out, exist_ok=True)
    path = os.path.join(args.out, f"{info['id']}-transcript.md")
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(md)

    print(f"OK  {info.get('title')}")
    print(f"    canal: {info.get('uploader')}  |  {len(cues)} lineas  |  ~{len(md.split())} palabras")
    print(f"    idioma: {lang} ({'automaticos' if is_auto else 'hechos a mano'})")
    print(f"    {path}")


if __name__ == "__main__":
    main()
