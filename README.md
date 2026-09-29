# Backend MEL — modelo de datos y ETL para un programa educativo

Diseño e implementación de un **backend único** (PostgreSQL) como fuente de verdad para
varios programas educativos: gestión de territorio (POA), academia juvenil, primera
infancia y transición primaria–secundaria.

**Lo que se ve aquí es la ingeniería, sin datos reales:**

- **Builder declarativo:** el schema se genera desde *specs* YAML (una capa por archivo) →
  DDL PostgreSQL idempotente, diccionario de datos y reporte de coherencia. Crecer = agregar
  un spec; nada se escribe a mano.
- **Modelo por capas:** núcleo transversal (`core_`) + padrón ESCALE (`pad_`) + dominios
  (`prog_`, `inst_`, `cca_`, `ms_`, `pdle_`, `aj_`) + analítica (`an_`) + UI data-driven (`ui_`).
- **ETL:** padrón institucional (Excel → capas del schema, con reparación de codificación) y
  **Google Apps Script** (formularios → hojas de cálculo → dashboard) para el recojo de campo.
- **Diseño de información:** requisitos, decisiones (ADR ligero) y vista detallada por módulo.

> Versión **pública y saneada**: sin credenciales, sin datos de personas, sin hosts internos
> ni identificadores de sistemas internos. Los ejemplos son **sintéticos** y se regeneran con
> un script.

## Estructura

```
arquitectura/
  README.md · vista_general.md      # modelo por capas y mapa conceptual
  builder/
    build.py                        # specs YAML → DDL PostgreSQL (+ diccionario y coherencia)
    gen_*.py                        # generadores de seeds (periodos, roles, UI, app, POA)
    spec/*.yaml                     # una capa por archivo (order, prefix, tablas, índices, vistas)
    seed/*.sql                      # semillas de ejemplo (catálogos + demo)
    out/sql/*.sql                   # DDL generado (aditivo e idempotente)
    out/diccionario.csv             # diccionario de datos columna por columna
    out/coherencia.md               # chequeos de integridad y convenciones
fuentes/
  padron_escuelas/etl_padron.py     # ETL Excel (ESCALE) → pad_* / core_ie
  cca/CCA_codigoGS_2026.gs          # Apps Script: formulario CCA → Sheets (IDs como placeholders)
  ms/MS_codigoGS_2026.gs            # Apps Script: formulario Mente Sana → Sheets
detalle/                            # vista detallada por módulo (funcionamiento fino)
decisiones.md · requisitos.md · inventario_insumos.md
data/synthetic/                     # datos de ejemplo SINTÉTICOS
tools/                              # generador de ejemplos + verificador de publicación
```

## Arranque rápido

```bash
pip install pyyaml                     # único requisito para el builder
python3 arquitectura/builder/build.py  # → arquitectura/builder/out/sql/*.sql
```

Verás algo como `OK · schema efectoancash · 10 capas · 55 tablas · 433 columnas`.
Paso a paso, variables de entorno y resultados esperados: **[REPRODUCIR.md](REPRODUCIR.md)**.

## Qué demuestra (para portafolio de ingeniería de datos)

- **Modelado dimensional/relacional:** PK surrogate + FKs reales, catálogos genéricos con
  color, entidad institucional IE × nivel, y "instrumentos" para no caer en el infierno de
  columnas (una encuesta = filas, no columnas).
- **Automatización del schema:** generación de DDL desde specs, chequeo de coherencia,
  detección de palabras reservadas y naming snake_case por prefijo de capa.
- **ETL robusto:** reparación de *mojibake* del Excel ESCALE, mapeo de flags a componentes,
  cargas idempotentes (`WHERE NOT EXISTS` / `ON CONFLICT`).
- **Gobierno del dato:** diccionario de datos generado, decisiones documentadas y reglas de
  privacidad (los agregados no son identificables).

## Privacidad

- Sin credenciales versionadas: todo se lee de variables de entorno (ver `.env.example`).
- **No hay datos de estudiantes, familias, docentes ni escuelas reales.** Los CSV/XLSX reales
  están excluidos por `.gitignore`; los ejemplos son sintéticos (`tools/make_synthetic_examples.py`).
- Los IDs de hojas de cálculo y carpetas de Google aparecen como **placeholders**.


> Autor: Cristofher Rodríguez · Analista de datos · MEL · Educación e impacto social (Perú)
