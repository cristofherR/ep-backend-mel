# Web de programación — Vista detallada (EN CONSTRUCCIÓN)

> Diseño compartido por **Cristofher por partes** (desde 2026-09-15 06:18 UTC).
> Regla: cada parte se guarda fiel + interpretación de ARIA + dudas.
> Rol en el schema: módulo **`programacion`** (gestión de territorio), relacionado con `bd_intranet` para **NO duplicar** actividades ya reportadas en la intranet.

## Estado de recepción
- **Parte 1 recibida** (06:19): shell general + Sección 1 "Portada".
- **Parte 2+**: pendiente.
- Prototipo HTML v1: `el-prototipo/portada_v1.html` (+ `portada_v1.png`).
- Íconos SVG (7) embebidos en el HTML v1.

---

## PARTE 1 — Shell + Sección 1 "Portada"

### 1. Contenedor
- Web tipo **app móvil** (mobile-first), pensada para teléfono.

### 2. Barra de navegación inferior (7 secciones)
- **Estática, fija al pie**, visible en todas las secciones. Fondo blanco/gris muy claro.
- 7 íconos = botones de sección. Estilo **Lineal Minimalista / Monoline**: trazo uniforme, esquinas redondeadas, monocromático, geometría simplificada (tipo Lucide / Feather / Tabler / Heroicons Outline).
- El ícono de la sección **activa crece 15%**.
- Orden izquierda→derecha (índice = N° de sección):
  1. Sección 4 — **Actividades** (ícono "bloques/destello")
  2. Sección 3 — **Indicadores** (ícono "gráfico línea")
  3. Sección 2 — **Mi historial** (ícono "reloj/refresh")
  4. Sección 1 — **Home / Portada** (ícono "casa") — **centrado**
  5. Sección 5 — **Reportes** (ícono "lista/portapapeles")
  6. Sección 6 — **Incidencias** (ícono "triángulo alerta")
  7. Sección 7 — **Calendario** (ícono "calendario")

### 3. Sección 1 — Portada
#### 3.1 Barra superior (header)
- Fondo **#1f3460** (azul marino sólido).
- **Izquierda**: saludo dinámico + ícono · debajo **nombre completo** (mayor, bold) · debajo **cargo/rol** (menor, bold).
  - Saludo: **"Buen día"** 05:00–12:00 · **"Buenas tardes"** 12:00–18:30 · **"Buenas noches"** resto.
  - Ícono: **sol** (día/tarde) · **luna** (noche).
  - Ejemplo: "Buenas noches," 🌙 / **Cristofher Rodriguez Atilano** / **Admin MEL - MEL**.
- **Derecha**: **logo "efecto Áncash"** (blanco) con líneas curvas/discontinuas (destello/huella).

#### 3.2 Cuerpo
**Bloque 2** (arriba, entre header y menú) — 3 tarjetas, filtradas al **mes actual**:
- Tarjeta 1: **N° actividades programadas** (entero).
- Tarjeta 2 (debajo): **N° actividades reportadas** (entero).
- Tarjeta 3 (a la derecha, altura = tarjeta1 + tarjeta2): **% reportabilidad** = reportadas / programadas × 100.

**Bloque 1** (centro) — menú de 6 botones (ícono + título), rectángulos de esquinas redondeadas gris claro; son botones de navegación.
- Contenido: Actividades · Indicadores · Mi historial · Reportes · Incidencias · Calendario.
- ⚠️ Ver ambigüedad A-2 (orden/forma de la grilla).

**Bloque 3** — tabla "**Próximas actividades:**": 2 columnas → "Actividad" (ancho **3x**), "Fecha programada" (ancho **x**). Orden: la más cercana en fecha/hora primero; segundo criterio **alfabético**. **Máx 5 filas**.

**Bloque 4** — 2 botones entre el bloque 3 y la barra inferior:
- Izq: **"Visitar web principal"** (redirige).
- Der: **"Dejar comentario o sugerencia"** → abre **modal centrado** (campo de texto, botón cerrar arriba‑derecha, botón enviar abajo‑centro). Al enviar → popup **"Gracias por tus comentarios."**

