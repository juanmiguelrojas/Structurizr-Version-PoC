# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Relaciones de la página 'L3 · App Movil' (vista L3_App_Movil)
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: FF5uxJXjgTfR0MfS2Fa0-4
am_disparadorDeSync -> am_capturaDeEvidencia "" "" "pagina:L3_App_Movil"
# Draw.io: mob-e1
am_navegacion -> am_moduloDeAutenticacion "usa" "" "pagina:L3_App_Movil"
# Draw.io: mob-e2
am_moduloDeAutenticacion -> entraId "login SSO (solo Entra ID)" "" "pagina:L3_App_Movil"
# Draw.io: mob-e3  (extremo inferido por geometría)
am_navegacion -> am_baseDeDatosLocal "lee/escribe" "" "pagina:L3_App_Movil"
# Draw.io: mob-e4
am_baseDeDatosLocal -> am_motorDeSincronizacion "cola pendiente" "" "pagina:L3_App_Movil"
# Draw.io: mob-e5
am_capturaDeEvidencia -> am_baseDeDatosLocal "referencia archivo" "" "pagina:L3_App_Movil"
# Draw.io: mob-e6
am_disparadorDeSync -> am_motorDeSincronizacion "dispara sync" "" "pagina:L3_App_Movil"
# Draw.io: mob-e7
am_motorDeSincronizacion -> am_clienteApi "al reconectar" "" "pagina:L3_App_Movil"
# Draw.io: mob-e8
am_clienteApi -> am_netskopeClientZtna "sync (online)" "" "pagina:L3_App_Movil"
# Draw.io: mob-e9
am_netskopeClientZtna -> vo_bffMovil "ZTNA / mTLS" "" "pagina:L3_App_Movil"
# Draw.io: mob-e10
am_motorDeSincronizacion -> am_gestorDeEstadosDeSincronizacion "actualiza estado / backoff exponencial" "" "pagina:L3_App_Movil"
# Draw.io: mob-e11
am_motorDeSincronizacion -> am_componentName "detecta conflicto local" "" "pagina:L3_App_Movil"
# Draw.io: mob-e12
am_componentName -> am_gestorDeEstadosDeSincronizacion "bloquea reintento hasta revisión" "" "pagina:L3_App_Movil"
# Draw.io: mob-e13
am_baseDeDatosLocal -> am_cifradoLocalEnReposo "cifra en reposo" "" "pagina:L3_App_Movil"
