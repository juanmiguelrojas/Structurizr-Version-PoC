# ---------------------------------------------------------------------------
# Estilos C4 por tag  ·  Paleta Volarte / Terpel
# El tema local (themes/volarte-theme.json) replica estos estilos para que
# otros workspaces del ecosistema puedan reutilizarlos.
# ---------------------------------------------------------------------------

theme themes/volarte-theme.json

styles {
    element "Element" {
        fontSize 22
        strokeWidth 2
    }
    element "Person" {
        shape Person
        background #0B3D91
        color #ffffff
    }
    element "External" {
        background #6B7280
        color #ffffff
    }
    element "FieldOperator" {
        background #C8102E
        color #ffffff
    }
    element "Software System" {
        background #1168BD
        color #ffffff
    }
    element "Volarte" {
        background #C8102E
        color #ffffff
        stroke #7A0A1C
    }
    element "ExternalSystem" {
        background #8C8C8C
        color #ffffff
    }
    element "Reference" {
        background #B0B7C3
        color #1F2937
        border dashed
    }
    element "Pending" {
        border dashed
        stroke #F59E0B
        strokeWidth 4
    }
    element "IdentityProvider" {
        shape Hexagon
        background #5C2D91
        color #ffffff
    }
    element "Infrastructure" {
        shape Pipe
        background #374151
        color #ffffff
    }
    element "Edge" {
        background #F48120
        color #ffffff
    }
    element "APIGateway" {
        shape Hexagon
        background #34A853
        color #ffffff
    }
    element "Security" {
        stroke #5C2D91
        strokeWidth 4
    }
    element "Observability" {
        shape Ellipse
        background #1496FF
        color #ffffff
    }
    element "Container" {
        background #438DD5
        color #ffffff
    }
    element "Frontend" {
        background #E0473F
        color #ffffff
    }
    element "WebBrowser" {
        shape WebBrowser
    }
    element "Mobile" {
        shape MobileDevicePortrait
        background #B5121B
        color #ffffff
    }
    element "BFF" {
        shape RoundedBox
        background #EA8600
        color #ffffff
    }
    element "DomainService" {
        shape RoundedBox
        background #1A73E8
        color #ffffff
    }
    element "GKE" {
        shape Hexagon
    }
    element "Database" {
        shape Cylinder
        background #0F9D58
        color #ffffff
    }
    element "Cache" {
        background #DC382D
        color #ffffff
    }
    element "Storage" {
        shape Folder
        background #4285F4
        color #ffffff
    }
    element "Queue" {
        shape Pipe
        background #7B1FA2
        color #ffffff
    }
    element "Component" {
        background #85BBF0
        color #000000
    }
    element "WebComponent" {
        background #F6B4AE
        color #000000
    }
    element "MobileComponent" {
        background #F2A1A6
        color #000000
    }
    element "LocalDatabase" {
        shape Cylinder
    }
    element "Topic" {
        shape Pipe
        background #CE93D8
        color #000000
    }
    element "Subscription" {
        shape RoundedBox
        background #E1BEE7
        color #000000
    }
    element "DLQ" {
        background #B71C1C
        color #ffffff
    }
    element "StorageComponent" {
        background #AECBFA
        color #000000
    }
    element "Infrastructure Node" {
        background #F3F4F6
        color #111827
    }
    element "Deployment Node" {
        color #374151
    }

    relationship "Relationship" {
        thickness 2
        color #4B5563
        routing Orthogonal
    }
    relationship "Logical" {
        style dashed
        color #9CA3AF
    }
    relationship "Asynchronous" {
        style dotted
    }
}

branding {
    font "Open Sans" https://fonts.googleapis.com/css?family=Open+Sans
}
