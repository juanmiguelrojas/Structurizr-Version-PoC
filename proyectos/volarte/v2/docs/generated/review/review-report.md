# Reporte del Agente Revisor de Arquitectura · proyectos/volarte/v2

- **Resultado:** ✅ APROBADO
- **Fecha (UTC):** 2026-10-09 00:24:53
- **Elementos analizados:** 117 · **Relaciones explícitas:** 158
- **Hallazgos:** 0 errores · 6 advertencias · 4 informativos

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

## Hallazgos

| # | Severidad | Regla | Elemento | Hallazgo | Recomendación |
|---|---|---|---|---|---|
| 1 | WARN | R5-Cifrado | GCP Cloud Logging → GCP Cloud Monitoring | Tramo sin cifrado explícito en la tecnología: 'GCP internal'. | Declare el protocolo seguro (TLS 1.2+, mTLS, IAM) o documente la excepción en un ADR. |
| 2 | WARN | R5-Cifrado | HUB Corporativo (Portal) → Power BI Service | Tramo sin cifrado explícito en la tecnología: 'Power BI REST API · AAD'. | Declare el protocolo seguro (TLS 1.2+, mTLS, IAM) o documente la excepción en un ADR. |
| 3 | WARN | R5-Cifrado | Volarte › Cola de Mensajería → Datalake BigQuery | Tramo sin cifrado explícito en la tecnología: 'Pub/Sub BigQuery subscription'. | Declare el protocolo seguro (TLS 1.2+, mTLS, IAM) o documente la excepción en un ADR. |
| 4 | WARN | R5-Resiliencia | Volarte › Cola de Mensajería › Sub: tracking-eventos-sub | Suscripción Pub/Sub sin Dead Letter Topic. | Configure dead_letter_policy (max_delivery_attempts) hacia el Dead Letter Topic. |
| 5 | WARN | R5-SPOF | Volarte › Cloud SQL | Posible Single Point of Failure: 7 contenedor(es) dependen de él y su nodo de despliegue no declara alta disponibilidad (ha=true / instances>1). | Configure HA regional (Cloud SQL HA, Memorystore Standard Tier, réplicas) y declare la propiedad "ha" "true" en el deploymentNode. |
| 6 | WARN | R5-SPOF | Volarte › Memorystore | Posible Single Point of Failure: 3 contenedor(es) dependen de él y su nodo de despliegue no declara alta disponibilidad (ha=true / instances>1). | Configure HA regional (Cloud SQL HA, Memorystore Standard Tier, réplicas) y declare la propiedad "ha" "true" en el deploymentNode. |
| 7 | INFO | R4-Trazabilidad | proyectos/volarte/CHANGELOG_DSL.md | Regla de trazabilidad omitida (--skip-traceability). |  |
| 8 | INFO | R5-Decisión Pendiente | PriceProvider Externo | Elemento marcado como decisión PENDING. | Cierre la decisión con un ADR (Accepted) y retire el tag Pending. |
| 9 | INFO | R5-Decisión Pendiente | Volarte › Svc: Asignación / Optimización | Elemento marcado como decisión PENDING. | Cierre la decisión con un ADR (Accepted) y retire el tag Pending. |
| 10 | INFO | R5-Decisión Pendiente | Volarte › Svc: Comercial › Resolutor PriceProvider | Elemento marcado como decisión PENDING. | Cierre la decisión con un ADR (Accepted) y retire el tag Pending. |
