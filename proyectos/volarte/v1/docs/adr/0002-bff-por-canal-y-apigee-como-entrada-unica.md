# 2. BFF por canal y Apigee como entrada única de APIs

Date: 2026-10-08

## Status

Accepted

## Context

Volarte tiene dos canales con necesidades distintas: Web (comercial, supervisión, administración) y Móvil
(operarios en campo, offline-first, payloads ultra-livianos). El Draw.io L2 muestra ambos canales entrando por Apigee
y luego por el Internal Load Balancer hacia un BFF dedicado.

## Decision

- Se mantienen dos BFF independientes (FastAPI · Cloud Run): **BFF Web** y **BFF Móvil**; no comparten payloads.
- **Apigee** es la única puerta de entrada: valida firma/issuer/audience del JWT contra el JWKS de Entra ID.
- Los BFF realizan una **segunda validación** del JWT y resuelven `GroupToRoleMapping → Role/Permission/Capability`.
- Ningún componente de frontend puede acceder directamente a bases de datos, colas ni servicios de dominio (regla R3 del Agente Revisor).

## Consequences

- Defensa en profundidad (Apigee + BFF) a costa de latencia adicional (mitigada con cache Redis de decisiones de autorización).
- La lógica de autorización se duplica en dos BFF; se recomienda extraerla a una librería compartida.