### 4. Ambigüedades / faltantes (a resolver con Cristofher)
- **A-1 Header**: el texto decía "saludo a la derecha" pero también "logo en esquina superior derecha". La **descripción de la imagen** aclara: saludo+nombre a la **izquierda**, logo a la **derecha**. → se implementó según la imagen.
- **A-2 Grilla del menú**: el texto dice *array 2×3* con coords `[fila;col]` y origen **abajo‑izquierda** (⇒ 2 filas × 3 columnas); la **imagen** muestra 2 columnas × 3 filas. → v1 usa la disposición de la **imagen** (Actividades|Incidencia / Indicadores|Mi Historial / Reportes|Calendario). A confirmar.
- **A-3 Alcance de los indicadores**: ¿"programadas/reportadas" son de **todo el programa**, de la **UGT del usuario**, o solo lo **asignado al usuario**?
- **A-4 "Actividad"**: ¿= sesión/visita programada (intranet `bd_intranet`) o catálogo propio? ¿Qué cuenta como "reportada" (reporte al día CCA/MS, visita, ambos)?
- **A-5 Fuente de "programadas"**: ¿quién/qué módulo registra la programación?
- **A-6 Identidad del usuario**: ¿de dónde salen nombre y cargo (login propio, SharePoint/AD)?
- **A-7 Íconos faltantes**: sol y luna (usuario no los envió) → provisionales; logo Efecto Áncash (¿archivo/URL oficial?).
- **A-8 Diseño**: ¿confirmas hex exactos (gris claro de tarjetas, gris de barra inferior, color de botones)? ¿Solo móvil o también escritorio?
- **A-9 Secciones 2–7**: falta su contenido.

### 5. Lectura de ARIA (entendí correctamente)
- Es una **app móvil de bolsillo** para el personal (arranca en la Portada con saludo/rol).
- Portada = **resumen operativo del mes**: cuánto se programó, cuánto se reportó y el % de reportabilidad.
- Navegación por **barra inferior fija** con 7 secciones; la Portada resalta el ícono central.
- "Próximas actividades" = **agenda vencimiento-próximo** (5 filas máx).
- Retroalimentación al usuario por **comentarios/sugerencias** (modal → confirmación).

### 6. Implicaciones para el modelo de datos (borrador)
- Entidad **`usuario`** (nombre, cargo/rol) → para el header y permisos.
- **`actividad_programada`** (fecha_programada, estado, UGT/IE, responsable) → alimenta "programadas", "% reportabilidad" y "próximas".
- Vínculo con **`reporte`/`sesion`** para contar como "reportada".
- Entidad **`comentario_sugerencia`** (usuario, texto, timestamp) → nueva.

---

## PARTE 2 — Sección 4 "Actividades (POA)" (recibida 06:41)
Prototipo: `el-prototipo/seccion4_actividades_v1.html` (+ `.png`).

