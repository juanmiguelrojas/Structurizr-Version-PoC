# 02 · Lineamientos de modelado C4

El [modelo C4](https://c4model.com) describe la arquitectura en niveles de zoom. Todos los proyectos del
repositorio lo aplican con las reglas de esta guía. Las reglas marcadas con **[Rn]** las verifica el Agente Revisor.

## 1. Niveles y vistas obligatorias

| Nivel | Vista Structurizr | Pregunta que responde | Obligatoria |
|---|---|---|---|
| L0 · Paisaje | `systemLandscape` | ¿Qué sistemas existen en la organización y cómo se integran? | Si el proyecto comparte plataforma transversal |
| L1 · Contexto | `systemContext` | ¿Quién usa el sistema y con qué sistemas externos interactúa? | **Sí** |
| L2 · Contenedores | `container` | ¿Qué aplicaciones, servicios y almacenes de datos lo componen y cómo se comunican? | **Sí** |
| L3 · Componentes | `component` | ¿Qué hay dentro de un contenedor relevante? | Para contenedores con lógica no trivial |
| Dinámicas | `dynamic` | ¿Cómo fluye un caso de uso / historia de usuario crítica? | Para flujos críticos (HU clave) |
| Despliegue | `deployment` | ¿Dónde y cómo se despliega cada contenedor? | **Sí** (al menos producción) |

**Nomenclatura de claves de vista:** `L0_…`, `L1_…`, `L2_…`, `L3_<Contenedor>`, `D<n>_<Flujo>_<HU>`, `DEP_<Ambiente>_<Plataforma>`.

## 2. Elementos

| Tipo C4 | Cuándo usarlo | Campos obligatorios |
|---|---|---|
| **Person** | Rol humano que usa el sistema (no individuos) | nombre, descripción **[R1]** |
| **Software System** | Sistema que entrega valor por sí mismo; el del proyecto y los externos | nombre, descripción **[R1]** |
| **Container** | Unidad desplegable/ejecutable: SPA, app móvil, servicio, BD, cola, bucket | nombre, descripción **[R1]**, tecnología **[R2]** |
| **Component** | Agrupación de responsabilidad dentro de un contenedor | nombre, descripción **[R1]**, tecnología **[R2]** |

Reglas:

- **Descripciones**: una o dos frases con la *responsabilidad* (qué hace y para qué), no la implementación.
  Incluir referencias de negocio relevantes (HU-NNN, S0N, P-NNN).
- **Tecnología**: lenguaje · framework · plataforma, p. ej. `Python · FastAPI · Cloud Run`, `PostgreSQL · Cloud SQL`.
- **Alcance**: todo lo que no pertenece al proyecto se modela como `softwareSystem` con el tag
  `External Software System` (también la plataforma corporativa: Apigee, Entra ID, Cloudflare…) **[R7]**.
- **Personas externas** a la organización llevan el tag `External Person` **[R7]**.
- **Decisiones pendientes**: tag `Pending` (borde ámbar) y referencia `P-NNN` en la descripción.

## 3. Relaciones

- Toda relación lleva **descripción** (verbo + propósito) y **tecnología/protocolo**:
  `bffWeb -> svcComercial "Consulta elegibilidad y crédito" "HTTPS · ID Token (IAM Invoker)"`.
- La tecnología declara el **cifrado** del tramo (`TLS`, `mTLS`, `HTTPS`, `IAM`, `OIDC`); el Agente Revisor
  advierte los tramos sin cifrado explícito **[R5]**.
- La dirección de la flecha indica **dependencia** (quién llama / quién publica).
- Relaciones lógicas que en realidad atraviesan intermediarios se marcan con el tag `Logical` (línea punteada gris).
- **Aislamiento de capas [R3]**: los contenedores/componentes `Frontend` o `Mobile` nunca se conectan directamente a
  `Database`, `Cache`, `Storage`, `Queue`, `Topic`, `Subscription` ni `DomainService`: siempre vía API Gateway / BFF.

## 4. Tags semánticos

Los tags clasifican elementos para las reglas del revisor y para la **forma** del elemento; **no asignan colores**
(ver [03 · Leyenda C4](03-leyenda-c4.md)).

| Tag | Uso | Efecto visual |
|---|---|---|
| `Frontend`, `Mobile`, `WebBrowser` | Canales de usuario | Forma navegador / móvil (vista Structurizr) |
| `BFF`, `DomainService` | Backend for Frontend / servicio de dominio | Caja redondeada |
| `Database`, `LocalDatabase`, `Cache`, `Storage` | Persistencia | Cilindro / carpeta |
| `Queue`, `Topic`, `Subscription`, `DLQ` | Mensajería | Tubo / borde punteado (DLQ) |
| `APIGateway`, `IdentityProvider`, `Infrastructure`, `Edge`, `Security`, `Observability` | Plataforma transversal | Hexágono / tubo / elipse |
| `Pending` | Decisión abierta | Borde ámbar |
| `Reference` | Sistema de referencia (otro proyecto) | Borde punteado |
| `Logical` (relación) | Relación lógica | Línea punteada gris |

## 5. Organización del DSL (por versión)

```
dsl/
├── workspace.dsl              # Punto de entrada: !identifiers, properties, model, views
├── model/
│   ├── people.dsl             # Personas
│   ├── systems.dsl            # Sistemas externos y plataforma transversal (agrupados con group)
│   ├── <sistema>_containers.dsl
│   ├── components/<contenedor>.dsl   # Componentes L3 + relaciones internas
│   ├── relationships.dsl      # Relaciones entre contenedores/sistemas (protocolo + cifrado)
│   └── deployment.dsl         # Entornos de despliegue
└── views/
    ├── landscape_context.dsl, containers.dsl, components.dsl, dynamic.dsl, deployment.dsl
    └── styles.dsl             # SOLO: !include del estándar estandares/c4/estilos-c4.dsl
```

- Identificadores `camelCase` y únicos (`!identifiers flat`), con prefijo por contenedor en componentes
  (`bmRouter`, `bwAuthz`…).
- `autoLayout` en todas las vistas (los diagramas no se acomodan a mano).
- La documentación de la versión se embebe con `!docs ../docs/workspace` y `!adrs ../docs/adr`.
- `structurizr inspect` debe reportar 0 observaciones de severidad *error*.

## 6. Consistencia entre niveles

- Un contenedor de L2 que tenga vista L3 debe tener **todas** sus integraciones externas modeladas en sus componentes.
- Los nombres de elementos son idénticos en todos los niveles (el modelo es único, no se duplica).
- Las vistas dinámicas solo usan relaciones que existen en el modelo (Structurizr lo valida).
- Toda tecnología mencionada en `docs/workspace/` debe existir en el modelo y viceversa.
