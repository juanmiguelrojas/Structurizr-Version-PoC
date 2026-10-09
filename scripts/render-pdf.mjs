#!/usr/bin/env node
/**
 * Genera la especificación PDF unificada de una versión de arquitectura.
 *
 * Contenido: portada (metadatos de la versión) · leyenda C4 · historial de versiones ·
 * documentación de la versión (docs/workspace) · diagramas vectoriales con leyenda ·
 * fichas técnicas por contenedor · catálogo de tecnologías · catálogo del modelo ·
 * bitácora del proyecto · ADRs · reporte del Agente Revisor.
 *
 * Uso: node scripts/render-pdf.mjs <dir-versión> <workspace.json> <dir-svg> <salida.pdf>
 */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import puppeteer from "puppeteer";
import { marked } from "marked";

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const [versionDir, workspacePath, diagramDir, outPdf] = process.argv.slice(2);
if (!versionDir || !workspacePath || !diagramDir || !outPdf) {
  console.error("Uso: node scripts/render-pdf.mjs <dir-versión> <workspace.json> <dir-svg> <salida.pdf>");
  process.exit(2);
}

const ws = JSON.parse(fs.readFileSync(workspacePath, "utf8"));
const meta = JSON.parse(fs.readFileSync(path.join(versionDir, "version.json"), "utf8"));
const projectDir = path.dirname(path.resolve(versionDir));
const esc = (s = "") => String(s).replace(/[&<>"]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" })[c]);
const md = (p) => (fs.existsSync(p) ? marked.parse(fs.readFileSync(p, "utf8")) : "<p><em>No disponible.</em></p>");
const tags = (el) => new Set(String(el.tags || "").split(",").map((t) => t.trim()).filter(Boolean));

// ------------------------------------------------------------------ Leyenda C4
const LEGEND = [
  ["Person", "#083F75", "Persona interna (usuario del tenant / organización)."],
  ["Software System", "#1061B0", "Sistema de software en el alcance del proyecto."],
  ["Container", "#23A2D9", "Unidad desplegable / ejecutable (app, servicio, base de datos, cola)."],
  ["Component", "#63BEF2", "Agrupación de funcionalidad dentro de un contenedor."],
  ["External Person", "#6C6477", "Persona fuera de la organización."],
  ["External Software System", "#8C8496", "Sistema fuera del alcance del proyecto (terceros, plataforma corporativa)."],
];
const legendHtml = `<table class="legend">${LEGEND.map(([t, c, d]) =>
  `<tr><td class="sw" style="background:${c}">${t}</td><td><code>${c}</code></td><td>${d}</td></tr>`).join("")}</table>`;

// ------------------------------------------------------------------ Índices del modelo
const byId = new Map();
const parentOf = new Map();
const all = [];
const reg = (el, type, parent) => { byId.set(el.id, { ...el, type }); if (parent) parentOf.set(el.id, parent.id); all.push(byId.get(el.id)); };
for (const p of ws.model.people || []) reg(p, "Person");
for (const s of ws.model.softwareSystems || []) {
  reg(s, "Software System");
  for (const c of s.containers || []) {
    reg(c, "Container", s);
    for (const comp of c.components || []) reg(comp, "Component", c);
  }
}
const containerOf = (id) => {
  let cur = byId.get(id);
  while (cur && cur.type !== "Container") cur = byId.get(parentOf.get(cur.id));
  return cur;
};
const relationships = all.flatMap((el) => (el.relationships || []).filter((r) => !r.linkedRelationshipId));
const label = (id) => {
  const el = byId.get(id);
  if (!el) return id;
  const parent = byId.get(parentOf.get(id));
  return parent && el.type === "Component" ? `${parent.name} › ${el.name}` : el.name;
};

// Despliegue: contenedor -> ruta de nodos
const deployedAt = new Map();
const walk = (nodes, chain, env) => {
  for (const n of nodes || []) {
    const c2 = [...chain, `${n.name}${n.technology ? ` (${n.technology})` : ""}`];
    for (const ci of n.containerInstances || []) {
      const list = deployedAt.get(ci.containerId) || [];
      list.push(`${env}: ${c2.join(" › ")}`);
      deployedAt.set(ci.containerId, list);
    }
    walk(n.children, c2, env);
  }
};
for (const n of ws.model.deploymentNodes || []) walk([n], [], n.environment);

