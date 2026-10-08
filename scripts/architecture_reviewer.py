#!/usr/bin/env python3
"""
Agente Revisor de Arquitectura · Volarte (Architecture as Code)

Analiza el workspace Structurizr (exportado a JSON por structurizr-cli) y el
diff de Git para aplicar las reglas de gobierno de arquitectura:

  R1  Descripciones   Todo Person / SoftwareSystem / Container / Component tiene descripción.     [ERROR]
  R2  Tecnologías     Todo Container y Component declara su tecnología.                         [ERROR]
  R3  Aislamiento     Frontend / Móvil no acceden a datos, colas ni servicios de dominio sin
                      pasar por un BFF / API Gateway.                                            [ERROR]
  R4  Trazabilidad    Todo cambio en dsl/ va acompañado de una entrada en docs/CHANGELOG_DSL.md
                      que referencia los archivos modificados y trae los campos obligatorios.    [ERROR]
  R5  Sugerencias     SPOF, tramos no cifrados, falta de observabilidad (OTel / Dynatrace),
                      suscripciones sin DLQ y decisiones pendientes.                       [WARN / INFO]

Opcional (--ai): si hay credenciales de la API de Anthropic, envía un resumen del
modelo + hallazgos a Claude para una revisión narrativa (no bloqueante).

Salida: log en consola, docs/generated/review/review-report.{md,json}.
Código de salida: 1 si hay ERRORES (rechaza el PR), 0 en caso contrario.
"""
from __future__ import annotations

import argparse
import fnmatch
import json
import os
import re
import subprocess
import sys
from dataclasses import asdict, dataclass, field
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_WORKSPACE_JSON = ROOT / ".aac" / "workspace.json"
CHANGELOG = "docs/CHANGELOG_DSL.md"
DSL_DIR = "dsl/"
# Archivos generados dentro de dsl/ que no requieren entrada propia en la bitácora.
GENERATED_IN_DSL = {"dsl/views/themes/volarte-theme.json"}

# ---------------------------------------------------------------- Taxonomía de tags
FRONTEND_TAGS = {"Frontend", "Mobile"}
FORBIDDEN_FOR_FRONTEND = {"Database", "Cache", "Storage", "Queue", "Topic", "Subscription", "DomainService"}
OBSERVABILITY_TAG = "Observability"
RUNTIME_TAGS = {"BFF", "DomainService", "CloudRun", "GKE", "Frontend"}
STATEFUL_TAGS = {"Database", "Cache", "Queue"}

ENCRYPTED_PATTERN = re.compile(
    r"\b(TLS|HTTPS|mTLS|SSL|IAM|OIDC|OAuth|ZTNA|ID Token|in-process|Llamada in-process|"
    r"Pub/Sub delivery|Configuración de bucket|UI nativa)\b",
    re.IGNORECASE,
)
CHANGELOG_REQUIRED_FIELDS = [
    ("Fecha", re.compile(r"fecha", re.I)),
    ("Autor", re.compile(r"autor|arquitect", re.I)),
    ("Ref (HU / Jira)", re.compile(r"\bref\b|ticket|jira|historia|\bHU\b", re.I)),
    ("Módulo / Archivo", re.compile(r"m[oó]dulo|archivo", re.I)),
    ("Contexto & Justificación", re.compile(r"contexto|justificaci", re.I)),
    ("Impacto / ADR", re.compile(r"impacto|adr", re.I)),
]

SEVERITY_ORDER = {"ERROR": 0, "WARN": 1, "INFO": 2}


@dataclass
class Finding:
    rule: str
    severity: str
    element: str
    message: str
    recommendation: str = ""


