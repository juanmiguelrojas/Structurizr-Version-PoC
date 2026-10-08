#!/usr/bin/env python3
"""Genera dsl/views/themes/volarte-theme.json a partir de dsl/views/styles.dsl.

El tema JSON permite reutilizar la paleta Volarte/Terpel en otros workspaces
(`theme https://.../volarte-theme.json`). Ejecutado por scripts/aac-build.sh.
"""
import json
import pathlib
import re

ROOT = pathlib.Path(__file__).resolve().parent.parent
STYLES = ROOT / "dsl" / "views" / "styles.dsl"
THEME = ROOT / "dsl" / "views" / "themes" / "volarte-theme.json"
ENUMS = {"border", "shape", "routing", "style"}


def convert(key, value):
    if value.isdigit():
        return int(value)
    if key in ENUMS:
        return value[:1].upper() + value[1:]
    return value


def main():
    text = STYLES.read_text(encoding="utf-8")
    elements, relationships = [], []
    for kind, tag, body in re.findall(r'(element|relationship) "([^"]+)" \{([^}]*)\}', text):
        style = {"tag": tag}
        for key, value in re.findall(r"(\w+) ([^\n]+)", body):
            style[key] = convert(key, value.strip())
        (elements if kind == "element" else relationships).append(style)
    THEME.parent.mkdir(parents=True, exist_ok=True)
    THEME.write_text(json.dumps({
        "name": "Volarte Terpel",
        "description": "Tema C4 corporativo Volarte (Terpel - Dirección de Arquitectura). Generado desde styles.dsl.",
        "elements": elements,
        "relationships": relationships,
    }, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"[theme] {THEME.relative_to(ROOT)}: {len(elements)} estilos de elemento, {len(relationships)} de relación")


if __name__ == "__main__":
    main()
