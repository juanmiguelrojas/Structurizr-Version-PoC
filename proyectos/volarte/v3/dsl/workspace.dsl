/*
 * =============================================================================
 *  VOLARTE · Architecture as Code (Structurizr DSL) · v3
 *  Terpel · Dirección de Arquitectura · Documento origen: Versión 1 · Fase I
 *
 *  v3 = espejo fiel del Draw.io (13 páginas): mismos elementos, textos, tipos,
 *  colores por página, siluetas de persona, boundaries, relaciones y disposición.
 *  Generado con scripts/drawio2structurizr.py desde
 *    proyectos/volarte/v1/fuente/Arquitectura_volarte_1.drawio
 *  usando el mapa curado proyectos/volarte/v3/fuente/mapeo-drawio.json.
 *
 *  Bitácora: proyectos/volarte/CHANGELOG_DSL.md · Revisión: v3/REVISION.md
 * =============================================================================
 */
workspace "Volarte" "Arquitectura Volarte (Terpel · Dirección de Arquitectura) — réplica fiel del Draw.io Versión 1 · Fase I, como modelo C4 en Structurizr." {

    !identifiers flat
    !impliedRelationships false

    properties {
        "volarte.version" "3.0.0"
        "volarte.fase" "I"
        "volarte.owner" "Terpel - Dirección de Arquitectura"
        "volarte.source" "Arquitectura_volarte_1.drawio"
        "aac.proyecto" "volarte"
        "aac.version" "v3"
        "aac.basadaEn" "v2"
        "aac.render" "c4-drawio"
    }

    model {
        !include model/personas.dsl
        !include model/sistemas.dsl
        !include model/portal.dsl
        !include model/volarte.dsl

        !include model/relaciones/L0_Referencia.dsl
        !include model/relaciones/L1_Context.dsl
        !include model/relaciones/L2_Container.dsl
        !include model/relaciones/L3_Frontend_Web.dsl
        !include model/relaciones/L3_App_Movil.dsl
        !include model/relaciones/L3_BFF_Web.dsl
        !include model/relaciones/L3_BFF_Movil.dsl
        !include model/relaciones/L3_Pub_Sub.dsl
        !include model/relaciones/L3_Documentos_GCS.dsl
        !include model/relaciones/L3_Svc_Usuarios_Auth.dsl
        !include model/relaciones/L3_Gestor_Documental.dsl
        !include model/relaciones/L3_Svc_Operacion.dsl
        !include model/relaciones/L3_Svc_Comercial.dsl
    }

    views {
        !include views/vistas.dsl
        !include views/styles.dsl
    }
}
