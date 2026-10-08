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


if __name__ == "__main__":
    unittest.main()
