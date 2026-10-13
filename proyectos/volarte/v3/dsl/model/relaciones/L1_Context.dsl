# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Relaciones de la página 'L1 · Context' (vista L1_Context)
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: jBqDDpGHMn_ggPszUGn9-2
pe_adminDevTeam -> portal "Administra módulos y permisos" "" "pagina:L1_Context"
# Draw.io: jBqDDpGHMn_ggPszUGn9-3
portal -> entraId "Delega autenticación" "OIDC / OAuth 2.0" "pagina:L1_Context"
# Draw.io: jBqDDpGHMn_ggPszUGn9-4
portal -> ss_sistemasExternosFuturos "Consulta / Actualiza REST API" "" "pagina:L1_Context"
# Draw.io: jBqDDpGHMn_ggPszUGn9-5
portal -> ss_googleCloudPlatform "Desplegado en GCP" "Cloud Run · SQL · GCS · BigQuery" "pagina:L1_Context"
# Draw.io: jBqDDpGHMn_ggPszUGn9-10
portal -> ss_webappsExternosFuturos "Federa sesión (SSO seamless)" "SAML 2.0 / OIDC token exchange" "pagina:L1_Context"
# Draw.io: jBqDDpGHMn_ggPszUGn9-13
ss_sistemasExternosFuturos -> ce_capacidadesTransversales "Todos los portales cumplen con" "" "pagina:L1_Context"
# Draw.io: jBqDDpGHMn_ggPszUGn9-16
ss_webappsExternosFuturos -> ce_capacidadesTransversales "Todos los portales cumplen con" "" "pagina:L1_Context"
# Draw.io: jBqDDpGHMn_ggPszUGn9-32
pe_usuarioExterno -> portal "Accede al portal (HTTPS) Navega wiki, lanza apps, federa" "" "pagina:L1_Context"
# Draw.io: jBqDDpGHMn_ggPszUGn9-35
portal -> ss_ciam "Delega autenticación" "OIDC / OAuth 2.0" "pagina:L1_Context"
# Draw.io: jBqDDpGHMn_ggPszUGn9-36
portal -> datalake "Fuente de datos/ Entrega de data" "" "pagina:L1_Context"
# Draw.io: jBqDDpGHMn_ggPszUGn9-40
pe_empleadoInterno -> portal "Accede al portal SSO (HTTPS) Navega wiki, lanza apps, federa" "" "pagina:L1_Context"
