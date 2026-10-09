## Volarte · Documentación de Arquitectura

Volarte es la plataforma de Terpel para la operación de abastecimiento de combustible de aviación.
Se compone de un **Frontend Web** (React SPA) para empleados comerciales, supervisores y administradores,
y una **App Móvil offline-first** (React Native · Android) para operarios de equipos abastecedores en campo.

Ambos canales consumen APIs a través de **Apigee** y de un **BFF por canal** (Web / Móvil) que orquesta
los **servicios de dominio** (Usuarios/Auth, Datos Maestros, Comercial, Operación, Asignación) y el
**Gestor Documental**, apoyados en **Pub/Sub**, **Cloud SQL**, **Memorystore** y **Cloud Storage** (WORM).

| Atributo | Valor |
|---|---|
| Organización | Terpel · Dirección de Arquitectura |
| Versión / Fase | 1 · Fase I |
| Fuente inicial | `Arquitectura_volarte_1.drawio` (13 páginas, 17/08/2026) |
| Gobierno | Architecture as Code · Structurizr DSL · `docs/CHANGELOG_DSL.md` |
