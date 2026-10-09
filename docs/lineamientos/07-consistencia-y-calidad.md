# 07 · Consistencia y criterios de calidad

Reglas para que todos los proyectos se lean igual y para decidir cuándo una versión está "terminada".

## 1. Convenciones de nombres

| Objeto | Convención | Ejemplo |
|---|---|---|
| Carpeta de proyecto | `kebab-case`, sin espacios ni tildes | `proyectos/volarte`, `proyectos/portal-hub` |
| Carpeta de versión | `v<N>` | `v1`, `v2` |
| Identificador DSL | `camelCase`, prefijo por contenedor para componentes | `bffMobile`, `bmReconciler` |
| Nombre de elemento | Español, *Title Case*, sin abreviaturas ambiguas | `Svc: Operación`, `Motor de Reconciliación` |
| Clave de vista | `L0_`, `L1_`, `L2_`, `L3_`, `D<n>_`, `DEP_` + nombre | `L3_BFF_Movil`, `D2_Sync_Offline_HU050` |
| Tecnología | `Lenguaje · Framework · Plataforma` (separador `·`) | `Python · FastAPI · Cloud Run` |
| Protocolo de relación | `Protocolo · Seguridad` | `HTTPS · ID Token (IAM Invoker)` |
| ADR | `NNNN-titulo-en-kebab.md` | `0006-leyenda-oficial-c4-y-versionamiento.md` |
| Entrada de bitácora | `AAC-AAAAMMDD-NN` | `AAC-20261009-01` |
| PDF | `<Nombre>_v<N>_Architecture_Specification.pdf` | `Arquitectura_Volarte_v2_Architecture_Specification.pdf` |

## 2. Contenido mínimo de una versión (*Definition of Done*)

- [ ] `version.json` completo (R8) y `README.md` de la versión con "qué cambió y por qué".
- [ ] Vistas L1, L2 y despliegue; L3 para contenedores con lógica relevante; dinámicas para flujos críticos.
- [ ] `docs/workspace/` con: introducción (alcance, atributos), trazabilidad a la fuente y **stack tecnológico**
      (tecnologías por capa, restricciones, puntos *Por confirmar*).
- [ ] ADRs de las decisiones estructurales.
- [ ] Build completo sin errores del Agente Revisor; advertencias R5 tratadas (ver 05 §5).
- [ ] `docs/generated/` actualizado: diagramas con leyenda C4, PDF, reportes.
- [ ] Entrada en la bitácora del proyecto y fila en la tabla de versiones del `README.md` del proyecto.

## 3. Consistencia entre proyectos

- La plataforma transversal de Terpel (Entra ID, Apigee, Cloudflare, OTel Collector, Dynatrace, Secret Manager, KMS…)
  se nombra y describe **igual** en todos los proyectos. Copiar los elementos desde un proyecto existente
  (p. ej. `proyectos/volarte/v2/dsl/model/systems.dsl`) en lugar de redactarlos de nuevo.
- Mismos grupos (`group`) para la plataforma: *Identidad*, *Borde y Red Corporativa*, *API Management*,
  *Seguridad Transversal*, *Observabilidad*, *Datos y Analítica Corporativa*.
- Un proyecto que depende de otro lo modela como `External Software System` con tag `Reference`
  y descripción que apunte a la carpeta del otro proyecto.

## 4. Calidad de los diagramas

- Un diagrama debe entenderse **solo** (con su título, descripción y leyenda) sin leer el código.
- Máximo recomendado ~25 elementos por vista; si se supera, dividir (como `L2_Containers_Mensajeria_Datos`).
- Las vistas excluyen ruido explícitamente (`exclude`) en lugar de borrar relaciones del modelo.
- Ninguna relación sin etiqueta; ningún elemento sin descripción.
