# =============================================================================
# Sistemas externos, plataforma transversal e infraestructura compartida
# (Fuente: Draw.io Volarte v1 · L0 Referencia, L1 Context, L2 Container)
#
# Convención: todo lo que NO es propiedad del equipo Volarte se modela como
# softwareSystem con el tag de leyenda "External Software System" (color C4 gris)
# más un tag semántico que solo define la FORMA:
#   External Software System -> (leyenda C4) TODO sistema fuera del alcance de Volarte
#   Infrastructure  -> red, borde y enrutamiento (Cloudflare, LB, Firewall, ZTNA)
#   APIGateway      -> capa de API Management (Apigee)
#   Security        -> gestión de secretos y llaves
#   Observability   -> telemetría (OTel, Dynatrace, Cloud Logging/Monitoring)
#   IdentityProvider-> proveedores de identidad
# =============================================================================

group "Identidad" {
    entraId = softwareSystem "Microsoft Entra ID" "Proveedor de identidad corporativo (empleados y operarios). SSO · MFA · RBAC por grupos. OIDC / OAuth 2.0 + PKCE. Transversal al hub." "External Software System,IdentityProvider"
    ciam = softwareSystem "CIAM Ping Identity" "Gestiona identidad y acceso de usuarios externos: autenticación, autorización, registro y ciclo de vida de identidades." "External Software System,IdentityProvider"
}

group "Borde y Red Corporativa (terpel-infra-vpc-transversal)" {
    cloudflare = softwareSystem "Cloudflare" "Plataforma de protección de tráfico (WAF, DDoS) y CDN para el acceso web desde red pública. DNS apunta a la IP del LB externo (pass-through)." "External Software System,Infrastructure,Edge"
    ztna = softwareSystem "ZTNA Netskope" "Acceso Zero Trust para dispositivos gestionados: posture check (Intune), GlobalProtect/Zscaler, split tunneling controlado. Único camino de red de la app móvil." "External Software System,Infrastructure,Edge"
    extLb = softwareSystem "External Regional Load Balancer" "GCP Cloud Load Balancing externo. Termina SSL/TLS en el borde y enruta hacia el firewall corporativo." "External Software System,Infrastructure"
    firewall = softwareSystem "Firewall Palo Alto" "Firewall de red que inspecciona y controla el tráfico de entrada y salida, aplicando políticas de seguridad y NAT." "External Software System,Infrastructure"
    intLb = softwareSystem "Internal Load Balancer" "GCP Cloud Load Balancing interno. Re-cifra TLS y enruta hacia la instancia proxy de Apigee y hacia los BFF en Cloud Run." "External Software System,Infrastructure"
}

group "API Management (terpel-gtic-apigee)" {
    apigee = softwareSystem "Apigee API Gateway" "Plataforma de administración de APIs nativa de GCP (Proxy instance + Gateway). Valida firma/issuer/audience del JWT contra el JWKS de Entra ID, aplica cuotas y políticas." "External Software System,APIGateway"
}

group "Seguridad Transversal" {
    secretManager = softwareSystem "GCP Secret Manager" "Almacena secretos de todos los servicios (credenciales DB, API keys, client secrets). Acceso vía Service Account (IAM). Rotación automática y audit log." "External Software System,Security"
    kms = softwareSystem "Cloud KMS" "Gestión de llaves de cifrado (CMEK, HSM, rotación). Cifra Cloud SQL, GCS, Firestore y los secretos de Secret Manager." "External Software System,Security"
}

group "Observabilidad" {
    otelCollector = softwareSystem "OTel Collector" "OpenTelemetry Collector (Cloud Run). Recibe OTLP gRPC/HTTP, enmascara datos personales y exporta trazas, métricas y logs a Dynatrace (estrategia 'OTel First')." "External Software System,Observability"
    dynatrace = softwareSystem "Dynatrace (Tenant Terpel)" "Fuente única de verdad corporativa de observabilidad: APM, Infra Monitoring, DEM/RUM, RASP y Business Analytics." "External Software System,Observability"
    cloudLogging = softwareSystem "GCP Cloud Logging" "Logs centralizados y audit logs (IAP, Secret Manager, KMS). Retención configurable y alertas." "External Software System,Observability"
    cloudMonitoring = softwareSystem "GCP Cloud Monitoring" "Métricas de Cloud Run, alertas de errores/latencia, dashboards, uptime checks y SLO tracking." "External Software System,Observability"
}

group "Datos y Analítica Corporativa" {
    datalake = softwareSystem "Datalake BigQuery" "Repositorio analítico corporativo de datos tabulares. Recibe información transformada por los ETL (Cloud Data Fusion)." "External Software System,Database"
    dataFusion = softwareSystem "Cloud Data Fusion" "Integración de datos (ETL) e ingesta al datalake corporativo." "External Software System"
}

group "Sistemas Transaccionales Corporativos" {
    sap = softwareSystem "SAP ERP" "ERP corporativo de Terpel." "External Software System"
    salesforce = softwareSystem "Salesforce" "Dato maestro de clientes." "External Software System"
    zenput = softwareSystem "Zenput" "Sistema corporativo referenciado en L0 (el Draw.io no trae descripción; pendiente de confirmar por Arquitectura)." "External Software System"
    gurusoft = softwareSystem "GuruSoft" "Servicio externo de facturación electrónica." "External Software System"
    priceProvider = softwareSystem "PriceProvider Externo" "Fuente autoritativa de precios de combustible (decisión P-072 PENDING). Volarte no inventa la fuente de precio." "External Software System,Pending"
    skypredict = softwareSystem "Skypredict" "Motor externo de recomendación/predicción usado por el servicio de Asignación/Optimización." "External Software System"
}

group "Ecosistema de Portales (Referencia L0)" {
    hubPortal = softwareSystem "HUB Corporativo (Portal)" "Portal interno/externo de referencia (L0): wiki de conocimiento, catálogo de web apps, SSO federado y shell MFE. Comparte la plataforma transversal con Volarte." "External Software System,Reference"
    powerBi = softwareSystem "Power BI Service" "Servicio de BI de Microsoft (Embed API, REST API, dashboards y reports) consumido por el HUB vía Power BI Proxy." "External Software System"
}
