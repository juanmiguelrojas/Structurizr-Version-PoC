#!/usr/bin/env python3
"""Escribe <versión>/docs/generated/BUILD_REPORT.md (invocado por scripts/aac-build.sh).

Uso: build_report.py <versión> <pdf> <cli-version> <inspect-issues> <segundos>
"""
import datetime
import json
import pathlib
import subprocess
import sys

vdir, pdf, cli_version, inspect_issues, seconds = sys.argv[1:6]
vdir, pdf = pathlib.Path(vdir), pathlib.Path(pdf)
out = vdir / "docs" / "generated"
meta = json.loads((vdir / "version.json").read_text(encoding="utf-8"))
review = json.loads((out / "review" / "review-report.json").read_text(encoding="utf-8"))
ws = json.loads((out / "json" / "workspace.json").read_text(encoding="utf-8"))


def git(*a):
    try:
        return subprocess.run(["git", *a], capture_output=True, text=True).stdout.strip() or "n/d"
    except OSError:
        return "n/d"


def size(p):
    return f"{p.stat().st_size / 1024:,.0f} KB" if p.exists() else "—"


counts = {"people": len(ws["model"].get("people", [])), "systems": 0, "containers": 0, "components": 0}
for s in ws["model"].get("softwareSystems", []):
    counts["systems"] += 1
    for c in s.get("containers", []) or []:
        counts["containers"] += 1
        counts["components"] += len(c.get("components", []) or [])

rows = []
for mmd in sorted((out / "mmd").glob("*.mmd")):
    n = mmd.stem
    files = [mmd, out / "svg" / f"{n}.svg", out / "png" / f"{n}.png", out / "png-hires" / f"{n}.png", out / "puml" / f"{n}.puml"]
    status = "✅" if all(f.exists() and f.stat().st_size > 0 for f in files) else "❌"
    rows.append(f"| `{n}` | {status} | {size(files[1])} | {size(files[2])} | {size(files[3])} |")

c = review["stats"]["counts"]
report = f"""# Reporte de Compilación · {meta['nombre']} · {meta['version']}

| Campo | Valor |
|---|---|
| Proyecto / versión | `{vdir.as_posix()}` · estado **{meta['estado']}** · basada en `{meta.get('basadaEn') or '—'}` |
| Fecha (UTC) | {datetime.datetime.now(datetime.timezone.utc):%Y-%m-%d %H:%M:%S} |
| Commit base | `{git('rev-parse', '--short', 'HEAD')}` ({git('rev-parse', '--abbrev-ref', 'HEAD')}) |
| structurizr-cli | {cli_version} |
| Duración | {seconds} s |
| Validación DSL | ✅ OK |
| `structurizr inspect` | {inspect_issues} observación(es) (`inspect-report.txt`) |
| Agente Revisor | {'✅ APROBADO' if c['ERROR'] == 0 else '❌ RECHAZADO'} · {c['ERROR']} errores · {c['WARN']} advertencias · {c['INFO']} info |
| Leyenda C4 | Person · Software System · Container · Component · External Person · External Software System (en cada diagrama) |
| Modelo | {counts['people']} personas · {counts['systems']} sistemas · {counts['containers']} contenedores · {counts['components']} componentes |
| PDF | `{pdf.name}` ({size(pdf)}) |

## Diagramas generados ({len(rows)} vistas)

Cada vista se exporta en `mmd/` (Mermaid), `puml/` (C4-PlantUML), `svg/`, `png/` (×2) y `png-hires/` (alta resolución, solo local / artefacto CI).

| Vista | Estado | SVG | PNG | PNG alta resolución |
|---|---|---|---|---|
""" + "\n".join(rows) + "\n\nDetalle de hallazgos: [`review/review-report.md`](review/review-report.md)\n"
(out / "BUILD_REPORT.md").write_text(report, encoding="utf-8")
print(report)
