# Revisión de la versión v3 · Comentarios de validación

Registro de **cada decisión de importación y cada observación sobre la fuente Draw.io** tomada al construir v3.
Cada comentario tiene un identificador `REV-NN` que se referencia desde el mapa (`fuente/mapeo-drawio.json`),
la bitácora (`../CHANGELOG_DSL.md`, entrada `AAC-20261009-02`) y los comentarios del Pull Request.

**Estados:** ✅ Aplicado en v3 · 🟠 Pendiente de decisión de Arquitectura · ℹ️ Informativo

**Evidencia automática:**
[`docs/generated/fidelidad/fidelidad-drawio.md`](docs/generated/fidelidad/fidelidad-drawio.md) (fidelidad por página) ·
[`fuente/TRAZABILIDAD.md`](fuente/TRAZABILIDAD.md) (forma → elemento) ·
[`docs/generated/review/review-report.md`](docs/generated/review/review-report.md) (Agente Revisor).

## Resumen de la validación

| Verificación | Resultado |
|---|---|
| Sintaxis DSL (`structurizr validate`) | ✅ válido |
| Fidelidad vs Draw.io (R9) | ✅ 13/13 páginas · 182/182 formas · 190/190 conectores · textos, colores y formas idénticos |
| Leyenda C4 (R7) | ✅ solo colores de la leyenda · personas con silueta (shape Person) |
| Errores del Agente Revisor | ✅ 0 |
| Advertencias del Agente Revisor | 🟠 observaciones de la fuente (REV-13), no bloqueantes |

## Comentarios

### REV-01 · El sistema del L1 se llama "Portal", no "Volarte" — 🟠
- **Observación:** el L1 (Context) y el L0 (Referencia) describen el **Portal / HUB corporativo** (wiki, catálogo de web
  apps, shell MFE), mientras el L2 y los L3 describen **Volarte** (marco "Diagrama Contenedores [Volarte]").
  No hay un diagrama de contexto propio de Volarte.
- **Decisión v3:** fidelidad literal. El modelo tiene dos sistemas en alcance: `portal` (L0, L1) y `volarte` (L2, L3).
- **Acción recomendada:** confirmar si Volarte *es* el Portal (renombrar en v4) o crear el L1 de Volarte.

### REV-02 · Colores por página: convención de "elemento fuera del zoom" — ✅
- **Observación:** el Draw.io pinta el mismo elemento con colores distintos según la página. En los L3 los contenedores
  vecinos se dibujan en gris con tipo `[Contenedor externo]`; Entra ID es azul en el L1 y gris en el L0/L2.
- **Decisión v3:** el modelo conserva el tipo real (contenedor, sistema); la **presentación** de cada vista guarda la
  clase de color de la página (siempre dentro de la leyenda C4). Así coinciden los 182 colores sin duplicar elementos.

### REV-03 · Elementos compartidos y alias de presentación — ✅
- **Decisión v3:** 21 elementos del modelo agrupan formas de varias páginas (20 reglas de `compartidos` + las personas), p. ej. (p. ej. `EntraID / CIAM`, `EntraID / Azure AD`
  y `EntraID` → `entraId`; `ApiGee`, `API Management` y `Apigee` → `apigee`; `Cloud SQL`, `Cloud SQL / metadata` →
  `vo_cloudSqlPostgresql`). **30 formas** muestran un texto distinto al del modelo, conservado como *alias de
  presentación* (detalle en `fuente/TRAZABILIDAD.md`).
- **Acción recomendada:** homogeneizar los nombres en la fuente (p. ej. un solo nombre para Apigee y Entra ID).

### REV-04 · Excepciones puntuales del mapeo — ✅
- Segundo **Internal Load Balancer** del L2 (`…PWvh-33`, dentro de `terpel-org-col-volarte-AMB`) → contenedor propio
  de Volarte (`vo_internalLoadBalancer`); el otro ILB es plataforma compartida (`ilbTransversal`).
- **App Móvil** del L0 (gris) → contenedor del Portal (`po_appMovil`), es el cliente del HUB.
- Dos cajas **"Backend — HUB Web"** en el L0 → el modelo distingue `Backend — HUB Web (Móvil)` (Structurizr exige
  nombres únicos); la vista muestra el texto original.

### REV-05 · Conectores que terminan en un boundary — 🟠
- **L2:** "orquesta cada servicio que no va por PUB/SUB" (desde BFF — Backend Volarte y BFF Móvil) llega al boundary
  *Servicios de dominio* / al proyecto. Se expande a **12 relaciones** BFF → cada servicio del boundary (se dibujan
  como los 2 conectores originales).
- **L0:** dos conectores de *Backend — HUB Web* hacia el boundary *Transversal* ("Se integra") y uno del *OTel
  Collector* hacia el texto libre "Se conecta a todas las Cloud runs…" quedan como **anotaciones de presentación**
  (sin relación de modelo).
- **Acción recomendada:** conectar esas flechas a elementos concretos en la fuente.

