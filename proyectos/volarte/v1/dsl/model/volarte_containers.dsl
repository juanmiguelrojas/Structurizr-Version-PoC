# =============================================================================
# Contenedores del sistema Volarte  (Fuente: Draw.io Volarte v1 · L2 Container)
# Proyecto GCP: terpel-org-col-volarte-AMB (dev, qa, prd)
# Los componentes L3 se incluyen desde ./components/
# =============================================================================

group "Canales (Clientes)" {
    frontendWeb = container "Frontend Web" "SPA sin MFE: un solo bundle con code-splitting por módulo (React.lazy). Login SSO vía MSAL.js contra Entra ID / CIAM. Deploy: CDN Cloudflare + GCS (terpel-gtic-front)." "React (CSR) + Vite · SPA" "Frontend,WebBrowser" {
        !include components/frontend_web.dsl
    }

    mobileApp = container "App Móvil" "Offline-first: SQLite local (WatermelonDB) + cola de escritura con UUID por acción. Fotos/firma al filesystem local. Sync bidireccional al reconectar (delta + resumable upload). Solo operarios; distribución vía Intune / Managed Play. NO se despliega en GCP." "React Native · Android exclusivo" "Frontend,Mobile" {
        !include components/mobile_app.dsl
    }
}

group "Backends for Frontend" {
    bffWeb = container "BFF Web" "BFF — Backend Volarte. Valida JWT (issuer/audience, 2a validación), resuelve GroupToRoleMapping → Role/Permission/Capability y orquesta los servicios de dominio. Publica conciliacion-resuelta. Auto-scaling · pay-per-use." "Python · FastAPI · Cloud Run" "BFF,CloudRun" {
        !include components/bff_web.dsl
    }

    bffMobile = container "BFF Móvil" "Consumidor único: App móvil (operarios). Respuestas ultra-livianas, vistas exclusivas de operación en campo (no comparte payloads con BFF Web). Resuelve sync offline: delta + cola + reconciliación HU-050." "Python · FastAPI · Cloud Run" "BFF,CloudRun" {
        !include components/bff_mobile.dsl
    }
}

group "Servicios de Dominio" {
    svcUsuarios = container "Svc: Usuarios / Auth" "S01: roles, permisos, perfil y GroupToRoleMapping. Sincroniza grupos con Entra ID (Microsoft Graph). Auditoría de decisiones de autorización." "Python · FastAPI · Cloud Run" "DomainService,CloudRun" {
        !include components/svc_usuarios.dsl
    }

    svcDatosMaestros = container "Svc: Datos Maestros" "S02: Customer, AircraftOperator, AircraftType, AircraftRegistration, FuellingEquipment, NegotiationProfile, geocercas (HU-145)." "Python · FastAPI · Cloud Run" "DomainService,CloudRun"

    svcComercial = container "Svc: Comercial" "S04: elegibilidad, precio (PriceProvider) y crédito disponible. Suscriptor de operacion-cerrada para actualizar saldo/crédito." "Python · FastAPI · Cloud Run" "DomainService,CloudRun" {
        !include components/svc_comercial.dsl
    }

    svcOperacion = container "Svc: Operación" "S05: estado dinámico equipo/operador, turnos, posición e inventario de calidad. Suscriptor de tracking-eventos y conciliacion-resuelta." "Python · FastAPI · Cloud Run" "DomainService,CloudRun" {
        !include components/svc_operacion.dsl
    }

    svcAsignacion = container "Svc: Asignación / Optimización" "S06: motor MILP + recomendación Skypredict con degradación controlada. GKE por cómputo sostenido (P-025 PENDING: owner/runtime final los confirma Arquitectura)." "Python · MILP Solver · GKE" "DomainService,GKE,Pending"

    gestorDocumental = container "Gestor Documental" "Publica el documento de entrega al cierre de operación y retorna un ID inmutable vinculado. Cola + reintento sin duplicar (HU-055). S07 define contenido y numeración del documento canónico; el Gestor solo lo publica." "Python · FastAPI · Cloud Run" "DomainService,CloudRun" {
        !include components/gestor_documental.dsl
    }
}

group "Mensajería" {
    pubsub = container "Cola de Mensajería" "Pub/Sub. Topics: doc-publicacion (HU-055, retry + DLQ), operacion-cerrada (fan-out a 3 suscriptores), conciliacion-resuelta (HU-050) y tracking-eventos (ingesta asíncrona de alta frecuencia)." "Google Cloud Pub/Sub" "Queue" {
        !include components/pubsub.dsl
    }
}

group "Datos" {
    cloudSql = container "Cloud SQL" "Base transaccional: usuarios, roles, registry, tablas operacionales, tablas de Sincronización (offline_actions_log) y metadata/numeración documental. Cifrado CMEK." "PostgreSQL · Cloud SQL" "Database"

    memorystore = container "Memorystore" "Cache de sesiones, tokens, queries, decisiones de autorización (TTL corto) y llaves de idempotencia por UUID." "Redis · Memorystore" "Database,Cache"

    documentosGcs = container "Documentos (GCS)" "Almacenamiento WORM/versionado de documentos de entrega, fotos y firmas. Retención según política vigente. Recuperable por operación y cliente." "Google Cloud Storage" "Database,Storage" {
        !include components/documentos_gcs.dsl
    }
}
