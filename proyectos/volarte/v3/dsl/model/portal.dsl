# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Sistema en alcance 'Portal' y sus contenedores
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: L1 · Context (jBqDDpGHMn_ggPszUGn9-8)
portal = softwareSystem "Portal" "Portal interno/externo corporativo con: • Wiki de conocimiento • Catálogo de Web Apps • SSO federado a portales externos • Shell + módulos independientes" "" {
    properties {
        "c4.tipo" "Software System"
        "drawio.ocurrencias" "L1 · Context#jBqDDpGHMn_ggPszUGn9-8"
        "drawio.boundary" "Diagrama Context"
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-11)
    po_search = container "Search" "Full-text Wiki · Apps" "Elasticsearch" "Database" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-11"
            "drawio.boundary" "Datos"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-12)
    po_storage = container "Storage" "Adjuntos Wiki · MFE builds" "Cloud Storage (GCS)" "Database,Storage" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-12"
            "drawio.boundary" "Datos"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-13)
    po_database = container "Database" "Páginas Wiki · Versiones" "Firestore" "Database" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-13"
            "drawio.boundary" "Datos"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-14)
    po_cloudSqlPostgresql = container "Cloud SQL (PostgreSQL)" "Usuarios · Roles · Registry" "Database" "Database" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-14"
            "drawio.boundary" "Datos"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-15)
    po_memorystoreRedis = container "Memorystore (Redis)" "Sesiones · Tokens · Queries" "Cache" "Database,Cache" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-15"
            "drawio.boundary" "Backend"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-16)
    po_svcWiki = container "Svc: Wiki" "CRUD páginas · Versiones Búsqueda Elasticsearch" "Cloud Run" "Component" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-16"
            "drawio.boundary" "Servicios"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-17)
    po_svcUsuariosAuth = container "Svc: Usuarios / Auth" "Roles · Permisos · Perfil Sincroniza con Azure AD" "Cloud Run" "Component" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-17"
            "drawio.boundary" "Servicios"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-20)
    po_backendHubWeb = container "Backend — HUB Web" "Orquesta todas las llamadas del Shell y los remotes MFE. Agrega: Wiki API + Apps Registry + User Profile Valida JWT · Propaga tokens Auto-scaling · Pay-per-use" "Node.js / FastAPI · Cloud Run" "BFF" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-20"
            "drawio.boundary" "Backend"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-22)
    po_hubFront = container "HUB Front" "App contenedora MFE. Orquesta routing global, layout, navbar. Carga remotes MFE según módulo. Inyecta JWT a todos los remotes. Deploy: CDN Cloudflare + GCS" "React + Vite · SPA" "Frontend,WebBrowser" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-22"
            "drawio.boundary" "Frontend"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-34)
    po_cloudMonitoring = container "Cloud Monitoring" "Métricas de todos los Cloud Run. Alertas: errores · latencia · anomalías. Dashboards operacionales. Uptime checks · SLO tracking." "GCP Cloud Monitoring" "Observability" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-34"
            "drawio.boundary" "Observabilidad"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-35)
    po_cloudLogging = container "Cloud Logging" "Logs centralizados de todos los servicios. Audit logs: IAP · Secret Manager · KMS. Request logs: BFF · Svc · Federation Bridge. Retención configurable · alertas." "GCP Cloud Logging" "Observability" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-35"
            "drawio.boundary" "Observabilidad"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-52)
    po_portalesRemoteModulo = container "Portales Remote Modulo" "Catálogo de herramientas internas. Lanza apps: iframe / sub-remote Estado: prod / poc / draft / deprecated RBAC por herramienta · Registry API" "React + Vite · Module · Cloud run" "Component" {
        properties {
            "c4.tipo" "Component"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-52"
            "drawio.boundary" "Modulos"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-53)
    po_federationBridge = container "Federation Bridge" "Adaptador de tokens para portales externos. SAML 2.0 assertion · OIDC token exchange On-Behalf-Of flow · SSO silencioso Propaga sesión sin re-login" "React + Vite · Module · Cloud run" "Component" {
        properties {
            "c4.tipo" "Component"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-53"
            "drawio.boundary" "Modulos"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-62)
    po_svcPowerBiProxy = container "Svc: Power BI Proxy" "Genera embed tokens via AAD. Proxy seguro a Power BI REST API. Controla acceso por rol/workspace." "Cloud Run · FastAPI" "Component" {
        properties {
            "c4.tipo" "Component"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-62"
            "drawio.boundary" "Servicios"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-68)
    po_backendHubWebMovil = container "Backend — HUB Web (Móvil)" "Mismo patrón que BFF Web. Orquesta Wiki API + Registry + Perfil. Payload liviano/paginado para móvil. Valida JWT · Propaga tokens. Instancia Cloud Run independiente." "Node.js / FastAPI / Python · Cloud Run" "BFF" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-68"
            "drawio.boundary" "Backend"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-72)
    po_svcAnalitica = container "Svc: Analitica" "Entrega y consulta de data analitica" "Cloud Run" "Component" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-72"
            "drawio.boundary" "Servicios"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-90)
    po_svcNotificacion = container "Svc: Notificacion" "Gestiona notificaciones" "Cloud Run" "Component" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-90"
            "drawio.boundary" "Servicios"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-91)
    po_svcPagos = container "Svc: Pagos" "Gestiona pagos" "Cloud Run" "Component" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-91"
            "drawio.boundary" "Servicios"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-94)
    po_colaDeMensajeria = container "Cola de mensajeria" "Serivico para subir las solicitudes asincronas" "Pub/Sub" "Queue" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-94"
            "drawio.boundary" "Mensajeria"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-101)
    po_memorystoreRedisFree = container "Memorystore (Redis free)" "Sesiones · Tokens · Queries" "Cache" "Database,Cache" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-101"
            "drawio.boundary" "Backend"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-116)
    po_appMovil = container "App Móvil" "NO se despliega en GCP. Corre en el dispositivo del usuario. Se distribuye vía tiendas de apps. Consume su backend (BFF Mobile) por HTTPS." "iOS / Android · App Store / Play Store" "External Software System,Frontend,Mobile" {
        properties {
            "c4.tipo" "React native — Cliente"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-116"
            "drawio.boundary" "Frontend"
        }
    }

    # Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-128)
    po_otelCollector = container "OTel Collector" "Recibe OTLP (gRPC/HTTP) de todos los servicios. Enmascara datos personales antes de exportar. Exporta trazas, metricas y logs a Dynatrace. Materializa la estrategia 'OTel First' de la politica." "OpenTelemetry Collector . Cloud Run" "Observability" {
        properties {
            "c4.tipo" "Container"
            "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-128"
        }
    }
}
