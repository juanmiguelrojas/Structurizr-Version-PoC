# Arquitectura Volarte

Plataforma de Terpel para la operación de abastecimiento de combustible de aviación: **Frontend Web** (comercial,
supervisión, administración) y **App Móvil offline-first** para operarios en campo, sobre GCP.

| Campo | Valor |
|---|---|
| Identificador | `proyectos/volarte` |
| Dueño | Terpel · Dirección de Arquitectura |
| Fase de negocio | Fase I |
| Fuente original | [`v1/fuente/Arquitectura_volarte_1.drawio`](v1/fuente/Arquitectura_volarte_1.drawio) (13 páginas, 17/08/2026, Kevin Montoya) |
| Versión vigente | **v3** · en-revision |
| Bitácora | [`CHANGELOG_DSL.md`](CHANGELOG_DSL.md) |

## Historial de versiones

| Versión | Estado | Fecha | Basada en | Resumen | Especificación (PDF) |
|---|---|---|---|---|---|
| [`v3`](v3/) | 🟠 en-revision | 2026-10-09 | v2 | **Réplica fiel del Draw.io**: 13 vistas = 13 páginas, colores por página, personas con silueta, disposición y boundaries originales, trazabilidad forma a forma y fidelidad validada (R9) | [PDF v3](v3/docs/generated/Arquitectura_Volarte_v3_Architecture_Specification.pdf) |
| [`v2`](v2/) | ⚪ reemplazada | 2026-10-09 | v1 | Leyenda oficial C4 en todos los diagramas, imágenes y PDF; observabilidad OTel completa; fichas técnicas, catálogo de tecnologías y stack documentado | [PDF v2](v2/docs/generated/Arquitectura_Volarte_v2_Architecture_Specification.pdf) |
| [`v1`](v1/) | ⚪ reemplazada | 2026-10-08 | — | Conversión inicial del Draw.io a Structurizr DSL con paleta propia (congelada como evidencia) | [PDF v1](v1/docs/generated/Volarte_Architecture_Specification.pdf) |

## Contenido de cada versión

| Ruta | Contenido |
|---|---|
| `vN/version.json` | Estado, autores, aprobadores, versión base, entradas de bitácora |
| `vN/README.md` | Notas de la versión (qué cambió y por qué) |
| `vN/dsl/` | Modelo Structurizr DSL (fuente de verdad) |
| `vN/docs/workspace/` | Introducción, trazabilidad al Draw.io y stack tecnológico |
| `vN/docs/adr/` | Architecture Decision Records |
| `vN/docs/generated/` | Diagramas (SVG/PNG con leyenda C4, Mermaid, PlantUML), PDF y reportes |

## Riesgos y decisiones abiertas (v3)

| Tipo | Elemento | Estado |
|---|---|---|
| Nombre del sistema | L1 muestra "Portal" (HUB); L2/L3 "Volarte" (REV-01) | Pendiente de decisión |
| Calidad de la fuente | 35 conectores no pegados, tipo ≠ color en 12 formas, erratas (REV-06/07/09) | Pendiente de corrección en la fuente |
| Observabilidad | Ningún contenedor de Volarte se conecta a OTel en el Draw.io (REV-13) | Pendiente |
| Posible SPOF | Cloud SQL · Memorystore | HA no declarada en la fuente — pendiente de decisión |
| Resiliencia | `tracking-eventos-sub` sin DLQ | Pendiente |
| Cifrado explícito | Pub/Sub → BigQuery · HUB → Power BI · Logging → Monitoring | Pendiente de documentar |
| Decisión P-025 | Runtime de Svc Asignación (GKE) | ADR 0005 *Proposed* |
| Decisión P-072 | Fuente de precios (PriceProvider) | Pendiente |

Detalle en [`v3/REVISION.md`](v3/REVISION.md) (REV-01 … REV-14) y [`v3/docs/generated/review/review-report.md`](v3/docs/generated/review/review-report.md).
