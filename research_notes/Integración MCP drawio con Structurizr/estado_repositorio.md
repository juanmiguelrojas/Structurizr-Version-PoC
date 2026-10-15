# Estado actual del ecosistema Architecture-as-Code (Structurizr-Version-PoC, rama main @ 157d1a2)

Fuente: lectura directa del repositorio local `/home/user/Structurizr-Version-PoC` (sin web). Todas las rutas de las
citas son relativas a esa raíz; las líneas citadas corresponden al commit `157d1a2 feat(volarte): v3, réplica fiel del
Draw.io con notación C4 y trazabilidad completa`. Historia: 4f681cc inicial → f57443d baseline v1 → f2549a5 lineamientos +
leyenda C4 + v2 → c15ddd0 fix Puppeteer CI → 157d1a2 v3 (réplica Draw.io).

## 1. Estructura del repositorio y convenciones

### Takeaway
Repositorio multi-proyecto/multi-versión: `proyectos/<proyecto>/v<N>/` es una fotografía completa (DSL + docs + artefactos)
gobernada por `version.json` (estado) y una bitácora única por proyecto (`CHANGELOG_DSL.md`); la notación es exclusivamente
C4 con una leyenda corporativa de 6 colores en una fuente única (`estandares/c4/estilos-c4.dsl`). No existe ninguna noción de
"notación" alternativa (ArchiMate) ni de iconografía cloud (GCP).

### Cited Findings
- Raíz: `README.md`, `CHANGELOG.md` (cambios del marco, semver 2.0.0/3.0.0), `docs/lineamientos/01..07 + README.md`,
  `estandares/{c4,plantillas}`, `proyectos/volarte/{README.md,CHANGELOG_DSL.md,v1,v2,v3}`, `scripts/`, `.github/`
  (workflow, `pull_request_template.md`, `CODEOWNERS` todo a @juanmiguelrojas). `.aac/` (herramientas, CLI, temporales) y
  `node_modules/` están en `.gitignore`. — [README.md](README.md); [.gitignore](.gitignore); [.github/CODEOWNERS](.github/CODEOWNERS)
- Requisitos: Java 17+, Python 3.10+, Node 18+; `package.json` solo tiene devDependencies `@mermaid-js/mermaid-cli 11.4.2`,
  `marked 14.1.4`, `puppeteer 23.11.1` (no hay dependencia drawio/xml de Node). — [README.md](README.md); [package.json](package.json)
- Lineamientos (líneas): 01 Propósito (70), 02 Modelado C4 (104), 03 Leyenda C4 (72), 04 Versionamiento (128),
  05 Revisión/aprobación (123), 06 Guía Structurizr (165), 07 Consistencia (48). — [docs/lineamientos/](docs/lineamientos/)
- 02 §1 vistas obligatorias: L1 `systemContext` y L2 `container` **Sí**; Despliegue `deployment` **Sí (al menos producción)**;
  L0 `systemLandscape` si hay plataforma transversal; L3 para contenedores no triviales; dinámicas para HU críticas.
  Nomenclatura de claves `L0_…, L1_…, L2_…, L3_<Contenedor>, D<n>_<Flujo>_<HU>, DEP_<Ambiente>_<Plataforma>`.
  — [docs/lineamientos/02-lineamientos-c4.md](docs/lineamientos/02-lineamientos-c4.md) L6-17
- 02 §4 tags semánticos: solo cambian **forma**, nunca color (`Frontend/Mobile/WebBrowser`, `BFF/DomainService`,
  `Database/LocalDatabase/Cache/Storage`, `Queue/Topic/Subscription/DLQ`, `APIGateway/IdentityProvider/Infrastructure/Edge/
  Security/Observability`, `Pending`, `Reference`, relación `Logical`). — [02-lineamientos-c4.md](docs/lineamientos/02-lineamientos-c4.md) L49-63
- 02 §5 describe el layout DSL "clásico" (`people.dsl, systems.dsl, <sistema>_containers.dsl, components/, relationships.dsl,
  deployment.dsl`, views `landscape_context/containers/components/dynamic/deployment/styles.dsl`) y exige "`autoLayout` en
  todas las vistas"; 02 §6 añade la excepción de presentación `dsl/layout/<vista>.json` para réplicas Draw.io.
  — [02-lineamientos-c4.md](docs/lineamientos/02-lineamientos-c4.md) L65-97
- 03 Leyenda: Person `#083F75`, Software System `#1061B0`, Container `#23A2D9`, Component `#63BEF2`, External Person `#6C6477`,
  External Software System `#8C8496`; personas siempre silueta (`shape Person`, equivalente a `mxgraph.c4.person2`); solo esos
  6 tags + neutros (`Element`, `Deployment Node`, `Infrastructure Node`) definen color; `Pending` solo stroke ámbar `#F59E0B`.
  Réplicas Draw.io: color por página guardado en `dsl/layout/<vista>.json` campo `clase`. Cambiar la leyenda requiere PR + ADR +
  entrada en CHANGELOG raíz; las versiones congeladas conservan su notación. — [03-leyenda-c4.md](docs/lineamientos/03-leyenda-c4.md)
- `estandares/c4/estilos-c4.dsl` (bloque `styles {}`) se incluye en cada versión desde `dsl/views/styles.dsl` con
  `!include ../../../../../estandares/c4/estilos-c4.dsl`; `tema-c4-terpel.json` se genera con `scripts/gen_theme.py`;
  `leyenda-c4.svg` estático. Estilos de despliegue: `Deployment Node`/`Infrastructure Node` blanco con borde gris. —
  [estandares/c4/estilos-c4.dsl](estandares/c4/estilos-c4.dsl); [proyectos/volarte/v3/dsl/views/styles.dsl](proyectos/volarte/v3/dsl/views/styles.dsl)
