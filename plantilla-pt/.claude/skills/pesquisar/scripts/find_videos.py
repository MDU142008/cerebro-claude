#!/usr/bin/env python3
"""Busca vídeos do YouTube para uma pesquisa: monta uma lista grande de candidatos e a ordena.

Uso:
    python find_videos.py "busca 1" "busca 2" ... [--per 20] [--months 24] [--top 40] [--canal 12] [--json]

1. Uma busca no YouTube para cada consulta (com yt-dlp, sem chave de API). Junta e tira os repetidos.
2. Os canais que aparecem em 2 ou mais consultas diferentes são ampliados com os seus --canal vídeos recentes
   (0 desliga): a busca não traz todos os vídeos bons de um canal bom.
3. Filtra (últimos --months meses, sem shorts) e ordena por sinal.
Depois as legendas dos melhores são baixadas com get-transcript.py (nesta mesma pasta).

Sinal: as views sozinhas premiam os canais grandes e o que é antigo. Combinam-se:
  - views por dia desde a publicação (o que as pessoas estão vendo agora)
  - views / inscritos (um vídeo que rende muito mais que o seu canal costuma ser bom)
  - aparecer em várias consultas diferentes
Os vídeos pequenos de canais especializados NÃO saem no topo: por isso todos os candidatos são mostrados
e a escolha é feita lendo títulos e canais, não só a pontuação.

Precisa do yt-dlp:  python -m pip install --user yt-dlp
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

# Uma trava por computador: duas buscas ao mesmo tempo na mesma conexão fazem o YouTube
# bloquear por um tempo (erro 429 / "confirm you're not a bot").
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
                sys.exit(f"outra busca de vídeos está rodando há mais de {LOCK_WAIT_S // 60} min ({LOCK})")
            print("  outra busca de vídeos está rodando; espero a minha vez...", file=sys.stderr)
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
    # "python -m yt_dlp" funciona mesmo que a pasta de programas do pip não esteja no PATH.
    cmd = [sys.executable, "-m", "yt_dlp", target, "--skip-download", "--no-warnings", "--ignore-errors",
           "--print", FIELDS] + extra
    try:
        # No Windows, sem isto o yt-dlp escreve em outra codificação e um título estranho quebra a leitura.
        env = dict(os.environ, PYTHONUTF8="1", PYTHONIOENCODING="utf-8")
        res = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8", errors="replace",
                             timeout=900, env=env)
    except subprocess.TimeoutExpired:
        ERRORS.append(f"passou do tempo: {label}")
        return []
    out = res.stdout or ""
    err = res.stderr or ""
    if "No module named yt_dlp" in err:
        sys.exit("falta o yt-dlp. Instale com:  python -m pip install --user yt-dlp")
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
    # logaritmo: para um vídeo viral não esconder o resto; views/dia e proporção pesam igual
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
        if v["dur_s"] and v["dur_s"] < 120:  # shorts: quase nunca mostram o processo
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
        print(f"AVISO: {len(ERRORS)} erros do yt-dlp ({len(bloqueos)} porque o YouTube bloqueou por um tempo)."
              f" A lista pode estar incompleta" + (": espere alguns minutos e repita." if bloqueos else "."))
        for e in ERRORS[:5]:
            print(f"  - {e}")
        print()
    print(f"{len(seen)} candidatos; canais ampliados ({len(fuertes)}): {', '.join(fuertes)}")
    print(f"{len(rows)} depois dos filtros (últimos {opts['--months']} meses, sem shorts)\n")
    for v in rows:
        print(f"{v['senal']:5} | {v['vistas']:>9,} views | {v['subs']:>9,} subs | {v['fecha']} | "
              f"{v['canal'][:22]:22} | {v['titulo'][:70]} | https://youtu.be/{v['id']}")


if __name__ == "__main__":
    main()
