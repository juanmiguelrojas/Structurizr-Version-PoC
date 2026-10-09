# 06 · Guía de uso de Structurizr y del pipeline AaC

Guía práctica para crear, editar, visualizar y publicar arquitectura en este repositorio.

## 1. Herramientas

| Herramienta | Versión | Para qué | Instalación |
|---|---|---|---|
| Java (JDK/JRE) | 17+ | Ejecutar `structurizr-cli` | `sudo apt install openjdk-21-jre` / Temurin |
| structurizr-cli | 2025.05.28 (fijada) | Validar, inspeccionar y exportar el DSL | Automática: `scripts/aac-build.sh` la descarga en `.aac/` |
| Python | 3.10+ | Agente Revisor, versionamiento, reportes | Sistema |
| Node.js | 18+ (22 en CI) | Render de diagramas (Mermaid CLI + Puppeteer) y PDF | `npm ci` |
| Structurizr Lite *(opcional)* | última | Explorar el modelo de forma interactiva | Docker (ver §4) |
| VS Code + extensión *Structurizr DSL* *(opcional)* | — | Resaltado de sintaxis | Marketplace |

## 2. Flujo diario

```bash
git checkout main && git pull
git checkout -b arq/volarte-v2-hu-123-resiliencia-pubsub     # rama por cambio

# 1) Editar el modelo de la versión editable
code proyectos/volarte/v2/dsl/

# 2) Validar rápido (sintaxis + Agente Revisor, ~10 s)
scripts/aac-build.sh proyectos/volarte/v2 --validate-only

# 3) Registrar el cambio en la bitácora del proyecto (obligatorio, R4)
code proyectos/volarte/CHANGELOG_DSL.md

# 4) Build completo: diagramas con leyenda C4 + PDF (~3-4 min)
scripts/aac-build.sh proyectos/volarte/v2

# 5) Commit + PR (la plantilla de PR guía la revisión)
git add -A && git commit -m "arq(volarte/v2): reintentos y DLQ en tracking-eventos (HU-123)"
git push -u origin HEAD
```

## 3. Comandos de `scripts/aac-build.sh`

| Comando | Qué hace |
|---|---|
| `scripts/aac-build.sh proyectos/<p>/v<N>` | Build completo de una versión (validar → revisar → exportar → render → PDF → reporte) |
| `… --validate-only` | Solo validación DSL, `inspect`, export JSON/Mermaid/PlantUML y Agente Revisor |
| `scripts/aac-build.sh --all` | Todas las versiones (las congeladas solo se validan) |
| `scripts/aac-build.sh --changed origin/main` | Solo versiones con cambios frente a `main` (lo que hace el CI) |
| `--base origin/main` | Evalúa R4/R6 contra la rama base en vez de contra los cambios locales |
| `--strict` | Las advertencias (R5) también rechazan |
| `--ai` | Agrega revisión narrativa con Claude (requiere `ANTHROPIC_API_KEY`) |
| `--force` | Regenera artefactos de una versión congelada (solo con aprobación de Arquitectura) |

Otros scripts:

| Script | Uso |
|---|---|
| `scripts/aac-nuevo-proyecto.sh <id> "<Nombre>"` | Crea `proyectos/<id>/v1` desde la plantilla |
| `scripts/aac-nueva-version.sh proyectos/<p>` | Crea `v<N+1>` copiando la última versión (estado `borrador`) |
| `python3 scripts/aac_versions.py list [--editable] [--changed BASE]` | Lista versiones y su estado |
| `python3 scripts/architecture_reviewer.py --version-dir proyectos/<p>/v<N>` | Ejecuta solo el Agente Revisor |
| `python3 -m unittest discover -s scripts/tests` | Pruebas del revisor |

## 4. Explorar el modelo con Structurizr Lite (opcional)

```bash
docker run -it --rm -p 8080:8080 \
  -v "$PWD":/repo -e STRUCTURIZR_WORKSPACE_PATH=proyectos/volarte/v2/dsl \
  structurizr/lite
# abrir http://localhost:8080
```

Lite permite navegar el modelo, mover elementos y ver la documentación embebida (`!docs`, `!adrs`). Los cambios de
**layout** hechos en Lite no se versionan: las vistas usan `autoLayout` para que el resultado sea reproducible.

## 5. Sintaxis esencial del DSL

```
# Persona y sistemas (model/people.dsl, model/systems.dsl)
empleado = person "Empleado Interno" "Usuario corporativo que…" 
cliente  = person "Usuario Externo" "Usuario fuera del tenant…" "External Person"
entraId  = softwareSystem "Microsoft Entra ID" "Proveedor de identidad…" "External Software System,IdentityProvider"

# Contenedor con componentes (model/<sistema>_containers.dsl)
bffWeb = container "BFF Web" "Valida JWT y orquesta…" "Python · FastAPI · Cloud Run" "BFF" {
    !include components/bff_web.dsl
}

# Componente y relación interna (model/components/bff_web.dsl)
bwRouter = component "API Router" "Endpoints REST por feature." "FastAPI"
bwRouter -> bwJwt "Valida" "Llamada in-process (Python)"

# Relación entre contenedores (model/relationships.dsl): propósito + tecnología con cifrado
bwSvcClients -> svcComercial "Consulta elegibilidad" "HTTPS · ID Token (IAM Invoker)"

# Vistas (views/*.dsl)
container volarte "L2_Containers" "L2 · Contenedores de Volarte" {
    include *
    autoLayout lr
}
dynamic volarte "D1_Consulta_Web" "D1 · …" {
    empleado -> frontendWeb "Abre Volarte"
    frontendWeb -> apigee "GET /comercial con Bearer JWT"
    autoLayout lr
}
```

Referencia completa: <https://docs.structurizr.com/dsl/language>.

## 6. Artefactos generados por versión (`docs/generated/`)

| Carpeta / archivo | Contenido | Versionado en Git |
|---|---|---|
| `json/workspace.json` | Modelo completo exportado | Sí |
| `mmd/`, `puml/` | Fuentes Mermaid y C4-PlantUML por vista | Sí |
| `svg/`, `png/` | Diagramas con leyenda C4 (PNG a ×2) | Sí |
| `png-hires/` | PNG ×4 para impresión | No (artefacto del CI) |
| `<Proyecto>_v<N>_Architecture_Specification.pdf` | Especificación unificada | Sí |
| `review/review-report.{md,json}` | Reporte del Agente Revisor | Sí |
| `inspect-report.txt`, `BUILD_REPORT.md` | Inspección Structurizr y reporte de compilación | Sí |

Los artefactos **no se editan a mano**: se regeneran con el build y el CI los vuelve a publicar en `main`.

## 7. Problemas frecuentes

| Síntoma | Causa / solución |
|---|---|
| `Unexpected tokens … at line N` | Error de sintaxis DSL; revisar comillas y llaves en el archivo y línea indicados |
| `The destination element … does not exist` | Identificador no definido **antes** de la relación; mover la relación a `relationships.dsl` |
| R4 rechaza el PR | Falta entrada en `CHANGELOG_DSL.md` o no lista la ruta completa de los archivos `.dsl` |
| R6 rechaza el PR | Se modificó una versión congelada: crear `v<N+1>` con `aac-nueva-version.sh` |
| R7 rechaza el PR | Un tag no-leyenda define color, o falta `External Person` / `External Software System` |
| Render falla por Chromium | Definir `PUPPETEER_EXECUTABLE_PATH` o dejar que `npm ci` descargue Chrome |
