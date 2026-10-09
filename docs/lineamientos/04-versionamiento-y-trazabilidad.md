# 04 · Versionamiento, trazabilidad y seguimiento

## 1. Modelo de versionamiento

Cada proyecto se versiona **por carpetas** dentro de `proyectos/<proyecto>/`. Una versión es una
**fotografía completa** de la arquitectura (modelo, documentación, decisiones y artefactos), no un diff.

```
proyectos/volarte/
├── README.md               # ficha del proyecto + tabla de versiones
├── CHANGELOG_DSL.md        # bitácora única de TODAS las versiones
├── v1/                     # reemplazada  → congelada (evidencia histórica)
│   ├── version.json
│   ├── fuente/Arquitectura_volarte_1.drawio
│   ├── dsl/ …
│   └── docs/{adr,workspace,generated}/
└── v2/                     # en-revision  → editable
    ├── version.json
    ├── README.md            # notas de la versión: qué cambió y por qué
    ├── dsl/ …
    └── docs/{adr,workspace,generated}/
```

### ¿Cuándo crear una versión nueva?

| Situación | Acción |
|---|---|
| Ajuste dentro de una versión **borrador / en-revision** (corrección, nueva relación, descripción) | Editar la misma versión + entrada en bitácora |
| La versión vigente ya está **aprobada** y hay que cambiarla | Crear `v<N+1>` (`scripts/aac-nueva-version.sh`) |
| Cambio de fase del negocio, de alcance o rediseño significativo | Nueva versión aunque la anterior no esté aprobada |
| Cambio de notación / estándar (p. ej. leyenda C4) | Nueva versión (las congeladas conservan su notación) |

Las versiones son enteros secuenciales (`v1`, `v2`, …). La versión semántica del contenido (p. ej. `2.0.0`) puede
declararse en las `properties` del workspace, pero la **carpeta** es la unidad de trazabilidad.

## 2. Estados de una versión (`version.json`)

```
borrador ──► en-revision ──► aprobada ──► reemplazada
                 │                 └─────► obsoleta
                 └─► (cambios solicitados: vuelve a borrador)
```

| Estado | Significado | ¿Editable? |
|---|---|---|
| `borrador` | En construcción | Sí |
| `en-revision` | PR abierto o pendiente de aprobación de Arquitectura | Sí (solo para atender la revisión) |
| `aprobada` | Vigente y aprobada (requiere `aprobadores`) | **No** (R6) |
| `reemplazada` | Existe una versión posterior aprobada o en curso que la sustituye | **No** (R6) |
| `obsoleta` | Ya no aplica (sistema retirado) | **No** (R6) |

En una versión congelada solo se permite editar `version.json` (p. ej. pasar de `aprobada` a `reemplazada`).
El estado se evalúa **en la rama base** del PR, así que no se puede "descongelar y modificar" en el mismo PR.

### Campos de `version.json` (R8)

```json
{
  "proyecto": "volarte",
  "nombre": "Arquitectura Volarte",
  "version": "v2",
  "estado": "en-revision",
  "fecha": "2026-10-09",
  "basadaEn": "v1",
  "reemplazadaPor": null,
  "autores": ["Nombre Apellido (@usuario)"],
  "aprobadores": [],
  "fuente": "../v1/fuente/Arquitectura_volarte_1.drawio",
  "workspace": "dsl/workspace.dsl",
  "changelog": ["AAC-20261009-01"],
  "descripcion": "Qué es esta versión y en qué se diferencia de la anterior."
}
```

## 3. Bitácora del proyecto (`CHANGELOG_DSL.md`)

Una sola bitácora por proyecto, en orden cronológico inverso. Cada cambio a `dsl/` **debe** registrar (R4):

| Campo | Ejemplo |
|---|---|
| ID | `AAC-20261009-01` |
| **Versión** | `v2` |
| **Fecha y Hora** | `2026-10-09 00:10 UTC · 2026-10-08 19:10 COT (UTC-5)` |
| **Autor / Arquitecto** | `Nombre Apellido (@usuario)` |
| **Ref (HU / Jira / Ticket)** | `HU-055 · VOL-1234 · P-072` |
| **Módulo / Archivo .dsl** | rutas completas entre backticks: `` `proyectos/volarte/v2/dsl/model/relationships.dsl` `` (se aceptan globs) |
| **Tipo de cambio** | Nuevo elemento · Modificación · Eliminación · Refactor · Vista · Estilo · Nueva versión |
| **Contexto & Justificación** | Por qué se hizo |
| **Impacto Técnico / ADR** | Qué afecta y ADR asociado |
| **Sugerencias del revisor** | Advertencias R5 atendidas o aceptadas como riesgo, con justificación |
| **Revisores** | Quién revisó / aprobó |

Plantilla: [`estandares/plantillas/entrada-changelog.md`](../../estandares/plantillas/entrada-changelog.md).

## 4. Decisiones (ADR)

- Cada versión tiene `docs/adr/` en formato *adr-tools* (`NNNN-titulo.md` con `# N. Título`, `Date:`, `## Status`,
  `## Context`, `## Decision`, `## Consequences`). Plantilla: [`estandares/plantillas/adr.md`](../../estandares/plantillas/adr.md).
- Al crear una versión nueva se copian los ADR vigentes; los nuevos continúan la numeración.
- Un ADR **no se borra**: se marca `Superseded by N` y se crea el nuevo.
- Obligatorio cuando el cambio altera tecnología, protocolos, límites de contenedores, seguridad o despliegue.

## 5. Trazabilidad de extremo a extremo

```
HU / Jira ──► rama Git ──► commit(s) ──► entrada CHANGELOG_DSL (ID AAC-…) ──► ADR ──► PR revisado
     ▲                                                                              │
     └──────────── version.json (changelog[], autores, aprobadores) ◄───────────────┘
                              │
                              └─► PDF de la versión (portada, historial, bitácora, ADR, reporte del revisor)
```

- **Ramas**: `arq/<proyecto>-v<N>-<ref>-<descripcion-corta>` (p. ej. `arq/volarte-v2-hu-055-dlq-tracking`).
- **Commits**: `arq(<proyecto>/v<N>): <resumen> (<ref>)`; cambios de lineamientos: `docs(lineamientos): …`;
  herramientas: `feat(aac): …` / `fix(aac): …`.
- **PR**: uno por cambio lógico; la plantilla exige versión afectada, ID de bitácora y checklist C4.
- El PDF de cada versión incluye portada con estado, historial de versiones, bitácora completa y reporte del revisor,
  por lo que **es autosuficiente** como evidencia para auditoría.

## 6. Seguimiento

| Qué seguir | Dónde |
|---|---|
| Estado de cada versión | `README.md` del proyecto (tabla de versiones) y `version.json` |
| Decisiones pendientes (`P-NNN`) | Hallazgos `R5-Decisión Pendiente` del reporte del revisor + tag `Pending` en diagramas |
| Riesgos abiertos (SPOF, cifrado, DLQ…) | Advertencias R5 del `review-report.md` y campo *Sugerencias del revisor* de la bitácora |
| Cambios por persona / ticket | Bitácora + `git log -- proyectos/<p>/` |
| Evolución entre versiones | `git diff --no-index proyectos/<p>/v1/dsl proyectos/<p>/v2/dsl` |
