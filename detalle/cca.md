# CCA — Vista detallada (funcionamiento fino)

> Fuente: Sheet actual de Cristofher + especificación verbal (2026-09-15).
> Sheet: `https://docs.google.com/spreadsheets/d/<SPREADSHEET_ID_CCA>`
> Acceso verificado: público (export xlsx/csv OK). Última lectura: 2026-09-15.

## 1. Inventario de pestañas actuales (11)
| # | Pestaña | Contenido / columnas clave |
|---|---------|----------------------------|
| 1 | `familias_fortaleza` | Vacía |
| 2 | `BD` | Base de IE: N°, COD_Inst, UGT, Provincia, Distrito, Centro_Poblado, Institucion_educativa, Cod_modular, Cod_local, Nivel modular, Cant_docentes, Cant_familias, Padres_fort, CT, Facilitadores, Etapa, Actividad |
| 3 | `Programacion` | Cod_mirror, UGT, IE, COD_Inst, Etapa, Actividad, Mes, Quincena, Fecha_corte, Programado, Ejecutado, Fecha_ejecucion, Status |
| 4 | `Familias` | Encuesta familias: Timestamp, UGT, IE, COD_Inst, Apellidos_nombres, Relacion, Edad_cuidador, Edad_ninio, Lengua_materna, Fecha_aplicacion, Corte, Preg_1..24, Pregunta_abierta_1..2, Faciltador |
| 5 | `Seguimiento` | Formato ancho por IE con hitos (Presentación proyecto, Cronograma, Reunión equipo docente, Reunión APAFA, Aplicación encuestas familias/docentes, Digitación...) |
| 6 | `Mirror` | Cod_mirror, UGT, IE, COD_Inst, Fecha_Sesion, Etapa, Actividad |
| 7 | `Docentes` | Encuesta docentes: Timestamp, UGT, IE, COD_Inst, Apellidos_nombres, Grado, Anios_experiencia, Lengua_materna, Fecha_aplicacion, Corte, Preg_1..30, Pregunta_abierta_1..4, Faciltador |
| 8 | `Reportes_Rapidos` | Timestamp, UGT, IE, COD_Inst, Facilitador, Fecha_Sesion, Etapa, Actividad, Tema, Publico_asistente, Asist_Familias, Asist_Docentes, Asist_Otros_Cant, Asist_Otros_Texto, Desarrollo, Incidencias_SN, Descripcion_Incidencia, Atencion_Adicional, Descripcion_Atencion_Adicion, Evidencia |
| 9 | `Asistencia` | **Legacy**: Timestamp, UGT, IE, COD_Inst, Facilitador, Fecha_inicio, Fecha_fin, Enlace |
| 10 | `Historial` | Log: Timestamp, Módulo, UGT, IE, COD_Inst, Facilitador, Registros, Detalle |
| 11 | `Asistencias` | **Nueva, vacía** → destino del rediseño de asistencia |

## 2. Rediseño de ASISTENCIAS (especificación de Cristofher)
**Cambio de fondo:** se abandona el uso de plantillas de Sheets/Excel para asistencia.

**Flujo requerido:**
1. El facilitador reporta la **ejecución de una sesión de familias** (reporte rápido / "reporte al día").
2. En la sección **Asistencias**, el usuario ve **solo sesiones ejecutadas** (no actividades de evaluación ni visitas), filtrable por **Facilitador / IE / UGT** (mismos filtros que otras secciones).
3. **Primera vez (sesión 1):** se ingresa la lista de asistentes en **vista tipo lista** (similar al ingreso de resultados en Familias/Docentes):
   - `N°` (auto al añadir asistentes)
   - `Apellidos`
   - `Nombres`
   - `DNI`
   - `Estudiante relacionado`
   - `Parentesco` (desplegable, igual al de ingreso de respuestas)
   - `Asistencia` (Sí/No)
   - Bloque encuesta de satisfacción: `Item_1..Item_5`, `Sugerencias`
4. Se guarda con datos del reporte: **fecha** (jala del reporte), **nombre de la actividad**, **ciclo**.
5. **Segunda sesión:** se **jalan las personas ya ingresadas** (roster). Si hay personas nuevas, se **añaden debajo**. Botón **Guardar y enviar**.
6. **Tercera sesión:** aparece la lista actualizada (acumulada por persona).

**Sección de evidencia:** subida de archivos **imagen (png, jpg, jpeg, etc.) y .pdf** — fotos de la lista de asistencia o documento escaneado.

**Resto:** se mantiene, salvo sugerencias de ARIA.

## 3. Requisitos transversales nuevos
- **Facilitadores no son siempre los mismos** → entidad Facilitador + asignación (no columna fija).
- **Programación flexible** (cantidad de sesiones variable) → sesiones como registros, no columnas fijas.

