#!/usr/bin/env bash
# =============================================================================
#  aac-build.sh · Pipeline de Architecture as Code (multi-proyecto / multi-versión)
#
#  Por cada versión (proyectos/<proyecto>/v<N>):
#   1. Prepara herramientas (structurizr-cli fijado por versión, deps Node)
#   2. Valida sintaxis DSL            (structurizr validate)              -> bloqueante
#   3. Inspecciona buenas prácticas   (structurizr inspect)               -> informativo
#   4. Exporta JSON / Mermaid / C4-PlantUML
#   5. Ejecuta el Agente Revisor      (scripts/architecture_reviewer.py)  -> bloqueante
#   6. Renderiza SVG, PNG y PNG alta resolución con la leyenda C4
#   7. Genera el PDF unificado        (<versión>/docs/generated/<Proyecto>_<vN>_Architecture_Specification.pdf)
#   8. Escribe <versión>/docs/generated/BUILD_REPORT.md
#
#  Las versiones congeladas (estado aprobada / reemplazada / obsoleta en version.json)
#  solo se VALIDAN: sus artefactos son evidencia histórica y no se regeneran.
#
#  Uso:
#    scripts/aac-build.sh proyectos/volarte/v2                    # build completo de una versión
#    scripts/aac-build.sh proyectos/volarte/v2 --validate-only    # validación + Agente Revisor
#    scripts/aac-build.sh --all [--validate-only]                 # todas las versiones
#    scripts/aac-build.sh --changed origin/main                   # versiones con cambios vs base
#    Opciones: --base REF · --skip-traceability · --strict · --ai · --force (re-generar congelada)
#
#  Variables: STRUCTURIZR_CLI_VERSION, PUPPETEER_EXECUTABLE_PATH, AAC_HIRES_SCALE
# =============================================================================
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

STRUCTURIZR_CLI_VERSION="${STRUCTURIZR_CLI_VERSION:-2025.05.28}"
TOOLS_DIR="$ROOT/.aac"
CLI_DIR="$TOOLS_DIR/structurizr-cli-$STRUCTURIZR_CLI_VERSION"
CLI="$CLI_DIR/structurizr.sh"
HIRES_SCALE="${AAC_HIRES_SCALE:-4}"

VERSIONS=(); VALIDATE_ONLY=0; FORCE=0; REVIEW_ARGS=(); MODE=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --all)                MODE="all" ;;
    --changed)            MODE="changed"; CHANGED_BASE="$2"; REVIEW_ARGS+=(--base "$2"); shift ;;
    --validate-only)      VALIDATE_ONLY=1 ;;
    --base)               REVIEW_ARGS+=(--base "$2"); shift ;;
    --skip-traceability)  REVIEW_ARGS+=(--skip-traceability) ;;
    --strict)             REVIEW_ARGS+=(--warnings-as-errors) ;;
    --ai)                 REVIEW_ARGS+=(--ai) ;;
    --force)              FORCE=1 ;;
    -h|--help)            sed -n '2,28p' "$0"; exit 0 ;;
    -*) echo "Opción desconocida: $1" >&2; exit 2 ;;
    *)                    VERSIONS+=("${1%/}") ;;
  esac
  shift
done
case "$MODE" in
  all)     mapfile -t VERSIONS < <(python3 scripts/aac_versions.py list) ;;
  changed) mapfile -t VERSIONS < <(python3 scripts/aac_versions.py list --changed "$CHANGED_BASE") ;;
