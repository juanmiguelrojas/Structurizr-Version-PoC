# Arquitectura Volarte · v2 (en revisión)

- **Estado:** 🟠 en-revision · **Fecha:** 2026-10-09 · **Basada en:** [`v1`](../v1/) · **Bitácora:** `AAC-20261009-01`
- **Especificación:** [`docs/generated/Arquitectura_Volarte_v2_Architecture_Specification.pdf`](docs/generated/Arquitectura_Volarte_v2_Architecture_Specification.pdf)
- **Reporte de compilación:** [`docs/generated/BUILD_REPORT.md`](docs/generated/BUILD_REPORT.md) ·
  **Agente Revisor:** [`docs/generated/review/review-report.md`](docs/generated/review/review-report.md)

## Qué cambió frente a v1

| # | Cambio | Archivos |
|---|---|---|
| 1 | **Leyenda oficial C4** en todos los diagramas, imágenes y PDF (Person `#083F75`, Software System `#1061B0`, Container `#23A2D9`, Component `#63BEF2`, External Person `#6C6477`, External Software System `#8C8496`) | `dsl/views/styles.dsl` → `estandares/c4/estilos-c4.dsl` |
| 2 | Tags `External Person` / `External Software System` en todo lo que está fuera del alcance de Volarte | `dsl/model/people.dsl`, `dsl/model/systems.dsl` |
| 3 | Tags semánticos solo cambian forma o borde (sin colores propios) | `estandares/c4/estilos-c4.dsl` |
| 4 | Leyenda C4 al pie de cada SVG/PNG y página de leyenda en el PDF | `scripts/render-diagrams.mjs`, `scripts/render-pdf.mjs` |
| 5 | Telemetría `→ OTel Collector` en los 5 servicios de dominio y el Gestor Documental (según L0 del Draw.io) | `dsl/model/relationships.dsl` |
| 6 | Documentación ampliada: stack tecnológico por capa, fichas técnicas por contenedor, catálogo de tecnologías y protocolos, historial de versiones en el PDF | `docs/workspace/03-stack-tecnologico.md`, PDF |
| 7 | ADR 0006 · Leyenda oficial C4 y versionamiento por carpetas | `docs/adr/0006-…md` |

## Para aprobar esta versión

Seguir [`docs/lineamientos/05-revision-y-aprobacion.md`](../../../docs/lineamientos/05-revision-y-aprobacion.md) §6:
la Dirección de Arquitectura revisa el PDF, se registran los aprobadores en `version.json`
(`"estado": "aprobada"`) y se agrega la entrada de aprobación en la bitácora.
