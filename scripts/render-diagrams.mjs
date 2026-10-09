#!/usr/bin/env node
/**
 * Renderiza todas las vistas Mermaid (.mmd) de una versión a SVG, PNG y PNG alta
 * resolución, agregando a CADA diagrama la leyenda oficial C4 corporativa.
 * Reutiliza un único Chromium headless (Puppeteer + @mermaid-js/mermaid-cli).
 *
 * Uso: node scripts/render-diagrams.mjs <dir-mmd> <dir-salida> [escala-hires]
 *   -> <dir-salida>/svg/<vista>.svg, png/<vista>.png (x2), png-hires/<vista>.png (xN)
 */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { launchBrowser } from "./browser.mjs";
import { renderMermaid } from "@mermaid-js/mermaid-cli";

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const [mmdDir, outDir, hiresArg] = process.argv.slice(2);
if (!mmdDir || !outDir) {
  console.error("Uso: node scripts/render-diagrams.mjs <dir-mmd> <dir-salida> [escala-hires]");
  process.exit(2);
}
const hires = Number(hiresArg || 4);
const mermaidConfig = JSON.parse(fs.readFileSync(path.join(ROOT, "scripts", "mermaid-config.json"), "utf8"));

// Leyenda oficial C4 (docs/lineamientos/03-leyenda-c4.md). Única fuente de verdad en
// estandares/c4/estilos-c4.dsl: se lee de allí para que diagrama y leyenda nunca difieran.
const LEGEND_TAGS = ["Person", "Software System", "Container", "Component", "External Person", "External Software System"];
const stylesDsl = fs.readFileSync(path.join(ROOT, "estandares", "c4", "estilos-c4.dsl"), "utf8");
const LEGEND = LEGEND_TAGS.map((tag) => {
  const block = stylesDsl.match(new RegExp(`element "${tag}" \\{([^}]*)\\}`));
  const background = block && block[1].match(/background (#[0-9A-Fa-f]{6})/);
  if (!background) throw new Error(`estilos-c4.dsl no define background para "${tag}"`);
  return { tag, color: background[1] };
});

const esc = (s) => s.replace(/[&<>]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;" })[c]);

/** Agrega la leyenda C4 al pie del SVG ampliando su viewBox. */
function withLegend(svg) {
  const vb = svg.match(/viewBox="([\d.\-]+) ([\d.\-]+) ([\d.\-]+) ([\d.\-]+)"/);
  if (!vb) return svg;
  const [x, y, w, h] = vb.slice(1).map(Number);
  const pad = 24, sw = 250, sh = 44, gap = 10, titleH = 34, noteH = 30;
  const legendW = LEGEND.length * sw + (LEGEND.length - 1) * gap;
  const legendH = titleH + sh + noteH + pad;
  const newW = Math.max(w, legendW + 2 * pad);
  const newH = h + legendH + pad;
  const ox = x + pad, oy = y + h + pad;
  const font = "font-family:Open Sans,Arial,sans-serif";
  const items = LEGEND.map((l, i) => {
    const lx = ox + i * (sw + gap);
    return `<rect x="${lx}" y="${oy + titleH}" width="${sw}" height="${sh}" style="fill:${l.color};stroke:none"/>` +
      `<text x="${lx + 12}" y="${oy + titleH + sh / 2 + 6}" style="${font};font-size:16px;fill:#ffffff">${esc(l.tag)}</text>`;
  }).join("");
  const legend = `<g id="c4-legend">` +
    `<line x1="${ox}" y1="${oy - pad / 2}" x2="${ox + newW - 2 * pad}" y2="${oy - pad / 2}" style="stroke:#E5E7EB;stroke-width:1"/>` +
    `<text x="${ox}" y="${oy + 22}" style="${font};font-size:20px;font-weight:700;fill:#374151">Leyenda C4</text>` +
    items +
    `<text x="${ox}" y="${oy + titleH + sh + 22}" style="${font};font-size:13px;fill:#4B5563">` +
    `Notación: cilindro = almacén de datos · borde ámbar = decisión pendiente (tag Pending) · ` +
    `flecha = relación / dependencia, rotulada con propósito y [tecnología]</text>` +
    `</g>`;
  return svg
    .replace(vb[0], `viewBox="${x} ${y} ${newW} ${newH}"`)
    .replace(/(<svg[^>]*?) width="[\d.]+"/, `$1 width="${newW}"`)
    .replace(/(<svg[^>]*?) height="[\d.]+"/, `$1 height="${newH}"`)
    .replace(/<\/svg>\s*$/, `${legend}</svg>`);
}

async function rasterize(browser, svg, file, scale) {
  const vb = svg.match(/viewBox="[\d.\-]+ [\d.\-]+ ([\d.]+) ([\d.]+)"/);
  const width = Math.ceil(Number(vb[1])), height = Math.ceil(Number(vb[2]));
  const page = await browser.newPage();
  try {
    await page.setViewport({ width, height, deviceScaleFactor: scale });
    await page.setContent(`<!doctype html><html><body style="margin:0;background:#fff">${svg}</body></html>`, { waitUntil: "load" });
    await page.screenshot({ path: file, clip: { x: 0, y: 0, width, height }, omitBackground: false });
  } finally {
    await page.close();
  }
}

for (const dir of ["svg", "png", "png-hires"]) fs.mkdirSync(path.join(outDir, dir), { recursive: true });
const browser = await launchBrowser();
let failures = 0;
try {
  const files = fs.readdirSync(mmdDir).filter((f) => f.endsWith(".mmd")).sort();
  for (const file of files) {
    const name = path.basename(file, ".mmd");
    try {
      const definition = fs.readFileSync(path.join(mmdDir, file), "utf8");
      const { data } = await renderMermaid(browser, definition, "svg", { mermaidConfig, backgroundColor: "white" });
      const svg = withLegend(Buffer.from(data).toString("utf8"));
      fs.writeFileSync(path.join(outDir, "svg", `${name}.svg`), svg);
      await rasterize(browser, svg, path.join(outDir, "png", `${name}.png`), 2);
      await rasterize(browser, svg, path.join(outDir, "png-hires", `${name}.png`), hires);
      console.log(`  ✔ ${name}`);
    } catch (err) {
      failures += 1;
      console.error(`  ✖ ${name}: ${err.message}`);
    }
  }
  console.log(`[render] ${files.length - failures}/${files.length} vistas · SVG + PNG x2 + PNG x${hires} · leyenda C4 incluida`);
} finally {
  await browser.close();
}
process.exit(failures ? 1 : 0);
