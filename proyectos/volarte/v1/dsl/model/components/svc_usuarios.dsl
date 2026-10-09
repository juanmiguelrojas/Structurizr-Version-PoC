# L3 · Svc Usuarios / Auth  (contenedor: svcUsuarios)
suRouter = component "API Router" "Endpoints /roles · /permissions · /mapping · /audit." "FastAPI" "BackendComponent"
suResolver = component "Resolver GroupToRoleMapping" "Deriva el rol efectivo desde grupo(s) de Entra ID. RN-007 / RN-008." "Python" "BackendComponent,Security"
suGraphAdapter = component "Adaptador de Sincronización Entra ID" "Consulta pertenencia a grupos cuando el claim 'groups' se trunca." "Microsoft Graph API SDK" "BackendComponent"
suCacheInvalidator = component "Invalidador de Cache" "Notifica a Redis cuando cambia un rol, sin esperar al TTL." "Python" "BackendComponent"
suSqlClient = component "Cliente Cloud SQL" "Acceso a datos de usuarios / roles / mapping." "SQLAlchemy" "BackendComponent"
suAuditor = component "Auditor" "Registra toda decisión de autorización, concedida o denegada." "Python" "BackendComponent,Security"

suRouter -> suResolver "Resuelve" "Llamada in-process (Python)"
suResolver -> suGraphAdapter "Consulta grupos" "Llamada in-process (Python)"
suResolver -> suAuditor "Registra decisión" "Llamada in-process (Python)"
suResolver -> suSqlClient "Persiste / consulta mapping" "Llamada in-process (Python)"
suAuditor -> suSqlClient "Persiste auditoría" "Llamada in-process (Python)"
suAuditor -> suCacheInvalidator "Invalida en cambio de rol" "Llamada in-process (Python)"
