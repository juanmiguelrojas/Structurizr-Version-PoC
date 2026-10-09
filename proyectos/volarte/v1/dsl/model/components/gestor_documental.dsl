# L3 · Gestor Documental  (contenedor: gestorDocumental)
gdSubscriber = component "Suscriptor Pub/Sub" "Recibe el evento operacion-cerrada / doc-publicacion. Retry + DLQ." "FastAPI Push endpoint" "BackendComponent"
gdGenerator = component "Generador de Documento" "Ensambla contenido: partes, cantidades, firmas y datos de la operación." "Python — ex S07" "BackendComponent"
gdTemplates = component "Motor de Plantillas" "Renderiza el formato final según lo que el cliente requiera." "PDF / AIDX XML" "BackendComponent"
gdNumbering = component "Asignador de Numeración" "Numeración secuencial, única y auditable." "Python" "BackendComponent"
gdPublisher = component "Publicador" "Idempotente: un reintento no genera un segundo documento. Retorna ID inmutable." "Python — HU-055" "BackendComponent"
gdGcsClient = component "Cliente GCS" "Sube el documento final al bucket." "GCS Resumable Upload" "BackendComponent"

gdSubscriber -> gdGenerator "Genera" "Llamada in-process (Python)"
gdGenerator -> gdTemplates "Renderiza" "Llamada in-process (Python)"
gdGenerator -> gdNumbering "Asigna número" "Llamada in-process (Python)"
gdGenerator -> gdPublisher "Publica" "Llamada in-process (Python)"
gdPublisher -> gdGcsClient "Sube" "Llamada in-process (Python)"
