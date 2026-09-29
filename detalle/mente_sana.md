# Mente Sana — Vista detallada (funcionamiento fino)

> Fuente: Sheet actual de Cristofher (2026-09-15). **Códigos de formularios: pendientes.**
> Sheet: `https://docs.google.com/spreadsheets/d/<SPREADSHEET_ID_MS>`
> Acceso verificado: público (export xlsx OK).

## 1. Inventario de pestañas actuales (11)
| # | Pestaña | Contenido / columnas clave |
|---|---------|----------------------------|
| 1 | `BD` | Cod_unico, COD_Inst, UGT, Provincia, Distrito, Centro Poblado, Institución educativa, Cod modular, Cod local, Nivel, Cant_docentes, Cant_familias, Cant_Estudiantes, Est_Focalizados, CT |
| 2 | `Programacion` | Cod_mirror, UGT, Cod_unico, IE, Nivel, COD_Inst, Grado, Etapa, Actividad, Mes, Semana, Fecha_corte, Programado, Ejecutado, Fecha_ejecucion, Status |
| 3 | `Facilitadores` | Facilitador/a (lista) |
| 4 | `Etapa` | Etapa, Actividad (lista) |
| 5 | `Mirror` | Cod_mirror, UGT, IE, COD_Inst, Nivel, Grado, Fecha_Sesion, Etapa, Actividad |
| 6 | `Reportes_Rapidos` | Timestamp, UGT, IE, COD_Inst, Nivel, Grado, Cod_unico, Facilitador/a, Fecha_Sesion, Etapa, Actividad, Tema, Asist_Estudiantes, Asist_Familias, Asist_Docentes, Asist_Otros_Cant, Asist_Otros_Texto, Desarrollo, Incidencias_SN, Descripcion_Incidencia, Atencion_Adicional, Descripcion_Atencion_Adicional, Evidencia |
| 7 | `Estudiantes` | Timestamp, UGT, IE, COD_Inst, Nivel, Cod_unico, Grado, Seccion, Apellidos_nombres, Fecha_aplicacion, Corte, Bloq_1..5, Preg_1..3, Lenguaje_corporal, Contacto_visual, Tono_volumen_voz, Tiempo_reaccion, Interaccion_con_material, Conducta_social, Comentario_adicional, Facilitador/a |
| 8 | `Familias` | Encuesta familias: Timestamp, UGT, IE, Nivel, COD_Inst, Cod_unico, Apellidos_nombres, Relacion, Edad_cuidador, Edad_ninio, Lengua_materna, Fecha_aplicacion, Corte, **Preg_1..23**, Pregunta_abierta_1..3, Facilitador/a |
| 9 | `Docentes` | Timestamp, UGT, IE, COD_Inst, Nivel, Cod_unico, Apellidos_nombres, Grado, Anios_experiencia, Lengua_materna, Fecha_aplicacion, Corte, **Preg_1..24**, Pregunta_abierta_1..3, Facilitador/a |
| 10 | `Asistencia` | **Legacy**: Timestamp, UGT, IE, COD_Inst, Nivel, Cod_unico, Facilitador/a, Fecha_inicio, Fecha_fin, Enlace |
| 11 | `Historial` | Timestamp, Módulo, UGT, IE, COD_Inst, Nivel, Cod_unico, Facilitador/a, Registros, Detalle |

## 2. Diferencias clave vs CCA (para el modelo común)
- **`Cod_unico` = COD_Inst + Nivel** (ej. `24920496Primaria` / `20938544Primaria`). Clave para IE que tienen **primaria y secundaria** → la entidad IE debe ser **IE × Nivel**, no solo IE.
- Aparecen **`Nivel`** (Primaria/Secundaria) y **`Grado`** (General / Pri-4rto / Pri-5nto…).
- **Módulo `Estudiantes`** (propio de MS, no existe en CCA): observación de habilidades → `Bloq_1..5`, `Preg_1..3` + conductas: Lenguaje_corporal, Contacto_visual, Tono_volumen_voz, Tiempo_reaccion, Interaccion_con_material, Conducta_social + comentario.
- `BD` trae **Cant_Estudiantes** y **Est_Focalizados** (CCA no).
- `Reportes_Rapidos` incluye **Asist_Estudiantes**.
- `Facilitadores` y `Etapa` están en **pestañas propias** (en CCA venían dentro de `BD` cols P/Q/R).
- Conteos de preguntas distintos: MS Docentes 24+3, Familias 23+3 (CCA 30+4 / 24+2).
- **No hay pestaña `Asistencias` nueva** (solo la legacy) → el rediseño de asistencia también aplica a MS.

