# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Relaciones de la página 'L0 · Referencia' (vista L0_Referencia)
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: sR61ePaMgubpxd_IzPhU-1
po_hubFront -> po_backendHubWeb "REST/JSON · JWT" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-2  (extremo inferido por geometría)
po_portalesRemoteModulo -> po_backendHubWeb "REST · JWT" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-3
po_backendHubWeb -> apigee "gRPC / REST" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-4
po_svcUsuariosAuth -> po_cloudSqlPostgresql "SQL" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-5
po_svcWiki -> po_database "Firestore SDK" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-6
po_svcWiki -> po_search "Elasticsearch API" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-7
po_backendHubWeb -> po_memorystoreRedis "Redis SDK" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-8
entraId -> po_svcUsuariosAuth "OIDC / SCIM sync" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-9
po_svcWiki -> po_storage "Almacen de data no estructurada" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-27
po_hubFront -> ss_identityAwareProxyIap "Verifica Autenticacion" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-29
ztna -> ss_globalLoadBalancer "Sync Red Corporativa Privada" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-30
ss_globalLoadBalancer -> po_hubFront "HTTPS · TLS 1.3" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-31
ss_identityAwareProxyIap -> po_hubFront "Sirve SPA + JWT" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-33
ss_identityAwareProxyIap -> entraId "OIDC redirect" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-36
po_cloudLogging -> po_cloudMonitoring "Métricas · alertas" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-41
ss_secretManager -> ss_cloudKms "Cifra secretos con CMEK" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-43
po_cloudSqlPostgresql -> ss_cloudKms "Lee client secrets · IAM SA" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-45
ss_cloudKms -> po_storage "CMEK cifrado en reposo" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-47
po_backendHubWeb -> ss_secretManager "Lee secretos · IAM SA" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-49
cloudflare -> ss_globalLoadBalancer "Sync Red Publica" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-54
po_portalesRemoteModulo -> po_federationBridge "Redirect + token hint" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-56
po_hubFront -> po_portalesRemoteModulo "Enruta al modulo" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-57
po_hubFront -> po_federationBridge "POST /federar {token, destino: \"portal\"}" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-59
po_federationBridge -> ss_portalesExternosFuturos "Redirect + JWT (token relay)" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-61
po_svcPowerBiProxy -> ss_powerBiService "Power BI REST API · AAD" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-64
po_appMovil -> entraId "Verifica Autenticacion" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-67
po_backendHubWebMovil -> ilbTransversal "" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-69
po_svcAnalitica -> datalake "Fuente de datos/ Entrega de data" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-74
po_svcUsuariosAuth -> apigee "Expone" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-76
po_svcWiki -> apigee "Expone" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-78
po_svcAnalitica -> apigee "Expone" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-80
po_svcPowerBiProxy -> apigee "Expone" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-92
po_svcNotificacion -> po_svcPagos "Notifica" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-95
po_svcPagos -> po_colaDeMensajeria "Consume y publica topics" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-97
po_colaDeMensajeria -> po_svcNotificacion "Consume y publica topics" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-99
po_backendHubWebMovil -> apigee "gRPC / REST" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-100
po_backendHubWebMovil -> po_memorystoreRedisFree "Redis SDK" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-104
ilbTransversal -> proxyApigee "Enruta la comunicacion" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-106
apigee -> proxyApigee "Enruta la comunicacion" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-111
pe_empleadoInterno -> po_hubFront "Accede al portal SSO (HTTPS) Navega wiki, lanza apps, federa" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-112  (extremo inferido por geometría)
pe_empleadoInterno -> po_appMovil "Accede desde la app en el movil por sso" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-114
po_appMovil -> ss_dynatraceTenantTerpel "RUM Agent" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-117
pe_usuarioExterno -> po_appMovil "Accede desde la app en el movil por sso" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-120
pe_usuarioExterno -> po_hubFront "Accede al portal (HTTPS) Navega wiki, lanza apps, federa" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-121
po_appMovil -> po_backendHubWebMovil "HTTPS · Bearer JWT (sin IAP)" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-125
po_colaDeMensajeria -> datalake "" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-129
po_otelCollector -> ss_dynatraceTenantTerpel "OTLP HTTPS Api Token" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-132
po_hubFront -> ss_dynatraceTenantTerpel "OTLP gRPC Auth: IAM Invoker" "" "pagina:L0_Referencia"
# Draw.io: sR61ePaMgubpxd_IzPhU-134
po_backendHubWeb -> ilbTransversal "" "" "pagina:L0_Referencia"
# Anotación sin relación de modelo (extremo en boundary 'Transversal'): Draw.io sR61ePaMgubpxd_IzPhU-19 ''
# Anotación sin relación de modelo (extremo en boundary 'Transversal'): Draw.io sR61ePaMgubpxd_IzPhU-123 'Se integra'
# Anotación sin relación de modelo (extremo en nota/texto libre): Draw.io sR61ePaMgubpxd_IzPhU-127 ''
