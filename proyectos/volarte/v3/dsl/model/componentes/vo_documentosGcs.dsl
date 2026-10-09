# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Componentes L3 de 'Documentos (GCS)'
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: L3 · Documentos GCS (_c_TmdJeJUtrgmQ7S9uW-1)
dg_estructuraDeCarpetas = component "Estructura de carpetas" "Organización por año, mes y ID de operación." "gs://.../{anio}/{mes}/{op_id}" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Documentos GCS#_c_TmdJeJUtrgmQ7S9uW-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Documentos GCS (_c_TmdJeJUtrgmQ7S9uW-2)
dg_politicaDeCicloDeVida = component "Política de ciclo de vida" "Transición a Nearline/ Coldline según antigüedad. Retención definida por política vigente." "GCS Lifecycle Rules" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Documentos GCS#_c_TmdJeJUtrgmQ7S9uW-2"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Documentos GCS (_c_TmdJeJUtrgmQ7S9uW-3)
dg_versionadoWorm = component "Versionado / WORM" "Inmutabilidad: un objeto nunca se sobrescribe." "GCS Object Versioning" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Documentos GCS#_c_TmdJeJUtrgmQ7S9uW-3"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Documentos GCS (_c_TmdJeJUtrgmQ7S9uW-4)
dg_iamDelBucket = component "IAM del bucket" "Write: SA Gestor Documental. Read: signed URLs temporales." "Service Account bindings" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Documentos GCS#_c_TmdJeJUtrgmQ7S9uW-4"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Documentos GCS (_c_TmdJeJUtrgmQ7S9uW-5)
dg_cifradoEnReposo = component "Cifrado en reposo" "Cada objeto cifrado con clave gestionada por Terpel, no por Google." "CMEK (Cloud KMS)" "" {
    properties {
        "c4.tipo" "Component"
        "drawio.ocurrencias" "L3 · Documentos GCS#_c_TmdJeJUtrgmQ7S9uW-5"
        "drawio.boundary" "Diagrama Componente"
    }
}
