# Cómo reproducir este repositorio

Todo se ejecuta **sin acceso a bases de datos institucionales y sin datos reales**.
Los ejemplos son **sintéticos** y se regeneran con un script.

## Requisitos

- Python 3.10+
- `pip install pyyaml` (builder) · `pip install openpyxl` (ETL del padrón, opcional)

## 0. Regenerar los datos de ejemplo (sintéticos)

```bash
python3 tools/make_synthetic_examples.py
```

Crea:

- `data/synthetic/padron_escuelas_ejemplo.csv` — 24 escuelas ficticias con el esquema del padrón.
- `data/synthetic/actividades_ejemplo.csv` — actividades de ejemplo por componente/UGT/estado.

## 1. Generar el schema (DDL) desde los specs

```bash
python3 arquitectura/builder/build.py
# → arquitectura/builder/out/sql/000_core.sql .. 999_fk.sql
# → arquitectura/builder/out/diccionario.csv  (diccionario de datos)
# → arquitectura/builder/out/coherencia.md    (chequeos)
```

Salida esperada:

```
OK · schema efectoancash · 10 capas · 55 tablas · 433 columnas
```

Orden de aplicación: `000_core.sql` primero y `999_fk.sql` al final (ninguna FK apunta hacia
una capa posterior). El DDL es aditivo: `CREATE TABLE IF NOT EXISTS`, se puede reaplicar.

```bash
psql "$DATABASE_URL" -f arquitectura/builder/out/sql/000_core.sql
# ... 005, 010, 015, 020, 030, 040, 050, 060, 070 ...
psql "$DATABASE_URL" -f arquitectura/builder/out/sql/999_fk.sql
```

## 2. Semillas de ejemplo

```bash
psql "$DATABASE_URL" -f arquitectura/builder/seed/010_periodos_seed.sql   # cortes (mes/trimestre)
psql "$DATABASE_URL" -f arquitectura/builder/seed/020_roles_seed.sql      # roles + usuarios SINTÉTICOS
psql "$DATABASE_URL" -f arquitectura/builder/seed/030_ui_seed.sql         # configuración de interfaz
psql "$DATABASE_URL" -f arquitectura/builder/seed/060_webapp_demo_seed.sql# demo con marcador [SEED]
```

Todas son **idempotentes** (`WHERE NOT EXISTS` / `ON CONFLICT`): se pueden aplicar varias veces.

## 3. ETL del padrón (Excel → capas del schema)

```bash
# Coloca tu propio Excel en la ruta y apúntala:
export PADRON_XLSX=/ruta/a/tu_padron.xlsx
python3 fuentes/padron_escuelas/etl_padron.py
```

El script lee el Excel, **repara el *mojibake*** típico del export ESCALE y escribe CSVs
listos para cargar en `pad_escuela`, `pad_escuela_componente` y `core_ie`.

> El Excel real **no** está en este repositorio. Usa `data/synthetic/padron_escuelas_ejemplo.csv`
> como muestra del formato esperado.

## 4. Google Apps Script (formularios → hojas)

`fuentes/cca/CCA_codigoGS_2026.gs` y `fuentes/ms/MS_codigoGS_2026.gs` son el backend de
formularios de campo (5 y 4 módulos), con:

- `SPREADSHEET_ID` y `CARPETA_RAIZ_ID` como **placeholders** (`<SPREADSHEET_ID_...>`): pon los de
  tu propia hoja.
- Funciones `doGet`/`doPost`, validación de módulos y un endpoint JSON para el dashboard.

Para probarlo: crea un proyecto de Apps Script, pega el `.gs`, reemplaza los placeholders y
publica como aplicación web.

## 5. Verificación antes de publicar

```bash
```

Recorre el repo y avisa si aparece una credencial, un host interno, un correo personal, un ID
de hoja de cálculo, un teléfono/DNI o una ruta privada. Si imprime **Limpio**, se puede publicar.

## Notas de saneamiento (qué se cambió para publicar)

- Se eliminaron: `.env` reales, credenciales, seeds con datos reales (personas, escuelas,
  POA), los CSV generados desde el padrón real, los mockups internos, las auditorías internas
  y las carpetas privadas (`_privado/`, `runner/`).
- Los **IDs de hojas/carpetas de Google** y los **correos** se reemplazaron por placeholders.
- La semilla de roles/usuarios se reescribió con **personas y correos ficticios**.
- Los nombres de bases internas se generalizaron (`bd_intranet`, `bd_analitica`).
- Los ejemplos de datos (padrón y actividades) se **generan sintéticamente**.
