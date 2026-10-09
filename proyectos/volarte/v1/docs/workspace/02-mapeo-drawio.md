## Trazabilidad Draw.io → Structurizr DSL

| Página Draw.io | Vista Structurizr | Archivo DSL |
|---|---|---|
| L0 · Referencia | `L0_Vista_Global` (System Landscape) | `model/systems.dsl`, `views/landscape_context.dsl` |
| L1 · Context | `L1_System_Context` | `model/people.dsl`, `views/landscape_context.dsl` |
| L2 · Container | `L2_Containers`, `L2_Containers_Mensajeria_Datos`, `DEP_Produccion_GCP` | `model/volarte_containers.dsl`, `model/deployment.dsl` |
| L3 · Frontend Web | `L3_Frontend_Web` | `model/components/frontend_web.dsl` |
| L3 · App Movil | `L3_App_Movil` | `model/components/mobile_app.dsl` |
| L3 · BFF Web | `L3_BFF_Web` | `model/components/bff_web.dsl` |
| L3 · BFF Movil | `L3_BFF_Movil`, `D2_Sync_Offline_HU050` | `model/components/bff_mobile.dsl` |
| L3 · Pub-Sub | `L3_PubSub_Mensajeria`, `D3_Cierre_Operacion_HU055` | `model/components/pubsub.dsl` |
| L3 · Documentos GCS | `L3_Documentos_GCS` | `model/components/documentos_gcs.dsl` |
| L3 · Svc Usuarios Auth | `L3_Svc_Usuarios_Auth` | `model/components/svc_usuarios.dsl` |
| L3 · Gestor Documental | `L3_Gestor_Documental` | `model/components/gestor_documental.dsl` |
| L3 · Svc Operacion | `L3_Svc_Operacion`, `D4_Conciliacion_Supervisor_HU050` | `model/components/svc_operacion.dsl` |
| L3 · Svc Comercial | `L3_Svc_Comercial`, `D1_Consulta_Web` | `model/components/svc_comercial.dsl` |
