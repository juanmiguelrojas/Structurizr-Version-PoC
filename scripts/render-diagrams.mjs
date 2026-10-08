#!/usr/bin/env node
/**
 * Renderiza todas las vistas Mermaid (.mmd) a SVG, PNG y PNG alta resolución
 * reutilizando un único Chromium headless (Puppeteer + @mermaid-js/mermaid-cli).
 *
 * Uso: node scripts/render-diagrams.mjs <dir-mmd> <dir-salida> [escala-hires]
 *   -> <dir-salida>/svg/<vista>.svg, png/<vista>.png (x2), png-hires/<vista>.png (xN)
 */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import puppeteer from "puppeteer";
import { renderMermaid } from "@mermaid-js/mermaid-cli";

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const [mmdDir, outDir, hiresArg] = process.argv.slice(2);
if (!mmdDir || !outDir) {
  console.error("Uso: node scripts/render-diagrams.mjs <dir-mmd> <dir-salida> [escala-hires]");
  process.exit(2);
}
const hires = Number(hiresArg || 4);
const mermaidConfig = JSON.parse(fs.readFileSync(path.join(ROOT, "scripts", "mermaid-config.json"), "utf8"));
const targets = [
  ["svg", "svg", 1],
  ["png", "png", 2],
  ["png-hires", "png", hires],
];
for (const [dir] of targets) fs.mkdirSync(path.join(outDir, dir), { recursive: true });

const launch = { headless: true, args: ["--no-sandbox", "--disable-dev-shm-usage"] };
if (process.env.PUPPETEER_EXECUTABLE_PATH) launch.executablePath = process.env.PUPPETEER_EXECUTABLE_PATH;
const browser = await puppeteer.launch(launch);
let failures = 0;
try {
  const files = fs.readdirSync(mmdDir).filter((f) => f.endsWith(".mmd")).sort();
  for (const file of files) {
    const name = path.basename(file, ".mmd");
    const definition = fs.readFileSync(path.join(mmdDir, file), "utf8");
    try {
      for (const [dir, format, scale] of targets) {
        const { data } = await renderMermaid(browser, definition, format, {
          mermaidConfig,
          backgroundColor: "white",
          viewport: { width: 1600, height: 1200, deviceScaleFactor: scale },
        });
        fs.writeFileSync(path.join(outDir, dir, `${name}.${format}`), data);
      }
      console.log(`  ✔ ${name}`);
    } catch (err) {
      failures += 1;
      console.error(`  ✖ ${name}: ${err.message}`);
    }
  }
  console.log(`[render] ${files.length - failures}/${files.length} vistas · SVG + PNG x2 + PNG x${hires}`);
} finally {
  await browser.close();
}
process.exit(failures ? 1 : 0);
