# L3 · Documentos GCS  (contenedor: documentosGcs)
gcsFolders = component "Estructura de Carpetas" "Organización por año, mes e ID de operación: gs://.../{anio}/{mes}/{op_id}." "GCS object prefixes" "StorageComponent"
gcsLifecycle = component "Política de Ciclo de Vida" "Transición a Nearline/Coldline según antigüedad. Retención definida por política vigente." "GCS Lifecycle Rules" "StorageComponent"
gcsWorm = component "Versionado / WORM" "Inmutabilidad: un objeto nunca se sobrescribe." "GCS Object Versioning + Retention Lock" "StorageComponent"
gcsIam = component "IAM del Bucket" "Write: SA Gestor Documental (y BFF Móvil para media). Read: signed URLs temporales." "Service Account bindings" "StorageComponent,Security"
gcsCmek = component "Cifrado en Reposo" "Cada objeto cifrado con llave gestionada por Terpel (no por Google)." "CMEK (Cloud KMS)" "StorageComponent,Security"

gcsFolders -> gcsLifecycle "Organiza" "Configuración de bucket GCS"
gcsFolders -> gcsWorm "Aplica" "Configuración de bucket GCS"
gcsFolders -> gcsIam "Controla acceso" "Configuración de bucket GCS"
gcsIam -> gcsCmek "Cifra" "Configuración de bucket GCS"
