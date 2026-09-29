# Requisitos y alcance — Backend MEL Efecto Áncash

> Fuente: mensajes de Cristofher (2026-09-15). Se actualiza cada vez que haya nuevos detalles.

## Enfoque general
Antes de crear el schema, definir **toda la información**: entidades, tablas, columnas, tipos, PK/FK y relaciones. Primero el **modelo de datos (diccionario + diagrama)**; el schema físico después, solo con aprobación.

## Módulo 1 — Web de programación (gestión de territorio)
- Alcance: gestión de territorio → **reuniones, asistencias a docentes, visitas**, etc.
- Restricción: **algunas actividades ya se reportan en la intranet** y aparecen en el schema existente **`bd_intranet`** (ej. cantidad de visitas, entre otros).
- Por tanto: la web de programación debe **relacionarse / alinearse con `bd_intranet`** y **NO duplicar** esas actividades.

## Módulo 2 — Web central de indicadores y gráficos
- Reporte central unificado.
- Se alimenta de los módulos anteriores.
- Base: los indicadores que ya viven en los dashboards CCA y Mente Sana actuales.

## Módulo 3 — CCA (backend)
- Migrar lo que está construido en **Google Sheets** a estructura Azure **dentro del schema**.
- Cristofher tiene los **códigos actuales** y los pasará.
- Ya no hojas sueltas: tablas normalizadas del schema.

## Módulo 4 — Mente Sana (backend)
- Igual que CCA: migración desde Google Sheets actuales.
- Cristofher tiene los **códigos actuales** y los pasará.

## Módulo 5 — Formularios actuales CCA y Mente Sana
- Rearmados para **leer y escribir** contra la BD.
- **Siguen funcionando como ahora** (misma experiencia/funcionalidad), solo cambia el backend.
- Se diseña la estructura Azure para **migrar los datos con fecha 2026**.
- **Post-test**: también se migrará en su momento (no ahora).

## Requisitos de calidad (transversales)
- Coherencia total entre los 4 frentes.
- Sin errores ni duplicidad.
- PK e ID propios (mejores prácticas).
- Orientado a ser ligero y rápido en consultas.
- Nombres estandarizados y coherentes.
- Dos vistas: general (coherente) + detallada (funcionamiento fino).

## Roles de ARIA
Backend engineer + frontend + diseñador UI + coder + diseño de datos. Guardar cada detalle y mantener, a la vez, una vista general de todo.
