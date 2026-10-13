## Volarte · Documentación de Arquitectura (v3)

**v3 es la réplica fiel del Draw.io** `Arquitectura_volarte_1.drawio` (Terpel · Dirección de Arquitectura ·
Versión 1 · Fase I · Kevin Montoya · 17/08/2026) como modelo C4 en Structurizr: cada una de sus **13 páginas** es
una vista, con los mismos elementos, textos, tipos, colores por página, personas con silueta de actor, boundaries,
conectores y disposición.

| Atributo | Valor |
|---|---|
| Proyecto / versión | `proyectos/volarte` · **v3** (basada en v2; reemplaza a v2) |
| Fuente | `proyectos/volarte/v1/fuente/Arquitectura_volarte_1.drawio` |
| Importación | `scripts/drawio2structurizr.py` + mapa curado `fuente/mapeo-drawio.json` |
| Trazabilidad | `fuente/TRAZABILIDAD.md` (182 formas → 143 elementos · 197 relaciones) |
| Fidelidad | `docs/generated/fidelidad/fidelidad-drawio.md` (regla R9 del Agente Revisor) |
| Revisión | `REVISION.md` — decisiones y observaciones REV-01 … REV-14 |
| Notación | C4 · leyenda oficial · render en notación Draw.io C4 (`scripts/render-c4.mjs`) |

### Cómo se logra la fidelidad sin duplicar el modelo

```
 Draw.io (13 páginas) ──drawio_inventory.py──► inventario (formas, colores, geometría, conectores)
        │                                             │
        │                     mapeo-drawio.json ──────┤ (decisiones curadas, ver REVISION.md)
        │                                             ▼
        │                                drawio2structurizr.py
        │                       ┌─────────────────────┴─────────────────────┐
        │                       ▼                                           ▼
        │          MODELO C4 (dsl/model, dsl/views)           PRESENTACIÓN (dsl/layout/<vista>.json)
        │          un elemento por cosa real, tipado,         posición, boundaries, clase de color y
        │          con procedencia drawio.ocurrencias         texto que muestra CADA página
        │                       └──────────────┬────────────────────────────┘
        │                                      ▼
        │                     structurizr-cli (validate · inspect · export JSON/Mermaid/PlantUML)
        │                                      ▼
        └──────────── c4_scene.py: escena DRAWIO vs escena MODELO ──► informe de fidelidad (R9)
                                               ▼
                         render-c4.mjs ──► SVG / PNG / PNG alta resolución / PDF (+ referencia Draw.io)
```

- El **modelo** es semánticamente C4: Entra ID, Apigee, Cloud SQL… existen **una sola vez** aunque aparezcan en
  varias páginas con nombres o colores distintos.
- La **presentación** registra cómo los muestra cada página (p. ej. en los L3 los contenedores vecinos aparecen
  en gris como `[Contenedor externo]`). Esas diferencias de texto se llaman *alias de presentación* y están
  listadas en `fuente/TRAZABILIDAD.md`.
- El render dibuja con el **mismo motor** el modelo y la página original del Draw.io (`docs/generated/referencia-drawio/`),
  y el informe de fidelidad compara ambos: elementos, textos, colores, formas, conectores y etiquetas.

### Qué cambió frente a v2

| # | Cambio | Motivo |
|---|---|---|
| 1 | Colores **por elemento y por página exactamente como el Draw.io** (siempre dentro de la leyenda C4) | v2 aplicaba la leyenda por tipo de elemento y no coincidía con los diagramas aprobados |
| 2 | **Personas con silueta de actor** (cabeza + cuerpo) en todas las vistas | v2 exportaba con Mermaid, que dibuja las personas como cajas |
| 3 | Disposición, boundaries (proyectos GCP, capas), resaltados y bloque de título del Draw.io | Los diagramas deben verse como los originales |
| 4 | Nombres, tipos (`[Contenedor externo]`, `[Sistema Externo — Identidad]`…), descripciones y etiquetas literales del Draw.io | Fidelidad a la fuente aprobada |
| 5 | 13 vistas = 13 páginas (incluye L3 Documentos GCS, Svc Usuarios Auth, Gestor Documental, Svc Operación, Svc Comercial y la página L0 · Referencia completa) | v2 interpretaba/omitía partes |
| 6 | Validación automática de fidelidad (R9) y comentarios de revisión (`REVISION.md`) | Trazabilidad verificable |
| 7 | Las vistas de despliegue y dinámicas de v2 **no** pasan a v3 (no existen en el Draw.io) | Ver REV-12: se proponen para v4 |
