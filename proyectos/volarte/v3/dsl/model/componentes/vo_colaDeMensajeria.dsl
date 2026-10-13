# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Componentes L3 de 'Cola de mensajeria'
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: L3 · Pub-Sub (1qreaHeSFc16h1s6TYu0-6)
ps_deadLetterTopic = component "Dead Letter Topic" "Mensajes que agotaron reintentos. Requiere revisión manual." "Pub/Sub DLQ" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Pub-Sub#1qreaHeSFc16h1s6TYu0-6"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Pub-Sub (1qreaHeSFc16h1s6TYu0-7)
ps_subComercialSub = component "Sub: comercial-sub" "Actualiza saldo/crédito tras el cierre." "Push · retry + DLQ" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Pub-Sub#1qreaHeSFc16h1s6TYu0-7"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Pub-Sub (1qreaHeSFc16h1s6TYu0-8)
ps_topicOperacionCerrada = component "Topic: operacion-cerrada" "Se dispara al cerrar una operación en campo." "Pub/Sub Topic" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Pub-Sub#1qreaHeSFc16h1s6TYu0-8"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Pub-Sub (1qreaHeSFc16h1s6TYu0-9)
ps_subGestorDocumentalSub = component "Sub: gestor-documental-sub" "Dispara generación y publicación del documento (HU-055)." "Push · retry + DLQ" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Pub-Sub#1qreaHeSFc16h1s6TYu0-9"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Pub-Sub (ps-conc-topic-1)
ps_topicConciliacionResuelta = component "Topic: conciliacion-resuelta" "Se publica cuando un supervisor resuelve desde la Web una operación PENDING_REVIEW (HU-050): confirmar o anular." "Pub/Sub Topic" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Pub-Sub#ps-conc-topic-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Pub-Sub (_5laymvxx4AvxF7kTuUS-1)
ps_subOperacionConciliacionSub = component "Sub: operacion-conciliacion-sub" "Aplica la resolución (finaliza o anula) sobre la operación en Tablas: operacionales." "Push · retry + DLQ" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Pub-Sub#_5laymvxx4AvxF7kTuUS-1"
        "drawio.boundary" "Diagrama Componente"
    }
}