### Estructura
- **Encabezado** fijo, fondo **#0E7C70** (verde turquesa oscuro): izquierda ícono flecha "<" dentro de círculo blanco; centro‑izquierda título en blanco bold **"Actividades (POA)"**.
- **Filtros** (fondo #F1F3F4), 2 filas de desplegables blancos:
  - Fila 1: **Año** (2026) · **Mes** (Abril) · **Territorio (UGT)**
  - Fila 2: **Componente** · **Estado** · botón circular **X** (limpiar filtros) a la derecha.
- **Listado de tarjetas** (scroll vertical), una por **actividad grande (POA)**:
  - Borde lateral izquierdo verde **#4A8B3B**.
  - Cabecera fondo **cian #C2F0EE** con el nombre de la actividad en bold.
  - **Badges**: UGT (verdes #4A8B3B / #73B852 / #20A3A2) · **Componente** (PDL #1E4E79 · QM #702082 · PDLD #0E7C70 · Lectoescritura #D9531E) · meta **(año/mes/estado → #1B75BC)**.
  - Debajo: **círculos de 10px** (uno por **actividad pequeña** dentro de la grande), centrados; color = estado de cumplimiento:
    - Ejecutado → **#437a22** · Reprogramado → **#8e44ad** · Cancelado → **#000000**
    - FechaProgramada vencida > 3 días → **#c0392b** · vencida > 0 días → **#e07000** · resto → **#cccccc**
  - Derecha: botón **chevron ">"** → abre la ventana de actividades pequeñas (crear / cambiar estado / reportar).
- **Barra inferior**: igual a la Portada; queda activo "Actividades" (ícono bloques).

### Lógica Power Apps recibida (referencia clave)
`Filter(EA_Actividades; ID_ActividadGrande = ThisItem.ID)` → los círculos = actividades pequeñas de cada grande.
**Confirmado: existe la tabla `EA_Actividades` (Power Apps) con `ID_ActividadGrande`.**

### Ambigüedades / faltantes (Sección 4)
- **S4‑1** ¿Mapeo oficial de colores por **UGT** y por **Componente**? (¿catálogo fijo?).
- **S4‑2** Catálogo de **Estados** (grande vs pequeña): ¿"Programado" es estado o "pendiente/sin ejecutar"? La lógica usa 3 estados + vencimiento.
- **S4‑3** ¿Los círculos muestran **todas** las pequeñas o solo las no ejecutadas?
- **S4‑4** ¿Cuál es el **esquema real de `EA_Actividades`** (campos de la actividad grande y pequeña)?
- **S4‑5** Ventana de actividades pequeñas (crear/estado/reportar) = nueva **sub‑sección 4.1** → falta su diseño.
- **S4‑6** ¿"Territorio (UGT)" filtra una UGT o multi? ¿Los filtros persisten?
- **S4‑7** ¿El borde izquierdo verde es fijo o varía por componente/UGT? (en la muestra todas verdes).
- **S4‑8** ¿El encabezado #0E7C70 aplica a **todas** las secciones o solo a Actividades?

### Implicaciones para el modelo
- **`actividad_grande`** (POA) 1—N **`actividad_pequena`** (auto‑relación por FK `id_actividad_grande`).
- `actividad_pequena`: fecha_programada, estado, componente, ugt, año, mes, fecha_ejecucion.
- Catálogos: `ugt`, `componente`, `estado_actividad`, `periodo` (año/mes).
- Nota: `EA_Actividades` es la **fuente existente** → su esquema real es insumo obligatorio (S4‑4).

### 7. CATÁLOGOS OFICIALES (recibidos 06:47, desde Power Apps)
**UGT → color** (etiqueta UGT):
- UGT Mina `#666666` · UGT San Marcos `#2e6b1a` · UGT Huallanca `#e07000` · UGT Valle Fortaleza `#6ab84a` · UGT Huarmey `#28b0b0` · Huaripampa `#8a6500` · Region `#c06080` · (default) `#888888`

**Componente (cod · nombre · color):**
- PROG-0 Gestión del Proyecto `#455a64`
- PROG-1 Programa de Liderazgo PDL `#1a4f7a`
- PROG-2 ¡Qué Maestro! QM `#6a1b9a`
- PROG-3 Liderazgo para Directivos PDLD `#00695c`
- PROG-4 Formación en Lectoescritura `#e65100`
- PROG-5 Crecemos con Amor CCA `#ad1457`
- PROG-6 Mente Sana MS `#0277bd`
- PROG-7 Liderazgo Estudiantil PDLE `#2e7d32`
- PROG-8 Academia Juvenil AJ `#6d4c41`
- PROG-9 Conectividad para Aprender `#00838f`
- ECO-1 Gobernanza Territorial `#558b2f`
- ECO-2 MEL `#4527a0`
- ECO-3 Sostenibilidad `#c62828`

**Meta (año / mes / estado):**
- Año → `#1a4f7a` · Mes (`MesProgramado`) → `#009684`
- Estado **grande**: Programado `#0077a8` · En ejecución `#8a6500` · Completado `#437a22` · Reprogramado `#5c3d8f` · No ejecutado `#c0392b` · (default) `#888888`

**Círculos = actividad pequeña** (estado de cumplimiento):
- Ejecutado `#437a22` · Reprogramado `#8e44ad` · Cancelado `#000000` · vencida >3 días `#c0392b` · vencida >0 días `#e07000` · resto `#cccccc`

**Campos confirmados** (por el código): `EA_Actividades.{ID, ID_ActividadGrande, UGT, Anio, MesProgramado, Estado, FechaProgramada}`.
→ **Dos catálogos de Estado distintos:** grande (5) y pequeña (Ejecutado/Reprogramado/Cancelado + pendiente por fecha).

**Pendientes aún:** S4‑3 (¿círculos = todas o solo no ejecutadas?), S4‑4 (esquema real completo), S4‑5 (sub-sección 4.1), S4‑6/4‑7, S4‑8 (¿#0E7C70 en todas las secciones?).

### 8. RESPUESTAS DE CRISTOFHER (06:49) + cambio de requisito
- **#2** ✅ — Catálogos de Estado confirmados: **grande** (Programado · En ejecución · Completado · Reprogramado · No ejecutado) y **pequeña** (Ejecutado · Reprogramado · Cancelado + pendiente por fecha).
- **#3** ✅ — Los círculos muestran **TODAS** las actividades pequeñas (`Filter(EA_Actividades; ID_ActividadGrande = ThisItem.ID)` **sin** filtro de estado).
- **#4** ✅ — Campos de `EA_Actividades` revelados por el código: `ID`, `ID_ActividadGrande`, `UGT`, `Anio`, `MesProgramado`, `Estado`, `FechaProgramada` (+ nombre de la actividad). *(Esquema completo exacto: aún por confirmar si hay más columnas.)*
- **#5** ⏳ — Sub‑sección 4.1 (ventana de actividades pequeñas): “en un momento”.
- **#6** ✅ — Encabezado **#0E7C70 solo en Actividades** (no en las demás secciones).
- **🔴 NUEVO REQUISITO:** agregar a los **filtros** el filtro **CT (Coordinador Territorial)** — necesario porque **UGT Mina tiene dos CT distintos**. → Filtros quedan: Fila 1 *Año · Mes · Territorio* / Fila 2 *CT · Componente · Estado · (X limpiar)*. **Falta el catálogo de CT** (viene de `BD` col. `CT`).

### 9. RESPUESTAS A/B/C DE CRISTOFHER (06:59)
**A) Portada**
- **A1** ✅ Header **como la imagen**: saludo+nombre a la izquierda, logo a la derecha.
- **A2** ✅ Grilla de botones **como la imagen** (2 columnas × 3 filas).
- **A3** ✅ Los 3 números van dirigidos a **CT y gestión de la UGT**: **por cada UGT** (excepción **UGT Mina** → **por cada CT**). Para los demás usuarios → **personal** (por cada uno).
- **A4** ⏳ Qué cuenta como “actividad/reportada”: pendiente.
- **A5** ⏳ Pendiente, pero: **login propio** (se pueden crear usuarios; la info mostrada se **filtra por usuario + password**).

**B) Sección 4**
- **B6** ✅ Confirmado.
- **B7** ⏳ Catálogo CT pendiente; en general **los CT son los de CCA/MS**, o mejor referencia: **el padrón**.
- **B8** ✅ Filtros **combinables** y **se cruzan** entre sí.
- **B9** ✅ Borde verde izquierdo **fijo**.
- **B10** ✅ Puede mostrar **todas**; los **filtros se muestran/actualizan por usuario** y son **modificables**.
- **B11** ✅ Reportar **guarda registro propio** (además del estado).
- **B12** ⏳ Pendiente (la cuenta “ahora”).

**C) Modelo**
- **C13** ✅ Las **actividades grandes** salen de un **POA ingresado por el Admin (Cristofher)** — **solo él** puede añadirlas (se pueden agregar más). Las **actividades pequeñas** las **crean los usuarios**, una por cada actividad grande.
- **C14** ⏳ Relación con `bd_intranet`: pendiente.

