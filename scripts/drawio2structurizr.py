#!/usr/bin/env python3
"""
Importador Draw.io (librería C4) -> Structurizr DSL + presentación por vista.

Genera, a partir del inventario del Draw.io (scripts/drawio_inventory.py) y de un
mapa curado (mapeo-drawio.json):

  dsl/model/personas.dsl           personas (compartidas entre páginas)
  dsl/model/sistemas.dsl           sistemas externos / plataforma y elementos de referencia
  dsl/model/<sistema>.dsl          sistemas en alcance con sus contenedores
  dsl/model/componentes/<c>.dsl    componentes L3 de cada contenedor
  dsl/model/relaciones/<vista>.dsl relaciones, agrupadas por la página donde aparecen
  dsl/views/vistas.dsl             una vista por página del Draw.io (sin autoLayout)
  dsl/layout/<vista>.json          presentación: posiciones, boundaries, clase de color y
                                   textos tal como los muestra el Draw.io en esa página
  fuente/trazabilidad.json         mapa completo (página, id Draw.io) -> elemento / relación

Principio: el MODELO es semánticamente C4 (un elemento por cosa real, sin duplicados);
la PRESENTACIÓN reproduce cada página del Draw.io. Toda diferencia entre lo que muestra
una página y el modelo queda registrada como "texto de presentación" (alias) y se
reporta en el informe de fidelidad.

Uso: python3 scripts/drawio2structurizr.py <inventario.json> <mapeo.json> <dir-version>
"""
from __future__ import annotations

import json
import re
import sys
import unicodedata
from collections import OrderedDict, defaultdict
from pathlib import Path

LEGEND_DEFAULT = {"person": "Person", "softwareSystem": "Software System", "container": "Container",
                  "component": "Component", "custom": None}
PAGE_PREFIX = {
    "L3 · Frontend Web": "fw", "L3 · App Movil": "am", "L3 · BFF Web": "bw", "L3 · BFF Movil": "bm",
    "L3 · Pub-Sub": "ps", "L3 · Documentos GCS": "dg", "L3 · Svc Usuarios Auth": "su",
    "L3 · Gestor Documental": "gd", "L3 · Svc Operacion": "so", "L3 · Svc Comercial": "sc",
}
CANON_ORDER = ["L2 · Container", "L0 · Referencia", "L1 · Context"]


def camel(text: str) -> str:
    text = unicodedata.normalize("NFKD", text).encode("ascii", "ignore").decode()
    words = [w for w in re.split(r"[^A-Za-z0-9]+", text) if w]
    if not words:
        return "x"
    return words[0].lower() + "".join(w[:1].upper() + w[1:].lower() for w in words[1:])


def norm(text: str) -> str:
    return re.sub(r"\s+", " ", (text or "").strip().lower())


def q(text: str | None) -> str:
    return '"' + (text or "").replace("\\", "/").replace('"', '\\"') + '"'


def split_label(label: str) -> tuple[str, str]:
    """'Delega autenticación [OIDC / OAuth 2.0]' -> ('Delega autenticación', 'OIDC / OAuth 2.0')."""
    m = re.match(r"^(.*?)\s*\[([^\]]+)\]\s*$", label or "")
    return (m.group(1).strip(), m.group(2).strip()) if m else ((label or "").strip(), "")


def is_person(el: dict) -> bool:
    return el.get("shape") == "mxgraph.c4.person2" or el["type"] in ("Person", "Persona")


