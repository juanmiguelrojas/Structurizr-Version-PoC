## Volarte · Documentación de Arquitectura (v2)

Volarte es la plataforma de Terpel para la operación de abastecimiento de combustible de aviación.
Se compone de un **Frontend Web** (React SPA) para empleados comerciales, supervisores y administradores,
y una **App Móvil offline-first** (React Native · Android) para operarios de equipos abastecedores en campo.

Ambos canales consumen APIs a través de **Apigee** y de un **BFF por canal** (Web / Móvil) que orquesta
los **servicios de dominio** (Usuarios/Auth, Datos Maestros, Comercial, Operación, Asignación) y el
**Gestor Documental**, apoyados en **Pub/Sub**, **Cloud SQL**, **Memorystore** y **Cloud Storage** (WORM).

| Atributo | Valor |
|---|---|
| Organización | Terpel · Dirección de Arquitectura |
| Proyecto / versión | `proyectos/volarte` · **v2** (basada en v1) |
| Fase del negocio | Fase I (documento origen Versión 1) |
| Fuente inicial | `proyectos/volarte/v1/fuente/Arquitectura_volarte_1.drawio` (13 páginas, 17/08/2026, autor Kevin Montoya) |
| Notación | C4 Model con **leyenda oficial C4** (`estandares/c4/estilos-c4.dsl`) |
| Gobierno | `docs/lineamientos/` · bitácora `proyectos/volarte/CHANGELOG_DSL.md` · Agente Revisor R1–R8 |

### Qué cambió frente a v1

| # | Cambio | Motivo |
|---|---|---|
| 1 | Colores de **todos** los diagramas, imágenes y PDF según la leyenda oficial C4 (Person, Software System, Container, Component, External Person, External Software System) | Lineamiento corporativo: notación C4 consistente entre proyectos |
| 2 | Tags `External Person` / `External Software System` en todo actor y sistema fuera del alcance de Volarte | Distinguir alcance del proyecto por color, como exige la leyenda |
| 3 | Los tags semánticos (`Database`, `Queue`, `BFF`, …) solo cambian forma o borde, nunca color | Evitar paletas propias que rompen la leyenda |
| 4 | Leyenda C4 embebida al pie de **cada** diagrama SVG / PNG y página de leyenda en el PDF | Que cada imagen sea autoexplicativa al compartirse sola |
| 5 | Relaciones `→ OTel Collector` para los 5 servicios de dominio y el Gestor Documental | El L0 del Draw.io indica que el colector "se conecta a todas las Cloud Run de Backend y Servicios"; v1 lo omitía |
| 6 | Fichas técnicas por contenedor, catálogo de tecnologías y protocolos (PDF) y documento de stack tecnológico | Contexto de tecnologías, no solo del diagrama |
