# =============================================================================
# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).
# Sistemas externos, plataforma corporativa y elementos de referencia
# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.
# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.
# =============================================================================

# Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-2); L0 · Referencia (sR61ePaMgubpxd_IzPhU-73); L3 · Frontend Web (K3x9ieyRvBXn8_fBmudi-2); L3 · BFF Web (m82-UoYV6cME8UAHcOga-2); L3 · BFF Movil (_G9imbh4nfA6h8SqaJqN-1)
apigee = softwareSystem "ApiGee" "Plataforma de administración de API nativa de Google Cloud. Valida firma/issuer/audience del JWT contra el JWKS de Entra ID." "Container,APIGateway" {
    properties {
        "c4.tipo" "Component"
        "c4.tecnologia" "Api Gatawey"
        "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-2; L0 · Referencia#sR61ePaMgubpxd_IzPhU-73; L3 · Frontend Web#K3x9ieyRvBXn8_fBmudi-2; L3 · BFF Web#m82-UoYV6cME8UAHcOga-2; L3 · BFF Movil#_G9imbh4nfA6h8SqaJqN-1"
        "drawio.boundary" "terpel-gtic-apigee-AMB (dev-qa-prd)"
    }
}

# Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-4)
ss_externalRegionalLoadBalancer = softwareSystem "External Regional Load Balancer" "SSL/TLS terminado en el borde. Enrutamiento al IAP y Cloud Run." "Component" {
    properties {
        "c4.tipo" "Component"
        "c4.tecnologia" "GCP Cloud Load Balancing"
        "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-4"
        "drawio.boundary" "terpel-infra-vpc-transversal"
    }
}

# Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-10); L0 · Referencia (sR61ePaMgubpxd_IzPhU-84)
firewall = softwareSystem "Firewall" "Firewall de red encargado de inspeccionar y controlar el tráfico de entrada y salida, aplicando políticas de seguridad y NAT según las reglas definidas." "External Software System" {
    properties {
        "c4.tipo" "Palo alto"
        "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-10; L0 · Referencia#sR61ePaMgubpxd_IzPhU-84"
        "drawio.boundary" "terpel-infra-vpc-transversal"
    }
}

# Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-18); L0 · Referencia (sR61ePaMgubpxd_IzPhU-102)
ilbTransversal = softwareSystem "Internal Load Balancer" "SSL/TLS terminado en el borde. Enrutamiento al IAP y Cloud Run." "Component" {
    properties {
        "c4.tipo" "Component"
        "c4.tecnologia" "GCP Cloud Load Balancing"
        "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-18; L0 · Referencia#sR61ePaMgubpxd_IzPhU-102"
        "drawio.boundary" "terpel-gtic-front-AMB (dev,qa y prd)"
    }
}

# Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-19); L0 · Referencia (sR61ePaMgubpxd_IzPhU-103)
proxyApigee = softwareSystem "Proxy instance" "Puente de conexion" "Component" {
    properties {
        "c4.tipo" "Component"
        "c4.tecnologia" "Apigge"
        "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-19; L0 · Referencia#sR61ePaMgubpxd_IzPhU-103"
        "drawio.boundary" "terpel-gtic-apigee-AMB (dev-qa-prd)"
    }
}

# Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-68); L0 · Referencia (sR61ePaMgubpxd_IzPhU-50)
cloudflare = softwareSystem "Cloudflare" "Plataforma de protección de tráfico y optimización de acceso web para servicios externos." "External Software System" {
    properties {
        "c4.tipo" "Component"
        "c4.tecnologia" "Cloudflare"
        "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-68; L0 · Referencia#sR61ePaMgubpxd_IzPhU-50"
        "drawio.boundary" "Diagrama Contenedores"
    }
}

# Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-69); L0 · Referencia (sR61ePaMgubpxd_IzPhU-23); L1 · Context (jBqDDpGHMn_ggPszUGn9-9); L3 · Frontend Web (K3x9ieyRvBXn8_fBmudi-1); L3 · App Movil (IJ51pq0J-d0GQBmwbhIP-2); L3 · Svc Usuarios Auth (QJXrHxYRZstZZbYl4sQt-4)
entraId = softwareSystem "EntraID / CIAM" "Proveedor de identidad corporativo. SSO · MFA · RBAC. Transversal al hub" "External Software System,IdentityProvider" {
    properties {
        "c4.tipo" "Sistema Externo — Identidad"
        "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-69; L0 · Referencia#sR61ePaMgubpxd_IzPhU-23; L1 · Context#jBqDDpGHMn_ggPszUGn9-9; L3 · Frontend Web#K3x9ieyRvBXn8_fBmudi-1; L3 · App Movil#IJ51pq0J-d0GQBmwbhIP-2; L3 · Svc Usuarios Auth#QJXrHxYRZstZZbYl4sQt-4"
        "drawio.boundary" "Diagrama Contenedores"
    }
}

