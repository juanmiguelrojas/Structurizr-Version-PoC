#!/usr/bin/env python3
"""
Escenas de dibujo C4 y validación de fidelidad contra el Draw.io.

Para cada vista construye dos "escenas" (lo que se dibuja: cajas, boundaries, notas,
conectores, textos y colores) a partir de fuentes independientes:

  * escena MODELO  = workspace.json exportado por structurizr-cli (DSL) + dsl/layout/<vista>.json
  * escena DRAWIO  = inventario del Draw.io original (página equivalente)

scripts/render-c4.mjs dibuja ambas con el mismo motor, de modo que cualquier diferencia
visual entre la arquitectura publicada (v3) y el Draw.io proviene del MODELO. La
comparación de ambas escenas produce el informe de fidelidad (regla R9 del Agente Revisor).

Uso:
  python3 scripts/c4_scene.py --workspace W.json --layouts DIR [--inventario INV.json]
                              --out DIR [--fidelidad DIR_REPORTE]
"""
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

LEGEND_COLORS = {
    "Person": ("#083F75", "#06315C"), "Software System": ("#1061B0", "#0D5091"),
    "Container": ("#23A2D9", "#0E7DAD"), "Component": ("#63BEF2", "#2086C9"),
    "External Person": ("#6C6477", "#4D4D57"), "External Software System": ("#8C8496", "#736782"),
}
DEFAULT_TYPE = {"Person": "Person", "SoftwareSystem": "Software System", "Container": "Container",
                "Component": "Component", "CustomElement": ""}


def one(text: str | None) -> str:
    """Normaliza solo formato (no contenido): blancos múltiples y espacio antes de '[tecnología]'."""
    text = re.sub(r"\s+", " ", (text or "").replace("\u00a0", " ")).strip()
    return re.sub(r"\s*\[", " [", text).strip()


def style_get(style: str, key: str, default=None):
    m = re.search(r"(?:^|;)" + re.escape(key) + r"=([^;]*)", style or "")
    return m.group(1) if m else default


# ------------------------------------------------------------------ modelo Structurizr
class Workspace:
    def __init__(self, path: Path):
        self.data = json.loads(path.read_text(encoding="utf-8"))
        self.by_ident, self.kind, self.rels = {}, {}, []
        model = self.data["model"]

        def reg(el, kind):
            ident = str((el.get("properties") or {}).get("structurizr.dsl.identifier", el["id"])).lower()
            self.by_ident[ident] = el
            self.kind[el["id"]] = kind
            self.rels.extend(el.get("relationships") or [])
            for c in el.get("containers") or []:
                reg(c, "Container")
            for c in el.get("components") or []:
                reg(c, "Component")

        for p in model.get("people") or []:
            reg(p, "Person")
        for s in model.get("softwareSystems") or []:
            reg(s, "SoftwareSystem")
        for c in model.get("customElements") or []:
            reg(c, "CustomElement")
        self.by_id = {e["id"]: e for e in self.by_ident.values()}
        self.ident_of = {e["id"]: i for i, e in self.by_ident.items()}
        self.rel_by_id = {r["id"]: r for r in self.rels}
        self.views = {}
        for vlist in self.data.get("views", {}).values():
            if isinstance(vlist, list):
                for v in vlist:
                    if "key" in v:
                        self.views[v["key"]] = v

    def get(self, ident: str):
        return self.by_ident.get((ident or "").lower())

    def texts(self, ident: str) -> dict:
        el = self.get(ident)
        props = el.get("properties") or {}
        kind = self.kind[el["id"]]
        return {"nombre": el.get("name", ""),
                "tipo": props.get("c4.tipo") or (el.get("metadata") if kind == "CustomElement" else DEFAULT_TYPE[kind]),
                "tecnologia": el.get("technology") or props.get("c4.tecnologia", ""),
                "descripcion": el.get("description", "")}


