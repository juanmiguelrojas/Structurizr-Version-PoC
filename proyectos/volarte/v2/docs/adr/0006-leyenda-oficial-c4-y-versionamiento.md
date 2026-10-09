# 6. Leyenda oficial C4 y versionamiento por carpetas

Date: 2026-10-09

## Status

Accepted

## Context

La v1 de Volarte usaba una paleta propia por tag (rojo Terpel, verde para bases de datos, morado para colas…).
Esto hacía que cada proyecto pudiera inventar su notación y que los diagramas no fueran comparables
con la leyenda C4 que usa la Dirección de Arquitectura en Draw.io. Además, los cambios sobre la arquitectura
se sobrescribían sin dejar las versiones anteriores consultables.

## Decision

- Todos los proyectos usan la **leyenda oficial C4** definida en `estandares/c4/estilos-c4.dsl`
  (Person `#083F75`, Software System `#1061B0`, Container `#23A2D9`, Component `#63BEF2`,
  External Person `#6C6477`, External Software System `#8C8496`). Solo esos tags asignan colores (regla R7).
- Cada diagrama exportado incluye la leyenda y el PDF incluye una página de leyenda.
- Cada proyecto se versiona por carpetas (`proyectos/<proyecto>/v<N>`); una versión aprobada o reemplazada
  queda congelada (regla R6) y los cambios se hacen en una versión nueva.

## Consequences

- v1 de Volarte queda congelada como evidencia (estado `reemplazada`); v2 aplica la leyenda.
- Cualquier estilo nuevo debe limitarse a forma o borde; los colores nuevos requieren modificar el estándar corporativo.
