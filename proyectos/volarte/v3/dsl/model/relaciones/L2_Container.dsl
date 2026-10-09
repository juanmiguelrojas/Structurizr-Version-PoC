# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Relaciones de la página 'L2 · Container' (vista L2_Container)
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: p8cCmguKJE-8GRD_PWvh-5
ss_externalRegionalLoadBalancer -> cloudflare "DNS apunta a IP del LB externo pass trougth" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-7
ss_externalRegionalLoadBalancer -> firewall "Resuelve los NAT Respectivos" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-11
firewall -> ilbTransversal "Reenvia el trafico" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-13
proxyApigee -> apigee "Reenvia trafico" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-20
ilbTransversal -> proxyApigee "Reenvia trafico" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-23
vo_frontendWeb -> apigee "REST/JSON · JWT (API, sin caché)" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-24
vo_bffBackendVolarte -> vo_memorystore "Redis SDK" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-28
apigee -> vo_internalLoadBalancer "" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-29
vo_internalLoadBalancer -> vo_bffMovil "Resuelve peticiones Moviles" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-34
vo_internalLoadBalancer -> vo_bffBackendVolarte "Resuelve peticiones Web" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-36  (extremo inferido por geometría)
vo_bffBackendVolarte -> vo_cloudSqlPostgresql "Consultas varias Proxy SQL" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-37
vo_frontendWeb -> entraId "login SSO / tokens (PKCE)" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-41
vo_cloudSqlPostgresql -> vo_cloudKms "Lee client secrets · IAM SA" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-44
vo_secretManager -> vo_cloudKms "Cifra secretos con CMEK" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-46
vo_bffBackendVolarte -> vo_secretManager "Lee secretos · IAM SA" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-55  (extremo inferido por geometría)
vo_bffBackendVolarte -> vo_svcUsuariosAuth "orquesta cada servicio que no va por PUB/SUB" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-55  (extremo inferido por geometría)
vo_bffBackendVolarte -> vo_gestorDocumental "orquesta cada servicio que no va por PUB/SUB" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-55  (extremo inferido por geometría)
vo_bffBackendVolarte -> vo_svcDatosMaestros "orquesta cada servicio que no va por PUB/SUB" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-55  (extremo inferido por geometría)
vo_bffBackendVolarte -> vo_svcComercial "orquesta cada servicio que no va por PUB/SUB" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-55  (extremo inferido por geometría)
vo_bffBackendVolarte -> vo_svcOperacion "orquesta cada servicio que no va por PUB/SUB" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-55  (extremo inferido por geometría)
vo_bffBackendVolarte -> vo_svcAsignacionOptimizacion "orquesta cada servicio que no va por PUB/SUB" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-57
vo_bffMovil -> vo_colaDeMensajeria "Publica y consume Topics" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-58
vo_colaDeMensajeria -> vo_gestorDocumental "suscripción (retry + DLQ)" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-59
vo_bffBackendVolarte -> vo_colaDeMensajeria "Publica y consume Topics" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-60
vo_colaDeMensajeria -> vo_svcComercial "suscripción" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-61
vo_colaDeMensajeria -> vo_svcOperacion "suscripción: tracking-eventos" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-64
pe_empleadoInterno -> cloudflare "Accede al portal SSO (HTTPS) Navega wiki, lanza apps, federa" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-66
pe_usuarioExterno -> cloudflare "Accede al portal (HTTPS) Navega wiki, lanza apps, federa" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-72
pe_operarioDeEquipoAbastecedor -> vo_appMovil "Accede a la APP Movil" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-73
vo_appMovil -> entraId "login SSO (solo Entra ID)" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-74
vo_appMovil -> ztna "tráfico gestionado (túnel MDM)" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-76
ztna -> apigee "acceso privado (ZTNA) — sin Cloudflare" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-78
vo_bffMovil -> vo_secretManager "Lee secretos · IAM SA" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-80
vo_bffMovil -> vo_cloudSqlPostgresql "Consultas varias Proxy SQL" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-81  (extremo inferido por geometría)
vo_bffMovil -> vo_svcUsuariosAuth "orquesta cada servicio que no va por PUB/SUB" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-81  (extremo inferido por geometría)
vo_bffMovil -> vo_gestorDocumental "orquesta cada servicio que no va por PUB/SUB" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-81  (extremo inferido por geometría)
vo_bffMovil -> vo_svcDatosMaestros "orquesta cada servicio que no va por PUB/SUB" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-81  (extremo inferido por geometría)
vo_bffMovil -> vo_svcComercial "orquesta cada servicio que no va por PUB/SUB" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-81  (extremo inferido por geometría)
vo_bffMovil -> vo_svcOperacion "orquesta cada servicio que no va por PUB/SUB" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-81  (extremo inferido por geometría)
vo_bffMovil -> vo_svcAsignacionOptimizacion "orquesta cada servicio que no va por PUB/SUB" "" "pagina:L2_Container"
# Draw.io: p8cCmguKJE-8GRD_PWvh-82
vo_bffMovil -> vo_memorystore "Redis SDK" "" "pagina:L2_Container"
