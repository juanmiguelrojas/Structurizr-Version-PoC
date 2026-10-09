"""Pruebas del importador Draw.io y de la validación de fidelidad (python3 -m unittest discover -s scripts/tests)."""
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
import c4_scene  # noqa: E402
import drawio2structurizr as d2s  # noqa: E402
import drawio_inventory as inv  # noqa: E402


class Importador(unittest.TestCase):
    def test_split_label_separa_tecnologia(self):
        self.assertEqual(d2s.split_label("Delega autenticación [OIDC / OAuth 2.0]"), ("Delega autenticación", "OIDC / OAuth 2.0"))
        self.assertEqual(d2s.split_label("Redis SDK"), ("Redis SDK", ""))

    def test_identificadores_ascii(self):
        self.assertEqual(d2s.camel("Svc: Asignación / Optimización"), "svcAsignacionOptimizacion")
        self.assertEqual(d2s.camel("BFF — Backend Volarte"), "bffBackendVolarte")

    def test_comillas_se_escapan_en_dsl(self):
        self.assertEqual(d2s.q('destino: "portal"'), '"destino: \\"portal\\""')

    def test_html_drawio_a_texto(self):
        self.assertEqual(inv.clean('Accede al portal (HTTPS)<br style="font-size: 9px;">Navega wiki'),
                         "Accede al portal (HTTPS)\nNavega wiki")
        self.assertEqual(inv.html_font('<span style="font-size: 9px; color: rgb(0, 0, 0);">x</span>'),
                         {"px": 9, "color": "#000000"})


class Fidelidad(unittest.TestCase):
    def scene(self, nombre="API", fill="#23A2D9", etiqueta="usa"):
        return {"nodos": [{"id": "n1", "nombre": nombre, "tipo": "Container", "tecnologia": "FastAPI",
                           "descripcion": "d", "fill": fill, "forma": "caja", "alias": []}],
                "conectores": [{"id": "e1", "etiqueta": etiqueta, "anotacion": False}]}

    def test_escenas_identicas_son_fieles(self):
        r = c4_scene.compare(self.scene(), self.scene(), [])
        self.assertEqual(r["fidelidad"], 100.0)
        self.assertEqual(r["diferencias"], [])

    def test_detecta_color_texto_y_etiqueta(self):
        r = c4_scene.compare(self.scene(nombre="API v2", fill="#8C8496", etiqueta="llama"), self.scene(), [])
        campos = {d["campo"] for d in r["diferencias"]}
        self.assertEqual(campos, {"nombre", "color", "etiqueta"})
        self.assertLess(r["fidelidad"], 100.0)

    def test_espacio_antes_de_tecnologia_es_formato(self):
        self.assertEqual(c4_scene.one("Federa sesión[SAML]"), c4_scene.one("Federa sesión [SAML]"))


if __name__ == "__main__":
    unittest.main()
