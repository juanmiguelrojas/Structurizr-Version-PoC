#!/usr/bin/env node
/**
 * Motor de render C4 con notación Draw.io (librería C4) para escenas generadas por
 * scripts/c4_scene.py.
 *
 *  - Persona = silueta (cabeza + cuerpo redondeado, como mxgraph.c4.person2), nunca una caja.
 *  - Cilindro para almacenes de datos, cajas redondeadas para sistemas / contenedores / componentes.
 *  - Boundaries punteados con etiqueta inferior izquierda (nombre + [aplicación]).
 *  - Conectores ortogonales con esquinas redondeadas, waypoints y anclajes del Draw.io,
 *    etiquetas con el color / tamaño de fuente originales.
 *  - Leyenda oficial C4 en cada vista publicada.
 *
 * Uso: node scripts/render-c4.mjs <dir-escenas> <dir-salida> [escala-hires]
 *   *.modelo.json -> <salida>/svg, <salida>/png (x2), <salida>/png-hires (xN)
 *   *.drawio.json -> <salida>/referencia-drawio/{svg,png}  (render de la página Draw.io original)
 */
import fs from "node:fs";
import path from "node:path";
import { launchBrowser } from "./browser.mjs";

const [scenesDir, outDir, hiresArg] = process.argv.slice(2);
if (!scenesDir || !outDir) {
  console.error("Uso: node scripts/render-c4.mjs <dir-escenas> <dir-salida> [escala-hires]");
  process.exit(2);
}
const hires = Number(hiresArg || 4);

