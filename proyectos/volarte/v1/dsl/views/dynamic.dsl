# ---------------------------------------------------------------------------
# Vistas Dinámicas (flujos clave de negocio)
# ---------------------------------------------------------------------------

dynamic volarte "D1_Consulta_Web" "D1 · Empleado consulta información comercial desde la Web (SSO + Apigee + BFF Web)." {
    empleado -> frontendWeb "Abre Volarte en el navegador"
    frontendWeb -> entraId "Login SSO (Authorization Code + PKCE)"
    frontendWeb -> apigee "GET /comercial/elegibilidad con Bearer JWT"
    apigee -> intLb "Valida firma/issuer/audience y reenvía"
    intLb -> bffWeb "Enruta al BFF Web"
    bffWeb -> memorystore "Lee decisión de autorización cacheada"
    bffWeb -> svcComercial "Consulta elegibilidad / precio / crédito (IAM Invoker)"
    svcComercial -> cloudSql "Lee estado comercial"
    bffWeb -> otelCollector "Exporta traza distribuida"
    autoLayout lr
}

dynamic bffMobile "D2_Sync_Offline_HU050" "D2 · Sincronización offline de la App Móvil al reconectar (HU-050, idempotencia por UUID)." {
    mobileApp -> bmRouter "POST /sync (cola pendiente con UUID por acción)"
    bmRouter -> bmJwt "Valida token"
    bmJwt -> bmAuthz "Resuelve rol del operario"
    bmAuthz -> bmReconciler "Entrega lote para reconciliar"
    bmReconciler -> bmIdempotency "Descarta acciones ya procesadas"
    bmIdempotency -> memorystore "SETNX uuid"
    bmIdempotency -> bmSequencer "Ordena por timestamp de captura"
    bmSequencer -> bmReconciler "Secuencia validada"
    bmReconciler -> bmSqlClient "Persiste CONFIRMADO / PENDING_REVIEW"
    bmSqlClient -> cloudSql "INSERT offline_actions_log"
    bmReconciler -> bmUpload "Fotos / firma pendientes"
    bmUpload -> documentosGcs "Resumable upload"
    bmReconciler -> bmPublisher "Operación cerrada"
    bmPublisher -> pubsub "Publica operacion-cerrada / doc-publicacion"
    autoLayout lr
}

dynamic volarte "D3_Cierre_Operacion_HU055" "D3 · Cierre de operación: fan-out por Pub/Sub y publicación documental idempotente (HU-055)." {
    mobileApp -> bffMobile "Sincroniza cierre de operación"
    bffMobile -> pubsub "Publica operacion-cerrada"
    {
        pubsub -> gestorDocumental "Push gestor-documental-sub (retry + DLQ)"
        gestorDocumental -> cloudSql "Asigna numeración secuencial"
        gestorDocumental -> documentosGcs "Publica documento WORM (ID inmutable)"
    }
    {
        pubsub -> svcComercial "Push comercial-sub: actualiza saldo/crédito"
        svcComercial -> cloudSql "Persiste saldo"
    }
    {
        pubsub -> svcOperacion "Push operacion-conciliacion-sub"
        svcOperacion -> cloudSql "Actualiza tablas operacionales"
    }
    autoLayout lr
}

dynamic volarte "D4_Conciliacion_Supervisor_HU050" "D4 · Supervisor resuelve una operación PENDING_REVIEW desde la Web (HU-050)." {
    empleado -> frontendWeb "Abre bandeja PENDING_REVIEW"
    frontendWeb -> apigee "POST /conciliacion/{op_id} (confirmar | anular)"
    apigee -> intLb "Reenvía petición validada"
    intLb -> bffWeb "Enruta al BFF Web"
    bffWeb -> pubsub "Publica conciliacion-resuelta"
    pubsub -> svcOperacion "Push operacion-conciliacion-sub"
    svcOperacion -> cloudSql "Finaliza / anula la operación"
    autoLayout lr
}
