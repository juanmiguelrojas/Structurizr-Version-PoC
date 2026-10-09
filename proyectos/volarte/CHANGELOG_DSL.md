# CHANGELOG_DSL · Bitácora de Cambios de Arquitectura · Proyecto Volarte

Bitácora **única y obligatoria** del proyecto: registra todo cambio sobre el modelo Structurizr DSL de
**cualquier versión** (`proyectos/volarte/v<N>/dsl/`). Estándar completo en
[`docs/lineamientos/04-versionamiento-y-trazabilidad.md`](../../docs/lineamientos/04-versionamiento-y-trazabilidad.md).

El Agente Revisor (regla **R4-Trazabilidad**) rechaza cualquier PR que modifique `dsl/` sin una entrada nueva aquí que:

1. Referencie **cada archivo modificado** con su ruta completa (o un patrón glob) entre backticks, p. ej. `` `proyectos/volarte/v2/dsl/model/*.dsl` ``.
2. Contenga los campos obligatorios de la plantilla (Versión, Fecha, Autor, Ref, Módulo/Archivo, Contexto, Impacto/ADR).

Las entradas se agregan **arriba** (orden cronológico inverso). No se editan entradas históricas:
una corrección se registra como una nueva entrada que referencia la anterior.

## Índice de versiones

| Versión | Estado | Entradas | Resumen |
|---|---|---|---|
| [`v3`](v3/) | en-revision | AAC-20261009-02 | Réplica fiel del Draw.io: colores por página, siluetas de persona, disposición, trazabilidad forma a forma y fidelidad validada (R9) |
| [`v2`](v2/) | reemplazada | AAC-20261009-01 | Leyenda oficial C4, observabilidad OTel completa, especificaciones y documentación ampliada |
| [`v1`](v1/) | reemplazada | AAC-20261008-01 | Conversión inicial del Draw.io a Structurizr DSL (paleta propia, congelada) |

## Plantilla de entrada (copiar y completar)

```markdown
### [AAC-AAAAMMDD-NN] Título corto del cambio

| Campo | Valor |
|---|---|
| **Versión** | `vN` |
| **Fecha y Hora** | AAAA-MM-DD HH:MM UTC · HH:MM COT (UTC-5) |
| **Autor / Arquitecto** | Nombre Apellido (@usuario-github) |
| **Ref (HU / Jira / Ticket)** | HU-XXX · VOL-XXXX · P-XXX |
| **Módulo / Archivo .dsl** | `proyectos/volarte/vN/dsl/model/...dsl`, `proyectos/volarte/vN/dsl/views/...dsl` |
| **Tipo de cambio** | Nuevo elemento · Modificación · Eliminación · Refactor · Vista · Estilo · Nueva versión |
| **Contexto & Justificación** | ¿Por qué se hizo el cambio? (p. ej. incorporación de resiliencia en Pub/Sub, ajuste de autenticación mTLS…) |
| **Impacto Técnico / ADR asociado** | Contenedores/vistas afectados, riesgos, `proyectos/volarte/vN/docs/adr/NNNN-...md` |
| **Sugerencias del revisor** | Advertencias R5 atendidas / aceptadas como riesgo (con justificación) |
| **Revisores** | @arquitecto-revisor |
```

**Convenciones**

- **ID**: `AAC-AAAAMMDD-NN` (NN = consecutivo del día).
- **Fecha y Hora**: siempre en UTC y su equivalente COT (Colombia, UTC-5, sin horario de verano).
- **Ref**: Historia de Usuario (`HU-NNN`), ticket Jira o decisión pendiente (`P-NNN`). Si no existe, `N/A` + justificación.
- **ADR**: obligatorio cuando el cambio altera tecnología, protocolos, límites de contenedores, seguridad o despliegue.

---

## Registro

### [AAC-20261009-02] v3 · Réplica fiel del Draw.io (colores por página, siluetas de persona, disposición) con trazabilidad forma a forma

