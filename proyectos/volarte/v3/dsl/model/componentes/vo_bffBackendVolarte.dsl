# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Componentes L3 de 'BFF — Backend Volarte'
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: L3 · BFF Web (77-Ya6_qwyibhzLODzQj-1)
bw_apiRouterControllers = component "API Router / Controllers" "Endpoints REST por feature. Punto de entrada del contenedor." "FastAPI" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · BFF Web#77-Ya6_qwyibhzLODzQj-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · BFF Web (77-Ya6_qwyibhzLODzQj-2)
bw_middlewareDeAutenticacion = component "Middleware de Autenticación" "Valida issuer/audience/ expiración del token (segunda validación)." "JWT Middleware" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · BFF Web#77-Ya6_qwyibhzLODzQj-2"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · BFF Web (77-Ya6_qwyibhzLODzQj-3)
bw_servicioDeAutorizacion = component "Servicio de Autorización" "Resuelve GroupToRoleMapping → Role/Permission/ Capability." "Python" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · BFF Web#77-Ya6_qwyibhzLODzQj-3"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · BFF Web (77-Ya6_qwyibhzLODzQj-6)
bw_orquestadorDeDominio = component "Orquestador de Dominio" "Enruta la petición al servicio de dominio correspondiente." "Python" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · BFF Web#77-Ya6_qwyibhzLODzQj-6"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · BFF Web (77-Ya6_qwyibhzLODzQj-8)
bw_clientesDeServicios = component "Clientes de Servicios" "Clientes tipados hacia cada Svc: interno. Cloud Run → Cloud Run." "HTTP + ID Token (IAM)" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · BFF Web#77-Ya6_qwyibhzLODzQj-8"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · BFF Web (77-Ya6_qwyibhzLODzQj-9)
bw_clienteDeSecretos = component "Cliente de Secretos" "Credenciales de servicios downstream." "Secret Manager SDK" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · BFF Web#77-Ya6_qwyibhzLODzQj-9"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · BFF Web (77-Ya6_qwyibhzLODzQj-10)
bw_clienteDeCache = component "Cliente de Cache" "Cache de decisión de autorización (TTL corto)." "Redis SDK" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · BFF Web#77-Ya6_qwyibhzLODzQj-10"
        "drawio.boundary" "Diagrama Componente"
    }
}
