/*
 * __NOMBRE__ · Architecture as Code (Structurizr DSL) · v1
 * Lineamientos: docs/lineamientos/ · Bitácora: proyectos/__PROYECTO__/CHANGELOG_DSL.md
 */
workspace "__NOMBRE__" "Describa el sistema." {

    !identifiers flat

    properties {
        "aac.proyecto" "__PROYECTO__"
        "aac.version" "v1"
    }

    model {
        !include model/people.dsl
        !include model/systems.dsl

        sistema = softwareSystem "__NOMBRE__" "Describa la responsabilidad del sistema." {
            !docs ../docs/workspace
            !adrs ../docs/adr
            !include model/containers.dsl
        }

        !include model/relationships.dsl
        !include model/deployment.dsl
    }

    views {
        !include views/views.dsl
        !include views/styles.dsl
    }
}
