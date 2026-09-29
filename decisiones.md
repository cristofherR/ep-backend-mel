# Registro de decisiones — Backend MEL Efecto Áncash

> ADR ligero. Cada decisión con fecha, contexto y estado.

## D-001 · 2026-09-15 · Diseño primero, schema después
- **Decisión:** no crear schema físico hasta definir y aprobar el modelo de datos completo (entidades, tablas, columnas, tipos, PK/FK).
- **Estado:** vigente.
- **Contexto:** instrucción explícita de Cristofher.

## D-002 · 2026-09-15 · Web de programación = gestión de territorio
- **Decisión:** la "web de programación" gestiona territorio (reuniones, asistencias a docentes, visitas).
- **Restricción:** no duplicar actividades ya reportadas en la intranet (`bd_intranet`). Debe relacionarse con ese schema.

## D-003 · 2026-09-15 · Ciclo de migración
- CCA y Mente Sana: migrar Sheets actuales → Azure dentro del schema.
- Formularios actuales: rearmados, misma funcionalidad; backend → BD.
- Migración de datos con **fecha 2026**. **Post-test** se migra en su momento.

## D-004 · 2026-09-15 · Dos vistas obligatorias
- **Vista general:** estructura coherente de todo el modelo.
- **Vista detallada:** funcionamiento fino de cada módulo/tabla/proceso.
- Debe mantenerse documentación de detalle **y** una vista global siempre disponible.

## D-005 · 2026-09-15 · Asistencias CCA rediseñadas (sin plantillas)
- Se abandona Sheets/Excel para asistencia.
- Vista tipo lista de asistentes; asistencia Sí/No por sesión ejecutada; filtros Facilitador/IE/UGT.
- Sesión 1 crea la lista; sesiones siguientes jalan el roster y añaden personas nuevas debajo.
- Guarda con fecha/actividad/ciclo del reporte. Botón Guardar y enviar.
- Detalle completo en `detalle/cca.md`.

## D-006 · 2026-09-15 · Evidencias con archivos
- Nueva sección de evidencia: imágenes (png/jpg/jpeg…) y PDF (fotos de lista de asistencia o documento escaneado).
- Se modelará con FK a la sesión (no enlaces sueltos).

## D-007 · 2026-09-15 · Facilitadores variables + programación flexible
- Los facilitadores **no son siempre los mismos** → entidad Facilitador + asignaciones, no columna fija.
- La programación es **flexible** (cantidad de sesiones variable) → sesiones como registros, no columnas.

## D-008 · 2026-09-15 · Reglas finas de Asistencias CCA (confirmadas)
- **Encuesta de satisfacción = por asistente** (`Item_1..5` + `Sugerencias` por persona).
- **Roster = por IE**, se reutiliza entre sesiones de esa IE.
- **`Estudiante relacionado` = texto libre** (nombre del hijo/hija); sin catálogo.

## D-010 · 2026-09-15 · Modelo por capas + builder declarativo
- **Decisión:** el schema se genera desde specs (`arquitectura/builder/spec/*.yaml`),
  no se escribe SQL a mano. Capas: 0 core, 1 programación, 1b instrumentos, 2 CCA,
  3 Mente Sana, 4 PDLE, 5 Academia Juvenil.
- **Motivo:** que la infraestructura "siga creciendo" sin reescribir lo hecho.
- **Estado:** vigente. Generado: 7 capas · 41 tablas · 276 columnas · 0 incoherencias.

## D-011 · 2026-09-15 · Motor del schema (RESUELTO → PostgreSQL)
- **Contexto:** `README.md` decía PostgreSQL; el DDL viejo y el conector de Power Apps eran T-SQL.
- **Decisión (Cristofher):** **PostgreSQL**. AJ ya vive en Postgres (`bd_analitica`).
- **Estado:** `build.py` emite PostgreSQL (`dialect: postgres`).

## D-012 · 2026-09-15 · Instrumentos como motor (no columnas de preguntas)
- **Decisión:** encuestas/evaluaciones se modelan con `inst_instrumento`/`inst_item`/
  `inst_intento`/`inst_respuesta`, no con `Preg_1..30` por tabla.
