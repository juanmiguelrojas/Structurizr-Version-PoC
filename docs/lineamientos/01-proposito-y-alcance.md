# 01 · Propósito y alcance del repositorio

## Propósito

Este repositorio es la **fuente de verdad versionada de la arquitectura de software** de la Dirección de
Arquitectura de Terpel, gestionada como código (**Architecture as Code – AaC**) con el modelo **C4** y
**Structurizr DSL**.

Su objetivo es que, para cada proyecto, cualquier persona pueda responder con evidencia:

| Pregunta | Dónde se responde |
|---|---|
| ¿Cómo es la arquitectura **hoy**? | La versión vigente del proyecto (`proyectos/<p>/v<N>/`): DSL, diagramas, PDF |
| ¿Cómo era **antes** y qué cambió? | Las versiones anteriores congeladas + `CHANGELOG_DSL.md` del proyecto |
| ¿**Por qué** se decidió así? | ADRs de cada versión (`docs/adr/`) y campo *Contexto & Justificación* de la bitácora |
| ¿**Quién** lo cambió, cuándo y por qué ticket? | Bitácora (autor, fecha UTC/COT, HU/Jira) + historial Git + PR |
| ¿Qué **tecnologías** y protocolos se usan? | `docs/workspace/` de la versión, fichas técnicas y catálogo de tecnologías del PDF |
| ¿Fue **revisado y aprobado**? | `version.json` (estado, aprobadores), PR aprobado, reporte del Agente Revisor |
| ¿Cumple los **estándares**? | Agente Revisor (reglas R1–R8) ejecutado en cada PR |

## Principios

1. **Un modelo, muchas vistas.** Los diagramas se generan desde el modelo; nunca se dibujan a mano.
2. **Todo cambio es trazable.** Sin entrada en bitácora no hay cambio (R4); sin PR aprobado no hay versión aprobada.
3. **Las versiones no se reescriben.** Una versión aprobada o reemplazada se congela (R6); se evoluciona creando `v<N+1>`.
4. **Notación única.** Leyenda oficial C4 corporativa en todos los proyectos (R7); nada de paletas propias.
5. **Contexto, no solo dibujos.** Cada versión documenta tecnologías, decisiones (ADR) y especificaciones.
6. **Automatizar la revisión, decidir con humanos.** El Agente Revisor detecta incumplimientos y riesgos; la
   aprobación siempre es de un arquitecto (ver [05 · Revisión y aprobación](05-revision-y-aprobacion.md)).

## Alcance

**Incluye:** modelos C4 (L1 contexto, L2 contenedores, L3 componentes), vistas de paisaje (L0), dinámicas y de
despliegue; ADRs; documentación técnica de la arquitectura; insumos originales (Draw.io, PDFs) como fuente de cada versión.

**No incluye:** código fuente de las aplicaciones, infraestructura como código (Terraform), diagramas de nivel 4 (código),
ni documentación funcional de negocio (solo se referencia por HU / Jira).

## Estructura del repositorio

```
.
├── README.md                         # Punto de entrada: propósito, navegación, inicio rápido
├── CHANGELOG.md                      # Cambios de lineamientos, estándares y herramientas (no de proyectos)
├── docs/lineamientos/                # Lineamientos obligatorios (este documento y siguientes)
├── estandares/
│   ├── c4/estilos-c4.dsl             # Leyenda oficial C4 (única fuente de colores)
│   ├── c4/tema-c4-terpel.json        # Tema Structurizr generado desde estilos-c4.dsl
│   └── plantillas/                   # Plantillas: proyecto, versión, ADR, entrada de bitácora
├── proyectos/
│   └── <proyecto>/
│       ├── README.md                 # Ficha del proyecto + historial de versiones
│       ├── CHANGELOG_DSL.md          # Bitácora única del proyecto
│       └── v<N>/
│           ├── version.json          # Metadatos y estado de la versión
│           ├── README.md             # Notas de la versión
│           ├── fuente/               # (opcional) insumos originales
│           ├── dsl/                  # Modelo Structurizr DSL
│           └── docs/{adr,workspace,generated}/
├── scripts/                          # aac-build, Agente Revisor, render, versionamiento
└── .github/                          # Pipeline CI/CD, plantilla de PR, CODEOWNERS
```

## Proyectos actuales

| Proyecto | Versión vigente | Estado | Carpeta |
|---|---|---|---|
| Arquitectura Volarte | v2 | en-revision | [`proyectos/volarte`](../../proyectos/volarte/) |
