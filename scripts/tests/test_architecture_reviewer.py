"""Pruebas unitarias del Agente Revisor (python3 -m unittest discover -s scripts/tests)."""
import json
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
import architecture_reviewer as ar  # noqa: E402


def workspace(containers, relationships_by_source=None, people=None):
    rels = relationships_by_source or {}
    def attach(el):
        el = dict(el)
        el["relationships"] = rels.get(el["id"], [])
        return el
    return {"model": {
        "people": [attach(p) for p in (people or [])],
        "softwareSystems": [{
            "id": "1", "name": "Sistema", "description": "desc", "tags": "Element,Software System",
            "containers": [{**attach(c), "components": [attach(x) for x in c.get("components", [])]} for c in containers],
        }],
    }}


def run(ws):
    with tempfile.NamedTemporaryFile("w", suffix=".json", delete=False) as fh:
        json.dump(ws, fh)
    _, elements, rels, nodes = ar.load_model(Path(fh.name))
    return elements, rels, nodes


class ReviewerRules(unittest.TestCase):
    def test_r1_r2_missing_description_and_technology(self):
        elements, _, _ = run(workspace([{"id": "2", "name": "API", "description": "", "technology": "", "tags": "Container"}]))
        self.assertEqual(len(list(ar.rule_descriptions(elements))), 1)
        self.assertEqual(len(list(ar.rule_technologies(elements))), 1)

    def test_r3_frontend_to_database_is_rejected(self):
        ws = workspace(
            [{"id": "2", "name": "SPA", "description": "d", "technology": "React", "tags": "Container,Frontend"},
             {"id": "3", "name": "DB", "description": "d", "technology": "PostgreSQL", "tags": "Container,Database"}],
            {"2": [{"id": "10", "sourceId": "2", "destinationId": "3", "technology": "SQL"}]})
        _, rels, _ = run(ws)
        findings = list(ar.rule_layer_isolation(rels))
        self.assertEqual(len(findings), 1)
        self.assertEqual(findings[0].severity, "ERROR")

    def test_r3_frontend_component_to_local_store_is_allowed(self):
        ws = workspace([{"id": "2", "name": "App", "description": "d", "technology": "RN", "tags": "Container,Mobile",
                         "components": [
                             {"id": "4", "name": "UI", "description": "d", "technology": "TS", "tags": "Component"},
                             {"id": "5", "name": "SQLite", "description": "d", "technology": "SQLite", "tags": "Component,LocalDatabase"}]}],
                       {"4": [{"id": "11", "sourceId": "4", "destinationId": "5", "technology": "in-process"}]})
        _, rels, _ = run(ws)
        self.assertEqual(list(ar.rule_layer_isolation(rels)), [])

    def test_r3_frontend_through_bff_is_allowed(self):
        ws = workspace(
            [{"id": "2", "name": "SPA", "description": "d", "technology": "React", "tags": "Container,Frontend"},
             {"id": "3", "name": "BFF", "description": "d", "technology": "FastAPI", "tags": "Container,BFF"}],
            {"2": [{"id": "10", "sourceId": "2", "destinationId": "3", "technology": "HTTPS"}]})
        _, rels, _ = run(ws)
        self.assertEqual(list(ar.rule_layer_isolation(rels)), [])

    def test_r5_unencrypted_and_missing_observability(self):
        ws = workspace(
            [{"id": "2", "name": "Svc", "description": "d", "technology": "Cloud Run", "tags": "Container,DomainService"},
             {"id": "3", "name": "Redis", "description": "d", "technology": "Redis", "tags": "Container,Cache"}],
            {"2": [{"id": "10", "sourceId": "2", "destinationId": "3", "technology": "Redis SDK"}]})
        elements, rels, nodes = run(ws)
        rules = {f.rule for f in ar.rule_suggestions(elements, rels, nodes)}
        self.assertIn("R5-Cifrado", rules)
        self.assertIn("R5-Observabilidad", rules)


    def test_r7_legend_ok_and_wrong_color(self):
        good = [{"tag": t, "background": c} for t, c in ar.C4_LEGEND.items()] + [{"tag": "Database", "shape": "Cylinder"}]
        elements, _, _ = run(workspace([]))
        errors = [f for f in ar.rule_c4_legend({"views": {"configuration": {"styles": {"elements": good}}}}, elements) if f.severity == "ERROR"]
        self.assertEqual(errors, [])
        bad = good + [{"tag": "Database", "background": "#0F9D58"}]
        findings = list(ar.rule_c4_legend({"views": {"configuration": {"styles": {"elements": bad}}}}, elements))
        self.assertTrue(any(f.rule == "R7-Leyenda C4" and f.severity == "ERROR" for f in findings))

    def test_r7_pending_may_only_set_stroke(self):
        styles = [{"tag": t, "background": c} for t, c in ar.C4_LEGEND.items()] + [{"tag": "Pending", "stroke": "#F59E0B"}]
        elements, _, _ = run(workspace([]))
        errors = [f for f in ar.rule_c4_legend({"views": {"configuration": {"styles": {"elements": styles}}}}, elements) if f.severity == "ERROR"]
        self.assertEqual(errors, [])

    def test_r7_external_person_tag_required(self):
        styles = [{"tag": t, "background": c} for t, c in ar.C4_LEGEND.items()]
        ws = workspace([], people=[{"id": "9", "name": "Cliente", "description": "d", "tags": "Element,Person,External"}])
        elements, _, _ = run(ws)
        findings = list(ar.rule_c4_legend({"views": {"configuration": {"styles": {"elements": styles}}}}, elements))
        self.assertTrue(any("External Person" in f.message for f in findings))

    def test_r6_locked_version_rejects_changes(self):
        original = ar.aac_versions.meta_at
        ar.aac_versions.meta_at = lambda ref, vdir: {"estado": "aprobada"}
        try:
            findings = list(ar.rule_immutability("proyectos/x/v1", ["proyectos/x/v1/dsl/workspace.dsl"], "origin/main"))
            self.assertEqual(findings[0].severity, "ERROR")
            only_meta = list(ar.rule_immutability("proyectos/x/v1", ["proyectos/x/v1/version.json"], "origin/main"))
            self.assertEqual(only_meta[0].severity, "INFO")
        finally:
            ar.aac_versions.meta_at = original

    def test_r6_editable_version_allows_changes(self):
        original = ar.aac_versions.meta_at
        ar.aac_versions.meta_at = lambda ref, vdir: {"estado": "en-revision"}
        try:
            self.assertEqual(list(ar.rule_immutability("proyectos/x/v2", ["proyectos/x/v2/dsl/a.dsl"], "origin/main")), [])
        finally:
            ar.aac_versions.meta_at = original

    def test_r8_metadata_of_real_versions(self):
        for vdir in ar.aac_versions.list_versions():
            rel = ar.aac_versions.rel(vdir)
            self.assertEqual([f for f in ar.rule_version_metadata(rel) if f.severity == "ERROR"], [], rel)


if __name__ == "__main__":
    unittest.main()
