# ---------------------------------------------------------------------------
# L0 · Vista Global de Integración  /  L1 · System Context
# ---------------------------------------------------------------------------

systemLandscape "L0_Vista_Global" "L0 · Referencia / Vista Global de Integración: arquitectura transversal compartida por Volarte y el ecosistema de portales." {
    include *
    autoLayout lr 300 150
}

systemContext volarte "L1_System_Context" "L1 · System Context de Volarte: actores, proveedores de identidad, datalake y capacidades transversales." {
    include *
    exclude "element.tag==Infrastructure" "element.tag==Security" otelCollector cloudLogging cloudMonitoring
    autoLayout tb 300 200
}
