# Trazabilidad Draw.io → Structurizr (generado)

Generado por `scripts/drawio2structurizr.py`. Una fila por forma del Draw.io: a qué elemento del modelo
corresponde, con qué regla se decidió y si la página muestra un texto distinto al del modelo (alias de presentación).
El detalle máquina-legible está en `trazabilidad.json`.

- Formas Draw.io: **182** · Elementos de modelo: **143** · Relaciones: **197** · Anotaciones sin relación: **3**

## L0 · Referencia → vista `L0_Referencia`

| Draw.io id | Forma (tipo · clase) | Elemento de modelo | Tipo modelo | Regla | Texto de presentación |
|---|---|---|---|---|---|
| `d_IzPhU-11` | **Search** (Container · Container) | `po_search` Search | container en portal | L0: contenedor del Portal | — |
| `d_IzPhU-12` | **Storage** (Container · Container) | `po_storage` Storage | container en portal | L0: contenedor del Portal | — |
| `d_IzPhU-13` | **Database** (Container · Container) | `po_database` Database | container en portal | L0: contenedor del Portal | — |
| `d_IzPhU-14` | **Cloud SQL (PostgreSQL)** (Container · Container) | `po_cloudSqlPostgresql` Cloud SQL (PostgreSQL) | container en portal | L0: contenedor del Portal | — |
| `d_IzPhU-15` | **Memorystore (Redis)** (Container · Container) | `po_memorystoreRedis` Memorystore (Redis) | container en portal | L0: contenedor del Portal | — |
| `d_IzPhU-16` | **Svc: Wiki** (Container · Component) | `po_svcWiki` Svc: Wiki | container en portal | L0: contenedor del Portal | — |
| `d_IzPhU-17` | **Svc: Usuarios / Auth** (Container · Component) | `po_svcUsuariosAuth` Svc: Usuarios / Auth | container en portal | L0: contenedor del Portal | — |
| `d_IzPhU-18` | **+ Portales Externos Futuros** ([Sistemas Externos — Portales] · Software System) | `ss_portalesExternosFuturos` + Portales Externos Futuros | softwareSystem | L0: plataforma / sistema externo | — |
| `d_IzPhU-20` | **Backend — HUB Web** (Container · Container) | `po_backendHubWeb` Backend — HUB Web | container en portal | L0: contenedor del Portal | — |
| `d_IzPhU-22` | **HUB Front** (Container · Container) | `po_hubFront` HUB Front | container en portal | L0: contenedor del Portal | — |
| `d_IzPhU-23` | **EntraID / CIAM** (Sistema Externo — Identidad · External Software System) | `entraId` EntraID / CIAM | softwareSystem | compartido (EntraID / CIAM, EntraID / Azure AD, EntraID) | — |
| `d_IzPhU-24` | **ZTNA** (Component · Component) | `ztna` ZTNA | softwareSystem | compartido (ZTNA) | — |
| `d_IzPhU-25` | **Global Load Balancer** (Component · Component) | `ss_globalLoadBalancer` Global Load Balancer | softwareSystem | L0: plataforma / sistema externo | — |
| `d_IzPhU-26` | **Identity-Aware Proxy (IAP)** (Component · Component) | `ss_identityAwareProxyIap` Identity-Aware Proxy (IAP) | softwareSystem | L0: plataforma / sistema externo | — |
| `d_IzPhU-34` | **Cloud Monitoring** (Container · Container) | `po_cloudMonitoring` Cloud Monitoring | container en portal | L0: contenedor del Portal | — |
| `d_IzPhU-35` | **Cloud Logging** (Container · Container) | `po_cloudLogging` Cloud Logging | container en portal | L0: contenedor del Portal | — |
| `d_IzPhU-39` | **Cloud KMS** (Container · Container) | `ss_cloudKms` Cloud KMS | softwareSystem | L0: plataforma / sistema externo | — |
| `d_IzPhU-40` | **Secret Manager** (Container · Container) | `ss_secretManager` Secret Manager | softwareSystem | L0: plataforma / sistema externo | — |
| `d_IzPhU-50` | **Cloudflare** (Component · External Software System) | `cloudflare` Cloudflare | softwareSystem | compartido (Cloudflare) | — |
| `d_IzPhU-52` | **Portales Remote Modulo** (Component · Component) | `po_portalesRemoteModulo` Portales Remote Modulo | container en portal | L0: contenedor del Portal | — |
| `d_IzPhU-53` | **Federation Bridge** (Component · Component) | `po_federationBridge` Federation Bridge | container en portal | L0: contenedor del Portal | — |
| `d_IzPhU-60` | **Power BI Service** (Sistema Externo — Microsoft · Software System) | `ss_powerBiService` Power BI Service | softwareSystem | L0: plataforma / sistema externo | — |
| `d_IzPhU-62` | **Svc: Power BI Proxy** (Component · Component) | `po_svcPowerBiProxy` Svc: Power BI Proxy | container en portal | L0: contenedor del Portal | — |
| `d_IzPhU-68` | **Backend — HUB Web** (Container · Container) | `po_backendHubWebMovil` Backend — HUB Web (Móvil) | container en portal | L0: contenedor del Portal | nombre: «Backend — HUB Web» |
| `d_IzPhU-71` | **Datalake** (Container · Container) | `datalake` Datalake | softwareSystem | compartido (Datalake) | — |
| `d_IzPhU-72` | **Svc: Analitica** (Container · Component) | `po_svcAnalitica` Svc: Analitica | container en portal | L0: contenedor del Portal | — |
| `d_IzPhU-73` | **API Management** (Component · Component) | `apigee` ApiGee | softwareSystem | compartido (ApiGee, API Management, Apigee) | nombre: «API Management», tecnologia: «ApiGee», descripcion: «Plataforma de administración de API nativa de Google Cloud» |
| `d_IzPhU-84` | **Firewall** (Palo alto · External Software System) | `firewall` Firewall | softwareSystem | compartido (Firewall) | — |
| `d_IzPhU-85` | **Cloud Data Fusion** (Container · External Software System) | `ss_cloudDataFusion` Cloud Data Fusion | softwareSystem | L0: plataforma / sistema externo | — |
| `d_IzPhU-86` | **SalesForce** (Component · External Software System) | `ss_salesforce` SalesForce | softwareSystem | L0: plataforma / sistema externo | — |
| `d_IzPhU-87` | **SAP ERP** (Component · Software System) | `ss_sapErp` SAP ERP | softwareSystem | L0: plataforma / sistema externo | — |
| `d_IzPhU-88` | **ZENPUT** (Component · External Software System) | `ss_zenput` ZENPUT | softwareSystem | L0: plataforma / sistema externo | descripcion: «» |
| `d_IzPhU-89` | **GuruSoft** (Servicio externo · External Software System) | `ss_gurusoft` GuruSoft | softwareSystem | L0: plataforma / sistema externo | — |
| `d_IzPhU-90` | **Svc: Notificacion** (Container · Component) | `po_svcNotificacion` Svc: Notificacion | container en portal | L0: contenedor del Portal | — |
| `d_IzPhU-91` | **Svc: Pagos** (Container · Component) | `po_svcPagos` Svc: Pagos | container en portal | L0: contenedor del Portal | — |
| `d_IzPhU-94` | **Cola de mensajeria** (Container · Container) | `po_colaDeMensajeria` Cola de mensajeria | container en portal | L0: contenedor del Portal | — |
| `_IzPhU-101` | **Memorystore (Redis free)** (Container · Container) | `po_memorystoreRedisFree` Memorystore (Redis free) | container en portal | L0: contenedor del Portal | — |
| `_IzPhU-102` | **Internal Load Balancer** (Component · Component) | `ilbTransversal` Internal Load Balancer | softwareSystem | compartido (Internal Load Balancer) | — |
| `_IzPhU-103` | **Proxy instance** (Component · Component) | `proxyApigee` Proxy instance | softwareSystem | compartido (Proxy instance) | — |
| `_IzPhU-110` | **Empleado Interno** (Persona · Person) | `pe_empleadoInterno` Empleado Interno | person | persona (compartida por nombre) | — |
| `_IzPhU-116` | **App Móvil** (React native — Cliente · External Software System) | `po_appMovil` App Móvil | container en portal | excepción mapeo: App Móvil del HUB: cliente del Portal (React Native) dibujado en gris; semánticamente es un contenedor del Portal. | — |
| `_IzPhU-119` | **Usuario externo** (Person · External Person) | `pe_usuarioExterno` Usuario externo | person | persona (compartida por nombre) | — |
| `_IzPhU-126` | **Dynatrace (Tenant Terpel)** (SaaS Dynatrace · External Software System) | `ss_dynatraceTenantTerpel` Dynatrace (Tenant Terpel) | softwareSystem | L0: plataforma / sistema externo | — |
| `_IzPhU-128` | **OTel Collector** (Container · Container) | `po_otelCollector` OTel Collector | container en portal | L0: contenedor del Portal | — |

