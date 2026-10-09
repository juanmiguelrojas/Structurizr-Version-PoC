# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Componentes L3 de 'Svc: Comercial'
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: L3 · Svc Comercial (SysJojknCBub14QhnpdS-1)
sc_apiRouter = component "API Router" "/roles · /permissions · /mapping · /audit" "FastAPI" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Svc Comercial#SysJojknCBub14QhnpdS-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Svc Comercial (Wf-JDKIvJJDLsy6hbBwl-1)
sc_clienteDeBaseDeDatos = component "Cliente de base de datos" "Estado dinámico, persistencia." "SQLAlchemy" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Svc Comercial#Wf-JDKIvJJDLsy6hbBwl-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Svc Comercial (xXJvcLVGKZx-Wk_l2KEW-1)
sc_suscriptorOperacionCerrada = component "Suscriptor operacion-cerrada" "Actualiza saldo/crédito tras cada cierre de operación." "Pub/Sub push" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Svc Comercial#xXJvcLVGKZx-Wk_l2KEW-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Svc Comercial (xXJvcLVGKZx-Wk_l2KEW-2)
sc_servicioDeCreditoDisponible = component "Servicio de Crédito Disponible" "Calcula crédito disponible según saldo y órdenes abiertas." "Python — S04" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Svc Comercial#xXJvcLVGKZx-Wk_l2KEW-2"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Svc Comercial (xXJvcLVGKZx-Wk_l2KEW-3)
sc_motorDeElegibilidad = component "Motor de Elegibilidad" "Cliente activo, acuerdo vigente, negociación existente (S02 → S04)." "Python — S04/HU-128" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Svc Comercial#xXJvcLVGKZx-Wk_l2KEW-3"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Svc Comercial (xXJvcLVGKZx-Wk_l2KEW-4)
sc_resolutorPriceprovider = component "Resolutor PriceProvider" "No inventa fuente de precio; delega a la autoridad cuando se confirme." "Python — P-072 PENDING" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Svc Comercial#xXJvcLVGKZx-Wk_l2KEW-4"
        "drawio.boundary" "Diagrama Componente"
    }
}
