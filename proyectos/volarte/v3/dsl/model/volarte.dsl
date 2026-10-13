# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Sistema en alcance 'Volarte' y sus contenedores
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

volarte = softwareSystem "Volarte" "Sistema Volarte: contenedores del L2 · Container y componentes de los L3. El nombre proviene del marco 'Diagrama Contenedores [Volarte]' del Draw.io." "" {
    properties {
        "c4.tipo" "Software System"
    }

    !docs ../../docs/workspace
    !adrs ../../docs/adr

    # Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-22)
    vo_frontendWeb = container "Frontend Web" "Sin MFE: un solo bundle, code- splitting por módulo (React.lazy). Login SSO vía MSAL.js contra Entra ID. Deploy: CDN Cloudflare + GCS" "React (CSR) + Vite · SPA" "Frontend,WebBrowser" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-22"
            "drawio.boundary" "terpel-org-col-volarte-AMB (Dev, qa y prd)"
        }

        !include componentes/vo_frontendWeb.dsl
    }

    # Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-25); L3 · Svc Usuarios Auth (QJXrHxYRZstZZbYl4sQt-3)
    vo_memorystore = container "Memorystore" "Sesiones · Tokens · Queries" "Cache" "Database,Cache" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-25; L3 · Svc Usuarios Auth#QJXrHxYRZstZZbYl4sQt-3"
            "drawio.boundary" "Datos"
        }
    }

    # Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-26); L3 · Pub-Sub (ps-bffw-1); L3 · Svc Comercial (b-RN_Ccwwt3KFX2f4dkP-1)
    vo_bffBackendVolarte = container "BFF — Backend Volarte" "Valida JWT (issuer/audience) Resuelve GroupToRoleMapping → Role/Permission/Capability Orquesta servicios de dominio Auto-scaling · Pay-per-use" "FastAPI · Cloud Run" "BFF" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-26; L3 · Pub-Sub#ps-bffw-1; L3 · Svc Comercial#b-RN_Ccwwt3KFX2f4dkP-1"
            "drawio.boundary" "terpel-org-col-volarte-AMB (Dev, qa y prd)"
        }

        !include componentes/vo_bffBackendVolarte.dsl
    }

    # Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-33)
    vo_internalLoadBalancer = container "Internal Load Balancer" "SSL/TLS terminado en el borde. Enrutamiento al IAP y Cloud Run." "GCP Cloud Load Balancing" "Component" {
        properties {
            "c4.tipo" "Component"
            "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-33"
            "drawio.boundary" "terpel-org-col-volarte-AMB (Dev, qa y prd)"
        }
    }

    # Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-38); L3 · BFF Movil (bffm-sql-ext-1); L3 · Svc Usuarios Auth (QJXrHxYRZstZZbYl4sQt-2); L3 · Gestor Documental (p3czn_rpy_i9IkPloGag-2)
    vo_cloudSqlPostgresql = container "Cloud SQL (PostgreSQL)" "Usuarios · Roles · Registry" "Database" "Database" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-38; L3 · BFF Movil#bffm-sql-ext-1; L3 · Svc Usuarios Auth#QJXrHxYRZstZZbYl4sQt-2; L3 · Gestor Documental#p3czn_rpy_i9IkPloGag-2"
            "drawio.boundary" "Datos"
        }
    }

    # Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-39)
    vo_svcUsuariosAuth = container "Svc: Usuarios / Auth" "Roles · Permisos · Perfil Sincroniza con Azure AD" "Cloud Run" "DomainService" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-39"
            "drawio.boundary" "Servicios de dominio"
        }

        !include componentes/vo_svcUsuariosAuth.dsl
    }

    # Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-40)
    vo_cloudKms = container "Cloud KMS" "Gestión de claves de cifrado (CMEK). Cifra: Cloud SQL · GCS · Firestore. Cifra secretos en Secret Manager. HSM · rotación de claves." "GCP Key Management Service" "" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-40"
            "drawio.boundary" "terpel-org-col-volarte-AMB (Dev, qa y prd)"
        }
    }

    # Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-43)
    vo_secretManager = container "Secret Manager" "Almacena secretos de todos los servicios: credenciales DB · API keys · client secrets. Acceso via Service Account (IAM). Rotación automática · audit log." "GCP Secret Manager" "" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-43"
            "drawio.boundary" "terpel-org-col-volarte-AMB (Dev, qa y prd)"
        }
    }

    # Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-48); L3 · Pub-Sub (NJPMC4rQsjvtd9-BpX4p-3); L3 · Documentos GCS (7glqgnJFogUP_nQTeCRp-2)
    vo_gestorDocumental = container "Gestor Documental" "Publica el documento de entrega al cierre de operación. Retorna ID inmutable vinculado. Cola + reintento, sin duplicar (HU-055). S07: contenido y numeración del documento canónico. El Gestor Documental solo lo publica." "FastAPI · Cloud Run" "DomainService" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-48; L3 · Pub-Sub#NJPMC4rQsjvtd9-BpX4p-3; L3 · Documentos GCS#7glqgnJFogUP_nQTeCRp-2"
            "drawio.boundary" "Servicios de dominio"
        }

        !include componentes/vo_gestorDocumental.dsl
    }

    # Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-49); L3 · BFF Movil (_G9imbh4nfA6h8SqaJqN-2); L3 · Gestor Documental (p3czn_rpy_i9IkPloGag-3)
    vo_documentosGcs = container "Documentos (GCS)" "Almacenamiento WORM/versionado. Retención según política vigente. Recuperable por operación y cliente." "Cloud Storage" "Database,Storage" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-49; L3 · BFF Movil#_G9imbh4nfA6h8SqaJqN-2; L3 · Gestor Documental#p3czn_rpy_i9IkPloGag-3"
            "drawio.boundary" "Datos"
        }

        !include componentes/vo_documentosGcs.dsl
    }

    # Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-51); L3 · Svc Operacion (i--iAFYeRP1RJYZK3LzI-3)
    vo_svcDatosMaestros = container "Svc: Datos Maestros" "S02: Customer, AircraftOperator, AircraftType, AircraftRegistration, FuellingEquipment, NegotiationProfile..." "FastAPI · Cloud Run" "DomainService" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-51; L3 · Svc Operacion#i--iAFYeRP1RJYZK3LzI-3"
            "drawio.boundary" "Servicios de dominio"
        }
    }

    # Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-52); L3 · Pub-Sub (NJPMC4rQsjvtd9-BpX4p-1)
    vo_svcComercial = container "Svc: Comercial" "S04: elegibilidad, precio (PriceProvider), crédito disponible." "FastAPI · Cloud Run" "DomainService" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-52; L3 · Pub-Sub#NJPMC4rQsjvtd9-BpX4p-1"
            "drawio.boundary" "Servicios de dominio"
        }

        !include componentes/vo_svcComercial.dsl
    }

    # Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-53); L3 · BFF Movil (_G9imbh4nfA6h8SqaJqN-4); L3 · Pub-Sub (ps-ops-ext-1)
    vo_svcOperacion = container "Svc: Operación" "S05: estado dinámico equipo/operador, turnos, posición, inventario calidad." "FastAPI · Cloud Run" "DomainService" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-53; L3 · BFF Movil#_G9imbh4nfA6h8SqaJqN-4; L3 · Pub-Sub#ps-ops-ext-1"
            "drawio.boundary" "Servicios de dominio"
        }

        !include componentes/vo_svcOperacion.dsl
    }

    # Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-54)
    vo_svcAsignacionOptimizacion = container "Svc: Asignación / Optimización" "S06: motor MILP + recomendación Skypredict, degradación controlada. GKE por cómputo sostenido; owner/ runtime final los confirma Arquitectura." "GKE (recomendado · P-025 PENDING)" "DomainService,Pending" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-54"
            "drawio.boundary" "Servicios de dominio"
        }
    }

    # Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-56); L3 · BFF Movil (_G9imbh4nfA6h8SqaJqN-3); L3 · Gestor Documental (p3czn_rpy_i9IkPloGag-1); L3 · Svc Operacion (i--iAFYeRP1RJYZK3LzI-2); L3 · Svc Comercial (b-RN_Ccwwt3KFX2f4dkP-2)
    vo_colaDeMensajeria = container "Cola de mensajeria" "Pub/Sub. Topics: doc-publicacion (HU-055, retry+DLQ), operacion-cerrada (fan-out a 3 suscriptores), tracking-eventos (ingesta asíncrona de alta frecuencia)." "Pub/Sub" "Queue" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-56; L3 · BFF Movil#_G9imbh4nfA6h8SqaJqN-3; L3 · Gestor Documental#p3czn_rpy_i9IkPloGag-1; L3 · Svc Operacion#i--iAFYeRP1RJYZK3LzI-2; L3 · Svc Comercial#b-RN_Ccwwt3KFX2f4dkP-2"
            "drawio.boundary" "terpel-org-col-volarte-AMB (Dev, qa y prd)"
        }

        !include componentes/vo_colaDeMensajeria.dsl
    }

    # Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-71)
    vo_appMovil = container "App móvil" "Offline-first: SQLite local (WatermelonDB) + cola de escritura con UUID por acción. Fotos/firma van al filesystem local. Sync bidireccional al reconectar (delta + resumable upload). Solo operarios; distribución vía Intune/Managed Play." "React Native · Android exclusivo" "Frontend,Mobile" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-71"
            "drawio.boundary" "Diagrama Contenedores"
        }

        !include componentes/vo_appMovil.dsl
    }

    # Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-77); L3 · App Movil (IJ51pq0J-d0GQBmwbhIP-1); L3 · Pub-Sub (NJPMC4rQsjvtd9-BpX4p-2)
    vo_bffMovil = container "BFF Móvil" "Consumidor: App móvil (operarios), única. Respuestas ultra-livianas, vistas exclusivas de operación en campo — no comparte payloads con BFF Web. Resuelve sync offline: delta + cola." "FastAPI · Cloud Run" "BFF" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-77; L3 · App Movil#IJ51pq0J-d0GQBmwbhIP-1; L3 · Pub-Sub#NJPMC4rQsjvtd9-BpX4p-2"
            "drawio.boundary" "terpel-org-col-volarte-AMB (Dev, qa y prd)"
        }

        !include componentes/vo_bffMovil.dsl
    }
}