def type_line(tipo: str, tech: str) -> str:
    if not tipo and not tech:
        return ""
    return "[" + (tipo or "") + (f": {tech}" if tech else "") + "]"


def fill_for(clase: str | None, style: str) -> tuple[str, str]:
    if clase in LEGEND_COLORS:
        fill, stroke = LEGEND_COLORS[clase]
        return fill, style_get(style, "strokeColor", stroke) or stroke
    return style_get(style, "fillColor", "none") or "none", style_get(style, "strokeColor", "none") or "none"


def base_scene(layout: dict) -> dict:
    return {"vista": layout["vista"], "pagina": layout["pagina"], "titulo": layout["titulo"],
            "boundaries": [{"id": b["drawioId"], "x": b["x"], "y": b["y"], "w": b["w"], "h": b["h"],
                            "nombre": b["nombre"], "etiqueta": b["etiqueta"], "style": b["style"]}
                           for b in layout["boundaries"]],
            "notas": [{"id": n["drawioId"], "x": n["x"], "y": n["y"], "w": n["w"], "h": n["h"],
                       "texto": n["texto"], "style": n.get("style", ""), "forma": n.get("forma"),
                       "fuente": n.get("fuente", {})}
                      for n in layout["notas"]],
            "nodos": [], "conectores": []}


def node_from(n: dict, t: dict, desc_lines: list[str]) -> dict:
    fill, stroke = fill_for(n.get("clase"), n.get("style", ""))
    return {"id": n["drawioId"], "ref": n.get("ref"), "x": n["x"], "y": n["y"], "w": n["w"], "h": n["h"],
            "forma": n["forma"], "fill": fill, "stroke": stroke, "clase": n.get("clase"),
            "fuentes": n.get("fuentes") or {}, "style": n.get("style", ""),
            "nombre": t["nombre"], "tipo": t["tipo"], "tecnologia": t["tecnologia"],
            "tipoLinea": type_line(t["tipo"], t["tecnologia"]), "descripcion": one(t["descripcion"]),
            "descripcionLineas": desc_lines}


def lines_for(model_text: str, drawio_raw: str) -> list[str]:
    """Usa los saltos de línea del Draw.io solo si el texto del modelo es el mismo (formato, no contenido)."""
    if drawio_raw and one(drawio_raw) == one(model_text):
        return [l for l in drawio_raw.split("\n") if l.strip()]
    return [model_text] if model_text else []


def edge_from(c: dict, label_lines: list[str], label: str) -> dict:
    return {"id": c["drawioId"], "origen": c["origen"], "destino": c["destino"], "puntos": c["puntos"],
            "origenTipo": c.get("origenTipo"), "destinoTipo": c.get("destinoTipo"),
            "extremos": c.get("extremos", {}), "estilo": c.get("estilo", ""), "estiloEtiqueta": c.get("estiloEtiqueta", ""),
            "posEtiqueta": c.get("posEtiqueta", {}), "fuenteEtiqueta": c.get("fuenteEtiqueta", {}),
            "etiqueta": label, "etiquetaLineas": label_lines,
            "anotacion": not c["relaciones"]}