@dataclass
class Element:
    id: str
    type: str
    name: str
    description: str
    technology: str
    tags: set[str]
    parent: "Element | None" = None
    properties: dict = field(default_factory=dict)

    @property
    def path(self) -> str:
        return f"{self.parent.path} › {self.name}" if self.parent else self.name

    def all_tags(self) -> set[str]:
        """Tags propios + los de sus ancestros (un componente hereda el rol de su contenedor)."""
        tags = set(self.tags)
        if self.parent:
            tags |= self.parent.all_tags()
        return tags

    def container(self) -> "Element | None":
        if self.type == "Container":
            return self
        return self.parent.container() if self.parent else None


@dataclass
class Relationship:
    id: str
    source: Element
    destination: Element
    description: str
    technology: str
    tags: set[str]
    implied: bool


# =============================================================================
# Carga del modelo
# =============================================================================
def split_tags(raw: str | None) -> set[str]:
    return {t.strip() for t in (raw or "").split(",") if t.strip()}


def load_model(workspace_json: Path):
    data = json.loads(workspace_json.read_text(encoding="utf-8"))
    model = data.get("model", {})
    elements: dict[str, Element] = {}
    raw_relationships: list[dict] = []

    def register(raw: dict, etype: str, parent: Element | None = None) -> Element:
        el = Element(
            id=raw["id"], type=etype, name=raw.get("name", ""),
            description=(raw.get("description") or "").strip(),
            technology=(raw.get("technology") or "").strip(),
            tags=split_tags(raw.get("tags")), parent=parent,
            properties=raw.get("properties", {}) or {},
        )
        elements[el.id] = el
        raw_relationships.extend(raw.get("relationships", []) or [])
        return el

    for p in model.get("people", []):
        register(p, "Person")
    for s in model.get("softwareSystems", []):
        ss = register(s, "SoftwareSystem")
        for c in s.get("containers", []) or []:
            ct = register(c, "Container", ss)
            for comp in c.get("components", []) or []:
                register(comp, "Component", ct)

    deployment_nodes: list[dict] = []

    def walk_nodes(nodes, ancestors):
        for n in nodes or []:
            chain = ancestors + [n]
            deployment_nodes.append({"node": n, "chain": chain})
            for inst in n.get("containerInstances", []) or []:
                raw_relationships.extend(inst.get("relationships", []) or [])
            for infra in n.get("infrastructureNodes", []) or []:
                raw_relationships.extend(infra.get("relationships", []) or [])
            walk_nodes(n.get("children"), chain)

    walk_nodes(model.get("deploymentNodes"), [])

    relationships = []
    for r in raw_relationships:
        src, dst = elements.get(r.get("sourceId")), elements.get(r.get("destinationId"))
        if not src or not dst:
            continue  # relaciones de despliegue entre nodos de infraestructura
        relationships.append(Relationship(
            id=r["id"], source=src, destination=dst,
            description=r.get("description", ""), technology=(r.get("technology") or "").strip(),
            tags=split_tags(r.get("tags")), implied="linkedRelationshipId" in r,
        ))
    return data, elements, relationships, deployment_nodes


# =============================================================================
# Reglas
# =============================================================================
def rule_descriptions(elements):
    for el in elements.values():
        if el.type in {"Person", "SoftwareSystem", "Container", "Component"} and not el.description:
            yield Finding("R1-Descripciones", "ERROR", el.path,
                          f"{el.type} sin descripción.",
                          "Agregue una descripción que explique la responsabilidad del elemento.")


def rule_technologies(elements):
    for el in elements.values():
        if el.type in {"Container", "Component"} and not el.technology:
            yield Finding("R2-Tecnologías", "ERROR", el.path,
                          f"{el.type} sin tecnología explícita.",
                          'Declare la tecnología (p. ej. "Python · FastAPI · Cloud Run").')


