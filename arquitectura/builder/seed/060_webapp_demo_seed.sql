/* 060_webapp_demo_seed.sql — SEMILLA DE DEMOSTRACIÓN (WebApp MEL / Efecto Áncash)
   ---------------------------------------------------------------------------
   SOLO schema `efectoancash`. Todo lo sembrado lleva el marcador `[SEED]` y se
   puede purgar con `purge_seed.sql` (generado por `seed_webapp_demo.py`).
   Idempotente: `INSERT ... WHERE NOT EXISTS` (no borra nada, no duplica).
   NO toca datos reales: solo agrega filas nuevas + 2 catálogos nuevos.
   Generado/curardo 17-sep-2026. */
SET search_path TO efectoancash, public;

/* ============================================================ 1. CATÁLOGOS ==
   core_catalogo_item no admite jerarquía (no hay padre_id) => dos catálogos. */

INSERT INTO core_catalogo (dominio, nombre)
SELECT 'CATEGORIA_INCIDENCIA', 'Categoría de incidencia'
WHERE NOT EXISTS (SELECT 1 FROM core_catalogo WHERE dominio = 'CATEGORIA_INCIDENCIA');

INSERT INTO core_catalogo (dominio, nombre)
SELECT 'SUBCATEGORIA_INCIDENCIA', 'Subcategoría de incidencia'
WHERE NOT EXISTS (SELECT 1 FROM core_catalogo WHERE dominio = 'SUBCATEGORIA_INCIDENCIA');

INSERT INTO core_catalogo_item (catalogo_id, codigo, etiqueta, color_hex, orden)
SELECT c.id, v.codigo, v.etiqueta, v.color, v.orden
  FROM core_catalogo c
  CROSS JOIN (VALUES
    ('RT',  'Relacionamiento territorial', '#6B3293', 1),
    ('OP',  'Operativa del equipo',        '#0077A8', 2),
    ('PB',  'Protección y bienestar',      '#0E7C70', 3),
    ('IE',  'Integridad y ética',          '#C0574B', 4),
    ('AT',  'Riesgo territorial',          '#B5651D', 5),
    ('BP',  'Riesgo en participantes',     '#8A6FB0', 6),
    ('NEE', 'Riesgo de aprendizaje',       '#4A7FB5', 7),
    ('DO',  'Riesgo operativo',            '#5B8C5A', 8)
  ) AS v(codigo, etiqueta, color, orden)
 WHERE c.dominio = 'CATEGORIA_INCIDENCIA'
   AND NOT EXISTS (SELECT 1 FROM core_catalogo_item i
                    WHERE i.catalogo_id = c.id AND i.codigo = v.codigo);

INSERT INTO core_catalogo_item (catalogo_id, codigo, etiqueta, color_hex, orden)
SELECT c.id, v.codigo, v.etiqueta, NULL, v.orden
  FROM core_catalogo c
  CROSS JOIN (VALUES
    ('FISICA',              'Física',                  1),
    ('VERBAL',              'Verbal',                  2),
    ('PSICOLOGICA',         'Psicológica',             3),
    ('SEXUAL',              'Sexual',                  4),
    ('CIBERBULLYING',       'Ciberbullying',           5),
    ('ACCIDENTE',           'Accidente',               6),
    ('ENFERMEDAD',          'Enfermedad',              7),
    ('CRISIS_EMOCIONAL',    'Crisis emocional',        8),
    ('NEGLIGENCIA',         'Negligencia',             9),
    ('VIOLENCIA_DOMESTICA', 'Violencia doméstica',    10),
    ('AUSENTISMO_DOCENTE',  'Ausentismo docente',     11),
    ('INFRAESTRUCTURA',     'Infraestructura',        12),
    ('CONFLICTO_AUTORIDAD', 'Conflicto con autoridad',13),
    ('LOGISTICA',           'Logística',              14),
    ('COMUNICACION',        'Comunicación',           15),
    ('CLIMA_LABORAL',       'Clima laboral',          16)
  ) AS v(codigo, etiqueta, orden)
 WHERE c.dominio = 'SUBCATEGORIA_INCIDENCIA'
   AND NOT EXISTS (SELECT 1 FROM core_catalogo_item i
                    WHERE i.catalogo_id = c.id AND i.codigo = v.codigo);

