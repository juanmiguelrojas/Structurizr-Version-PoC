# 05 · Revisión y aprobación del contenido generado

Ningún cambio de arquitectura llega a `main` sin pasar por **revisión automática** (Agente Revisor + pipeline)
y **revisión humana** (arquitecto revisor). La aprobación formal de una versión la otorga la Dirección de Arquitectura.

## 1. Roles

| Rol | Responsabilidad |
|---|---|
| **Autor** (arquitecto de solución) | Modela el cambio, registra bitácora y ADR, ejecuta el build local, abre el PR y atiende comentarios |
| **Agente Revisor** (automático) | Valida reglas R1–R8, sugiere mejoras (R5), comenta el reporte en el PR y bloquea si hay errores |
| **Arquitecto revisor** (par) | Revisa contenido técnico, consistencia C4 y sugerencias del agente; aprueba el PR |
| **Dirección de Arquitectura** (aprobador) | Aprueba versiones (`en-revision → aprobada`) y cambios a lineamientos / estándares |
| **CODEOWNERS** | Revisión obligatoria automática según `.github/CODEOWNERS` |

## 2. Flujo

```
 Autor                        Pipeline / Agente                 Arquitecto revisor         Dirección de Arquitectura
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────
 1. Rama + cambios DSL
 2. Bitácora + ADR
 3. aac-build local ──────►  (mismas reglas que el CI)
 4. PR (plantilla) ───────►  5. validate + R1–R8 + render
                             6. comenta reporte en el PR
                                 │ errores → PR bloqueado
                                 ▼ sin errores
                                                        7. revisa checklist,
                                                           diagramas y sugerencias
                                                           ├─ cambios solicitados → vuelve a 1
                                                           └─ aprueba PR
                                                                                     8. (si cierra versión)
                                                                                        estado → aprobada,
                                                                                        aprobadores en version.json
 9. Merge a main ─────────►  10. regenera docs/generated y publica artefactos
```

## 3. Revisión automática (Agente Revisor)

| Regla | Severidad | Verifica | Si falla |
|---|---|---|---|
| R1 Descripciones | ERROR | Person / Software System / Container / Component con descripción | PR bloqueado |
| R2 Tecnologías | ERROR | Container y Component con tecnología | PR bloqueado |
| R3 Aislamiento de capas | ERROR | Frontend/Móvil sin acceso directo a datos, colas o servicios de dominio | PR bloqueado |
| R4 Trazabilidad | ERROR | Cambios en `dsl/` con entrada completa en la bitácora del proyecto | PR bloqueado |
| R5 Sugerencias | WARN / INFO | SPOF, cifrado, observabilidad, DLQ, decisiones pendientes | Debe **responderse** (ver §5) |
| R6 Inmutabilidad | ERROR | No se modifican versiones aprobadas / reemplazadas / obsoletas | PR bloqueado |
| R7 Leyenda C4 | ERROR | Colores solo de la leyenda oficial; tags de externos | PR bloqueado |
| R8 Metadatos | ERROR | `version.json` completo, estado válido, aprobadores si está aprobada | PR bloqueado |
| IA (opcional) | — | Resumen ejecutivo, riesgos y recomendaciones (Claude) | Insumo para el revisor humano |

Además: `structurizr validate` (sintaxis) bloquea y `structurizr inspect` se publica como informativo.

## 4. Checklist del arquitecto revisor

**Notación C4**
- [ ] Los diagramas generados (SVG/PNG del PR) usan la leyenda C4 y la muestran al pie.
- [ ] Cada elemento está en el nivel correcto (no hay componentes en L2 ni contenedores en L1).
- [ ] Lo que está fuera del alcance es `External Software System` / `External Person`.
- [ ] Relaciones con propósito claro y tecnología/protocolo; la dirección expresa la dependencia.

**Contenido técnico**
- [ ] Las tecnologías son correctas y consistentes con `docs/workspace/` (stack tecnológico).
- [ ] Seguridad: autenticación, autorización, cifrado en tránsito y reposo, secretos.
- [ ] Resiliencia: reintentos, DLQ, idempotencia, degradación; SPOF identificados.
- [ ] Observabilidad: todo contenedor de ejecución exporta telemetría.
- [ ] Despliegue: cada contenedor aparece en la vista de despliegue.

**Trazabilidad**
- [ ] Entrada en `CHANGELOG_DSL.md` con versión, HU/Jira, archivos, contexto, impacto y sugerencias del revisor.
- [ ] ADR nuevo o actualizado si cambió tecnología, protocolo, límite o seguridad.
- [ ] `version.json` actualizado (descripción, changelog[]).
- [ ] Las advertencias R5 están atendidas o aceptadas explícitamente como riesgo.

## 5. Tratamiento de sugerencias (R5)

Cada advertencia R5 debe quedar en uno de estos estados, registrado en el campo *Sugerencias del revisor* de la bitácora:

| Estado | Qué hacer |
|---|---|
| **Atendida** | Se corrige el modelo en el mismo PR |
| **Riesgo aceptado** | Se justifica (y, si aplica, ADR) — p. ej. "HA de Cloud SQL se define en fase II" |
| **Pendiente de decisión** | Se crea/enlaza la decisión `P-NNN` y se marca el elemento con tag `Pending` |
| **Falso positivo** | Se explica en el PR; si es recurrente se ajusta la regla del agente (cambio de lineamiento) |

`--strict` convierte las advertencias en errores; se recomienda en la aprobación final de una versión.

## 6. Aprobación de una versión

1. La versión está en `en-revision`, el pipeline está verde y el PR tiene aprobación del arquitecto revisor.
2. La Dirección de Arquitectura revisa el **PDF** de la versión (portada, diagramas, fichas, bitácora, reporte).
3. En el mismo PR (o uno dedicado) se actualiza `version.json`: `"estado": "aprobada"`, `"aprobadores": [...]`
   y la versión anterior pasa a `"reemplazada"` con `"reemplazadaPor"`.
4. Se agrega la entrada de aprobación en la bitácora y se actualiza la tabla de versiones del `README.md` del proyecto.
5. Tras el merge, la versión queda **congelada** (R6).

## 7. Configuración recomendada en GitHub (protección de `main`)

- *Require a pull request before merging* con al menos **1 aprobación** y *Require review from Code Owners*.
- *Require status checks to pass*: `Validar DSL y Agente Revisor` y `Compilar diagramas y PDF`.
- *Require conversation resolution before merging*.
- Prohibir *force push* y borrado de `main`.
- Secret opcional `ANTHROPIC_API_KEY` para la revisión narrativa por IA.
