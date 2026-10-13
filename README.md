# Arquitectura como Código · Terpel · Dirección de Arquitectura

Repositorio **oficial y versionado** de la arquitectura de software de los proyectos de la Dirección de Arquitectura,
modelada como código con **C4 Model** + **Structurizr DSL**, revisada automáticamente por un **Agente Revisor** y
publicada como diagramas y especificaciones PDF con la **leyenda oficial C4**.

## Propósito

Tener, para cada proyecto, una **traza clara y auditable** de su arquitectura:

- **Qué** es la arquitectura vigente y **cómo era antes**: cada proyecto se versiona por carpetas (`v1`, `v2`, …) y las versiones aprobadas o reemplazadas quedan congeladas.
- **Por qué** y **quién** la cambió: bitácora obligatoria por proyecto (fecha UTC/COT, autor, HU/Jira, archivos, contexto, impacto) y ADRs.
- **Con qué** tecnologías: stack tecnológico documentado, fichas técnicas por contenedor y catálogo de tecnologías y protocolos.
- **Si cumple** los estándares: revisión automática (reglas R1–R8) y revisión humana en cada PR, con aprobación formal de versiones.

Detalle: [Propósito y alcance](docs/lineamientos/01-proposito-y-alcance.md).

## Proyectos

| Proyecto | Versión vigente | Estado | Versiones | Especificación |
|---|---|---|---|---|
| [Arquitectura Volarte](proyectos/volarte/) | v3 | 🟠 en-revision | [v1](proyectos/volarte/v1/) (reemplazada) · [v2](proyectos/volarte/v2/) (reemplazada) · [v3](proyectos/volarte/v3/) | [PDF v3](proyectos/volarte/v3/docs/generated/Arquitectura_Volarte_v3_Architecture_Specification.pdf) |

## Leyenda C4 (obligatoria)

![Leyenda C4](estandares/c4/leyenda-c4.svg)

| Person | Software System | Container | Component | External Person | External Software System |
|---|---|---|---|---|---|
| `#083F75` | `#1061B0` | `#23A2D9` | `#63BEF2` | `#6C6477` | `#8C8496` |

Fuente única: [`estandares/c4/estilos-c4.dsl`](estandares/c4/estilos-c4.dsl) · Lineamiento: [03 · Leyenda C4](docs/lineamientos/03-leyenda-c4.md).
Cada diagrama generado incluye esta leyenda. Las **personas se dibujan siempre con silueta de actor**, nunca como caja.

## Diagramas fieles al Draw.io

Los proyectos que nacen de un Draw.io aprobado se importan con `scripts/drawio2structurizr.py`: cada página se convierte en
una vista Structurizr que se ve igual al original (colores por página, siluetas, boundaries, disposición), el modelo C4 queda
deduplicado y trazable forma a forma, y cada build valida la fidelidad contra la fuente (regla R9). Ejemplo:
[Volarte v3](proyectos/volarte/v3/) · guía en [06 · Guía de uso de Structurizr §8](docs/lineamientos/06-guia-structurizr.md).

## Lineamientos

| # | Documento | |
|---|---|---|
| 01 | [Propósito y alcance](docs/lineamientos/01-proposito-y-alcance.md) | Para qué existe el repositorio y cómo está organizado |
| 02 | [Modelado C4](docs/lineamientos/02-lineamientos-c4.md) | Niveles, vistas obligatorias, elementos, relaciones, tags |
| 03 | [Leyenda oficial C4](docs/lineamientos/03-leyenda-c4.md) | Colores y reglas de estilo |
| 04 | [Versionamiento y trazabilidad](docs/lineamientos/04-versionamiento-y-trazabilidad.md) | Versiones por carpeta, estados, bitácora, ADR, seguimiento |
| 05 | [Revisión y aprobación](docs/lineamientos/05-revision-y-aprobacion.md) | Flujo de PR, Agente Revisor, checklist, aprobación de versiones |
| 06 | [Guía de uso de Structurizr](docs/lineamientos/06-guia-structurizr.md) | Herramientas, comandos, sintaxis, problemas frecuentes |
| 07 | [Consistencia y calidad](docs/lineamientos/07-consistencia-y-calidad.md) | Nombres, *Definition of Done*, consistencia entre proyectos |

## Estructura

```
.
├── docs/lineamientos/          # Lineamientos obligatorios
├── estandares/
│   ├── c4/                     # Leyenda oficial C4: estilos-c4.dsl, tema JSON, leyenda-c4.svg
│   └── plantillas/             # Plantillas de proyecto, versión, ADR y entrada de bitácora
├── proyectos/
│   └── volarte/
│       ├── README.md           # Ficha + historial de versiones + riesgos abiertos
│       ├── CHANGELOG_DSL.md    # Bitácora del proyecto
│       ├── v1/                 # reemplazada (congelada): Draw.io original + primera conversión
│       ├── v2/                 # reemplazada (congelada): leyenda C4 + especificaciones
│       └── v3/                 # en-revision: réplica fiel del Draw.io + REVISION.md
├── scripts/                    # aac-build, Agente Revisor, render, versionamiento, plantillas
├── .github/                    # Pipeline, plantilla de PR, CODEOWNERS
└── CHANGELOG.md                # Cambios de lineamientos y herramientas
```

## Inicio rápido

Requisitos: Java 17+, Python 3.10+, Node 18+.

```bash
npm ci
scripts/aac-build.sh proyectos/volarte/v3 --validate-only   # validación + Agente Revisor + fidelidad Draw.io (~15 s)
scripts/aac-build.sh proyectos/volarte/v3                   # diagramas notación Draw.io C4 + PDF (~2 min)
scripts/aac-build.sh --all --validate-only                  # todas las versiones de todos los proyectos

scripts/aac-nueva-version.sh proyectos/volarte              # crea v4 a partir de v3
scripts/aac-nuevo-proyecto.sh portal-hub "Arquitectura Portal HUB"
```

Guía completa: [06 · Guía de uso de Structurizr](docs/lineamientos/06-guia-structurizr.md).

## Revisión y aprobación

1. Cambio en una rama → bitácora + ADR → `aac-build.sh` local → PR (plantilla con checklist C4).
2. El pipeline valida el DSL, ejecuta el **Agente Revisor** (R1 descripciones · R2 tecnologías · R3 aislamiento de capas ·
   R4 trazabilidad · R5 sugerencias · R6 inmutabilidad · R7 leyenda C4 y siluetas · R8 metadatos · R9 fidelidad Draw.io),
   comenta el reporte en el PR y compila diagramas y PDF.
3. Las decisiones y observaciones del autor se registran como comentarios `REV-NN` en el `REVISION.md` de la versión.
4. Un arquitecto revisor aprueba el PR; la Dirección de Arquitectura aprueba la versión (`version.json` → `aprobada`).
5. Al fusionar en `main` se publican los artefactos y la versión aprobada queda congelada.

Detalle: [05 · Revisión y aprobación](docs/lineamientos/05-revision-y-aprobacion.md).