/* ======================================================= 2. REGLAS DE ALERTA */

INSERT INTO prog_alerta_regla (nombre, tipo, nivel_semaforo_min_id, roles_destino, incluir_jefe, canal, escalar_minutos, activo)
SELECT v.nombre, 'incidencia',
       (SELECT i.id FROM core_catalogo_item i JOIN core_catalogo c ON c.id = i.catalogo_id
         WHERE c.dominio = 'NIVEL_SEMAFORO' AND i.codigo = v.sem),
       v.roles, TRUE, 'push', v.esc, TRUE
  FROM (VALUES
    ('[SEED] Escalar casos urgentes',  'rojo',  'admin_mel,jefe_territorial', 60),
    ('[SEED] Seguimiento moderado',    'ambar', 'jefe_territorial',          240),
    ('[SEED] Aviso informativo leve',  'verde', 'admin_mel',                 NULL)
  ) AS v(nombre, sem, roles, esc)
 WHERE NOT EXISTS (SELECT 1 FROM prog_alerta_regla r WHERE r.nombre = v.nombre);

/* ============================== 3. SUB-ACTIVIDADES (prog_actividad_pequena) ==
   15 filas [SEED] sep–oct 2026, sobre las actividades grandes reales (AG25–AG42).
   Clave de idempotencia = `especifico` (marcador único). */

INSERT INTO prog_actividad_pequena
  (act_grande_id, ie_id, distrito, centro_poblado, nivel, especifico,
   responsable_id, fecha_programada, hora_inicio, estado_id)
SELECT v.ag,
       (SELECT ie.id FROM core_ie ie WHERE ie.ugt_id = ag.ugt_id ORDER BY ie.id LIMIT 1),
       v.distrito, v.cp, v.nivel, v.marca, v.resp,
       v.f::timestamptz, v.h::time,
       (SELECT i.id FROM core_catalogo_item i JOIN core_catalogo c ON c.id = i.catalogo_id
         WHERE c.dominio = 'ESTADO_ACTIVIDAD' AND i.codigo = v.est)
  FROM (VALUES
    (25, 'San Marcos',     'Huaripampa',    'Secundaria', '[SEED] T3 Visita en aula PDL · 22 set · San Marcos',        31, '2026-09-22 10:00:00-05', '10:00', 'programado'),
    (26, 'San Marcos',     'Carhuayoc',     'Primaria',   '[SEED] T3 ENFOCO núcleo PDL · 08 set · San Marcos',         45, '2026-09-08 09:00:00-05', '09:00', 'ejecutado'),
    (27, 'Chacas',         'Chacas',        'Primaria',   '[SEED] T3 Visita pedagógica QM · 15 set · Chacas',          31, '2026-09-15 10:30:00-05', '10:30', 'ejecutado'),
    (28, 'Huari',          'Huari',         'Secundaria', '[SEED] T3 ENFOCO regional QM · 10 set · Huari',             28, '2026-09-10 15:00:00-05', '15:00', 'ejecutado'),
    (29, 'Huarmey',        'Huarmey',       'Secundaria', '[SEED] T3 ENFOCO PDLD · 05 set · Huarmey',                  36, '2026-09-05 09:00:00-05', '09:00', 'ejecutado'),
    (30, 'Huarmey',        'Culebras',      'Primaria',   '[SEED] T3 Visita a directivo · 24 set · Culebras',          47, '2026-09-24 11:00:00-05', '11:00', 'programado'),
    (31, 'Huarmey',        'Malvas',        'Primaria',   '[SEED] T3 Jornada lecto · 29 set · Malvas',                 32, '2026-09-29 08:30:00-05', '08:30', 'programado'),
    (32, 'Acochaca',       'Acochaca',      'Primaria',   '[SEED] T3 Acompañamiento lecto · 04 set · Acochaca',    NULL, '2026-09-04 09:00:00-05', '09:00', 'cancelado'),
    (33, 'San Luis',       'San Luis',      'Primaria',   '[SEED] T3 Evaluación diagnóstica · 19 set · San Luis',  NULL, '2026-09-19 08:00:00-05', '08:00', 'reprogramado'),
    (34, 'Huari',          'Huari',         'Inicial',    '[SEED] T4 Experiencia familias CCA · 02 oct · Huari',       36, '2026-10-02 10:00:00-05', '10:00', 'programado'),
    (35, 'San Marcos',     'San Marcos',    'Secundaria', '[SEED] T4 Formación facilitadores MS · 06 oct · San Marcos',37, '2026-10-06 09:30:00-05', '09:30', 'programado'),
    (36, 'San Marcos',     'Carhuayoc',     'Secundaria', '[SEED] T3 Experiencia socioemocional MS · 12 set · Carhuayoc', NULL, '2026-09-12 11:00:00-05', '11:00', 'postergado'),
    (37, 'Huari',          'Huari',         'Secundaria', '[SEED] T4 Experiencia liderazgo PDLE · 09 oct · Huari',     38, '2026-10-09 10:00:00-05', '10:00', 'programado'),
    (38, 'Huari',          'Huari',         'Secundaria', '[SEED] T3 Feria vocacional AJ · 26 set · Huari',            39, '2026-09-26 09:00:00-05', '09:00', 'programado'),
    (42, 'Chacas',         'Chacas',        'Inicial',    '[SEED] T4 Acompañamiento IIEE PEIPAT · 13 oct · Chacas',    40, '2026-10-13 09:00:00-05', '09:00', 'programado')
  ) AS v(ag, distrito, cp, nivel, marca, resp, f, h, est)
  JOIN prog_poa_actividad_grande ag ON ag.id = v.ag
 WHERE NOT EXISTS (SELECT 1 FROM prog_actividad_pequena s WHERE s.especifico = v.marca);

