#!/usr/bin/env python3
"""
Inventario estructurado de un archivo Draw.io con la librería C4.

Extrae por página: elementos C4 (nombre, tipo, tecnología, descripción, colores,
geometría absoluta, boundary padre), boundaries, notas y conectores (origen,
destino, etiqueta, waypoints, estilo). Es la base de la trazabilidad
Draw.io → Structurizr (scripts/drawio_fidelity.py) y del render de referencia.

Uso: python3 scripts/drawio_inventory.py <archivo.drawio> <salida.json>
"""
from __future__ import annotations

import base64
import html
import json
import re
import sys
import urllib.parse
import xml.etree.ElementTree as ET
import zlib
from pathlib import Path

LEGEND = {  # fill de la librería C4 de draw.io -> clase de la leyenda oficial
    "#083F75": "Person", "#1061B0": "Software System", "#23A2D9": "Container",
    "#63BEF2": "Component", "#6C6477": "External Person", "#8C8496": "External Software System",
}


def style_dict(style: str) -> dict:
    out = {}
    for part in (style or "").split(";"):
        if "=" in part:
            k, v = part.split("=", 1)
            out[k] = v
        elif part:
            out[part] = True
    return out


def clean(text: str | None) -> str:
    text = html.unescape(text or "")
    text = re.sub(r"<br[^>]*>|</div>|<div[^>]*>|</p>", "\n", text, flags=re.I)
    text = re.sub(r"<[^>]+>", "", text)
    text = html.unescape(text).replace("\xa0", " ")
    lines = [re.sub(r"[ \t]+", " ", l).strip() for l in text.splitlines()]
    return "\n".join(l for l in lines if l).strip()


def label_fonts(label_html: str, st: dict) -> dict:
    """Tamaños y colores de las tres líneas de la etiqueta C4 (nombre, tipo, descripción)."""
    sizes = [int(x) for x in re.findall(r"font-size:\s*(\d+)px", label_html)]
    colors = re.findall(r'color[=:]\s*"?(#[0-9A-Fa-f]{6})', label_html)
    base_color = st.get("fontColor") or "#000000"
    if "%c4Name%" in label_html:
        desc_color = re.search(r'%c4Description%', label_html) and re.findall(r'color="(#[0-9A-Fa-f]{6})"', label_html)
        return {"nombrePx": sizes[0] if sizes else 16, "tipoPx": int(st.get("fontSize", 12)),
                "descPx": sizes[1] if len(sizes) > 1 else 11, "color": base_color,
                "colorTipo": base_color, "colorDesc": desc_color[-1] if desc_color else base_color}
    return {"nombrePx": sizes[0] if sizes else 14, "tipoPx": sizes[1] if len(sizes) > 1 else 10,
            "descPx": sizes[2] if len(sizes) > 2 else 9, "color": colors[0] if colors else base_color,
            "colorTipo": colors[1] if len(colors) > 1 else base_color,
            "colorDesc": colors[2] if len(colors) > 2 else base_color}


def html_font(label_html: str) -> dict:
    """Primer tamaño y color de fuente declarados en línea en una etiqueta HTML del Draw.io."""
    html_s = html.unescape(label_html or "")
    size = re.search(r"font-size:\s*(\d+)px", html_s)
    color = re.search(r"color:\s*(#[0-9A-Fa-f]{6}|rgb\(\s*(\d+),\s*(\d+),\s*(\d+)\s*\))", html_s) or \
        re.search(r'color="(#[0-9A-Fa-f]{6})"', html_s)
    out = {}
    if size:
        out["px"] = int(size.group(1))
    if color:
        out["color"] = color.group(1) if color.group(1).startswith("#") else \
            "#%02X%02X%02X" % tuple(int(color.group(i)) for i in (2, 3, 4))
    return out


def one_line(text: str) -> str:
    return re.sub(r"\s+", " ", text or "").strip()


