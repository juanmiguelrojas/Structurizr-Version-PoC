# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Componentes L3 de 'Gestor Documental'
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: L3 · Gestor Documental (w7r6QkDVoiiIa6xH4-3E-1)
gd_asignadorDeNumeracion = component "Asignador de Numeración" "Numeración secuencial, única, auditable." "Python" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Gestor Documental#w7r6QkDVoiiIa6xH4-3E-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Gestor Documental (LfrINowvB_6pj9qjwHhb-1)
gd_suscriptorPubSub = component "Suscriptor Pub/Sub" "Recibe el evento operacion-cerrada. Retry + DLQ." "Push endpoint" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Gestor Documental#LfrINowvB_6pj9qjwHhb-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Gestor Documental (LfrINowvB_6pj9qjwHhb-3)
gd_generadorDeDocumento = component "Generador de Documento" "Ensambla contenido: partes, cantidades, firmas, datos de la operación." "Python — ex S07" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Gestor Documental#LfrINowvB_6pj9qjwHhb-3"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Gestor Documental (LfrINowvB_6pj9qjwHhb-4)
gd_motorDePlantillas = component "Motor de Plantillas" "Renderiza el formato final según lo que el cliente requiera." "PDF / AIDX XML" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Gestor Documental#LfrINowvB_6pj9qjwHhb-4"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Gestor Documental (LfrINowvB_6pj9qjwHhb-5)
gd_publicador = component "Publicador" "Idempotente: un reintento no genera un segundo documento. Retorna ID inmutable." "Python — HU-055" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Gestor Documental#LfrINowvB_6pj9qjwHhb-5"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Gestor Documental (7EeqbbmK745T4Ry1vtSA-1)
gd_clienteGcs = component "Cliente GCS" "Sube el documento final al bucket." "Resumable Upload" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Gestor Documental#7EeqbbmK745T4Ry1vtSA-1"
        "drawio.boundary" "Diagrama Componente"
    }
}
