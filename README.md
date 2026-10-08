# Volarte · Architecture as Code (Structurizr)

Ecosistema de **Architecture as Code (AaC)** para **Volarte** (Terpel · Dirección de Arquitectura · Versión 1 · Fase I).
El modelo C4 completo vive como código Structurizr DSL, versionado en Git, validado por un pipeline de CI/CD
y revisado automáticamente por un **Agente Revisor de Arquitectura**.

> Fuente de verdad inicial: `Arquitectura_volarte_1.drawio` (13 páginas, 17/08/2026). A partir del baseline
> `AAC-20261008-01` los cambios se hacen **solo** en `dsl/` y se registran en [`docs/CHANGELOG_DSL.md`](docs/CHANGELOG_DSL.md).

## Estructura del repositorio

```
.
├── .github/workflows/architecture-pipeline.yml   # CI/CD: validación, revisión, render, PDF
├── docs/
│   ├── adr/                                       # Architecture Decision Records (formato adr-tools)
│   ├── workspace/                                 # Documentación embebida en el workspace (!docs)
│   ├── CHANGELOG_DSL.md                           # Bitácora obligatoria de cambios del DSL
│   └── generated/                                 # Salidas compiladas
│       ├── mmd/  puml/  svg/  png/  png-hires/    #   diagramas por vista (png-hires: solo local / artefacto CI)
│       ├── json/workspace.json                    #   modelo exportado
│       ├── review/review-report.{md,json}         #   reporte del Agente Revisor
│       ├── inspect-report.txt                     #   structurizr inspect
│       ├── BUILD_REPORT.md                        #   reporte de compilación
│       └── Volarte_Architecture_Specification.pdf #   documento unificado
├── dsl/
│   ├── workspace.dsl                              # Punto de entrada (modelo + vistas + configuración)
│   ├── model/
│   │   ├── people.dsl                             # Personas / actores
│   │   ├── systems.dsl                            # Sistemas externos, plataforma transversal, infraestructura
│   │   ├── volarte_containers.dsl                 # Contenedores de Volarte (L2)
│   │   ├── relationships.dsl                      # Relaciones (protocolo + cifrado)
│   │   ├── deployment.dsl                         # Entorno de despliegue GCP (Producción)
│   │   └── components/                            # L3: frontend_web, mobile_app, bff_web, bff_mobile,
│   │                                              #     pubsub, gestor_documental, documentos_gcs,
│   │                                              #     svc_usuarios, svc_operacion, svc_comercial
│   └── views/
│       ├── landscape_context.dsl                  # L0 Vista Global · L1 System Context
│       ├── containers.dsl                         # L2
│       ├── components.dsl                         # L3 (10 vistas)
│       ├── dynamic.dsl                            # Flujos HU-050 / HU-055 / consulta web
│       ├── deployment.dsl                         # Despliegue GCP
│       ├── styles.dsl                             # Estilos C4 por tag
│       └── themes/volarte-theme.json              # Tema reutilizable (generado desde styles.dsl)
├── scripts/
│   ├── aac-build.sh                               # Build local: validar → revisar → exportar → render → PDF
│   ├── architecture_reviewer.py                   # Agente Revisor (reglas R1–R5 + revisión IA opcional)
│   ├── render-pdf.mjs                             # PDF unificado (Puppeteer)
│   ├── gen_theme.py                               # Genera el tema JSON desde styles.dsl
│   ├── mermaid-config.json                        # Configuración de Mermaid CLI
│   └── tests/                                     # Pruebas unitarias del revisor
└── package.json                                   # Mermaid CLI + Puppeteer + marked (versiones fijadas)
```

## Vistas del modelo

| Nivel | Vista (key) | Contenido |
|---|---|---|
| L0 | `L0_Vista_Global` | Landscape: Volarte, HUB corporativo, identidad, borde, Apigee, seguridad, observabilidad, datos |
| L1 | `L1_System_Context` | Actores (Empleado, Usuario externo, Operario, Admin), Entra ID, CIAM Ping, Datalake, externos |
| L2 | `L2_Containers`, `L2_Containers_Mensajeria_Datos` | Web, App Móvil, BFF Web/Móvil, servicios de dominio, Pub/Sub, Cloud SQL, Redis, GCS |
| L3 | `L3_Frontend_Web`, `L3_App_Movil`, `L3_BFF_Web`, `L3_BFF_Movil`, `L3_PubSub_Mensajeria`, `L3_Gestor_Documental`, `L3_Documentos_GCS`, `L3_Svc_Usuarios_Auth`, `L3_Svc_Operacion`, `L3_Svc_Comercial` | Componentes por contenedor |
| Dinámicas | `D1_Consulta_Web`, `D2_Sync_Offline_HU050`, `D3_Cierre_Operacion_HU055`, `D4_Conciliacion_Supervisor_HU050` | Flujos de negocio clave |
| Despliegue | `DEP_Produccion_GCP` | Dispositivo gestionado, Cloudflare, Netskope, VPC transversal, Apigee, proyecto Volarte |

