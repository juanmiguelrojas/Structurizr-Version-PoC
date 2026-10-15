#!/usr/bin/env python3
"""Genera un diagrama de despliegue de Volarte en GCP con notación ArchiMate 3.2
(librería oficial `archimate3` de draw.io) y marco/relaciones C4, al estilo de
GKE_2.drawio. Escribe el .drawio editable y el mxGraphModel que se envía al MCP.

Cada forma del modelo lleva `structurizrId` apuntando al elemento de
proyectos/volarte/v3 para mantener la trazabilidad modelo ↔ diagrama.
"""
from pathlib import Path
from xml.sax.saxutils import escape, quoteattr

OUT = Path(__file__).resolve().parent

# Estilos verbatim de la librería archimate3 de draw.io (ArchiMate 3.2).
AM = "html=1;outlineConnect=0;whiteSpace=wrap;shape=mxgraph.archimate3.application;archiType=square;"
STYLE = {
    "actor": AM + "appType=actor;fillColor=#ffff99;",
    "node": AM + "appType=node;fillColor=#AFFFAF;verticalAlign=top;align=left;spacingLeft=8;fontStyle=1;",
    "sysSw": AM + "appType=sysSw;fillColor=#AFFFAF;",
    "netw": AM + "appType=netw;fillColor=#AFFFAF;",
    "artifact": AM + "appType=artifact;fillColor=#AFFFAF;",
    "comp": AM + "appType=comp;fillColor=#99ffff;",
    "data": AM + "appType=passive;fillColor=#99ffff;",
    "grouping": AM + "appType=grouping;fillColor=none;dashed=1;verticalAlign=top;align=left;spacingLeft=8;fontStyle=1;",
}
SWIMLANE = "swimlane;html=1;fillColor=#ffffff;whiteSpace=wrap;strokeColor=#828282;align=left;verticalAlign=top;startSize=26;"
C4_BOUNDARY = ("rounded=1;fontSize=11;whiteSpace=wrap;html=1;dashed=1;arcSize=20;fillColor=none;strokeColor=#666666;"
               "fontColor=#333333;labelBackgroundColor=none;align=left;verticalAlign=bottom;spacing=10;dashPattern=8 4;"
               "metaEdit=1;rotatable=0;connectable=0;recursiveResize=0;pointerEvents=0;absoluteArcSize=1;")
C4_REL = ("endArrow=blockThin;html=1;fontSize=10;fontColor=#404040;strokeWidth=1;endFill=1;strokeColor=#828282;"
          "metaEdit=1;endSize=14;startSize=14;rounded=1;edgeStyle=orthogonalEdgeStyle;")

cells: list[str] = []
parent_of: dict[str, str] = {}


def shape(cid, label, kind, x, y, w, h, parent="1", sid=None, tech=None):
    attrs = {"id": cid, "label": escape(label) if not tech else
             f"&lt;b&gt;{escape(label)}&lt;/b&gt;&lt;br&gt;&lt;font style=&quot;font-size:10px&quot;&gt;[{escape(tech)}]&lt;/font&gt;",
             "archimateType": {"actor": "BusinessActor", "node": "Node", "sysSw": "SystemSoftware",
                               "netw": "CommunicationNetwork", "artifact": "Artifact", "comp": "ApplicationComponent",
                               "data": "DataObject", "grouping": "Grouping"}[kind]}
    parent_of[cid] = parent
    if sid:
        attrs["structurizrId"] = sid
    a = " ".join(f'{k}="{v}"' if k == "label" else f"{k}={quoteattr(v)}" for k, v in attrs.items())
    cells.append(f'<object {a}><mxCell style="{STYLE[kind]}" vertex="1" parent="{parent}">'
                 f'<mxGeometry x="{x}" y="{y}" width="{w}" height="{h}" as="geometry"/></mxCell></object>')


def lane(cid, label, x, y, w, h, parent="1"):
    parent_of[cid] = parent
    cells.append(f'<mxCell id="{cid}" value={quoteattr(label)} style="{SWIMLANE}" vertex="1" parent="{parent}">'
                 f'<mxGeometry x="{x}" y="{y}" width="{w}" height="{h}" as="geometry"/></mxCell>')


def ancestors(cid):
    chain = []
    while cid in parent_of:
        cid = parent_of[cid]
        chain.append(cid)
    return chain