Conectores sin relación de modelo (anotaciones de presentación):

- `sR61ePaMgubpxd_IzPhU-19` «sin etiqueta» — extremo en boundary 'Transversal'
- `sR61ePaMgubpxd_IzPhU-123` «Se integra» — extremo en boundary 'Transversal'
- `sR61ePaMgubpxd_IzPhU-127` «sin etiqueta» — extremo en nota/texto libre

## L1 · Context → vista `L1_Context`

| Draw.io id | Forma (tipo · clase) | Elemento de modelo | Tipo modelo | Regla | Texto de presentación |
|---|---|---|---|---|---|
| `gPszUGn9-1` | **Admin / Dev Team** (Persona · Person) | `pe_adminDevTeam` Admin / Dev Team | person | persona (compartida por nombre) | — |
| `gPszUGn9-6` | **Google Cloud Platform** (Sistema Externo — Infra · Software System) | `ss_googleCloudPlatform` Google Cloud Platform | softwareSystem | L1: sistema | — |
| `gPszUGn9-7` | **+ Sistemas Externos Futuros** (Sistemas Externos · External Software System) | `ss_sistemasExternosFuturos` + Sistemas Externos Futuros | softwareSystem | L1: sistema | — |
| `gPszUGn9-8` | **Portal** (Software System · Software System) | `portal` Portal | softwareSystem | L1: sistema en alcance | — |
| `gPszUGn9-9` | **EntraID / Azure AD** (Sistema Externo — Identidad · Software System) | `entraId` EntraID / CIAM | softwareSystem | compartido (EntraID / CIAM, EntraID / Azure AD, EntraID) | nombre: «EntraID / Azure AD» |
| `PszUGn9-12` | **+ Webapps Externos Futuros** (Sistemas internos — Portales/ aplicaciones · Software System) | `ss_webappsExternosFuturos` + Webapps Externos Futuros | softwareSystem | L1: sistema | — |
| `PszUGn9-31` | **Usuario externo** (Person · External Person) | `pe_usuarioExterno` Usuario externo | person | persona (compartida por nombre) | — |
| `PszUGn9-34` | **CIAM** (Ping Identity · External Software System) | `ss_ciam` CIAM | softwareSystem | L1: sistema | — |
| `PszUGn9-38` | **Datalake** (Container · Container) | `datalake` Datalake | softwareSystem | compartido (Datalake) | — |
| `PszUGn9-39` | **Empleado Interno** (Persona · Person) | `pe_empleadoInterno` Empleado Interno | person | persona (compartida por nombre) | — |
| `PszUGn9-15` | **Capacidades Transversales** (Nota · nota) | `ce_capacidadesTransversales` Capacidades Transversales | custom | nota del Draw.io modelada como elemento | — |

