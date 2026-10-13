# 7. Réplica fiel del Draw.io: modelo C4 deduplicado + presentación por vista

Date: 2026-10-09

## Status

Accepted

## Context

La Dirección de Arquitectura revisó v2 y encontró que, aunque la leyenda C4 se cumplía, los colores de muchos
elementos no coincidían con los diagramas aprobados en Draw.io y que las personas se dibujaban como cajas.
En el Draw.io el color de una forma depende de la página (p. ej. Entra ID es azul en el L1 y gris en el L0/L2;
en los L3 los contenedores vecinos se pintan en gris como "Contenedor externo"). Structurizr asigna estilos por
tag de forma global, por lo que no puede reproducir colores distintos del mismo elemento en vistas distintas, y el
exportador Mermaid dibuja las personas como cajas.

## Decision

- Importar el Draw.io con `scripts/drawio2structurizr.py` (inventario + mapa curado `fuente/mapeo-drawio.json`):
  - **Modelo** C4 deduplicado y tipado (una cosa real = un elemento), con procedencia `drawio.ocurrencias`.
  - **Presentación** por vista (`dsl/layout/<vista>.json`): posiciones, boundaries, notas, clase de color y textos
    tal como los muestra cada página (alias de presentación).
- Dibujar con `scripts/render-c4.mjs` en notación Draw.io C4: silueta de persona, cilindros, boundaries punteados,
  conectores ortogonales con los waypoints del Draw.io y leyenda oficial.
- Validar la fidelidad contra la fuente en cada build (`scripts/c4_scene.py`, regla **R9**): cualquier diferencia de
  elemento, texto, color, forma, conector o etiqueta es un error.
- Mantener las exportaciones estándar de Structurizr (JSON, Mermaid, C4-PlantUML) desde el mismo DSL.

## Consequences

- Los diagramas publicados son visualmente equivalentes al Draw.io y trazables forma por forma.
- El DSL de v3 es la fuente de verdad a partir de ahora; el importador solo se vuelve a usar si cambia el Draw.io.
- La capa de presentación es un artefacto versionado más: mover elementos se hace editando `dsl/layout/`.
- Las inconsistencias del propio Draw.io no se corrigen en silencio: se documentan en `REVISION.md` para decisión.
