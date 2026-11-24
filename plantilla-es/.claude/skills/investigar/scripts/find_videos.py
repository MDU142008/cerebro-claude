#!/usr/bin/env python3
"""Busca videos de YouTube para una investigacion: arma una lista grande de candidatos y la ordena.

Uso:
    python find_videos.py "busqueda 1" "busqueda 2" ... [--per 20] [--months 24] [--top 40] [--canal 12] [--json]

1. Una busqueda de YouTube por cada consulta (con yt-dlp, sin clave de API). Junta y saca repetidos.
2. Los canales que aparecen en 2 o mas consultas distintas se amplian con sus --canal videos recientes
   (0 lo apaga): el buscador no trae todos los videos buenos de un buen canal.
3. Filtra (ultimos --months meses, sin shorts) y ordena por senal.
Despues se bajan los subtitulos de los mejores con get-transcript.py (en esta misma carpeta).

Senal: las vistas solas premian a los canales grandes y a lo viejo. Se combinan:
  - vistas por dia desde que se publico (lo que la gente esta mirando ahora)
  - vistas / suscriptores (un video que rinde mucho mas que su canal suele ser bueno)
  - aparecer en varias consultas distintas
Los videos chicos de canales especializados NO salen arriba: por eso se muestran todos los candidatos
y se elige leyendo titulos y canales, no solo el puntaje.

Necesita yt-dlp:  python -m pip install --user yt-dlp
"""
import json
import math
import os
import subprocess
import sys
import tempfile
import time
from collections import defaultdict
from datetime import date, datetime

FIELDS = ("%(id)s\t%(channel)s\t%(channel_follower_count)s\t%(upload_date)s\t%(view_count)s"
          "\t%(duration)s\t%(title)s\t%(channel_url)s")

# Un candado por computadora: dos busquedas a la vez desde la misma conexion hacen que YouTube
# bloquee por un rato (error 429 / "confirm you're not a bot").
LOCK = os.path.join(tempfile.gettempdir(), "claude-find-videos.lock")
LOCK_STALE_S = 30 * 60
LOCK_WAIT_S = 40 * 60


def acquire_lock():
    start = time.time()
    while True:
        try:
            fd = os.open(LOCK, os.O_CREAT | os.O_EXCL | os.O_WRONLY)
            os.write(fd, str(os.getpid()).encode())
            os.close(fd)
            return
        except FileExistsError:
            try:
                if time.time() - os.path.getmtime(LOCK) > LOCK_STALE_S:
                    os.remove(LOCK)
                    continue
            except OSError:
                continue
            if time.time() - start > LOCK_WAIT_S:
                sys.exit(f"otra busqueda de videos esta corriendo hace mas de {LOCK_WAIT_S // 60} min ({LOCK})")
            print("  otra busqueda de videos esta corriendo; espero mi turno...", file=sys.stderr)
            time.sleep(20)


def release_lock():
    try:
        os.remove(LOCK)
    except OSError:
        pass


ERRORS = []


def _int(x):
    try:
        return int(float(x))
    except (TypeError, ValueError):
        return 0


def run_ytdlp(target: str, extra: list, label: str):
    # "python -m yt_dlp" funciona aunque la carpeta de programas de pip no este en el PATH.
    cmd = [sys.executable, "-m", "yt_dlp", target, "--skip-download", "--no-warnings", "--ignore-errors",
           "--print", FIELDS] + extra
    try:
        # En Windows, sin esto yt-dlp escribe en otra codificacion y un titulo raro rompe la lectura.
        env = dict(os.environ, PYTHONUTF8="1", PYTHONIOENCODING="utf-8")
        res = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8", errors="replace",
                             timeout=900, env=env)
    except subprocess.TimeoutExpired:
        ERRORS.append(f"se paso de tiempo: {label}")
        return []
    out = res.stdout or ""
    err = res.stderr or ""
    if "No module named yt_dlp" in err:
        sys.exit("falta yt-dlp. Instalalo con:  python -m pip install --user yt-dlp")
    for e in err.splitlines():
        if "ERROR" in e:
            ERRORS.append(f"{label}: {e.strip()[:160]}")
    rows = []
    for line in out.splitlines():
        p = line.split("\t")
        if len(p) != 8:
            continue
        vid, ch, subs, up, views, dur, title, curl = p
        rows.append({"id": vid, "canal": ch, "subs": _int(subs), "fecha": up, "vistas": _int(views),
                     "dur_s": _int(dur), "titulo": title, "canal_url": curl, "consultas": [label]})
    return rows