esac
if [[ ${#VERSIONS[@]} -eq 0 ]]; then
  if [[ "$MODE" == "changed" ]]; then echo "Sin versiones de arquitectura modificadas frente a $CHANGED_BASE."; exit 0; fi
  echo "Indique una versión (p. ej. proyectos/volarte/v2), --all o --changed <base>. Ver --help." >&2; exit 2
fi

c_blue=$'\e[34m'; c_green=$'\e[32m'; c_red=$'\e[31m'; c_yellow=$'\e[33m'; c_off=$'\e[0m'
step() { echo; echo "${c_blue}▶ $*${c_off}"; }
ok()   { echo "${c_green}✔ $*${c_off}"; }
warn() { echo "${c_yellow}⚠ $*${c_off}"; }
fail() { echo "${c_red}✖ $*${c_off}" >&2; exit 1; }
cli()  {
  local log rc
  log="$(mktemp)"
  "$CLI" "$@" >"$log" 2>&1 && rc=0 || rc=$?
  grep -v '^Picked up JAVA_TOOL_OPTIONS' "$log" || true
  rm -f "$log"
  return "$rc"
}
meta() { python3 -c "import json,sys; print(json.load(open(sys.argv[1])).get(sys.argv[2]) or '')" "$1/version.json" "$2"; }

# ----------------------------------------------------------------------------- 1
step "1 · Preparando herramientas"
command -v java >/dev/null || fail "Se requiere Java 17+ (structurizr-cli)"
command -v python3 >/dev/null || fail "Se requiere Python 3.10+"
if [[ ! -x "$CLI" ]]; then
  mkdir -p "$CLI_DIR"
  url="https://github.com/structurizr/cli/releases/download/v${STRUCTURIZR_CLI_VERSION}/structurizr-cli.zip"
  echo "Descargando structurizr-cli ${STRUCTURIZR_CLI_VERSION}…"
  curl -fsSL "$url" -o "$TOOLS_DIR/structurizr-cli.zip" || fail "No se pudo descargar $url"
  unzip -qo "$TOOLS_DIR/structurizr-cli.zip" -d "$CLI_DIR" && rm -f "$TOOLS_DIR/structurizr-cli.zip"
  chmod +x "$CLI"
fi
ok "structurizr-cli $STRUCTURIZR_CLI_VERSION · $(java -version 2>&1 | grep -m1 version)"
python3 scripts/gen_theme.py

prepare_render() {
  [[ -n "${RENDER_READY:-}" ]] && return 0
  command -v node >/dev/null || fail "Se requiere Node.js 18+ para el render"
  if [[ -z "${PUPPETEER_EXECUTABLE_PATH:-}" ]]; then
    # Chromium de Playwright si está preinstalado (entornos de desarrollo); si no, el
    # chrome-headless-shell que Puppeteer descarga con `npm ci` (versión fijada).
    # No se usa el Chrome del sistema: su versión no coincide con Puppeteer (ver scripts/browser.mjs).
    for c in /opt/pw-browsers/chromium-*/chrome-linux/chrome; do
      [[ -x "$c" ]] && export PUPPETEER_EXECUTABLE_PATH="$c" && break
    done
  fi
  if [[ ! -d node_modules/@mermaid-js/mermaid-cli ]]; then
    if [[ -n "${PUPPETEER_EXECUTABLE_PATH:-}" ]]; then export PUPPETEER_SKIP_DOWNLOAD=1; fi
    npm ci --no-audit --no-fund
  fi
  RENDER_READY=1
}

build_version() {
  local VDIR="$1" START; START=$(date +%s)
  [[ -f "$VDIR/dsl/workspace.dsl" ]] || fail "$VDIR no contiene dsl/workspace.dsl"
  [[ -f "$VDIR/version.json" ]] || fail "$VDIR no contiene version.json (ver estandares/plantillas/version.json)"
  local PROJECT VERSION NAME STATE WORKSPACE OUT WORK PDF
  PROJECT="$(basename "$(dirname "$VDIR")")"; VERSION="$(basename "$VDIR")"
  NAME="$(meta "$VDIR" nombre)"; STATE="$(meta "$VDIR" estado)"
  WORKSPACE="$VDIR/dsl/workspace.dsl"; OUT="$VDIR/docs/generated"; WORK="$TOOLS_DIR/$PROJECT-$VERSION"
  PDF="$OUT/${NAME// /_}_${VERSION}_Architecture_Specification.pdf"
  mkdir -p "$WORK"

  echo; echo "═══════════════════════════════════════════════════════════════════════"
  echo " $NAME · $VERSION · estado: $STATE"
  echo "═══════════════════════════════════════════════════════════════════════"

  step "2 · Validando sintaxis DSL ($WORKSPACE)"
  cli validate -workspace "$WORKSPACE" || fail "La validación del DSL falló ($VDIR)"
  ok "DSL válido"

  if [[ "$STATE" =~ ^(aprobada|reemplazada|obsoleta)$ && $FORCE -eq 0 ]]; then
    warn "Versión congelada ($STATE): solo se valida (R6 inmutabilidad, R8 metadatos); sus artefactos no se regeneran."
    cli export -workspace "$WORKSPACE" -format json -output "$WORK" >/dev/null || fail "Export JSON falló"
    python3 scripts/architecture_reviewer.py --version-dir "$VDIR" --workspace-json "$WORK/workspace.json" \
      --frozen --out "$WORK/review" "${REVIEW_ARGS[@]}" || fail "La versión congelada $VDIR fue modificada (R6) o sus metadatos son inválidos (R8)"
    return 0
  fi

  step "3 · Inspección de buenas prácticas (structurizr inspect)"
  mkdir -p "$OUT"
  cli inspect -workspace "$WORKSPACE" -severity error,warning > "$OUT/inspect-report.txt" || true
  local INSPECT_ISSUES; INSPECT_ISSUES=$(grep -cE '^(ERROR|WARNING)' "$OUT/inspect-report.txt" || true)
  ok "inspect: ${INSPECT_ISSUES} observación(es) → $OUT/inspect-report.txt"

  step "4 · Exportando JSON, Mermaid y C4-PlantUML"
  rm -rf "$OUT/json" "$OUT/mmd" "$OUT/puml" && mkdir -p "$OUT/json" "$OUT/mmd" "$OUT/puml"
  cli export -workspace "$WORKSPACE" -format json -output "$WORK" >/dev/null || fail "Export JSON falló"
  python3 -c "import json,sys; d=json.load(open(sys.argv[1])); json.dump(d, open(sys.argv[2],'w'), indent=2, ensure_ascii=False)" \
    "$WORK/workspace.json" "$OUT/json/workspace.json"
  cli export -workspace "$WORKSPACE" -format mermaid -output "$OUT/mmd" >/dev/null || fail "Export Mermaid falló"
  cli export -workspace "$WORKSPACE" -format plantuml/c4plantuml -output "$OUT/puml" >/dev/null || fail "Export PlantUML falló"
  for f in "$OUT"/mmd/structurizr-*.mmd "$OUT"/puml/structurizr-*.puml; do
    [[ -e "$f" ]] && mv "$f" "$(dirname "$f")/$(basename "$f" | sed 's/^structurizr-//')"
  done
  local VIEWS; VIEWS=$(ls "$OUT"/mmd/*.mmd | wc -l | tr -d ' ')
  ok "$VIEWS vistas exportadas (mmd + puml) · modelo en $OUT/json/workspace.json"

  step "5 · Agente Revisor de Arquitectura"
  set +e
  python3 scripts/architecture_reviewer.py --version-dir "$VDIR" --workspace-json "$WORK/workspace.json" "${REVIEW_ARGS[@]}"
  local REVIEW_RC=$?
  set -e
  [[ $REVIEW_RC -eq 0 ]] || fail "El Agente Revisor encontró violaciones (ver $OUT/review/review-report.md)"

  if [[ $VALIDATE_ONLY -eq 1 ]]; then
    ok "$VDIR validada (render omitido) en $(( $(date +%s) - START ))s"
    return 0
  fi

  step "6 · Renderizando SVG / PNG / PNG alta resolución con leyenda C4"
  prepare_render
  rm -rf "$OUT/svg" "$OUT/png" "$OUT/png-hires"
  node scripts/render-diagrams.mjs "$OUT/mmd" "$OUT" "$HIRES_SCALE" \
    || fail "Uno o más diagramas no se pudieron renderizar"
  ok "$VIEWS diagramas × (SVG, PNG ×2, PNG ×$HIRES_SCALE)"

  step "7 · Generando PDF unificado"
  rm -f "$OUT"/*_Architecture_Specification.pdf
  AAC_COMMIT="$(git rev-parse --short HEAD 2>/dev/null || echo local)" \
    node scripts/render-pdf.mjs "$VDIR" "$WORK/workspace.json" "$OUT/svg" "$PDF"
  ok "PDF: $PDF"

  step "8 · Reporte de compilación"
  python3 scripts/build_report.py "$VDIR" "$PDF" "$STRUCTURIZR_CLI_VERSION" "$INSPECT_ISSUES" "$(( $(date +%s) - START ))"
  ok "$VDIR compilada en $(( $(date +%s) - START ))s"
}

for v in "${VERSIONS[@]}"; do
  build_version "$v"
done
echo; ok "Versiones procesadas: ${VERSIONS[*]}"
