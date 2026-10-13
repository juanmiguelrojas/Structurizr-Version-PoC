# 5. Runtime del Svc Asignación / Optimización en GKE

Date: 2026-10-08

## Status

Proposed

## Context

El servicio S06 ejecuta un motor MILP y consume recomendaciones de Skypredict con degradación controlada.
El cómputo es sostenido y no se ajusta bien a los límites de Cloud Run. El Draw.io lo marca como **P-025 PENDING**.

## Decision

Se recomienda GKE (Autopilot) para el Svc Asignación. El owner y el runtime final los confirma la Dirección de Arquitectura.

## Consequences

- Elemento modelado con tag `Pending` (borde punteado ámbar) hasta su confirmación.
- Al confirmarse, actualizar este ADR a `Accepted` y registrar el cambio en `CHANGELOG_DSL.md`.
