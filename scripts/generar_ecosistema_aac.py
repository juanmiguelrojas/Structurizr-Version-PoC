#!/usr/bin/env python3
"""Genera los diagramas draw.io AS-IS y TO-BE del ecosistema AaC (Hermes Agent + Azure DevOps + MCP).

Cada elemento conserva metadatos de trazabilidad: structurizrId, c4Type y archimateType.
Uso: python3 scripts/generar_ecosistema_aac.py [directorio_salida]
"""
import sys
from pathlib import Path
from xml.sax.saxutils import quoteattr

COLORS = {
    "Person": ("#083F75", "#06315C"),
    "SoftwareSystem": ("#1061B0", "#0D4E8D"),
    "Container": ("#23A2D9", "#0E7DAD"),
    "Component": ("#63BEF2", "#2086C9"),
    "ExternalPerson": ("#6C6477", "#4D4D4D"),
    "ExternalSystem": ("#8C8496", "#736782"),
    "Agent": ("#7B2CBF", "#4A1A73"),
}
ARCHIMATE = {
    "Person": "BusinessActor",
    "SoftwareSystem": "ApplicationComponent",
    "Container": "ApplicationComponent",
    "Component": "ApplicationFunction",
    "ExternalSystem": "ApplicationComponent",
    "Agent": "ApplicationComponent",
    "Boundary": "Grouping",
    "Relationship": "Flow",
}
TYPE_LABEL = {
    "Person": "Person",
    "SoftwareSystem": "Software System",
    "Container": "Container",
    "Component": "Component",
    "ExternalSystem": "External System",
    "Agent": "AI Agent",
}


