# =============================================================================
# Relaciones entre elementos (Fuente: Draw.io Volarte v1 · L0/L1/L2/L3)
# Convención: la tecnología de cada relación declara el protocolo y su
# cifrado (TLS / mTLS / IAM). El Agente Revisor lo usa para detectar tramos
# no cifrados.
# =============================================================================

# ---------------------------------------------------------------- Personas
empleado -> fwShell "Accede a Volarte con SSO (navega, consulta, concilia)" "HTTPS · TLS 1.3"
usuarioExterno -> fwShell "Accede a Volarte (portal externo)" "HTTPS · TLS 1.3"
operario -> maNav "Opera en campo: turnos, checklist, PQDA, firma" "UI nativa Android"
adminDev -> fwShell "Administra módulos, permisos y publica versiones" "HTTPS · TLS 1.3"

# ---------------------------------------------------- Borde / Red (Web, red pública)
empleado -> cloudflare "Resuelve DNS y tráfico web" "HTTPS · TLS 1.3"
usuarioExterno -> cloudflare "Resuelve DNS y tráfico web" "HTTPS · TLS 1.3"
cloudflare -> extLb "Proxy pass-through (DNS apunta a IP del LB externo)" "HTTPS · TLS 1.3"
extLb -> firewall "Reenvía tráfico; resuelve NAT" "HTTPS · TLS"
firewall -> intLb "Reenvía tráfico inspeccionado" "HTTPS · TLS"
intLb -> apigee "Enruta a Proxy instance de Apigee" "HTTPS · TLS"
apigee -> intLb "Enruta peticiones autorizadas hacia los BFF" "HTTPS · TLS"
intLb -> bwRouter "Resuelve peticiones Web (JWT ya validado por Apigee)" "HTTPS · TLS"
intLb -> bmRouter "Resuelve peticiones Móviles (JWT ya validado por Apigee)" "HTTPS · TLS"
ztna -> apigee "Acceso privado ZTNA (sin Cloudflare)" "mTLS · Red corporativa privada"

# --------------------------------------------------------- Frontend Web (L3)
fwAuth -> entraId "Login SSO / tokens (Authorization Code + PKCE)" "OIDC · HTTPS"
fwAuth -> ciam "Login de usuarios externos" "OIDC · HTTPS"
fwApiClient -> apigee "Consume APIs del BFF Web (sin caché)" "REST/JSON · JWT · HTTPS"
fwErrorBoundary -> dynatrace "Envía eventos RUM de uso / error" "Dynatrace RUM · HTTPS"
cloudflare -> frontendWeb "Sirve el bundle estático (CDN + GCS)" "HTTPS · TLS 1.3"

# --------------------------------------------------------- App Móvil (L3)
maAuth -> entraId "Login SSO (solo Entra ID)" "OIDC · HTTPS"
maZtnaClient -> ztna "Túnel gestionado (MDM / posture Intune)" "ZTNA · mTLS"
maZtnaClient -> bmRouter "Sync, delta y media (lógico: Netskope → Apigee → ILB)" "REST/JSON · JWT · mTLS" {
    tags "Logical"
}
mobileApp -> dynatrace "RUM Agent móvil" "Dynatrace OneAgent Mobile · HTTPS"

# ----------------------------------------------------------- BFF Web (L3)
bwCache -> memorystore "Cache de decisión de autorización" "Redis RESP · TLS (in-transit encryption)"
bwSecrets -> secretManager "Lee secretos (IAM Service Account)" "gRPC · TLS · IAM"
bwSvcClients -> svcUsuarios "Consulta roles / mapping" "HTTPS · ID Token (IAM Invoker)"
bwSvcClients -> svcDatosMaestros "Consulta datos maestros" "HTTPS · ID Token (IAM Invoker)"
bwSvcClients -> scRouter "Consulta elegibilidad, precio y crédito" "HTTPS · ID Token (IAM Invoker)"
bwSvcClients -> soRouter "Consulta estado de operación / turnos" "HTTPS · ID Token (IAM Invoker)"
bwSvcClients -> svcAsignacion "Solicita recomendación de asignación" "HTTPS · ID Token (IAM Invoker)"
bwOrchestrator -> cloudSql "Consultas varias (Proxy SQL)" "Cloud SQL Auth Proxy · TLS"
bwConciliation -> topicConciliacionResuelta "Publica resolución del supervisor (HU-050)" "Pub/Sub API · gRPC TLS"
bffWeb -> otelCollector "Exporta trazas, métricas y logs" "OTLP gRPC · TLS · IAM Invoker"

# ---------------------------------------------------------- BFF Móvil (L3)
bmIdempotency -> memorystore "Dedupe por UUID de acción" "Redis RESP · TLS (in-transit encryption)"
bmAuthz -> memorystore "Cache de decisión de autorización" "Redis RESP · TLS (in-transit encryption)"
bmSqlClient -> cloudSql "Escribe / lee tablas de Sincronización" "Cloud SQL Connector · TLS"
bmUpload -> gcsFolders "Resumable upload de fotos / firma" "GCS JSON API · HTTPS"
bmPublisher -> topicOperacionCerrada "Publica cierre de operación" "Pub/Sub API · gRPC TLS"
bmPublisher -> topicDocPublicacion "Publica solicitud de documento" "Pub/Sub API · gRPC TLS"
bmDelta -> soRouter "Obtiene turnos / estado operativo" "HTTPS · ID Token (IAM Invoker)"
bmDelta -> svcDatosMaestros "Obtiene catálogos versionados" "HTTPS · ID Token (IAM Invoker)"
bffMobile -> secretManager "Lee secretos (IAM Service Account)" "gRPC · TLS · IAM"
bffMobile -> topicTracking "Publica eventos de tracking de alta frecuencia" "Pub/Sub API · gRPC TLS"
bffMobile -> otelCollector "Exporta trazas, métricas y logs" "OTLP gRPC · TLS · IAM Invoker"

