#!/usr/bin/env bash
# =============================================================================
#  aac-build.sh · Pipeline local de Architecture as Code (Volarte)
#
#  1. Prepara herramientas (structurizr-cli fijado por versión, deps Node)
#  2. Valida sintaxis DSL            (structurizr validate)          -> bloqueante
#  3. Inspecciona buenas prácticas   (structurizr inspect)           -> informativo
#  4. Exporta JSON / Mermaid / C4-PlantUML
#  5. Ejecuta el Agente Revisor      (scripts/architecture_reviewer.py) -> bloqueante
#  6. Renderiza SVG, PNG y PNG alta resolución (Mermaid CLI + Puppeteer)
#  7. Genera el PDF unificado        (docs/generated/Volarte_Architecture_Specification.pdf)
#  8. Escribe docs/generated/BUILD_REPORT.md
#
#  Uso:
#    scripts/aac-build.sh                    # build completo (R4 contra cambios locales)
#    scripts/aac-build.sh --validate-only    # solo validación + export JSON
#    scripts/aac-build.sh --base origin/main # R4 contra una rama base (CI de PR)
#    scripts/aac-build.sh --skip-traceability --ai --strict
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
WORKSPACE="dsl/workspace.dsl"
OUT="docs/generated"
HIRES_SCALE="${AAC_HIRES_SCALE:-4}"

VALIDATE_ONLY=0; SKIP_RENDER=0; REVIEW_ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --validate-only)      VALIDATE_ONLY=1 ;;
    --skip-render)        SKIP_RENDER=1 ;;
    --base)               REVIEW_ARGS+=(--base "$2"); shift ;;
    --skip-traceability)  REVIEW_ARGS+=(--skip-traceability) ;;
    --strict)             REVIEW_ARGS+=(--warnings-as-errors) ;;
    --ai)                 REVIEW_ARGS+=(--ai) ;;
    -h|--help)            sed -n '2,24p' "$0"; exit 0 ;;
    *) echo "Opción desconocida: $1" >&2; exit 2 ;;
  esac
  shift
done

c_blue=$'\e[34m'; c_green=$'\e[32m'; c_red=$'\e[31m'; c_off=$'\e[0m'
step() { echo; echo "${c_blue}▶ $*${c_off}"; }
ok()   { echo "${c_green}✔ $*${c_off}"; }
fail() { echo "${c_red}✖ $*${c_off}" >&2; exit 1; }
cli()  {
  local log rc
  log="$(mktemp)"
  "$CLI" "$@" >"$log" 2>&1 && rc=0 || rc=$?
  grep -v '^Picked up JAVA_TOOL_OPTIONS' "$log" || true
  rm -f "$log"
  return "$rc"
}

START=$(date +%s)

# ----------------------------------------------------------------------------- 1
step "1/8 Preparando herramientas"
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

# ----------------------------------------------------------------------------- 2
step "2/8 Validando sintaxis DSL ($WORKSPACE)"
cli validate -workspace "$WORKSPACE" || fail "La validación del DSL falló"
ok "DSL válido"

# ----------------------------------------------------------------------------- 3
step "3/8 Inspección de buenas prácticas (structurizr inspect)"
mkdir -p "$OUT"
cli inspect -workspace "$WORKSPACE" -severity error,warning > "$OUT/inspect-report.txt" || true
INSPECT_ISSUES=$(grep -cE '^(ERROR|WARNING)' "$OUT/inspect-report.txt" || true)
ok "inspect: ${INSPECT_ISSUES} observación(es) → $OUT/inspect-report.txt"

# ----------------------------------------------------------------------------- 4
step "4/8 Exportando JSON, Mermaid y C4-PlantUML"
rm -rf "$OUT/json" "$OUT/mmd" "$OUT/puml" && mkdir -p "$OUT/json" "$OUT/mmd" "$OUT/puml"
cli export -workspace "$WORKSPACE" -format json -output "$TOOLS_DIR" >/dev/null || fail "Export JSON falló"
python3 -c "import json,sys; d=json.load(open(sys.argv[1])); json.dump(d, open(sys.argv[2],'w'), indent=2, ensure_ascii=False)" \
  "$TOOLS_DIR/workspace.json" "$OUT/json/workspace.json"
cli export -workspace "$WORKSPACE" -format mermaid -output "$OUT/mmd" >/dev/null || fail "Export Mermaid falló"
cli export -workspace "$WORKSPACE" -format plantuml/c4plantuml -output "$OUT/puml" >/dev/null || fail "Export PlantUML falló"
for f in "$OUT"/mmd/structurizr-*.mmd "$OUT"/puml/structurizr-*.puml; do
  [[ -e "$f" ]] && mv "$f" "$(dirname "$f")/$(basename "$f" | sed 's/^structurizr-//')"