## L2 · Container → vista `L2_Container`

| Draw.io id | Forma (tipo · clase) | Elemento de modelo | Tipo modelo | Regla | Texto de presentación |
|---|---|---|---|---|---|
| `GRD_PWvh-2` | **ApiGee** (Component · Container) | `apigee` ApiGee | softwareSystem | compartido (ApiGee, API Management, Apigee) | — |
| `GRD_PWvh-4` | **External Regional Load Balancer** (Component · Component) | `ss_externalRegionalLoadBalancer` External Regional Load Balancer | softwareSystem | L2: plataforma / sistema externo | — |
| `RD_PWvh-10` | **Firewall** (Palo alto · External Software System) | `firewall` Firewall | softwareSystem | compartido (Firewall) | — |
| `RD_PWvh-18` | **Internal Load Balancer** (Component · Component) | `ilbTransversal` Internal Load Balancer | softwareSystem | compartido (Internal Load Balancer) | — |
| `RD_PWvh-19` | **Proxy instance** (Component · Component) | `proxyApigee` Proxy instance | softwareSystem | compartido (Proxy instance) | — |
| `RD_PWvh-22` | **Frontend Web** (Container · Container) | `vo_frontendWeb` Frontend Web | container en volarte | L2: contenedor de Volarte | — |
| `RD_PWvh-25` | **Memorystore** (Container · Container) | `vo_memorystore` Memorystore | container en volarte | L2: contenedor de Volarte | — |
| `RD_PWvh-26` | **BFF — Backend Volarte** (Container · Container) | `vo_bffBackendVolarte` BFF — Backend Volarte | container en volarte | L2: contenedor de Volarte | — |
| `RD_PWvh-33` | **Internal Load Balancer** (Component · Component) | `vo_internalLoadBalancer` Internal Load Balancer | container en volarte | excepción mapeo: Segundo 'Internal Load Balancer' del L2, dentro del proyecto terpel-org-col-volarte-AMB: recurso propio de Volarte (el otro ILB es plataforma compartida). | — |
| `RD_PWvh-38` | **Cloud SQL (PostgreSQL)** (Container · Container) | `vo_cloudSqlPostgresql` Cloud SQL (PostgreSQL) | container en volarte | L2: contenedor de Volarte | — |
| `RD_PWvh-39` | **Svc: Usuarios / Auth** (Container · Container) | `vo_svcUsuariosAuth` Svc: Usuarios / Auth | container en volarte | L2: contenedor de Volarte | — |
| `RD_PWvh-40` | **Cloud KMS** (Container · Container) | `vo_cloudKms` Cloud KMS | container en volarte | L2: contenedor de Volarte | — |
| `RD_PWvh-43` | **Secret Manager** (Container · Container) | `vo_secretManager` Secret Manager | container en volarte | L2: contenedor de Volarte | — |
| `RD_PWvh-48` | **Gestor Documental** (Container · Container) | `vo_gestorDocumental` Gestor Documental | container en volarte | L2: contenedor de Volarte | — |
| `RD_PWvh-49` | **Documentos (GCS)** (Container · Container) | `vo_documentosGcs` Documentos (GCS) | container en volarte | L2: contenedor de Volarte | — |
| `RD_PWvh-51` | **Svc: Datos Maestros** (Container · Container) | `vo_svcDatosMaestros` Svc: Datos Maestros | container en volarte | L2: contenedor de Volarte | — |
| `RD_PWvh-52` | **Svc: Comercial** (Container · Container) | `vo_svcComercial` Svc: Comercial | container en volarte | L2: contenedor de Volarte | — |
| `RD_PWvh-53` | **Svc: Operación** (Container · Container) | `vo_svcOperacion` Svc: Operación | container en volarte | L2: contenedor de Volarte | — |
| `RD_PWvh-54` | **Svc: Asignación / Optimización** (Container · Container) | `vo_svcAsignacionOptimizacion` Svc: Asignación / Optimización | container en volarte | L2: contenedor de Volarte | — |
| `RD_PWvh-56` | **Cola de mensajeria** (Container · Container) | `vo_colaDeMensajeria` Cola de mensajeria | container en volarte | L2: contenedor de Volarte | — |
| `RD_PWvh-63` | **Empleado Interno** (Persona · Person) | `pe_empleadoInterno` Empleado Interno | person | persona (compartida por nombre) | — |
| `RD_PWvh-65` | **Usuario externo** (Person · External Person) | `pe_usuarioExterno` Usuario externo | person | persona (compartida por nombre) | — |
| `RD_PWvh-68` | **Cloudflare** (Component · External Software System) | `cloudflare` Cloudflare | softwareSystem | compartido (Cloudflare) | — |
| `RD_PWvh-69` | **EntraID / CIAM** (Sistema Externo — Identidad · External Software System) | `entraId` EntraID / CIAM | softwareSystem | compartido (EntraID / CIAM, EntraID / Azure AD, EntraID) | — |
| `RD_PWvh-70` | **Operario de equipo abastecedor** (Persona · Person) | `pe_operarioDeEquipoAbastecedor` Operario de equipo abastecedor | person | persona (compartida por nombre) | — |
| `RD_PWvh-71` | **App móvil** (Container · Container) | `vo_appMovil` App móvil | container en volarte | L2: contenedor de Volarte | — |
| `RD_PWvh-75` | **ZTNA** (Component · Component) | `ztna` ZTNA | softwareSystem | compartido (ZTNA) | — |
| `RD_PWvh-77` | **BFF Móvil** (Container · Container) | `vo_bffMovil` BFF Móvil | container en volarte | L2: contenedor de Volarte | — |

