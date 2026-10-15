# Prueba de concepto · draw.io MCP + ArchiMate 3.2 + C4

Diagrama de despliegue de Volarte en Google Cloud, creado con el MCP de draw.io y guardado como
archivo `.drawio` **editable** en el repositorio. Toma como referencia el estilo de `GKE_2.drawio`
(página *Deployment v7-Final*): marco C4 con bloque de título, nodos ArchiMate con componentes
anidados, proyectos GCP como contenedores y relaciones C4 con descripción.

| Archivo | Qué es |
|---|---|
| `generar_despliegue.py` | Genera el diagrama de forma determinista (sin IA) |
| `despliegue.mxgraph.xml` | El `mxGraphModel` exacto que se envía a `create_diagram` del MCP |
| `Volarte_Despliegue_GCP_ArchiMate32.drawio` | El archivo editable (abrir con draw.io Desktop, app.diagrams.net o la extensión de VS Code) |

```bash
python3 ejemplos/drawio-mcp/generar_despliegue.py   # regenera el .drawio y el XML para el MCP
```

## Notación

| Elemento | ArchiMate 3.2 (librería `archimate3`) | Color |
|---|---|---|
| Personas | Business Actor (`appType=actor`) | `#ffff99` |
| Servicios Volarte, Apigee proxy, App móvil | Application Component (`appType=comp`) | `#99ffff` |
| BD, caché, documentos | Data Object (`appType=passive`) | `#99ffff` |
| Cloud Run, Cloud SQL, Memorystore, GCS, Apigee, Pub/Sub, Cloudflare, Firewall, Entra ID | Node (`appType=node`) | `#AFFFAF` |
| ILB, ELB, ZTNA | Communication Network (`appType=netw`) | `#AFFFAF` |
| Cola, KMS, Secret Manager, OTel | System Software (`appType=sysSw`) | `#AFFFAF` |
| Topics + DLQ | Artifact (`appType=artifact`) | `#AFFFAF` |
| Seguridad, Observabilidad | Grouping (`appType=grouping`) | — |
| Marco y conectores | C4 `ContainerScopeBoundary` y `Relationship` con `c4Description` | `#828282` |

## Trazabilidad y validación

- 29 formas llevan `structurizrId` apuntando a elementos de `proyectos/volarte/v3` (verificado: 0 inexistentes).
- Todas llevan `archimateType`, para no depender del estilo al releer el archivo.
- Solo usa `mxgraph.archimate3.*` (ArchiMate 3.2), sin imágenes en base64 y sin comprimir (diffable en git).

## Diferencias detectadas en `GKE_2.drawio` (14 páginas)

- Mezcla la librería antigua **`mxgraph.archimate.*`** (ArchiMate 2.x: 31 formas en *Deployment v7-Final*)
  con **`mxgraph.archimate3.*`** (21 formas). Para ArchiMate 3.2 debería usarse solo `archimate3`.
- Usa los colores por defecto de draw.io con variaciones (`#99ff99` en la librería antigua y `#AFFFAF` en la nueva
  para la capa de tecnología).
- Las páginas *Context* y *Container* son C4 (`c4Type`), pero con elipses y cajas genéricas en vez de las formas C4.
- Ninguna forma tiene identificador de modelo, así que hoy no se puede trazar contra Structurizr.

## Límites del MCP observados

- `create_diagram` muestra el diagrama y devuelve el XML y un enlace a app.diagrams.net; **no guarda el archivo**.
  El `.drawio` lo escribe el script (o se guarda desde el editor).
- Una página por llamada; las rutas que calcula `libavoid` no vuelven en el XML (draw.io las recalcula al abrir).
- Normaliza el contenedor de cada conector al contenedor común más interno; el generador aplica la misma regla.
