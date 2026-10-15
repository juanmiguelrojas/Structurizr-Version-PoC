# Structurizr modela, draw.io presenta: propuesta de integración MCP

**Recomendación:** el MCP de draw.io debe entrar al ecosistema Architecture-as-Code como **asistente interactivo de autoría y revisión**, no como generador de diagramas en CI. Las tres razones son verificables. Primero, el MCP oficial solo *crea* diagramas: `create_diagram` devuelve el XML recibido y una URL de `app.diagrams.net`, y no escribe archivos, no exporta y no edita un `.drawio` existente (probado en esta sesión). Segundo, el repositorio ya decidió que **el DSL de Structurizr es la fuente de verdad** (ADR 0007, guía 06 §8). Tercero, el pipeline ya tiene casi todo lo que hace falta para un generador determinista de `.drawio`: las escenas de `c4_scene.py` traen geometría, estilo, waypoints y clase de leyenda por elemento. La arquitectura objetivo tiene entonces dos lazos. En el **lazo CI**, un nuevo `scripts/render-drawio.py` convierte workspace + escenas en un `.drawio` multipágina sin comprimir. Usa las librerías oficiales de draw.io (`c4`, `archimate3`, `gcp3`) con ids estables `sz-<id>`, el CLI de draw.io Desktop exporta SVG para las notaciones que `render-c4.mjs` no sabe dibujar, y el Agente Revisor gana reglas por notación y de deriva. En el **lazo interactivo**, el arquitecto usa el MCP (autoalojado o vía plugin local) para bocetar, buscar formas y revisar vistas, y todo lo que produce vuelve al repo por el importador y el PR habitual. Por notación, la propuesta es: C4 sobre la librería `c4`, cuya paleta coincide exactamente con la leyenda corporativa; ArchiMate **3.2** (no 4) mediante elementos custom del DSL; y Google Cloud con **`gcp3`** (stencils con nombre, diffables) como primera opción y `gcp2`/`gcpicons` (imágenes base64) solo por excepción aprobada. El roadmap tiene cinco fases. La primera entrega C4 → `.drawio` con fidelidad de ida y vuelta (round-trip) R9, y la vista de despliegue GCP que v3 eliminó (REV-12) es el primer caso de negocio nuevo.

> **Convención de evidencia.** Cada afirmación relevante lleva una marca. **[V]** significa verificado en esta sesión con las herramientas `mcp__draw_io__*` (2026-10-15, `_buildId 3398377@2026-10-13`). **[R]** significa lectura estática del repositorio en `main @ 157d1a2`; el build no se ejecutó. **[F]** significa fuente externa citada; si dice *snippet*, la fuente solo se vio vía resumen de búsqueda. **[I]** es inferencia o propuesta de este informe.

## El MCP oficial crea vistas, pero no gestiona archivos

