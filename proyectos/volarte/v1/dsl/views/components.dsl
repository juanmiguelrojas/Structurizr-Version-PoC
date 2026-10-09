# ---------------------------------------------------------------------------
# L3 · Component Diagrams
# ---------------------------------------------------------------------------

component frontendWeb "L3_Frontend_Web" "L3 · Frontend Web (React SPA)." {
    include *
    autoLayout lr
}

component mobileApp "L3_App_Movil" "L3 · App Móvil offline-first (React Native · WatermelonDB · SQLCipher)." {
    include *
    autoLayout lr
}

component bffWeb "L3_BFF_Web" "L3 · BFF Web (FastAPI · Cloud Run)." {
    include *
    autoLayout lr
}

component bffMobile "L3_BFF_Movil" "L3 · BFF Móvil: sync offline, idempotencia, reconciliación HU-050, resumable upload." {
    include *
    exclude "relationship.tag==Logical"
    include mobileApp
    autoLayout lr
}

component pubsub "L3_PubSub_Mensajeria" "L3 · Pub/Sub: topics, suscripciones push con retry + DLQ." {
    include *
    autoLayout lr
}

component gestorDocumental "L3_Gestor_Documental" "L3 · Gestor Documental (HU-055)." {
    include *
    autoLayout lr
}

component documentosGcs "L3_Documentos_GCS" "L3 · Bucket de Documentos (WORM, CMEK, lifecycle)." {
    include *
    autoLayout lr
}

component svcUsuarios "L3_Svc_Usuarios_Auth" "L3 · Svc Usuarios / Auth (GroupToRoleMapping, auditoría)." {
    include *
    autoLayout lr
}

component svcOperacion "L3_Svc_Operacion" "L3 · Svc Operación (turnos, posición, inventario de calidad)." {
    include *
    autoLayout lr
}

component svcComercial "L3_Svc_Comercial" "L3 · Svc Comercial (elegibilidad, precio, crédito)." {
    include *
    autoLayout lr
}