# ------------------------------------------------------------------ escenas
def model_scene(ws: Workspace, layout: dict, issues: list) -> dict:
    scene = base_scene(layout)
    scene["leyenda"] = True
    # La tabla 'Legend' dibujada a mano en el Draw.io (colores aproximados) se sustituye por la leyenda
    # oficial C4 en la misma posición.
    table = next((n for n in scene["notas"] if n.get("forma") == "table" and n["texto"].strip() == "Legend"), None)
    if table:
        scene["leyendaEn"] = {"x": table["x"], "y": table["y"], "w": table["w"]}
        legend_names = {"Person", "Software System", "Container", "Component", "External Person", "External Software System"}
        scene["notas"] = [n for n in scene["notas"] if n is not table and not
                          (n.get("forma") == "partialRectangle" and n["texto"].strip() in legend_names)]
    view = ws.views.get(layout["vista"])
    if not view:
        issues.append({"tipo": "ERROR", "regla": "vista", "detalle": f"La vista {layout['vista']} no existe en el workspace."})
        return scene
    in_view = {ws.ident_of.get(e["id"]) for e in view.get("elements", [])}
    for n in layout["nodos"]:
        if not ws.get(n["ref"]) or n["ref"].lower() not in in_view:
            issues.append({"tipo": "ERROR", "regla": "elemento", "drawioId": n["drawioId"],
                           "detalle": f"'{n['ref']}' no está en la vista Structurizr."})
            continue
        t = ws.texts(n["ref"])
        over = n.get("texto") or {}
        t = {k: over.get(k, t[k]) for k in t}
        if n["forma"] == "nota":
            t = {**t, "tipo": ""}
            nd = node_from(n, t, lines_for(t["descripcion"], "\n".join(n.get("textoDrawio", "").split("\n")[1:])))
            nd["fuenteNota"] = n.get("fuente", {})
            nd["textoNota"] = [t["nombre"]] + nd["descripcionLineas"]
        else:
            nd = node_from(n, t, lines_for(t["descripcion"], n.get("descripcionDrawio", "")))
        nd["alias"] = sorted(over)
        scene["nodos"].append(nd)
    view_rels = {r["id"] for r in view.get("relationships", [])}
    covered = set()
    for c in layout["conectores"]:
        found = []
        for r in c["relaciones"]:
            src, dst = ws.get(r["origen"]), ws.get(r["destino"])
            match = next((x for x in ws.rels if src and dst and x["sourceId"] == src["id"] and x["destinationId"] == dst["id"]
                          and one(x.get("description")) == one(r["descripcion"]) and one(x.get("technology")) == one(r["tecnologia"])), None)
            if not match or match["id"] not in view_rels:
                issues.append({"tipo": "ERROR", "regla": "relacion", "drawioId": c["drawioId"],
                               "detalle": f"Relación {r['origen']} -> {r['destino']} '{r['descripcion']}' no está en la vista."})
            else:
                found.append(match)
                covered.add(match["id"])
        if c["relaciones"] and not found:
            continue
        if found:
            r0 = found[0]
            label = one(r0.get("description")) + (f" [{one(r0.get('technology'))}]" if r0.get("technology") else "")
        else:
            label = c["etiqueta"]
        scene["conectores"].append(edge_from(c, lines_for(label, c.get("etiquetaLineas", "")), label))
    for rid in view_rels - covered:
        r = ws.rel_by_id.get(rid, {})
        issues.append({"tipo": "ERROR", "regla": "relacion-extra",
                       "detalle": f"La vista incluye la relación {ws.ident_of.get(r.get('sourceId'))} -> "
                                  f"{ws.ident_of.get(r.get('destinationId'))} '{r.get('description')}' que no está dibujada en el Draw.io."})
    return scene


def drawio_scene(layout: dict, page: dict) -> dict:
    scene = base_scene(layout)
    scene["leyenda"] = False
    els = {e["id"]: e for e in page["elements"]}
    for n in layout["nodos"]:
        if n["forma"] == "nota":
            note = next(x for x in page["notes"] if x["id"] == n["drawioId"])
            lines = [l for l in note["text"].split("\n") if l.strip()]
            nd = node_from(n, {"nombre": lines[0] if lines else "", "tipo": "", "tecnologia": "",
                               "descripcion": " ".join(lines[1:])}, lines[1:])
            nd["textoNota"] = lines
            nd["fuenteNota"] = n.get("fuente", {})
        else:
            e = els[n["drawioId"]]
            nd = node_from(n, {"nombre": e["name"], "tipo": e["type"], "tecnologia": e.get("technology", ""),
                               "descripcion": e.get("description", "")},
                           [l for l in e.get("descriptionRaw", "").split("\n") if l.strip()])
        scene["nodos"].append(nd)
    for c in layout["conectores"]:
        scene["conectores"].append(edge_from({**c, "relaciones": c["relaciones"] or [None]},
                                             [l for l in c.get("etiquetaLineas", "").split("\n") if l.strip()],
                                             c["etiqueta"]))
        scene["conectores"][-1]["anotacion"] = False
    return scene