class Diagram:
    def __init__(self, did, name, width, height):
        self.did, self.name, self.w, self.h = did, name, width, height
        self.cells = []

    def _obj(self, cid, attrs, style, geom, vertex=True, src=None, tgt=None, parent="1"):
        a = " ".join(f"{k}={quoteattr(str(v))}" for k, v in attrs.items())
        kind = 'vertex="1"' if vertex else f'edge="1" source="{src}" target="{tgt}"'
        self.cells.append(
            f'<object id="{cid}" {a}><mxCell style={quoteattr(style)} {kind} parent="{parent}">{geom}</mxCell></object>'
        )

    def boundary(self, cid, name, tech, x, y, w, h, color="#666666", sid=None):
        style = (
            "rounded=1;fontSize=12;whiteSpace=wrap;html=1;dashed=1;arcSize=20;fillColor=none;"
            f"strokeColor={color};strokeWidth=2;fontColor={color};labelBackgroundColor=none;align=left;"
            "verticalAlign=bottom;spacing=10;dashPattern=8 4;metaEdit=1;rotatable=0;connectable=0;"
            "recursiveResize=0;pointerEvents=0;absoluteArcSize=1;"
        )
        attrs = {
            "placeholders": "1", "c4Type": "SystemScopeBoundary", "c4Name": name, "c4Application": tech,
            "archimateType": ARCHIMATE["Boundary"], "structurizrId": sid or cid,
            "label": "<font style='font-size: 14px'><b>%c4Name%</b></font><div>[%c4Application%]</div>",
        }
        self._obj(cid, attrs, style, f'<mxGeometry x="{x}" y="{y}" width="{w}" height="{h}" as="geometry"/>')

    def node(self, cid, kind, name, tech, desc, x, y, w=240, h=120, sid=None):
        fill, stroke = COLORS[kind]
        c4Type = "Software System" if kind == "SoftwareSystem" else TYPE_LABEL[kind]
        attrs = {
            "placeholders": "1", "c4Name": name, "c4Type": c4Type, "c4Technology": tech,
            "c4Description": desc, "archimateType": ARCHIMATE[kind], "structurizrId": sid or cid,
        }
        if kind == "Person":
            style = (
                "html=1;fontSize=11;dashed=0;whiteSpace=wrap;fillColor=%s;strokeColor=%s;fontColor=#ffffff;"
                "shape=mxgraph.c4.person2;align=center;metaEdit=1;points=[[0.5,0,0],[1,0.5,0],[1,0.75,0],"
                "[0.75,1,0],[0.5,1,0],[0.25,1,0],[0,0.75,0],[0,0.5,0]];resizable=0;" % (fill, stroke)
            )
            attrs["label"] = ("<font style='font-size: 14px'><b>%c4Name%</b></font><div>[%c4Type%]</div><br>"
                              "<div><font style='font-size: 10px'>%c4Description%</font></div>")
            w, h = 200, 180
        else:
            extra = ""
            if kind == "Agent":
                extra = "strokeWidth=3;"
            style = (
                f"rounded=1;whiteSpace=wrap;html=1;labelBackgroundColor=none;fillColor={fill};fontColor=#ffffff;"
                f"align=center;arcSize=10;strokeColor={stroke};metaEdit=1;resizable=1;fontSize=11;{extra}"
                "points=[[0.25,0,0],[0.5,0,0],[0.75,0,0],[1,0.25,0],[1,0.5,0],[1,0.75,0],[0.75,1,0],"
                "[0.5,1,0],[0.25,1,0],[0,0.75,0],[0,0.5,0],[0,0.25,0]];"
            )
            tech_part = ": %c4Technology%" if tech else ""
            attrs["label"] = ("<font style='font-size: 14px'><b>%c4Name%</b></font><div>[%c4Type%" + tech_part +
                              "]</div><br><div><font style='font-size: 10px'>%c4Description%</font></div>")
        self._obj(cid, attrs, style, f'<mxGeometry x="{x}" y="{y}" width="{w}" height="{h}" as="geometry"/>')

    def rel(self, cid, src, tgt, desc, tech="", both=False, dashed=False, color="#828282", points=None):
        style = (
            "endArrow=blockThin;html=1;fontSize=10;fontColor=#404040;strokeWidth=1;endFill=1;"
            f"strokeColor={color};elbow=vertical;metaEdit=1;endSize=14;startSize=14;jumpStyle=arc;"
            "jumpSize=16;rounded=0;edgeStyle=orthogonalEdgeStyle;labelBackgroundColor=#FFFFFF;"
        )
        if both:
            style += "startArrow=blockThin;startFill=1;"
        if dashed:
            style += "dashed=1;"
        attrs = {
            "placeholders": "1", "c4Type": "Relationship", "c4Description": desc, "c4Technology": tech,
            "archimateType": ARCHIMATE["Relationship"], "structurizrId": cid,
            "label": "<div style='text-align: left'><div style='text-align: center'><b>%c4Description%</b></div>"
                     + ("<div style='text-align: center'>[%c4Technology%]</div>" if tech else "") + "</div>",
        }
        pts = ""
        if points:
            pts = '<Array as="points">' + "".join(f'<mxPoint x="{px}" y="{py}"/>' for px, py in points) + "</Array>"
        self._obj(cid, attrs, style, f'<mxGeometry relative="1" as="geometry">{pts}</mxGeometry>',
                  vertex=False, src=src, tgt=tgt)

    def text(self, cid, html, x, y, w, h, size=12):
        self.cells.append(
            f'<mxCell id="{cid}" value={quoteattr(html)} style="text;html=1;whiteSpace=wrap;align=left;'
            f'verticalAlign=top;fontSize={size};fontColor=#333333;" vertex="1" parent="1">'
            f'<mxGeometry x="{x}" y="{y}" width="{w}" height="{h}" as="geometry"/></mxCell>'
        )

    def legend(self, x, y, items):
        self.text("leg_t", "<b>Leyenda C4</b>", x, y, 200, 20)
        for i, (label, fill, dashed) in enumerate(items):
            yy = y + 26 + i * 30
            style = (f"rounded=1;html=1;fontSize=10;fontColor=#ffffff;fillColor={fill};strokeColor={fill};"
                     if not dashed else
                     f"rounded=1;html=1;fontSize=10;fontColor={fill};fillColor=none;dashed=1;strokeWidth=2;strokeColor={fill};")
            self.cells.append(
                f'<mxCell id="leg_{i}" value={quoteattr(label)} style={quoteattr(style)} vertex="1" parent="1">'
                f'<mxGeometry x="{x}" y="{yy}" width="200" height="24" as="geometry"/></mxCell>'
            )

    def xml(self):
        body = "".join(self.cells)
        return (
            '<mxfile host="AaC" agent="generar_ecosistema_aac.py" compressed="false">'
            f'<diagram id="{self.did}" name={quoteattr(self.name)}>'
            f'<mxGraphModel grid="1" gridSize="10" page="1" pageWidth="{self.w}" pageHeight="{self.h}">'
            f'<root><mxCell id="0"/><mxCell id="1" parent="0"/>{body}</root></mxGraphModel></diagram></mxfile>\n'
        )