/* ------------------------------------------------------------------ dibujo (se ejecuta en Chromium) */
function renderScene(scene) {
  const FONT = "Helvetica, Arial, sans-serif";
  const canvas = document.createElement("canvas");
  const ctx = canvas.getContext("2d");
  const esc = (s) => String(s ?? "").replace(/[&<>"]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" })[c]);
  const sty = (style, key, def) => {
    const m = (style || "").match(new RegExp("(?:^|;)" + key.replace(/[.*+?^${}()|[\]\\]/g, "\\$&") + "=([^;]*)"));
    return m ? m[1] : def;
  };
  const width = (t, px, bold) => { ctx.font = `${bold ? "bold " : ""}${px}px ${FONT}`; return ctx.measureText(t).width; };
  const wrap = (text, px, bold, maxW) => {
    const out = [];
    for (const para of String(text ?? "").split("\n")) {
      const words = para.split(/\s+/).filter(Boolean);
      let line = "";
      for (const w of words) {
        const cand = line ? line + " " + w : w;
        if (width(cand, px, bold) <= maxW || !line) line = cand; else { out.push(line); line = w; }
      }
      if (line) out.push(line);
    }
    return out;
  };

  // --------------------------------------------------------------- límites del lienzo
  const rects = [...scene.boundaries, ...scene.nodos, ...scene.notas];
  const ids = new Set([...scene.boundaries, ...scene.nodos, ...scene.notas].map((r) => r.id));
  const pts = scene.conectores.flatMap((c) => [...(c.puntos || []),
    ...(!ids.has(c.origen) && c.extremos && c.extremos.sourcePoint ? [c.extremos.sourcePoint] : []),
    ...(!ids.has(c.destino) && c.extremos && c.extremos.targetPoint ? [c.extremos.targetPoint] : [])]);
  let minX = Math.min(...rects.map((r) => r.x), ...pts.map((p) => p.x)) - 30;
  let minY = Math.min(...rects.map((r) => r.y), ...pts.map((p) => p.y)) - 30;
  let maxX = Math.max(...rects.map((r) => r.x + r.w), ...pts.map((p) => p.x)) + 30;
  let maxY = Math.max(...rects.map((r) => r.y + r.h), ...pts.map((p) => p.y)) + 30;
  const legendW = 260, legendH = 6 * 30 + 40;
  if (scene.leyenda && !scene.leyendaEn) maxY += legendH + 30;
  const W = Math.ceil(maxX - minX), H = Math.ceil(maxY - minY + 26);
  const out = [];
  out.push(`<svg xmlns="http://www.w3.org/2000/svg" width="${W}" height="${H}" viewBox="${minX} ${minY} ${W} ${H}" font-family="${FONT}">`);
  out.push(`<defs>
    <marker id="aBlock" viewBox="0 0 10 10" refX="9.5" refY="5" markerWidth="9" markerHeight="9" orient="auto-start-reverse" markerUnits="userSpaceOnUse"><path d="M0,0 L10,5 L0,10 z" fill="context-stroke"/></marker>
    <marker id="aClassic" viewBox="0 0 10 10" refX="9.5" refY="5" markerWidth="10" markerHeight="10" orient="auto-start-reverse" markerUnits="userSpaceOnUse"><path d="M0,0 L10,5 L0,10 L2.5,5 z" fill="context-stroke"/></marker>
    <marker id="aOpen" viewBox="0 0 10 10" refX="9.5" refY="5" markerWidth="10" markerHeight="10" orient="auto-start-reverse" markerUnits="userSpaceOnUse"><path d="M0,0 L10,5 L0,10" fill="none" stroke="context-stroke" stroke-width="1.4"/></marker>
  </defs>`);
  out.push(`<rect x="${minX}" y="${minY}" width="${W}" height="${H}" fill="#ffffff"/>`);

  const textLines = (lines, x, y, anchor) => lines.map((l, i) =>
    `<text x="${x}" y="${y + i * l.lh}" font-size="${l.px}" ${l.bold ? 'font-weight="bold"' : ""} fill="${l.color}" text-anchor="${anchor}">${esc(l.t)}</text>`).join("");

  // --------------------------------------------------------------- boundaries
  const bsorted = [...scene.boundaries].sort((a, b) => b.w * b.h - a.w * a.h);
  for (const b of bsorted) {
    const stroke = sty(b.style, "strokeColor", "#666666");
    const dash = sty(b.style, "dashPattern", "8 4");
    const arc = Number(sty(b.style, "arcSize", 20));
    const rx = sty(b.style, "absoluteArcSize", "0") === "1" ? arc / 2 : Math.min(b.w, b.h) * arc / 200;
    out.push(`<rect x="${b.x}" y="${b.y}" width="${b.w}" height="${b.h}" rx="${Math.min(rx, 16)}" fill="none" stroke="${stroke}" stroke-width="1" stroke-dasharray="${dash.replace(/\s+/g, ",")}"/>`);
    const color = sty(b.style, "fontColor", "#333333");
    const px = Number(sty(b.style, "fontSize", 11));
    const lines = [{ t: b.nombre, px: 16, bold: true, color, lh: 19 },
      ...(b.etiqueta ? ("[" + b.etiqueta + "]").split("\n").map((t) => ({ t, px, color, lh: px * 1.25 })) : [])];
    let y = b.y + b.h - 10;
    for (let i = lines.length - 1; i >= 0; i--) { lines[i].y = y; y -= lines[i].lh; }
    out.push(lines.map((l) => `<text x="${b.x + 10}" y="${l.y}" font-size="${l.px}" ${l.bold ? 'font-weight="bold"' : ""} fill="${l.color}">${esc(l.t)}</text>`).join(""));
  }

  // --------------------------------------------------------------- notas libres (texto, tabla de leyenda del Draw.io)
  for (const n of scene.notas) {
    const fill = sty(n.style, "fillColor", "none");
    const stroke = sty(n.style, "strokeColor", "none");
    const color = sty(n.style, "fontColor", "#000000");
    const px = Number((n.fuente && n.fuente.px) || sty(n.style, "fontSize", 12));
    const nrx = sty(n.style, "rounded", "0") === "1" ? Math.min(n.w, n.h) * Number(sty(n.style, "arcSize", 10)) / 100 : 0;
    if (fill !== "none") out.push(`<rect x="${n.x}" y="${n.y}" width="${n.w}" height="${n.h}" rx="${nrx}" fill="${fill}" stroke="${stroke}" stroke-width="${sty(n.style, "strokeWidth", 1)}"/>`);
    const lines = (n.texto || "").split("\n").flatMap((t) => wrap(t, px, false, Math.max(n.w - 6, 40)));
    const lh = px * 1.2;
    if (n.forma === "table") {
      out.push(textLines([{ t: lines[0] || "", px: px + 2, bold: true, color, lh }], n.x + 4, n.y + px + 4, "start"));
    } else if (n.forma === "partialRectangle") {
      out.push(textLines(lines.map((t) => ({ t, px, color, lh })), n.x + 8, n.y + n.h / 2 + px / 3, "start"));
    } else {
      const y0 = n.y + n.h / 2 - (lines.length * lh) / 2 + px * 0.85;
      out.push(textLines(lines.map((t) => ({ t, px, color, lh })), n.x + n.w / 2, y0, "middle"));
    }
  }

  // --------------------------------------------------------------- conectores
  const rectOf = {};
  for (const r of [...scene.nodos, ...scene.boundaries, ...scene.notas]) rectOf[r.id] = r;
  const center = (r) => ({ x: r.x + r.w / 2, y: r.y + r.h / 2 });
  const side = (r, fx, fy) => {
    if (fx <= 0.001) return "L"; if (fx >= 0.999) return "R"; if (fy <= 0.001) return "T"; if (fy >= 0.999) return "B";
    const d = { L: fx, R: 1 - fx, T: fy, B: 1 - fy };
    return Object.keys(d).sort((a, b) => d[a] - d[b])[0];
  };
  const anchorTo = (r, ref) => { // ancla ortogonal hacia un punto de referencia
    if (!r) return { p: ref, s: "R" };
    if (ref.x >= r.x && ref.x <= r.x + r.w) return ref.y < r.y ? { p: { x: ref.x, y: r.y }, s: "T" } : ref.y > r.y + r.h ? { p: { x: ref.x, y: r.y + r.h }, s: "B" } : { p: center(r), s: "T" };
    if (ref.y >= r.y && ref.y <= r.y + r.h) return ref.x < r.x ? { p: { x: r.x, y: ref.y }, s: "L" } : { p: { x: r.x + r.w, y: ref.y }, s: "R" };
    const c = center(r), dx = ref.x - c.x, dy = ref.y - c.y;
    if (Math.abs(dx) / r.w > Math.abs(dy) / r.h) return dx < 0 ? { p: { x: r.x, y: c.y }, s: "L" } : { p: { x: r.x + r.w, y: c.y }, s: "R" };
    return dy < 0 ? { p: { x: c.x, y: r.y }, s: "T" } : { p: { x: c.x, y: r.y + r.h }, s: "B" };
  };
  const constrained = (r, style, pre) => {
    const fx = sty(style, pre + "X"), fy = sty(style, pre + "Y");
    if (!r || fx === undefined || fy === undefined) return null;
    const x = Number(fx), y = Number(fy);
    return { p: { x: r.x + x * r.w + Number(sty(style, pre + "Dx", 0)), y: r.y + y * r.h + Number(sty(style, pre + "Dy", 0)) }, s: side(r, x, y) };
  };
  const horiz = (s) => s === "L" || s === "R";
  const labels = [];
  for (const c of scene.conectores) {
    const sr = rectOf[c.origen], tr = rectOf[c.destino];
    const wps = (c.puntos || []).map((p) => ({ x: p.x, y: p.y }));
    const orth = (sty(c.estilo, "edgeStyle", "") || "").includes("rthogonal") || (sty(c.estilo, "edgeStyle", "") || "").includes("elbow");
    let s = constrained(sr, c.estilo, "exit");
    let t = constrained(tr, c.estilo, "entry");
    const sPt = c.extremos && c.extremos.sourcePoint, tPt = c.extremos && c.extremos.targetPoint;
    // Extremo en un boundary: el Draw.io lo dibuja hasta el punto exacto donde se soltó la flecha.
    if (!t && c.destinoTipo === "boundary" && tPt) t = { p: tPt, s: "L" };
    if (!s && c.origenTipo === "boundary" && sPt) s = { p: sPt, s: "R" };
    if (!s) s = sr ? anchorTo(sr, wps[0] || (t ? t.p : tr ? center(tr) : tPt)) : { p: sPt, s: "R" };
    if (!t) t = tr ? anchorTo(tr, wps[wps.length - 1] || s.p) : { p: tPt || s.p, s: "L" };
    if (!s.p || !t.p) continue;
    let route = [s.p];
    if (!orth) {
      route = [s.p, ...wps, t.p];
    } else {
      const P = [s.p, ...wps, t.p];
      let dir = horiz(s.s) ? "H" : "V";
      for (let k = 1; k < P.length; k++) {
        const a = route[route.length - 1], b = P[k], last = k === P.length - 1;
        if (Math.abs(a.x - b.x) < 0.5 || Math.abs(a.y - b.y) < 0.5) { route.push(b); dir = Math.abs(a.y - b.y) < 0.5 ? "H" : "V"; continue; }
        if (last) {
          const want = horiz(t.s) ? "H" : "V";
          if (dir === "H" && want === "H") { const mx = (a.x + b.x) / 2; route.push({ x: mx, y: a.y }, { x: mx, y: b.y }); }
          else if (dir === "V" && want === "V") { const my = (a.y + b.y) / 2; route.push({ x: a.x, y: my }, { x: b.x, y: my }); }
          else if (want === "H") route.push({ x: a.x, y: b.y }); else route.push({ x: b.x, y: a.y });
          route.push(b);
        } else {
          route.push(dir === "H" ? { x: b.x, y: a.y } : { x: a.x, y: b.y }, b);
          dir = dir === "H" ? "V" : "H";
        }
      }
    }
    route = route.filter((p, i) => i === 0 || Math.hypot(p.x - route[i - 1].x, p.y - route[i - 1].y) > 0.5);
    const rounded = sty(c.estilo, "rounded", "0") === "1";
    let d = `M${route[0].x},${route[0].y}`;
    for (let i = 1; i < route.length; i++) {
      const p = route[i];
      if (rounded && i < route.length - 1) {
        const a = route[i - 1], n = route[i + 1];
        const r1 = Math.min(10, Math.hypot(p.x - a.x, p.y - a.y) / 2, Math.hypot(n.x - p.x, n.y - p.y) / 2);
        const ux = (p.x - a.x) / (Math.hypot(p.x - a.x, p.y - a.y) || 1), uy = (p.y - a.y) / (Math.hypot(p.x - a.x, p.y - a.y) || 1);
        const vx = (n.x - p.x) / (Math.hypot(n.x - p.x, n.y - p.y) || 1), vy = (n.y - p.y) / (Math.hypot(n.x - p.x, n.y - p.y) || 1);
        d += ` L${p.x - ux * r1},${p.y - uy * r1} Q${p.x},${p.y} ${p.x + vx * r1},${p.y + vy * r1}`;
      } else d += ` L${p.x},${p.y}`;
    }
    const stroke = sty(c.estilo, "strokeColor", "#000000");
    const dashed = sty(c.estilo, "dashed", "0") === "1";
    const endA = sty(c.estilo, "endArrow", "classic"), startA = sty(c.estilo, "startArrow", "none");
    const mk = (a) => a === "none" ? "" : a === "open" || a === "openThin" ? "url(#aOpen)" : a === "block" || a === "blockThin" ? "url(#aBlock)" : "url(#aClassic)";
    out.push(`<path d="${d}" fill="none" stroke="${stroke}" stroke-width="${sty(c.estilo, "strokeWidth", 1)}" ${dashed ? 'stroke-dasharray="3,3"' : ""} ${mk(endA) ? `marker-end="${mk(endA)}"` : ""} ${mk(startA) ? `marker-start="${mk(startA)}"` : ""}/>`);
    if ((c.etiquetaLineas || []).length) {
      // posición de la etiqueta: fracción relativa del Draw.io + desplazamientos
      const seg = []; let total = 0;
      for (let i = 1; i < route.length; i++) { const l = Math.hypot(route[i].x - route[i - 1].x, route[i].y - route[i - 1].y); seg.push(l); total += l; }
      const pos = c.posEtiqueta || {};
      let target = total * Math.min(Math.max(((pos.x || 0) + 1) / 2, 0), 1), acc = 0, lp = route[0];
      for (let i = 0; i < seg.length; i++) {
        if (acc + seg[i] >= target) {
          const f = seg[i] ? (target - acc) / seg[i] : 0;
          const a = route[i], b = route[i + 1];
          lp = { x: a.x + (b.x - a.x) * f, y: a.y + (b.y - a.y) * f };
          const nx = seg[i] ? -(b.y - a.y) / seg[i] : 0, ny = seg[i] ? (b.x - a.x) / seg[i] : 0;
          lp = { x: lp.x + nx * (pos.y || 0), y: lp.y + ny * (pos.y || 0) };
          break;
        }
        acc += seg[i];
      }
      lp = { x: lp.x + (pos.dx || 0), y: lp.y + (pos.dy || 0) };
      const ls = c.estiloEtiqueta || c.estilo;
      const fe = c.fuenteEtiqueta || {};
      const px = Number(fe.px || sty(ls, "fontSize", sty(c.estilo, "fontSize", 11)));
      const color = fe.color || sty(ls, "fontColor", sty(c.estilo, "fontColor", "#000000"));
      const lines = c.etiquetaLineas.flatMap((t) => wrap(t, px, false, 260));
      labels.push({ lp, lines, px, color });
    }
  }

  // --------------------------------------------------------------- nodos
  for (const n of scene.nodos) {
    const f = n.fuentes || {};
    const stroke = n.stroke && n.stroke !== "none" ? n.stroke : "none";
    if (n.forma === "persona") {
      const headD = Math.min(n.w * 0.5, n.h * 0.56), cx = n.x + n.w / 2;
      const bodyY = n.y + headD * 0.78, rx = Math.min(n.w, n.h - headD * 0.78) * 0.28;
      out.push(`<rect x="${n.x}" y="${bodyY}" width="${n.w}" height="${n.h - (bodyY - n.y)}" rx="${rx}" fill="${n.fill}" stroke="${stroke}" stroke-width="1"/>`);
      out.push(`<circle cx="${cx}" cy="${n.y + headD / 2}" r="${headD / 2}" fill="${n.fill}" stroke="${stroke}" stroke-width="1"/>`);
      layoutText(n, bodyY + 6, n.y + n.h - 4, f);
    } else if (n.forma === "cilindro") {
      const ry = Math.min(15, n.h / 6);
      out.push(`<path d="M${n.x},${n.y + ry} A${n.w / 2},${ry} 0 0 1 ${n.x + n.w},${n.y + ry} L${n.x + n.w},${n.y + n.h - ry} A${n.w / 2},${ry} 0 0 1 ${n.x},${n.y + n.h - ry} Z" fill="${n.fill}" stroke="${stroke}" stroke-width="1"/>`);
      out.push(`<path d="M${n.x},${n.y + ry} A${n.w / 2},${ry} 0 0 0 ${n.x + n.w},${n.y + ry}" fill="none" stroke="${stroke}" stroke-width="1"/>`);
      layoutText(n, n.y + ry * 2, n.y + n.h - 2, f);
    } else if (n.forma === "nota") {
      const fill = sty(n.style, "fillColor", "#fffde7"), st = sty(n.style, "strokeColor", "#c9a227");
      out.push(`<rect x="${n.x}" y="${n.y}" width="${n.w}" height="${n.h}" rx="8" fill="${fill}" stroke="${st}" stroke-width="1"/>`);
      const color = sty(n.style, "fontColor", "#5f4b00");
      const px = Number((n.fuenteNota && n.fuenteNota.px) || sty(n.style, "fontSize", 14));
      const raw = n.textoNota || [n.nombre, ...(n.descripcionLineas || [])];
      const lines = raw.flatMap((t, i) => wrap(t, px, i === 0, n.w - 24).map((x) => ({ t: x, px, bold: i === 0, color, lh: px * 1.2 })));
      out.push(textLines(lines, n.x + Number(sty(n.style, "spacingLeft", 10)) + 4, n.y + Number(sty(n.style, "spacingTop", 8)) + px, "start"));
    } else {
      const arc = Number(sty(n.style, "arcSize", 6));
      out.push(`<rect x="${n.x}" y="${n.y}" width="${n.w}" height="${n.h}" rx="${Math.min(n.w, n.h) * arc / 100}" fill="${n.fill}" stroke="${stroke}" stroke-width="1"/>`);
      layoutText(n, n.y + 2, n.y + n.h - 2, f);
    }
  }

  function layoutText(n, top, bottom, f) {
    const maxW = n.w - 10;
    const col = f.color || "#ffffff";
    const L = [];
    for (const t of wrap(n.nombre, f.nombrePx || 16, true, maxW)) L.push({ t, px: f.nombrePx || 16, bold: true, color: col });
    if (n.tipoLinea) for (const t of wrap(n.tipoLinea, f.tipoPx || 12, false, maxW)) L.push({ t, px: f.tipoPx || 12, color: f.colorTipo || col });
    const desc = (n.descripcionLineas && n.descripcionLineas.length ? n.descripcionLineas : [n.descripcion]).filter(Boolean);
    if (desc.length) {
      L.push({ t: "", px: (f.descPx || 11), color: col, gap: true });
      for (const d of desc) for (const t of wrap(d, f.descPx || 11, false, maxW)) L.push({ t, px: f.descPx || 11, color: f.colorDesc || col });
    }
    L.forEach((l) => { l.lh = l.px * 1.2; });
    const total = L.reduce((s, l) => s + l.lh, 0);
    let y = top + Math.max((bottom - top - total) / 2, 0);
    for (const l of L) {
      y += l.lh;
      if (!l.gap) out.push(`<text x="${n.x + n.w / 2}" y="${y - l.lh * 0.22}" font-size="${l.px}" ${l.bold ? 'font-weight="bold"' : ""} fill="${l.color}" text-anchor="middle">${esc(l.t)}</text>`);
    }
  }

  // --------------------------------------------------------------- etiquetas de conectores (encima de todo)
  for (const { lp, lines, px, color } of labels) {
    const lh = px * 1.2;
    const w = Math.max(...lines.map((t) => width(t, px, false))) + 4;
    const h = lines.length * lh + 2;
    out.push(`<rect x="${lp.x - w / 2}" y="${lp.y - h / 2}" width="${w}" height="${h}" fill="#ffffff" opacity="0.92"/>`);
    lines.forEach((t, i) => out.push(`<text x="${lp.x}" y="${lp.y - h / 2 + (i + 1) * lh - px * 0.25}" font-size="${px}" fill="${color}" text-anchor="middle">${esc(t)}</text>`));
  }

  // --------------------------------------------------------------- leyenda C4 + pie de trazabilidad
  if (scene.leyenda) {
    const L = [["Person", "#083F75"], ["Software System", "#1061B0"], ["Container", "#23A2D9"], ["Component", "#63BEF2"], ["External Person", "#6C6477"], ["External Software System", "#8C8496"]];
    const at = scene.leyendaEn;
    const lw = at ? at.w : legendW;
    const lx = at ? at.x : maxX - legendW - 10, ly = at ? at.y - 4 : maxY - legendH;
    out.push(`<text x="${lx}" y="${ly + 22}" font-size="16" font-weight="bold" fill="#4D4D4D">Legend</text>`);
    L.forEach(([t, c], i) => {
      out.push(`<rect x="${lx}" y="${ly + 34 + i * 30}" width="${lw}" height="30" fill="${c}"/>`);
      out.push(`<text x="${lx + 10}" y="${ly + 34 + i * 30 + 20}" font-size="13" fill="#ffffff">${t}</text>`);
    });
  }
  out.push(`<text x="${minX + 10}" y="${minY + H - 9}" font-size="11" fill="#9CA3AF">${esc(scene.pie || "")}</text>`);
  out.push("</svg>");
  return out.join("\n");
}

