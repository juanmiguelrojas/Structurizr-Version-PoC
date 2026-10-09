#!/usr/bin/env python3
"""
Utilidades de versionamiento de proyectos de arquitectura.

Estructura esperada (ver docs/lineamientos/04-versionamiento-y-trazabilidad.md):

    proyectos/<proyecto>/
        README.md                 índice del proyecto e historial de versiones
        CHANGELOG_DSL.md          bitácora única del proyecto (todas las versiones)
        v<N>/
            version.json          metadatos y ESTADO de la versión
            dsl/workspace.dsl     modelo Structurizr de la versión
            docs/                 adr/, workspace/, generated/
            fuente/               (opcional) insumos originales (Draw.io, PDF…)

CLI:
    python3 scripts/aac_versions.py list                       # todas las versiones
    python3 scripts/aac_versions.py list --editable            # solo no congeladas
    python3 scripts/aac_versions.py list --changed origin/main # con cambios vs base
    python3 scripts/aac_versions.py info proyectos/volarte/v2  # metadatos (JSON)
"""
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PROJECTS_DIR = ROOT / "proyectos"
VERSION_DIR_RE = re.compile(r"^proyectos/([^/]+)/(v\d+)/")

STATES = {"borrador", "en-revision", "aprobada", "reemplazada", "obsoleta"}
LOCKED_STATES = {"aprobada", "reemplazada", "obsoleta"}
REQUIRED_FIELDS = ["proyecto", "nombre", "version", "estado", "fecha", "basadaEn", "autores",
                   "aprobadores", "workspace", "changelog", "descripcion"]


def version_sort_key(path: Path) -> tuple[str, int]:
    return path.parent.name, int(path.name[1:])


def list_versions() -> list[Path]:
    dirs = [p for p in PROJECTS_DIR.glob("*/v*") if p.is_dir() and re.fullmatch(r"v\d+", p.name)]
    return sorted(dirs, key=version_sort_key)


def load_version(version_dir: Path) -> dict:
    meta_path = version_dir / "version.json"
    return json.loads(meta_path.read_text(encoding="utf-8")) if meta_path.exists() else {}


def is_locked(meta: dict) -> bool:
    return meta.get("estado") in LOCKED_STATES


def rel(path: Path) -> str:
    return path.resolve().relative_to(ROOT).as_posix()


def version_of_path(repo_path: str) -> str | None:
    """'proyectos/volarte/v2/dsl/x.dsl' -> 'proyectos/volarte/v2'"""
    m = VERSION_DIR_RE.match(repo_path)
    return f"proyectos/{m.group(1)}/{m.group(2)}" if m else None


def git(*args: str) -> str:
    return subprocess.run(["git", *args], cwd=ROOT, capture_output=True, text=True, check=True).stdout


def changed_files(base: str | None) -> list[str]:
    """Archivos cambiados vs base (CI) o cambios locales sin commit vs HEAD."""
    if base:
        out = git("diff", "--name-only", f"{base}...HEAD")
    else:
        out = git("diff", "--name-only", "HEAD") + git("ls-files", "--others", "--exclude-standard")
    return sorted({line.strip() for line in out.splitlines() if line.strip()})


def meta_at(ref: str | None, version_dir: str) -> dict:
    """version.json tal como estaba en `ref` (o en disco si ref es None)."""
    if ref is None:
        return load_version(ROOT / version_dir)
    try:
        return json.loads(git("show", f"{ref}:{version_dir}/version.json"))
    except (subprocess.CalledProcessError, json.JSONDecodeError):
        return {}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = parser.add_subparsers(dest="cmd", required=True)
    lst = sub.add_parser("list")
    lst.add_argument("--editable", action="store_true", help="excluye versiones congeladas")
    lst.add_argument("--changed", metavar="BASE", help="solo versiones con cambios frente a BASE")
    info = sub.add_parser("info")
    info.add_argument("version_dir", type=Path)
    args = parser.parse_args()

    if args.cmd == "info":
        print(json.dumps(load_version(args.version_dir), indent=2, ensure_ascii=False))
        return 0

    versions = list_versions()
    if args.changed:
        touched = {version_of_path(f) for f in changed_files(args.changed)}
        versions = [v for v in versions if rel(v) in touched]
    if args.editable:
        versions = [v for v in versions if not is_locked(load_version(v))]
    for v in versions:
        print(rel(v))
    return 0


if __name__ == "__main__":
    sys.exit(main())