LEGEND_BASE = [
    ("Person", COLORS["Person"][0], False),
    ("Software System", COLORS["SoftwareSystem"][0], False),
    ("Container", COLORS["Container"][0], False),
    ("Component", COLORS["Component"][0], False),
    ("External System", COLORS["ExternalSystem"][0], False),
]


def as_is():
    d = Diagram("aac-as-is", "AS-IS · Ecosistema AaC actual", 1760, 1080)
    d.text("titulo", "<b style='font-size:20px'>AS-IS · Ecosistema Architecture-as-Code (Volarte / Terpel)</b>"
           "<br>Workstations locales, edición manual, GitHub Actions estático y carga manual a SharePoint",
           40, 10, 1200, 50)

    d.node("p_arquitecto", "Person", "Arquitecto de Software", "",
           "Edita DSL y .drawio localmente, hace git push, revisa REVISION.md y sube entregables a mano",
           40, 330)

    d.boundary("b_workstation", "Workstation del Arquitecto", "Local Environment", 300, 80, 560, 640)
    d.node("c_dsl_local", "Container", "Structurizr DSL Local", "Archivos .dsl",
           "Modelo C4 editado manualmente en disco local", 330, 120, 240, 120)
    d.node("c_drawio_desktop", "Container", "Draw.io Desktop App", "Electron",
           "Creación manual de diagramas .drawio", 600, 120, 230, 120)
    d.node("cmp_pipeline_local", "Component", "Pipeline Local", "scripts/aac-build.sh",
           "Ejecuta drawio_inventory.py, drawio2structurizr.py, c4_scene.py, render-c4.mjs",
           330, 320, 500, 120)
    d.node("c_reviewer_local", "Container", "Agente Revisor Local", "architecture_reviewer.py",
           "Aplica reglas estáticas R1-R9 en la máquina local", 330, 520, 500, 120)

    d.boundary("b_github", "Repositorio GitHub", "main / Pull Requests", 920, 80, 400, 640)
    d.node("s_github_repo", "SoftwareSystem", "GitHub Repository", "juanmiguelrojas/Structurizr-Version-PoC",
           "Versiones manuales v1/, v2/, v3/. version.json y CHANGELOG_DSL.md mantenidos a mano",
           950, 120, 340, 150)
    d.node("c_gh_actions", "Container", "GitHub Actions CI/CD Pipeline", "Runner ubuntu-latest",
           "Ejecuta aac-build.sh: validar DSL, exportar, revisar R1-R9, renderizar PDF/PNG",
           950, 420, 340, 150)

    d.boundary("b_registro", "Registro Corporativo / Documentación", "Entregables", 1380, 80, 340, 640)
    d.node("c_docs", "Container", "Documentos PDF / Markdown Generados", "PDF, SVG, REVISION.md",
           "REVISION.md con REV-01 a REV-14 pendientes de firma manual", 1410, 120, 280, 150)
    d.node("x_sharepoint", "ExternalSystem", "SharePoint Corporativo", "Microsoft 365",
           "Recibe la carga manual de entregables", 1410, 420, 280, 150)

    d.rel("r1", "p_arquitecto", "c_dsl_local", "Modifica DSL manualmente", "Editor local",
          points=[(280, 420), (280, 180)])
    d.rel("r2", "p_arquitecto", "c_drawio_desktop", "Dibuja .drawio manualmente", "",
          points=[(140, 70), (715, 70)])
    d.rel("r3", "c_dsl_local", "cmp_pipeline_local", "Ejecuta aac-build.sh localmente", "bash / Python / Node")
    d.rel("r3b", "c_drawio_desktop", "cmp_pipeline_local", "Insumo .drawio", "")
    d.rel("r4", "cmp_pipeline_local", "c_reviewer_local", "Invoca revisión R1-R9", "python")
    d.rel("r5", "p_arquitecto", "s_github_repo", "git push a PR", "git / HTTPS",
          points=[(140, 760), (890, 760), (890, 195)])
    d.rel("r6", "s_github_repo", "c_gh_actions", "Desencadena workflow en PR", "GitHub webhook")
    d.rel("r7", "c_gh_actions", "c_docs", "Genera PDF/SVG y reporta fallos de reglas estáticas", "artifacts",
          points=[(1350, 495), (1350, 195)])
    d.rel("r8", "p_arquitecto", "c_docs", "Revisa REVISION.md manualmente", "",
          points=[(100, 820), (1705, 820), (1705, 195)], dashed=True)
    d.rel("r9", "c_docs", "x_sharepoint", "Arquitecto sube archivos manualmente", "Carga web", dashed=True)

    d.legend(40, 870, LEGEND_BASE)
    d.text("nota", "<b>Puntos de dolor:</b> dependencia de workstation local, versionado y CHANGELOG manual, "
           "reglas estáticas sin contexto, firma REV-01..14 manual, carga manual a SharePoint (sin hash ni auditoría).",
           300, 880, 1400, 50)
    return d