/* ------------------------------------------------------------------ orquestación */
async function rasterize(browser, svg, file, scale) {
  const m = svg.match(/width="(\d+)" height="(\d+)"/);
  const width = Number(m[1]), height = Number(m[2]);
  const page = await browser.newPage();
  try {
    await page.setViewport({ width, height, deviceScaleFactor: scale });
    await page.setContent(`<!doctype html><html><body style="margin:0;background:#fff">${svg}</body></html>`, { waitUntil: "load" });
    await page.screenshot({ path: file, clip: { x: 0, y: 0, width, height } });
  } finally {
    await page.close();
  }
}

const files = fs.readdirSync(scenesDir).filter((f) => f.endsWith(".json")).sort();
const dirs = { svg: path.join(outDir, "svg"), png: path.join(outDir, "png"), hires: path.join(outDir, "png-hires"),
  refSvg: path.join(outDir, "referencia-drawio", "svg"), refPng: path.join(outDir, "referencia-drawio", "png") };
for (const d of Object.values(dirs)) fs.mkdirSync(d, { recursive: true });
const browser = await launchBrowser();
let failures = 0;
try {
  const page = await browser.newPage();
  await page.setContent("<!doctype html><html><body></body></html>");
  for (const f of files) {
    const scene = JSON.parse(fs.readFileSync(path.join(scenesDir, f), "utf8"));
    const isRef = f.endsWith(".drawio.json");
    const key = scene.vista;
    scene.pie = isRef
      ? `Referencia: página '${scene.pagina}' del Draw.io original (render de la fuente, sin modelo).`
      : `${process.env.AAC_PIE || "Structurizr"} · vista ${key} · fuente Draw.io: '${scene.pagina}'`;
    try {
      const svg = await page.evaluate(renderScene, scene);
      if (isRef) {
        fs.writeFileSync(path.join(dirs.refSvg, `${key}.svg`), svg);
        await rasterize(browser, svg, path.join(dirs.refPng, `${key}.png`), 2);
      } else {
        fs.writeFileSync(path.join(dirs.svg, `${key}.svg`), svg);
        await rasterize(browser, svg, path.join(dirs.png, `${key}.png`), 2);
        await rasterize(browser, svg, path.join(dirs.hires, `${key}.png`), hires);
      }
      console.log(`  ✔ ${key}${isRef ? " (referencia Draw.io)" : ""}`);
    } catch (err) {
      failures += 1;
      console.error(`  ✖ ${key}: ${err.message}`);
    }
  }
  console.log(`[render-c4] ${files.length - failures}/${files.length} escenas · notación Draw.io C4 · leyenda oficial`);
} finally {
  await browser.close();
}
process.exit(failures ? 1 : 0);
