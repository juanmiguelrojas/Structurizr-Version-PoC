#!/usr/bin/env node
/**
 * Genera docs/generated/Volarte_Architecture_Specification.pdf
 * Unifica: portada, índice, diagramas vectoriales (SVG generados desde Mermaid), catálogo
 * del modelo (workspace.json), bitácora CHANGELOG_DSL, ADRs y reporte del
 * Agente Revisor. Renderiza con Puppeteer (Chromium headless).
 *
 * Uso: node scripts/render-pdf.mjs <workspace.json> <dir-svg> <salida.pdf>
 */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import puppeteer from "puppeteer";
import { marked } from "marked";

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const [workspacePath, diagramDir, outPdf] = process.argv.slice(2);
if (!workspacePath || !diagramDir || !outPdf) {
  console.error("Uso: node scripts/render-pdf.mjs <workspace.json> <dir-svg> <salida.pdf>");
  process.exit(2);
}

const ws = JSON.parse(fs.readFileSync(workspacePath, "utf8"));
const esc = (s = "") => String(s).replace(/[&<>"]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" })[c]);
const readMd = (p) => (fs.existsSync(p) ? marked.parse(fs.readFileSync(p, "utf8")) : "<p><em>No disponible.</em></p>");

// ----------------------------------------------------------------- Vistas
const v = ws.views || {};
const groups = [
  ["L0 · Vista Global de Integración", v.systemLandscapeViews],
  ["L1 · System Context", v.systemContextViews],
  ["L2 · Contenedores", v.containerViews],
  ["L3 · Componentes", v.componentViews],
  ["Vistas Dinámicas", v.dynamicViews],
  ["Despliegue", v.deploymentViews],
];
const views = groups.flatMap(([group, list]) => (list || []).map((view) => ({ group, ...view })));

const viewSections = views.map((view, i) => {
  const svg = path.join(diagramDir, `${view.key}.svg`);
  const img = fs.existsSync(svg)
    ? `<img src="data:image/svg+xml;base64,${fs.readFileSync(svg).toString("base64")}" alt="${esc(view.key)}"/>`
    : `<p class="warn">Diagrama no generado.</p>`;
  return `<section class="view">
    <div class="group">${esc(view.group)}</div>
    <h2>${i + 1}. ${esc(view.title || view.key)}</h2>
    <p class="meta"><code>${esc(view.key)}</code> · ${esc(view.description || "")}</p>
    <div class="diagram">${img}</div>
  </section>`;
}).join("\n");

// ----------------------------------------------------------------- Catálogo
const rows = [];
const add = (type, el, parent = "") =>
  rows.push(`<tr><td>${type}</td><td><strong>${esc(el.name)}</strong>${parent ? `<br/><span class="muted">${esc(parent)}</span>` : ""}</td><td>${esc(el.technology || "—")}</td><td>${esc(el.description || "")}</td></tr>`);
for (const p of ws.model.people || []) add("Person", p);
for (const s of ws.model.softwareSystems || []) {
  add("Software System", s);
  for (const c of s.containers || []) {
    add("Container", c, s.name);
    for (const comp of c.components || []) add("Component", comp, `${s.name} › ${c.name}`);
  }
}

// ----------------------------------------------------------------- ADRs
const adrDir = path.join(ROOT, "docs", "adr");
const adrs = fs.existsSync(adrDir)
  ? fs.readdirSync(adrDir).filter((f) => f.endsWith(".md")).sort().map((f) => `<div class="adr">${readMd(path.join(adrDir, f))}</div>`).join("\n")
  : "";

const props = ws.properties || {};
const now = new Date().toISOString().replace("T", " ").slice(0, 19) + " UTC";
const toc = views.map((view, i) => `<li><span>${esc(view.group)}</span> — ${i + 1}. ${esc(view.title || view.key)}</li>`).join("");

