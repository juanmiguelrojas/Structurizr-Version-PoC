# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Componentes L3 de 'Svc: Operación'
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: L3 · Svc Operacion (y6BNUnCm-LO4T1uQHbZl-1)
so_apiRouter = component "API Router" "/roles · /permissions · /mapping · /audit" "FastAPI" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Svc Operacion#y6BNUnCm-LO4T1uQHbZl-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Svc Operacion (y6BNUnCm-LO4T1uQHbZl-2)
so_rastreadorDePosicion = component "Rastreador de Posición" "Determina posición del equipo vs. geocerca de Datos Maestros." "Python — HU-044/HU-145" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Svc Operacion#y6BNUnCm-LO4T1uQHbZl-2"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Svc Operacion (y6BNUnCm-LO4T1uQHbZl-3)
so_inventarioDeCalidad = component "Inventario de Calidad" "Decremento de insumos (pastillas PQDA) por prueba ejecutada." "Python — IR-06 reservada" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Svc Operacion#y6BNUnCm-LO4T1uQHbZl-3"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Svc Operacion (y6BNUnCm-LO4T1uQHbZl-4)
so_clienteDeBaseDeDatos = component "Cliente de base de datos" "Estado dinámico, persistencia." "SQLAlchemy" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Svc Operacion#y6BNUnCm-LO4T1uQHbZl-4"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Svc Operacion (y6BNUnCm-LO4T1uQHbZl-5)
so_gestorDeTurnos = component "Gestor de Turnos" "Ventana de inicio, autorización de excepción por supervisor." "Python — S05/S08 HU-056" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Svc Operacion#y6BNUnCm-LO4T1uQHbZl-5"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Svc Operacion (y6BNUnCm-LO4T1uQHbZl-7)
so_suscriptorDeTracking = component "Suscriptor de Tracking" "Procesa eventos de tracking entrantes, si el topic está activo." "Pub/Sub push" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Svc Operacion#y6BNUnCm-LO4T1uQHbZl-7"
        "drawio.boundary" "Diagrama Componente"
    }
}
