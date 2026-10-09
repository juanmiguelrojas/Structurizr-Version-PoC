#!/usr/bin/env bash
# Crea un proyecto nuevo de arquitectura desde estandares/plantillas/proyecto.
#   Uso: scripts/aac-nuevo-proyecto.sh <id-kebab-case> "<Nombre del proyecto>"
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ID="${1:-}"; NAME="${2:-}"
[[ "$ID" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ && -n "$NAME" ]] || { echo "Uso: $0 <id-kebab-case> \"<Nombre>\"" >&2; exit 2; }
DEST="$ROOT/proyectos/$ID"
[[ ! -e "$DEST" ]] || { echo "Ya existe proyectos/$ID" >&2; exit 1; }
cp -r "$ROOT/estandares/plantillas/proyecto" "$DEST"
FECHA="$(date -u +%Y-%m-%d)"; IDFECHA="$(date -u +%Y%m%d)"
grep -rl "__PROYECTO__\|__NOMBRE__\|__FECHA__\|__ID__" "$DEST" | while read -r f; do
  sed -i "s/__PROYECTO__/$ID/g; s/__NOMBRE__/${NAME//\//\\/}/g; s/__FECHA__/$FECHA/g; s/__ID__/$IDFECHA/g" "$f"
done
find "$DEST" -name .gitkeep -size 0 -path '*/components/*' -delete
echo "✔ Proyecto creado en proyectos/$ID (v1 · borrador)"
echo "  Siguiente: completar autores en v1/version.json, modelar v1/dsl/ y ejecutar"
echo "  scripts/aac-build.sh proyectos/$ID/v1 --validate-only"
