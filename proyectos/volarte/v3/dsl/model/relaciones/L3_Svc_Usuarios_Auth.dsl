# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Relaciones de la página 'L3 · Svc Usuarios Auth' (vista L3_Svc_Usuarios_Auth)
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: auth-e1  (extremo inferido por geometría)
su_auditor -> ce_bffWebBffMovil "consulta" "" "pagina:L3_Svc_Usuarios_Auth"
# Draw.io: auth-e2
ce_bffWebBffMovil -> su_apiRouter "recibe petición" "" "pagina:L3_Svc_Usuarios_Auth"
# Draw.io: auth-e3  (extremo inferido por geometría)
su_apiRouter -> su_resolverGrouptorolemapping "resuelve" "" "pagina:L3_Svc_Usuarios_Auth"
# Draw.io: auth-e4
su_resolverGrouptorolemapping -> su_adaptadorDeSincronizacionEntraId "consulta grupos" "" "pagina:L3_Svc_Usuarios_Auth"
# Draw.io: auth-e5
su_adaptadorDeSincronizacionEntraId -> entraId "sincroniza" "" "pagina:L3_Svc_Usuarios_Auth"
# Draw.io: auth-e6  (extremo inferido por geometría)
su_resolverGrouptorolemapping -> su_auditor "registra" "" "pagina:L3_Svc_Usuarios_Auth"
# Draw.io: auth-e7
su_auditor -> su_invalidadorDeCache "invalida en cambio de rol" "" "pagina:L3_Svc_Usuarios_Auth"
# Draw.io: auth-e8
su_invalidadorDeCache -> vo_memorystore "notifica" "" "pagina:L3_Svc_Usuarios_Auth"
# Draw.io: auth-e9  (extremo inferido por geometría)
su_auditor -> su_clienteCloudSql "persiste" "" "pagina:L3_Svc_Usuarios_Auth"
# Draw.io: auth-e10
su_clienteCloudSql -> vo_cloudSqlPostgresql "lee/escribe" "" "pagina:L3_Svc_Usuarios_Auth"
