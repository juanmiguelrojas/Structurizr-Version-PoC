# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Relaciones de la página 'L3 · Pub-Sub' (vista L3_Pub_Sub)
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: ps-e1  (extremo inferido por geometría)
vo_bffMovil -> ps_topicOperacionCerrada "publica" "" "pagina:L3_Pub_Sub"
# Draw.io: ps-e2
ps_topicOperacionCerrada -> ps_subGestorDocumentalSub "entrega" "" "pagina:L3_Pub_Sub"
# Draw.io: ps-e3  (extremo inferido por geometría)
ps_topicOperacionCerrada -> ps_subComercialSub "entrega" "" "pagina:L3_Pub_Sub"
# Draw.io: ps-e4
ps_subGestorDocumentalSub -> vo_gestorDocumental "dispara" "" "pagina:L3_Pub_Sub"
# Draw.io: ps-e5
ps_subComercialSub -> vo_svcComercial "dispara" "" "pagina:L3_Pub_Sub"
# Draw.io: ps-e6  (extremo inferido por geometría)
ps_subGestorDocumentalSub -> ps_deadLetterTopic "tras 5 reintentos (backoff 10s-600s)" "" "pagina:L3_Pub_Sub"
# Draw.io: ps-e7
ps_subComercialSub -> ps_deadLetterTopic "tras 5 reintentos (backoff 10s-600s)" "" "pagina:L3_Pub_Sub"
# Draw.io: ps-e8
vo_bffBackendVolarte -> ps_topicConciliacionResuelta "publica (supervisor resuelve)" "" "pagina:L3_Pub_Sub"
# Draw.io: ps-e9
ps_topicConciliacionResuelta -> ps_subOperacionConciliacionSub "entrega" "" "pagina:L3_Pub_Sub"
# Draw.io: ps-e10
ps_subOperacionConciliacionSub -> vo_svcOperacion "finaliza / anula operación pendiente" "" "pagina:L3_Pub_Sub"
# Draw.io: ps-e11
ps_subOperacionConciliacionSub -> ps_deadLetterTopic "tras 5 reintentos (backoff 10s-600s)" "" "pagina:L3_Pub_Sub"
