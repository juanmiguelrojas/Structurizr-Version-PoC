# =============================================================================
#  ESTILOS C4 CORPORATIVOS · Terpel · Dirección de Arquitectura
#  Leyenda oficial C4 (obligatoria en TODOS los proyectos del repositorio):
#
#    Person                    #083F75   (persona interna / del tenant)
#    Software System           #1061B0   (sistema en alcance del proyecto)
#    Container                 #23A2D9
#    Component                 #63BEF2
#    External Person           #6C6477   (persona fuera de la organización)
#    External Software System  #8C8496   (todo sistema fuera del alcance)
#
#  Reglas (verificadas por el Agente Revisor, regla R7-Leyenda C4):
#   - SOLO los 6 tags de la leyenda pueden definir background / color / stroke.
#   - Los tags semánticos (Database, Queue, Mobile, …) solo cambian la FORMA
#     (shape) o el BORDE (border / strokeWidth), nunca el color.
#   - El color ámbar de borde está reservado para el tag "Pending".
#
#  Uso: dentro del bloque views {} del workspace →  !include <ruta>/estilos-c4.dsl
# =============================================================================
styles {
    # ------------------------------------------------------------ Leyenda C4
    element "Element" {
        color #ffffff
        fontSize 22
        strokeWidth 2
    }
    element "Person" {
        shape Person
        background #083F75
        stroke #052E57
        color #ffffff
    }
    element "Software System" {
        background #1061B0
        stroke #0B4884
        color #ffffff
    }
    element "Container" {
        background #23A2D9
        stroke #0E7DAD
        color #ffffff
    }
    element "Component" {
        background #63BEF2
        stroke #2E8BC9
        color #ffffff
    }
    element "External Person" {
        background #6C6477
        stroke #4D4756
        color #ffffff
    }
    element "External Software System" {
        background #8C8496
        stroke #6B6474
        color #ffffff
    }

    # -------------------------------------------- Formas semánticas (sin color)
    element "WebBrowser" {
        shape WebBrowser
    }
    element "Mobile" {
        shape MobileDevicePortrait
    }
    element "Database" {
        shape Cylinder
    }
    element "LocalDatabase" {
        shape Cylinder
    }
    element "Storage" {
        shape Folder
    }
    element "Queue" {
        shape Pipe
    }
    element "Topic" {
        shape Pipe
    }
    element "IdentityProvider" {
        shape Hexagon
    }
    element "APIGateway" {
        shape Hexagon
    }
    element "BFF" {
        shape RoundedBox
    }
    element "DomainService" {
        shape RoundedBox
    }
    element "Subscription" {
        shape RoundedBox
    }
    element "Infrastructure" {
        shape Pipe
    }
    element "Observability" {
        shape Ellipse
    }

    # -------------------------------------------------- Bordes (sin color de fondo)
    element "Pending" {
        border Dashed
        stroke #F59E0B
        strokeWidth 5
    }
    element "Reference" {
        border Dashed
    }
    element "DLQ" {
        border Dotted
        strokeWidth 4
    }

    # ------------------------------------------------------------- Despliegue
    element "Deployment Node" {
        background #ffffff
        color #1F2937
        stroke #6B7280
    }
    element "Infrastructure Node" {
        background #ffffff
        color #1F2937
        stroke #6B7280
    }

    # -------------------------------------------------------------- Relaciones
    relationship "Relationship" {
        thickness 2
        color #707070
        routing Orthogonal
    }
    relationship "Logical" {
        style Dashed
        color #9CA3AF
    }
}