| Campo | Valor |
|---|---|
| **Versión** | `v3` (nueva, basada en `v2`; `v2` pasa a `reemplazada`) |
| **Fecha y Hora** | 2026-10-09 02:30 UTC · 2026-10-08 21:30 COT (UTC-5) |
| **Autor / Arquitecto** | Juan Miguel Rojas (@juanmiguelrojas) · asistido por Claude Code |
| **Ref (HU / Jira / Ticket)** | AAC-FIDELIDAD-DRAWIO · Revisión de la Dirección de Arquitectura sobre v2 (colores no coinciden con los diagramas; personas como cajas) |
| **Módulo / Archivo .dsl** | `proyectos/volarte/v3/dsl/*` (generado por `scripts/drawio2structurizr.py` desde `proyectos/volarte/v1/fuente/Arquitectura_volarte_1.drawio` con el mapa `proyectos/volarte/v3/fuente/mapeo-drawio.json`) |
| **Tipo de cambio** | Nueva versión · Estilo · Vista · Modificación |
| **Contexto & Justificación** | v2 cumplía la leyenda C4 pero asignaba el color por tipo de elemento, distinto al de los diagramas aprobados en Draw.io, y el render Mermaid dibujaba las personas como cajas. v3 reproduce **las 13 páginas** del Draw.io como 13 vistas: mismos elementos, textos, tipos, color de cada forma en cada página (siempre de la leyenda C4), personas con silueta, boundaries (capas y proyectos GCP), resaltados, conectores con sus waypoints y bloque de título. El modelo C4 no duplica elementos: la diferencia entre páginas se guarda como presentación por vista (`dsl/layout/`). |
| **Impacto Técnico / ADR asociado** | 143 elementos de modelo (2 sistemas en alcance: Portal y Volarte) · 182 formas Draw.io · 197 relaciones · 3 anotaciones de presentación. Fidelidad validada: 13/13 vistas, 182/182 formas y 190/190 conectores idénticos (regla R9). Nuevas herramientas: `drawio_inventory.py`, `drawio2structurizr.py`, `c4_scene.py`, `render-c4.mjs`. ADR `proyectos/volarte/v3/docs/adr/0007-replica-fiel-del-drawio-y-render-c4.md`. Las vistas de despliegue/dinámicas de v2 no pasan a v3 (REV-12). |
| **Sugerencias del revisor** | Decisiones y observaciones documentadas en `proyectos/volarte/v3/REVISION.md` (REV-01 … REV-14). Abiertas para decisión de Arquitectura: nombre Portal/Volarte (REV-01), conectores a boundaries (REV-05), extremos inferidos (REV-06), tipo vs color (REV-07), erratas (REV-09), contenido de v2 fuera del Draw.io (REV-12), observabilidad y cifrado (REV-13). |
| **Revisores** | Dirección de Arquitectura Terpel (pendiente) |

### [AAC-20261009-01] v2 · Leyenda oficial C4, observabilidad completa y especificaciones

| Campo | Valor |
|---|---|
| **Versión** | `v2` (nueva, basada en `v1`) |
| **Fecha y Hora** | 2026-10-09 00:10 UTC · 2026-10-08 19:10 COT (UTC-5) |
| **Autor / Arquitecto** | Juan Miguel Rojas (@juanmiguelrojas) · asistido por Claude Code |
| **Ref (HU / Jira / Ticket)** | AAC-LINEAMIENTOS-C4 · Revisión Dirección de Arquitectura sobre v1 |
| **Módulo / Archivo .dsl** | `proyectos/volarte/v2/dsl/*` (copia de v1 con cambios en `proyectos/volarte/v2/dsl/workspace.dsl`, `proyectos/volarte/v2/dsl/model/people.dsl`, `proyectos/volarte/v2/dsl/model/systems.dsl`, `proyectos/volarte/v2/dsl/model/relationships.dsl`, `proyectos/volarte/v2/dsl/views/styles.dsl`) |
| **Tipo de cambio** | Nueva versión · Estilo · Modificación |
| **Contexto & Justificación** | La Dirección de Arquitectura exige la **leyenda oficial C4** (Person `#083F75`, Software System `#1061B0`, Container `#23A2D9`, Component `#63BEF2`, External Person `#6C6477`, External Software System `#8C8496`) en todos los diagramas, imágenes y PDF, y trazabilidad por versiones. v1 usaba una paleta propia por tag. Se crea v2: (1) estilos desde `estandares/c4/estilos-c4.dsl`, tags semánticos solo de forma; (2) tags `External Person` / `External Software System` en actores y sistemas fuera de alcance; (3) relaciones de los 5 servicios de dominio y el Gestor Documental hacia el OTel Collector, tal como indica el L0 del Draw.io ("se conecta a todas las Cloud Run de Backend y Servicios"); (4) leyenda embebida en cada diagrama, fichas técnicas, catálogo de tecnologías y `docs/workspace/03-stack-tecnologico.md`. |
| **Impacto Técnico / ADR asociado** | Sin cambios de contenedores ni componentes (14 / 74). +6 relaciones de observabilidad. Cambio visual en las 19 vistas. ADR `proyectos/volarte/v2/docs/adr/0006-leyenda-oficial-c4-y-versionamiento.md`. v1 pasa a estado `reemplazada` (congelada). |
| **Sugerencias del revisor** | R5-Observabilidad (6 advertencias de v1) **atendidas**. Se mantienen como riesgo abierto, pendientes de decisión: SPOF Cloud SQL / Memorystore (HA no declarada en la fuente), `tracking-eventos-sub` sin DLQ, 3 tramos sin cifrado explícito (Pub/Sub→BigQuery, HUB→Power BI, Logging→Monitoring). |
| **Revisores** | Dirección de Arquitectura Terpel (pendiente) |