# ------------------------------------------------------------------ fidelidad
def compare(model: dict, drawio: dict, issues: list) -> dict:
    mn = {n["id"]: n for n in model["nodos"]}
    dn = {n["id"]: n for n in drawio["nodos"]}
    res = {"elementos": len(dn), "elementosPresentes": 0, "textosIguales": 0, "coloresIguales": 0,
           "formasIguales": 0, "conectores": len(drawio["conectores"]), "conectoresPresentes": 0,
           "etiquetasIguales": 0, "alias": 0, "anotaciones": 0, "diferencias": []}
    for i, d in dn.items():
        m = mn.get(i)
        if not m:
            res["diferencias"].append({"tipo": "ERROR", "drawioId": i, "campo": "elemento",
                                       "drawio": d["nombre"], "modelo": "(ausente)"})
            continue
        res["elementosPresentes"] += 1
        same = True
        for campo in ("nombre", "tipo", "tecnologia", "descripcion"):
            if one(m.get(campo)) != one(d.get(campo)):
                same = False
                res["diferencias"].append({"tipo": "ERROR", "drawioId": i, "campo": campo,
                                           "drawio": d.get(campo), "modelo": m.get(campo)})
        res["textosIguales"] += same
        if m["fill"].upper() == d["fill"].upper():
            res["coloresIguales"] += 1
        else:
            res["diferencias"].append({"tipo": "ERROR", "drawioId": i, "campo": "color",
                                       "drawio": d["fill"], "modelo": m["fill"]})
        res["formasIguales"] += m["forma"] == d["forma"]
        if m.get("alias"):
            res["alias"] += 1
    mc = {c["id"]: c for c in model["conectores"]}
    for c in drawio["conectores"]:
        m = mc.get(c["id"])
        if not m:
            res["diferencias"].append({"tipo": "ERROR", "drawioId": c["id"], "campo": "conector",
                                       "drawio": c["etiqueta"], "modelo": "(ausente)"})
            continue
        res["conectoresPresentes"] += 1
        if m["anotacion"]:
            res["anotaciones"] += 1
        if one(m["etiqueta"]) == one(c["etiqueta"]):
            res["etiquetasIguales"] += 1
        else:
            res["diferencias"].append({"tipo": "ERROR", "drawioId": c["id"], "campo": "etiqueta",
                                       "drawio": c["etiqueta"], "modelo": m["etiqueta"]})
    res["diferencias"] += issues
    total = res["elementos"] * 3 + res["conectores"] * 2
    ok = res["elementosPresentes"] + res["textosIguales"] + res["coloresIguales"] + res["conectoresPresentes"] + res["etiquetasIguales"]
    res["fidelidad"] = round(100.0 * ok / total, 1) if total else 100.0
    return res


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--workspace", type=Path, required=True)
    ap.add_argument("--layouts", type=Path, required=True)
    ap.add_argument("--inventario", type=Path)
    ap.add_argument("--out", type=Path, required=True)
    ap.add_argument("--fidelidad", type=Path)
    args = ap.parse_args()
    ws = Workspace(args.workspace)
    inv = json.loads(args.inventario.read_text(encoding="utf-8")) if args.inventario else None
    args.out.mkdir(parents=True, exist_ok=True)
    report = []
    for lf in sorted(args.layouts.glob("*.json")):
        layout = json.loads(lf.read_text(encoding="utf-8"))
        issues: list = []
        ms = model_scene(ws, layout, issues)
        (args.out / f"{layout['vista']}.modelo.json").write_text(json.dumps(ms, ensure_ascii=False), encoding="utf-8")
        if inv:
            page = next(p for p in inv["pages"] if p["name"] == layout["pagina"])
            ds = drawio_scene(layout, page)
            (args.out / f"{layout['vista']}.drawio.json").write_text(json.dumps(ds, ensure_ascii=False), encoding="utf-8")
            res = compare(ms, ds, issues)
            report.append({"vista": layout["vista"], "pagina": layout["pagina"], **res})
    if args.fidelidad and report:
        write_report(args.fidelidad, report)


