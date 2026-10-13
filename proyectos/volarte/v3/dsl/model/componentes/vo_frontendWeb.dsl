# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Componentes L3 de 'Frontend Web'
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: L3 · Frontend Web (JWy8FgxPE3tA-0hkP3Wm-1)
fw_appShellRouter = component "App Shell / Router" "Layout, navbar, enrutamiento client-side. Punto de entrada único de la SPA." "React Router" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Frontend Web#JWy8FgxPE3tA-0hkP3Wm-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Frontend Web (JWy8FgxPE3tA-0hkP3Wm-2)
fw_vistasPorRol = component "Vistas por rol" "Módulos cargados con React.lazy() según rol: comercial, supervisión, admin." "React (code-splitting)" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Frontend Web#JWy8FgxPE3tA-0hkP3Wm-2"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Frontend Web (JWy8FgxPE3tA-0hkP3Wm-3)
fw_clienteApi = component "Cliente API" "Inyecta Bearer token en cada request. Reintentos con backoff." "Fetch/Axios" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Frontend Web#JWy8FgxPE3tA-0hkP3Wm-3"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Frontend Web (JWy8FgxPE3tA-0hkP3Wm-4)
fw_cacheDeEstadoServidor = component "Cache de estado servidor" "Cache y revalidación de datos de servidor. Evita refetch innecesario." "React Query" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Frontend Web#JWy8FgxPE3tA-0hkP3Wm-4"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Frontend Web (JWy8FgxPE3tA-0hkP3Wm-5)
fw_errorBoundaryTelemetria = component "Error Boundary / Telemetría" "Captura errores de render. Envía eventos de uso/error." "React ErrorBoundary" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Frontend Web#JWy8FgxPE3tA-0hkP3Wm-5"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Frontend Web (JWy8FgxPE3tA-0hkP3Wm-6)
fw_moduloDeAutenticacion = component "Modulo de Autenticacion" "Flujo OAuth2 Authorization Code + PKCE. Token en memoria (no localStorage)." "MSAL.js" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Frontend Web#JWy8FgxPE3tA-0hkP3Wm-6"
        "drawio.boundary" "Diagrama Componente"
    }
}