def to_be():
    d = Diagram("aac-to-be", "TO-BE · Hermes Agent + Azure DevOps + MCP", 1820, 1240)
    d.text("titulo", "<b style='font-size:20px'>TO-BE · Ecosistema AaC con Hermes Agent, Azure DevOps y MCP</b>"
           "<br>Sin workstations: ciclo 100% en la nube con el Arquitecto In-The-Loop como autoridad de gobierno",
           40, 10, 1300, 50)

    d.node("p_arquitecto_itl", "Person", "Arquitecto de Arquitectura Corporativa (In-The-Loop)", "",
           "Interactúa solo vía ADO PR Threads / Web UI / Chat. Aprueba REV-01..14 y las Approval Gates",
           820, 70)

    # Frontera 1: Azure DevOps
    d.boundary("b_ado", "Azure DevOps Cloud Platform", "Azure DevOps Services", 40, 300, 460, 760, color="#0078D4")
    d.node("c_ado_repos", "Container", "Azure Repos", "Git",
           "proyectos/volarte/v4/. Rama main protegida con políticas CODEOWNERS", 80, 340, 380, 140)
    d.node("c_ado_pipelines", "Container", "Azure Pipelines", "YAML multi-stage",
           "Stage 1: Validation & Hermes Swarm Execution<br>Stage 2: ArchitectApprovalGate (Manual Validation)"
           "<br>Stage 3: Publish & Audit", 80, 560, 380, 180)
    d.node("c_ado_boards", "Container", "ADO Boards / Work Items", "Azure Boards",
           "Vinculación automática AB#1234 con commits y PR", 80, 820, 380, 140)

    # Frontera 2: Hermes Swarm
    d.boundary("b_hermes", "Hermes Agent Swarm", "Orquestación agéntica", 580, 300, 740, 500, color="#7B2CBF")
    d.node("s_hermes", "Agent", "Hermes Agent Orchestrator", "Serverless / Container Runner",
           "Coordina el enjambre de sub-agentes y el contexto MCP", 790, 340, 320, 120)
    d.node("a_traceability", "Agent", "Agent 1: Traceability Agent", "Hermes sub-agent",
           "Mantiene CHANGELOG_DSL.md (R4) y version.json (R8) de forma autónoma", 640, 500, 300, 120)
    d.node("a_governance", "Agent", "Agent 2: Architecture Governance Agent", "Hermes sub-agent",
           "Revisa R1-R12 (architecture_reviewer.py), SPOFs y seguridad; propone parches en el PR",
           970, 500, 300, 120)
    d.node("a_sync", "Agent", "Agent 3: Diagram & MCP Sync Agent", "Hermes sub-agent",
           "Sincroniza Structurizr DSL y .drawio XML sin perder IDs de trazabilidad", 640, 650, 300, 120)
    d.node("a_audit", "Agent", "Agent 4: Audit & SharePoint Agent", "Hermes sub-agent",
           "Firma SHA-256 los paquetes aprobados y reconcilia drift", 970, 650, 300, 120)

    # Frontera 3: MCP
    d.boundary("b_mcp", "Capa de Integración MCP", "Model Context Protocol", 580, 880, 1060, 220)
    d.node("m_structurizr", "Container", "mcp-structurizr", "MCP Server",
           "Parser DSL, árbol de modelo, diffs semánticos", 610, 920, 230, 130)
    d.node("m_drawio", "Container", "mcp-drawio", "MCP Server",
           "Render C4 / ArchiMate 3.2, inyección de structurizrId", 870, 920, 230, 130)
    d.node("m_ado", "Container", "mcp-azure-devops", "MCP Server",
           "Comentarios en hilos de PR, actualización de Work Items", 1130, 920, 230, 130)
    d.node("m_sharepoint", "Container", "mcp-sharepoint-graph", "MCP Server · Microsoft Graph",
           "Escritura vía Graph API con OIDC, sin secretos persistentes", 1390, 920, 230, 130)

    # Frontera 4: Registro inmutable
    d.boundary("b_registro", "Registro Corporativo Inmutable", "SharePoint / M365", 1400, 300, 380, 500)
    d.node("x_sharepoint", "ExternalSystem", "SharePoint Corporate Architecture Repository", "SharePoint Online + Purview",
           "Biblioteca de entregables con SHA-256 e historial de aprobación. Purview declara Records inmutables",
           1430, 340, 320, 180)

    # Relaciones
    d.rel("t1", "p_arquitecto_itl", "c_ado_repos", "Crea/modifica DSL desde ADO Web o Git Cloud", "HTTPS / git",
          points=[(270, 160)])
    d.rel("t2", "c_ado_repos", "c_ado_pipelines", "Desencadena pipeline en PR", "PR trigger")
    d.rel("t3", "c_ado_pipelines", "s_hermes", "Stage 1: ejecuta Hermes Swarm", "Container job",
          points=[(550, 650), (550, 370)])
    d.rel("t4", "s_hermes", "m_structurizr", "Parsea y valida semántica", "MCP",
          points=[(600, 450), (600, 840), (700, 840)], color="#7B2CBF")
    d.rel("t5", "a_traceability", "c_ado_repos", "Escribe CHANGELOG_DSL.md y version.json", "git commit al PR",
          points=[(530, 530), (530, 410)], color="#7B2CBF")
    d.rel("t6", "a_sync", "m_drawio", "Genera diagramas C4 / ArchiMate 3.2 (despliegue GCP)", "MCP",
          color="#7B2CBF", points=[(790, 860), (985, 860)])
    d.rel("t7", "a_governance", "m_ado", "Comenta violaciones de reglas o preguntas", "MCP",
          color="#7B2CBF", points=[(1305, 560), (1305, 890), (1245, 890)])
    d.rel("t8", "m_ado", "c_ado_pipelines", "Publica en hilo de PR / estado", "ADO REST API",
          points=[(1245, 1140), (520, 1140), (520, 700)])
    d.rel("t9", "m_ado", "c_ado_boards", "Actualiza Work Items AB#", "ADO REST API",
          points=[(1200, 1170), (270, 1170)])
    d.rel("t10", "p_arquitecto_itl", "c_ado_pipelines", "Responde en hilo del PR / aprueba ArchitectApprovalGate",
          "ADO Web / Chat", both=True, color="#083F75", points=[(920, 280), (510, 280), (510, 600)])
    d.rel("t11", "a_audit", "m_sharepoint", "Al fusionar a main: SHA-256 y registro oficial", "MCP",
          color="#7B2CBF", points=[(1120, 870), (1505, 870)])
    d.rel("t12", "m_sharepoint", "x_sharepoint", "Registra versión inmutable", "Microsoft Graph · OIDC",
          points=[(1660, 985), (1660, 520)])
    d.rel("t13", "s_hermes", "a_traceability", "Delega", "", dashed=True, color="#7B2CBF")
    d.rel("t14", "s_hermes", "a_governance", "Delega", "", dashed=True, color="#7B2CBF")
    d.rel("t15", "s_hermes", "a_sync", "Delega", "", dashed=True, color="#7B2CBF", points=[(620, 420), (620, 710)])
    d.rel("t16", "s_hermes", "a_audit", "Delega", "", dashed=True, color="#7B2CBF", points=[(1285, 430), (1285, 710)])

    d.legend(1460, 40, LEGEND_BASE + [
        ("Hermes Agent / AI Agent", COLORS["Agent"][0], False),
        ("Frontera Azure DevOps", "#0078D4", True),
    ])
    return d


def main():
    out = Path(sys.argv[1] if len(sys.argv) > 1 else "docs/ecosistema-aac")
    out.mkdir(parents=True, exist_ok=True)
    (out / "AaC_AS-IS.drawio").write_text(as_is().xml(), encoding="utf-8")
    (out / "AaC_TO-BE_Hermes.drawio").write_text(to_be().xml(), encoding="utf-8")
    print(f"Diagramas generados en {out}/")


if __name__ == "__main__":
    main()