def rule_layer_isolation(relationships):
    for rel in relationships:
        if rel.implied:
            continue
        src_tags = rel.source.all_tags()
        if not (src_tags & FRONTEND_TAGS):
            continue
        same_container = rel.source.container() is not None and rel.source.container() is rel.destination.container()
        if same_container:
            continue  # p. ej. App Móvil → su base local WatermelonDB
        hit = rel.destination.all_tags() & FORBIDDEN_FOR_FRONTEND
        if hit:
            yield Finding("R3-Aislamiento de Capas", "ERROR",
                          f"{rel.source.path} → {rel.destination.path}",
                          f"Un elemento de frontend accede directamente a un elemento {sorted(hit)} "
                          f"sin pasar por BFF / API Gateway ({rel.technology or 'sin tecnología'}).",
                          "Enrute la llamada por Apigee → BFF del canal correspondiente.")


def git(*args: str) -> str:
    return subprocess.run(["git", *args], cwd=ROOT, capture_output=True, text=True, check=True).stdout


def changed_files(base: str | None) -> list[str]:
    if base:
        out = git("diff", "--name-only", f"{base}...HEAD")
    else:  # local: cambios sin commit (staged + unstaged + untracked) frente a HEAD
        out = git("diff", "--name-only", "HEAD") + git("ls-files", "--others", "--exclude-standard")
    return sorted({line.strip() for line in out.splitlines() if line.strip()})


def changelog_added_text(base: str | None) -> str:
    try:
        diff = git("diff", f"{base}...HEAD", "--", CHANGELOG) if base else git("diff", "HEAD", "--", CHANGELOG)
    except subprocess.CalledProcessError:
        diff = ""
    added = [l[1:] for l in diff.splitlines() if l.startswith("+") and not l.startswith("+++")]
    if not added and CHANGELOG in git("ls-files", "--others", "--exclude-standard").split():
        added = (ROOT / CHANGELOG).read_text(encoding="utf-8").splitlines()
    return "\n".join(added)


def rule_traceability(base: str | None, skip: bool):
    if skip:
        yield Finding("R4-Trazabilidad", "INFO", CHANGELOG, "Regla de trazabilidad omitida (--skip-traceability).")
        return
    try:
        files = changed_files(base)
    except (subprocess.CalledProcessError, FileNotFoundError) as exc:
        yield Finding("R4-Trazabilidad", "WARN", CHANGELOG, f"No fue posible calcular el diff de Git: {exc}")
        return
    dsl_changes = [f for f in files if f.startswith(DSL_DIR) and f not in GENERATED_IN_DSL]
    if not dsl_changes:
        yield Finding("R4-Trazabilidad", "INFO", CHANGELOG, "Sin cambios en dsl/ para este diff.")
        return
    if CHANGELOG not in files:
        yield Finding("R4-Trazabilidad", "ERROR", CHANGELOG,
                      f"Se modificaron {len(dsl_changes)} archivo(s) DSL sin entrada en la bitácora: {', '.join(dsl_changes)}.",
                      f"Agregue una entrada en {CHANGELOG} siguiendo la plantilla obligatoria.")
        return
    added = changelog_added_text(base)
    referenced = set(re.findall(r"`(dsl/[^`]+)`", added))
    uncovered = [f for f in dsl_changes if not any(fnmatch.fnmatch(f, pat) for pat in referenced)]
    if uncovered:
        yield Finding("R4-Trazabilidad", "ERROR", CHANGELOG,
                      f"La nueva entrada de la bitácora no referencia: {', '.join(uncovered)}.",
                      "Liste cada archivo (o un patrón glob) entre backticks en el campo 'Módulo / Archivo'.")
    missing = [name for name, pat in CHANGELOG_REQUIRED_FIELDS if not pat.search(added)]
    if missing:
        yield Finding("R4-Trazabilidad", "ERROR", CHANGELOG,
                      f"La nueva entrada no contiene los campos obligatorios: {', '.join(missing)}.",
                      "Use la plantilla de entrada definida al inicio de la bitácora.")
    if not uncovered and not missing:
        yield Finding("R4-Trazabilidad", "INFO", CHANGELOG,
                      f"{len(dsl_changes)} archivo(s) DSL modificados y cubiertos por la bitácora.")


