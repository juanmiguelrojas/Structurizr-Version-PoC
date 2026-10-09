#!/usr/bin/env bash
# Crea la versión v<N+1> de un proyecto copiando su última versión.
#   Uso: scripts/aac-nueva-version.sh proyectos/<proyecto> ["Descripción de la nueva versión"]
# La nueva versión nace en estado "borrador" con basadaEn = vN. Los artefactos generados
# y la carpeta fuente/ no se copian (se regeneran / se referencian). La versión anterior
# NO se modifica: su estado se actualiza al aprobar la nueva (ver lineamiento 05 §6).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT="${1%/}"; DESC="${2:-Por completar: qué cambia frente a la versión anterior.}"
[[ -d "$ROOT/$PROJECT" && "$PROJECT" == proyectos/* ]] || { echo "Uso: $0 proyectos/<proyecto> [\"descripción\"]" >&2; exit 2; }
LAST="$(ls -d "$ROOT/$PROJECT"/v[0-9]* | sed 's#.*/v##' | sort -n | tail -1)"
PREV="v$LAST"; NEXT="v$((LAST + 1))"
SRC="$ROOT/$PROJECT/$PREV"; DEST="$ROOT/$PROJECT/$NEXT"
mkdir -p "$DEST/docs"
cp -r "$SRC/dsl" "$DEST/dsl"
for d in adr workspace; do [[ -d "$SRC/docs/$d" ]] && cp -r "$SRC/docs/$d" "$DEST/docs/$d"; done
python3 - "$SRC/version.json" "$DEST/version.json" "$PREV" "$NEXT" "$DESC" <<'PY'
import json, sys, datetime
src, dest, prev, nxt, desc = sys.argv[1:]
m = json.load(open(src, encoding="utf-8"))
fuente = m.get("fuente")
if fuente and not fuente.startswith("../"):
    fuente = f"../{prev}/{fuente}"
m.update({"version": nxt, "estado": "borrador", "fecha": datetime.date.today().isoformat(),
          "basadaEn": prev, "reemplazadaPor": None, "aprobadores": [], "fuente": fuente,
          "changelog": [], "descripcion": desc})
json.dump(m, open(dest, "w", encoding="utf-8"), indent=2, ensure_ascii=False)
open(dest, "a").write("\n")
PY
sed -i "s/\"aac.version\" \"$PREV\"/\"aac.version\" \"$NEXT\"/; s/\"aac.basadaEn\" \"[^\"]*\"/\"aac.basadaEn\" \"$PREV\"/" "$DEST/dsl/workspace.dsl"
cat > "$DEST/README.md" <<MD
# $(python3 -c "import json;print(json.load(open('$DEST/version.json'))['nombre'])") · $NEXT (borrador)

- **Estado:** borrador · **Basada en:** [\`$PREV\`](../$PREV/)
- **Qué cambió frente a $PREV:** $DESC
MD
echo "✔ Creada $PROJECT/$NEXT (borrador, basada en $PREV)"
echo "  Siguiente: registrar la entrada en $PROJECT/CHANGELOG_DSL.md (Versión: \`$NEXT\`, Tipo: Nueva versión),"
echo "  agregar la fila en $PROJECT/README.md y ejecutar scripts/aac-build.sh $PROJECT/$NEXT"