/* =============================================================== 4. REPORTES ==
   Un reporte por cada sub-actividad [SEED] en estado 'ejecutado'. */

INSERT INTO prog_reporte (act_pequena_id, descripcion, logro, n_docentes, n_familias,
                          n_estudiantes, n_otros, estado, enviado_en)
SELECT s.id, v.des, v.log, v.nd, v.nf, v.ne, 0, 'enviado', s.fecha_programada + interval '1 day'
  FROM (VALUES
    ('[SEED] T3 ENFOCO núcleo PDL · 08 set · San Marcos',
     '[SEED] Aplicación del núcleo ENFOCO con docentes del programa de liderazgo.',
     '[SEED] Núcleo aplicado en 1 IIEE; 12 docentes participantes; 3 acuerdos de aula.', 12, 3, 0),
    ('[SEED] T3 Visita pedagógica QM · 15 set · Chacas',
     '[SEED] Visita de acompañamiento pedagógico en aula (Qué Maestro).',
     '[SEED] 8 docentes observados; retroalimentación individual entregada.', 8, 0, 24),
    ('[SEED] T3 ENFOCO regional QM · 10 set · Huari',
     '[SEED] Encuentro regional de docentes Qué Maestro.',
     '[SEED] 24 docentes de 5 IIEE; planificación de la ruta T3 cerrada.', 24, 2, 0),
    ('[SEED] T3 ENFOCO PDLD · 05 set · Huarmey',
     '[SEED] ENFOCO con directivos priorizados (PDLD).',
     '[SEED] 6 directivos acompañados; 2 planes de mejora en revisión.', 6, 0, 0)
  ) AS v(marca, des, log, nd, nf, ne)
  JOIN prog_actividad_pequena s ON s.especifico = v.marca
 WHERE NOT EXISTS (SELECT 1 FROM prog_reporte r WHERE r.act_pequena_id = s.id);

/* ============================================================ 5. INCIDENCIAS ==
   Categoría/subcategoría por dominio (nunca por código suelto) y semáforo en
   el vocabulario del catálogo (verde/ambar/rojo). */

INSERT INTO prog_incidencia (reporte_id, tipo, categoria_id, subcategoria_id, nivel_semaforo_id,
                             diagnostico_previo, descripcion)