def rule_suggestions(elements, relationships, deployment_nodes):
    explicit = [r for r in relationships if not r.implied]

    # --- 5a. SPOF en elementos con estado / alto fan-in
    deployed_ha: dict[str, bool] = {}
    for entry in deployment_nodes:
        ha = any(str(n.get("properties", {}).get("ha", "")).lower() == "true" for n in entry["chain"])
        instances = str(entry["node"].get("instances", "1"))
        for inst in entry["node"].get("containerInstances", []) or []:
            deployed_ha[inst["containerId"]] = ha or instances not in {"1", ""}
    fan_in: dict[str, set[str]] = {}
    for r in relationships:
        dc, sc = r.destination.container(), r.source.container()
        if dc and sc is not dc:
            fan_in.setdefault(dc.id, set()).add(sc.id if sc else r.source.id)
    for el in elements.values():
        if el.type != "Container" or el.id not in deployed_ha or deployed_ha[el.id]:
            continue
        if el.tags & FRONTEND_TAGS:
            continue  # se ejecuta en el cliente (navegador / dispositivo)
        consumers = len(fan_in.get(el.id, ()))
        if el.tags & STATEFUL_TAGS or consumers >= 4:
            yield Finding("R5-SPOF", "WARN", el.path,
                          f"Posible Single Point of Failure: {consumers} contenedor(es) dependen de él y su nodo "
                          f"de despliegue no declara alta disponibilidad (ha=true / instances>1).",
                          "Configure HA regional (Cloud SQL HA, Memorystore Standard Tier, réplicas) y declare "
                          'la propiedad "ha" "true" en el deploymentNode.')

    # --- 5b. Conexiones no cifradas
    for r in explicit:
        if r.source.type == "Person":
            continue
        if not r.technology or not ENCRYPTED_PATTERN.search(r.technology):
            yield Finding("R5-Cifrado", "WARN", f"{r.source.path} → {r.destination.path}",
                          f"Tramo sin cifrado explícito en la tecnología: '{r.technology or 'N/D'}'.",
                          "Declare el protocolo seguro (TLS 1.2+, mTLS, IAM) o documente la excepción en un ADR.")

    # --- 5c. Observabilidad
    observed: set[str] = set()
    for r in relationships:
        if OBSERVABILITY_TAG in r.destination.all_tags():
            c = r.source.container()
            observed.add(c.id if c else r.source.id)
    for el in elements.values():
        if el.type == "Container" and el.tags & RUNTIME_TAGS and el.id not in observed:
            yield Finding("R5-Observabilidad", "WARN", el.path,
                          "Contenedor sin relación hacia OTel Collector / Dynatrace.",
                          "Instrumente con OpenTelemetry (OTLP → OTel Collector → Dynatrace) según la política 'OTel First'.")

    # --- 5d. Suscripciones sin DLQ
    for el in elements.values():
        if "Subscription" in el.tags:
            if not any(r.source is el and "DLQ" in r.destination.tags for r in explicit):
                yield Finding("R5-Resiliencia", "WARN", el.path,
                              "Suscripción Pub/Sub sin Dead Letter Topic.",
                              "Configure dead_letter_policy (max_delivery_attempts) hacia el Dead Letter Topic.")

    # --- 5e. Decisiones pendientes
    for el in elements.values():
        if "Pending" in el.tags:
            yield Finding("R5-Decisión Pendiente", "INFO", el.path,
                          "Elemento marcado como decisión PENDING.",
                          "Cierre la decisión con un ADR (Accepted) y retire el tag Pending.")