## L3 · Frontend Web → vista `L3_Frontend_Web`

| Draw.io id | Forma (tipo · clase) | Elemento de modelo | Tipo modelo | Regla | Texto de presentación |
|---|---|---|---|---|---|
| `-0hkP3Wm-1` | **App Shell / Router** (Component · Component) | `fw_appShellRouter` App Shell / Router | component en vo_frontendWeb | L3: componente de vo_frontendWeb | — |
| `-0hkP3Wm-2` | **Vistas por rol** (Component · Component) | `fw_vistasPorRol` Vistas por rol | component en vo_frontendWeb | L3: componente de vo_frontendWeb | — |
| `-0hkP3Wm-3` | **Cliente API** (Component · Component) | `fw_clienteApi` Cliente API | component en vo_frontendWeb | L3: componente de vo_frontendWeb | — |
| `-0hkP3Wm-4` | **Cache de estado servidor** (Component · Component) | `fw_cacheDeEstadoServidor` Cache de estado servidor | component en vo_frontendWeb | L3: componente de vo_frontendWeb | — |
| `-0hkP3Wm-5` | **Error Boundary / Telemetría** (Component · Component) | `fw_errorBoundaryTelemetria` Error Boundary / Telemetría | component en vo_frontendWeb | L3: componente de vo_frontendWeb | — |
| `-0hkP3Wm-6` | **Modulo de Autenticacion** (Component · Component) | `fw_moduloDeAutenticacion` Modulo de Autenticacion | component en vo_frontendWeb | L3: componente de vo_frontendWeb | — |
| `8_fBmudi-1` | **EntraID / CIAM** (Software System · External Software System) | `entraId` EntraID / CIAM | softwareSystem | compartido (EntraID / CIAM, EntraID / Azure AD, EntraID) | tipo: «Software System», descripcion: «Login SSO (MSAL.js, PKCE)» |
| `8_fBmudi-2` | **Apigee** (Componente externo · External Software System) | `apigee` ApiGee | softwareSystem | compartido (ApiGee, API Management, Apigee) | nombre: «Apigee», tipo: «Componente externo», tecnologia: «», descripcion: «Gateway API (fuera de este contenedor)» |

## L3 · App Movil → vista `L3_App_Movil`

| Draw.io id | Forma (tipo · clase) | Elemento de modelo | Tipo modelo | Regla | Texto de presentación |
|---|---|---|---|---|---|
| `fPVDgkf5-1` | **Modulo de Autenticacion** (Component · Component) | `am_moduloDeAutenticacion` Modulo de Autenticacion | component en vo_appMovil | L3: componente de vo_appMovil | — |
| `VybLAq_5-2` | **Navegación** (Component · Component) | `am_navegacion` Navegación | component en vo_appMovil | L3: componente de vo_appMovil | — |
| `VybLAq_5-3` | **Base de Datos local** (Component · Component) | `am_baseDeDatosLocal` Base de Datos local | component en vo_appMovil | L3: componente de vo_appMovil | — |
| `VybLAq_5-4` | **Motor de Sincronización** (Component · Component) | `am_motorDeSincronizacion` Motor de Sincronización | component en vo_appMovil | L3: componente de vo_appMovil | — |
| `0MfS2Fa0-1` | **Cliente API** (Component · Component) | `am_clienteApi` Cliente API | component en vo_appMovil | L3: componente de vo_appMovil | — |
| `0MfS2Fa0-2` | **Captura de Evidencia** (Component · Component) | `am_capturaDeEvidencia` Captura de Evidencia | component en vo_appMovil | L3: componente de vo_appMovil | — |
| `0MfS2Fa0-3` | **Disparador de Sync** (Component · Component) | `am_disparadorDeSync` Disparador de Sync | component en vo_appMovil | L3: componente de vo_appMovil | — |
| `QBmwbhIP-1` | **BFF Móvil** (Software System · External Software System) | `vo_bffMovil` BFF Móvil | container en volarte | compartido (BFF Móvil) | tipo: «Software System», tecnologia: «», descripcion: «Vía Netskope/ZTNA (fuera de este contenedor)» |
| `QBmwbhIP-2` | **EntraID** (Software System · External Software System) | `entraId` EntraID / CIAM | softwareSystem | compartido (EntraID / CIAM, EntraID / Azure AD, EntraID) | nombre: «EntraID», tipo: «Software System», descripcion: «Login SSO (solo Entra ID)» |
| `netskope-1` | **Netskope Client (ZTNA)** (Component · Component) | `am_netskopeClientZtna` Netskope Client (ZTNA) | component en vo_appMovil | L3: componente de vo_appMovil | — |
| `p9T_tGyF-1` | **Cifrado Local en Reposo** (Component · Component) | `am_cifradoLocalEnReposo` Cifrado Local en Reposo | component en vo_appMovil | L3: componente de vo_appMovil | — |
| `p9T_tGyF-2` | **Gestor de Estados de Sincronización** (Component · Component) | `am_gestorDeEstadosDeSincronizacion` Gestor de Estados de Sincronización | component en vo_appMovil | L3: componente de vo_appMovil | — |
| `p9T_tGyF-4` | **Component name** (Component · Component) | `am_componentName` Component name | component en vo_appMovil | L3: componente de vo_appMovil | — |

