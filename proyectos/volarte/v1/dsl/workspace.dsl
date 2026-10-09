/*
 * =============================================================================
 *  VOLARTE · Architecture as Code (Structurizr DSL)
 *  Terpel · Dirección de Arquitectura · Versión 1 · Fase I
 *  Fuente de verdad inicial: Arquitectura_volarte_1.drawio (13 páginas, 17/08/2026)
 *
 *  Punto de entrada. Todo cambio en dsl/ DEBE registrarse en docs/CHANGELOG_DSL.md
 *  (validado por scripts/architecture_reviewer.py · regla R4).
 * =============================================================================
 */
workspace "Volarte" "Plataforma de operación de abastecimiento de combustible de aviación (web + app móvil offline-first) sobre GCP. Terpel · Dirección de Arquitectura." {

    !identifiers flat

    properties {
        "structurizr.groupSeparator" "/"
        "volarte.version" "1.0.0"
        "volarte.fase" "I"
        "volarte.owner" "Terpel - Dirección de Arquitectura"
        "volarte.source" "Arquitectura_volarte_1.drawio"
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
