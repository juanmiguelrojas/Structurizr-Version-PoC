# CHANGELOG_DSL · Bitácora de Cambios de Arquitectura (Volarte)

Bitácora **obligatoria** de todo cambio sobre el modelo Structurizr DSL (`dsl/`).
El Agente Revisor (`scripts/architecture_reviewer.py`, regla **R4-Trazabilidad**) rechaza
cualquier PR que modifique `dsl/` sin una entrada nueva en este archivo que:

1. Referencie **cada archivo `.dsl` modificado** (ruta completa o patrón glob) entre backticks.
2. Contenga los campos obligatorios de la plantilla.

Las entradas se agregan **arriba** (orden cronológico inverso). No se editan entradas históricas:
una corrección se registra como una nueva entrada que referencia la anterior.

## Plantilla de entrada (copiar y completar)

```markdown
### [AAC-AAAAMMDD-NN] Título corto del cambio

| Campo | Valor |
|---|---|
| **Fecha y Hora** | AAAA-MM-DD HH:MM UTC · HH:MM COT (UTC-5) |
| **Autor / Arquitecto** | Nombre Apellido (@usuario-github) |
| **Ref (HU / Jira / Ticket)** | HU-XXX · VOL-XXXX · P-XXX |
| **Módulo / Archivo .dsl** | `dsl/model/...dsl`, `dsl/views/...dsl` |
| **Tipo de cambio** | Nuevo elemento · Modificación · Eliminación · Refactor · Vista · Estilo |
| **Contexto & Justificación** | ¿Por qué se hizo el cambio? (p. ej. incorporación de resiliencia en Pub/Sub, ajuste de autenticación mTLS…) |
| **Impacto Técnico / ADR asociado** | Contenedores/vistas afectados, riesgos, `docs/adr/NNNN-...md` |
| **Revisores** | @arquitecto-revisor |
```

**Convenciones**

- **ID**: `AAC-AAAAMMDD-NN` (NN = consecutivo del día).
- **Fecha y Hora**: siempre en UTC y su equivalente COT (Colombia, UTC-5, sin horario de verano).
- **Ref**: Historia de Usuario (`HU-NNN`), ticket Jira o decisión pendiente (`P-NNN`). Si no existe, `N/A` + justificación.
- **ADR**: obligatorio cuando el cambio altera tecnología, protocolos, límites de contenedores, seguridad o despliegue.

---

## Registro

### [AAC-20261008-01] Baseline inicial · Conversión de Draw.io Volarte v1 a Structurizr DSL

| Campo | Valor |
|---|---|
| **Fecha y Hora** | 2026-10-08 23:17 UTC · 2026-10-08 18:17 COT (UTC-5) |
| **Autor / Arquitecto** | Juan Miguel Rojas (@juanmiguelrojas) · asistido por Claude Code · Modelo origen: Kevin Montoya (Draw.io v1, 17/08/2026) |
| **Ref (HU / Jira / Ticket)** | AAC-BASELINE · Volarte Fase I · HU-007, HU-044, HU-050, HU-055, HU-056, HU-128, HU-145 · P-025, P-072 |
| **Módulo / Archivo .dsl** | `dsl/workspace.dsl`, `dsl/model/people.dsl`, `dsl/model/systems.dsl`, `dsl/model/volarte_containers.dsl`, `dsl/model/relationships.dsl`, `dsl/model/deployment.dsl`, `dsl/model/components/*.dsl`, `dsl/views/*.dsl`, `dsl/views/themes/*` |
| **Tipo de cambio** | Nuevo (baseline) |
| **Contexto & Justificación** | Adopción de la estrategia corporativa de Architecture as Code. Se traduce el diagrama `Arquitectura_volarte_1.drawio` (13 páginas: L0 Referencia, L1 Context, L2 Container y 10 diagramas L3) a un modelo C4 único y modular en Structurizr DSL, que pasa a ser la fuente de verdad versionada. |
| **Impacto Técnico / ADR asociado** | 4 personas · 25 sistemas (Volarte + 24 externos/transversales) · 14 contenedores · 74 componentes · 19 vistas (L0, L1, 2×L2, 10×L3, 4 dinámicas, 1 despliegue). ADRs: `docs/adr/0001` (AaC), `0002` (BFF por canal + Apigee), `0003` (offline-first HU-050), `0004` (Pub/Sub + DLQ HU-055), `0005` (GKE para Asignación, *Proposed*). |
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