### Tags de estilo

`Frontend`, `Mobile`, `BFF`, `DomainService`, `Database`, `Cache`, `Storage`, `Queue`, `Topic`, `Subscription`, `DLQ`,
`ExternalSystem`, `IdentityProvider`, `Infrastructure`, `Edge`, `APIGateway`, `Security`, `Observability`, `Pending`, `Reference`.
Los tags no son solo visuales: el Agente Revisor los usa para aplicar las reglas de capas, SPOF y observabilidad.

## Uso local

Requisitos: **Java 17+**, **Python 3.10+**, **Node 18+** (el render usa Chromium vía Puppeteer).

```bash
npm ci                                   # Mermaid CLI + Puppeteer (descarga Chromium salvo PUPPETEER_SKIP_DOWNLOAD=1)
scripts/aac-build.sh                     # build completo (R4 contra cambios locales sin commit)
scripts/aac-build.sh --validate-only     # validación + Agente Revisor, sin render
scripts/aac-build.sh --base origin/main  # R4 contra la rama base (igual que en el PR)
scripts/aac-build.sh --strict            # las advertencias R5 también rechazan
scripts/aac-build.sh --ai                # + revisión narrativa con Claude (requiere ANTHROPIC_API_KEY)
python3 -m unittest discover -s scripts/tests
```

El script descarga y cachea `structurizr-cli` (versión fijada en `STRUCTURIZR_CLI_VERSION`, por defecto `2025.05.28`)
en `.aac/`. Si existe un Chromium local (`PUPPETEER_EXECUTABLE_PATH`, Playwright en `/opt/pw-browsers`, `/usr/bin/chromium`) se reutiliza.

Para explorar el modelo de forma interactiva: `docker run -it --rm -p 8080:8080 -v $PWD/dsl:/usr/local/structurizr structurizr/lite`.

## Flujo de trabajo para cambios de arquitectura

1. Crear rama desde `main`.
2. Modificar el/los archivo(s) en `dsl/`.
3. Agregar una entrada en `docs/CHANGELOG_DSL.md` usando la plantilla (fecha UTC/COT, autor, ref HU/Jira, archivos, contexto, impacto/ADR).
4. Si el cambio altera tecnología, protocolos, límites o seguridad: agregar un ADR en `docs/adr/`.
5. Ejecutar `scripts/aac-build.sh --base origin/main` y abrir el PR.
6. El pipeline valida, ejecuta el Agente Revisor (comenta el reporte en el PR) y compila los artefactos.
   Al fusionar a `main`, `docs/generated/` se regenera y versiona automáticamente.

## Agente Revisor de Arquitectura

`scripts/architecture_reviewer.py` analiza el modelo exportado (`workspace.json`) y el diff de Git:

| Regla | Severidad | Verificación |
|---|---|---|
| **R1** Descripciones | ERROR | Todo Person, SoftwareSystem, Container y Component tiene descripción no vacía |
| **R2** Tecnologías | ERROR | Todo Container y Component declara tecnología |
| **R3** Aislamiento de capas | ERROR | Elementos `Frontend`/`Mobile` (y sus componentes) no se conectan a `Database`, `Cache`, `Storage`, `Queue`, `Topic`, `Subscription` ni `DomainService` de otro contenedor: deben pasar por BFF / API Gateway |
| **R4** Trazabilidad | ERROR | Todo cambio en `dsl/` tiene entrada nueva en `CHANGELOG_DSL.md` que referencia cada archivo y trae los campos obligatorios |
| **R5** SPOF | WARN | Contenedores con estado o fan-in ≥ 4 desplegados sin `"ha" "true"` / `instances > 1` |
| **R5** Cifrado | WARN | Relaciones cuya tecnología no declara TLS / HTTPS / mTLS / IAM / OIDC |
| **R5** Observabilidad | WARN | Contenedores de ejecución sin relación hacia OTel Collector / Dynatrace |
| **R5** Resiliencia | WARN | Suscripciones Pub/Sub sin Dead Letter Topic |
| **R5** Decisión pendiente | INFO | Elementos con tag `Pending` (P-025, P-072…) |
| IA (opcional) | — | Con `--ai` y credenciales de Anthropic, Claude produce un resumen ejecutivo, top de riesgos y recomendaciones |

Los errores devuelven código de salida `1` y rechazan el PR; las advertencias se reportan en el log, en el resumen del job y como comentario del PR.
Para que el pipeline ejecute la revisión IA, configure el secret `ANTHROPIC_API_KEY` en el repositorio.

## Estado del baseline

Ver [`docs/generated/BUILD_REPORT.md`](docs/generated/BUILD_REPORT.md) y
[`docs/generated/review/review-report.md`](docs/generated/review/review-report.md).
