# Reporte del Agente Revisor de Arquitectura · proyectos/volarte/v3

- **Resultado:** ✅ APROBADO
- **Fecha (UTC):** 2026-10-09 01:48:09
- **Elementos analizados:** 140 · **Relaciones explícitas:** 191
- **Hallazgos:** 0 errores · 40 advertencias · 4 informativos

## Reglas

| Regla | Severidad | Descripción |
|---|---|---|
| R1-Descripciones | ERROR | Todo Person, SoftwareSystem, Container y Component tiene descripción |
| R2-Tecnologías | ERROR | Todo Container y Component declara tecnología |
| R3-Aislamiento de Capas | ERROR | Frontend/Móvil no acceden a datos, colas ni servicios de dominio sin BFF/API Gateway |
| R4-Trazabilidad | ERROR | Cambios en `<versión>/dsl/` acompañados de entrada completa en el `CHANGELOG_DSL.md` del proyecto |
| R5-* (Sugerencias) | WARN/INFO | SPOF, cifrado, observabilidad, DLQ, decisiones pendientes |
| R6-Inmutabilidad | ERROR | Versiones aprobadas / reemplazadas / obsoletas no se modifican |
| R7-Leyenda C4 | ERROR | Colores solo desde la leyenda oficial C4; tags External Person / External Software System |
| R8-Metadatos | ERROR | `version.json` completo y con estado válido |
| R9-Fidelidad Draw.io | ERROR | Si hay fuente Draw.io declarada, cada vista la reproduce sin diferencias |

## Hallazgos