**Corrección de diseño:** el prototipo tenía un **error de CSS** (regla de `.sel` sin cerrar → filtros mal renderizados). Corregido.

---

## PARTE 3 — Sub-sección 4.1 "Programación" (recibida 07:10)
Prototipo: `el-prototipo/seccion4_1_programacion_v1.html` (+ `.png`). Se abre al tocar el **chevron ">"** de la Sección 4.

### Estructura
- **Barra superior** (fondo turquesa/aqua **#18C2AD**):
  - Izq: ícono circular con flecha **"<"** (vuelve a la Sección 4).
  - Centro: línea 1 bold **"Visita en aula PDL - Abril 2026"** (nombre de la **AG** + Mes Año); línea 2 **"UGT San Marcos - Programa de Liderazgo (PDL)"** (UGT & " - " & nombre componente).
  - Der: **círculo** con color de estado de la AG → `Switch`: Programado #0077a8 · En ejecución #8a6500 · Completado #437a22 · Reprogramado #5c3d8f · No ejecutado #c0392b · default #888888.
- **Bloque Agregar**: contenedor gris **#ECEFF1**, texto "Agregar nueva actividad" + ícono cuadrado con "+" (**#90A4AE**).
- **Filtros**: **Responsable** ("Cristofher Rodriguez Atila…") + **Estado** ("Programado") + botón **X**.
- **Listado de actividades pequeñas**:
  - Cabecera con el nombre de la pequeña (fondo **#A2C9D9**), borde izq **#38A344**.
  - `Lugar: ` & Distrito & " / " & CentroPoblado & " / " & NombreIE & ` (nivel)` & ` (especifico)`.
  - `Responsable: ` & `ResponsableNuevo.DisplayName`.
  - `Fecha: ` & `Text(dddd)` & "; " & FechaProgramada & ` - Hora inicio: ` & HoraInicio.
  - **Pie der**: punto (color de cumplimiento: Ejecutado #437a22 · Reprogramado #8e44ad · Cancelado #000000 · vencida>3 #c0392b · vencida>0 #e07000 · resto #cccccc) + **píldora** con el estado (Programado #0077a8 · Ejecutado #437a22 · Reprogramado #5c3d8f · Cancelado #c0392b · resto #888888).
- Nav inferior: **Actividades destacado**.

### Campos/código revelado
`varAGSeleccionada.Estado` · actividad pequeña: `Distrito, CentroPoblado, NombreIE, nivel, especifico, ResponsableNuevo.DisplayName, FechaProgramada, HoraInicio, Estado` · control `dpFechaProgramada`.
→ **La actividad pequeña tiene bastantes campos** (Lugar, Responsable, Fecha, Hora inicio, Estado).

### Ambigüedades 4.1
- **E41‑1** Texto del botón: el código dice "Agregar atividad" (typo); la descripción "Agregar nueva actividad". Usé el de la descripción.
- **E41‑2** Círculo del encabezado: el código lo pinta con el `Switch` del estado de la AG; la descripción estimaba #0E7C8B → **usé el Switch** (Programado #0077a8). ¿Correcto?
- **E41‑3** El filtro **Responsable** ¿lista usuarios del sistema? ¿se puede asignar/crear para otro?
- **E41‑4** Estructura del **formulario "Agregar actividad"** (campos exactos) → falta.
- **E41‑5** `especifico` ¿qué valores admite? (¿Secundaria/Primaria/…?)

---

## PARTE 4 — Sub-sección 4.2 "Reporte" (recibida 07:36)
Prototipos: `el-prototipo/seccion4_2_reporte_v1.html` (+`.png`) y `seccion4_2_incidencia_v1.html` (+`.png`, bloque de incidencia/alerta).

### Navegación desde 4.1
Al lado derecho de cada **subactividad** está el **botón + etiqueta de estado**:
```
Set(varSubActividadReporte; ThisItem);
If(ThisItem.Estado.Value = "Programado";
   Navigate(Scr_RegistroReporte; ScreenTransition.UnCover);  // editable
   Navigate(Scr_Detalle; ScreenTransition.UnCover))           // solo lectura (ya cerró)
```
→ Si **Programado** ⇒ pantalla **Reporte (editable)**. Si **Ejecutado/Cancelado** ⇒ pantalla **Detalle (solo lectura)**.

### Contenido — Bloque superior
- **Barra de color** (fondo del bloque) tipo **#6B3293**: **Nombre subactividad & " - " & Mes & " - " & año**.
- Debajo: label **UGT & " - " & componente**.
- Izq: botón atrás. **Der: botón Guardar y enviar** (ícono disquete+flecha, blanco).

### Bloques de datos
- **Actividad**: nombre de la actividad a la que se reporta.
- **Localización** (`With`): `prov & " / " & dist` + `ie` + `(nivel)` + ` - " & esp` + ` Fecha programada: dd/mm/yyyy` (usa `Lugar_Especifico.Text`).
- **Responsable**: `varSubActividadReporte.ResponsableNuevo.DisplayName`.
- **Descripción de la actividad**: text input párrafo (placeholder "Describir puntos importantes de la actividad realizada").
- **Participantes**: 4 contadores enteros ≥0, en fila → **Docente · Familias · Estudiantes · Otros**.
- **Logro del espacio**: text input.

### Toggle incidencia/alerta
- **"¿Hubo incidencia/alerta en esta actividad?"** Sí/No. Si **No** → nada. Si **Sí** → abre bloque de incidencia/alerta.
- Dos opciones: **Incidencia** / **Alerta** (campos distintos por caso).
- **Categorías:** RT Relacionamiento territorial · OP Operativa del equipo · PB Protección y bienestar · IE Integridad y ética · AT Riesgo territorial · BP Riesgo en participantes · NEE Riesgo de aprendizaje · DO Riesgo operativo.
- **Subcategorías (16):** Física · Verbal · Psicológica · Sexual · Ciberbullying · Accidente · Enfermedad · Crisis emocional · Negligencia · Violencia doméstica · Ausentismo docente · Infraestructura · Conflicto con autoridad · Logística · Comunicación · Clima laboral.
- **NivelSemáforo:** Informativo · Leve · Moderado · Urgente · Prioritario.
- **Alerta NEE:** `DiagnosticoPrevio`: No · Sí · En proceso · Desconoce.
- **Dos formas de reportar:** desde la actividad (hereda localización+actividad) o **caso aislado** (Sección 6 / Incidencias).

### Ambigüedades 4.2
- **E42‑1** ¿Qué campos cambian entre **Incidencia** y **Alerta**? (solo sé de la rama NEE).
- **E42‑2** ¿El **mapeo categoría → subcategorías**? (¿las 16 aplican a todas, o cada categoría tiene su lista?).
- **E42‑3** ¿El **semáforo** lo elige el usuario o se calcula? ¿Rol que puede cambiarlo?
- **E42‑4** ¿Se adjunta **evidencia** (foto/PDF) al reporte de incidencia?
- **E42‑5** Falta el mockup previo de Power Apps (alertas NEE) — no lo encontré local; pedir reenvío.
- **E42‑6** Falta la **pantalla Detalle (solo lectura)** (`Scr_Detalle`).
- **E42‑7** Falta el flujo de **cambio de estado** de una subactividad ejecutada/cancelada.
- **E42‑8** El botón Guardar y enviar ¿valida antes de guardar? ¿guarda como Pendiente/Enviado?
- **E42‑9** ✅ (07:38) **Categoría** y **Subcategoría** van como **listas desplegables** (no chips) para ahorrar espacio.
- **E42‑10** ✅ (07:40) El bloque es **dinámico según Incidencia vs Alerta**: al marcar **Alerta** solo campos de alerta (**NEE / informativas**); al marcar **Incidencia** solo campos de incidencia (**violencia y afines**). Prototipo: `el-prototipo/seccion4_2_toggle_v1.html` (dos caras: `#alerta` / `#incidencia`) → `seccion4_2_alerta_v1.png`, `seccion4_2_incidencia_form_v1.png`.
  - ⏳ Falta el **mapeo exacto**: qué **categorías/subcategorías** pertenecen a **Alerta** vs **Incidencia**, y los **campos adicionales de NEE** (además de `DiagnosticoPrevio`).