## L3 · BFF Web → vista `L3_BFF_Web`

| Draw.io id | Forma (tipo · clase) | Elemento de modelo | Tipo modelo | Regla | Texto de presentación |
|---|---|---|---|---|---|
| `hzLODzQj-1` | **API Router / Controllers** (Component · Component) | `bw_apiRouterControllers` API Router / Controllers | component en vo_bffBackendVolarte | L3: componente de vo_bffBackendVolarte | — |
| `hzLODzQj-2` | **Middleware de Autenticación** (Component · Component) | `bw_middlewareDeAutenticacion` Middleware de Autenticación | component en vo_bffBackendVolarte | L3: componente de vo_bffBackendVolarte | — |
| `hzLODzQj-3` | **Servicio de Autorización** (Component · Component) | `bw_servicioDeAutorizacion` Servicio de Autorización | component en vo_bffBackendVolarte | L3: componente de vo_bffBackendVolarte | — |
| `hzLODzQj-6` | **Orquestador de Dominio** (Component · Component) | `bw_orquestadorDeDominio` Orquestador de Dominio | component en vo_bffBackendVolarte | L3: componente de vo_bffBackendVolarte | — |
| `hzLODzQj-8` | **Clientes de Servicios** (Component · Component) | `bw_clientesDeServicios` Clientes de Servicios | component en vo_bffBackendVolarte | L3: componente de vo_bffBackendVolarte | — |
| `hzLODzQj-9` | **Cliente de Secretos** (Component · Component) | `bw_clienteDeSecretos` Cliente de Secretos | component en vo_bffBackendVolarte | L3: componente de vo_bffBackendVolarte | — |
| `zLODzQj-10` | **Cliente de Cache** (Component · Component) | `bw_clienteDeCache` Cliente de Cache | component en vo_bffBackendVolarte | L3: componente de vo_bffBackendVolarte | — |
| `8UAHcOga-1` | **Servicios de dominio** (Contenedores externos · External Software System) | `ce_serviciosDeDominio` Servicios de dominio | custom | compartido (Servicios de dominio) | — |
| `8UAHcOga-2` | **Apigee** (Software System · External Software System) | `apigee` ApiGee | softwareSystem | compartido (ApiGee, API Management, Apigee) | nombre: «Apigee», tipo: «Software System», tecnologia: «», descripcion: «Entrada, ya valida firma/issuer del JWT» |

## L3 · BFF Movil → vista `L3_BFF_Movil`

| Draw.io id | Forma (tipo · clase) | Elemento de modelo | Tipo modelo | Regla | Texto de presentación |
|---|---|---|---|---|---|
| `L66ETiHT-1` | **Servicio de Autorización** (Component · Component) | `bm_servicioDeAutorizacion` Servicio de Autorización | component en vo_bffMovil | L3: componente de vo_bffMovil | — |
| `H_jisJpw-1` | **Middleware de Autenticación** (Component · Component) | `bm_middlewareDeAutenticacion` Middleware de Autenticación | component en vo_bffMovil | L3: componente de vo_bffMovil | — |
| `09Kx5JXH-1` | **API Router / Controllers** (Component · Component) | `bm_apiRouterControllers` API Router / Controllers | component en vo_bffMovil | L3: componente de vo_bffMovil | — |
| `_uYIQ-JI-1` | **Servicio de Idempotencia** (Component · Component) | `bm_servicioDeIdempotencia` Servicio de Idempotencia | component en vo_bffMovil | L3: componente de vo_bffMovil | — |
| `cfRa9Mfz-1` | **Publicador de Eventos** (Component · Component) | `bm_publicadorDeEventos` Publicador de Eventos | component en vo_bffMovil | L3: componente de vo_bffMovil | — |
| `cfRa9Mfz-4` | **Manejador de Subida** (Component · Component) | `bm_manejadorDeSubida` Manejador de Subida | component en vo_bffMovil | L3: componente de vo_bffMovil | — |
| `cfRa9Mfz-5` | **Proveedor de Delta** (Component · Component) | `bm_proveedorDeDelta` Proveedor de Delta | component en vo_bffMovil | L3: componente de vo_bffMovil | — |
| `h8SqaJqN-1` | **Apigee** (Software System · External Software System) | `apigee` ApiGee | softwareSystem | compartido (ApiGee, API Management, Apigee) | nombre: «Apigee», tipo: «Software System», tecnologia: «», descripcion: «Entrada vía Netskope/ZTNA» |
| `h8SqaJqN-2` | **Documentos (GCS)** (Contenedor externo · External Software System) | `vo_documentosGcs` Documentos (GCS) | container en volarte | compartido (Documentos (GCS)) | tipo: «Contenedor externo», tecnologia: «», descripcion: «Fuera de este contenedor» |
| `h8SqaJqN-3` | **Cola de mensajería** (Contenedor externo · External Software System) | `vo_colaDeMensajeria` Cola de mensajeria | container en volarte | compartido (Cola de mensajería) | nombre: «Cola de mensajería», tipo: «Contenedor externo», tecnologia: «», descripcion: «Pub/Sub (fuera de este contenedor)» |
| `h8SqaJqN-4` | **Svc: Operación** (Contenedor externo · External Software System) | `vo_svcOperacion` Svc: Operación | container en volarte | compartido (Svc: Operación) | tipo: «Contenedor externo», tecnologia: «», descripcion: «Fuera de este contenedor» |
| `-sql-ext-1` | **Cloud SQL** (Contenedor externo · External Software System) | `vo_cloudSqlPostgresql` Cloud SQL (PostgreSQL) | container en volarte | compartido (Cloud SQL, Cloud SQL / metadata) | nombre: «Cloud SQL», tipo: «Contenedor externo», tecnologia: «», descripcion: «Tablas: Sincronizacion (fuera de este contenedor)» |
| `cfRa9Mfz-2` | **Motor de Reconciliación** (Component · Component) | `bm_motorDeReconciliacion` Motor de Reconciliación | component en vo_bffMovil | L3: componente de vo_bffMovil | — |
| `80vgvwd1-4` | **Validador de Orden/Secuencia** (Component · Component) | `bm_validadorDeOrdenSecuencia` Validador de Orden/Secuencia | component en vo_bffMovil | L3: componente de vo_bffMovil | — |
| `80vgvwd1-5` | **Cliente Cloud SQL** (Component · Component) | `bm_clienteCloudSql` Cliente Cloud SQL | component en vo_bffMovil | L3: componente de vo_bffMovil | — |