## 3. Rediseño de asistencias en MS
- Aplica el **mismo diseño** definido para CCA (roster por IE, encuesta por asistente, evidencia imagen/PDF, guardar por sesión ejecutada).
- A tener en cuenta: aquí el "roster" debe poder distinguir **Nivel/Grado** (IE con primaria y secundaria).

## 4. Códigos de los formularios (recibidos 2026-09-15 06:12)
App: **“Mente Sana – Plataforma de ingreso de datos”** (v14-jul-2026). Fuentes en `fuentes/ms/`: `MS_codigoGS_2026.gs`, `MS_formulario_2026.html`, `appscript_MS_2026.json`.

- **5 módulos** (CCA tenía 4):
  1. Reporte al día → `Reportes_Rapidos`
  2. Asistencias → `Asistencia` (legacy: sube plantilla **xlsx/xls/csv** a Drive)
  3. Docentes → `Docentes`
  4. Familias → `Familias`
  5. **Estudiantes → `Estudiantes`** (propio de MS)
- **Dropdowns**: Facilitadores (hoja propia) · Etapa+Actividad (hoja propia).
- **Evidencia (m1)**: Drive root `1BYUneOHbh05KPZySYHLh5u4old_BQFI0`, subcarpeta por facilitador, nombre `IE-CP-actividad-fecha.ext`.
- **Asistencia legacy (m2)**: Drive root `<CARPETA_RAIZ_ID>`, archivo `Facilitador-fechaIni-fechaFin.ext`, guarda `Enlace`.
- **Endpoint** `?source=dashboard` → JSON `{bd, facilitadores, etapa, programacion, mirror, reportes_rapidos, familias, docentes, estudiantes, asistencia, historial, timestamp}` (CCA traía menos keys).
- **Patrón tabla dinámica + modales** reutilizado en Docentes/Familias/Estudiantes (m3/m4/m5); modales: respuestas (m3/m4), bloques + indicadores (m5).
- **Catálogo Grado (MS)**: General · Multigrado · Pri-4rto · Pri-5nto · Pri-6xto · Sec-1ero · Sec-2ndo → confirma que MS es **transición primaria→secundaria**.
- **Relación (familia)**: Mamá · Papá · Tío/a · Abuelo/a · Primo/a · Hermano/a · Tutor/a (igual que CCA).
- **Cortes**: Pre test / Post test.

## 5. Imprecisiones actuales a corregir en el rediseño (MS)
- Orden de columnas **inconsistente** entre módulos: Docentes escribe `Cod_Inst, Nivel`; Familias escribe `Nivel, Cod_Inst`.
- `sheetToObjects` está **definido dos veces** en el `.gs` (la 2ª gana) → la 1ª es código muerto.
- `Edad_ninio` (Familias) sigue en la hoja pero **ya no se recolecta** (queda vacío) → legacy.
- `Pregunta_abierta_3` (Familias) se escribe **después** del Facilitador (col AN) → orden raro.
- Facilitadores = **solo una lista de nombres, sin ID** → en el rediseño será entidad propia.

## 6. Qué cambia con el rediseño (MS)
- Módulo 2 (plantilla xlsx) → **reemplazado** por Asistencias-por-lista (mismo diseño que CCA).
- Módulo 5 (Estudiantes) → se mantiene como módulo de **evaluación propio de MS**.
- **Pendiente**: confirmar si `Estudiantes`/`Est_Focalizados` migran en la misma fase que el resto.
