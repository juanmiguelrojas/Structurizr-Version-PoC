# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Componentes L3 de 'BFF Móvil'
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: L3 · BFF Movil (1zkQ9IaikqJmL66ETiHT-1)
bm_servicioDeAutorizacion = component "Servicio de Autorización" "Resuelve GroupToRoleMapping → Role/Permission/ Capability." "Python" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · BFF Movil#1zkQ9IaikqJmL66ETiHT-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · BFF Movil (SELEylk7Q_GAH_jisJpw-1)
bm_middlewareDeAutenticacion = component "Middleware de Autenticación" "Valida issuer/audience/ expiración del token (segunda validación)." "JWT Middleware" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · BFF Movil#SELEylk7Q_GAH_jisJpw-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · BFF Movil (bxV1-kFdc_Y-09Kx5JXH-1)
bm_apiRouterControllers = component "API Router / Controllers" "Endpoints REST por feature. Punto de entrada del contenedor." "FastAPI" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · BFF Movil#bxV1-kFdc_Y-09Kx5JXH-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · BFF Movil (D_LV-Y4hSz6o_uYIQ-JI-1)
bm_servicioDeIdempotencia = component "Servicio de Idempotencia" "Evita procesar dos veces la misma acción reenviada." "Redis (dedupe por UUID)" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · BFF Movil#D_LV-Y4hSz6o_uYIQ-JI-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · BFF Movil (6K30jVCmdG1WcfRa9Mfz-1)
bm_publicadorDeEventos = component "Publicador de Eventos" "Publica operacion-cerrada y doc-publicacion." "Pub/Sub Publisher" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · BFF Movil#6K30jVCmdG1WcfRa9Mfz-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · BFF Movil (6K30jVCmdG1WcfRa9Mfz-4)
bm_manejadorDeSubida = component "Manejador de Subida" "Orquesta subida de fotos/firma, tolera cortes de red." "GCS Resumable Uploa" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · BFF Movil#6K30jVCmdG1WcfRa9Mfz-4"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · BFF Movil (6K30jVCmdG1WcfRa9Mfz-5)
bm_proveedorDeDelta = component "Proveedor de Delta" "Versión + diferencias de catálogos/turnos para descarga incremental." "Python — patrón HU-007" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · BFF Movil#6K30jVCmdG1WcfRa9Mfz-5"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · BFF Movil (6K30jVCmdG1WcfRa9Mfz-2)
bm_motorDeReconciliacion = component "Motor de Reconciliación" "Compara timestamp de captura vs. histórico de revocación. Auto-acepta o PENDING_REVIEW." "Python — regla HU-050" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · BFF Movil#6K30jVCmdG1WcfRa9Mfz-2"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · BFF Movil (E34e5Gi3vuo780vgvwd1-4)
bm_validadorDeOrdenSecuencia = component "Validador de Orden/Secuencia" "Reordena acciones offline por timestamp de captura (no de llegada). Evita que una acción vieja reenviada tarde sobrescriba un estado más reciente." "Python" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · BFF Movil#E34e5Gi3vuo780vgvwd1-4"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · BFF Movil (E34e5Gi3vuo780vgvwd1-5)
bm_clienteCloudSql = component "Cliente Cloud SQL" "Escribe la cola de acciones offline recibidas y el estado de conciliación (PENDIENTE/CONFIRMADO/ PENDING_REVIEW) en Tablas: Sincronizacion." "Cloud SQL Connector" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · BFF Movil#E34e5Gi3vuo780vgvwd1-5"
        "drawio.boundary" "Diagrama Componente"
    }
}
