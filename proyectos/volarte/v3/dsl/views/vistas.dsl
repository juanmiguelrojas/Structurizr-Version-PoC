# =============================================================================
# GENERADO por scripts/drawio2structurizr.py — una vista por página del Draw.io.
# Sin autoLayout: la posición de cada elemento viene de dsl/layout/<vista>.json.
# Cada vista muestra solo las relaciones dibujadas en su página (tag pagina:<vista>).
# =============================================================================

container portal "L0_Referencia" "Página 'L0 · Referencia' del Draw.io: arquitectura de referencia del HUB / Portal y plataforma transversal." {
    title "L0 · Referencia — Vista global de integración"
    include po_search po_storage po_database po_cloudSqlPostgresql po_memorystoreRedis po_svcWiki
    include po_svcUsuariosAuth ss_portalesExternosFuturos po_backendHubWeb po_hubFront entraId ztna
    include ss_globalLoadBalancer ss_identityAwareProxyIap po_cloudMonitoring po_cloudLogging ss_cloudKms ss_secretManager
    include cloudflare po_portalesRemoteModulo po_federationBridge ss_powerBiService po_svcPowerBiProxy po_backendHubWebMovil
    include datalake po_svcAnalitica apigee firewall ss_cloudDataFusion ss_salesforce
    include ss_sapErp ss_zenput ss_gurusoft po_svcNotificacion po_svcPagos po_colaDeMensajeria
    include po_memorystoreRedisFree ilbTransversal proxyApigee pe_empleadoInterno po_appMovil pe_usuarioExterno
    include ss_dynatraceTenantTerpel po_otelCollector
    exclude "relationship.tag!=pagina:L0_Referencia"
    properties {
        "drawio.pagina" "L0 · Referencia"
        "aac.layout" "layout/L0_Referencia.json"
    }
}

systemContext portal "L1_Context" "Página 'L1 · Context' del Draw.io." {
    title "L1 · Context — Diagrama de contexto"
    include pe_adminDevTeam ss_googleCloudPlatform ss_sistemasExternosFuturos portal entraId ss_webappsExternosFuturos
    include pe_usuarioExterno ss_ciam datalake pe_empleadoInterno ce_capacidadesTransversales
    exclude "relationship.tag!=pagina:L1_Context"
    properties {
        "drawio.pagina" "L1 · Context"
        "aac.layout" "layout/L1_Context.json"
    }
}

container volarte "L2_Container" "Página 'L2 · Container' del Draw.io." {
    title "L2 · Container — Diagrama de contenedores"
    include apigee ss_externalRegionalLoadBalancer firewall ilbTransversal proxyApigee vo_frontendWeb
    include vo_memorystore vo_bffBackendVolarte vo_internalLoadBalancer vo_cloudSqlPostgresql vo_svcUsuariosAuth vo_cloudKms
    include vo_secretManager vo_gestorDocumental vo_documentosGcs vo_svcDatosMaestros vo_svcComercial vo_svcOperacion
    include vo_svcAsignacionOptimizacion vo_colaDeMensajeria pe_empleadoInterno pe_usuarioExterno cloudflare entraId
    include pe_operarioDeEquipoAbastecedor vo_appMovil ztna vo_bffMovil
    exclude "relationship.tag!=pagina:L2_Container"
    properties {
        "drawio.pagina" "L2 · Container"
        "aac.layout" "layout/L2_Container.json"
    }
}

component vo_frontendWeb "L3_Frontend_Web" "Página 'L3 · Frontend Web' del Draw.io." {
    title "L3 · Frontend Web — Diagrama de componentes"
    include fw_appShellRouter fw_vistasPorRol fw_clienteApi fw_cacheDeEstadoServidor fw_errorBoundaryTelemetria fw_moduloDeAutenticacion
    include entraId apigee
    exclude "relationship.tag!=pagina:L3_Frontend_Web"
    properties {
        "drawio.pagina" "L3 · Frontend Web"
        "aac.layout" "layout/L3_Frontend_Web.json"
    }
}

component vo_appMovil "L3_App_Movil" "Página 'L3 · App Movil' del Draw.io." {
    title "L3 · App Móvil — Diagrama de componentes"
    include am_moduloDeAutenticacion am_navegacion am_baseDeDatosLocal am_motorDeSincronizacion am_clienteApi am_capturaDeEvidencia
    include am_disparadorDeSync vo_bffMovil entraId am_netskopeClientZtna am_cifradoLocalEnReposo am_gestorDeEstadosDeSincronizacion
    include am_componentName
    exclude "relationship.tag!=pagina:L3_App_Movil"
    properties {
        "drawio.pagina" "L3 · App Movil"
        "aac.layout" "layout/L3_App_Movil.json"
    }
}

component vo_bffBackendVolarte "L3_BFF_Web" "Página 'L3 · BFF Web' del Draw.io." {
    title "L3 · BFF Web — Diagrama de componentes"
    include bw_apiRouterControllers bw_middlewareDeAutenticacion bw_servicioDeAutorizacion bw_orquestadorDeDominio bw_clientesDeServicios bw_clienteDeSecretos
    include bw_clienteDeCache ce_serviciosDeDominio apigee
    exclude "relationship.tag!=pagina:L3_BFF_Web"
    properties {
        "drawio.pagina" "L3 · BFF Web"
        "aac.layout" "layout/L3_BFF_Web.json"
    }
}