def score(v, today):
    try:
        d = datetime.strptime(v["fecha"], "%Y%m%d").date()
    except ValueError:
        return 0.0, 99999
    age = max((today - d).days, 1)
    per_day = v["vistas"] / age
    ratio = v["vistas"] / max(v["subs"], 1000)
    # logaritmo: que un video viral no tape todo; vistas/dia y proporcion pesan igual
    return round(math.log10(per_day + 1) + math.log10(ratio + 1), 2), age


def main():
    args = sys.argv[1:]
    opts = {"--per": 20, "--months": 24, "--top": 40, "--canal": 12}
    for k in list(opts):
        if k in args:
            i = args.index(k)
            opts[k] = int(args[i + 1])
            del args[i:i + 2]
    as_json = "--json" in args
    queries = [a for a in args if a != "--json"]
    if not queries:
        print(__doc__)
        sys.exit(2)
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    except AttributeError:
        pass
    today = date.today()
    acquire_lock()
    try:
        _run(queries, opts, as_json, today)
    finally:
        release_lock()


def _run(queries, opts, as_json, today):
    seen = {}
    for q in queries:
        for v in run_ytdlp(f"ytsearch{opts['--per']}:{q}", [], q):
            if v["id"] in seen:
                seen[v["id"]]["consultas"].append(q)
            else:
                seen[v["id"]] = v

    hits, urls = defaultdict(set), {}
    for v in seen.values():
        hits[v["canal"]].update(v["consultas"])
        if v.get("canal_url") and v["canal_url"] != "NA":
            urls[v["canal"]] = v["canal_url"]
    fuertes = [c for c, qs in hits.items() if len(qs) >= 2 and c in urls]
    if opts["--canal"] > 0:
        for c in fuertes:
            for v in run_ytdlp(f"{urls[c]}/videos", ["--playlist-end", str(opts["--canal"])], f"canal:{c}"):
                if v["id"] not in seen:
                    seen[v["id"]] = v

    rows = []
    for v in seen.values():
        s, age = score(v, today)
        if age > opts["--months"] * 30.5:
            continue
        if v["dur_s"] and v["dur_s"] < 120:  # shorts: casi nunca muestran el proceso
            continue
        v["senal"] = round(s + 0.3 * (len(set(v["consultas"])) - 1), 2)
        rows.append(v)
    rows.sort(key=lambda v: v["senal"], reverse=True)
    rows = rows[: opts["--top"]]

    bloqueos = [e for e in ERRORS if "429" in e or "not a bot" in e]
    if as_json:
        print(json.dumps({"videos": rows, "errores": ERRORS}, ensure_ascii=False, indent=2))
        return
    if ERRORS:
        print(f"AVISO: {len(ERRORS)} errores de yt-dlp ({len(bloqueos)} porque YouTube bloqueo un rato)."
              f" La lista puede estar incompleta" + (": espera unos minutos y repeti." if bloqueos else "."))
        for e in ERRORS[:5]:
            print(f"  - {e}")
        print()
    print(f"{len(seen)} candidatos; canales ampliados ({len(fuertes)}): {', '.join(fuertes)}")
    print(f"{len(rows)} despues de filtros (ultimos {opts['--months']} meses, sin shorts)\n")
    for v in rows:
        print(f"{v['senal']:5} | {v['vistas']:>9,} vistas | {v['subs']:>9,} subs | {v['fecha']} | "
              f"{v['canal'][:22]:22} | {v['titulo'][:70]} | https://youtu.be/{v['id']}")


if __name__ == "__main__":
    main()
