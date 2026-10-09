# L3 · Svc Comercial  (contenedor: svcComercial)
scRouter = component "API Router" "Endpoints de elegibilidad, precio y crédito." "FastAPI" "BackendComponent"
scEligibility = component "Motor de Elegibilidad" "Cliente activo, acuerdo vigente, negociación existente (S02 → S04, HU-128)." "Python — S04/HU-128" "BackendComponent"
scPrice = component "Resolutor PriceProvider" "No inventa fuente de precio; delega a la autoridad cuando se confirme (P-072 PENDING)." "Python — P-072 PENDING" "BackendComponent,Pending"
scCredit = component "Servicio de Crédito Disponible" "Calcula crédito disponible según saldo y órdenes abiertas." "Python — S04" "BackendComponent"
scClosedSub = component "Suscriptor operacion-cerrada" "Actualiza saldo/crédito tras cada cierre de operación." "Pub/Sub push endpoint" "BackendComponent"
scDbClient = component "Cliente de Base de Datos" "Estado comercial y persistencia." "SQLAlchemy" "BackendComponent"

scRouter -> scEligibility "Enruta" "Llamada in-process (Python)"
scRouter -> scPrice "Enruta" "Llamada in-process (Python)"
scRouter -> scCredit "Enruta" "Llamada in-process (Python)"
scClosedSub -> scCredit "Actualiza saldo" "Llamada in-process (Python)"
scCredit -> scDbClient "Persiste" "Llamada in-process (Python)"
scEligibility -> scDbClient "Consulta" "Llamada in-process (Python)"
