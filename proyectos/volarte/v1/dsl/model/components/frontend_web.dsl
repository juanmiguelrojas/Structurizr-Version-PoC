# L3 · Frontend Web  (contenedor: frontendWeb)
fwShell = component "App Shell / Router" "Layout, navbar y enrutamiento client-side. Punto de entrada único de la SPA." "React Router" "WebComponent"
fwAuth = component "Módulo de Autenticación" "Flujo OAuth2 Authorization Code + PKCE. Token en memoria (no localStorage)." "MSAL.js" "WebComponent,Security"
fwViews = component "Vistas por Rol" "Módulos cargados con React.lazy() según rol: comercial, supervisión, admin. Incluye la bandeja de conciliación PENDING_REVIEW (HU-050)." "React (code-splitting)" "WebComponent"
fwApiClient = component "Cliente API" "Inyecta el Bearer token en cada request. Reintentos con backoff." "Fetch / Axios" "WebComponent"
fwQueryCache = component "Cache de Estado Servidor" "Cache y revalidación de datos de servidor. Evita refetch innecesario." "React Query" "WebComponent"
fwErrorBoundary = component "Error Boundary / Telemetría" "Captura errores de render y envía eventos de uso/error (RUM)." "React ErrorBoundary + Dynatrace RUM" "WebComponent,Observability"

fwShell -> fwAuth "Usa" "Llamada in-process (TypeScript)"
fwShell -> fwViews "Autenticado → enruta a" "Llamada in-process (TypeScript)"
fwViews -> fwApiClient "Solicita datos" "Llamada in-process (TypeScript)"
fwApiClient -> fwQueryCache "Cachea respuestas" "Llamada in-process (TypeScript)"
fwViews -> fwErrorBoundary "Reporta errores" "Llamada in-process (TypeScript)"
