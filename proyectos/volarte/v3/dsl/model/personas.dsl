# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Personas
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-63); L0 · Referencia (sR61ePaMgubpxd_IzPhU-110); L1 · Context (jBqDDpGHMn_ggPszUGn9-39)
pe_empleadoInterno = person "Empleado Interno" "Usuario corporativo que accede a la wiki, lanza web apps y navega a portales externos desde un único punto de entrada" "" {
    properties {
        "c4.tipo" "Persona"
        "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-63; L0 · Referencia#sR61ePaMgubpxd_IzPhU-110; L1 · Context#jBqDDpGHMn_ggPszUGn9-39"
        "drawio.boundary" "Diagrama Contenedores"
    }
}

# Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-65); L0 · Referencia (sR61ePaMgubpxd_IzPhU-119); L1 · Context (jBqDDpGHMn_ggPszUGn9-31)
pe_usuarioExterno = person "Usuario externo" "Usuario que no esta dentro del tenant de terpel" "External Person" {
    properties {
        "c4.tipo" "Person"
        "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-65; L0 · Referencia#sR61ePaMgubpxd_IzPhU-119; L1 · Context#jBqDDpGHMn_ggPszUGn9-31"
        "drawio.boundary" "Diagrama Contenedores"
    }
}

# Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-70)
pe_operarioDeEquipoAbastecedor = person "Operario de equipo abastecedor" "Único rol que usa la app móvil. Opera en campo, con o sin cobertura." "" {
    properties {
        "c4.tipo" "Persona"
        "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-70"
        "drawio.boundary" "Diagrama Contenedores"
    }
}

# Draw.io: L1 · Context (jBqDDpGHMn_ggPszUGn9-1)
pe_adminDevTeam = person "Admin / Dev Team" "Gestiona módulos, publica web apps, administra permisos, monitorea uso y registra nuevas herramientas" "" {
    properties {
        "c4.tipo" "Persona"
        "drawio.ocurrencias" "L1 · Context#jBqDDpGHMn_ggPszUGn9-1"
        "drawio.boundary" "Diagrama Context"
    }
}