### [AAC-20261008-01] Baseline inicial · Conversión de Draw.io Volarte v1 a Structurizr DSL

| Campo | Valor |
|---|---|
| **Versión** | `v1` (estado actual: reemplazada por v2) |
| **Fecha y Hora** | 2026-10-08 23:17 UTC · 2026-10-08 18:17 COT (UTC-5) |
| **Autor / Arquitecto** | Juan Miguel Rojas (@juanmiguelrojas) · asistido por Claude Code · Modelo origen: Kevin Montoya (Draw.io v1, 17/08/2026) |
| **Ref (HU / Jira / Ticket)** | AAC-BASELINE · Volarte Fase I · HU-007, HU-044, HU-050, HU-055, HU-056, HU-128, HU-145 · P-025, P-072 |
| **Módulo / Archivo .dsl** | `dsl/workspace.dsl`, `dsl/model/people.dsl`, `dsl/model/systems.dsl`, `dsl/model/volarte_containers.dsl`, `dsl/model/relationships.dsl`, `dsl/model/deployment.dsl`, `dsl/model/components/*.dsl`, `dsl/views/*.dsl`, `dsl/views/themes/*` |
| **Tipo de cambio** | Nuevo (baseline) · *Rutas previas a la reestructuración por proyectos: hoy en `proyectos/volarte/v1/dsl/`* |
| **Contexto & Justificación** | Adopción de la estrategia corporativa de Architecture as Code. Se traduce el diagrama `Arquitectura_volarte_1.drawio` (13 páginas: L0 Referencia, L1 Context, L2 Container y 10 diagramas L3) a un modelo C4 único y modular en Structurizr DSL, que pasa a ser la fuente de verdad versionada. |
| **Impacto Técnico / ADR asociado** | 4 personas · 25 sistemas (Volarte + 24 externos/transversales) · 14 contenedores · 74 componentes · 19 vistas (L0, L1, 2×L2, 10×L3, 4 dinámicas, 1 despliegue). ADRs: `proyectos/volarte/v1/docs/adr/0001` (AaC), `0002` (BFF por canal + Apigee), `0003` (offline-first HU-050), `0004` (Pub/Sub + DLQ HU-055), `0005` (GKE para Asignación, *Proposed*). |
| **Revisores** | Dirección de Arquitectura Terpel |

**Decisiones de modelado y hallazgos de la conversión (requieren validación de Arquitectura):**

1. **Alcance L0** — La página *L0 · Referencia* describe el HUB corporativo (wiki, catálogo, MFE, Power BI). Se modela como el sistema de referencia `HUB Corporativo (Portal)` + la plataforma transversal compartida; los servicios propios del HUB (Svc Wiki, Svc Pagos, Svc Notificación, Elasticsearch, Firestore) no se trasladan a Volarte.
2. **Infraestructura como sistemas** — Cloudflare, LB externo/interno, Palo Alto, Apigee, ZTNA, Secret Manager, KMS, OTel Collector, Cloud Logging/Monitoring se modelan como `softwareSystem` con tags (`Infrastructure`, `APIGateway`, `Security`, `Observability`) y como nodos de infraestructura en la vista de despliegue.
3. **Inconsistencia L3 Pub/Sub** — El Draw.io conecta *BFF Móvil → Sub: operacion-conciliacion-sub* y una auto-relación de esa suscripción. Se interpreta como *BFF Móvil → Topic operacion-cerrada* (fan-out a 3 suscriptores, coherente con L2).
4. **Topics adicionales** — `doc-publicacion` y `tracking-eventos` solo aparecen en la descripción L2; se agregan como componentes del contenedor Pub/Sub. `tracking-eventos-sub` no declara DLQ en el origen (el Agente Revisor lo reporta).
5. **API Router de Svc Operación / Comercial** — En el Draw.io reutilizan la descripción de Svc Usuarios (`/roles · /permissions …`, copia evidente); se reemplaza por una descripción acorde al servicio.
6. **Componentes sin nombre** — El componente *"Component name"* de L3 App Móvil se nombra `Detector de Conflictos Locales` según su descripción.
7. **Relaciones inferidas** — Varias flechas del Draw.io no tienen origen conectado (L3 Svc Operación, Svc Comercial, Gestor Documental, Svc Usuarios); se infirieron por posición y semántica (p. ej. *Generador de Documento → Motor de Plantillas*).
8. **Data Fusion ↔ SAP / Salesforce / Zenput / GuruSoft** — En L0 estos sistemas aparecen sin conexiones; se conectan como fuentes de ingesta de Cloud Data Fusion (supuesto a confirmar).
9. **Contenedor Svc Datos Maestros** — Sin diagrama L3 en el Draw.io; se modela a nivel de contenedor.
10. **HA no declarada** — El Draw.io no especifica HA de Cloud SQL ni el tier de Memorystore; el Agente Revisor los reporta como posibles SPOF (R5).