## L3 · Pub-Sub → vista `L3_Pub_Sub`

| Draw.io id | Forma (tipo · clase) | Elemento de modelo | Tipo modelo | Regla | Texto de presentación |
|---|---|---|---|---|---|
| `h1s6TYu0-6` | **Dead Letter Topic** (Component · Component) | `ps_deadLetterTopic` Dead Letter Topic | component en vo_colaDeMensajeria | L3: componente de vo_colaDeMensajeria | — |
| `h1s6TYu0-7` | **Sub: comercial-sub** (Component · Component) | `ps_subComercialSub` Sub: comercial-sub | component en vo_colaDeMensajeria | L3: componente de vo_colaDeMensajeria | — |
| `h1s6TYu0-8` | **Topic: operacion-cerrada** (Component · Component) | `ps_topicOperacionCerrada` Topic: operacion-cerrada | component en vo_colaDeMensajeria | L3: componente de vo_colaDeMensajeria | — |
| `h1s6TYu0-9` | **Sub: gestor-documental-sub** (Component · Component) | `ps_subGestorDocumentalSub` Sub: gestor-documental-sub | component en vo_colaDeMensajeria | L3: componente de vo_colaDeMensajeria | — |
| `d9-BpX4p-1` | **Svc: Comercial** (Contenedor externo · External Software System) | `vo_svcComercial` Svc: Comercial | container en volarte | compartido (Svc: Comercial) | tipo: «Contenedor externo», tecnologia: «», descripcion: «Suscriptor» |
| `d9-BpX4p-2` | **BFF Móvil** (Contenedor externo · External Software System) | `vo_bffMovil` BFF Móvil | container en volarte | compartido (BFF Móvil) | tipo: «Contenedor externo», tecnologia: «», descripcion: «Publicador principal» |
| `d9-BpX4p-3` | **Gestor Documental** (Contenedor externo · External Software System) | `vo_gestorDocumental` Gestor Documental | container en volarte | compartido (Gestor Documental) | tipo: «Contenedor externo», tecnologia: «», descripcion: «Suscriptor» |
| `ps-bffw-1` | **BFF Web** (Contenedor externo · External Software System) | `vo_bffBackendVolarte` BFF — Backend Volarte | container en volarte | compartido (BFF Web) | nombre: «BFF Web», tipo: «Contenedor externo», tecnologia: «», descripcion: «Publicador — Servicio de Conciliación (revisión manual HU-050)» |
| `nc-topic-1` | **Topic: conciliacion-resuelta** (Component · Component) | `ps_topicConciliacionResuelta` Topic: conciliacion-resuelta | component en vo_colaDeMensajeria | L3: componente de vo_colaDeMensajeria | — |
| `-ops-ext-1` | **Svc: Operación** (Contenedor externo · External Software System) | `vo_svcOperacion` Svc: Operación | container en volarte | compartido (Svc: Operación) | tipo: «Contenedor externo», tecnologia: «», descripcion: «Suscriptor» |
| `xF7kTuUS-1` | **Sub: operacion-conciliacion-sub** (Component · Component) | `ps_subOperacionConciliacionSub` Sub: operacion-conciliacion-sub | component en vo_colaDeMensajeria | L3: componente de vo_colaDeMensajeria | — |

## L3 · Documentos GCS → vista `L3_Documentos_GCS`

| Draw.io id | Forma (tipo · clase) | Elemento de modelo | Tipo modelo | Regla | Texto de presentación |
|---|---|---|---|---|---|
| `gmQ7S9uW-1` | **Estructura de carpetas** (Component · Component) | `dg_estructuraDeCarpetas` Estructura de carpetas | component en vo_documentosGcs | L3: componente de vo_documentosGcs | — |
| `gmQ7S9uW-2` | **Política de ciclo de vida** (Component · Component) | `dg_politicaDeCicloDeVida` Política de ciclo de vida | component en vo_documentosGcs | L3: componente de vo_documentosGcs | — |
| `gmQ7S9uW-3` | **Versionado / WORM** (Component · Component) | `dg_versionadoWorm` Versionado / WORM | component en vo_documentosGcs | L3: componente de vo_documentosGcs | — |
| `gmQ7S9uW-4` | **IAM del bucket** (Component · Component) | `dg_iamDelBucket` IAM del bucket | component en vo_documentosGcs | L3: componente de vo_documentosGcs | — |
| `gmQ7S9uW-5` | **Cifrado en reposo** (Component · Component) | `dg_cifradoEnReposo` Cifrado en reposo | component en vo_documentosGcs | L3: componente de vo_documentosGcs | — |
| `_nQTeCRp-2` | **Gestor Documental** (Contenedor externo · External Software System) | `vo_gestorDocumental` Gestor Documental | container en volarte | compartido (Gestor Documental) | tipo: «Contenedor externo», tecnologia: «», descripcion: «Único escritor (SA con permiso write)» |

