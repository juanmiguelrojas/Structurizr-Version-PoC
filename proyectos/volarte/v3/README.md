# Arquitectura Volarte · v3 (en revisión) — réplica fiel del Draw.io

- **Estado:** 🟠 en-revision · **Fecha:** 2026-10-09 · **Basada en:** [`v2`](../v2/) · **Bitácora:** `AAC-20261009-02`
- **Fuente:** [`../v1/fuente/Arquitectura_volarte_1.drawio`](../v1/fuente/Arquitectura_volarte_1.drawio) (13 páginas)
- **Especificación:** [`docs/generated/Arquitectura_Volarte_v3_Architecture_Specification.pdf`](docs/generated/Arquitectura_Volarte_v3_Architecture_Specification.pdf)
  — incluye, por cada vista, la página original del Draw.io para comparar
- **Revisión:** [`REVISION.md`](REVISION.md) — comentarios de validación REV-01 … REV-14
- **Fidelidad:** [`docs/generated/fidelidad/fidelidad-drawio.md`](docs/generated/fidelidad/fidelidad-drawio.md) ·
  **Trazabilidad:** [`fuente/TRAZABILIDAD.md`](fuente/TRAZABILIDAD.md) ·
  **Agente Revisor:** [`docs/generated/review/review-report.md`](docs/generated/review/review-report.md)

## Qué es v3

Las 13 páginas del Draw.io como 13 vistas Structurizr que se ven **igual** que el original: mismos elementos, textos,
colores por página (leyenda C4), **personas con silueta de actor**, boundaries, resaltados, conectores y disposición.

| Vista | Página Draw.io | PNG | Referencia Draw.io |
|---|---|---|---|
| `L0_Referencia` | L0 · Referencia | [png](docs/generated/png/L0_Referencia.png) | [png](docs/generated/referencia-drawio/png/L0_Referencia.png) |
| `L1_Context` | L1 · Context | [png](docs/generated/png/L1_Context.png) | [png](docs/generated/referencia-drawio/png/L1_Context.png) |
| `L2_Container` | L2 · Container | [png](docs/generated/png/L2_Container.png) | [png](docs/generated/referencia-drawio/png/L2_Container.png) |
| `L3_Frontend_Web` | L3 · Frontend Web | [png](docs/generated/png/L3_Frontend_Web.png) | [png](docs/generated/referencia-drawio/png/L3_Frontend_Web.png) |
| `L3_App_Movil` | L3 · App Movil | [png](docs/generated/png/L3_App_Movil.png) | [png](docs/generated/referencia-drawio/png/L3_App_Movil.png) |
| `L3_BFF_Web` | L3 · BFF Web | [png](docs/generated/png/L3_BFF_Web.png) | [png](docs/generated/referencia-drawio/png/L3_BFF_Web.png) |
| `L3_BFF_Movil` | L3 · BFF Movil | [png](docs/generated/png/L3_BFF_Movil.png) | [png](docs/generated/referencia-drawio/png/L3_BFF_Movil.png) |
| `L3_Pub_Sub` | L3 · Pub-Sub | [png](docs/generated/png/L3_Pub_Sub.png) | [png](docs/generated/referencia-drawio/png/L3_Pub_Sub.png) |
| `L3_Documentos_GCS` | L3 · Documentos GCS | [png](docs/generated/png/L3_Documentos_GCS.png) | [png](docs/generated/referencia-drawio/png/L3_Documentos_GCS.png) |
| `L3_Svc_Usuarios_Auth` | L3 · Svc Usuarios Auth | [png](docs/generated/png/L3_Svc_Usuarios_Auth.png) | [png](docs/generated/referencia-drawio/png/L3_Svc_Usuarios_Auth.png) |
| `L3_Gestor_Documental` | L3 · Gestor Documental | [png](docs/generated/png/L3_Gestor_Documental.png) | [png](docs/generated/referencia-drawio/png/L3_Gestor_Documental.png) |
| `L3_Svc_Operacion` | L3 · Svc Operacion | [png](docs/generated/png/L3_Svc_Operacion.png) | [png](docs/generated/referencia-drawio/png/L3_Svc_Operacion.png) |
| `L3_Svc_Comercial` | L3 · Svc Comercial | [png](docs/generated/png/L3_Svc_Comercial.png) | [png](docs/generated/referencia-drawio/png/L3_Svc_Comercial.png) |

## Estructura

| Ruta | Contenido |
|---|---|
| `dsl/model/` | Modelo C4 generado desde el Draw.io: personas, sistemas, `portal.dsl`, `volarte.dsl`, `componentes/`, `relaciones/<vista>.dsl` |
| `dsl/views/vistas.dsl` | Una vista por página (sin autoLayout; cada vista solo muestra las relaciones de su página) |
| `dsl/layout/<vista>.json` | Presentación: posición, boundaries, clase de color y textos de cada página |
| `fuente/mapeo-drawio.json` | Decisiones curadas del importador (cada una referenciada en `REVISION.md`) |
| `fuente/drawio-inventario.json` · `trazabilidad.json` · `TRAZABILIDAD.md` | Inventario de la fuente y trazabilidad forma → elemento |
| `docs/generated/` | SVG / PNG / PNG alta resolución, referencia Draw.io, Mermaid, PlantUML, PDF, fidelidad, reportes |

## Cómo editar a partir de v3

El DSL de v3 es la fuente de verdad. Para cambiar la arquitectura se crea `v4` (`scripts/aac-nueva-version.sh proyectos/volarte`)
y se edita el DSL; para mover un elemento en un diagrama se edita su posición en `dsl/layout/<vista>.json`. El importador
solo se vuelve a ejecutar si cambia el Draw.io de origen (ver `docs/lineamientos/06-guia-structurizr.md` §8).

## Para aprobar esta versión

Ver [`docs/lineamientos/05-revision-y-aprobacion.md`](../../../docs/lineamientos/05-revision-y-aprobacion.md) §6: la Dirección
de Arquitectura revisa el PDF y `REVISION.md`, decide los REV pendientes 🟠, registra aprobadores en `version.json`
(`"estado": "aprobada"`) y la entrada de aprobación en la bitácora.
