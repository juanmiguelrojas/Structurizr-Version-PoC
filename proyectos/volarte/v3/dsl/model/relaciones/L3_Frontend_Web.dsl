# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Relaciones de la página 'L3 · Frontend Web' (vista L3_Frontend_Web)
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: fw-e1
fw_appShellRouter -> fw_moduloDeAutenticacion "usa" "" "pagina:L3_Frontend_Web"
# Draw.io: fw-e2
fw_moduloDeAutenticacion -> entraId "login SSO/tokens (PKCE)" "" "pagina:L3_Frontend_Web"
# Draw.io: fw-e3
fw_appShellRouter -> fw_vistasPorRol "autenticado →" "" "pagina:L3_Frontend_Web"
# Draw.io: fw-e4
fw_vistasPorRol -> fw_clienteApi "solicita datos" "" "pagina:L3_Frontend_Web"
# Draw.io: fw-e5
fw_clienteApi -> apigee "REST/JSON · JWT" "" "pagina:L3_Frontend_Web"
# Draw.io: fw-e6
fw_clienteApi -> fw_cacheDeEstadoServidor "cachea respuestas" "" "pagina:L3_Frontend_Web"
# Draw.io: fw-e7
fw_vistasPorRol -> fw_errorBoundaryTelemetria "reporta errores" "" "pagina:L3_Frontend_Web"