- 04 Versionamiento: estados `borrador → en-revision → aprobada → reemplazada | obsoleta`; congeladas = aprobada/reemplazada/
  obsoleta (solo se permite editar `version.json`; el estado se evalúa en la rama base). Campos obligatorios de `version.json`
  (R8): `proyecto, nombre, version, estado, fecha, basadaEn, autores, aprobadores, workspace, changelog, descripcion`.
  Cambio de notación/estándar ⇒ **nueva versión**. — [04-versionamiento-y-trazabilidad.md](docs/lineamientos/04-versionamiento-y-trazabilidad.md) L24-73; [scripts/aac_versions.py](scripts/aac_versions.py) L35-39
- `CHANGELOG_DSL.md` (por proyecto): orden cronológico inverso, ID `AAC-AAAAMMDD-NN`, campos Versión, Fecha y Hora UTC/COT,
  Autor, Ref HU/Jira, Módulo/Archivo (rutas completas entre backticks, globs permitidos), Tipo de cambio, Contexto &
  Justificación, Impacto/ADR, Sugerencias del revisor, Revisores; tabla índice de versiones. —
  [proyectos/volarte/CHANGELOG_DSL.md](proyectos/volarte/CHANGELOG_DSL.md); [04 §3](docs/lineamientos/04-versionamiento-y-trazabilidad.md)
- `REVISION.md` por versión: comentarios `REV-NN` (✅ aplicado / 🟠 pendiente / ℹ️), con observación, decisión y acción; la
  versión solo se aprueba cuando los 🟠 tienen decisión; tabla de firma. v3 tiene REV-01..REV-14. —
  [05-revision-y-aprobacion.md](docs/lineamientos/05-revision-y-aprobacion.md) L55-70; [proyectos/volarte/v3/REVISION.md](proyectos/volarte/v3/REVISION.md)
- Layout de versión v3: `version.json`, `README.md`, `REVISION.md`, `dsl/{workspace.dsl, model/{personas,sistemas,portal,volarte}.dsl,
  model/componentes/vo_*.dsl, model/relaciones/<vista>.dsl, views/{vistas,styles}.dsl, layout/<vista>.json (13)}`,
  `docs/{adr (0001-0007), workspace (01-introduccion, 02-trazabilidad, 03-stack), generated/}`, `fuente/{mapeo-drawio.json,
  drawio-inventario.json, trazabilidad.json, TRAZABILIDAD.md}`. El `.drawio` real vive solo en `v1/fuente/Arquitectura_volarte_1.drawio`.
  — árbol de [proyectos/volarte/v3](proyectos/volarte/v3)
- `docs/generated/` por versión: `json/workspace.json`, `mmd/`, `puml/`, `svg/`, `png/` (×2), `png-hires/` (no versionado),
  PDF `<Nombre>_v<N>_Architecture_Specification.pdf`, `review/review-report.{md,json}`, `inspect-report.txt`, `BUILD_REPORT.md`;
  en c4-drawio además `fidelidad/` y `referencia-drawio/{svg,png}`. — [06-guia-structurizr.md](docs/lineamientos/06-guia-structurizr.md) §6; [.gitignore](.gitignore)
- Plantilla de proyecto (`estandares/plantillas/proyecto/v1`) usa el layout clásico en inglés (`people.dsl`, `systems.dsl`,
  `containers.dsl`, `relationships.dsl`, `deployment.dsl`, `views/views.dsl` con `L1_System_Context`, `L2_Containers`,
  `DEP_Produccion` todos con `autoLayout`), y su `version.json` no trae `render` ni `fidelidad`. —
  [estandares/plantillas/proyecto/v1/dsl/views/views.dsl](estandares/plantillas/proyecto/v1/dsl/views/views.dsl); [estandares/plantillas/version.json](estandares/plantillas/version.json)
