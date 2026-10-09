# 1. Adoptar Architecture as Code con Structurizr DSL

Date: 2026-10-08

## Status

Accepted

## Context

La arquitectura de Volarte (Fase I) se documentó en Draw.io (`Arquitectura_volarte_1.drawio`, 13 páginas, 17/08/2026).
Los diagramas dibujados a mano divergen entre niveles (p. ej. el mismo contenedor con descripciones distintas en L0 y L2),
no son verificables automáticamente y no dejan trazabilidad de quién cambió qué y por qué.

## Decision

- El modelo C4 de Volarte se mantiene como código en `dsl/` (Structurizr DSL), modular por personas, sistemas, contenedores, componentes, despliegue y vistas.
- Un único modelo genera todas las vistas (L0, L1, L2, L3, dinámicas y despliegue).
- Todo cambio en `dsl/` exige una entrada en `docs/CHANGELOG_DSL.md` y, cuando el impacto es estructural, un ADR.
- El pipeline `architecture-pipeline.yml` valida sintaxis, ejecuta el Agente Revisor y genera artefactos (MMD, SVG, PNG, PDF).

## Consequences

- El Draw.io queda congelado como fuente histórica; los cambios se hacen en el DSL.
- Los arquitectos requieren Java 17+ y Node 18+ (o el pipeline) para renderizar localmente.
- Las reglas de gobierno (descripciones, tecnologías, aislamiento de capas, trazabilidad) se aplican automáticamente en cada PR.
