# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Relaciones de la página 'L3 · Svc Operacion' (vista L3_Svc_Operacion)
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: ops-e1
so_apiRouter -> so_gestorDeTurnos "enruta" "" "pagina:L3_Svc_Operacion"
# Draw.io: ops-e2  (extremo inferido por geometría)
so_apiRouter -> so_rastreadorDePosicion "enruta" "" "pagina:L3_Svc_Operacion"
# Draw.io: ops-e3  (extremo inferido por geometría)
so_apiRouter -> so_inventarioDeCalidad "enruta" "" "pagina:L3_Svc_Operacion"
# Draw.io: ops-e4
so_rastreadorDePosicion -> vo_svcDatosMaestros "consulta geocerca" "" "pagina:L3_Svc_Operacion"
# Draw.io: ops-e5  (extremo inferido por geometría)
vo_colaDeMensajeria -> so_suscriptorDeTracking "recibe eventos" "" "pagina:L3_Svc_Operacion"
# Draw.io: ops-e6  (extremo inferido por geometría)
so_suscriptorDeTracking -> so_rastreadorDePosicion "actualiza" "" "pagina:L3_Svc_Operacion"
# Draw.io: ops-e7  (extremo inferido por geometría)
so_gestorDeTurnos -> so_clienteDeBaseDeDatos "persiste" "" "pagina:L3_Svc_Operacion"
# Draw.io: ops-e8  (extremo inferido por geometría)
so_inventarioDeCalidad -> so_clienteDeBaseDeDatos "persiste" "" "pagina:L3_Svc_Operacion"
# Draw.io: ops-e9  (extremo inferido por geometría)
so_clienteDeBaseDeDatos -> ce_bffWebBffMovil "consultado por" "" "pagina:L3_Svc_Operacion"