## 4. Observaciones / sugerencias de ARIA (borrador)
- **Evitar duplicidad de personas**: modelar `persona` (DNI como clave natural + ID surrogate) y un **roster por IE/UGT**; la asistencia de cada sesión referencia al `persona_id` con `asistio bool`. No copiar Apellidos/DNI en cada sesión.
- **Encuesta de satisfacción**: definir si `Item_1..5` + `Sugerencias` es **por asistente** o **por sesión** (una por sesión). Impacta el diseño.
- **Sesión** = entidad única (`sesion_id`) compartida por Reportes_Rápidos + Asistencias + Evidencias (evita el `Cod_mirror` frágil de hoy).
- **Evidencias**: tabla `evidencia` con FK a `sesion_id` y ruta/almacenamiento (Azure Blob o tabla de archivos), no enlaces sueltos como hoy.
- **Cod_mirror / Mirror**: reemplazar por FKs reales (IE, sesión, actividad, etapa) en lugar de concatenaciones de texto.
- **Log (`Historial`)**: modelarlo como tabla de auditoría.
- **`Seguimiento` ancho** → normalizar a `seguimiento_ie` (IE, hito, estado, fecha).

## 5. Preguntas CCA — RESUELTAS (2026-09-15)
1. ✅ **Encuesta de satisfacción = por asistente** (cada asistente responde `Item_1..5` + `Sugerencias`) → vive en la fila de asistencia persona×sesión.
2. ✅ **Roster = por IE**, se reutiliza entre sesiones de esa IE (las personas se agrupan por IE).
3. ✅ **`Estudiante relacionado` = texto libre manual** (nombre del hijo/hija). No hay catálogo de estudiantes.
4. ✅ `CT` = Coordinador(a) de Territorio.
5. ✅ Códigos recibidos y analizados (ver sección 6).

## 6. Código actual (recibido 2026-09-15)
Archivos en `fuentes/cca/`: `CCA_codigoGS_2026.gs` (backend 21 KB), `CCA_formulario_2026.html` (front 92 KB), `appscript_cca_2026.json` (manifest: tz **America/Lima**, V8, webapp `ANYONE_ANONYMOUS`, scopes drive/spreadsheets/ui).

- **App:** "Crecemos con amor – Plataforma de ingreso de datos" (Apps Script Web App).
- **SPREADSHEET_ID** = el Sheet CCA.
- **Módulos → hoja destino:** 1) Reporte al día → `Reportes_Rapidos`; 2) Asistencias → `Asistencia` (legacy: sube plantilla .xlsx/.xls/.csv a Drive); 3) Docentes → `Docentes`; 4) Familias → `Familias`. Más `Historial` (auditoría).
- **Dropdowns (desde `BD`):** Facilitadores (col **P/16**), Etapa (**Q/17**), Actividad (**R/18**, dependiente de Etapa). UGT/IE/CodInst/Provincia/Distrito/CP desde BD cols C/G/B/D/E/F.
- **`BD` columnas:** A N°, B COD_Inst, C UGT, D Provincia, E Distrito, F Centro_Poblado, G Institucion_educativa, H Cod_modular, I Cod_local, J Nivel modular, K Cant_docentes, L Cant_familias, M Padres_fort, N **CT**, O (vacío), P Facilitadores, Q Etapa, R Actividad.
- **Catálogos:** Relación (m4) = Mamá, Papá, Tío/a, Abuelo/a, Primo/a, Hermano/a, Tutor/a · Lengua = Castellano, Quechua, Otro · Grado docentes = Ini-3ero/4to/5to/Multigrado · Corte = Pre test / Post test.
- **Encuestas:** Docentes = 30 preg + 4 abiertas; Familias = 24 preg + 2 abiertas. Respuestas = texto de opción (ej. "Nada de acuerdo").
- **Evidencia (m1):** sube a Drive, raíz `1Pda0j7go2b2fvqnI7pq2rY-PMwLUIaT8`, subcarpeta por facilitador; nombre `IE-CP-actividad-fecha.ext`.
- **Asistencia (m2 legacy):** Drive raíz `<CARPETA_RAIZ_ID>`; archivo `Facilitador-fechaIni-fechaFin.ext`; guarda `Enlace`.
- **Endpoint dashboard:** `?source=dashboard` → JSON `{bd, reportes_rapidos, programacion, docentes, familias, historial, timestamp}`.
- **Tabla dinámica (m3/m4):** patrón lista con "+ Añadir fila", modal de respuestas, pegar desde Excel (`handlePaste`), `maxRows 60` → **reutilizable para el nuevo Asistencias**.
- **NO existe hoy:** encuesta de satisfacción `Item_1..5` ni `Sugerencias` → es **nuevo** del rediseño.

## 7. Implicaciones para el diseño Azure
- `Cod_mirror`/`Mirror` = concatenación de texto (ej. "261131721. InserciónPresenta") → **reemplazar por FKs reales** (ie, sesión, actividad, etapa).
- La nueva **Asistencia se nutre de sesiones ejecutadas de `Reportes_Rapidos`** → relación fuerte sesión ↔ asistencia.
- El dashboard actual lee Sheets; migrará a **Azure (vistas / vistas materializadas)**.
- Mantener la **UX de tabla** (añadir fila, pegar, modal) para que "siga funcionando como ahora".
- La hoja `Asistencia` (legacy) quedará obsoleta; la nueva es `Asistencias`.