# Draw.io: L2 · Container (p8cCmguKJE-8GRD_PWvh-75); L0 · Referencia (sR61ePaMgubpxd_IzPhU-24)
ztna = softwareSystem "ZTNA" "GlobalProtect · Zscaler Device posture check · Intune Split tunneling controlado Solo acceso desde red corporativa" "Component" {
    properties {
        "c4.tipo" "Component"
        "c4.tecnologia" "Netscope"
        "drawio.ocurrencias" "L2 · Container#p8cCmguKJE-8GRD_PWvh-75; L0 · Referencia#sR61ePaMgubpxd_IzPhU-24"
        "drawio.boundary" "Diagrama Contenedores"
    }
}

# Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-18)
ss_portalesExternosFuturos = softwareSystem "+ Portales Externos Futuros" "Cualquier portal que acepte federación SAML 2.0 / OIDC" "" {
    properties {
        "c4.tipo" "[Sistemas Externos — Portales]"
        "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-18"
    }
}

# Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-25)
ss_globalLoadBalancer = softwareSystem "Global Load Balancer" "SSL/TLS terminado en el borde. Enrutamiento al IAP y Cloud Run." "Component" {
    properties {
        "c4.tipo" "Component"
        "c4.tecnologia" "GCP Cloud Load Balancing"
        "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-25"
        "drawio.boundary" "Ingress Corporativo"
    }
}

# Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-26)
ss_identityAwareProxyIap = softwareSystem "Identity-Aware Proxy (IAP)" "Capa de seguridad nativa GCP. Valida identidad antes de llegar a cualquier servicio interno. Integrado con EntraID via OIDC. Sin VPN requerida para el acceso web." "Component" {
    properties {
        "c4.tipo" "Component"
        "c4.tecnologia" "GCP IAP · OIDC"
        "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-26"
        "drawio.boundary" "Ingress Corporativo"
    }
}

# Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-39)
ss_cloudKms = softwareSystem "Cloud KMS" "Gestión de claves de cifrado (CMEK). Cifra: Cloud SQL · GCS · Firestore. Cifra secretos en Secret Manager. HSM · rotación de claves." "Container" {
    properties {
        "c4.tipo" "Container"
        "c4.tecnologia" "GCP Key Management Service"
        "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-39"
        "drawio.boundary" "Api Management y Seguridad"
    }
}

# Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-40)
ss_secretManager = softwareSystem "Secret Manager" "Almacena secretos de todos los servicios: credenciales DB · API keys · client secrets. Acceso via Service Account (IAM). Rotación automática · audit log." "Container" {
    properties {
        "c4.tipo" "Container"
        "c4.tecnologia" "GCP Secret Manager"
        "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-40"
        "drawio.boundary" "Api Management y Seguridad"
    }
}

# Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-60)
ss_powerBiService = softwareSystem "Power BI Service" "Servicio de BI en la nube. Embed API · REST API Dashboards · Reports · Datasets" "" {
    properties {
        "c4.tipo" "Sistema Externo — Microsoft"
        "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-60"
    }
}

# Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-71); L1 · Context (jBqDDpGHMn_ggPszUGn9-38)
datalake = softwareSystem "Datalake" "Repositorio analítico y estructurado de datos tabulares. Recibe información transformada por los ETL." "Container,Database" {
    properties {
        "c4.tipo" "Container"
        "c4.tecnologia" "Big Query"
        "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-71; L1 · Context#jBqDDpGHMn_ggPszUGn9-38"
        "drawio.boundary" "Datos"
    }
}

# Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-85)
ss_cloudDataFusion = softwareSystem "Cloud Data Fusion" "Ingesta al datalake corporativo" "External Software System" {
    properties {
        "c4.tipo" "Container"
        "c4.tecnologia" "Data Integration"
        "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-85"
        "drawio.boundary" "Transversal"
    }
}

# Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-86)
ss_salesforce = softwareSystem "SalesForce" "Dato maestro de los clientes" "External Software System" {
    properties {
        "c4.tipo" "Component"
        "c4.tecnologia" "Software System"
        "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-86"
        "drawio.boundary" "Transversal"
    }
}

# Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-87)
ss_sapErp = softwareSystem "SAP ERP" "ERP de terpel" "" {
    properties {
        "c4.tipo" "Component"
        "c4.tecnologia" "Software System"
        "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-87"
        "drawio.boundary" "Transversal"
    }
}

# Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-88)
ss_zenput = softwareSystem "ZENPUT" "Sistema corporativo referenciado en la página L0 sin descripción en el Draw.io (pendiente de confirmar por Arquitectura)." "External Software System" {
    properties {
        "c4.tipo" "Component"
        "c4.tecnologia" "Software System"
        "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-88"
        "drawio.boundary" "Transversal"
    }
}

# Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-89)
ss_gurusoft = softwareSystem "GuruSoft" "Servicio de facturacion" "External Software System" {
    properties {
        "c4.tipo" "Servicio externo"
        "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-89"
        "drawio.boundary" "Transversal"
    }
}