# ------------------------------------------------------------- Pub/Sub (L3)
subGestorDocumental -> gdSubscriber "Push: dispara publicación documental" "HTTPS push · OIDC token"
subComercial -> scClosedSub "Push: actualiza saldo / crédito" "HTTPS push · OIDC token"
subOperacionConciliacion -> soConciliationSub "Push: finaliza / anula operación pendiente" "HTTPS push · OIDC token"
subTracking -> soTrackingSub "Push: eventos de tracking" "HTTPS push · OIDC token"
pubsub -> datalake "Exporta eventos al datalake (BigQuery subscription)" "Pub/Sub BigQuery subscription"

# ------------------------------------------------------- Gestor Documental (L3)
gdNumbering -> cloudSql "Persiste número / metadata documental" "Cloud SQL Connector · TLS"
gdGcsClient -> gcsFolders "Sube documento final (único escritor)" "GCS JSON API · HTTPS"

# ------------------------------------------------------------ Documentos GCS
gcsCmek -> kms "Cifra objetos con CMEK" "Cloud KMS API · TLS"

# ---------------------------------------------------- Svc Usuarios / Auth (L3)
suGraphAdapter -> entraId "Sincroniza pertenencia a grupos" "Microsoft Graph API · HTTPS · OAuth2 client credentials"
suCacheInvalidator -> memorystore "Invalida decisiones cacheadas" "Redis RESP · TLS (in-transit encryption)"
suSqlClient -> cloudSql "Lee / escribe usuarios, roles y mapping" "Cloud SQL Connector · TLS"
entraId -> svcUsuarios "Provisiona identidades / grupos" "SCIM / OIDC · HTTPS"

# ------------------------------------------------------- Svc Operación (L3)
soPosition -> svcDatosMaestros "Consulta geocerca (S02 / HU-145)" "HTTPS · ID Token (IAM Invoker)"
soDbClient -> cloudSql "Lee / escribe tablas operacionales" "Cloud SQL Connector · TLS"

# ------------------------------------------------------- Svc Comercial (L3)
scPrice -> priceProvider "Consulta precio (cuando se confirme P-072)" "REST · HTTPS"
scDbClient -> cloudSql "Lee / escribe estado comercial" "Cloud SQL Connector · TLS"

# ---------------------------------------------------- Svc Datos Maestros / Asignación
svcDatosMaestros -> cloudSql "Lee / escribe datos maestros" "Cloud SQL Connector · TLS"
svcDatosMaestros -> salesforce "Sincroniza dato maestro de clientes" "REST · HTTPS · OAuth2"
svcAsignacion -> skypredict "Solicita recomendación (degradación controlada)" "REST · HTTPS"
svcAsignacion -> soRouter "Lee estado dinámico de equipos / operadores" "HTTPS · ID Token (IAM Invoker)"

# ----------------------------------------------------------- Seguridad / Datos
cloudSql -> kms "Cifrado en reposo (CMEK)" "Cloud KMS API · TLS"
secretManager -> kms "Cifra secretos con CMEK" "Cloud KMS API · TLS"
dataFusion -> datalake "Ingesta datos transformados (ETL)" "BigQuery API · TLS"
dataFusion -> sap "Extrae datos transaccionales (ERP)" "SAP OData · TLS"
dataFusion -> salesforce "Extrae dato maestro de clientes" "Salesforce Bulk API · HTTPS"
dataFusion -> zenput "Extrae datos operativos" "REST · HTTPS"
dataFusion -> gurusoft "Extrae datos de facturación" "REST · HTTPS"

# ----------------------------------------------------------- Observabilidad
otelCollector -> dynatrace "Exporta telemetría enmascarada" "OTLP HTTPS · API Token"
cloudLogging -> cloudMonitoring "Métricas basadas en logs · alertas" "GCP internal"

# ------------------------------------------- Referencia L0 (HUB corporativo)
empleado -> hubPortal "Navega wiki, lanza apps y federa sesión" "HTTPS · TLS 1.3"
hubPortal -> entraId "Delega autenticación" "OIDC / OAuth 2.0"
hubPortal -> apigee "Consume APIs corporativas" "REST · JWT · HTTPS"
hubPortal -> powerBi "Embebe reportes vía Power BI Proxy" "Power BI REST API · AAD"
hubPortal -> otelCollector "Exporta telemetría" "OTLP gRPC · TLS"
hubPortal -> volarte "Lanza Volarte desde el catálogo de web apps (SSO)" "HTTPS · OIDC token exchange"

# ------------------------------------------------- v2 · Observabilidad "OTel First"
# Corrección v2: el L0 del Draw.io indica que el OTel Collector "se conecta a todas
# las Cloud Run de Backend y Servicios"; v1 solo lo modelaba para los BFF.
svcUsuarios -> otelCollector "Exporta trazas, métricas y logs" "OTLP gRPC · TLS · IAM Invoker"
svcDatosMaestros -> otelCollector "Exporta trazas, métricas y logs" "OTLP gRPC · TLS · IAM Invoker"
svcComercial -> otelCollector "Exporta trazas, métricas y logs" "OTLP gRPC · TLS · IAM Invoker"
svcOperacion -> otelCollector "Exporta trazas, métricas y logs" "OTLP gRPC · TLS · IAM Invoker"
svcAsignacion -> otelCollector "Exporta trazas, métricas y logs" "OTLP gRPC · TLS · IAM Invoker"
gestorDocumental -> otelCollector "Exporta trazas, métricas y logs" "OTLP gRPC · TLS · IAM Invoker"