def rel(cid, src, dst, desc="", dashed=False):
    # El conector vive en el contenedor común más interno (regla de draw.io; el MCP lo normaliza así).
    a, b = ancestors(src), set(ancestors(dst))
    parent = next(c for c in a if c in b)
    style = C4_REL + ("dashed=1;" if dashed else "")
    label = "&lt;b&gt;%c4Description%&lt;/b&gt;" if desc else ""
    cells.append(f'<object id="{cid}" placeholders="1" c4Type="Relationship" c4Description={quoteattr(desc)} label="{label}">'
                 f'<mxCell style="{style}" edge="1" parent="{parent}" source="{src}" target="{dst}">'
                 f'<mxGeometry relative="1" as="geometry"/></mxCell></object>')


# Marco C4 con bloque de título (igual que GKE_2.drawio).
cells.append(
    '<object id="marco" placeholders="1" c4Type="ContainerScopeBoundary" '
    'c4Name="Diagrama de Despliegue — Volarte en Google Cloud (ArchiMate 3.2)" '
    'c4Application="Arquitectura AaC · PoC draw.io MCP · 2026-10-15" '
    'label="&lt;font style=&quot;font-size: 16px&quot;&gt;&lt;b&gt;%c4Name%&lt;/b&gt;&lt;/font&gt;&lt;div&gt;[%c4Application%]&lt;/div&gt;">'
    f'<mxCell style="{C4_BOUNDARY}" vertex="1" parent="1"><mxGeometry x="0" y="0" width="2060" height="1240" as="geometry"/></mxCell></object>')

# Actores (capa de negocio).
shape("a_ext", "Usuario externo", "actor", 40, 80, 170, 70, sid="pe_usuarioExterno")
shape("a_int", "Empleado interno", "actor", 40, 380, 170, 70, sid="pe_empleadoInterno")
shape("a_ope", "Operario de equipo abastecedor", "actor", 40, 640, 170, 70, sid="pe_operarioDeEquipoAbastecedor")

# Borde / perímetro.
lane("perimetro", "Perímetro", 260, 40, 480, 760)
shape("cf", "Cloudflare", "node", 20, 40, 200, 110, "perimetro", "cloudflare")
shape("cf_waf", "WAF · bot · TLS", "sysSw", 20, 40, 160, 50, "cf")
shape("elb", "External Regional Load Balancer", "netw", 250, 60, 200, 70, "perimetro", "ss_externalRegionalLoadBalancer")
shape("fw", "Firewall (Palo Alto)", "node", 250, 190, 200, 90, "perimetro", "firewall")
shape("ztna", "ZTNA (Netskope)", "netw", 20, 330, 200, 70, "perimetro", "ztna")
shape("app", "App móvil", "comp", 20, 600, 200, 70, "perimetro", "vo_appMovil", "React Native · offline-first")

# Google Cloud.
lane("gcp", "Google Cloud · terpel-org-colombia", 780, 40, 1240, 1150)
lane("p_apigee", "terpel-gtic-apigee-AMB (dev-qa-prd)", 20, 40, 380, 200, "gcp")
shape("apigee", "Apigee", "node", 20, 40, 340, 140, "p_apigee", "apigee")
shape("apigee_px", "Api Manager · Proxy instance", "comp", 20, 40, 200, 60, "apigee", "proxyApigee")

