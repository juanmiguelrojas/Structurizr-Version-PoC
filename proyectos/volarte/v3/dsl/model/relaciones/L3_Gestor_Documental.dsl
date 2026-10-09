# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Relaciones de la página 'L3 · Gestor Documental' (vista L3_Gestor_Documental)
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: doc-e1
vo_colaDeMensajeria -> gd_suscriptorPubSub "recibe evento" "" "pagina:L3_Gestor_Documental"
# Draw.io: doc-e2
gd_suscriptorPubSub -> gd_generadorDeDocumento "genera" "" "pagina:L3_Gestor_Documental"
# Draw.io: doc-e3  (extremo inferido por geometría)
gd_generadorDeDocumento -> gd_motorDePlantillas "renderiza" "" "pagina:L3_Gestor_Documental"
# Draw.io: doc-e4
gd_generadorDeDocumento -> gd_asignadorDeNumeracion "asigna número" "" "pagina:L3_Gestor_Documental"
# Draw.io: doc-e5  (extremo inferido por geometría)
gd_asignadorDeNumeracion -> vo_cloudSqlPostgresql "persiste número" "" "pagina:L3_Gestor_Documental"
# Draw.io: doc-e6  (extremo inferido por geometría)
gd_motorDePlantillas -> gd_publicador "publica" "" "pagina:L3_Gestor_Documental"
# Draw.io: doc-e7  (extremo inferido por geometría)
gd_publicador -> gd_clienteGcs "sube" "" "pagina:L3_Gestor_Documental"
# Draw.io: p3czn_rpy_i9IkPloGag-4
gd_clienteGcs -> vo_documentosGcs "" "" "pagina:L3_Gestor_Documental"
