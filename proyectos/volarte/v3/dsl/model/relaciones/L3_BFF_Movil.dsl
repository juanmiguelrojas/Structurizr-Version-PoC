# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Relaciones de la página 'L3 · BFF Movil' (vista L3_BFF_Movil)
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: 9QahTo7XVIhn2NQbdA9p-4
bm_manejadorDeSubida -> bm_publicadorDeEventos "Publica eventos" "" "pagina:L3_BFF_Movil"
# Draw.io: bffm-e1
apigee -> bm_apiRouterControllers "recibe sync" "" "pagina:L3_BFF_Movil"
# Draw.io: bffm-e2
bm_apiRouterControllers -> bm_middlewareDeAutenticacion "valida" "" "pagina:L3_BFF_Movil"
# Draw.io: bffm-e3
bm_middlewareDeAutenticacion -> bm_servicioDeAutorizacion "resuelve rol" "" "pagina:L3_BFF_Movil"
# Draw.io: bffm-e4
bm_servicioDeAutorizacion -> bm_motorDeReconciliacion "reconcilia" "" "pagina:L3_BFF_Movil"
# Draw.io: bffm-e5
bm_motorDeReconciliacion -> bm_servicioDeIdempotencia "dedupe" "" "pagina:L3_BFF_Movil"
# Draw.io: bffm-e6
bm_motorDeReconciliacion -> bm_proveedorDeDelta "catálogos/turnos" "" "pagina:L3_BFF_Movil"
# Draw.io: bffm-e7
vo_colaDeMensajeria -> vo_svcOperacion "orquesta operación" "" "pagina:L3_BFF_Movil"
# Draw.io: bffm-e8
bm_motorDeReconciliacion -> bm_manejadorDeSubida "fotos/firma" "" "pagina:L3_BFF_Movil"
# Draw.io: bffm-e9
vo_colaDeMensajeria -> vo_documentosGcs "resumable upload" "" "pagina:L3_BFF_Movil"
# Draw.io: bffm-e10
bm_motorDeReconciliacion -> bm_publicadorDeEventos "al cerrar operación" "" "pagina:L3_BFF_Movil"
# Draw.io: bffm-e11
bm_publicadorDeEventos -> vo_colaDeMensajeria "publica" "" "pagina:L3_BFF_Movil"
# Draw.io: bffm-e12
bm_servicioDeIdempotencia -> bm_validadorDeOrdenSecuencia "aplica en orden (timestamp captura)" "" "pagina:L3_BFF_Movil"
# Draw.io: bffm-e13
bm_validadorDeOrdenSecuencia -> bm_motorDeReconciliacion "secuencia validada" "" "pagina:L3_BFF_Movil"
# Draw.io: bffm-e14
bm_motorDeReconciliacion -> bm_clienteCloudSql "persiste offline_actions_log / PENDING_REVIEW" "" "pagina:L3_BFF_Movil"
# Draw.io: bffm-e15
bm_clienteCloudSql -> vo_cloudSqlPostgresql "escribe/lee" "" "pagina:L3_BFF_Movil"