def write_report(out: Path, report: list):
    out.mkdir(parents=True, exist_ok=True)
    (out / "fidelidad-drawio.json").write_text(json.dumps(report, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
    tot = {k: sum(r[k] for r in report) for k in ("elementos", "elementosPresentes", "textosIguales", "coloresIguales",
                                                    "formasIguales", "conectores", "conectoresPresentes",
                                                    "etiquetasIguales", "alias", "anotaciones")}
    errors = sum(1 for r in report for d in r["diferencias"] if d["tipo"] == "ERROR")
    md = ["# Informe de fidelidad · Structurizr vs Draw.io", "",
          "Compara, página por página, lo que dibuja la versión publicada (modelo Structurizr + presentación) con el",
          "Draw.io original. Ambas escenas se dibujan con el mismo motor (`scripts/render-c4.mjs`): toda diferencia",
          "proviene del modelo.", "",
          f"- **Resultado:** {'✅ FIEL' if errors == 0 else '❌ CON DIFERENCIAS'} · {errors} diferencia(s) bloqueante(s)",
          f"- **Elementos:** {tot['elementosPresentes']}/{tot['elementos']} presentes · {tot['textosIguales']} textos idénticos · "
          f"{tot['coloresIguales']} colores idénticos · {tot['formasIguales']} formas idénticas",
          f"- **Conectores:** {tot['conectoresPresentes']}/{tot['conectores']} presentes · {tot['etiquetasIguales']} etiquetas idénticas · "
          f"{tot['anotaciones']} anotaciones de presentación (sin relación de modelo)",
          f"- **Textos de presentación (alias):** {tot['alias']} elementos muestran en alguna página un texto distinto al del modelo, "
          "tal como lo hace el Draw.io (ver `fuente/trazabilidad.json`).", "",
          "| Vista | Página Draw.io | Fidelidad | Elementos | Textos | Colores | Conectores | Etiquetas | Alias | Anotaciones |",
          "|---|---|---|---|---|---|---|---|---|---|"]
    for r in report:
        md.append(f"| `{r['vista']}` | {r['pagina']} | **{r['fidelidad']}%** | {r['elementosPresentes']}/{r['elementos']} | "
                  f"{r['textosIguales']}/{r['elementos']} | {r['coloresIguales']}/{r['elementos']} | "
                  f"{r['conectoresPresentes']}/{r['conectores']} | {r['etiquetasIguales']}/{r['conectores']} | {r['alias']} | {r['anotaciones']} |")
    diffs = [(r["vista"], d) for r in report for d in r["diferencias"]]
    if diffs:
        md += ["", "## Diferencias", "", "| Vista | Tipo | Campo / regla | Draw.io id | Draw.io | Modelo / detalle |", "|---|---|---|---|---|---|"]
        for v, d in diffs:
            md.append(f"| `{v}` | {d['tipo']} | {d.get('campo', d.get('regla', ''))} | {d.get('drawioId', '')} | "
                      f"{str(d.get('drawio', '')).replace('|', '/')} | {str(d.get('modelo', d.get('detalle', ''))).replace('|', '/')} |")
    (out / "fidelidad-drawio.md").write_text("\n".join(md) + "\n", encoding="utf-8")
    print(f"[fidelidad] {len(report)} vistas · {errors} diferencias bloqueantes · "
          f"elementos {tot['elementosPresentes']}/{tot['elementos']} · conectores {tot['conectoresPresentes']}/{tot['conectores']}")


if __name__ == "__main__":
    main()