- 07 DoD: `version.json`+README, vistas L1/L2/**despliegue**, L3, dinámicas; docs/workspace con stack; ADR; build sin errores;
  `REVISION.md`; si replica un Draw.io: fidelidad R9 sin diferencias. Máx. ~25 elementos por vista. —
  [07-consistencia-y-calidad.md](docs/lineamientos/07-consistencia-y-calidad.md)

### Inferences
- Una integración draw.io MCP debe respetar: (a) versión = carpeta inmutable una vez congelada; (b) cada cambio de `dsl/`
  con entrada R4 en la bitácora; (c) decisiones de mapeo como `REV-NN`; (d) "cambio de notación ⇒ nueva versión" (ArchiMate/GCP
  serían v4 de Volarte, no una edición de v3).
- La leyenda está acoplada a "C4"; añadir ArchiMate o iconos GCP exige ampliar el lineamiento 03 (leyenda por notación) vía
  PR + ADR + CHANGELOG raíz, como el propio 03 prescribe.

### Gaps
- No hay un lineamiento ni estándar para ArchiMate, viewpoints, ni para iconografía GCP; tampoco una carpeta `estandares/archimate`
  o `estandares/gcp` (búsqueda `archimate|gcp2|mxgraph.gcp` en scripts/docs/estandares: 0 resultados; única mención "proyecto GCP" en 03 L65).
- 02 §5 (layout DSL clásico + autoLayout obligatorio) está desactualizado respecto de v3 (nombres en español, sin autoLayout).

## 2. Pipeline: aac-build.sh, Agente Revisor, scripts y CI

### Takeaway
`scripts/aac-build.sh` orquesta 8 pasos por versión (validate → inspect → export → [4b escenas+fidelidad si `render=c4-drawio`] →
revisor R1–R9 → render → PDF → BUILD_REPORT). El motor de render se elige por `version.json.render` ∈ {`mermaid` (default),
`c4-drawio`}: es el punto natural para añadir un target `drawio`. CI = 2 jobs (validar+revisar bloqueante con comentario en PR;
compilar y publicar `docs/generated` en main).

### Cited Findings
- **Tamaños** (líneas): `aac-build.sh` 212 · `architecture_reviewer.py` 643 · `drawio2structurizr.py` 515 · `c4_scene.py` 347 ·
  `render-c4.mjs` 345 · `render-pdf.mjs` 310 · `drawio_inventory.py` 280 · `aac_versions.py` 118 · `render-diagrams.mjs` 107 ·
  `build_report.py` 81 · `gen_theme.py` 44 · `aac-nueva-version.sh` 39 · `browser.mjs` 21 · `aac-nuevo-proyecto.sh` 18 ·
  `mermaid-config.json` 17 · tests: `test_architecture_reviewer.py` 134, `test_drawio_fidelidad.py` 53 · workflow 210. — `wc -l` sobre [scripts/](scripts/)
- `aac-build.sh` flags: `<versión>…`, `--all`, `--changed <ref>` (también pasa `--base`), `--validate-only`, `--base REF`,
  `--skip-traceability`, `--strict` (→ `--warnings-as-errors`), `--ai`, `--force` (regenerar congelada). Env:
  `STRUCTURIZR_CLI_VERSION` (2025.05.28), `PUPPETEER_EXECUTABLE_PATH`, `AAC_HIRES_SCALE` (4). — [scripts/aac-build.sh](scripts/aac-build.sh) L18-56
- Pasos: 1 herramientas (descarga structurizr-cli, `gen_theme.py`) · 2 `structurizr validate` (bloqueante) · versiones congeladas:
  solo export JSON + revisor `--frozen` (R6, R8) y return · 3 `inspect` (informativo) · 4 export `json`, `mermaid`,
  `plantuml/c4plantuml` · 4b (solo `c4-drawio`) `drawio_inventory.py` sobre `fidelidad.fuente` → `c4_scene.py` (escenas + informe) ·
  5 revisor (bloqueante) · `--validate-only` termina aquí · 6 render (`render-c4.mjs` si c4-drawio, si no `render-diagrams.mjs`) ·
  7 `render-pdf.mjs` · 8 `build_report.py`. — [aac-build.sh](scripts/aac-build.sh) L80-212 (selector de motor L158-171 y L187-196)
- La CLI fijada (2025.05.28, structurizr-export 4.1.0) solo se usa con formatos json/mermaid/plantuml; su `lib/` incluye
  `structurizr-d2-exporter-1.5.3.jar` pero el pipeline no lo usa. No hay exportador draw.io en la cadena. — [aac-build.sh](scripts/aac-build.sh) L148-151; listado `.aac/structurizr-cli-2025.05.28/lib/`
- **Agente Revisor** (`scripts/architecture_reviewer.py`), carga `workspace.json` exportado + diff Git:
  - R1 Descripciones (ERROR): Person/SoftwareSystem/Container/Component con descripción (`rule_descriptions`, L200).
  - R2 Tecnologías (ERROR): Container/Component con tecnología (`rule_technologies`, L208).
  - R3 Aislamiento (ERROR): origen con tags `Frontend|Mobile` no puede ir a `Database, Cache, Storage, Queue, Topic, Subscription,
    DomainService` salvo dentro del mismo contenedor (`rule_layer_isolation`, L216; tags L64-65).
  - R4 Trazabilidad (ERROR): cambios en `<versión>/dsl/` ⇒ `CHANGELOG_DSL.md` modificado, nueva entrada referencia cada archivo
    (backticks/glob) y contiene los 7 campos (regex L75-83) (`rule_traceability`, L247).
  - R5 Sugerencias (WARN/INFO): SPOF (nodos de despliegue sin `ha=true`/instances>1 con estado o fan-in ≥4), Cifrado (regex
    TLS/HTTPS/mTLS/IAM/OIDC…, agrupado por tag `pagina:`), Observabilidad (contenedores con `BFF/DomainService/CloudRun/GKE/Frontend`
    sin relación a tag `Observability`), Resiliencia (`Subscription` sin `DLQ`), Decisión Pendiente (`Pending`) (`rule_suggestions`, L393).
  - R6 Inmutabilidad (ERROR): versión congelada en la base solo admite tocar `version.json` (`rule_immutability`, L281).
  - R7 Leyenda C4 (ERROR/WARN): los 6 tags con background exacto (`C4_LEGEND`, L50-57), `Person` con `shape Person`, ningún otro tag
    (salvo `Element`, `Deployment Node`, `Infrastructure Node`) define background/color/stroke (`Pending` solo stroke), persona
    `External` ⇒ tag `External Person`, sistema sin contenedores sin `External Software System` ⇒ WARN (`rule_c4_legend`, L302).
  - R8 Metadatos (ERROR): `version.json` existe, campos obligatorios, estado válido, `version` = carpeta, aprobada ⇒ aprobadores (L368).
  - R9 Fidelidad (ERROR/INFO): si `version.json.fidelidad` existe, lee `docs/generated/fidelidad/fidelidad-drawio.json` y eleva cada
    diferencia `tipo=ERROR`; si falta el informe, WARN (`rule_drawio_fidelity`, L337).
  - `--ai`: revisión narrativa opcional con modelo `AAC_REVIEWER_MODEL` (default `claude-opus-5-5`); `--frozen` solo R6+R8.
  — [scripts/architecture_reviewer.py](scripts/architecture_reviewer.py) L1-30, L45-85, L200-465, L566-639
- Orden de reglas en `main()` es una lista fija de generadores (no hay registro/plug-in de reglas). — [architecture_reviewer.py](scripts/architecture_reviewer.py) L605-620
- `render-diagrams.mjs` (motor mermaid): `renderMermaid` de mermaid-cli + leyenda al pie leída de `estilos-c4.dsl`. —
  [scripts/render-diagrams.mjs](scripts/render-diagrams.mjs) L1-40
- `render-pdf.mjs`: portada, leyenda, historial, docs/workspace, diagramas (por cada vista del workspace usa `svg/<key>.svg`; si no
  existe imprime "Diagrama no generado"), página de referencia Draw.io y métricas de fidelidad por vista, fichas por contenedor,
  catálogos, bitácora, ADR, reporte del revisor, anexos (fidelidad, trazabilidad…). — [scripts/render-pdf.mjs](scripts/render-pdf.mjs) L1-11, L100-133, L263-293
- `browser.mjs`: Puppeteer `headless: "shell"` (chrome-headless-shell fijado) o `PUPPETEER_EXECUTABLE_PATH`. `build_report.py`
  escribe `BUILD_REPORT.md`. `aac_versions.py`: `list [--editable|--changed]`, `info`, `meta_at`, `changed_files`. —
  [scripts/browser.mjs](scripts/browser.mjs); [scripts/build_report.py](scripts/build_report.py); [scripts/aac_versions.py](scripts/aac_versions.py)
- `aac-nueva-version.sh` copia `dsl/` (incluye `dsl/layout/`), `docs/adr`, `docs/workspace`; **no** copia `fuente/` ni
  `REVISION.md`; reescribe `version.json` (borrador). `aac-nuevo-proyecto.sh` copia la plantilla. —
  [scripts/aac-nueva-version.sh](scripts/aac-nueva-version.sh); [scripts/aac-nuevo-proyecto.sh](scripts/aac-nuevo-proyecto.sh)
- **Workflow** `.github/workflows/architecture-pipeline.yml`: triggers `pull_request` y `push` a `main` con paths
  `proyectos/**, estandares/**, scripts/**, package*.json, workflow`, más `workflow_dispatch` (input `ai_review`); concurrency por ref;
  Java 21, Node 22, Python 3.12.
  - Job `validate-and-review`: checkout `fetch-depth: 0`, cache CLI, `python3 -m unittest discover -s scripts/tests`, `pip install
    anthropic` (PR o ai_review), base = `origin/<base_ref>` / `github.event.before` / `--skip-traceability`, `aac-build.sh --all
    --validate-only` (+`--ai` si hay `ANTHROPIC_API_KEY`), consolida `aac-review-summary.md` (tabla versiones/estado + reportes de
    versiones editables) → `GITHUB_STEP_SUMMARY`, comenta/actualiza en el PR con marcador `<!-- aac-architecture-review -->`
    (truncado a 60 000 chars, solo PR del mismo repo), artefacto `architecture-review`.
  - Job `build-artifacts` (needs anterior, `contents: write`): `npm ci`, `aac-build.sh --changed <base> --skip-traceability` (o `--all`),
    resumen de BUILD_REPORT, artefacto `architecture-<sha>` (`proyectos/*/v*/docs/generated/`, 30 días), y en push a main commitea
    `docs(aac): regenerar artefactos de arquitectura [skip ci]` como `aac-pipeline[bot]`.
  — [.github/workflows/architecture-pipeline.yml](.github/workflows/architecture-pipeline.yml)
- Tests: `test_architecture_reviewer.py` (13 casos: R1/R2, R3 ×3, R5, R7 ×4, R6 ×2, R8 sobre versiones reales) y
  `test_drawio_fidelidad.py` (7 casos: `split_label`, `camel` ASCII, escape de comillas, HTML→texto, escenas idénticas fieles,
  detecta color/texto/etiqueta, espacio antes de tecnología). No hay tests de `render-c4.mjs`, `drawio_inventory.inventory()` sobre
  un archivo real, ni de `write_views/write_layouts`. — [scripts/tests/](scripts/tests/)

### Inferences
- Extensión mínima para un target drawio: nuevo valor `render` (o lista `salidas`) en `version.json` + rama en `aac-build.sh`
  L158-196 + nuevo script (p. ej. `scripts/render-drawio.py|mjs`) que consuma las mismas escenas (`*.modelo.json`) o el
  `workspace.json`. El workflow no necesita cambios estructurales (los artefactos van en `docs/generated/`, ya subidos y publicados).
- El MCP de draw.io es una herramienta interactiva (agente), no un paso de CI; el pipeline CI tendría que generar `.drawio`
  de forma determinista (script), dejando el MCP para autoría/edición asistida y luego reimportar por `drawio_inventory.py`.

### Gaps
- No se verificó la ejecución del build (lectura estática); duración ~15 s validate / ~2 min completo según README, no medida.

## 3. Cómo funciona Volarte v3 (draw.io → inventario → DSL + layout → escena → SVG; R9)

### Takeaway
v3 es un "round-trip de un solo sentido": el `.drawio` (13 páginas, librería C4) se inventaría, se mapea con un JSON curado a un
modelo C4 deduplicado + una presentación por vista (`dsl/layout/*.json`), y un renderer SVG propio dibuja tanto el modelo como la
página original para comparar (R9: 182/182 elementos, 190/190 conectores, 100 % en las 13 vistas). El renderer solo conoce 4 formas
(persona, cilindro, caja redondeada, nota) y no soporta stencils/iconos (`mxgraph.gcp2.*`, `mxgraph.archimate3.*`) ni imágenes.

### Cited Findings
- `version.json` v3: `"render": "c4-drawio"`, `"fidelidad": {"fuente": "../v1/fuente/Arquitectura_volarte_1.drawio", "mapeo":
  "fuente/mapeo-drawio.json", "importador": "scripts/drawio2structurizr.py"}`, estado `en-revision`. —
  [proyectos/volarte/v3/version.json](proyectos/volarte/v3/version.json)
- Fuente: draw.io 27.0.9, 13 páginas (`L0 · Referencia`, `L1 · Context`, `L2 · Container`, 10 × `L3 · …`). Formas en el inventario:
  elementos `rounded` 158, `cylinder3` 15, `mxgraph.c4.person2` 8; boundaries `rounded` 29; notas `rounded` 16, `partialRectangle` 6,
  `cylinder3` 1, `table` 1. El único stencil `mxgraph.*` del archivo es `mxgraph.c4.person2` (8); 0 `image=`. — análisis de
  [proyectos/volarte/v3/fuente/drawio-inventario.json](proyectos/volarte/v3/fuente/drawio-inventario.json) y grep sobre [v1/fuente/Arquitectura_volarte_1.drawio](proyectos/volarte/v1/fuente/Arquitectura_volarte_1.drawio)
- **`drawio_inventory.py`**: descomprime páginas (deflate+base64), recorre `mxCell`/`object`/`UserObject`; clasifica: con
  `c4Type`/`c4Name` ⇒ elemento C4 (o boundary si `c4Type` contiene "Boundary"); `shape=mxgraph.c4.person2` o "[Persona]" ⇒ persona;
  cualquier otra forma con texto ⇒ **nota**; forma sin texto con relleno ⇒ nota decorativa; edges con waypoints, puntos libres,
  etiquetas hijas `edgeLabel` (descarta "Text"), extremos inferidos por geometría (tolerancia 20 px), pertenencia a boundary por
  geometría. Mapea `fillColor` → clase de leyenda con `LEGEND` (6 colores). — [scripts/drawio_inventory.py](scripts/drawio_inventory.py) L24-27, L95-275 (clasificación L140-159)
- **`drawio2structurizr.py`** (`Generator`): usa `mapeo-drawio.json` (claves `sistemas`, `paginas`{vista,tipo,alcance,titulo,descripcion},
  `compartidos`, `porElemento`, `boundariesPlataformaL0`, `notasComoElemento`, `expansiones`, `tagsSemanticos`, `enriquecimiento`) y
  `classify()` por prefijo de página `L0/L1/L2/L3` con refs `pe_`, `ss_`, `po_` (portal), `vo_` (volarte) y `PAGE_PREFIX` por página
  L3. Escribe `model/personas.dsl`, `sistemas.dsl`, `portal.dsl`, `volarte.dsl`, `componentes/<c>.dsl`, `relaciones/<vista>.dsl`
  (tag `pagina:<vista>`), `views/vistas.dsl` (solo `container`/`systemContext`/`component`, sin autoLayout, con `exclude
  "relationship.tag!=pagina:<vista>"` y properties `drawio.pagina`, `aac.layout`), `layout/<vista>.json` (nodos con `forma`
  ∈ {persona, cilindro, caja, nota}, `clase`, `style` crudo, `fuentes`, `texto` alias; boundaries; notas; conectores con puntos,
  extremos, estilo crudo) y `fuente/trazabilidad.json` + `TRAZABILIDAD.md`. Propiedades por elemento: `c4.tipo`, `c4.tecnologia`,
  `drawio.ocurrencias`, `drawio.boundary`. — [scripts/drawio2structurizr.py](scripts/drawio2structurizr.py) L1-41, L93-139, L274-460; [fuente/mapeo-drawio.json](proyectos/volarte/v3/fuente/mapeo-drawio.json)
- **`c4_scene.py`**: escena MODELO = `workspace.json` + `layout/<vista>.json` (textos del modelo, colores de `LEGEND_COLORS` por
  `clase`, sustitución de la tabla "Legend" dibujada por la leyenda oficial); escena DRAWIO = inventario. `compare()` cuenta
  elementos/textos/colores/formas/conectores/etiquetas; diferencias de presencia, texto (nombre/tipo/tecnología/descripción), color y
  etiqueta son ERROR; `fidelidad = ok / (3·elementos + 2·conectores)`. Escribe `escenas/*.modelo.json|*.drawio.json` y
  `fidelidad-drawio.{json,md}`. Itera **solo** sobre `dsl/layout/*.json`. — [scripts/c4_scene.py](scripts/c4_scene.py) L26-30, L144-205, L207-231, L234-283, L286-306
- **`render-c4.mjs`**: dibuja en Chromium (Puppeteer) un SVG a mano. Soporta: boundaries (rect punteado, `strokeColor`, `dashPattern`,
  `arcSize`, `absoluteArcSize`, `fontColor`, `fontSize`); notas (`fillColor`, `strokeColor`, `fontColor`, `rounded`, `arcSize`,
  casos `table` y `partialRectangle`); conectores (`edgeStyle` orthogonal/elbow con enrutado propio, waypoints, `exitX/Y/Dx/Dy`,
  `entryX/Y…`, `rounded`, `strokeColor`, `strokeWidth`, `dashed`, `endArrow`/`startArrow` mapeados a 3 marcadores classic/block/open,
  posición de etiqueta relativa + offset); nodos `persona` (círculo + rect), `cilindro`, `nota`, y por defecto rect redondeado
  (`arcSize`) con 3 bloques de texto (nombre negrita, `[tipo: tecnología]`, descripción) y leyenda C4 fija de 6 colores. Salidas
  `svg/`, `png/` ×2, `png-hires/` ×N y `referencia-drawio/{svg,png}`. — [scripts/render-c4.mjs](scripts/render-c4.mjs) L29-292, L310-345
- No soportado por el renderer (inferido del código: no hay ramas para ello): `shape=` stencils distintos de los 4 casos (cualquier
  `mxgraph.gcp2.*`, `mxgraph.archimate3.*`, `mxgraph.aws*`, `hexagon`, `folder`…), `image=`/SVG embebidos, gradientes, sombras,
  rotación, `curved=1`, swimlanes/contenedores colapsables, capas, `labelPosition/verticalLabelPosition` (etiquetas bajo iconos),
  texto HTML enriquecido, flechas ArchiMate (diamante, triángulo hueco, círculo). — [scripts/render-c4.mjs](scripts/render-c4.mjs) L223-246 (único `if/else` de formas)
- Mapeo de forma en el importador: `{"mxgraph.c4.person2": "persona", "cylinder3": "cilindro"}.get(shape, "caja")` — un icono GCP
  importado sería "caja". — [drawio2structurizr.py](scripts/drawio2structurizr.py) L425
- Resultado R9 v3: "✅ FIEL · 0 diferencias · 182/182 elementos · 190/190 conectores · 3 anotaciones · 30 alias", 100 % en las 13
  vistas; revisor: 0 errores, 40 WARN (mayoría R5-Cifrado y R5-Observabilidad), 4 INFO. —
  [docs/generated/fidelidad/fidelidad-drawio.md](proyectos/volarte/v3/docs/generated/fidelidad/fidelidad-drawio.md); [docs/generated/review/review-report.md](proyectos/volarte/v3/docs/generated/review/review-report.md)
- ADR 0007: el DSL de v3 es fuente de verdad; el importador solo se vuelve a usar si cambia el Draw.io; mover elementos = editar
  `dsl/layout/`. La guía 06 §8 dice lo mismo ("los cambios se hacen en el DSL… no en el Draw.io"). —
  [docs/adr/0007-replica-fiel-del-drawio-y-render-c4.md](proyectos/volarte/v3/docs/adr/0007-replica-fiel-del-drawio-y-render-c4.md); [06-guia-structurizr.md](docs/lineamientos/06-guia-structurizr.md) §8
- REV-12: v3 **eliminó** la vista de despliegue `DEP_Produccion_GCP`, las 4 dinámicas (D1–D4) y las relaciones OTel de v2 para
  mantener fidelidad; se recomienda reincorporarlas en v4. v2 tenía `deployment.dsl` con nodos `Google Cloud Platform` → proyectos
  `terpel-infra-vpc-transversal`, `terpel-gtic-apigee-prd`, … (tags `GCP`, `GCPProject`, `VPC`, `LoadBalancer`, `Firewall`, `Gateway`)
  y vista `deployment volarte prd "DEP_Produccion_GCP" { include * autoLayout lr }`. —
  [v3/REVISION.md](proyectos/volarte/v3/REVISION.md) REV-12; [v2/dsl/model/deployment.dsl](proyectos/volarte/v2/dsl/model/deployment.dsl); [v2/dsl/views/deployment.dsl](proyectos/volarte/v2/dsl/views/deployment.dsl)

### Inferences
- **Nada produce hoy `.drawio`** (búsqueda de `mxfile`/`mxGraphModel` en scripts: solo lectura en `drawio_inventory.py`; las
  "`*.drawio.json`" de `c4_scene.py` son escenas JSON, no archivos draw.io). El flujo es estrictamente draw.io → modelo.
- La escena (`*.modelo.json`) ya contiene casi todo para emitir mxGraph XML (geometría absoluta, `style` original de cada forma,
  boundaries, waypoints, estilo de conector): un exportador escena → `.drawio` es la extensión de menor costo y permitiría
  round-trip con el MCP (abrir/editar en draw.io → reimportar → R9).
- Para GCP/ArchiMate la cadena actual perdería semántica en el inventario (se volverían notas) y en el render (cajas).
- La versión v3 incumple el DoD propio (07 §2: despliegue obligatorio) por decisión documentada (REV-12) — una vista de
  despliegue GCP es un hueco reconocido, candidata natural para v4.

### Gaps
- No se comprobó visualmente el SVG frente a draw.io; la "fidelidad" R9 compara datos (texto/color/presencia), no píxeles.
- `formasIguales` se cuenta pero una forma distinta **no** genera ERROR en `compare()` (pese a que 05 §3 dice que R9 verifica formas).

## 4. ¿Hay salida .drawio, ArchiMate o GCP? ¿Qué soporta `render`?

### Takeaway
No: no hay generación model → drawio, ni ArchiMate, ni iconos GCP en ninguna parte. `version.json.render` solo admite `mermaid`
(default) y `c4-drawio`; cualquier otro valor cae silenciosamente en mermaid.

### Cited Findings
- Selector: `RENDER=…get('render','mermaid')`; `if [[ "$RENDER" == "c4-drawio" ]] … else node scripts/render-diagrams.mjs`. —
  [scripts/aac-build.sh](scripts/aac-build.sh) L160-161, L190-195
- Tabla de motores: `c4-drawio` (c4_scene + render-c4, recomendado) y `mermaid` (versiones antiguas, personas como cajas). En ambos se
  exportan JSON, Mermaid, C4-PlantUML. — [06-guia-structurizr.md](docs/lineamientos/06-guia-structurizr.md) §7
- Búsqueda `archimate|gcp2|mxgraph.gcp` en scripts, docs, estandares, DSL v3: sin coincidencias. "GCP" solo aparece como texto/tags
  en DSL v1/v2 (despliegue) y como "proyecto GCP" en 03. — grep en el repositorio
- `render-pdf.mjs` tiene el nombre `Arquitectura_volarte_1.drawio` cableado en el texto de la página de referencia. —
  [scripts/render-pdf.mjs](scripts/render-pdf.mjs) L119

### Inferences
- Un valor desconocido de `render` (p. ej. `drawio`) hoy no falla: produciría Mermaid sin aviso. Convendría validar el enum en R8.
- `render` es escalar (un motor por versión); para "C4 + ArchiMate + GCP + .drawio" en una versión haría falta un campo lista
  (p. ej. `salidas: ["c4-drawio","drawio"]`) o `render` por vista (propiedad de vista, análogo a `aac.layout`).

### Gaps
- No se encontró documentación de un formato objetivo para `.drawio` generado (librerías a usar, ids estables, páginas).

## 5. Puntos de extensión concretos y cambios necesarios en el revisor; deuda técnica

### Takeaway
Los enganches naturales son: `version.json` (`render`/`fidelidad`), `aac-build.sh` paso 4b/6, las escenas de `c4_scene.py`
(contrato JSON), el `if/else` de formas de `render-c4.mjs`, la clasificación de `drawio_inventory.py`, `classify()`/`write_views()`
del importador, el bloque de estilos `estandares/` y las constantes de leyenda/tag del revisor (R3/R5/R7). La deuda principal es el
acoplamiento a Volarte y a C4 (leyenda duplicada en 5 sitios, prefijos de página y refs cableados).

### Cited Findings (ubicaciones)
- **Target `drawio` (model → .drawio)**:
  - `scripts/aac-build.sh` L158-196: añadir rama (p. ej. paso 6b `node|python scripts/render-drawio.* "$WORK/escenas" "$OUT/drawio"`).
  - `scripts/c4_scene.py` `model_scene()` L144 / `main()` L286: las escenas ya llevan `x,y,w,h,style,fill,clase,forma,textos,puntos,
    extremos,estilo` — insumo directo para mxGraph; falta escena para vistas **sin** layout (deployment/dynamic) — hoy solo itera `layouts/*.json` (L296).
  - `scripts/render-pdf.mjs` L100-133: podría enlazar/adjuntar el `.drawio` por vista.
  - `.github/workflows/architecture-pipeline.yml`: sin cambios (artefacto `docs/generated/` ya cubre `drawio/`).
- **ArchiMate 3.2 (viewpoints)**:
  - Modelo: Structurizr DSL no tiene tipos ArchiMate; la vía existente es `element "<nombre>" "<metadata>"` (custom element, ya usado
    por `drawio2structurizr.py` `element_dsl()` L301-319 para `kind == "custom"`) + tags/properties (p. ej. `archimate.tipo`, `archimate.capa`).
  - Inventario: `drawio_inventory.py` L140-159 — agregar rama para `shape=mxgraph.archimate3.*` (hoy caen en notas).
  - Importador: `classify()` L93-139 decide por prefijo de página `L0/L1/L2/L3`; haría falta un clasificador por notación/estilo.
  - Vistas: `write_views()` L379-409 solo emite `container|systemContext|component`; ArchiMate necesitaría vistas `custom` o
    `systemLandscape` filtradas por tag con layout propio.
  - Render: `render-c4.mjs` L223-246 — nuevas formas/notaciones (iconos por tipo ArchiMate, flechas de relación ArchiMate).
  - Estilos: nuevo `estandares/archimate/estilos-archimate.dsl` (colores por capa) incluido junto a `estilos-c4.dsl`.
- **Vista de despliegue GCP**:
  - Modelo: reutilizar `v2/dsl/model/deployment.dsl` (tags `GCP`, `GCPProject`, `VPC`, `LoadBalancer`, `Firewall`, `Gateway`, `Device`,
    `Edge`, `Security`) y propiedad `ha` que ya consume R5-SPOF (`rule_suggestions` L396-416).
  - Iconos: Structurizr soporta `icon` en estilos; hoy no hay estilos por tag GCP en `estilos-c4.dsl` ni soporte de `image` en `render-c4.mjs`.
  - Render: con `render=c4-drawio` una vista `deployment` sin `dsl/layout/<vista>.json` no tendría SVG (c4_scene solo itera layouts) y el
    PDF mostraría "Diagrama no generado" (`render-pdf.mjs` L105-107).
- **Revisor — reglas a ajustar**:
  - R7 (`rule_c4_legend` L302-334, `C4_LEGEND` L50-57, `COLOR_ALLOWED_TAGS` L59): hoy prohíbe que cualquier tag no-C4 defina
    `background/color/stroke` ⇒ un estilo ArchiMate por capa o GCP fallaría. Requiere leyenda **por notación** (p. ej. tags
    `ArchiMate:*` con su paleta permitida, nodos GCP con icono) y ámbito por vista.
  - R1/R2 (L200-213) solo miran Person/SoftwareSystem/Container/Component; los custom elements ArchiMate no se revisan (falta R1 para `CustomElement`).
  - R3 (L216-232) y R5 (L393-465) dependen de tags C4 (`Frontend`, `BFF`, `DomainService`, `Observability`, `Subscription`, `DLQ`);
    elementos ArchiMate/GCP tendrían que mapear a esa taxonomía o quedar fuera.
  - R8 (L368-390, `aac_versions.REQUIRED_FIELDS`): validar valores de `render` y la nueva estructura (`salidas`, `notaciones`).
  - R9 (L337-365 + `c4_scene.compare`): extender a round-trip (`.drawio` generado vuelve a inventariarse y debe ser idéntico) y a
    formas/iconos (hoy forma distinta no es error).
  - Tests a ampliar: `scripts/tests/test_architecture_reviewer.py` (R7 por notación), `test_drawio_fidelidad.py` (round-trip).
- **Deuda técnica observada**:
  - Leyenda duplicada/cableada en 5 lugares con valores de borde inconsistentes: `estilos-c4.dsl` (stroke Person `#052E57`),
    `architecture_reviewer.py` `C4_LEGEND`, `drawio_inventory.py` `LEGEND`, `c4_scene.py` `LEGEND_COLORS` (stroke Person `#06315C`,
    Container… distintos), `render-c4.mjs` L280. Solo `render-diagrams.mjs` lee la fuente única. — archivos citados arriba
  - Acoplamiento a Volarte en el importador: `PAGE_PREFIX` (L36-40) con nombres de páginas de Volarte, `CANON_ORDER`, refs `portal`/
    `volarte` cableados en `write()` (L337-357) y `classify()` (prefijos `po_`/`vo_`, página `L0`). No es reutilizable para otro proyecto
    sin editar código. — [scripts/drawio2structurizr.py](scripts/drawio2structurizr.py)
  - `render-pdf.mjs` L119 cablea `Arquitectura_volarte_1.drawio`.
  - `drawio_inventory.py` docstring cita `scripts/drawio_fidelity.py` (no existe; la lógica está en `c4_scene.py`); líneas duplicadas
    `by_id`/`bound_ids` (L210-213); bucle no-op `e["style"] = e["style"]`; variable `desc_color` con lógica confusa en `label_fonts`.
  - Docs desactualizadas: 02 §5 (layout DSL y "autoLayout en todas las vistas") y 04 §1 (ejemplo con v2 editable) frente a v3;
    README dice "reglas R1–R8" en Propósito y R1–R9 más abajo.
  - `aac-nueva-version.sh` no copia `fuente/` ni crea `REVISION.md`; `fidelidad.mapeo` relativo (`fuente/mapeo-drawio.json`) quedaría
    roto en v4 (solo informativo hoy). `fidelidad.fuente` relativo a v1 sí funcionaría.
  - Escenas y fidelidad solo para vistas con layout; vistas sin layout en una versión c4-drawio quedan sin diagrama.
  - `render` desconocido cae a mermaid sin error; reglas del revisor en lista fija (sin registro de reglas por notación).
  - Sin tests de render ni de inventario sobre archivo real; artefactos binarios (PNG/PDF) versionados en Git y regenerados por bot.
  - `.aac/` contiene scripts ad-hoc (`v3-regen.sh`) y muchos temporales (ignorado por git, pero evidencia de que la regeneración de v3
    se hizo fuera de `aac-build.sh`).

### Inferences
- Propuesta coherente con el diseño: (1) `scripts/render-drawio.*` que convierta escenas → `.drawio` multipágina usando la librería
  C4 de draw.io (`c4Type`, `c4Name`… para que `drawio_inventory.py` lo relea sin cambios ⇒ R9 round-trip gratis); (2) campo de
  notación por vista (`properties { "aac.notacion" "archimate|c4|gcp" }`) junto a `aac.layout`; (3) leyendas por notación en
  `estandares/<notacion>/` y R7 parametrizado; (4) vista `DEP_Produccion_GCP` recuperada de v2 en una v4, con iconos `mxgraph.gcp2.*`
  solo en la salida drawio/escena; (5) el MCP de draw.io como herramienta de autoría (crear/editar páginas y buscar shapes) cuyo
  resultado entra al repo como `fuente/*.drawio` y pasa por el pipeline existente.
- Centralizar la leyenda (leer `estilos-*.dsl` o un JSON de leyenda en `estandares/`) es prerequisito para añadir notaciones sin
  multiplicar la duplicación.

### Gaps
- No se evaluó qué shapes/estilos exactos genera el MCP de draw.io ni los nombres de stencils GCP/ArchiMate (fuera del alcance:
  solo repositorio local).
- No se midió el rendimiento ni la estabilidad de ids al regenerar (`drawioId` es la clave de trazabilidad; un `.drawio` generado debe
  conservar ids para que R9 y `trazabilidad.json` sigan funcionando).