// ------------------------------------------------------------------ Vistas
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
    <h2>4.${i + 1} ${esc(view.title || view.key)}</h2>
    <p class="meta"><code>${esc(view.key)}</code> · ${esc(view.description || "")}</p>
    <div class="diagram">${img}</div>
  </section>`;
}).join("\n");

// ------------------------------------------------------------------ Fichas técnicas
const inScope = (ws.model.softwareSystems || []).filter((s) => (s.containers || []).length);
const factSheets = inScope.flatMap((s) => (s.containers || []).map((c) => {
  const ids = new Set([c.id, ...(c.components || []).map((x) => x.id)]);
  const out = relationships.filter((r) => ids.has(r.sourceId) && !ids.has(r.destinationId));
  const inc = relationships.filter((r) => ids.has(r.destinationId) && !ids.has(r.sourceId));
  const rel = (list, key) => list.map((r) => `<li>${esc(label(r[key]))} — ${esc(r.description || "")} <span class="muted">[${esc(r.technology || "sin tecnología")}]</span></li>`).join("")
    || "<li class=\"muted\">—</li>";
  const comps = (c.components || []).map((x) => `<li><strong>${esc(x.name)}</strong> <span class="muted">[${esc(x.technology || "")}]</span> — ${esc(x.description || "")}</li>`).join("")
    || "<li class=\"muted\">Sin componentes modelados (nivel L2).</li>";
  const t = [...tags(c)].filter((x) => !["Element", "Container"].includes(x)).join(", ");
  return `<div class="sheet">
    <h3>${esc(c.name)} <span class="tech">${esc(c.technology || "")}</span></h3>
    <table class="kv">
      <tr><th>Responsabilidad</th><td>${esc(c.description || "")}</td></tr>
      <tr><th>Sistema</th><td>${esc(s.name)}</td></tr>
      <tr><th>Tags</th><td>${esc(t || "—")}</td></tr>
      <tr><th>Despliegue</th><td>${(deployedAt.get(c.id) || ["No modelado"]).map(esc).join("<br/>")}</td></tr>
    </table>
    <div class="cols">
      <div><h4>Depende de (salientes)</h4><ul>${rel(out, "destinationId")}</ul></div>
      <div><h4>Consumido por (entrantes)</h4><ul>${rel(inc, "sourceId")}</ul></div>
    </div>
    <h4>Componentes</h4><ul>${comps}</ul>
  </div>`;
})).join("\n");

// ------------------------------------------------------------------ Catálogo de tecnologías
const techMap = new Map();
for (const el of all) {
  if (!el.technology || !["Container", "Component"].includes(el.type)) continue;
  for (const tech of el.technology.split(/[·,+/]/).map((t) => t.trim()).filter((t) => t.length > 1)) {
    const list = techMap.get(tech) || [];
    list.push(`${label(el.id)} (${el.type})`);
    techMap.set(tech, list);
  }
}
const protoMap = new Map();
for (const r of relationships) {
  if (!r.technology) continue;
  const list = protoMap.get(r.technology) || [];
  list.push(`${label(r.sourceId)} → ${label(r.destinationId)}`);
  protoMap.set(r.technology, list);
}
const techRows = [...techMap.entries()].sort((a, b) => b[1].length - a[1].length || a[0].localeCompare(b[0]))
  .map(([t, l]) => `<tr><td><strong>${esc(t)}</strong></td><td>${l.length}</td><td>${l.map(esc).join("; ")}</td></tr>`).join("");
const protoRows = [...protoMap.entries()].sort((a, b) => b[1].length - a[1].length)
  .map(([t, l]) => `<tr><td><strong>${esc(t)}</strong></td><td>${l.length}</td><td>${l.slice(0, 6).map(esc).join("; ")}${l.length > 6 ? " …" : ""}</td></tr>`).join("");

// ------------------------------------------------------------------ Catálogo del modelo
const catalogRows = all.map((el) => {
  const parent = byId.get(parentOf.get(el.id));
  const type = el.type === "Person" && tags(el).has("External Person") ? "External Person"
    : el.type === "Software System" && tags(el).has("External Software System") ? "External Software System" : el.type;
  const color = LEGEND.find(([t]) => t === type)?.[1] || "#999";
  return `<tr><td><span class="dot" style="background:${color}"></span>${type}</td><td><strong>${esc(el.name)}</strong>${parent ? `<br/><span class="muted">${esc(parent.name)}</span>` : ""}</td><td>${esc(el.technology || "—")}</td><td>${esc(el.description || "")}</td></tr>`;
}).join("");

// ------------------------------------------------------------------ Historial de versiones
const versionRows = fs.readdirSync(projectDir).filter((d) => /^v\d+$/.test(d))
  .sort((a, b) => Number(a.slice(1)) - Number(b.slice(1)))
  .map((d) => {
    const m = JSON.parse(fs.readFileSync(path.join(projectDir, d, "version.json"), "utf8"));
    const current = d === meta.version ? " class=\"current\"" : "";
    return `<tr${current}><td><strong>${d}</strong></td><td>${esc(m.estado)}</td><td>${esc(m.fecha)}</td><td>${esc(m.basadaEn || "—")}</td><td>${esc((m.autores || []).join(", "))}</td><td>${esc((m.aprobadores || []).join(", ") || "—")}</td><td>${esc(m.descripcion)}</td></tr>`;
  }).join("");

const docsDir = path.join(versionDir, "docs", "workspace");
const workspaceDocs = fs.existsSync(docsDir)
  ? fs.readdirSync(docsDir).filter((f) => f.endsWith(".md")).sort().map((f) => `<div class="doc">${md(path.join(docsDir, f))}</div>`).join("\n") : "";
const adrDir = path.join(versionDir, "docs", "adr");
const adrs = fs.existsSync(adrDir)
  ? fs.readdirSync(adrDir).filter((f) => f.endsWith(".md")).sort().map((f) => `<div class="adr">${md(path.join(adrDir, f))}</div>`).join("\n") : "";

const now = new Date().toISOString().replace("T", " ").slice(0, 19) + " UTC";
const toc = views.map((view, i) => `<li><span>${esc(view.group)}</span> — 4.${i + 1} ${esc(view.title || view.key)}</li>`).join("");
const statusColor = { borrador: "#6B7280", "en-revision": "#D97706", aprobada: "#059669", reemplazada: "#6B7280", obsoleta: "#991B1B" }[meta.estado] || "#6B7280";

const html = `<!doctype html><html lang="es"><head><meta charset="utf-8"/>
<title>${esc(meta.nombre)} ${esc(meta.version)} · Architecture Specification</title>
<style>
  @page { size: A3 landscape; margin: 14mm 14mm 16mm 14mm; }
  body { font-family: "Open Sans", Arial, sans-serif; color: #1f2937; font-size: 11pt; }
  h1 { color: #083F75; font-size: 34pt; margin: 0 0 8px; }
  h2 { color: #083F75; border-bottom: 3px solid #1061B0; padding-bottom: 4px; }
  h3 { color: #1061B0; margin-bottom: 4px; } h4 { margin: 8px 0 4px; color: #374151; }
  .cover { height: 250mm; display: flex; flex-direction: column; justify-content: center; border-left: 14px solid #1061B0; padding-left: 28px; }
  .cover .sub { font-size: 16pt; color: #374151; max-width: 320mm; }
  .cover table td { padding: 4px 16px 4px 0; border: none; font-size: 12pt; }
  .badge { display: inline-block; padding: 2px 12px; border-radius: 12px; color: #fff; font-weight: 700; }
  section, .page { page-break-before: always; }
  .group { text-transform: uppercase; letter-spacing: .08em; color: #1061B0; font-weight: 700; font-size: 10pt; }
  .meta { color: #4b5563; }
  .diagram { text-align: center; }
  .diagram img { max-width: 100%; max-height: 222mm; object-fit: contain; }
  table { border-collapse: collapse; width: 100%; }
  td, th { border: 1px solid #d1d5db; padding: 4px 6px; vertical-align: top; font-size: 9pt; text-align: left; }
  th { background: #083F75; color: #fff; }
  table.kv th { width: 34mm; background: #EFF6FF; color: #083F75; }
  table.legend td { font-size: 11pt; padding: 8px; } td.sw { color: #fff; font-weight: 700; width: 70mm; }
  tr.current td { background: #EFF6FF; font-weight: 600; }
  .muted { color: #6b7280; font-size: 8pt; }
  .dot { display: inline-block; width: 10px; height: 10px; border-radius: 2px; margin-right: 6px; }
  .sheet { page-break-inside: avoid; border: 1px solid #d1d5db; border-left: 6px solid #23A2D9; padding: 8px 14px; margin-bottom: 14px; }
  .sheet .tech { font-size: 10pt; color: #6b7280; font-weight: 400; }
  .sheet ul { margin: 2px 0 6px 18px; padding: 0; font-size: 9pt; }
  .cols { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
  .adr, .doc { border-left: 4px solid #1061B0; padding-left: 12px; margin-bottom: 18px; }
  .adr { page-break-inside: avoid; }
  ul.toc li { margin: 2px 0; } ul.toc span { color: #6b7280; }
  code { background: #f3f4f6; padding: 1px 4px; border-radius: 3px; }
</style></head><body>
<div class="cover">
  <div class="group">Terpel · Dirección de Arquitectura · Architecture as Code</div>
  <h1>${esc(meta.nombre)} — Architecture Specification</h1>
  <div class="sub">${esc(ws.description || "")}</div>
  <table style="margin-top:24px">
    <tr><td><strong>Versión</strong></td><td>${esc(meta.version)} <span class="badge" style="background:${statusColor}">${esc(meta.estado)}</span></td></tr>
    <tr><td><strong>Basada en</strong></td><td>${esc(meta.basadaEn || "—")}</td></tr>
    <tr><td><strong>Autores</strong></td><td>${esc((meta.autores || []).join(", "))}</td></tr>
    <tr><td><strong>Aprobadores</strong></td><td>${esc((meta.aprobadores || []).join(", ") || "Pendiente de aprobación")}</td></tr>
    <tr><td><strong>Fuente</strong></td><td><code>${esc(path.relative(ROOT, path.join(versionDir, "dsl", "workspace.dsl")))}</code></td></tr>
    <tr><td><strong>Commit</strong></td><td><code>${esc(process.env.AAC_COMMIT || "local")}</code></td></tr>
    <tr><td><strong>Generado</strong></td><td>${now}</td></tr>
  </table>
</div>
<div class="page"><h2>Contenido</h2>
  <ol><li>Leyenda C4 y convenciones</li><li>Historial de versiones</li><li>Documentación de la arquitectura</li><li>Diagramas (${views.length} vistas)</li>
  <li>Fichas técnicas por contenedor</li><li>Catálogo de tecnologías y protocolos</li><li>Catálogo del modelo</li><li>Bitácora de cambios</li><li>Architecture Decision Records</li><li>Reporte del Agente Revisor</li></ol>
  <h3>Vistas</h3><ul class="toc">${toc}</ul></div>
<div class="page"><h2>1. Leyenda C4 y convenciones</h2>
  <p>Todos los diagramas siguen la <strong>leyenda oficial C4</strong> adoptada por la Dirección de Arquitectura
  (<code>estandares/c4/estilos-c4.dsl</code>). El color identifica el <em>tipo</em> de elemento C4; las formas solo agregan semántica.</p>
  ${legendHtml}
  <h4>Convenciones adicionales</h4>
  <ul><li><strong>Cilindro</strong>: almacén de datos (base de datos, cache, bucket).</li>
  <li><strong>Borde ámbar</strong>: decisión arquitectónica pendiente (tag <code>Pending</code>).</li>
  <li><strong>Flechas</strong>: dependencia / flujo, rotuladas con propósito y <code>[tecnología · protocolo]</code>.</li>
  <li><strong>Recuadros punteados</strong>: agrupaciones lógicas (dominios, proyectos GCP, capas).</li></ul></div>
<div class="page"><h2>2. Historial de versiones del proyecto</h2>
  <table><thead><tr><th>Versión</th><th>Estado</th><th>Fecha</th><th>Basada en</th><th>Autores</th><th>Aprobadores</th><th>Descripción</th></tr></thead><tbody>${versionRows}</tbody></table></div>
<div class="page"><h2>3. Documentación de la arquitectura</h2>${workspaceDocs}</div>
${viewSections}
<div class="page"><h2>5. Fichas técnicas por contenedor</h2>
  <p class="meta">Generadas automáticamente desde el modelo: responsabilidad, despliegue, dependencias e integraciones de cada contenedor.</p>${factSheets}</div>
<div class="page"><h2>6. Catálogo de tecnologías y protocolos</h2>
  <h3>Tecnologías (contenedores y componentes)</h3>
  <table><thead><tr><th>Tecnología</th><th>#</th><th>Usada por</th></tr></thead><tbody>${techRows}</tbody></table>
  <h3>Protocolos de integración (relaciones)</h3>
  <table><thead><tr><th>Protocolo / tecnología</th><th>#</th><th>Ejemplos</th></tr></thead><tbody>${protoRows}</tbody></table></div>
<div class="page"><h2>7. Catálogo del modelo</h2>
  <table><thead><tr><th>Tipo C4</th><th>Elemento</th><th>Tecnología</th><th>Descripción</th></tr></thead><tbody>${catalogRows}</tbody></table></div>
<div class="page"><h2>8. Bitácora de cambios</h2>${md(path.join(projectDir, "CHANGELOG_DSL.md"))}</div>
<div class="page"><h2>9. Architecture Decision Records</h2>${adrs}</div>
<div class="page"><h2>10. Reporte del Agente Revisor</h2>${md(path.join(versionDir, "docs", "generated", "review", "review-report.md"))}</div>
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
      <span>${esc(meta.nombre)} · ${esc(meta.version)} (${esc(meta.estado)}) · Architecture Specification · Terpel</span><span><span class="pageNumber"></span> / <span class="totalPages"></span></span></div>`,
  });
  console.log(`[pdf] ${path.relative(ROOT, outPdf)} (${views.length} vistas, ${all.length} elementos)`);
} finally {
  await browser.close();
}
