# =============================================================================
# Personas / Actores  (Fuente: Draw.io Volarte v1 · páginas L0, L1, L2)
# =============================================================================

empleado = person "Empleado Interno" "Usuario corporativo (tenant Terpel) que accede a Volarte vía web con SSO de Entra ID: comercial, supervisión y administración." "Internal"

usuarioExterno = person "Usuario Externo" "Usuario que no está dentro del tenant de Terpel. Se autentica a través del CIAM (Ping Identity)." "External"

operario = person "Operario de Equipo Abastecedor" "Único rol que usa la app móvil. Opera en campo (plataforma/rampa) con o sin cobertura de red." "Internal,FieldOperator"

adminDev = person "Admin / Dev Team" "Gestiona módulos, publica versiones, administra permisos (GroupToRoleMapping) y monitorea el uso de la plataforma." "Internal"