done
VIEWS=$(ls "$OUT"/mmd/*.mmd | wc -l | tr -d ' ')
ok "$VIEWS vistas exportadas (mmd + puml) · modelo en $OUT/json/workspace.json"

# ----------------------------------------------------------------------------- 5
step "5/8 Agente Revisor de Arquitectura"
set +e
python3 scripts/architecture_reviewer.py --workspace-json "$TOOLS_DIR/workspace.json" "${REVIEW_ARGS[@]}"
REVIEW_RC=$?
set -e
[[ $REVIEW_RC -eq 0 ]] || fail "El Agente Revisor encontró violaciones (ver $OUT/review/review-report.md)"

if [[ $VALIDATE_ONLY -eq 1 || $SKIP_RENDER -eq 1 ]]; then
  ok "Validación completa (render omitido) en $(( $(date +%s) - START ))s"
  exit 0
fi

# ----------------------------------------------------------------------------- 6
step "6/8 Renderizando SVG / PNG / PNG alta resolución (Mermaid CLI + Puppeteer)"
command -v node >/dev/null || fail "Se requiere Node.js 18+ para el render"
if [[ -z "${PUPPETEER_EXECUTABLE_PATH:-}" ]]; then
  # Chromium preinstalado (p. ej. Playwright) si existe; si no, el que descarga Puppeteer.
  for c in /opt/pw-browsers/chromium-*/chrome-linux/chrome /usr/bin/chromium /usr/bin/google-chrome; do
    [[ -x "$c" ]] && export PUPPETEER_EXECUTABLE_PATH="$c" && break
  done
fi
if [[ ! -d node_modules/@mermaid-js/mermaid-cli ]]; then
  if [[ -n "${PUPPETEER_EXECUTABLE_PATH:-}" ]]; then export PUPPETEER_SKIP_DOWNLOAD=1; fi
  npm ci --no-audit --no-fund
fi
rm -rf "$OUT/svg" "$OUT/png" "$OUT/png-hires"
node scripts/render-diagrams.mjs "$OUT/mmd" "$OUT" "$HIRES_SCALE" || fail "Uno o más diagramas no se pudieron renderizar"
ok "$VIEWS diagramas × (SVG, PNG ×2, PNG ×$HIRES_SCALE)"

# ----------------------------------------------------------------------------- 7
step "7/8 Generando PDF unificado"
AAC_COMMIT="$(git rev-parse --short HEAD 2>/dev/null || echo local)" \
  node scripts/render-pdf.mjs "$TOOLS_DIR/workspace.json" "$OUT/svg" "$OUT/Volarte_Architecture_Specification.pdf"
ok "PDF: $OUT/Volarte_Architecture_Specification.pdf"

# ----------------------------------------------------------------------------- 8
step "8/8 Reporte de compilación"
python3 - "$OUT" "$STRUCTURIZR_CLI_VERSION" "$INSPECT_ISSUES" "$(( $(date +%s) - START ))" <<'PY'
import json, pathlib, subprocess, sys, datetime
out, cli_version, inspect_issues, seconds = pathlib.Path(sys.argv[1]), sys.argv[2], sys.argv[3], sys.argv[4]
review = json.loads((out / "review" / "review-report.json").read_text(encoding="utf-8"))
ws = json.loads((out / "json" / "workspace.json").read_text(encoding="utf-8"))
def git(*a):
    try: return subprocess.run(["git", *a], capture_output=True, text=True).stdout.strip()
    except Exception: return "n/d"
def size(p): return f"{p.stat().st_size / 1024:,.0f} KB"
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
pdf = out / "Volarte_Architecture_Specification.pdf"
c = review["stats"]["counts"]
report = f"""# Reporte de Compilación · Volarte AaC

| Campo | Valor |
|---|---|
| Fecha (UTC) | {datetime.datetime.now(datetime.timezone.utc):%Y-%m-%d %H:%M:%S} |
| Commit base | `{git('rev-parse', '--short', 'HEAD')}` ({git('rev-parse', '--abbrev-ref', 'HEAD')}) |
| structurizr-cli | {cli_version} |
| Duración | {seconds} s |
| Validación DSL | ✅ OK |
| `structurizr inspect` | {inspect_issues} observación(es) (`inspect-report.txt`) |
| Agente Revisor | {'✅ APROBADO' if c['ERROR'] == 0 else '❌ RECHAZADO'} · {c['ERROR']} errores · {c['WARN']} advertencias · {c['INFO']} info |
| Modelo | {counts['people']} personas · {counts['systems']} sistemas · {counts['containers']} contenedores · {counts['components']} componentes |
| PDF | `Volarte_Architecture_Specification.pdf` ({size(pdf) if pdf.exists() else 'no generado'}) |

## Diagramas generados ({len(rows)} vistas)

Cada vista se exporta en `mmd/` (Mermaid), `puml/` (C4-PlantUML), `svg/`, `png/` (×2) y `png-hires/` (alta resolución).

| Vista | Estado | SVG | PNG | PNG alta resolución |
|---|---|---|---|---|
""" + "\n".join(rows) + "\n\nDetalle de hallazgos: [`review/review-report.md`](review/review-report.md)\n"
(out / "BUILD_REPORT.md").write_text(report, encoding="utf-8")
print(report)
PY
ok "Build completo en $(( $(date +%s) - START ))s"