component vo_bffMovil "L3_BFF_Movil" "Página 'L3 · BFF Movil' del Draw.io." {
    title "L3 · BFF Móvil — Diagrama de componentes"
    include bm_servicioDeAutorizacion bm_middlewareDeAutenticacion bm_apiRouterControllers bm_servicioDeIdempotencia bm_publicadorDeEventos bm_manejadorDeSubida
    include bm_proveedorDeDelta apigee vo_documentosGcs vo_colaDeMensajeria vo_svcOperacion vo_cloudSqlPostgresql
    include bm_motorDeReconciliacion bm_validadorDeOrdenSecuencia bm_clienteCloudSql
    exclude "relationship.tag!=pagina:L3_BFF_Movil"
    properties {
        "drawio.pagina" "L3 · BFF Movil"
        "aac.layout" "layout/L3_BFF_Movil.json"
    }
}

component vo_colaDeMensajeria "L3_Pub_Sub" "Página 'L3 · Pub-Sub' del Draw.io." {
    title "L3 · Pub-Sub — Diagrama de componentes"
    include ps_deadLetterTopic ps_subComercialSub ps_topicOperacionCerrada ps_subGestorDocumentalSub vo_svcComercial vo_bffMovil
    include vo_gestorDocumental vo_bffBackendVolarte ps_topicConciliacionResuelta vo_svcOperacion ps_subOperacionConciliacionSub
    exclude "relationship.tag!=pagina:L3_Pub_Sub"
    properties {
        "drawio.pagina" "L3 · Pub-Sub"
        "aac.layout" "layout/L3_Pub_Sub.json"
    }
}

component vo_documentosGcs "L3_Documentos_GCS" "Página 'L3 · Documentos GCS' del Draw.io." {
    title "L3 · Documentos GCS — Diagrama de componentes"
    include dg_estructuraDeCarpetas dg_politicaDeCicloDeVida dg_versionadoWorm dg_iamDelBucket dg_cifradoEnReposo vo_gestorDocumental
    exclude "relationship.tag!=pagina:L3_Documentos_GCS"
    properties {
        "drawio.pagina" "L3 · Documentos GCS"
        "aac.layout" "layout/L3_Documentos_GCS.json"
    }
}

component vo_svcUsuariosAuth "L3_Svc_Usuarios_Auth" "Página 'L3 · Svc Usuarios Auth' del Draw.io." {
    title "L3 · Svc Usuarios / Auth — Diagrama de componentes"
    include su_apiRouter su_resolverGrouptorolemapping su_adaptadorDeSincronizacionEntraId su_invalidadorDeCache su_clienteCloudSql su_auditor
    include ce_bffWebBffMovil vo_cloudSqlPostgresql vo_memorystore entraId
    exclude "relationship.tag!=pagina:L3_Svc_Usuarios_Auth"
    properties {
        "drawio.pagina" "L3 · Svc Usuarios Auth"
        "aac.layout" "layout/L3_Svc_Usuarios_Auth.json"
    }
}

component vo_gestorDocumental "L3_Gestor_Documental" "Página 'L3 · Gestor Documental' del Draw.io." {
    title "L3 · Gestor Documental — Diagrama de componentes"
    include gd_asignadorDeNumeracion gd_suscriptorPubSub gd_generadorDeDocumento gd_motorDePlantillas gd_publicador gd_clienteGcs
    include vo_colaDeMensajeria vo_cloudSqlPostgresql vo_documentosGcs
    exclude "relationship.tag!=pagina:L3_Gestor_Documental"
    properties {
        "drawio.pagina" "L3 · Gestor Documental"
        "aac.layout" "layout/L3_Gestor_Documental.json"
    }
}

component vo_svcOperacion "L3_Svc_Operacion" "Página 'L3 · Svc Operacion' del Draw.io." {
    title "L3 · Svc Operación — Diagrama de componentes"
    include so_apiRouter so_rastreadorDePosicion so_inventarioDeCalidad so_clienteDeBaseDeDatos so_gestorDeTurnos so_suscriptorDeTracking
    include ce_bffWebBffMovil vo_colaDeMensajeria vo_svcDatosMaestros
    exclude "relationship.tag!=pagina:L3_Svc_Operacion"
    properties {
        "drawio.pagina" "L3 · Svc Operacion"
        "aac.layout" "layout/L3_Svc_Operacion.json"
    }
}

component vo_svcComercial "L3_Svc_Comercial" "Página 'L3 · Svc Comercial' del Draw.io." {
    title "L3 · Svc Comercial — Diagrama de componentes"
    include sc_apiRouter sc_clienteDeBaseDeDatos sc_suscriptorOperacionCerrada sc_servicioDeCreditoDisponible sc_motorDeElegibilidad sc_resolutorPriceprovider
    include ss_priceproviderExterno vo_bffBackendVolarte vo_colaDeMensajeria
    exclude "relationship.tag!=pagina:L3_Svc_Comercial"
    properties {
        "drawio.pagina" "L3 · Svc Comercial"
        "aac.layout" "layout/L3_Svc_Comercial.json"
    }
}
