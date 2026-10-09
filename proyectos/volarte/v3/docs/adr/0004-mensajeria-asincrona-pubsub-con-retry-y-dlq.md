# 4. Mensajería asíncrona con Pub/Sub, retry y Dead Letter Topic (HU-055)

Date: 2026-10-08

## Status

Accepted

## Context

Al cerrar una operación se deben disparar varias acciones independientes: publicar el documento de entrega (HU-055),
actualizar saldo/crédito y finalizar/anular la operación. Acoplarlas de forma síncrona en el BFF Móvil afectaría la sync offline.

## Decision

- Topics: `operacion-cerrada` (fan-out a 3 suscriptores), `conciliacion-resuelta` (HU-050), `doc-publicacion` (HU-055) y `tracking-eventos`.
- Suscripciones **push** autenticadas con token OIDC, **5 reintentos** con backoff 10 s – 600 s y **Dead Letter Topic** con revisión manual.
- El Gestor Documental es idempotente: un reintento no genera un segundo documento y retorna un ID inmutable.

## Consequences

- Consistencia eventual entre Operación, Comercial y Gestor Documental.
- Se debe monitorear el Dead Letter Topic (alerta en Cloud Monitoring / Dynatrace).