SELECT (SELECT r.id FROM prog_reporte r
          JOIN prog_actividad_pequena s ON s.id = r.act_pequena_id
         WHERE s.especifico = v.marca LIMIT 1),
       v.tipo,
       (SELECT i.id FROM core_catalogo_item i JOIN core_catalogo c ON c.id = i.catalogo_id
         WHERE c.dominio = 'CATEGORIA_INCIDENCIA'   AND i.codigo = v.cat),
       (SELECT i.id FROM core_catalogo_item i JOIN core_catalogo c ON c.id = i.catalogo_id
         WHERE c.dominio = 'SUBCATEGORIA_INCIDENCIA' AND i.codigo = v.sub),
       (SELECT i.id FROM core_catalogo_item i JOIN core_catalogo c ON c.id = i.catalogo_id
         WHERE c.dominio = 'NIVEL_SEMAFORO' AND i.codigo = v.sem),
       v.diag, v.descr
  FROM (VALUES
    ('[SEED] T3 Visita pedagógica QM · 15 set · Chacas', 'incidencia', 'IE',  'INF',  'ambar', NULL,
     '[SEED] Incidencia IE: Infraestructura — Aula con techo deteriorado reportada durante la visita pedagógica.'),
    (NULL, 'alerta', 'NEE', 'RAP', 'verde', 'En proceso',
     '[SEED] Alerta NEE: Riesgo de aprendizaje — 3 estudiantes con baja asistencia y desfase lector.'),
    ('[SEED] T3 ENFOCO PDLD · 05 set · Huarmey', 'incidencia', 'AT',  'AUS',  'rojo', NULL,
     '[SEED] Incidencia AT: Ausentismo docente — Docente con 4 faltas consecutivas en la IIEE priorizada.'),
    (NULL, 'alerta', 'DOC', 'DOCP', 'ambar', NULL,
     '[SEED] Alerta DOC: Desempeño docente — Planificación sin adecuación curricular en 2 secciones.')
  ) AS v(marca, tipo, cat, sub, sem, diag, descr)
 WHERE NOT EXISTS (SELECT 1 FROM prog_incidencia x WHERE x.descripcion = v.descr);

/* ====================================================== 6. NOTIFICACIONES ====
   El "estado" del caso se deriva de aquí: pendiente/enviado → En seguimiento;
   cerrado → Cerrada; sin notificaciones → Abierta. */

INSERT INTO prog_notificacion (incidencia_id, regla_id, destinatario_id, canal, asunto, cuerpo,
                               estado, intentos, enviado_en, creado_en)
SELECT i.id, r.id, v.dest, 'push', v.asunto, v.cuerpo, v.estado, v.intentos,
       CASE WHEN v.estado = 'pendiente' THEN NULL ELSE now() - interval '1 day' END,
       now() - interval '2 day'
  FROM (VALUES
    ('[SEED] Alerta NEE: Riesgo de aprendizaje — 3 estudiantes con baja asistencia y desfase lector.',
     '[SEED] Seguimiento moderado', 31, '[SEED] Caso NEE en seguimiento',    '[SEED] Se asignó seguimiento al caso NEE y se notificó al coordinador de programa.', 'pendiente', 0),
    ('[SEED] Incidencia AT: Ausentismo docente — Docente con 4 faltas consecutivas en la IIEE priorizada.',
     '[SEED] Escalar casos urgentes', 47, '[SEED] Caso urgente resuelto',    '[SEED] Se coordinó con la IIEE y se regularizó la asistencia docente. Caso cerrado.', 'cerrado', 2),
    ('[SEED] Incidencia IE: Infraestructura — Aula con techo deteriorado reportada durante la visita pedagógica.',
     '[SEED] Seguimiento moderado', 36, '[SEED] Caso IE derivado',           '[SEED] Se derivó el caso de infraestructura y se notificó al jefe territorial.', 'enviado', 1)
  ) AS v(idesc, regla, dest, asunto, cuerpo, estado, intentos)
  JOIN prog_incidencia i ON i.descripcion = v.idesc
  JOIN prog_alerta_regla r ON r.nombre = v.regla
 WHERE NOT EXISTS (SELECT 1 FROM prog_notificacion n
                    WHERE n.incidencia_id = i.id AND n.asunto = v.asunto);