### REV-06 · Extremos de conector inferidos por geometría — 🟠
- **Observación:** 35 conectores del Draw.io no están "pegados" a una forma (terminan en un punto suelto). Se
  asignaron a la forma que está bajo el extremo (tolerancia 20 px): L3 Svc Operación 7, L3 Svc Comercial 7,
  L3 Svc Usuarios Auth 4, L3 Gestor Documental 4, L2 3, L3 Pub-Sub 3, L3 Documentos GCS 3, L0 2, L3 App Móvil 1,
  L3 BFF Web 1. Cada relación inferida lleva el comentario `(extremo inferido por geometría)` en el DSL.
- **Acción recomendada:** revisar visualmente esas relaciones y "pegar" los conectores en la fuente.

### REV-07 · Tipo C4 y color no coinciden en el Draw.io — 🟠
| Página | Forma | Tipo declarado | Color usado |
|---|---|---|---|
| L0 | Svc: Wiki · Svc: Usuarios / Auth · Svc: Analitica · Svc: Notificacion · Svc: Pagos | Container | Component |
| L0 | Cloudflare · SalesForce · ZENPUT | Component | External Software System |
| L0 | SAP ERP | Component (tecnología "Software System") | Software System |
| L0 | Cloud Data Fusion | Container | External Software System |
| L2 | ApiGee | Component | Container |
| L2 | Cloudflare | Component | External Software System |
- **Decisión v3:** se respeta literalmente tipo y color de la fuente (la leyenda se cumple porque todos los colores
  pertenecen a ella).
- **Acción recomendada:** alinear tipo y color en la fuente.

### REV-08 · Enriquecimiento del modelo sin alterar la vista — ✅
- **ZENPUT** no tiene descripción en el Draw.io (la regla R1 la exige). El modelo la incorpora
  ("Sistema corporativo referenciado en la página L0 sin descripción…") y la vista L0 sigue mostrando la caja sin
  descripción, como el original.

### REV-09 · Erratas de la fuente conservadas literalmente — 🟠
`Api Gatawey` (ApiGee, L2) · `Apigge` (Proxy instance, L0/L2) · `Netscope` (ZTNA, L0/L2) · `Serivico` (Cola de
mensajeria, L0) · `pass trougth` (etiqueta L2) · `GCS Resumable Uploa` (Manejador de Subida, L3 BFF Móvil) ·
`Component name` (componente sin nombre, L3 App Móvil).
- **Acción recomendada:** corregir en la fuente y en el DSL de v4 (entrada de bitácora por corrección).

### REV-10 · Etiquetas "Text" de relleno del Draw.io — ✅
- Un conector del L2 tiene dos etiquetas `Text` (valor por defecto de Draw.io) ocultas bajo "Resuelve peticiones
  Moviles". Se descartan y se usa la etiqueta real.

### REV-11 · Leyenda del Draw.io sustituida por la oficial — ✅
- La tabla "Legend" del L1 usa colores aproximados (`#1E4074`, `#3162AF`, `#52a2d8`, `#7dbef2`, `#6b6477`, `#8b8496`).
  v3 dibuja en la misma posición la **leyenda oficial** (`#083F75`, `#1061B0`, `#23A2D9`, `#63BEF2`, `#6C6477`,
  `#8C8496`), que es la que usan las formas del propio Draw.io. Las demás vistas llevan la leyenda al pie.

### REV-12 · Contenido de v2 que no está en el Draw.io — 🟠
- v2 había agregado (por interpretación): vista de despliegue, 4 vistas dinámicas (HU-050, HU-055), relaciones OTel de
  los servicios, topics `doc-publicacion` / `tracking-eventos` como componentes, ADR 0001–0006. Para mantener la
  fidelidad, **v3 no incluye** esas vistas ni relaciones; los ADR se conservan.
- **Acción recomendada:** validar esas propuestas con Arquitectura e incorporarlas en v4 (siguen consultables en `../v2`).

### REV-13 · Advertencias del Agente Revisor sobre la fuente — 🟠
- **R5-Observabilidad:** ningún contenedor de Volarte (ni los Backend del HUB) tiene relación hacia OTel Collector /
  Dynatrace en el Draw.io, aunque el L0 dice que el colector "se conecta a todas las Cloud runs".
- **R5-Cifrado:** la mayoría de conectores no declara protocolo seguro (agrupado por vista en el reporte).
- **R7:** plataformas externas pintadas con colores de elemento en alcance (Apigee, ZTNA, balanceadores, IAP, SAP ERP,
  Power BI, GCP, Datalake…), ver REV-07.
- **Acción recomendada:** decidir por cada advertencia (atender / aceptar riesgo / decisión pendiente) en la entrada
  de aprobación de la bitácora.

### REV-14 · Personas con silueta y notación Draw.io C4 — ✅
- Las 4 personas (Empleado Interno, Usuario externo, Operario de equipo abastecedor, Admin / Dev Team) se dibujan con
  silueta de actor en todas las vistas. El lineamiento 03 y la regla R7 lo exigen ahora para todos los proyectos.

## Firma de revisión

| Rol | Nombre | Fecha | Resultado |
|---|---|---|---|
| Autor | Juan Miguel Rojas (@juanmiguelrojas) | 2026-10-09 | Versión lista para revisión |
| Agente Revisor | `scripts/architecture_reviewer.py` (R1–R9) | automático en CI | 0 errores · advertencias REV-13 |
| Arquitecto revisor | _pendiente_ | | |
| Dirección de Arquitectura | _pendiente_ | | |
