/*
 * =============================================================================
 *  VOLARTE · Architecture as Code (Structurizr DSL)
 *  Terpel · Dirección de Arquitectura · Documento origen: Versión 1 · Fase I
 *  Versión de arquitectura: v2 (basada en v1 · leyenda C4 oficial + especificaciones)
 *  Fuente de verdad inicial: proyectos/volarte/v1/fuente/Arquitectura_volarte_1.drawio
 *
 *  Punto de entrada. Todo cambio en dsl/ DEBE registrarse en
 *  proyectos/volarte/CHANGELOG_DSL.md (Agente Revisor · regla R4) y respetar los
 *  lineamientos de docs/lineamientos/ (leyenda C4 · regla R7).
 * =============================================================================
 */
workspace "Volarte" "Plataforma de operación de abastecimiento de combustible de aviación (web + app móvil offline-first) sobre GCP. Terpel · Dirección de Arquitectura." {

    !identifiers flat

    properties {
        "structurizr.groupSeparator" "/"
        "volarte.version" "2.0.0"
        "volarte.fase" "I"
        "volarte.owner" "Terpel - Dirección de Arquitectura"
        "volarte.source" "Arquitectura_volarte_1.drawio"
        "aac.proyecto" "volarte"
        "aac.version" "v2"
        "aac.basadaEn" "v1"
    }

    model {
        properties {
            "structurizr.groupSeparator" "/"
        }

        !include model/people.dsl
        !include model/systems.dsl

        volarte = softwareSystem "Volarte" "Sistema de operación de abastecimiento: web (comercial, supervisión, admin) y app móvil offline-first para operarios en campo. Orquesta datos maestros, comercial, operación, asignación y publicación documental sobre GCP." "Volarte" {
            !docs ../docs/workspace
            !adrs ../docs/adr
            !include model/volarte_containers.dsl
        }

        !include model/relationships.dsl
        !include model/deployment.dsl
    }

    views {
        !include views/landscape_context.dsl
        !include views/containers.dsl
        !include views/components.dsl
        !include views/dynamic.dsl
        !include views/deployment.dsl
        !include views/styles.dsl
    }

    configuration {
        scope softwaresystem
    }
}
