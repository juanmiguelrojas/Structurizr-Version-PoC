# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Componentes L3 de 'App móvil'
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: L3 · App Movil (tE5uz-bxcUuAfPVDgkf5-1)
am_moduloDeAutenticacion = component "Modulo de Autenticacion" "Flujo OAuth2 Authorization Code + PKCE. Token en memoria (no localStorage)." "MSAL.js" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · App Movil#tE5uz-bxcUuAfPVDgkf5-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · App Movil (UOg2JrxTDASzVybLAq_5-2)
am_navegacion = component "Navegación" "Pantallas del operario: turnos, checklist, PQDA, firma, historial." "React Navigation" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · App Movil#UOg2JrxTDASzVybLAq_5-2"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · App Movil (UOg2JrxTDASzVybLAq_5-3)
am_baseDeDatosLocal = component "Base de Datos local" "Réplica funcional: turnos, operaciones, catálogos. Fuente de verdad offline." "WatermelonDB (SQLite)" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · App Movil#UOg2JrxTDASzVybLAq_5-3"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · App Movil (UOg2JrxTDASzVybLAq_5-4)
am_motorDeSincronizacion = component "Motor de Sincronización" "Cola de escritura local. Delta pull / push al reconectar. Aplica HU-050." "Cola + UUID" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · App Movil#UOg2JrxTDASzVybLAq_5-4"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · App Movil (FF5uxJXjgTfR0MfS2Fa0-1)
am_clienteApi = component "Cliente API" "Sube cola pendiente, descarga delta, sube media con reanudación." "Fetch + Resumable Upload" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · App Movil#FF5uxJXjgTfR0MfS2Fa0-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · App Movil (FF5uxJXjgTfR0MfS2Fa0-2)
am_capturaDeEvidencia = component "Captura de Evidencia" "Fotos PQDA/checklist y firma. Guardado en filesystem local primero." "Cámara + canvas Tactil" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · App Movil#FF5uxJXjgTfR0MfS2Fa0-2"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · App Movil (FF5uxJXjgTfR0MfS2Fa0-3)
am_disparadorDeSync = component "Disparador de Sync" "Detecta reconexión y dispara el Motor de Sincronización." "Netinfo listener" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · App Movil#FF5uxJXjgTfR0MfS2Fa0-3"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · App Movil (mob-netskope-1)
am_netskopeClientZtna = component "Netskope Client (ZTNA)" "Agente ZTNA embebido/ perfil de dispositivo. Verifica posture (Intune) antes de habilitar túnel hacia BFF Móvil. Sin esto no hay salida de red." "Netskope Agent" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · App Movil#mob-netskope-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · App Movil (I06DCVj82Mg0p9T_tGyF-1)
am_cifradoLocalEnReposo = component "Cifrado Local en Reposo" "Cifra la Base de Datos local (WatermelonDB). Clave derivada del hardware del dispositivo, no exportable. Protege datos operacionales si el dispositivo se pierde o es robado" "SQLCipher + Android Keystore" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · App Movil#I06DCVj82Mg0p9T_tGyF-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · App Movil (I06DCVj82Mg0p9T_tGyF-2)
am_gestorDeEstadosDeSincronizacion = component "Gestor de Estados de Sincronización" "Por cada ítem de la cola: PENDIENTE → ENVIANDO → CONFIRMADO | CONFLICTO | ERROR. Reintento con backoff exponencial (base 5s, máx 5 min)" "State Machine (local)" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · App Movil#I06DCVj82Mg0p9T_tGyF-2"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · App Movil (I06DCVj82Mg0p9T_tGyF-4)
am_componentName = component "Component name" "Detecta antes de reenviar: turno reasignado, recurso bloqueado, catálogo desactualizado. Marca CONFLICTO_LOCAL, no descarta el dato (hecho físico) y espera resolución." "Kotlin/TS — reglas locales" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · App Movil#I06DCVj82Mg0p9T_tGyF-4"
        "drawio.boundary" "Diagrama Componente"
    }
}