El repositorio oficial `jgraph/drawio-mcp` (Apache-2.0) ofrece cuatro modos de entrega: un MCP App Server (alojado en `https://mcp.draw.io/mcp` o autoalojable con Docker `jgraph/drawio-mcp`), un MCP Tool Server `@drawio/mcp` por stdio, un **plugin/skill** para Claude Code, Codex y Copilot, e instrucciones de proyecto **[F]** ([jgraph/drawio-mcp](https://github.com/jgraph/drawio-mcp)). **Solo el plugin escribe un `.drawio` en disco y exporta PNG/SVG/PDF**, y lo hace invocando el CLI de draw.io Desktop (`drawio -x -f <fmt> -e -b 10 -o <out> <in>`, y también `--layout` con ELK o libavoid) **[F]** ([SKILL.md](https://raw.githubusercontent.com/jgraph/drawio-mcp/main/plugins/claude-code/skills/drawio/SKILL.md)). Ninguna variante oficial abre ni modifica un diagrama existente como herramienta MCP.

La prueba en esta sesión confirmó que las herramientas disponibles son las del App Server: `create_diagram`, `search_shapes` y `get_drawio_reference` **[V]**. Se envió a `create_diagram` una persona `mxgraph.c4.person2`, un contenedor C4 envuelto en `<object>` con atributos `c4Type`, `structurizrId` y `tags`, un icono de Cloud Run y dos conectores con `routing: "libavoid"`. La herramienta **devolvió el XML de entrada sin cambios** y una URL `https://app.diagrams.net/?pv=0&grid=0#R<deflate+base64>`. No escribió archivo, no exportó y no devolvió los puntos de libavoid, porque el enrutamiento ocurre en el visor del cliente. Sí **preservó los atributos personalizados**, que es el hallazgo clave para la trazabilidad. Tampoco validó nada más allá del XML bien formado: aceptó un estilo de C4 que su propio índice no conoce. La referencia oficial fija un esqueleto `<mxGraphModel>` de una sola página por llamada, prohíbe comentarios XML, propone una rejilla rígida y ofrece `postLayout: "elk"` o `routing: "libavoid"` como alternativas excluyentes **[V]**.

`search_shapes` tiene tres huecos que afectan directamente a este proyecto **[V]**. **No indexa la librería C4**: "c4 person" devuelve un actor UML, una persona de Cisco y un falso positivo `mxgraph.aws4.c4_instance`. **No devolvió ningún stencil `mxgraph.gcp3.*`**. Y los productos GCP centrales (Cloud Run, Cloud SQL, Pub/Sub, Apigee) llegan como `shape=image` con SVG en base64. En cambio, ArchiMate sí aparece bien indexado (`mxgraph.archimate3.application;appType=comp;archiType=square`). La consecuencia de diseño es clara: **el catálogo de formas permitidas debe vivir en `estandares/` y no depender del buscador del MCP**.

En residencia de datos hay que distinguir variantes. El App Server alojado **recibe el contenido del diagrama**. Las variantes autoalojadas, el Tool Server y el plugin lo mantienen local, pero siguen cargando el visor desde `app.diagrams.net`/`viewer.diagrams.net` y consultando `icons.diagrams.net` al buscar formas, salvo que se configure `DRAWIO_ICON_SERVICE_URL=off` **[F]** ([jgraph/drawio-mcp](https://github.com/jgraph/drawio-mcp)). En cualquier caso, el proveedor del LLM ve todo. Para editar archivos existentes, la opción comunitaria más completa es `lgazo/drawio-mcp-server` (MIT, v2.3.0), con unas 30 herramientas, entre ellas `import-diagram`, `export-diagram` y `save-document`. Requiere un editor draw.io en ejecución, lo que la hace poco práctica en CI **[F]** ([lgazo/drawio-mcp-server](https://github.com/lgazo/drawio-mcp-server); [TOOLS.md](https://raw.githubusercontent.com/lgazo/drawio-mcp-server/main/TOOLS.md)).

Del lado de Structurizr, **no existe exportador oficial a draw.io**. Los exportadores cubren PlantUML, C4-PlantUML, Mermaid, DOT, WebSequenceDiagrams e Ilograph **[F]** ([Structurizr CLI export](https://docs.structurizr.com/cli/export), *snippet*). El CLI independiente está en deprecación a favor del repositorio consolidado `structurizr/structurizr`, que incluye un módulo `structurizr-mcp` **[F]** ([structurizr/structurizr](https://github.com/structurizr/structurizr)). El repo fija hoy la versión `2025.05.28` **[R]** ([aac-build.sh](../scripts/aac-build.sh)). Por último, **nada en el repositorio produce `.drawio`**. El flujo actual es estrictamente draw.io → modelo: `drawio_inventory.py` solo lee, y los `*.drawio.json` de `c4_scene.py` son escenas JSON, no archivos draw.io **[R]**.

## Seis rutas evaluadas: gana el generador propio con el MCP al lado

La pregunta "¿cómo integrar el MCP para generar los diagramas?" admite varias respuestas. La tabla las compara contra los requisitos del repositorio: determinismo en CI, la regla "fuente de verdad = DSL" (ADR 0007), la trazabilidad R4/R9, las tres notaciones y la madurez de cada herramienta.

| Opción | Cómo funciona | Determinista en CI | Fuente de verdad | C4 / ArchiMate / GCP | Madurez | Veredicto |
|---|---|---|---|---|---|---|
| **A. MCP como generador en CI** | Un job llama a un LLM con el MCP para dibujar cada vista | No: LLM en el lazo y salida en URL/visor, no en archivo **[V]** | Se diluye | Las tres, pero sin garantía | Sin soporte documentado para uso headless **[F]** | Descartada |
| **B. draw.io como fuente** (modelo actual de v3, generalizado) | Se dibuja en draw.io y se importa con `drawio2structurizr.py` | Sí, el importador | draw.io | C4 sí. ArchiMate y GCP se pierden: el inventario los clasifica como "nota" y el render como "caja" **[R]** | Importador acoplado a Volarte **[R]**; importadores externos de 2026 sin estrellas **[F]** | Solo para migraciones puntuales |
| **C. Structurizr → Mermaid → import de draw.io** | Exportador oficial a Mermaid y luego Insert > Mermaid | Parcial: necesita la UI o un navegador headless | DSL | Pierde estilos C4 e ids **[F]** ([draw.io Mermaid](https://www.drawio.com/docs/manual/insert/insert-mermaid/)) | Alta, pero con pérdida | Descartada para el pipeline |
| **D. Structurizr → C4-PlantUML → puml2drawio** | Cadena de dos conversores | Sí | DSL | Solo C4 | `puml2drawio` creado en 2026-04 con 0★ **[F]** ([GitHub](https://github.com/AndriyKalashnykov/puml2drawio)) | Piloto, no base |
| **E. Migrar a LikeC4** | `likec4 export/import drawio` nativo | Sí | Modelo LikeC4 | C4 nativo; sin ArchiMate ni GCP | Unas 5,9k★, muy activo **[F]** ([likec4](https://github.com/likec4/likec4)) | Fuera de alcance: rompe todo el marco actual |
| **F. Generador propio desde escenas/workspace + MCP como asistente** | `render-drawio.py` determinista; MCP para bocetar, editar y revisar | **Sí** | **DSL** (coherente con ADR 0007) | Las tres, con catálogos controlados en `estandares/` | Reutiliza `c4_scene.py`, `drawio_inventory.py` y R9 **[R]** | **Recomendada** |

La opción F se impone porque reutiliza lo que el repo ya tiene. Las escenas `*.modelo.json` contienen `x, y, w, h, style, fill, clase, forma, textos, puntos, extremos` y `estilo` **[R]** ([c4_scene.py](../scripts/c4_scene.py)), que es prácticamente un mxGraph serializado. Además, `drawio_inventory.py` ya reconoce elementos C4 por el atributo `c4Type` **[R]** ([drawio_inventory.py](../scripts/drawio_inventory.py)). Si el generador emite `<object c4Type=… c4Name=…>` con la librería oficial, el `.drawio` producido se puede volver a inventariar sin tocar el inventario, y **R9 obtiene una verificación de ida y vuelta casi gratis [I]**. Hay que reconocer el mejor argumento de la opción B: draw.io es más cómodo para quien no programa. La propuesta lo absorbe dejando que el MCP y el editor sean la superficie de trabajo, mientras la semántica se queda en el DSL.

## Arquitectura objetivo: un modelo, dos lazos y el .drawio como artefacto

En la arquitectura objetivo, **Structurizr DSL es la única fuente de verdad semántica** (elementos, relaciones, tags, propiedades, notación de cada vista). `dsl/layout/<vista>.json` es la fuente de presentación, y el `.drawio` es un **artefacto generado y regenerable** en `docs/generated/drawio/`. Es el mismo posicionamiento que adopta LikeC4, que trata draw.io como formato de intercambio **[F]** ([LikeC4 Draw.io](https://likec4.dev/tooling/drawio/), *snippet*). draw.io conserva la propiedad de la geometría solo a través de `dsl/layout/`, que es la excepción de presentación ya prevista en la guía 02 §6 **[R]**.

**Lazo CI (determinista, sin LLM).** Los pasos 1 a 4 de [`aac-build.sh`](../scripts/aac-build.sh) no cambian: validate, inspect y export de JSON, Mermaid y PlantUML. En el paso 4b, `c4_scene.py` genera escenas para las vistas con layout, y se extiende para generar también escenas con autolayout para las vistas sin layout (despliegue y dinámicas), que hoy quedan sin diagrama **[R]**. El nuevo **paso 4c**, `scripts/render-drawio.py`, emite `docs/generated/drawio/<Proyecto>_v<N>.drawio`: una página por vista, `compressed="false"`, cada celda envuelta en `<object id="sz-<elementId>" structurizrId=… notacion=… tags=… placeholders="1">`, y aristas `sz-rel-<relationshipId>`. En el paso 5, el revisor ejecuta R1–R9 más las nuevas R10–R12. En el paso 6, `render-c4.mjs` sigue dibujando las páginas C4, y las páginas ArchiMate y GCP se exportan a `svg/<key>.svg` con el CLI de draw.io Desktop. En CI ese CLI corre en el contenedor `rlespinasse/drawio-export` o con `rlespinasse/drawio-export-action@v2` (formato `svg`, `embed-diagram`, timeout) **[F]** ([drawio-export-action](https://github.com/rlespinasse/drawio-export-action)). Así, `render-pdf.mjs` sigue encontrando un SVG por vista **[R/I]**. El `jgraph/export-server` no es opción porque está **fuera de soporte** **[F]** ([docker-drawio](https://raw.githubusercontent.com/jgraph/docker-drawio/dev/README.md)).

**Lazo interactivo (MCP, con humano en el lazo).** Hay tres usos legítimos. El primero es **bocetar**: el arquitecto pide al asistente una vista nueva o una variante, el asistente lee `workspace.json`, consulta `estandares/<notación>/catalogo.json` (no `search_shapes`, por los huecos ya descritos) y llama a `create_diagram` con XML que lleva `structurizrId`. El arquitecto ajusta en el editor y guarda el archivo en `proyectos/<p>/v<N>/fuente/`. El importador generalizado traduce los cambios a DSL y `layout/`, y entran por PR con entrada `AAC-…` en `CHANGELOG_DSL.md` (R4). El segundo es **revisar**: el asistente toma una página del `.drawio` generado y la muestra inline en el chat para discutirla, sin tocar el repo. El tercero es **editar la presentación**: mover cajas en draw.io y reimportar solo geometría a `dsl/layout/`, lo que ADR 0007 ya permite **[R]**. Como el App Server crea una página por llamada y no devuelve las rutas calculadas por libavoid **[V]**, el XML que vale es el que se guarda **desde el editor**, no el que devuelve la herramienta. El MCP **no se ejecuta en CI**, y el Agente Revisor `--ai` sigue usando la API directamente **[R]**.

| Artefacto | Dueño | Dónde vive | Regenerable |
|---|---|---|---|
| Semántica (elementos, relaciones, notación por vista) | DSL | `dsl/model`, `dsl/views` | No, se edita a mano o vía importador |
| Geometría y estilo de presentación | `dsl/layout/<vista>.json` | `dsl/layout/` | Sí, desde un `.drawio` editado (importador) |
| `.drawio` multipágina | Generado | `docs/generated/drawio/` | Sí, en cada build |
| `.drawio` de trabajo (bocetos del MCP o del editor) | Arquitecto | `fuente/*.drawio` | No; se valida con R10/R11 antes de importarse |
| SVG/PNG/PDF | Generado | `docs/generated/{svg,png}` y PDF | Sí |

## Cada notación exige una librería, un catálogo y un contrato

### C4: la librería oficial ya coincide con la leyenda corporativa

La librería `c4` de draw.io (v32.4.1, 19 entradas) usa exactamente la paleta de seis colores de la leyenda corporativa: `#083F75`, `#6C6477`, `#1061B0`, `#8C8496`, `#23A2D9` y `#63BEF2` **[F]** ([Sidebar-C4.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-C4.js)) **[R]** ([03-leyenda-c4.md](../docs/lineamientos/03-leyenda-c4.md)). Guarda la semántica en atributos (`c4Name`, `c4Type`, `c4Technology`, `c4Description`) con `placeholders="1"`, y el `.drawio` real de Volarte usa `mxgraph.c4.person2` en sus 8 personas **[R]**. El generador debe copiar los estilos verbatim de la librería y mapear los tags semánticos de la guía 02 §4 a formas oficiales: `Database` → `cylinder3`, `Queue/Topic` → `cylinder3;direction=south`, `WebBrowser` → `mxgraph.c4.webBrowserContainer2`, `Mobile` → `mxgraph.c4.mobileDeviceContainer` y `DomainService` (si se aprueba) → `hexagon` **[I]**. La librería **no tiene leyenda, nodos de despliegue ni numeración para vistas dinámicas** **[F]**, de modo que el generador debe insertar la leyenda corporativa como grupo propio y definir el estilo de `Deployment Node` (blanco con borde gris, como en `estilos-c4.dsl`) **[R]**. Hay una inconsistencia a resolver antes: el stroke de Person es `#052E57` en `estilos-c4.dsl` y `#06315C` en `c4_scene.py` y en draw.io **[R/F]**.

### ArchiMate 3.2: elementos custom en el DSL y la librería archimate3

Structurizr no tiene tipos ArchiMate. La vía existente es el **elemento custom** (`element "<nombre>" "<metadata>"`), que `drawio2structurizr.py` ya emite **[R]**, enriquecido con las propiedades `archimate.tipo` (p. ej. `ApplicationComponent`) y `archimate.capa`. Se proponen dos modos complementarios **[I]**. El primero es la **vista derivada**: un viewpoint de *Application Cooperation* generado a partir del modelo C4 con un mapeo explícito. Persona → Business Actor; Software System y Container → Application Component; almacén de datos → Data Object o System Software; Deployment Node → Node. Este mapeo es práctica de la comunidad y no es normativo **[F]** ([DEV](https://dev.to/jbrocher/agile-software-architecture-using-archimate-and-the-c4-model-54f4); [MooD](https://supportportal.moodinternational.com/hc/en-us/articles/360015465100-MooD-and-the-C4-model)). El segundo es la **vista nativa**, para capas sin equivalente en C4 (Strategy, Business, Motivation), con elementos custom declarados.

La librería `archimate3` de draw.io, titulada "ArchiMate 3.2", cubre todo el catálogo de 3.2, las 11 relaciones y las dos uniones (junctions) **[F]** ([Sidebar-ArchiMate3.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-ArchiMate3.js)). El tipo de elemento vive **solo en el estilo** (`shape=mxgraph.archimate3.application;appType=comp;archiType=square`), y el tipo de relación solo en la **firma de flechas**: Flow y Triggering difieren únicamente en `dashed=1;dashPattern=6 4` **[F]**. Por eso el generador debe escribir además `archimateType` en el `<object>`, para no depender del estilo al releer **[I]**.

La paleta exige una decisión. Archi usa `#FFFFB5`/`#B5FFFF`/`#C9E7B7`, draw.io usa `#ffff99`/`#99ffff`/`#AFFFAF`, y el estándar no obliga a ninguna **[F]** ([Archi UIProvider](https://github.com/archimatetool/archi/blob/master/com.archimatetool.editor/src/com/archimatetool/editor/ui/factory/elements/AbstractArchimateElementUIProvider.java); [Visual Paradigm](https://archimate.visual-paradigm.com/?p=610), *snippet*). Si Enterprise Architecture trabaja en Archi, conviene emitir también el **Open Group Exchange XML** e importarlo de forma headless (`--xmlexchange.import`, `--script.runScript`, `--html.createReport` bajo `xvfb-run`) **[F]** ([Archi CLI](https://github.com/archimatetool/archi/wiki/Archi-Command-Line-Interface)).

**La salvedad de ArchiMate 4.** draw.io añadió la librería `archimate4` en la versión 31.1.8 (2026-08-07) **[F]** ([Sidebar-ArchiMate4.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-ArchiMate4.js)). Fuentes secundarias dicen que ArchiMate 4 elimina siete conceptos de 3.2 (Interaction, Contract, Constraint, Gap, Representation…) y la Composition **[F]** ([Alfabet](https://alfabet.com/blog/archimate-4-changes)), pero la paleta de draw.io para 4 **todavía incluye Composition**, así que el conjunto final está sin confirmar. Archi 5.10.0 (master, octubre de 2026) sigue modelando 3.2 **[F]** ([archi model](https://github.com/archimatetool/archi/tree/master/com.archimatetool.model/src/com/archimatetool/model)). La recomendación es **estandarizar 3.2**, prohibir mezclar `mxgraph.archimate3.*` con `mxgraph.archimate4.*` en un mismo archivo y reevaluar cuando Archi soporte 4 **[I]**.

### Google Cloud: gcp3 como primera opción y gcp2 solo por excepción

Google rehízo su iconografía a inicios de 2025 y pasó de más de 250 iconos únicos a unos 40: iconos de **producto central** a cuatro colores e iconos de **categoría** a dos colores, compartidos entre productos **[F]** ([cloud.google.com/icons](https://cloud.google.com/icons)). draw.io lo refleja en `gcp3` ("Google Cloud Platform 2026", versión 30.0.4, mayo de 2026). Trae 19 productos centrales con nombre de stencil, entre ellos `cloudrun`, `apigee`, `cloudsql`, `cloud_storage`, `bigquery`, `gke`, `alloydb`, `cloudspanner` y `vertexai`, y 26 categorías, entre ellas `integrationservices`, `databases`, `networking` y `securityidentity` **[F]** ([Sidebar-GCP3.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-GCP3.js)). La librería anterior, `gcp2`/`gcpicons`, codifica casi todo como `shape=image` con SVG en base64 **[F]** ([Sidebar-GCP2.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-GCP2.js)), y eso mismo devolvió el MCP **[V]**. A cambio, es la única que trae un icono propio para Pub/Sub, Memorystore, Cloud Armor, IAP o Dataflow.

| Criterio | `gcp3` (2026) | `gcp2` / `gcpicons` (legado) |
|---|---|---|
| Codificación | `shape=mxgraph.gcp3.<nombre>`, legible y diffable | `image=data:image/svg+xml,<base64>`, XML inflado y diffs ruidosos **[V]** |
| Validación | Lista blanca por nombre | Lista blanca por hash del `image=` |
| Cobertura de Volarte (v2: Apigee, Cloud Run, LB, Firewall…) | Apigee, Cloud Run y Cloud SQL con icono propio. Pub/Sub → categoría `integrationservices` + etiqueta; LB → `networking`; Armor/IAP → `securityidentity` **[I]** | Icono por producto |
| Fronteras (proyecto, región, VPC) | No existen en gcp3 **[F]** | "Zones" del estilo antiguo |
| Alineación con la guía de Google vigente | Sí | No: anterior a 2025 |

La propuesta es usar **`gcp3` por defecto**, con categoría más **etiqueta obligatoria** cuando no hay icono central, porque la categoría es compartida **[I]**. Los iconos `gcp2` quedarían solo como excepciones registradas en `estandares/gcp/iconos-aprobados.json` con su hash. Las fronteras de proyecto, VPC y región se definen como contenedores corporativos propios. La notación GCP se aplica **solo a vistas `deployment`**. En el DSL, los nodos llevan la propiedad `gcp.producto` (p. ej. `cloudrun`), reutilizando los tags de v2 (`GCP`, `GCPProject`, `VPC`, `LoadBalancer`, `Firewall`, `Gateway`) **[R]** ([v2 deployment.dsl](../proyectos/volarte/v2/dsl/model/deployment.dsl)). Queda una incógnita: no se inspeccionó si `gcp3` se dibuja monocromo (`fillColor=#4285f4`) en lugar de con los cuatro colores de Google **[F/gap]**.

## Cambios concretos al repositorio y a los lineamientos

Los puntos de extensión ya existen. El trabajo consiste en abrirlos por notación y en eliminar la duplicación de la leyenda, que hoy está cableada en cinco lugares con valores de borde distintos **[R]**. Centralizarla es prerrequisito: añadir dos notaciones sin hacerlo multiplicaría el problema.

| Archivo o área | Cambio propuesto | Base en el repo **[R]** |
|---|---|---|
| `estandares/leyendas/{c4,archimate,gcp}.json` (nuevo) | Fuente única de paleta, formas y estilos verbatim de draw.io por notación. La leen el revisor, el inventario, `c4_scene.py`, `render-c4.mjs` y `render-drawio.py` | Leyenda duplicada en `estilos-c4.dsl`, `C4_LEGEND`, `LEGEND`, `LEGEND_COLORS` y `render-c4.mjs` L280 |
| `estandares/archimate/`, `estandares/gcp/` (nuevos) | `estilos-archimate.dsl` y `estilos-gcp.dsl`, `catalogo.json` (formas permitidas), `mapeo-c4-archimate.json`, `iconos-aprobados.json` | No existe nada de ArchiMate ni GCP (grep sin resultados) |
| `version.json` y plantilla | `render` se mantiene, y se añaden `salidas: ["svg","drawio"]` y `notaciones: ["c4","archimate","gcp"]` | `render` es escalar; un valor desconocido cae en mermaid sin aviso ([aac-build.sh](../scripts/aac-build.sh) L160-195) |
| `dsl/views/*.dsl` | Propiedad por vista `aac.notacion` junto a `aac.layout` | Patrón ya usado por `drawio2structurizr.py` (`aac.layout`, `drawio.pagina`) |
| `scripts/aac-build.sh` | Paso 4c `render-drawio.py`; paso 6 con export draw.io CLI para páginas no C4; validación del enum | Selector de motor en L158-196 |
| `scripts/c4_scene.py` | Escenas para vistas sin `layout/` (autolayout) y campo `notacion` en la escena | Solo itera `layouts/*.json` (L296) |
| `scripts/render-drawio.py` (nuevo) | Escena/workspace → mxfile multipágina sin comprimir, ids `sz-*`, atributos `c4*`/`archimateType`/`gcp.producto` | Las escenas ya traen geometría y `style` |
| `scripts/drawio_inventory.py` | Clasificar `mxgraph.archimate3.*` y `mxgraph.gcp3.*`; leer `structurizrId` | Hoy, lo que no es C4 se trata como "nota" (L140-159) |
| `scripts/drawio2structurizr.py` | Generalizar: quitar `PAGE_PREFIX`, refs `portal`/`volarte` y `CANON_ORDER` cableados; mapeo por notación | Acoplado a Volarte (L36-40, L337-357) |
| `scripts/render-pdf.mjs` | Enlazar el `.drawio` por vista; quitar el nombre `Arquitectura_volarte_1.drawio` cableado | L119 |
| `scripts/aac-nueva-version.sh` | Copiar `fuente/` (o reescribir rutas relativas) y crear `REVISION.md` | Hoy no copia `fuente/` |
| `.github/workflows/architecture-pipeline.yml` | Paso con contenedor `rlespinasse/drawio-export` (versión fijada y timeout) en `build-artifacts`; sin cambios estructurales | Los artefactos de `docs/generated/` ya se publican |
| `scripts/tests/` | Tests de R7 por notación, de ida y vuelta del generador, de inventario sobre un archivo real y de la lista blanca | No existen tests de render ni de inventario real |
| Lineamientos | 02 §5 actualizado (layout v3, notación por vista); **03 → "Leyendas por notación"**; nueva **08 – Diagramas draw.io y uso del MCP** (ver abajo); 05 y 07 actualizados con R10–R12 y DoD por notación | 02 §5 desactualizado; 03 exige PR + ADR + CHANGELOG raíz para cambiar la leyenda |

La nueva **guía 08** debe fijar seis reglas de uso **[I]**:

1. Qué variante del MCP está autorizada (autoalojada o plugin local; nunca `mcp.draw.io` para contenido confidencial).
2. `DRAWIO_ICON_SERVICE_URL=off`.
3. Prohibición de pegar URLs `#R` en comentarios públicos, porque la URL **contiene el diagrama completo** **[V]**.
4. Todo `.drawio` se guarda sin comprimir.
5. Lo producido con el MCP solo entra al repo por `fuente/` + importador + PR.
6. El catálogo de formas es el de `estandares/`.

Por la regla "cambio de notación ⇒ nueva versión" de la guía 04 **[R]**, ArchiMate y GCP en Volarte serán una **v4**, no una edición de v3.

## El Agente Revisor necesita reglas por notación y una regla de deriva

Las reglas actuales viven en una lista fija en `main()` y no hay un registro de reglas por notación **[R]** ([architecture_reviewer.py](../scripts/architecture_reviewer.py) L605-620). La propuesta es introducir ese registro y estas reglas:

| Regla | Cambio | Severidad | Detalle |
|---|---|---|---|
| R1/R2 | Ampliar a `CustomElement` con `archimate.tipo` y a nodos con `gcp.producto` | ERROR | Hoy solo revisa Person, SoftwareSystem, Container y Component (L200-213) **[R]** |
| R3/R5 | Mapear tags GCP (`CloudRun`, `GKE`, `LoadBalancer`…) a la taxonomía de capas y observabilidad | WARN | R5 ya usa `CloudRun/GKE` y `ha` **[R]** |
| **R7-C4** | Igual que la R7 actual, pero acotada a vistas `aac.notacion=c4` | ERROR | Hoy, cualquier tag no C4 con color falla (L302-334), lo que bloquearía ArchiMate y GCP **[R]** |
| **R7-AM** | Paleta por capa de `leyendas/archimate.json`; `archimate.tipo` válido para 3.2; elementos eliminados en 4 marcados si se migra | ERROR | Paleta por decidir (Archi o draw.io) |
| **R7-GCP** | `gcp.producto` dentro del catálogo `gcp3`; categoría ⇒ etiqueta obligatoria; icono `gcp2` solo con hash aprobado | ERROR/WARN | |
| R8 | Validar el enum de `render`, `salidas` y `notaciones`, y `aac.notacion` por vista | ERROR | Hoy un valor desconocido pasa en silencio **[R]** |
| R9 | Ida y vuelta: el `.drawio` generado se reinventaría y debe coincidir con la escena; **una forma distinta pasa a ser ERROR** | ERROR | Hoy `formasIguales` se cuenta pero no falla **[R]** |
| **R10 (nueva)** | Conformidad del `.drawio`: formas de la lista blanca de la página, `c4Type` y `c4Description` en aristas C4, sin flechas bidireccionales, sin mezcla archimate3/archimate4, sin comprimir, sin `image=data:` no aprobado | ERROR | Diseño de validador en las notas de notación **[F/I]** |
| **R11 (nueva)** | Deriva modelo ↔ `fuente/*.drawio`: celdas sin `structurizrId` (contenido a mano alzada), ids obsoletos, elementos de la vista ausentes, etiquetas distintas | ERROR en `fuente/` de versiones editables | Patrón de detección de deriva **[F/I]** |
| **R12 (nueva)** | Validez de relaciones ArchiMate: se clasifican las aristas por firma de flecha y se coteja el par origen/destino con la tabla de relaciones | WARN al inicio | Requiere embeber la tabla del Apéndice B **[I]** |

R10 y R11 son la pieza que hace seguro el MCP. Lo que el asistente proponga se puede aceptar porque el pipeline rechaza formas fuera de catálogo, celdas sin trazabilidad y archivos comprimidos antes de que lleguen a `main` **[I]**.

## Roadmap en cinco fases, empezando por C4

| Fase | Objetivo | Entregables | Criterio de salida |
|---|---|---|---|
| **F0 – Fundaciones** | Preparar el terreno sin cambiar diagramas | ADR "Integración draw.io/MCP" (raíz); `estandares/leyendas/*.json` con la leyenda C4 unificada (resuelve el stroke de Person); enum de `render` en R8; registro de reglas en el revisor; decisión y despliegue de la variante del MCP; borrador de la guía 08 | Build de v1–v3 sin cambios de salida; tests verdes |
| **F1 – C4 → .drawio** | Generador determinista para C4 | `render-drawio.py`; paso 4c; `docs/generated/drawio/Volarte_v3.drawio` con 13 páginas; R9 de ida y vuelta; R10 para C4; tests | El `.drawio` generado reinventariado da fidelidad del 100 % en las 13 vistas (hoy 182/182 y 190/190 frente al original **[R]**) |
| **F2 – Lazo MCP** | Autoría y revisión asistidas | Importador generalizado (sin cableado de Volarte); flujo `fuente/` → importador → PR; R11; guía 08 publicada; prompt/skill de proyecto con catálogo | Una vista nueva bocetada con el MCP llega a `main` solo por PR con R4, R10 y R11 en verde |
| **F3 – GCP en despliegue** | Recuperar `DEP_Produccion_GCP` (REV-12) en **Volarte v4** | `estandares/gcp/`; escenas con autolayout para `deployment`; export SVG por CLI draw.io en CI; R7-GCP; DoD 07 §2 cumplido | Vista de despliegue de producción con iconos `gcp3` en PDF; 0 ERROR |
| **F4 – ArchiMate 3.2** | Viewpoint de aplicación derivado del modelo y vistas nativas | `estandares/archimate/` y mapeo C4 → ArchiMate aprobado por EA; páginas `archimate3`; R7-AM y R12; Exchange XML opcional + Archi CLI | Una vista Application Cooperation de Volarte revisada y aprobada por EA |
| **F5 – Consolidación** | Revisar decisiones de plataforma | Evaluación de Structurizr vNext y `structurizr-mcp`; revisión de ArchiMate 4 frente a Archi; medición de tiempos del CLI draw.io | Informe y ADR de seguimiento |

El orden responde al riesgo. F1 se apoya casi por completo en código existente y deja una red de seguridad (R9 de ida y vuelta) antes de abrir la puerta al MCP en F2. GCP va antes que ArchiMate porque cubre un hueco reconocido del propio DoD: v3 no tiene vista de despliegue **[R]** ([REVISION.md](../proyectos/volarte/v3/REVISION.md) REV-12).

## Riesgos y limitaciones que condicionan el diseño

| Riesgo o limitación | Evidencia | Mitigación |
|---|---|---|
| El MCP solo crea: no lee, no escribe archivo, no exporta | **[V]** | El MCP nunca va en CI. Archivos solo vía editor o plugin y `fuente/`. Para editar existentes, evaluar `lgazo` en un piloto |
| Una página por llamada; las rutas libavoid/ELK no se devuelven | **[V]** | Guardar desde el editor. El layout de verdad vive en `dsl/layout/` |
| `search_shapes` no indexa C4 ni ofreció `gcp3` | **[V]** | Catálogo propio en `estandares/`, inyectado al asistente |
| Residencia: `mcp.draw.io` recibe el diagrama; la URL `#R` lleva todo el contenido; el LLM ve todo | **[F]** + **[V]** | Variante autoalojada con `DRAWIO_ICON_SERVICE_URL=off` y visor propio, o plugin local; guía 08 |
| Iconos en base64 (`gcp2`/`gcpicons`) inflan el XML y ensucian los diffs | **[V]** **[F]** | `gcp3` por defecto; excepciones por hash; R10 |
| CLI de draw.io en CI depende de Xvfb y Electron, puede colgarse, y la acción es comunitaria | **[F]** ([docker-drawio-desktop-headless](https://github.com/rlespinasse/docker-drawio-desktop-headless/blob/982088cf01fb272ec6747a362645cbaf5fc956ad/README.adoc)) | Imagen fijada, timeout, export por lotes; `render-c4.mjs` sigue cubriendo C4 |
| ArchiMate 4 todavía inestable en las herramientas | **[F]** | Estandarizar 3.2 y prohibir la mezcla |
| Mapeo C4 → ArchiMate no normativo | **[F]** | Aprobación de EA y archivo de mapeo versionado |
| Structurizr CLI en deprecación | **[F]** | F5: evaluar vNext; mantener la versión fijada mientras tanto |
| Brecha de verificación: el build no se ejecutó, no se vio el render inline de `mxgraph.c4.person2` ni si se aceptan entradas multipágina | **[R]** **[V]** | Validarlo en F1 como primera tarea |

## Decisiones pendientes para el equipo de Arquitectura

| # | Decisión | Opciones | Recomendación |
|---|---|---|---|
| D1 | Variante del MCP autorizada | Alojado `mcp.draw.io` / autoalojado Docker / plugin local + Desktop | Autoalojado o plugin; el alojado solo para contenido público |
| D2 | Paleta ArchiMate | Archi (`#FFFFB5`…) / draw.io (`#ffff99`…) | Archi, si EA usa Archi |
| D3 | Versión ArchiMate | 3.2 / 4 | 3.2, con revisión en F5 |
| D4 | Política de iconos GCP | Solo `gcp3` / `gcp3` + excepciones `gcp2` / solo `gcp2` | `gcp3` + excepciones por hash |
| D5 | Fronteras GCP (proyecto, VPC, región) | Estilo corporativo propio / "Zones" de gcp2 | Estilo propio en `estandares/gcp` |
| D6 | ¿El `.drawio` generado se versiona en Git o solo se publica como artefacto? | Commit del bot / artefacto de 30 días | Commit del bot (coherente con `docs/generated/` actual) |
| D7 | Motor SVG para C4 | Mantener `render-c4.mjs` / migrar todo al CLI de draw.io | Mantener `render-c4.mjs` en F1–F3 y reevaluar |
| D8 | ¿ArchiMate derivado, nativo o ambos? | Derivado de C4 / custom elements nativos / ambos | Ambos, empezando por el derivado |
| D9 | ¿Exportar Exchange XML para Archi? | Sí / no | Sí, si EA mantiene un repositorio Archi |
| D10 | Ámbito: ¿solo Volarte v4 o plantilla para todos los proyectos? | Piloto / plantilla | Piloto en Volarte v4 y luego plantilla |

## Conclusión

El cambio de enfoque más útil es dejar de ver el MCP de draw.io como "el generador" y verlo como **la superficie de conversación sobre un modelo que ya existe**. La prueba práctica lo deja claro: el valor del MCP está en que preserva metadatos y muestra al instante, no en producir archivos. Lo que hace viable la integración no es el MCP sino tres decisiones de diseño: ids `structurizrId` en cada celda, catálogos de notación en `estandares/` y reglas R10–R11 que vuelven verificable cualquier diagrama, lo haya dibujado una persona, un script o un asistente.

La consecuencia menos obvia es que el mayor costo no está en las notaciones nuevas sino en la **deuda que hoy ata el pipeline a C4 y a Volarte**: la leyenda en cinco copias, el importador con nombres de página cableados y un `render` que falla en silencio. F0 no es preparación cosmética. Es la condición para que ArchiMate y GCP entren sin multiplicar esa deuda. Hecho eso, la vista de despliegue GCP que v3 sacrificó por fidelidad se convierte en el primer entregable que el ecosistema anterior no podía producir.