- **Motivo:** CCA y MS tienen conteos distintos y cambiarán; agregar un cuestionario
  debe ser filas, no columnas.

## D-013 · 2026-09-15 · Multi-proyecto desde el día 1
- **Decisión:** el núcleo (`core_`) es transversal; cada proyecto es una capa que lo
  reutiliza. PDLE (PROG-7) y Academia Juvenil (PROG-8) ya tienen esqueleto.
- **Motivo:** pedido explícito de Cristofher (otros proyectos sin tocar lo existente).

## D-009 · 2026-09-15 · IE como IE × Nivel (`cod_unico`)
- En **Mente Sana** la misma IE puede tener Primaria y Secundaria → la entidad IE se identifica por **`cod_unico` = COD_Inst + Nivel**.
- CCA no trae `cod_unico` explícito, pero comparte IE (inicial/primaria). El modelo común deberá unificar: **IE × Nivel** como unidad.

## D-014 · 2026-09-15 · Padrón ESCALE como fuente de localización/IIEE
- **Decisión:** `LocalizacionEA` (SharePoint) se reemplaza por el **padrón ESCALE**
  (`padron_escuelas.xlsx`, 4 983 escuelas) + flag UGT + columnas de proyecto.
- **Motivo:** incluye TODO el territorio (aunque no sea intervención) y trae las
  membresías por componente → guía definitiva de a quién intervenimos.
- **Estado:** ingestado + ETL verificado (216 membresías cuadran con los flags).

## D-015 · 2026-09-15 · Academia Juvenil ya vive en PostgreSQL
- **Hecho:** AJ Áncash está en `bd_analitica` (Postgres): AJAncash, AJCuenca,
  AJHuaripampa, AJHuarmey, AJValleFortaleza (+ técnicos). Se conecta por contexto de evaluación.

## D-016 · 2026-09-15 · Builder en PostgreSQL + ETL del padrón
- **Decisión:** `build.py` emite **PostgreSQL**; se agrega `etl_padron.py` que carga
  el ESCALE a `core_ie`/`pad_escuela`/`pad_escuela_componente`.
- Generado: 8 capas · 43 tablas · 328 columnas · 0 incoherencias.

## D-017 · 2026-09-15 · Schema dedicado `efectoancash` (aislado)
- **Decisión:** todo el modelo vive en el schema PostgreSQL **`efectoancash`**, separado de
  `bd_intranet` (intranet) y `bd_analitica` (AJ). Config: `spec/_config.yaml`.
- **Motivo:** evitar conflictos de nombres; mismo servidor, namespaces distintos.
- **Ventaja:** si hace falta, se lee `bd_intranet.vw_*` (solo lectura) por nombre
  cualificado, sin duplicar datos. Cambiar de motor/nombre = 1 línea.

## D-018 · 2026-09-15 · UI data-driven (capa `ui_`)
- **Decisión:** labels, títulos, tipografía, tamaños, colores, orden/fijado y visibilidad viven como **datos** (`ui_texto`, `ui_tema`, `ui_tema_token`, `ui_vista`, `ui_bloque`, `ui_elemento`).
- **Motivo:** editar/mover/fijar/retematizar **sin recompilar ni desplegar**; anticipa i18n y temas.
- **Estado:** vigente (estructura aplicada).

## D-019 · 2026-09-15 · Endurecimiento del builder
- **Decisión:** emitir `COMMENT ON`, `out/manifiesto.json` (hash por archivo), modo `build.py --verify`, y chequeos extra (palabras reservadas, índices duplicados/largos).
- **Estado:** vigente.

## D-020 · 2026-09-15 · Runner + ledger + solo aditivo
- **Decisión:** `runner/apply.py` aplica todo en **una transacción** (dry-run por defecto) y registra en `core_migracion`. Los cambios de esquema son **aditivos e idempotentes**, nunca destructivos.
- **Estado:** vigente.

## D-021 · 2026-09-15 · Schema renombrado a `efectoancash`
- **Decisión:** el schema pasa de `mel` a **`efectoancash`** (`ALTER SCHEMA`, reversible). Builder, seeds, docs y runner alineados.
- **Estado:** vigente.
