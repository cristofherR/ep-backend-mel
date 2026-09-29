# Arquitectura por capas — Backend MEL Efecto Áncash

> **FASE 0 (diseño).** Este árbol es el *builder*: el modelo se genera desde specs
> declarativos, no se escribe SQL a mano. Agregar un proyecto = agregar un spec.
> **Motor: PostgreSQL** (Azure Database for PostgreSQL). Última actualización: 2026-09-15.

## Idea central
Un solo schema **por capas**: las capas bajas son **transversales** (sirven a todos
los proyectos) y las altas son **por proyecto**. Sumar PDLE o Academia Juvenil no toca
lo ya hecho: solo agrega una capa que reutiliza el núcleo.

**Namespace:** todo vive en el schema PostgreSQL **`efectoancash`** (config en `spec/_config.yaml`),
**aislado** de `bd_intranet` y `bd_analitica` → cero conflictos de nombres; y si se
necesita, se lee la intranet con nombre cualificado sin duplicar datos.

## Las capas

| # | Capa | Prefijo | Qué contiene | Estado |
|---|------|---------|--------------|--------|
| 0 | **core** (núcleo transversal) | `core_` | proyecto, componente, UGT, CT, persona, usuario/rol, **IE×Nivel**, etapa, periodo, catálogos, actividad, sesión, evidencia, evento, comentario | ✅ |
| 0b | **padron** (ESCALE) | `pad_` | padrón oficial (4 983 escuelas) + membresía IE×componente | ✅ + ETL |
| 1 | **programacion** (territorio/POA) | `prog_` | AG del POA, actividad pequeña, reporte, incidencia/alerta, indicador/mes | ✅ |
| 1b | **instrumentos** (motor) | `inst_` | instrumento, ítem, intento (Pre/Post), respuesta | ✅ |
| 2 | **cca** | `cca_` | roster, sesión familias, asistencia+satisfacción, seguimiento IE | ✅ |
| 3 | **mente_sana** | `ms_` | roster, sesión, asistencia, evaluación estudiante | ✅ |
| 4 | **pdle** | `pdle_` | sesión de liderazgo, participante, evaluación | 🟡 esqueleto |
| 5 | **academia_juvenil** | `aj_` | habilidad (radar), participante, evaluación, cartilla | 🟡 esqueleto (datos ya en Postgres) |

Reglas:
- Una capa **no se edita** para acomodar a otra: se extiende. FK siempre hacia abajo.
- La entidad institucional (**IE×Nivel**) vive en `core_ie`; su detalle ESCALE, en `pad_escuela`.
- **Instrumentos** evita el "infierno de columnas": encuestas = filas, no columnas.
- Orden de creación válido: ninguna FK apunta hacia una capa posterior.

## El builder
```
arquitectura/
├── README.md            (este archivo)     ├── builder/
├── vista_general.md     (mapa global)      │   ├── build.py     (generador PostgreSQL)
                                            │   ├── spec/*.yaml (una capa por archivo)
                                            │   └── out/         (sql/, diccionario.csv, coherencia.md,
                                            │                     + CSVs del padrón)
```
- Cada `spec/*.yaml`: `order`, `layer`, `prefix`, `dialect`, `tables[].columns[]`, `indexes`, `views`.
- `python3 build.py` → DDL **idempotente** por capa (`CREATE TABLE IF NOT EXISTS`), diccionario y reporte de coherencia.
- **Crecer = agregar un spec** con su `order` y `prefix`. Nada más se toca.

### Capa padrón (fuente real de localización)
- `padron_escuelas.xlsx` (fuente propia) (ESCALE, 69 col) + `etl_padron.py`.
- `python3 etl_padron.py` → `out/padron_core_ie.csv` (4 983), `padron_escuela.csv`, `padron_componente.csv` (216 membresías).
- Los flags del Excel se mapean a componentes: PDL→PROG-1, QM→PROG-2, PDLD→PROG-3, LECTO→PROG-4, CCA→PROG-5, MS→PROG-6, PDLE→PROG-7, ACADEMIA→PROG-8.

## Convenciones
- **snake_case**, español, prefijo de capa obligatorio.
- PK surrogate `id` (identity); FKs reales (`tabla.id`), nunca claves de texto concatenadas.
- Catálogos genéricos con `color_hex` → comida directa del UI.
- Lectura por **vistas**; escritura por **procedimientos**. La app nunca hace INSERT crudo.
- Nada identificable de estudiantes/familias en agregados.

## Notas de datos
- **Codificación**: el `.xlsx` del ESCALE trae mojibake (`P·blica`, `Ma±ana`, `Educaci¾n`). El ETL aplica una reparación best-effort; conviene re-exportar limpio desde ESCALE.
- **Calidad**: 1 fila tiene `Secundaria` en la columna UGT (posible desalineación) → revisar.

## Motor — resuelto
**PostgreSQL** confirmado (Academia Juvenil ya vive en `bd_analitica` Postgres).
Nota técnica: el conector de Power Apps→PostgreSQL existe, pero *delegación* y
*stored procedures* rinden mejor en Azure SQL. Como los dashboards (Power BI/Deneb)
consumen Postgres sin problema, se mantiene **PostgreSQL**. Si luego la delegación de
Power Apps crea fricción, el builder cambia de dialecto con una línea.