# Draw.io: L0 · Referencia (sR61ePaMgubpxd_IzPhU-126)
ss_dynatraceTenantTerpel = softwareSystem "Dynatrace (Tenant Terpel)" "Fuente unica de verdad corporativa (Politica de Observabilidad Terpel). APM . Infra Monitoring . DEM . RASP . Business Analytics." "External Software System,Observability" {
    properties {
        "c4.tipo" "SaaS Dynatrace"
        "drawio.ocurrencias" "L0 · Referencia#sR61ePaMgubpxd_IzPhU-126"
        "drawio.boundary" "Observabilidad"
    }
}

# Draw.io: L1 · Context (jBqDDpGHMn_ggPszUGn9-6)
ss_googleCloudPlatform = softwareSystem "Google Cloud Platform" "Cloud Run · Cloud SQL · Firestore GCS · BigQuery · Secret Manager Cloudflare CDN / WAF" "" {
    properties {
        "c4.tipo" "Sistema Externo — Infra"
        "drawio.ocurrencias" "L1 · Context#jBqDDpGHMn_ggPszUGn9-6"
        "drawio.boundary" "Diagrama Context"
    }
}

# Draw.io: L1 · Context (jBqDDpGHMn_ggPszUGn9-7)
ss_sistemasExternosFuturos = softwareSystem "+ Sistemas Externos Futuros" "SAP · SALESFORCE · COUPA o cualquier sistema transaccional que necesite el portal" "External Software System" {
    properties {
        "c4.tipo" "Sistemas Externos"
        "drawio.ocurrencias" "L1 · Context#jBqDDpGHMn_ggPszUGn9-7"
        "drawio.boundary" "Diagrama Context"
    }
}

# Draw.io: L1 · Context (jBqDDpGHMn_ggPszUGn9-12)
ss_webappsExternosFuturos = softwareSystem "+ Webapps Externos Futuros" "sistemas o cualquier portal que acepte federación SAML 2.0 / OIDC o comunicacion API REST" "" {
    properties {
        "c4.tipo" "Sistemas internos — Portales/ aplicaciones"
        "drawio.ocurrencias" "L1 · Context#jBqDDpGHMn_ggPszUGn9-12"
        "drawio.boundary" "Diagrama Context"
    }
}

# Draw.io: L1 · Context (jBqDDpGHMn_ggPszUGn9-34)
ss_ciam = softwareSystem "CIAM" "Gestiona la identidad y acceso de usuarios externos, proporcionando autenticación, autorización, registro de usuarios y gestión del ciclo de vida de identidades." "External Software System,IdentityProvider" {
    properties {
        "c4.tipo" "Ping Identity"
        "drawio.ocurrencias" "L1 · Context#jBqDDpGHMn_ggPszUGn9-34"
        "drawio.boundary" "Diagrama Context"
    }
}

# Draw.io: L1 · Context (jBqDDpGHMn_ggPszUGn9-15)
ce_capacidadesTransversales = element "Capacidades Transversales" "Nota" "Aplicables a todos los portales del ecosistema. • Seguridad: OAuth2/OIDC · RBAC/ABAC · Zero Trust • Observabilidad: Logs · Tracing · Métricas · SLOs • Resiliencia: Circuit Breaker · Retry · Timeout • Escalabilidad: Auto-scaling · Event-driven • Gobernanza: API versioning · Data contracts · ADRs" "Nota" {
    properties {
        "c4.tipo" "Nota"
        "drawio.ocurrencias" "L1 · Context#jBqDDpGHMn_ggPszUGn9-15"
        "drawio.boundary" "Diagrama Context"
    }
}

# Draw.io: L3 · BFF Web (m82-UoYV6cME8UAHcOga-1)
ce_serviciosDeDominio = element "Servicios de dominio" "Contenedores externos" "S02, S04, S06, S01 (fuera de este contenedor)" "External Software System" {
    properties {
        "c4.tipo" "Contenedores externos"
        "drawio.ocurrencias" "L3 · BFF Web#m82-UoYV6cME8UAHcOga-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Svc Usuarios Auth (QJXrHxYRZstZZbYl4sQt-1); L3 · Svc Operacion (i--iAFYeRP1RJYZK3LzI-1)
ce_bffWebBffMovil = element "BFF Web / BFF Móvil" "Contenedores externos" "Consumidores" "External Software System" {
    properties {
        "c4.tipo" "Contenedores externos"
        "drawio.ocurrencias" "L3 · Svc Usuarios Auth#QJXrHxYRZstZZbYl4sQt-1; L3 · Svc Operacion#i--iAFYeRP1RJYZK3LzI-1"
        "drawio.boundary" "Diagrama Componente"
    }
}

# Draw.io: L3 · Svc Comercial (H-s8rk4Q10PAkRIC20Ai-1)
ss_priceproviderExterno = softwareSystem "PriceProvider externo" "Fuente de precio — P-072 PENDING" "External Software System,Pending" {
    properties {
        "c4.tipo" "Sistema externo"
        "drawio.ocurrencias" "L3 · Svc Comercial#H-s8rk4Q10PAkRIC20Ai-1"
        "drawio.boundary" "Diagrama Componente"
    }
}
