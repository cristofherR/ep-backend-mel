# Coherencia del modelo — Efecto Áncash MEL

Generado por `build.py` (PostgreSQL). Capas y tablas:

- **core** (`order 0`, prefijo `core_`): 20 tablas — Capa 0 — Núcleo transversal. Dimensiones y entidades compartidas por TODOS los proyectos (
- **padron** (`order 5`, prefijo `pad_`): 2 tablas — Capa 0b — Padrón ESCALE (fuente OFICIAL de localización / IIEE). 1 fila = 1 COD_MOD (escue
- **programacion** (`order 10`, prefijo `prog_`): 7 tablas — Capa 1 — Dominio "Gestión de territorio / POA". Migra las listas EA_POA (actividad grande)
- **instrumentos** (`order 15`, prefijo `inst_`): 4 tablas — Capa 1b — Motor de instrumentos (encuestas y evaluaciones). Evita crear 30 tablas de pregu
- **cca** (`order 20`, prefijo `cca_`): 4 tablas — Capa 2 — Módulo CCA (Crecemos con Amor, primera infancia). Migra las 11 pestañas del Sheet
- **mente_sana** (`order 30`, prefijo `ms_`): 4 tablas — Capa 3 — Módulo Mente Sana (transición primaria-secundaria). Reusa el núcleo (IE x Nivel v
- **pdle** (`order 40`, prefijo `pdle_`): 3 tablas — Capa 4 — ESQUELETO PDLE (Programa de Liderazgo Estudiantil, componente PROG-7). Aún SIN in
- **academia_juvenil** (`order 50`, prefijo `aj_`): 4 tablas — Capa 5 — ESQUELETO Academia Juvenil (componente PROG-8). Ya existe trabajo previo (Power B
- **analitica** (`order 60`, prefijo `vw_`): 0 tablas — Capa analítica: vistas de solo lectura sobre la intranet (reportes.* y bd_intranet.*, mism
- **ui** (`order 70`, prefijo `ui_`): 7 tablas — Capa 7 — Configuración de interfaz (data-driven UI). Todo lo que en un front suele ir "har

## Chequeos

- ✅ Sin hallazgos: FKs, PKs y nombres coherentes.