## L3 · Svc Usuarios Auth → vista `L3_Svc_Usuarios_Auth`

| Draw.io id | Forma (tipo · clase) | Elemento de modelo | Tipo modelo | Regla | Texto de presentación |
|---|---|---|---|---|---|
| `JnTnU6Eb-1` | **API Router** (Component · Component) | `su_apiRouter` API Router | component en vo_svcUsuariosAuth | L3: componente de vo_svcUsuariosAuth | — |
| `JnTnU6Eb-2` | **Resolver GroupToRoleMapping** (Component · Component) | `su_resolverGrouptorolemapping` Resolver GroupToRoleMapping | component en vo_svcUsuariosAuth | L3: componente de vo_svcUsuariosAuth | — |
| `JnTnU6Eb-3` | **Adaptador de sincronización Entra ID** (Component · Component) | `su_adaptadorDeSincronizacionEntraId` Adaptador de sincronización Entra ID | component en vo_svcUsuariosAuth | L3: componente de vo_svcUsuariosAuth | — |
| `JnTnU6Eb-4` | **Invalidador de Cache** (Component · Component) | `su_invalidadorDeCache` Invalidador de Cache | component en vo_svcUsuariosAuth | L3: componente de vo_svcUsuariosAuth | — |
| `JnTnU6Eb-5` | **Cliente Cloud SQL** (Component · Component) | `su_clienteCloudSql` Cliente Cloud SQL | component en vo_svcUsuariosAuth | L3: componente de vo_svcUsuariosAuth | — |
| `JnTnU6Eb-6` | **Auditor** (Component · Component) | `su_auditor` Auditor | component en vo_svcUsuariosAuth | L3: componente de vo_svcUsuariosAuth | — |
| `ZbYl4sQt-1` | **BFF Web / BFF Móvil** (Contenedores externos · External Software System) | `ce_bffWebBffMovil` BFF Web / BFF Móvil | custom | compartido (BFF Web / BFF Móvil) | — |
| `ZbYl4sQt-2` | **Cloud SQL** (Contenedor externo · External Software System) | `vo_cloudSqlPostgresql` Cloud SQL (PostgreSQL) | container en volarte | compartido (Cloud SQL, Cloud SQL / metadata) | nombre: «Cloud SQL», tipo: «Contenedor externo», tecnologia: «», descripcion: «Persistencia» |
| `ZbYl4sQt-3` | **Memorystore** (Contenedor externo · External Software System) | `vo_memorystore` Memorystore | container en volarte | compartido (Memorystore) | tipo: «Contenedor externo», tecnologia: «», descripcion: «Invalidación de cache» |
| `ZbYl4sQt-4` | **EntraID** (Sistema externo · External Software System) | `entraId` EntraID / CIAM | softwareSystem | compartido (EntraID / CIAM, EntraID / Azure AD, EntraID) | nombre: «EntraID», tipo: «Sistema externo», descripcion: «Fuente de identidad/grupos» |

## L3 · Gestor Documental → vista `L3_Gestor_Documental`

| Draw.io id | Forma (tipo · clase) | Elemento de modelo | Tipo modelo | Regla | Texto de presentación |
|---|---|---|---|---|---|
| `a6xH4-3E-1` | **Asignador de Numeración** (Component · Component) | `gd_asignadorDeNumeracion` Asignador de Numeración | component en vo_gestorDocumental | L3: componente de vo_gestorDocumental | — |
| `j9qjwHhb-1` | **Suscriptor Pub/Sub** (Component · Component) | `gd_suscriptorPubSub` Suscriptor Pub/Sub | component en vo_gestorDocumental | L3: componente de vo_gestorDocumental | — |
| `j9qjwHhb-3` | **Generador de Documento** (Component · Component) | `gd_generadorDeDocumento` Generador de Documento | component en vo_gestorDocumental | L3: componente de vo_gestorDocumental | — |
| `j9qjwHhb-4` | **Motor de Plantillas** (Component · Component) | `gd_motorDePlantillas` Motor de Plantillas | component en vo_gestorDocumental | L3: componente de vo_gestorDocumental | — |
| `j9qjwHhb-5` | **Publicador** (Component · Component) | `gd_publicador` Publicador | component en vo_gestorDocumental | L3: componente de vo_gestorDocumental | — |
| `4Ry1vtSA-1` | **Cliente GCS** (Component · Component) | `gd_clienteGcs` Cliente GCS | component en vo_gestorDocumental | L3: componente de vo_gestorDocumental | — |
| `IkPloGag-1` | **Cola de mensajería** (Contenedor externo · External Software System) | `vo_colaDeMensajeria` Cola de mensajeria | container en volarte | compartido (Cola de mensajería) | nombre: «Cola de mensajería», tipo: «Contenedor externo», tecnologia: «», descripcion: «Suscripción: operacion-cerrada» |
| `IkPloGag-2` | **Cloud SQL / metadata** (Contenedor externo · External Software System) | `vo_cloudSqlPostgresql` Cloud SQL (PostgreSQL) | container en volarte | compartido (Cloud SQL, Cloud SQL / metadata) | nombre: «Cloud SQL / metadata», tipo: «Contenedor externo», tecnologia: «», descripcion: «Numeración secuencial» |
| `IkPloGag-3` | **Documentos (GCS)** (Contenedor externo · External Software System) | `vo_documentosGcs` Documentos (GCS) | container en volarte | compartido (Documentos (GCS)) | tipo: «Contenedor externo», tecnologia: «», descripcion: «Almacenamiento final» |