/* ========================================================== 7. EVENTOS ======= */

INSERT INTO core_evento (entidad, entidad_id, accion, usuario_id, payload, fecha)
SELECT v.ent, (SELECT s.id FROM prog_actividad_pequena s WHERE s.especifico = v.marca),
       v.acc, v.usr, v.txt, v.f::timestamptz
  FROM (VALUES
    ('prog_actividad_pequena', '[SEED] T3 ENFOCO PDLD · 05 set · Huarmey',   'Reporte',      36, '[SEED] Reportó la ejecución de ENFOCO PDLD en Huarmey.',                     '2026-09-05 13:05:00-05'),
    ('prog_actividad_pequena', '[SEED] T3 ENFOCO núcleo PDL · 08 set · San Marcos', 'Reporte', 45, '[SEED] Reportó el núcleo ENFOCO PDL con 12 docentes.',                       '2026-09-08 12:40:00-05'),
    ('prog_actividad_pequena', '[SEED] T3 ENFOCO regional QM · 10 set · Huari','Reporte',      28, '[SEED] Reportó el ENFOCO regional QM (24 docentes).',                       '2026-09-10 18:10:00-05'),
    ('prog_actividad_pequena', '[SEED] T3 Visita pedagógica QM · 15 set · Chacas', 'Reporte',   31, '[SEED] Reportó la visita pedagógica QM en Chacas.',                         '2026-09-15 16:25:00-05'),
    ('prog_actividad_pequena', '[SEED] T3 Visita pedagógica QM · 15 set · Chacas', 'Actualización', NULL, '[SEED] Se actualizó la fecha programada de la visita pedagógica QM.',   '2026-09-16 09:15:00-05'),
    ('prog_actividad_pequena', '[SEED] T3 Acompañamiento lecto · 04 set · Acochaca', 'Actualización', NULL, '[SEED] Sub-actividad cancelada: IIEE en semana de exámenes.',            '2026-09-03 17:40:00-05'),
    ('prog_incidencia',        NULL,                                          'Incidencia',   28, '[SEED] Registró el caso IE · Infraestructura (aula con techo deteriorado).', '2026-09-15 16:40:00-05'),
    ('prog_incidencia',        NULL,                                          'Incidencia',   28, '[SEED] Registró el caso AT · Ausentismo docente (urgente).',                 '2026-09-05 14:05:00-05'),
    ('core_comentario',        NULL,                                          'Comentario',   28, '[SEED] Comentario en portada sobre el avance del T3.',                       '2026-09-10 08:55:00-05'),
    ('prog_actividad_pequena', '[SEED] T3 Evaluación diagnóstica · 19 set · San Luis', 'Creación', NULL, '[SEED] Sub-actividad reprogramada para el 19 de setiembre.',              '2026-09-12 10:05:00-05'),
    ('prog_actividad_pequena', NULL,                                          'Creación',     NULL, '[SEED] Se generó la programación T4 en el tablero MEL.',                     '2026-09-16 07:30:00-05'),
    ('prog_actividad_pequena', NULL,                                          'Actualización', 31, '[SEED] Ajuste de metas del POA T3 en la UGT Huarmey.',                      '2026-09-11 15:20:00-05')
  ) AS v(ent, marca, acc, usr, txt, f)
 WHERE NOT EXISTS (SELECT 1 FROM core_evento e WHERE e.payload = v.txt);

/* ======================================================= 8. COMENTARIOS ====== */

INSERT INTO core_comentario (usuario_id, texto, fecha)
SELECT v.usr, v.txt, v.f::timestamptz
  FROM (VALUES
    (28, '[SEED] Buen avance del T3: 4 actividades ejecutadas y reportadas; queda pendiente cerrar los casos IE y AT.', '2026-09-16 08:05:00-05'),
    (31, '[SEED] Coordinado con la UGT Huarmey la reprogramación de la evaluación diagnóstica.', '2026-09-15 17:30:00-05')
  ) AS v(usr, txt, f)
 WHERE NOT EXISTS (SELECT 1 FROM core_comentario c WHERE c.texto = v.txt);
