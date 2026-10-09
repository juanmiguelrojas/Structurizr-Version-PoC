# 3. App Móvil offline-first con sincronización idempotente (HU-050)

Date: 2026-10-08

## Status

Accepted

## Context

Los operarios trabajan en plataforma/rampa con cobertura intermitente. Los hechos físicos (abastecimiento, firma, PQDA)
no pueden perderse ni duplicarse, y una acción vieja reenviada tarde no puede sobrescribir un estado más reciente.

## Decision

- Base local **WatermelonDB (SQLite)** cifrada con **SQLCipher + Android Keystore**.
- Cola de escritura local con **UUID por acción**, máquina de estados (PENDIENTE → ENVIANDO → CONFIRMADO | CONFLICTO | ERROR) y backoff exponencial (5 s – 5 min).
- En el BFF Móvil: **Servicio de Idempotencia** (dedupe por UUID en Redis), **Validador de Secuencia** (orden por timestamp de captura) y **Motor de Reconciliación HU-050** (auto-acepta o `PENDING_REVIEW`).
- Descarga incremental por **Proveedor de Delta** (patrón HU-007) y media por **GCS Resumable Upload**.
- Red exclusivamente vía **Netskope ZTNA** (posture Intune), sin Cloudflare.

## Consequences

- Se requiere un flujo de conciliación manual del supervisor (topic `conciliacion-resuelta`, ver ADR 4).
- Memorystore pasa a ser crítico para la idempotencia: se recomienda tier Standard (HA).
