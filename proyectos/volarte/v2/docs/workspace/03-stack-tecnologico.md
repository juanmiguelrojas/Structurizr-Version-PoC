## Stack tecnológico y especificaciones

Resumen por capa de las tecnologías declaradas en el modelo, con su rol y las restricciones que
impone la arquitectura. Lo marcado como **Por confirmar** no está definido en la fuente y debe cerrarse
mediante ADR. El PDF incluye además el catálogo automático de tecnologías y protocolos extraído del DSL.

### Canales

| Contenedor | Tecnología | Especificación / restricciones |
|---|---|---|
| Frontend Web | React (CSR) + Vite · SPA, React Router, React Query, MSAL.js, Axios | Un solo bundle con *code-splitting* por rol (`React.lazy`). Login OAuth2 Authorization Code + **PKCE**; token **solo en memoria** (no `localStorage`). Servida por Cloudflare CDN con origen en bucket GCS (`terpel-gtic-front`). Toda llamada a datos pasa por Apigee → BFF Web (regla R3). RUM Dynatrace vía Error Boundary. |
| App Móvil | React Native · **Android exclusivo**, React Navigation, WatermelonDB (SQLite), SQLCipher + Android Keystore, NetInfo, Netskope Agent | Offline-first: base local cifrada (clave no exportable), cola de escritura con **UUID por acción**, máquina de estados PENDIENTE → ENVIANDO → CONFIRMADO / CONFLICTO / ERROR, backoff 5 s – 5 min. Red **solo por ZTNA Netskope** con *posture* Intune (sin Cloudflare). Distribución Intune / Managed Play. |

### Backends for Frontend

| Contenedor | Tecnología | Especificación / restricciones |
|---|---|---|
| BFF Web | Python · FastAPI · Cloud Run | 2.ª validación JWT (issuer / audience / exp) tras Apigee; `GroupToRoleMapping → Role/Permission/Capability` con cache Redis TTL corto; llamadas Cloud Run → Cloud Run con **ID Token (IAM Invoker)**; secretos vía Secret Manager (Service Account). Publica `conciliacion-resuelta`. |
| BFF Móvil | Python · FastAPI · Cloud Run | Respuestas ultra-livianas; sync con **idempotencia por UUID** (Redis), **reordenamiento por timestamp de captura**, reconciliación **HU-050** (auto-acepta o `PENDING_REVIEW`), delta HU-007 y *resumable upload* a GCS. Publica `operacion-cerrada`, `doc-publicacion`, `tracking-eventos`. |

### Servicios de dominio

| Contenedor | Tecnología | Especificación / restricciones |
|---|---|---|
| Svc Usuarios / Auth (S01) | Python · FastAPI · Cloud Run · SQLAlchemy · Microsoft Graph | Resolver RN-007/RN-008, sincronización de grupos cuando el claim `groups` se trunca, auditoría de toda decisión, invalidación activa de cache. |
| Svc Datos Maestros (S02) | Python · FastAPI · Cloud Run | Customer, AircraftOperator/Type/Registration, FuellingEquipment, NegotiationProfile, geocercas (HU-145). Sin L3 en la fuente. |
| Svc Comercial (S04) | Python · FastAPI · Cloud Run | Elegibilidad (HU-128), crédito disponible, precio vía **PriceProvider (P-072 PENDING)**; suscriptor `operacion-cerrada`. |
| Svc Operación (S05) | Python · FastAPI · Cloud Run | Turnos (HU-056), posición vs geocerca (HU-044/HU-145), inventario de calidad PQDA (IR-06); suscriptores tracking y conciliación. |
| Svc Asignación (S06) | Python · solver MILP · **GKE** | Cómputo sostenido; recomendación Skypredict con degradación controlada. Runtime **P-025 PENDING** (ADR 0005 *Proposed*). |
| Gestor Documental | Python · FastAPI · Cloud Run | Publicación **idempotente** (HU-055) con ID inmutable, numeración secuencial auditable, plantillas PDF / AIDX XML, único escritor del bucket. |

### Mensajería y datos

| Contenedor | Tecnología | Especificación / restricciones |
|---|---|---|
| Cola de Mensajería | Google Cloud Pub/Sub | Topics `operacion-cerrada` (fan-out ×3), `conciliacion-resuelta`, `doc-publicacion`, `tracking-eventos`; suscripciones **push con token OIDC**, 5 reintentos (10 s – 600 s) y **Dead Letter Topic**. `tracking-eventos-sub` sin DLQ: **Por confirmar**. |
| Cloud SQL | PostgreSQL · Cloud SQL | Datos transaccionales, tablas de Sincronización y numeración documental; **CMEK** (Cloud KMS); acceso por Cloud SQL Connector (TLS). Alta disponibilidad: **Por confirmar** (posible SPOF, ver reporte). |
| Memorystore | Redis · Memorystore | Sesiones, decisiones de autorización e idempotencia. Tier (Basic / Standard HA): **Por confirmar**. |
| Documentos (GCS) | Google Cloud Storage | Bucket WORM (Object Versioning + retención), lifecycle Nearline/Coldline, CMEK, escritura solo SA del Gestor Documental (y BFF Móvil para media), lectura por *signed URLs*. |

### Plataforma transversal (fuera del alcance de Volarte)

Cloudflare (WAF/CDN), External/Internal Load Balancer GCP, Firewall Palo Alto, **Apigee** (validación JWT contra JWKS de Entra ID),
Netskope ZTNA, Secret Manager, Cloud KMS, **OTel Collector → Dynatrace** (política "OTel First"), Cloud Logging / Monitoring,
Entra ID y CIAM Ping Identity, Datalake BigQuery + Cloud Data Fusion. Se modelan como **External Software System**.

### Estándares transversales obligatorios

- **Seguridad**: OAuth2/OIDC + PKCE, doble validación de JWT, IAM Invoker entre servicios, secretos solo en Secret Manager, CMEK en reposo, TLS en todo tramo.
- **Observabilidad**: todo contenedor de ejecución exporta OTLP al OTel Collector (enmascarado de datos personales) → Dynatrace.
- **Resiliencia**: reintentos con backoff, DLQ en toda suscripción, idempotencia por UUID, degradación controlada en dependencias externas.
