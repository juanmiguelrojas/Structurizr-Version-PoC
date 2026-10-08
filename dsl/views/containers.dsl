# ---------------------------------------------------------------------------
# L2 · Container Diagram
# ---------------------------------------------------------------------------

container volarte "L2_Containers" "L2 · Contenedores de Volarte en GCP (terpel-org-col-volarte) con borde, API Management y seguridad transversal." {
    include *
    exclude hubPortal dynatrace kms "relationship.tag==Logical"
    autoLayout lr 250 120
}

container volarte "L2_Containers_Mensajeria_Datos" "L2 · Vista enfocada en flujos asíncronos (Pub/Sub) y persistencia." {
    include bffWeb bffMobile pubsub svcComercial svcOperacion gestorDocumental cloudSql memorystore documentosGcs datalake
    autoLayout lr 250 120
}