# =============================================================================
# Revisión narrativa por IA (opcional)
# =============================================================================
AI_MODEL = os.environ.get("AAC_REVIEWER_MODEL", "claude-opus-5-5")
AI_SYSTEM = (
    "Eres un Lead Software Architect revisando el modelo C4 (Structurizr) del sistema Volarte de Terpel "
    "sobre GCP. Recibes un resumen del modelo y los hallazgos de un revisor determinista. Responde en español, "
    "en Markdown, con: 1) Resumen ejecutivo (3-5 líneas), 2) Top 5 riesgos priorizados con justificación, "
    "3) Recomendaciones concretas (qué elemento DSL cambiar), 4) Preguntas abiertas para la Dirección de "
    "Arquitectura. No repitas hallazgos triviales; no inventes elementos que no estén en el modelo."
)


def model_summary(elements, relationships) -> str:
    lines = ["## Elementos"]
    for el in sorted(elements.values(), key=lambda e: e.path):
        lines.append(f"- [{el.type}] {el.path} | tech: {el.technology or '-'} | tags: {','.join(sorted(el.tags))} | {el.description}")
    lines.append("\n## Relaciones explícitas")
    for r in relationships:
        if not r.implied:
            lines.append(f"- {r.source.path} -> {r.destination.path} | {r.description} | {r.technology}")
    return "\n".join(lines)


def ai_review(elements, relationships, findings) -> str | None:
    try:
        import anthropic
    except ImportError:
        print("[ai] Paquete 'anthropic' no instalado: se omite la revisión narrativa (pip install anthropic).")
        return None
    findings_md = "\n".join(f"- [{f.severity}] {f.rule} · {f.element}: {f.message}" for f in findings)
    prompt = f"{model_summary(elements, relationships)}\n\n## Hallazgos del revisor determinista\n{findings_md}"
    try:
        client = anthropic.Anthropic()
        with client.beta.messages.stream(
            model=AI_MODEL,
            max_tokens=16000,
            betas=["server-side-fallback-2026-07-01"],
            fallbacks="default",
            output_config={"effort": "high"},
            system=AI_SYSTEM,
            messages=[{"role": "user", "content": prompt}],
        ) as stream:
            message = stream.get_final_message()
    except anthropic.AuthenticationError:
        print("[ai] Sin credenciales válidas de Anthropic: se omite la revisión narrativa.")
        return None
    except anthropic.RateLimitError:
        print("[ai] Rate limit de la API: se omite la revisión narrativa en esta ejecución.")
        return None
    except anthropic.APIStatusError as exc:
        print(f"[ai] Error de API {exc.status_code}: se omite la revisión narrativa.")
        return None
    except anthropic.APIConnectionError:
        print("[ai] Sin conectividad con la API: se omite la revisión narrativa.")
        return None
    if message.stop_reason == "refusal":
        print("[ai] La solicitud fue rechazada por el modelo: se omite la revisión narrativa.")
        return None
    return "".join(b.text for b in message.content if b.type == "text").strip() or None


