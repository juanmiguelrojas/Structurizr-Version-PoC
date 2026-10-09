# CHANGELOG · Lineamientos, estándares y herramientas

Cambios del **marco de trabajo** (lineamientos, leyenda C4, plantillas, scripts, pipeline). Los cambios de
arquitectura de cada proyecto se registran en `proyectos/<proyecto>/CHANGELOG_DSL.md`.

## [3.0.0] · 2026-10-09

### Agregado
- **Importador Draw.io → Structurizr** (`scripts/drawio_inventory.py`, `scripts/drawio2structurizr.py`): inventario de la
  fuente (formas, colores, geometría, boundaries, conectores con waypoints) y generación del DSL (modelo C4 deduplicado con
  procedencia `drawio.ocurrencias`), una vista por página y la **presentación por vista** (`dsl/layout/<vista>.json`).
- **Motor de render C4 con notación Draw.io** (`scripts/render-c4.mjs`): personas con **silueta de actor**, cilindros,
  boundaries punteados con bloque de título, conectores ortogonales con los waypoints originales, leyenda oficial y
  render de referencia de la página Draw.io original.
- **Validación de fidelidad** (`scripts/c4_scene.py`) y regla **R9-Fidelidad Draw.io** del Agente Revisor.
- `REVISION.md` por versión: comentarios de validación `REV-NN`.

### Cambiado
- R7 exige personas con silueta (estilo `Person` con `shape Person`).
- R5-Cifrado agrupa los hallazgos por vista.
- `aac-build.sh` elige el motor de render declarado en `version.json` (`render`: `mermaid` | `c4-drawio`).
- PDF: por cada vista se incluye la página original del Draw.io y sus métricas de fidelidad; anexos de revisión,
  fidelidad y trazabilidad.

## [2.0.0] · 2026-10-09

### Agregado
- **Lineamientos** en `docs/lineamientos/`: propósito y alcance, modelado C4, leyenda oficial C4, versionamiento y
  trazabilidad, revisión y aprobación, guía de Structurizr, consistencia y calidad.
- **Leyenda oficial C4** como estándar único en `estandares/c4/estilos-c4.dsl` (+ tema JSON y `leyenda-c4.svg`).
- **Estructura multi-proyecto y multi-versión**: `proyectos/<proyecto>/v<N>/` con `version.json` y bitácora por proyecto.
- Plantillas (`estandares/plantillas/`) y scripts `aac-nuevo-proyecto.sh`, `aac-nueva-version.sh`, `aac_versions.py`.
- Agente Revisor: reglas **R6 Inmutabilidad**, **R7 Leyenda C4**, **R8 Metadatos**; R4 ahora exige el campo *Versión*.
- Leyenda C4 embebida en cada SVG/PNG; PDF con leyenda, historial de versiones, documentación, fichas técnicas por
  contenedor y catálogo de tecnologías y protocolos.
- Plantilla de PR y `CODEOWNERS`.

### Cambiado
- `aac-build.sh` recibe la versión a compilar (`proyectos/<p>/v<N>`, `--all`, `--changed <base>`); las versiones
  congeladas solo se validan.
- Pipeline CI compila solo las versiones modificadas y publica sus artefactos en `main`.

### Corregido
- Render en CI: `aac-build.sh` usaba el Chrome del sistema del runner (`/usr/bin/google-chrome`), de versión distinta a
  la de Puppeteer, y su arranque excedía el timeout de 30 s (`Timed out … waiting for the WS endpoint URL`).
  Ahora se usa el `chrome-headless-shell` fijado por Puppeteer mediante `scripts/browser.mjs` (timeout 120 s).

### Migración
- El contenido previo (raíz `dsl/`, `docs/`) se movió a `proyectos/volarte/v1/` sin modificaciones y quedó congelado.

## [1.0.0] · 2026-10-08

- Baseline: conversión del Draw.io de Volarte a Structurizr DSL, `aac-build.sh`, Agente Revisor (R1–R5),
  pipeline `architecture-pipeline.yml`.