lane("p_vol", "terpel-org-col-volarte-AMB (dev-qa-prd)", 20, 270, 1200, 860, "gcp")
shape("ilb", "Internal Load Balancer", "netw", 20, 50, 190, 70, "p_vol", "vo_internalLoadBalancer")
shape("run", "Cloud Run", "node", 240, 40, 700, 380, "p_vol")
comps = [
    ("c_web", "Frontend Web", "vo_frontendWeb", "React SPA"),
    ("c_bff", "BFF — Backend Volarte", "vo_bffBackendVolarte", "Cloud Run"),
    ("c_bffm", "BFF Móvil", "vo_bffMovil", "Cloud Run"),
    ("c_auth", "Svc: Usuarios / Auth", "vo_svcUsuariosAuth", "Cloud Run"),
    ("c_ope", "Svc: Operación", "vo_svcOperacion", "FastAPI"),
    ("c_com", "Svc: Comercial", "vo_svcComercial", "FastAPI"),
    ("c_dm", "Svc: Datos Maestros", "vo_svcDatosMaestros", "FastAPI"),
    ("c_gd", "Gestor Documental", "vo_gestorDocumental", "Cloud Run"),
]
for i, (cid, name, sid, tech) in enumerate(comps):
    shape(cid, name, "comp", 20 + (i % 4) * 170, 50 + (i // 4) * 150, 150, 80, "run", sid, tech)
shape("pubsub", "Pub/Sub", "node", 970, 40, 210, 200, "p_vol")
shape("cola", "Cola de mensajería", "sysSw", 20, 50, 170, 60, "pubsub", "vo_colaDeMensajeria")
shape("dlq", "Topics + DLQ", "artifact", 20, 125, 170, 55, "pubsub")

shape("sql", "Cloud SQL (PostgreSQL)", "node", 240, 470, 220, 150, "p_vol")
shape("sql_db", "BD Volarte", "data", 25, 60, 170, 60, "sql", "vo_cloudSqlPostgresql")
shape("redis", "Memorystore (Redis)", "node", 490, 470, 220, 150, "p_vol")
shape("redis_c", "Sesiones · Tokens · Queries", "data", 25, 60, 170, 60, "redis", "vo_memorystore")
shape("gcs", "Cloud Storage", "node", 740, 470, 220, 150, "p_vol")
shape("gcs_d", "Documentos (WORM)", "data", 25, 60, 170, 60, "gcs", "vo_documentosGcs")
shape("seg", "Seguridad", "grouping", 240, 660, 470, 170, "p_vol")
shape("kms", "Cloud KMS", "sysSw", 20, 60, 200, 70, "seg", "vo_cloudKms")
shape("sm", "Secret Manager", "sysSw", 245, 60, 200, 70, "seg", "vo_secretManager")
shape("obs", "Observabilidad", "grouping", 740, 660, 440, 170, "p_vol")
shape("otel", "OTel Collector → Dynatrace", "sysSw", 20, 60, 220, 70, "obs", "ss_dynatraceTenantTerpel")

# Externos.
lane("ext", "Servicios corporativos externos", 260, 840, 480, 350)
shape("entra", "Entra ID / CIAM", "node", 20, 40, 200, 120, "ext", "entraId")
shape("entra_c", "B2B · B2C CIAM", "comp", 20, 40, 160, 55, "entra")
shape("dl", "Datalake", "node", 250, 40, 200, 120, "ext", "datalake")
shape("pp", "PriceProvider externo", "comp", 20, 200, 200, 70, "ext", "ss_priceproviderExterno")

# Relaciones C4 (descripción = protocolo/propósito).
rel("r1", "a_ext", "cf", "HTTPS")
rel("r2", "cf", "elb", "Tráfico filtrado")
rel("r3", "elb", "fw", "TLS")
rel("r4", "a_int", "ztna", "Acceso Zero Trust")
rel("r5", "ztna", "ilb", "Túnel privado")
rel("r6", "a_ope", "app", "Usa")
rel("r7", "app", "apigee", "HTTPS + JWT")
rel("r8", "fw", "apigee", "HTTPS")
rel("r9", "apigee", "ilb", "mTLS")
rel("r10", "ilb", "c_bff", "HTTPS")
rel("r11", "ilb", "c_bffm", "HTTPS")
rel("r12", "c_bff", "cola", "Publica eventos", dashed=True)
rel("r13", "cola", "c_gd", "Entrega async", dashed=True)
rel("r14", "c_ope", "sql_db", "SQL/TLS")
rel("r15", "c_bff", "redis_c", "RESP/TLS")
rel("r16", "c_gd", "gcs_d", "Escribe (CMEK)")
rel("r17", "c_auth", "entra", "OIDC")
rel("r18", "c_com", "pp", "HTTPS")
rel("r19", "run", "otel", "OTLP", dashed=True)
rel("r20", "sql", "kms", "CMEK", dashed=True)
rel("r21", "cola", "dl", "Exporta", dashed=True)

model = ('<mxGraphModel adaptiveColors="auto" grid="1" gridSize="10" page="1" pageWidth="2100" pageHeight="1300">'
         '<root><mxCell id="0"/><mxCell id="1" parent="0"/>' + "".join(cells) + "</root></mxGraphModel>")

(OUT / "despliegue.mxgraph.xml").write_text(model, encoding="utf-8")
(OUT / "Volarte_Despliegue_GCP_ArchiMate32.drawio").write_text(
    '<mxfile host="AaC" agent="generar_despliegue.py" compressed="false">'
    f'<diagram id="dep-gcp" name="DEP · Producción GCP (ArchiMate 3.2)">{model}</diagram></mxfile>\n',
    encoding="utf-8")
print(f"{len(cells)} celdas")
