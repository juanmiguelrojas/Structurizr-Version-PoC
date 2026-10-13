# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Relaciones de la página 'L3 · BFF Web' (vista L3_BFF_Web)
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: bffw-e1  (extremo inferido por geometría)
apigee -> bw_apiRouterControllers "recibe petición" "" "pagina:L3_BFF_Web"
# Draw.io: bffw-e2
bw_apiRouterControllers -> bw_middlewareDeAutenticacion "valida" "" "pagina:L3_BFF_Web"
# Draw.io: bffw-e3
bw_middlewareDeAutenticacion -> bw_servicioDeAutorizacion "resuelve rol" "" "pagina:L3_BFF_Web"
# Draw.io: bffw-e4
bw_servicioDeAutorizacion -> bw_clienteDeCache "lee/escribe cache" "" "pagina:L3_BFF_Web"
# Draw.io: bffw-e5
bw_servicioDeAutorizacion -> bw_orquestadorDeDominio "autorizado →" "" "pagina:L3_BFF_Web"
# Draw.io: bffw-e6
bw_orquestadorDeDominio -> bw_clienteDeSecretos "lee secretos" "" "pagina:L3_BFF_Web"
# Draw.io: bffw-e7
bw_orquestadorDeDominio -> bw_clientesDeServicios "orquesta" "" "pagina:L3_BFF_Web"
# Draw.io: bffw-e8
bw_clientesDeServicios -> ce_serviciosDeDominio "llama (IAM Invoker)" "" "pagina:L3_BFF_Web"
