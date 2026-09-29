# Inventario de insumos — Backend MEL Efecto Áncash

> Estado de cada insumo necesario para diseñar. Se actualiza con cada entrega.
> Leyenda: ⬜ pendiente · 🟡 en progreso · ✅ recibido/verificado · ⛔ bloqueante

## A. Accesos e insumos técnicos
| # | Insumo | Estado | Notas |
|---|--------|--------|-------|
| A1 | Schema `bd_intranet` (intranet) — tablas de visitas/actividades/territorio | ⬜ ⛔ | Necesito verlo para no duplicar. Confirmar servidor/BD + permiso SELECT |
| A2 | Link Google Sheets **CCA** + códigos actuales | 🟡 | Sheet ✅ recibido e inventariado (11 pestañas) → `detalle/cca.md`. **Falta:** códigos (Apps Script) |
| A3 | Link Google Sheets **Mente Sana** + códigos actuales | ✅ | Sheet inventariado (11 pestañas) + códigos analizados (`detalle/mente_sana.md`, `fuentes/ms/`) |
| A4 | Estructura/campos de **formularios actuales** CCA y MS | 🟡 | CCA: código completo recibido y analizado (`detalle/cca.md` §6-7). Falta MS |
| A5 | ¿Existe ya la **web de programación**? URL/repo | ⬜ | O es nueva desde cero |
| A6 | Dashboards CCA (p80) y MS (p81): accesos / listado de indicadores | ⬜ | Punto de partida de la web central |

## B. Definiciones de negocio (para el modelo)
| # | Definición | Estado |
|---|------------|--------|
| B1 | Entidades "sujeto" transversales (IIEE, UGT, docentes, territorio, actividad...) | ⬜ |
| B2 | Granularidad temporal (año / periodos / fechas) | ⬜ |
| B3 | Identificadores naturales (código IIEE, UGT, DNI, etc.) | ⬜ |
| B4 | Catálogo de programas/dimensiones (CCA, Mente Sana, otros) | ⬜ |
| B5 | Qué produce cada formulario y con qué frecuencia (pre/post/monitoreo) | ⬜ |
| B6 | Reglas de privacidad: qué se guarda crudo y qué solo agregado | ⬜ |

## D. Datos reales para "lanzar" (cargar/migrar) — verificado 2026-09-15
| # | Insumo | Estado | Notas |
|---|--------|--------|-------|
| D1 | **Padrón ESCALE** (`padron_escuelas.xlsx`, 4 983 escuelas) | ✅ | Recibido + ETL a `core_ie`/`pad_escuela`; reemplaza a `LocalizacionEA` |
| D2 | **Esquema completo `EA_Actividades`** (35 col) y **`EA_POA`** (17 col) | 🟡 | Tengo las columnas clave usadas por Power Apps, no el diccionario completo |
| D3 | **POA cargado** (actividades grandes reales 2026) | ⬜ | Migra hoy en SharePoint (18 AG / 16 AP); falta exportar |
| D4 | **`bd_intranet`** (intranet, 60 tablas) | 🟡 | La guía definitiva ahora es nuestro schema (padrón). Falta igual ver la intranet para no duplicar visitas |
| D5 | **CCA** — confirmar qué pestañas migran ahora vs post-test | ⬜ | Códigos CCA ✅; falta alcance de migración |
| D6 | **Mente Sana** — igual que CCA | ⬜ | Códigos MS ✅ |
| D7 | **PDLE** — datos/campos/formularios | ⬜ ⛔ | Sin insumos (solo esqueleto) |
| D8 | **Academia Juvenil** — datos/campos + fuente semáforo HSE y centro poblado | 🟡 | Existe trabajo Power BI/Deneb; falta el modelo de datos |
| D9 | **Motor**: PostgreSQL | ✅ | Confirmado (AJ ya en Postgres) |

## C. Decisiones de arquitectura
| # | Decisión | Estado |
|---|----------|--------|
| C1 | Schema único con dominios vs varios schemas | ⬜ (recomiendo único con dominios) |
| C2 | Nomenclatura (idioma, prefijos por dominio) | ⬜ (propongo snake_case, español) |
| C3 | Formato de entrega (markdown + Mermaid / Excalidraw) | ⬜ |
| C4 | Fuente de verdad final y periodo de convivencia con Sheets | ⬜ |