| # | Severidad | Regla | Elemento | Hallazgo | Recomendación |
|---|---|---|---|---|---|
| 1 | WARN | R5-Cifrado | L0_Referencia | 37 relación(es) sin protocolo seguro explícito (TLS/HTTPS/mTLS/IAM/OIDC): ApiGee → Proxy instance; Internal Load Balancer → Proxy instance; Cloudflare → Global Load Balancer; ZTNA → Global Load Balancer; … (+33). | Declare la tecnología con su cifrado en la relación o documente la excepción en un ADR. |
| 2 | WARN | R5-Cifrado | L1_Context | 3 relación(es) sin protocolo seguro explícito (TLS/HTTPS/mTLS/IAM/OIDC): Portal → + Sistemas Externos Futuros; Portal → Google Cloud Platform; Portal → Datalake. | Declare la tecnología con su cifrado en la relación o documente la excepción en un ADR. |
| 3 | WARN | R5-Cifrado | L2_Container | 34 relación(es) sin protocolo seguro explícito (TLS/HTTPS/mTLS/IAM/OIDC): ApiGee → Internal Load Balancer (sin etiqueta); External Regional Load Balancer → Cloudflare; External Regional Load Balancer → Firewall; Firewall → Internal Load Balancer; … (+30). | Declare la tecnología con su cifrado en la relación o documente la excepción en un ADR. |
| 4 | WARN | R5-Cifrado | L3_App_Movil | 13 relación(es) sin protocolo seguro explícito (TLS/HTTPS/mTLS/IAM/OIDC): Modulo de Autenticacion → EntraID / CIAM; Navegación → Modulo de Autenticacion; Navegación → Base de Datos local; Base de Datos local → Motor de Sincronización; … (+9). | Declare la tecnología con su cifrado en la relación o documente la excepción en un ADR. |
| 5 | WARN | R5-Cifrado | L3_BFF_Movil | 16 relación(es) sin protocolo seguro explícito (TLS/HTTPS/mTLS/IAM/OIDC): ApiGee → API Router / Controllers; Cola de mensajeria → Svc: Operación; Cola de mensajeria → Documentos (GCS); Servicio de Autorización → Motor de Reconciliación; … (+12). | Declare la tecnología con su cifrado en la relación o documente la excepción en un ADR. |
| 6 | WARN | R5-Cifrado | L3_BFF_Web | 7 relación(es) sin protocolo seguro explícito (TLS/HTTPS/mTLS/IAM/OIDC): ApiGee → API Router / Controllers; API Router / Controllers → Middleware de Autenticación; Middleware de Autenticación → Servicio de Autorización; Servicio de Autorización → Cliente de Cache; … (+3). | Declare la tecnología con su cifrado en la relación o documente la excepción en un ADR. |
| 7 | WARN | R5-Cifrado | L3_Documentos_GCS | 5 relación(es) sin protocolo seguro explícito (TLS/HTTPS/mTLS/IAM/OIDC): Gestor Documental → Estructura de carpetas; Estructura de carpetas → Política de ciclo de vida; Estructura de carpetas → IAM del bucket; Política de ciclo de vida → Versionado / WORM; … (+1). | Declare la tecnología con su cifrado en la relación o documente la excepción en un ADR. |
| 8 | WARN | R5-Cifrado | L3_Frontend_Web | 7 relación(es) sin protocolo seguro explícito (TLS/HTTPS/mTLS/IAM/OIDC): App Shell / Router → Modulo de Autenticacion; App Shell / Router → Vistas por rol; Vistas por rol → Cliente API; Vistas por rol → Error Boundary / Telemetría; … (+3). | Declare la tecnología con su cifrado en la relación o documente la excepción en un ADR. |
| 9 | WARN | R5-Cifrado | L3_Gestor_Documental | 8 relación(es) sin protocolo seguro explícito (TLS/HTTPS/mTLS/IAM/OIDC): Asignador de Numeración → Cloud SQL (PostgreSQL); Suscriptor Pub/Sub → Generador de Documento; Generador de Documento → Motor de Plantillas; Generador de Documento → Asignador de Numeración; … (+4). | Declare la tecnología con su cifrado en la relación o documente la excepción en un ADR. |
| 10 | WARN | R5-Cifrado | L3_Pub_Sub | 11 relación(es) sin protocolo seguro explícito (TLS/HTTPS/mTLS/IAM/OIDC): BFF — Backend Volarte → Topic: conciliacion-resuelta; Sub: comercial-sub → Svc: Comercial; Sub: comercial-sub → Dead Letter Topic; Topic: operacion-cerrada → Sub: gestor-documental-sub; … (+7). | Declare la tecnología con su cifrado en la relación o documente la excepción en un ADR. |
| 11 | WARN | R5-Cifrado | L3_Svc_Comercial | 8 relación(es) sin protocolo seguro explícito (TLS/HTTPS/mTLS/IAM/OIDC): API Router → Motor de Elegibilidad; API Router → Resolutor PriceProvider; API Router → Servicio de Crédito Disponible; Cliente de base de datos → BFF — Backend Volarte; … (+4). | Declare la tecnología con su cifrado en la relación o documente la excepción en un ADR. |
| 12 | WARN | R5-Cifrado | L3_Svc_Operacion | 8 relación(es) sin protocolo seguro explícito (TLS/HTTPS/mTLS/IAM/OIDC): API Router → Gestor de Turnos; API Router → Rastreador de Posición; API Router → Inventario de Calidad; Rastreador de Posición → Svc: Datos Maestros; … (+4). | Declare la tecnología con su cifrado en la relación o documente la excepción en un ADR. |
| 13 | WARN | R5-Cifrado | L3_Svc_Usuarios_Auth | 8 relación(es) sin protocolo seguro explícito (TLS/HTTPS/mTLS/IAM/OIDC): API Router → Resolver GroupToRoleMapping; Resolver GroupToRoleMapping → Adaptador de sincronización Entra ID; Resolver GroupToRoleMapping → Auditor; Adaptador de sincronización Entra ID → EntraID / CIAM; … (+4). | Declare la tecnología con su cifrado en la relación o documente la excepción en un ADR. |
| 14 | WARN | R5-Observabilidad | Portal › Backend — HUB Web | Contenedor sin relación hacia OTel Collector / Dynatrace. | Instrumente con OpenTelemetry (OTLP → OTel Collector → Dynatrace) según la política 'OTel First'. |
| 15 | WARN | R5-Observabilidad | Portal › Backend — HUB Web (Móvil) | Contenedor sin relación hacia OTel Collector / Dynatrace. | Instrumente con OpenTelemetry (OTLP → OTel Collector → Dynatrace) según la política 'OTel First'. |
| 16 | WARN | R5-Observabilidad | Volarte › App móvil | Contenedor sin relación hacia OTel Collector / Dynatrace. | Instrumente con OpenTelemetry (OTLP → OTel Collector → Dynatrace) según la política 'OTel First'. |
| 17 | WARN | R5-Observabilidad | Volarte › BFF Móvil | Contenedor sin relación hacia OTel Collector / Dynatrace. | Instrumente con OpenTelemetry (OTLP → OTel Collector → Dynatrace) según la política 'OTel First'. |
| 18 | WARN | R5-Observabilidad | Volarte › BFF — Backend Volarte | Contenedor sin relación hacia OTel Collector / Dynatrace. | Instrumente con OpenTelemetry (OTLP → OTel Collector → Dynatrace) según la política 'OTel First'. |
| 19 | WARN | R5-Observabilidad | Volarte › Frontend Web | Contenedor sin relación hacia OTel Collector / Dynatrace. | Instrumente con OpenTelemetry (OTLP → OTel Collector → Dynatrace) según la política 'OTel First'. |
| 20 | WARN | R5-Observabilidad | Volarte › Gestor Documental | Contenedor sin relación hacia OTel Collector / Dynatrace. | Instrumente con OpenTelemetry (OTLP → OTel Collector → Dynatrace) según la política 'OTel First'. |
| 21 | WARN | R5-Observabilidad | Volarte › Svc: Asignación / Optimización | Contenedor sin relación hacia OTel Collector / Dynatrace. | Instrumente con OpenTelemetry (OTLP → OTel Collector → Dynatrace) según la política 'OTel First'. |
| 22 | WARN | R5-Observabilidad | Volarte › Svc: Comercial | Contenedor sin relación hacia OTel Collector / Dynatrace. | Instrumente con OpenTelemetry (OTLP → OTel Collector → Dynatrace) según la política 'OTel First'. |
| 23 | WARN | R5-Observabilidad | Volarte › Svc: Datos Maestros | Contenedor sin relación hacia OTel Collector / Dynatrace. | Instrumente con OpenTelemetry (OTLP → OTel Collector → Dynatrace) según la política 'OTel First'. |
| 24 | WARN | R5-Observabilidad | Volarte › Svc: Operación | Contenedor sin relación hacia OTel Collector / Dynatrace. | Instrumente con OpenTelemetry (OTLP → OTel Collector → Dynatrace) según la política 'OTel First'. |
| 25 | WARN | R5-Observabilidad | Volarte › Svc: Usuarios / Auth | Contenedor sin relación hacia OTel Collector / Dynatrace. | Instrumente con OpenTelemetry (OTLP → OTel Collector → Dynatrace) según la política 'OTel First'. |
| 26 | WARN | R7-Leyenda C4 | + Portales Externos Futuros | Sistema sin contenedores y sin el tag 'External Software System': se mostrará como sistema en alcance. | Si está fuera del alcance del proyecto, agregue el tag "External Software System". |
| 27 | WARN | R7-Leyenda C4 | + Webapps Externos Futuros | Sistema sin contenedores y sin el tag 'External Software System': se mostrará como sistema en alcance. | Si está fuera del alcance del proyecto, agregue el tag "External Software System". |
| 28 | WARN | R7-Leyenda C4 | ApiGee | Sistema sin contenedores y sin el tag 'External Software System': se mostrará como sistema en alcance. | Si está fuera del alcance del proyecto, agregue el tag "External Software System". |
| 29 | WARN | R7-Leyenda C4 | Cloud KMS | Sistema sin contenedores y sin el tag 'External Software System': se mostrará como sistema en alcance. | Si está fuera del alcance del proyecto, agregue el tag "External Software System". |
| 30 | WARN | R7-Leyenda C4 | Datalake | Sistema sin contenedores y sin el tag 'External Software System': se mostrará como sistema en alcance. | Si está fuera del alcance del proyecto, agregue el tag "External Software System". |
| 31 | WARN | R7-Leyenda C4 | External Regional Load Balancer | Sistema sin contenedores y sin el tag 'External Software System': se mostrará como sistema en alcance. | Si está fuera del alcance del proyecto, agregue el tag "External Software System". |
| 32 | WARN | R7-Leyenda C4 | Global Load Balancer | Sistema sin contenedores y sin el tag 'External Software System': se mostrará como sistema en alcance. | Si está fuera del alcance del proyecto, agregue el tag "External Software System". |
| 33 | WARN | R7-Leyenda C4 | Google Cloud Platform | Sistema sin contenedores y sin el tag 'External Software System': se mostrará como sistema en alcance. | Si está fuera del alcance del proyecto, agregue el tag "External Software System". |
| 34 | WARN | R7-Leyenda C4 | Identity-Aware Proxy (IAP) | Sistema sin contenedores y sin el tag 'External Software System': se mostrará como sistema en alcance. | Si está fuera del alcance del proyecto, agregue el tag "External Software System". |
| 35 | WARN | R7-Leyenda C4 | Internal Load Balancer | Sistema sin contenedores y sin el tag 'External Software System': se mostrará como sistema en alcance. | Si está fuera del alcance del proyecto, agregue el tag "External Software System". |
| 36 | WARN | R7-Leyenda C4 | Power BI Service | Sistema sin contenedores y sin el tag 'External Software System': se mostrará como sistema en alcance. | Si está fuera del alcance del proyecto, agregue el tag "External Software System". |
| 37 | WARN | R7-Leyenda C4 | Proxy instance | Sistema sin contenedores y sin el tag 'External Software System': se mostrará como sistema en alcance. | Si está fuera del alcance del proyecto, agregue el tag "External Software System". |
| 38 | WARN | R7-Leyenda C4 | SAP ERP | Sistema sin contenedores y sin el tag 'External Software System': se mostrará como sistema en alcance. | Si está fuera del alcance del proyecto, agregue el tag "External Software System". |
| 39 | WARN | R7-Leyenda C4 | Secret Manager | Sistema sin contenedores y sin el tag 'External Software System': se mostrará como sistema en alcance. | Si está fuera del alcance del proyecto, agregue el tag "External Software System". |
| 40 | WARN | R7-Leyenda C4 | ZTNA | Sistema sin contenedores y sin el tag 'External Software System': se mostrará como sistema en alcance. | Si está fuera del alcance del proyecto, agregue el tag "External Software System". |
| 41 | INFO | R4-Trazabilidad | proyectos/volarte/CHANGELOG_DSL.md | Sin cambios en proyectos/volarte/v3/dsl/ para este diff. |  |
| 42 | INFO | R5-Decisión Pendiente | PriceProvider externo | Elemento marcado como decisión PENDING. | Cierre la decisión con un ADR (Accepted) y retire el tag Pending. |
| 43 | INFO | R5-Decisión Pendiente | Volarte › Svc: Asignación / Optimización | Elemento marcado como decisión PENDING. | Cierre la decisión con un ADR (Accepted) y retire el tag Pending. |
| 44 | INFO | R9-Fidelidad Draw.io | proyectos/volarte/v3 | 13 vistas · elementos 182/182 · conectores 190/190 · fidelidad mínima 100.0% · 30 textos de presentación (alias) · 3 anotaciones sin relación de modelo. |  |