## L3 · Svc Operacion → vista `L3_Svc_Operacion`

| Draw.io id | Forma (tipo · clase) | Elemento de modelo | Tipo modelo | Regla | Texto de presentación |
|---|---|---|---|---|---|
| `T1uQHbZl-1` | **API Router** (Component · Component) | `so_apiRouter` API Router | component en vo_svcOperacion | L3: componente de vo_svcOperacion | — |
| `T1uQHbZl-2` | **Rastreador de Posición** (Component · Component) | `so_rastreadorDePosicion` Rastreador de Posición | component en vo_svcOperacion | L3: componente de vo_svcOperacion | — |
| `T1uQHbZl-3` | **Inventario de Calidad** (Component · Component) | `so_inventarioDeCalidad` Inventario de Calidad | component en vo_svcOperacion | L3: componente de vo_svcOperacion | — |
| `T1uQHbZl-4` | **Cliente de base de datos** (Component · Component) | `so_clienteDeBaseDeDatos` Cliente de base de datos | component en vo_svcOperacion | L3: componente de vo_svcOperacion | — |
| `T1uQHbZl-5` | **Gestor de Turnos** (Component · Component) | `so_gestorDeTurnos` Gestor de Turnos | component en vo_svcOperacion | L3: componente de vo_svcOperacion | — |
| `T1uQHbZl-7` | **Suscriptor de Tracking** (Component · Component) | `so_suscriptorDeTracking` Suscriptor de Tracking | component en vo_svcOperacion | L3: componente de vo_svcOperacion | — |
| `JYZK3LzI-1` | **BFF Web / BFF Móvil** (Contenedores externos · External Software System) | `ce_bffWebBffMovil` BFF Web / BFF Móvil | custom | compartido (BFF Web / BFF Móvil) | — |
| `JYZK3LzI-2` | **Cola de mensajería** (Contenedor externo · External Software System) | `vo_colaDeMensajeria` Cola de mensajeria | container en volarte | compartido (Cola de mensajería) | nombre: «Cola de mensajería», tipo: «Contenedor externo», tecnologia: «», descripcion: «Suscripción: tracking-eventos (si aplica)» |
| `JYZK3LzI-3` | **Svc: Datos Maestros** (Contenedor externo · External Software System) | `vo_svcDatosMaestros` Svc: Datos Maestros | container en volarte | compartido (Svc: Datos Maestros) | tipo: «Contenedor externo», tecnologia: «», descripcion: «Geocerca (S02/HU-145)» |

## L3 · Svc Comercial → vista `L3_Svc_Comercial`

| Draw.io id | Forma (tipo · clase) | Elemento de modelo | Tipo modelo | Regla | Texto de presentación |
|---|---|---|---|---|---|
| `14QhnpdS-1` | **API Router** (Component · Component) | `sc_apiRouter` API Router | component en vo_svcComercial | L3: componente de vo_svcComercial | — |
| `sy6hbBwl-1` | **Cliente de base de datos** (Component · Component) | `sc_clienteDeBaseDeDatos` Cliente de base de datos | component en vo_svcComercial | L3: componente de vo_svcComercial | — |
| `Wk_l2KEW-1` | **Suscriptor operacion-cerrada** (Component · Component) | `sc_suscriptorOperacionCerrada` Suscriptor operacion-cerrada | component en vo_svcComercial | L3: componente de vo_svcComercial | — |
| `Wk_l2KEW-2` | **Servicio de Crédito Disponible** (Component · Component) | `sc_servicioDeCreditoDisponible` Servicio de Crédito Disponible | component en vo_svcComercial | L3: componente de vo_svcComercial | — |
| `Wk_l2KEW-3` | **Motor de Elegibilidad** (Component · Component) | `sc_motorDeElegibilidad` Motor de Elegibilidad | component en vo_svcComercial | L3: componente de vo_svcComercial | — |
| `Wk_l2KEW-4` | **Resolutor PriceProvider** (Component · Component) | `sc_resolutorPriceprovider` Resolutor PriceProvider | component en vo_svcComercial | L3: componente de vo_svcComercial | — |
| `kRIC20Ai-1` | **PriceProvider externo** (Sistema externo · External Software System) | `ss_priceproviderExterno` PriceProvider externo | softwareSystem | L3: sistema externo | — |
| `FX2f4dkP-1` | **BFF Web** (Contenedores externos · External Software System) | `vo_bffBackendVolarte` BFF — Backend Volarte | container en volarte | compartido (BFF Web) | nombre: «BFF Web», tipo: «Contenedores externos», tecnologia: «», descripcion: «Consumidor Principal» |
| `FX2f4dkP-2` | **Cola de mensajería** (Contenedor externo · External Software System) | `vo_colaDeMensajeria` Cola de mensajeria | container en volarte | compartido (Cola de mensajería) | nombre: «Cola de mensajería», tipo: «Contenedor externo», tecnologia: «», descripcion: «Suscripción: operacion-cerrada» |

