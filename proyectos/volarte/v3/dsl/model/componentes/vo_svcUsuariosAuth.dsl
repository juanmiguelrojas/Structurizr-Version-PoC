# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Componentes L3 de 'Svc: Usuarios / Auth'
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: L3 · Svc Usuarios Auth (t-WAN_PF45m8JnTnU6Eb-1)
su_apiRouter = component "API Router" "/roles · /permissions · /mapping · /audit" "FastAPI" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Svc Usuarios Auth#t-WAN_PF45m8JnTnU6Eb-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Svc Usuarios Auth (t-WAN_PF45m8JnTnU6Eb-2)
su_resolverGrouptorolemapping = component "Resolver GroupToRoleMapping" "Deriva rol efectivo desde grupo(s) de Entra ID. RN-007/RN-008." "Python" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Svc Usuarios Auth#t-WAN_PF45m8JnTnU6Eb-2"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Svc Usuarios Auth (t-WAN_PF45m8JnTnU6Eb-3)
su_adaptadorDeSincronizacionEntraId = component "Adaptador de sincronización Entra ID" "Consulta pertenencia a grupos cuando el claim 'groups' se trunca." "Microsoft Graph API" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Svc Usuarios Auth#t-WAN_PF45m8JnTnU6Eb-3"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Svc Usuarios Auth (t-WAN_PF45m8JnTnU6Eb-4)
su_invalidadorDeCache = component "Invalidador de Cache" "Notifica a Redis cuando cambia un rol — no espera al TTL." "Python" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Svc Usuarios Auth#t-WAN_PF45m8JnTnU6Eb-4"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Svc Usuarios Auth (t-WAN_PF45m8JnTnU6Eb-5)
su_clienteCloudSql = component "Cliente Cloud SQL" "Acceso a datos de usuarios/roles/mapping." "SQLAlchemy" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Svc Usuarios Auth#t-WAN_PF45m8JnTnU6Eb-5"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Svc Usuarios Auth (t-WAN_PF45m8JnTnU6Eb-6)
su_auditor = component "Auditor" "Registra toda decisión de autorización, concedida o denegada." "Python" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Svc Usuarios Auth#t-WAN_PF45m8JnTnU6Eb-6"
        "drawio.boundary" "Diagrama Componente"
    }
}