# =============================================================================
# Reportes
# =============================================================================
def write_reports(out_dir: Path, findings: list[Finding], stats: dict, ai_text: str | None) -> None:
    out_dir.mkdir(parents=True, exist_ok=True)
    (out_dir / "review-report.json").write_text(
        json.dumps({"stats": stats, "findings": [asdict(f) for f in findings], "ai_review": ai_text},
                   indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    counts = stats["counts"]
    verdict = "❌ RECHAZADO" if counts["ERROR"] else "✅ APROBADO"
    md = [
        "# Reporte del Agente Revisor de Arquitectura · Volarte", "",
        f"- **Resultado:** {verdict}",
        f"- **Fecha (UTC):** {stats['generated_at']}",
        f"- **Elementos analizados:** {stats['elements']} · **Relaciones explícitas:** {stats['explicit_relationships']}",
        f"- **Hallazgos:** {counts['ERROR']} errores · {counts['WARN']} advertencias · {counts['INFO']} informativos", "",
        "## Reglas", "",
        "| Regla | Severidad | Descripción |", "|---|---|---|",
        "| R1-Descripciones | ERROR | Todo Person, SoftwareSystem, Container y Component tiene descripción |",
        "| R2-Tecnologías | ERROR | Todo Container y Component declara tecnología |",
        "| R3-Aislamiento de Capas | ERROR | Frontend/Móvil no acceden a datos, colas ni servicios de dominio sin BFF/API Gateway |",
        "| R4-Trazabilidad | ERROR | Cambios en `dsl/` acompañados de entrada completa en `docs/CHANGELOG_DSL.md` |",
        "| R5-* (Sugerencias) | WARN/INFO | SPOF, cifrado, observabilidad, DLQ, decisiones pendientes |", "",
        "## Hallazgos", "",
        "| # | Severidad | Regla | Elemento | Hallazgo | Recomendación |", "|---|---|---|---|---|---|",
    ]
    for i, f in enumerate(findings, 1):
        cells = [str(i), f.severity, f.rule, f.element, f.message, f.recommendation]
        md.append("| " + " | ".join(c.replace("|", "\\|") for c in cells) + " |")
    if ai_text:
        md += ["", "## Revisión narrativa (IA)", "", f"_Modelo: {AI_MODEL}_", "", ai_text]
    (out_dir / "review-report.md").write_text("\n".join(md) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--workspace-json", type=Path, default=DEFAULT_WORKSPACE_JSON,
                        help="workspace.json exportado por structurizr-cli (export -format json)")
    parser.add_argument("--base", default=os.environ.get("AAC_BASE_REF"),
                        help="ref Git base para R4 (p. ej. origin/main). Sin valor: cambios locales vs HEAD")
    parser.add_argument("--skip-traceability", action="store_true", help="omite R4 (builds de main/release)")
    parser.add_argument("--warnings-as-errors", action="store_true", help="las advertencias R5 también rechazan")
    parser.add_argument("--ai", action="store_true", help="agrega revisión narrativa con Claude (requiere credenciales)")
    parser.add_argument("--out", type=Path, default=ROOT / "docs" / "generated" / "review")
    args = parser.parse_args()

    if not args.workspace_json.exists():
        print(f"[reviewer] No existe {args.workspace_json}. Ejecute primero: scripts/aac-build.sh --validate-only")
        return 2
    _, elements, relationships, deployment_nodes = load_model(args.workspace_json)

    findings: list[Finding] = [
        *rule_descriptions(elements),
        *rule_technologies(elements),
        *rule_layer_isolation(relationships),
        *rule_traceability(args.base, args.skip_traceability),
        *rule_suggestions(elements, relationships, deployment_nodes),
    ]
    findings.sort(key=lambda f: (SEVERITY_ORDER[f.severity], f.rule, f.element))
    counts = {s: sum(1 for f in findings if f.severity == s) for s in SEVERITY_ORDER}
    stats = {
        "generated_at": datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S"),
        "elements": len(elements),
        "explicit_relationships": sum(1 for r in relationships if not r.implied),
        "counts": counts,
    }

    icons = {"ERROR": "✖", "WARN": "⚠", "INFO": "ℹ"}
    print("=" * 78)
    print(" Agente Revisor de Arquitectura · Volarte")
    print("=" * 78)
    for f in findings:
        print(f"{icons[f.severity]} [{f.severity:5}] {f.rule:24} {f.element}\n      {f.message}")
        if f.recommendation and f.severity != "INFO":
            print(f"      ↳ {f.recommendation}")
    print("-" * 78)
    print(f" Errores: {counts['ERROR']}  ·  Advertencias: {counts['WARN']}  ·  Info: {counts['INFO']}")

    ai_text = ai_review(elements, relationships, findings) if args.ai else None
    write_reports(args.out, findings, stats, ai_text)
    print(f" Reporte: {args.out.relative_to(ROOT) if args.out.is_relative_to(ROOT) else args.out}/review-report.md")

    failed = counts["ERROR"] > 0 or (args.warnings_as_errors and counts["WARN"] > 0)
    print(" RESULTADO:", "RECHAZADO ❌" if failed else "APROBADO ✅")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
