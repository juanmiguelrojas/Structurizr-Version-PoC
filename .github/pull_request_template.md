## Cambio de arquitectura

- **Proyecto / versión:** `proyectos/<proyecto>/v<N>`
- **Entrada de bitácora:** `AAC-AAAAMMDD-NN`
- **Ref (HU / Jira / P-NNN):**
- **Tipo:** Nuevo elemento · Modificación · Eliminación · Vista · Nueva versión · Aprobación de versión · Lineamientos / herramientas

### Resumen
<!-- Qué cambia y por qué (2-5 líneas). -->

### Diagramas afectados
<!-- Vistas (L1_…, L2_…, L3_…, D…, DEP_…) y, si ayuda, captura del PNG generado. -->

## Checklist del autor

- [ ] `scripts/aac-build.sh proyectos/<p>/v<N>` ejecutado localmente sin errores
- [ ] Entrada en `CHANGELOG_DSL.md` del proyecto con versión, fecha UTC/COT, autor, ref, archivos, contexto, impacto y sugerencias del revisor
- [ ] ADR nuevo / actualizado si cambia tecnología, protocolo, límite de contenedor, seguridad o despliegue
- [ ] `version.json` actualizado (descripción, `changelog[]`; estado si aplica)
- [ ] No se modificó ninguna versión congelada (aprobada / reemplazada / obsoleta)
- [ ] Advertencias R5 atendidas o justificadas en la bitácora

## Checklist del revisor (ver `docs/lineamientos/05-revision-y-aprobacion.md`)

- [ ] Leyenda C4 correcta y visible en los diagramas; externos con `External Person` / `External Software System`
- [ ] Elementos en el nivel C4 correcto; relaciones con propósito y tecnología/protocolo
- [ ] Seguridad, resiliencia, observabilidad y despliegue coherentes
- [ ] Stack tecnológico (`docs/workspace/`) consistente con el modelo
- [ ] Trazabilidad completa (bitácora, ADR, version.json)
