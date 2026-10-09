/**
 * Lanzador común de Chromium headless para el render de diagramas y del PDF.
 *
 * - Con PUPPETEER_EXECUTABLE_PATH (Chromium local, p. ej. Playwright) usa ese binario.
 * - Sin él usa el chrome-headless-shell que Puppeteer descarga con `npm ci`, cuya versión
 *   está fijada a la de Puppeteer. NO se usa el Chrome del sistema (/usr/bin/google-chrome
 *   en los runners de GitHub): su versión no coincide con Puppeteer y su arranque puede
 *   exceder el timeout de lanzamiento.
 */
import puppeteer from "puppeteer";

export async function launchBrowser() {
  const executablePath = process.env.PUPPETEER_EXECUTABLE_PATH || undefined;
  return puppeteer.launch({
    executablePath,
    headless: executablePath ? true : "shell",
    timeout: 120_000,
    protocolTimeout: 300_000,
    args: ["--no-sandbox", "--disable-dev-shm-usage", "--disable-gpu"],
  });
}