const html = `<!doctype html><html lang="es"><head><meta charset="utf-8"/>
<title>Volarte · Architecture Specification</title>
<style>
  @page { size: A3 landscape; margin: 14mm 14mm 16mm 14mm; }
  body { font-family: "Open Sans", Arial, sans-serif; color: #1f2937; font-size: 11pt; }
  h1 { color: #C8102E; font-size: 34pt; margin: 0 0 8px; }
  h2 { color: #0B3D91; border-bottom: 2px solid #C8102E; padding-bottom: 4px; }
  .cover { height: 250mm; display: flex; flex-direction: column; justify-content: center; border-left: 12px solid #C8102E; padding-left: 28px; }
  .cover .sub { font-size: 16pt; color: #374151; }
  .cover table td { padding: 4px 16px 4px 0; }
  section, .page { page-break-before: always; }
  .group { text-transform: uppercase; letter-spacing: .08em; color: #C8102E; font-weight: 700; font-size: 10pt; }
  .meta { color: #4b5563; }
  .diagram { text-align: center; }
  .diagram img { max-width: 100%; max-height: 225mm; object-fit: contain; }
  table.catalog { border-collapse: collapse; width: 100%; font-size: 9pt; }
  table.catalog th, table.catalog td { border: 1px solid #d1d5db; padding: 4px 6px; vertical-align: top; }
  table.catalog th { background: #0B3D91; color: #fff; }
  table { border-collapse: collapse; } td, th { border: 1px solid #e5e7eb; padding: 3px 6px; font-size: 9pt; }
  .muted { color: #6b7280; font-size: 8pt; }
  .adr { border-left: 4px solid #0B3D91; padding-left: 12px; margin-bottom: 18px; page-break-inside: avoid; }
  ul.toc li { margin: 2px 0; } ul.toc span { color: #6b7280; }
  code { background: #f3f4f6; padding: 1px 4px; border-radius: 3px; }
</style></head><body>
<div class="cover">
  <div class="group">Terpel · Dirección de Arquitectura</div>
  <h1>Volarte — Architecture Specification</h1>
  <div class="sub">${esc(ws.description || "")}</div>
  <table style="margin-top:24px">
    <tr><td><strong>Versión</strong></td><td>${esc(props["volarte.version"] || "-")} · Fase ${esc(props["volarte.fase"] || "-")}</td></tr>
    <tr><td><strong>Fuente</strong></td><td>Structurizr DSL (<code>dsl/workspace.dsl</code>) · origen ${esc(props["volarte.source"] || "-")}</td></tr>
    <tr><td><strong>Commit</strong></td><td><code>${esc(process.env.AAC_COMMIT || "local")}</code></td></tr>
    <tr><td><strong>Generado</strong></td><td>${now}</td></tr>
    <tr><td><strong>Vistas</strong></td><td>${views.length}</td></tr>
  </table>
</div>
<div class="page"><h2>Índice de vistas</h2><ul class="toc">${toc}</ul>
  <h2>Anexos</h2><ul><li>A. Catálogo del modelo</li><li>B. Bitácora de cambios (CHANGELOG_DSL)</li><li>C. Architecture Decision Records</li><li>D. Reporte del Agente Revisor</li></ul></div>
${viewSections}
<div class="page"><h2>A. Catálogo del modelo</h2>
  <table class="catalog"><thead><tr><th>Tipo</th><th>Elemento</th><th>Tecnología</th><th>Descripción</th></tr></thead><tbody>${rows.join("")}</tbody></table></div>
<div class="page"><h2>B. Bitácora de cambios</h2>${readMd(path.join(ROOT, "docs", "CHANGELOG_DSL.md"))}</div>
<div class="page"><h2>C. Architecture Decision Records</h2>${adrs}</div>
<div class="page"><h2>D. Reporte del Agente Revisor</h2>${readMd(path.join(ROOT, "docs", "generated", "review", "review-report.md"))}</div>
</body></html>`;

const launch = { args: ["--no-sandbox", "--disable-dev-shm-usage"] };
if (process.env.PUPPETEER_EXECUTABLE_PATH) launch.executablePath = process.env.PUPPETEER_EXECUTABLE_PATH;
const browser = await puppeteer.launch(launch);
try {
  const page = await browser.newPage();
  await page.setContent(html, { waitUntil: "load" });
  await page.pdf({
    path: outPdf, format: "A3", landscape: true, printBackground: true,
    displayHeaderFooter: true,
    headerTemplate: "<span></span>",
    footerTemplate: `<div style="font-size:8px;width:100%;padding:0 14mm;color:#6b7280;display:flex;justify-content:space-between">
      <span>Volarte · Architecture Specification · Terpel</span><span><span class="pageNumber"></span> / <span class="totalPages"></span></span></div>`,
  });
  console.log(`[pdf] ${path.relative(ROOT, outPdf)} (${views.length} vistas, ${rows.length} elementos)`);
} finally {
  await browser.close();
}
