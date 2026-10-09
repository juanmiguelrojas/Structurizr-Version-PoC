# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Relaciones de la página 'L3 · Svc Comercial' (vista L3_Svc_Comercial)
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: com-e1  (extremo inferido por geometría)
sc_apiRouter -> sc_motorDeElegibilidad "enruta" "" "pagina:L3_Svc_Comercial"
# Draw.io: com-e2
sc_apiRouter -> sc_resolutorPriceprovider "enruta" "" "pagina:L3_Svc_Comercial"
# Draw.io: com-e3  (extremo inferido por geometría)
sc_apiRouter -> sc_servicioDeCreditoDisponible "enruta" "" "pagina:L3_Svc_Comercial"
# Draw.io: com-e4  (extremo inferido por geometría)
sc_resolutorPriceprovider -> ss_priceproviderExterno "consulta (cuando se confirme)" "" "pagina:L3_Svc_Comercial"
# Draw.io: com-e5  (extremo inferido por geometría)
vo_colaDeMensajeria -> sc_suscriptorOperacionCerrada "recibe evento" "" "pagina:L3_Svc_Comercial"
# Draw.io: com-e6  (extremo inferido por geometría)
sc_suscriptorOperacionCerrada -> sc_servicioDeCreditoDisponible "actualiza" "" "pagina:L3_Svc_Comercial"
# Draw.io: com-e7  (extremo inferido por geometría)
sc_servicioDeCreditoDisponible -> sc_clienteDeBaseDeDatos "persiste" "" "pagina:L3_Svc_Comercial"
# Draw.io: com-e8  (extremo inferido por geometría)
sc_clienteDeBaseDeDatos -> vo_bffBackendVolarte "consultado por" "" "pagina:L3_Svc_Comercial"