class Generator:
    def __init__(self, inv: dict, mapa: dict):
        self.inv, self.mapa = inv, mapa
        self.pages = {p["name"]: p for p in inv["pages"]}
        self.elements: "OrderedDict[str, dict]" = OrderedDict()   # ref -> definición del modelo
        self.occ: dict[tuple[str, str], str] = {}                  # (página, id drawio) -> ref
        self.decisions: list[dict] = []
        self.rels: "OrderedDict[tuple, dict]" = OrderedDict()
        self.annotations: dict[str, list] = defaultdict(list)
        self.scope_ref: dict[str, str] = {}

    # ------------------------------------------------------------------ resolución de elementos
    def shared_for(self, page: str, name: str):
        for s in self.mapa["compartidos"]:
            if norm(name) in {norm(n) for n in s["nombres"]}:
                amb = s.get("ambito", "*")
                if amb == "*" or page.startswith(amb):
                    return s
        return None

    def boundary_name(self, page: dict, bid: str | None) -> str | None:
        return next((b["name"] for b in page["boundaries"] if b["id"] == bid), None)

    def classify(self, page_name: str, el: dict) -> dict:
        """Decide (ref, tipo de modelo, padre, nombre de modelo) para una forma del Draw.io."""
        page = self.pages[page_name]
        cfg = self.mapa["paginas"][page_name]
        over = self.mapa.get("porElemento", {}).get(f"{page_name}|{el['id']}", {})
        name_model = over.get("nombreModelo", el["name"])
        boundary = self.boundary_name(page, el.get("boundary"))
        if is_person(el):
            return {"ref": over.get("ref", "pe_" + camel(el["name"])), "kind": "person", "parent": None,
                    "name": name_model, "regla": "persona (compartida por nombre)"}
        shared = None if over.get("ref") else self.shared_for(page_name, el["name"])
        if shared:
            kind = shared.get("tipoModelo")
            return {"ref": shared["ref"], "kind": kind, "parent": None, "name": name_model,
                    "regla": f"compartido ({', '.join(shared['nombres'])})", "shared": shared}
        if over.get("tipoModelo"):
            ref = over.get("ref") or {"container": ("po_" if over.get("padre") == "portal" else "vo_")}.get(
                over["tipoModelo"], "ss_") + camel(name_model)
            return {"ref": ref, "kind": over["tipoModelo"], "parent": over.get("padre"), "name": name_model,
                    "regla": "excepción mapeo: " + over.get("motivo", "")}
        legend = el.get("legend")
        if page_name.startswith("L0"):
            if el["type"] in ("Component", "Container") and legend in ("Container", "Component") \
                    and boundary not in self.mapa.get("boundariesPlataformaL0", []):
                return {"ref": "po_" + camel(name_model), "kind": "container", "parent": "portal",
                        "name": name_model, "regla": "L0: contenedor del Portal"}
            return {"ref": "ss_" + camel(name_model), "kind": "softwareSystem", "parent": None,
                    "name": name_model, "regla": "L0: plataforma / sistema externo"}
        if page_name.startswith("L1"):
            if norm(el["name"]) == norm(self.mapa["sistemas"]["portal"]["nombreDrawio"]):
                return {"ref": "portal", "kind": "softwareSystem", "parent": None, "name": name_model,
                        "regla": "L1: sistema en alcance"}
            return {"ref": "ss_" + camel(name_model), "kind": "softwareSystem", "parent": None,
                    "name": name_model, "regla": "L1: sistema"}
        if page_name.startswith("L2"):
            if el["type"] == "Container":
                return {"ref": "vo_" + camel(name_model), "kind": "container", "parent": "volarte",
                        "name": name_model, "regla": "L2: contenedor de Volarte"}
            return {"ref": "ss_" + camel(name_model), "kind": "softwareSystem", "parent": None,
                    "name": name_model, "regla": "L2: plataforma / sistema externo"}
        # L3
        scope = self.scope_ref[page_name]
        if el["type"] == "Component":
            return {"ref": f"{PAGE_PREFIX[page_name]}_" + camel(name_model), "kind": "component", "parent": scope,
                    "name": name_model, "regla": f"L3: componente de {scope}"}
        return {"ref": "ss_" + camel(name_model), "kind": "softwareSystem", "parent": None, "name": name_model,
                "regla": "L3: sistema externo"}

    def texts(self, el: dict) -> dict:
        return {"nombre": el["name"], "tipo": el["type"], "tecnologia": el.get("technology", ""),
                "descripcion": el.get("description", "")}

    def run(self):
        mapa = self.mapa
        # 1) sistemas en alcance (Volarte no tiene caja en el Draw.io; se declara en el mapa)
        v = mapa["sistemas"]["volarte"]
        self.elements["volarte"] = {"ref": "volarte", "kind": "softwareSystem", "parent": None, "name": v["nombre"],
                                    "texts": {"nombre": v["nombre"], "tipo": v.get("tipo", "Software System"),
                                              "tecnologia": "", "descripcion": v["descripcion"]},
                                    "class": "Software System", "occ": [], "regla": "mapeo: " + v["nota"]}
        # alcance de cada L3 = contenedor L2 con ese nombre
        l2 = self.pages["L2 · Container"]
        for pname, cfg in mapa["paginas"].items():
            if cfg["tipo"] == "component":
                el = next(e for e in l2["elements"] if norm(e["name"]) == norm(cfg["alcance"]))
                self.scope_ref[pname] = "vo_" + camel(el["name"])
        # 2) clasificar todas las formas; la ocurrencia canónica define los textos del modelo
        order = sorted(self.pages, key=lambda n: CANON_ORDER.index(n) if n in CANON_ORDER else 99)
        pending = []
        for pname in order:
            page = self.pages[pname]
            for el in page["elements"]:
                c = self.classify(pname, el)
                pending.append((pname, el, c))
            for note in page["notes"]:
                spec = mapa.get("notasComoElemento", {}).get(pname, {}).get(note.get("fill"))
                if spec:
                    title, *rest = note["text"].split("\n")
                    fake = {"id": note["id"], "name": title.strip(), "type": "Nota", "technology": "",
                            "description": " ".join(r.strip() for r in rest), "legend": None,
                            "geometry": note["geometry"], "shape": "note", "boundary": note.get("boundary"),
                            "fill": note.get("fill"), "style": note.get("style", "")}
                    pending.append((pname, fake, {"ref": spec["ref"], "kind": "custom", "parent": None,
                                                  "name": fake["name"], "regla": "nota del Draw.io modelada como elemento",
                                                  "tag": spec.get("tag")}))
        by_ref = defaultdict(list)
        for item in pending:
            by_ref[item[2]["ref"]].append(item)
        for ref, items in by_ref.items():
            shared = next((c.get("shared") for _, _, c in items if c.get("shared")), None)
            canon_page = shared.get("canonica") if shared else None
            pname, el, c = next((it for it in items if it[0] == canon_page), items[0])
            kind = c["kind"] or self.kind_from_canonical(pname, el, c)
            parent = c["parent"]
            if kind in ("container", "component") and not parent:
                parent = "volarte" if ref.startswith("vo_") else "portal" if ref.startswith("po_") else None
            texts = self.texts(el)
            texts["nombre"] = c["name"]
            self.elements[ref] = {"ref": ref, "kind": kind, "parent": parent if kind in ("container", "component") else None,
                                  "name": c["name"], "texts": texts, "class": el.get("legend"), "occ": [],
                                  "regla": c["regla"], "tagExtra": c.get("tag"), "canonical": (pname, el["id"]),
                                  "boundary": self.boundary_name(self.pages[pname], el.get("boundary"))}
            if ref == "portal":
                self.elements[ref]["kind"] = "softwareSystem"
            extra = self.mapa.get("enriquecimiento", {}).get(ref)
            if extra:
                for campo in ("descripcion", "tecnologia"):
                    if extra.get(campo):
                        self.elements[ref]["texts"][campo] = extra[campo]
                self.elements[ref]["regla"] += " · enriquecido: " + extra.get("motivo", "")
        for pname, el, c in pending:
            key = (pname, el["id"])
            if key in self.occ:
                continue
            self.occ[key] = c["ref"]
            self.elements[c["ref"]]["occ"].append({"pagina": pname, "drawioId": el["id"], "el": el, "regla": c["regla"]})
        self.check_duplicates_per_page()
        self.build_relationships()

    def kind_from_canonical(self, pname, el, c):
        if c["ref"].startswith("vo_") or c["ref"].startswith("po_"):
            return "container"
        if c["ref"].startswith("ce_"):
            return "custom"
        return "softwareSystem"

    def check_duplicates_per_page(self):
        for pname, page in self.pages.items():
            seen = defaultdict(list)
            for el in page["elements"]:
                seen[self.occ[(pname, el["id"])]].append(el["id"])
            for ref, ids in seen.items():
                if len(ids) > 1:
                    raise SystemExit(f"[mapeo] {pname}: {len(ids)} formas apuntan al mismo elemento '{ref}' ({ids}). "
                                     "Agregue una excepción en porElemento.")

    # ------------------------------------------------------------------ relaciones
    def build_relationships(self):
        exp = self.mapa.get("expansiones", {})
        for pname, page in self.pages.items():
            vista = self.mapa["paginas"][pname]["vista"]
            bmembers = defaultdict(list)
            for el in page["elements"]:
                if el.get("boundary"):
                    bmembers[el["boundary"]].append(self.occ[(pname, el["id"])])
            bnames = {b["id"]: b["name"] for b in page["boundaries"]}
            for e in page["edges"]:
                src = self.occ.get((pname, e["source"])) if e["sourceKind"] == "element" else None
                if e["sourceKind"] == "note":
                    src = self.note_ref(pname, e["source"])
                dst = self.occ.get((pname, e["target"])) if e["targetKind"] == "element" else None
                if e["targetKind"] == "note":
                    dst = self.note_ref(pname, e["target"])
                desc, tech = split_label(e["label"])
                targets = []
                if src and dst and src != dst:
                    targets = [(src, dst)]
                elif src and e["targetKind"] == "boundary" and desc in exp.get(pname, {}):
                    bname = exp[pname][desc]
                    bid = next(b["id"] for b in page["boundaries"] if b["name"] == bname)
                    targets = [(src, m) for m in bmembers[bid] if m != src]
                if not targets:
                    motivo = ("autorreferencia en el Draw.io" if src and src == dst else
                              f"extremo en {'boundary ' + repr(bnames.get(e['target'], e['target'])) if e['targetKind'] == 'boundary' else 'nota/texto libre' if e['targetKind'] in ('note', 'none') else e['targetKind']}")
                    self.annotations[pname].append({"drawioId": e["id"], "motivo": motivo, "edge": e})
                    continue
                keys = []
                for s, d in targets:
                    k = (s, d, desc, tech)
                    r = self.rels.setdefault(k, {"source": s, "target": d, "description": desc, "technology": tech,
                                                 "pages": [], "edges": []})
                    if vista not in r["pages"]:
                        r["pages"].append(vista)
                    r["edges"].append({"pagina": pname, "drawioId": e["id"], "inferido": e.get("inferred", [])})
                    keys.append(k)
                e["_rels"] = keys

    def note_ref(self, pname, note_id):
        return next((ref for (p, i), ref in self.occ.items() if p == pname and i == note_id), None)

    # ------------------------------------------------------------------ escritura DSL
    def element_tags(self, d: dict) -> list[str]:
        tags = []
        default = LEGEND_DEFAULT[d["kind"]]
        if d["kind"] == "person":
            default = "Person"
        if d.get("class") and d["class"] != default:
            tags.append(d["class"])
        if d["kind"] == "custom" and not d.get("class"):
            tags.append(d.get("tagExtra") or "Nota")
        tags += self.mapa.get("tagsSemanticos", {}).get(d["ref"], [])
        return list(dict.fromkeys(tags))

    def props(self, d: dict, indent: str) -> str:
        t = d["texts"]
        occ = "; ".join(f"{o['pagina']}#{o['drawioId']}" for o in d["occ"])
        lines = [f'{indent}properties {{']
        if t.get("tipo"):
            lines.append(f'{indent}    "c4.tipo" {q(t["tipo"])}')
        if d["kind"] in ("softwareSystem", "person", "custom") and t.get("tecnologia"):
            lines.append(f'{indent}    "c4.tecnologia" {q(t["tecnologia"])}')
        if occ:
            lines.append(f'{indent}    "drawio.ocurrencias" {q(occ)}')
        if d.get("boundary"):
            lines.append(f'{indent}    "drawio.boundary" {q(d["boundary"])}')
        lines.append(f'{indent}}}')
        return "\n".join(lines)

    def element_dsl(self, d: dict, indent: str, body: str = "") -> str:
        t = d["texts"]
        tags = ",".join(self.element_tags(d))
        if d["kind"] == "person":
            head = f'{d["ref"]} = person {q(d["name"])} {q(t["descripcion"])} {q(tags)}'
        elif d["kind"] == "softwareSystem":
            head = f'{d["ref"]} = softwareSystem {q(d["name"])} {q(t["descripcion"])} {q(tags)}'
        elif d["kind"] == "container":
            head = f'{d["ref"]} = container {q(d["name"])} {q(t["descripcion"])} {q(t["tecnologia"])} {q(tags)}'
        elif d["kind"] == "component":
            head = f'{d["ref"]} = component {q(d["name"])} {q(t["descripcion"])} {q(t["tecnologia"])} {q(tags)}'
        else:
            meta = t["tipo"] + (f": {t['tecnologia']}" if t.get("tecnologia") else "")
            head = f'{d["ref"]} = element {q(d["name"])} {q(meta)} {q(t["descripcion"])} {q(tags)}'
        origin = f'{indent}# Draw.io: ' + "; ".join(f"{o['pagina']} ({o['drawioId']})" for o in d["occ"]) if d["occ"] else ""
        inner = self.props(d, indent + "    ")
        if body:
            inner += "\n\n" + body
        return (origin + "\n" if origin else "") + f"{indent}{head} {{\n{inner}\n{indent}}}"

    def write(self, vdir: Path):
        dsl = vdir / "dsl"
        for sub in ("model/componentes", "model/relaciones", "views", "layout"):
            (dsl / sub).mkdir(parents=True, exist_ok=True)
        header = ("# =============================================================================\n"
                  "# GENERADO por scripts/drawio2structurizr.py desde la fuente Draw.io (v3).\n"
                  "# {titulo}\n"
                  "# Cada elemento conserva su procedencia (página e id Draw.io) en 'drawio.ocurrencias'.\n"
                  "# A partir de v3 este DSL es la fuente de verdad: se edita a mano en versiones siguientes.\n"
                  "# =============================================================================\n\n")
        people = [d for d in self.elements.values() if d["kind"] == "person"]
        systems = [d for d in self.elements.values() if d["kind"] in ("softwareSystem", "custom") and d["ref"] not in ("portal", "volarte")]
        (dsl / "model/personas.dsl").write_text(header.format(titulo="Personas") +
                                               "\n\n".join(self.element_dsl(d, "") for d in people) + "\n", encoding="utf-8")
        (dsl / "model/sistemas.dsl").write_text(header.format(titulo="Sistemas externos, plataforma corporativa y elementos de referencia") +
                                               "\n\n".join(self.element_dsl(d, "") for d in systems) + "\n", encoding="utf-8")
        for sys_ref in ("portal", "volarte"):
            sysd = self.elements[sys_ref]
            conts = [d for d in self.elements.values() if d["kind"] == "container" and d["parent"] == sys_ref]
            blocks = []
            for c in conts:
                comps = [d for d in self.elements.values() if d["kind"] == "component" and d["parent"] == c["ref"]]
                body = ""
                if comps:
                    fname = f"componentes/{c['ref']}.dsl"
                    (dsl / "model" / fname).write_text(
                        header.format(titulo=f"Componentes L3 de '{c['name']}'") +
                        "\n\n".join(self.element_dsl(d, "") for d in comps) + "\n", encoding="utf-8")
                    body = f"        !include {fname}"
                blocks.append(self.element_dsl(c, "    ", body))
            if sys_ref == "volarte":
                docs = "    !docs ../../docs/workspace\n    !adrs ../../docs/adr\n\n"
            else:
                docs = ""
            content = header.format(titulo=f"Sistema en alcance '{sysd['name']}' y sus contenedores") + \
                self.element_dsl(sysd, "", docs + "\n\n".join(blocks)) + "\n"
            (dsl / f"model/{sys_ref}.dsl").write_text(content, encoding="utf-8")
        # relaciones por página
        by_page = defaultdict(list)
        for r in self.rels.values():
            by_page[r["pages"][0]].append(r)
        for pname, cfg in self.mapa["paginas"].items():
            vista = cfg["vista"]
            lines = [header.format(titulo=f"Relaciones de la página '{pname}' (vista {vista})").rstrip() + "\n"]
            for r in by_page.get(vista, []):
                tags = ",".join(f"pagina:{p}" for p in r["pages"])
                ids = ", ".join(sorted({e["drawioId"] for e in r["edges"]}))
                inf = any(e["inferido"] for e in r["edges"])
                lines.append(f"# Draw.io: {ids}" + ("  (extremo inferido por geometría)" if inf else ""))
                lines.append(f'{r["source"]} -> {r["target"]} {q(r["description"])} {q(r["technology"])} {q(tags)}')
            for a in self.annotations.get(pname, []):
                lines.append(f"# Anotación sin relación de modelo ({a['motivo']}): Draw.io {a['drawioId']} "
                             f"'{a['edge']['label']}'")
            (dsl / f"model/relaciones/{vista}.dsl").write_text("\n".join(lines) + "\n", encoding="utf-8")
        self.write_views(dsl)
        self.write_layouts(dsl)
        self.write_trace(vdir)

    def write_views(self, dsl: Path):
        out = ["# =============================================================================",
               "# GENERADO por scripts/drawio2structurizr.py — una vista por página del Draw.io.",
               "# Sin autoLayout: la posición de cada elemento viene de dsl/layout/<vista>.json.",
               "# Cada vista muestra solo las relaciones dibujadas en su página (tag pagina:<vista>).",
               "# =============================================================================", ""]
        for pname, cfg in self.mapa["paginas"].items():
            refs = []
            for el in self.pages[pname]["elements"]:
                refs.append(self.occ[(pname, el["id"])])
            for note in self.pages[pname]["notes"]:
                r = self.note_ref(pname, note["id"])
                if r:
                    refs.append(r)
            refs = list(dict.fromkeys(refs))
            scope = {"container": cfg["alcance"], "systemContext": cfg["alcance"]}.get(cfg["tipo"]) or self.scope_ref[pname]
            if cfg["tipo"] == "component":
                refs = [r for r in refs if r != scope]
            kw = {"container": "container", "systemContext": "systemContext", "component": "component"}[cfg["tipo"]]
            out.append(f'{kw} {scope} {q(cfg["vista"])} {q(cfg["descripcion"])} {{')
            out.append(f'    title {q(cfg["titulo"])}')
            for i in range(0, len(refs), 6):
                out.append("    include " + " ".join(refs[i:i + 6]))
            out.append(f'    exclude "relationship.tag!=pagina:{cfg["vista"]}"')
            out.append("    properties {")
            out.append(f'        "drawio.pagina" {q(pname)}')
            out.append(f'        "aac.layout" {q("layout/" + cfg["vista"] + ".json")}')
            out.append("    }")
            out.append("}")
            out.append("")
        (dsl / "views/vistas.dsl").write_text("\n".join(out), encoding="utf-8")

    def presentation_texts(self, ref: str, el: dict) -> dict:
        d = self.elements[ref]
        model = d["texts"]
        drawio = self.texts(el)
        return {k: drawio[k] for k in ("nombre", "tipo", "tecnologia", "descripcion")
                if (drawio[k] or "") != (model.get(k) or "") and not (k == "nombre" and drawio[k] == d["name"])}

    def write_layouts(self, dsl: Path):
        for pname, cfg in self.mapa["paginas"].items():
            page = self.pages[pname]
            nodes = []
            for el in page["elements"]:
                ref = self.occ[(pname, el["id"])]
                node = {"ref": ref, "drawioId": el["id"], **el["geometry"],
                        "forma": {"mxgraph.c4.person2": "persona", "cylinder3": "cilindro"}.get(el.get("shape"), "caja"),
                        "clase": el.get("legend"), "boundary": el.get("boundary"),
                        "style": el.get("style", ""), "fuentes": el.get("fonts"),
                        "descripcionDrawio": el.get("descriptionRaw", "")}
                over = self.presentation_texts(ref, el)
                if over:
                    node["texto"] = over
                nodes.append(node)
            notes = []
            for n in page["notes"]:
                ref = self.note_ref(pname, n["id"])
                if ref:
                    nodes.append({"ref": ref, "drawioId": n["id"], **n["geometry"], "forma": "nota",
                                  "clase": None, "fill": n.get("fill"), "boundary": n.get("boundary"),
                                  "style": n.get("style", ""), "textoDrawio": n["text"], "fuente": n.get("font", {})})
                else:
                    notes.append({"drawioId": n["id"], **n["geometry"], "texto": n["text"], "fill": n.get("fill"),
                                  "fuente": n.get("font", {}),
                                  "forma": n.get("shape"), "style": n.get("style", "")})
            edges = []
            for e in page["edges"]:
                edges.append({"drawioId": e["id"], "origen": e["source"], "origenTipo": e["sourceKind"],
                              "destino": e["target"], "destinoTipo": e["targetKind"],
                              "relaciones": [{"origen": k[0], "destino": k[1], "descripcion": k[2], "tecnologia": k[3]}
                                             for k in e.get("_rels", [])],
                              "etiqueta": e["label"], "etiquetaLineas": e.get("labelRaw", e["label"]),
                              "estiloEtiqueta": e.get("labelStyle", ""), "fuenteEtiqueta": e.get("labelFont", {}),
                              "puntos": e["points"], "extremos": e["endPoints"],
                              "posEtiqueta": e["labelPos"], "estilo": e["style"], "inferido": e.get("inferred", [])})
            layout = {"vista": cfg["vista"], "pagina": pname, "titulo": cfg["titulo"],
                      "boundaries": [{"drawioId": b["id"], "nombre": b["name"], "etiqueta": b["application"],
                                      "tipo": b["type"], **b["geometry"], "style": b.get("style", "")}
                                     for b in page["boundaries"]],
                      "nodos": nodes, "notas": notes, "conectores": edges}
            (dsl / f"layout/{cfg['vista']}.json").write_text(json.dumps(layout, indent=1, ensure_ascii=False) + "\n",
                                                              encoding="utf-8")

    def write_trace(self, vdir: Path):
        rows = []
        for (pname, did), ref in self.occ.items():
            d = self.elements[ref]
            o = next(o for o in d["occ"] if o["pagina"] == pname and o["drawioId"] == did)
            el = o["el"]
            rows.append({"pagina": pname, "drawioId": did, "nombreDrawio": el["name"], "tipoDrawio": el["type"],
                         "claseDrawio": el.get("legend"), "ref": ref, "tipoModelo": d["kind"],
                         "padre": d.get("parent"), "nombreModelo": d["name"], "regla": o["regla"],
                         "textoPresentacion": self.presentation_texts(ref, el)})
        rels = [{"origen": r["source"], "destino": r["target"], "descripcion": r["description"],
                 "tecnologia": r["technology"], "vistas": r["pages"], "conectoresDrawio": r["edges"]}
                for r in self.rels.values()]
        ann = [{"pagina": p, "drawioId": a["drawioId"], "etiqueta": a["edge"]["label"], "motivo": a["motivo"]}
               for p, lst in self.annotations.items() for a in lst]
        (vdir / "fuente/trazabilidad.json").write_text(json.dumps(
            {"elementos": rows, "relaciones": rels, "anotaciones": ann}, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
        md = ["# Trazabilidad Draw.io → Structurizr (generado)", "",
              "Generado por `scripts/drawio2structurizr.py`. Una fila por forma del Draw.io: a qué elemento del modelo",
              "corresponde, con qué regla se decidió y si la página muestra un texto distinto al del modelo (alias de presentación).",
              "El detalle máquina-legible está en `trazabilidad.json`.", "",
              f"- Formas Draw.io: **{len(rows)}** · Elementos de modelo: **{len(self.elements)}** · Relaciones: **{len(rels)}** · "
              f"Anotaciones sin relación: **{len(ann)}**", ""]
        for pname in self.mapa["paginas"]:
            prs = [r for r in rows if r["pagina"] == pname]
            md += [f"## {pname} → vista `{self.mapa['paginas'][pname]['vista']}`", "",
                   "| Draw.io id | Forma (tipo · clase) | Elemento de modelo | Tipo modelo | Regla | Texto de presentación |",
                   "|---|---|---|---|---|---|"]
            for r in prs:
                alias = ", ".join(f"{k}: «{v}»" for k, v in r["textoPresentacion"].items()) or "—"
                md.append(f"| `{r['drawioId'][-10:]}` | **{r['nombreDrawio']}** ({r['tipoDrawio']} · {r['claseDrawio'] or 'nota'}) | "
                          f"`{r['ref']}` {r['nombreModelo']} | {r['tipoModelo']}{' en ' + r['padre'] if r['padre'] else ''} | "
                          f"{r['regla'].replace('|', '/')} | {alias.replace('|', '/')} |")
            pa = [a for a in ann if a["pagina"] == pname]
            if pa:
                md += ["", "Conectores sin relación de modelo (anotaciones de presentación):", ""]
                md += [f"- `{a['drawioId']}` «{a['etiqueta'] or 'sin etiqueta'}» — {a['motivo']}" for a in pa]
            md.append("")
        (vdir / "fuente/TRAZABILIDAD.md").write_text("\n".join(md) + "\n", encoding="utf-8")
        print(f"[drawio2structurizr] {len(self.elements)} elementos de modelo · {len(rows)} formas Draw.io · "
              f"{len(rels)} relaciones · {len(ann)} anotaciones sin relación")


def main():
    inv = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
    mapa = json.loads(Path(sys.argv[2]).read_text(encoding="utf-8"))
    vdir = Path(sys.argv[3])
    g = Generator(inv, mapa)
    g.run()
    g.write(vdir)


if __name__ == "__main__":
    main()