def load_pages(path: Path):
    root = ET.parse(path).getroot()
    for d in root.findall("diagram"):
        model = d.find("mxGraphModel")
        if model is None and (d.text or "").strip():
            raw = zlib.decompress(base64.b64decode(d.text), -15)
            model = ET.fromstring(urllib.parse.unquote(raw.decode()))
        yield d.get("name"), d.get("id"), model


def inventory(path: Path) -> dict:
    pages = []
    for name, page_id, model in load_pages(path):
        cells = {}
        for node in model.iter():
            if node.tag == "mxCell":
                if node.get("id") in cells:  # mxCell hijo de <object>: ya registrado
                    continue
                cells[node.get("id")] = {"attrs": {}, "cell": node, "id": node.get("id")}
            elif node.tag in ("object", "UserObject"):
                mc = node.find("mxCell")
                if mc is not None:
                    cells[node.get("id")] = {"attrs": dict(node.attrib), "cell": mc, "id": node.get("id")}

        def geom(cid):
            c = cells.get(cid)
            if not c:
                return None
            g = c["cell"].find("mxGeometry")
            if g is None or g.get("relative") == "1":
                return None
            x, y = float(g.get("x", 0)), float(g.get("y", 0))
            w, h = float(g.get("width", 0)), float(g.get("height", 0))
            parent = c["cell"].get("parent")
            if parent and parent in cells and cells[parent]["cell"].get("vertex") == "1":
                pg = geom(parent)
                if pg:
                    x, y = x + pg["x"], y + pg["y"]
            return {"x": round(x, 1), "y": round(y, 1), "w": round(w, 1), "h": round(h, 1)}

        elements, boundaries, notes, edges = [], [], [], []
        for cid, c in cells.items():
            cell, attrs = c["cell"], c["attrs"]
            st = style_dict(cell.get("style"))
            if cell.get("vertex") == "1":
                g = geom(cid)
                c4type = attrs.get("c4Type")
                label = clean(attrs.get("label") or cell.get("value"))
                base = {"id": cid, "geometry": g, "style": cell.get("style") or "", "fill": st.get("fillColor"), "stroke": st.get("strokeColor"),
                        "fontColor": st.get("fontColor"), "shape": st.get("shape") or ("rounded" if st.get("rounded") else None),
                        "dashed": st.get("dashed") == "1", "parent": cell.get("parent")}
                if c4type and "Boundary" in c4type:
                    boundaries.append({**base, "name": attrs.get("c4Name", ""), "type": c4type,
                                       "application": clean(attrs.get("c4Application", "")), "label": label})
                elif c4type or attrs.get("c4Name"):
                    fill = (st.get("fillColor") or "").upper()
                    elements.append({**base, "name": one_line(attrs.get("c4Name", "")), "type": one_line(c4type or ""),
                                     "technology": one_line(attrs.get("c4Technology", "")),
                                     "description": one_line(attrs.get("c4Description", "")),
                                     "descriptionRaw": clean(attrs.get("c4Description", "")),
                                     "legend": LEGEND.get(fill), "label": label,
                                     "fonts": label_fonts(attrs.get("label") or "", st)})
                elif st.get("shape") == "mxgraph.c4.person2" or (label and "[Persona]" in label):
                    parts = [p.strip() for p in label.split("\n") if p.strip()]
                    raw_parts = [p for p in label.split("\n")]
                    elements.append({**base, "name": parts[0] if parts else "", "type": "Persona",
                                     "technology": "", "description": one_line(" ".join(parts[2:])),
                                     "descriptionRaw": "\n".join(p for p in raw_parts[2:] if p.strip()),
                                     "legend": LEGEND.get((st.get("fillColor") or "").upper()), "label": label,
                                     "fonts": label_fonts(cell.get("value") or "", st)})
                elif label and not st.get("edgeLabel") and "edgeLabel" not in (cell.get("style") or ""):
                    notes.append({**base, "text": label, "font": html_font(cell.get("value") or attrs.get("label") or "")})
                elif not label and g and st.get("fillColor") not in (None, "none") and "edgeLabel" not in (cell.get("style") or "") \
                        and cells.get(cell.get("parent"), {"cell": ET.Element("x")})["cell"].get("vertex") != "1":
                    notes.append({**base, "text": "", "font": {}, "decoracion": True})  # resaltados sin texto
            elif cell.get("edge") == "1":
                g = cell.find("mxGeometry")
                ox = oy = 0.0
                par = cell.get("parent")
                if par in cells and cells[par]["cell"].get("vertex") == "1":
                    pg = geom(par)
                    if pg:
                        ox, oy = pg["x"], pg["y"]
                pts, ends, lab = [], {}, {"x": 0.0, "y": 0.0, "dx": 0.0, "dy": 0.0}
                if g is not None:
                    lab["x"], lab["y"] = float(g.get("x", 0)), float(g.get("y", 0))
                    off = [m for m in g.findall("mxPoint") if m.get("as") == "offset"]
                    if off:
                        lab["dx"], lab["dy"] = float(off[0].get("x", 0)), float(off[0].get("y", 0))
                    arr = g.find("Array")
                    if arr is not None:
                        pts = [{"x": float(p.get("x", 0)) + ox, "y": float(p.get("y", 0)) + oy} for p in arr.findall("mxPoint")]
                    for mp in g.findall("mxPoint"):
                        if mp.get("as") in ("sourcePoint", "targetPoint"):
                            ends[mp.get("as")] = (float(mp.get("x", 0)) + ox, float(mp.get("y", 0)) + oy)
                edges.append({"id": cid, "source": cell.get("source"), "target": cell.get("target"), "_ends": ends, "labelPos": lab,
                              "label": one_line(clean(attrs.get("label") or cell.get("value"))),
                              "labelRaw": clean(attrs.get("label") or cell.get("value")),
                              "labelFont": html_font(attrs.get("label") or cell.get("value")),
                              "points": pts, "dashed": st.get("dashed") == "1", "style": cell.get("style")})
        # etiquetas de conector definidas como celdas hijas (edgeLabel). El Draw.io inserta "Text" como
        # marcador por defecto: si hay una etiqueta real, los marcadores se descartan (quedan registrados).
        for e in edges:
            kids = [c for c in cells.values() if c["cell"].get("parent") == e["id"] and "edgeLabel" in (c["cell"].get("style") or "")]
            real = [k for k in kids if one_line(clean(k["attrs"].get("label") or k["cell"].get("value"))) not in ("", "Text")]
            e["placeholders"] = len(kids) - len(real)
            if not e["label"] and (real or kids):
                k = (real or kids)[-1]
                cell = k["cell"]
                e["label"] = one_line(clean(k["attrs"].get("label") or cell.get("value")))
                e["labelRaw"] = clean(k["attrs"].get("label") or cell.get("value"))
                e["labelFont"] = html_font(k["attrs"].get("label") or cell.get("value"))
                e["labelStyle"] = cell.get("style") or ""
                lg = cell.find("mxGeometry")
                if lg is not None:
                    off = [m for m in lg.findall("mxPoint") if m.get("as") == "offset"]
                    e["labelPos"] = {"x": float(lg.get("x", 0)), "y": float(lg.get("y", 0)),
                                     "dx": float(off[0].get("x", 0)) if off else 0.0,
                                     "dy": float(off[0].get("y", 0)) if off else 0.0}
            if e["label"] == "Text":
                e["label"], e["labelRaw"] = "", ""
        by_id = {e["id"]: e for e in elements}
        bound_ids = {b["id"]: b for b in boundaries}
        by_id = {e["id"]: e for e in elements}
        bound_ids = {b["id"]: b for b in boundaries}
        # Conectores sin extremo conectado: se infiere el elemento bajo el punto final (tolerancia 20 px)
        def element_at(pt):
            best = None
            for el in elements:
                g = el["geometry"]
                if not g:
                    continue
                dx = max(g["x"] - pt[0], 0, pt[0] - (g["x"] + g["w"]))
                dy = max(g["y"] - pt[1], 0, pt[1] - (g["y"] + g["h"]))
                d = (dx * dx + dy * dy) ** 0.5
                if d <= 20 and (best is None or d < best[0]):
                    best = (d, el["id"])
            return best[1] if best else None

        for e in edges:
            e["inferred"] = []
            for end, key in (("source", "sourcePoint"), ("target", "targetPoint")):
                if (not e[end] or e[end] not in cells) and key in e["_ends"]:
                    guess = element_at(e["_ends"][key])
                    if guess:
                        e[end] = guess
                        e["inferred"].append(end)
            e["endPoints"] = {k: {"x": v[0], "y": v[1]} for k, v in e.pop("_ends").items()}
        for e in edges:
            e["sourceName"] = by_id.get(e["source"], {}).get("name") or bound_ids.get(e["source"], {}).get("name")
            e["targetName"] = by_id.get(e["target"], {}).get("name") or bound_ids.get(e["target"], {}).get("name")
            e["sourceKind"] = "element" if e["source"] in by_id else ("boundary" if e["source"] in bound_ids else "none")
            e["targetKind"] = "element" if e["target"] in by_id else ("boundary" if e["target"] in bound_ids else "none")
        for e in edges:
            e["style"] = e["style"]
        # Pertenencia a boundaries por geometría (el boundary más pequeño que contiene el centro)
        def inside(g, b):
            return b["x"] <= g["x"] and b["y"] <= g["y"] and g["x"] + g["w"] <= b["x"] + b["w"] + 1 \
                and g["y"] + g["h"] <= b["y"] + b["h"] + 1

        def boundary_of(g, exclude=None):
            cands = [b for b in boundaries if b["geometry"] and b["id"] != exclude and inside(g, b["geometry"])]
            return min(cands, key=lambda b: b["geometry"]["w"] * b["geometry"]["h"])["id"] if cands else None

        def boundary_at(pt):
            cands = [b for b in boundaries if b["geometry"] and b["geometry"]["x"] <= pt["x"] <= b["geometry"]["x"] + b["geometry"]["w"]
                     and b["geometry"]["y"] <= pt["y"] <= b["geometry"]["y"] + b["geometry"]["h"]]
            return min(cands, key=lambda b: b["geometry"]["w"] * b["geometry"]["h"])["id"] if cands else None

        for el in elements + notes + boundaries:
            el.pop("parent", None)
            el["boundary"] = boundary_of(el["geometry"], el["id"]) if el.get("geometry") else None
        notes_by_id = {n["id"]: n for n in notes}
        for e in edges:
            for end, key in (("source", "sourcePoint"), ("target", "targetPoint")):
                if e[end + "Kind"] == "none":
                    if e[end] and e[end] in notes_by_id:
                        e[end + "Kind"] = "note"
                    elif key in e["endPoints"]:
                        b = boundary_at(e["endPoints"][key])
                        if b:
                            e[end], e[end + "Kind"] = b, "boundary"
                            e["inferred"].append(end)
        pages.append({"name": name, "id": page_id, "elements": elements, "boundaries": boundaries,
                      "notes": notes, "edges": edges})
    return {"source": path.name, "pages": pages}


if __name__ == "__main__":
    src, out = Path(sys.argv[1]), Path(sys.argv[2])
    inv = inventory(src)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(inv, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    for p in inv["pages"]:
        print(f"{p['name']:28} elementos={len(p['elements']):3} boundaries={len(p['boundaries']):2} "
              f"notas={len(p['notes']):2} conectores={len(p['edges']):3}")
