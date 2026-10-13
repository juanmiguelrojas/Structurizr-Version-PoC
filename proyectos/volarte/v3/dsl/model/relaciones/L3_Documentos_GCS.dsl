# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Relaciones de la página 'L3 · Documentos GCS' (vista L3_Documentos_GCS)
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: gcs-e1
vo_gestorDocumental -> dg_estructuraDeCarpetas "escribe" "" "pagina:L3_Documentos_GCS"
# Draw.io: gcs-e2  (extremo inferido por geometría)
dg_estructuraDeCarpetas -> dg_politicaDeCicloDeVida "organiza" "" "pagina:L3_Documentos_GCS"
# Draw.io: gcs-e3  (extremo inferido por geometría)
dg_politicaDeCicloDeVida -> dg_versionadoWorm "aplica" "" "pagina:L3_Documentos_GCS"
# Draw.io: gcs-e4  (extremo inferido por geometría)
dg_estructuraDeCarpetas -> dg_iamDelBucket "controla acceso" "" "pagina:L3_Documentos_GCS"
# Draw.io: gcs-e6
dg_iamDelBucket -> dg_cifradoEnReposo "cifra" "" "pagina:L3_Documentos_GCS"
