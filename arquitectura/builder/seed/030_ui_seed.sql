/* 030_ui_seed.sql — configuración de interfaz (idioma, tema, textos, vistas).
   Generado por gen_ui.py. Idempotente (WHERE NOT EXISTS). */
SET search_path TO efectoancash, public;
BEGIN;

INSERT INTO ui_idioma (codigo, nombre, activo)
SELECT 'es', 'Español', true WHERE NOT EXISTS (SELECT 1 FROM ui_idioma WHERE codigo='es');

INSERT INTO ui_tema (codigo, nombre, es_default, activo)
SELECT 'base', 'Base (claro)', true, true WHERE NOT EXISTS (SELECT 1 FROM ui_tema WHERE codigo='base');

INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--fuente-base', 'Inter, system-ui, -apple-system, Segoe UI, sans-serif', 'font', 'tipografia', 'Fuente del cuerpo' FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--fuente-base');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--fuente-titulo', 'Inter, system-ui, -apple-system, Segoe UI, sans-serif', 'font', 'tipografia', 'Fuente de títulos' FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--fuente-titulo');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--fs-xs', '12px', 'size', 'tipografia', NULL FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--fs-xs');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--fs-sm', '14px', 'size', 'tipografia', NULL FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--fs-sm');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--fs-md', '16px', 'size', 'tipografia', 'Tamaño base' FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--fs-md');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--fs-lg', '20px', 'size', 'tipografia', NULL FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--fs-lg');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--fs-xl', '24px', 'size', 'tipografia', NULL FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--fs-xl');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--fs-xxl', '32px', 'size', 'tipografia', NULL FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--fs-xxl');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--fw-normal', '400', 'size', 'tipografia', NULL FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--fw-normal');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--fw-bold', '700', 'size', 'tipografia', NULL FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--fw-bold');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--color-primario', '#1f6feb', 'color', 'color', NULL FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--color-primario');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--color-secundario', '#0d9488', 'color', 'color', NULL FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--color-secundario');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--color-fondo', '#f7f8fa', 'color', 'color', NULL FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--color-fondo');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--color-superficie', '#ffffff', 'color', 'color', NULL FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--color-superficie');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--color-texto', '#1b1f24', 'color', 'color', NULL FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--color-texto');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--color-muted', '#6b7280', 'color', 'color', NULL FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--color-muted');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--color-exito', '#16a34a', 'color', 'color', 'semáforo OK' FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--color-exito');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--color-alerta', '#d97706', 'color', 'color', 'semáforo medio' FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--color-alerta');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--color-peligro', '#dc2626', 'color', 'color', 'semáforo alto' FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--color-peligro');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--radio', '10px', 'radius', 'layout', NULL FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--radio');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--esp-1', '4px', 'spacing', 'layout', NULL FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--esp-1');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--esp-2', '8px', 'spacing', 'layout', NULL FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--esp-2');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--esp-3', '16px', 'spacing', 'layout', NULL FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--esp-3');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--esp-4', '24px', 'spacing', 'layout', NULL FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--esp-4');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--sombra-1', '0 1px 3px rgba(0,0,0,.08)', 'shadow', 'layout', NULL FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--sombra-1');
INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)
SELECT t.id, '--ancho-max', '1200px', 'spacing', 'layout', 'Ancho máximo del contenido' FROM ui_tema t WHERE t.codigo='base'
  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token='--ancho-max');

INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'app.nombre', i.id, 'Efecto Áncash · MEL', 'app' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='app.nombre' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'app.subtitulo', i.id, 'Monitoreo, Evaluación y Aprendizaje', 'app' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='app.subtitulo' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'login.titulo', i.id, 'Iniciar sesión', 'login' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='login.titulo' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'login.usuario', i.id, 'Usuario', 'login' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='login.usuario' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'login.clave', i.id, 'Clave', 'login' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='login.clave' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'login.entrar', i.id, 'Entrar', 'login' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='login.entrar' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'login.error', i.id, 'Usuario o clave incorrectos', 'login' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='login.error' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'nav.programacion', i.id, 'Programación', 'nav' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='nav.programacion' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'nav.cca', i.id, 'CCA', 'nav' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='nav.cca' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'nav.mente_sana', i.id, 'Mente Sana', 'nav' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='nav.mente_sana' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'nav.indicadores', i.id, 'Indicadores', 'nav' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='nav.indicadores' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'nav.academia', i.id, 'Academia Juvenil', 'nav' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='nav.academia' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'comun.dashboard', i.id, 'Panel', 'comun' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='comun.dashboard' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'comun.guardar', i.id, 'Guardar', 'comun' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='comun.guardar' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'comun.enviar', i.id, 'Guardar y enviar', 'comun' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='comun.enviar' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'comun.cargando', i.id, 'Cargando…', 'comun' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='comun.cargando' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'comun.sin_datos', i.id, 'Sin datos para los filtros elegidos', 'comun' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='comun.sin_datos' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'kpi.n_ie', i.id, 'IE atendidas', 'indicadores' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='kpi.n_ie' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'kpi.n_participantes', i.id, 'Participantes', 'indicadores' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='kpi.n_participantes' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'kpi.acompanamientos', i.id, 'Acompañamientos', 'indicadores' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='kpi.acompanamientos' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'kpi.renuncias', i.id, 'Renuncias', 'indicadores' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='kpi.renuncias' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'bloque.filtros', i.id, 'Filtros', 'bloques' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='bloque.filtros' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'bloque.agenda', i.id, 'Agenda', 'bloques' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='bloque.agenda' AND x.idioma_id=i.id);
INSERT INTO ui_texto (clave, idioma_id, valor, contexto)
SELECT 'bloque.kpis', i.id, 'Indicadores clave', 'bloques' FROM ui_idioma i WHERE i.codigo='es'
  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave='bloque.kpis' AND x.idioma_id=i.id);

INSERT INTO ui_vista (codigo, ruta, titulo_clave, icono, orden, activo)
SELECT 'programacion', '#/programacion', 'nav.programacion', 'calendar', 10, true WHERE NOT EXISTS (SELECT 1 FROM ui_vista WHERE codigo='programacion');
INSERT INTO ui_vista (codigo, ruta, titulo_clave, icono, orden, activo)
SELECT 'cca', '#/cca', 'nav.cca', 'users', 20, true WHERE NOT EXISTS (SELECT 1 FROM ui_vista WHERE codigo='cca');
INSERT INTO ui_vista (codigo, ruta, titulo_clave, icono, orden, activo)
SELECT 'mente_sana', '#/mente-sana', 'nav.mente_sana', 'users', 30, true WHERE NOT EXISTS (SELECT 1 FROM ui_vista WHERE codigo='mente_sana');
INSERT INTO ui_vista (codigo, ruta, titulo_clave, icono, orden, activo)
SELECT 'indicadores', '#/indicadores', 'nav.indicadores', 'bar-chart', 40, true WHERE NOT EXISTS (SELECT 1 FROM ui_vista WHERE codigo='indicadores');
INSERT INTO ui_vista (codigo, ruta, titulo_clave, icono, orden, activo)
SELECT 'academia', '#/academia', 'nav.academia', 'award', 50, true WHERE NOT EXISTS (SELECT 1 FROM ui_vista WHERE codigo='academia');

INSERT INTO ui_bloque (vista_id, codigo, titulo_clave, tipo, orden, fijo, visible, ancho)
SELECT v.id, 'filtros', 'bloque.filtros', 'filtros', 1, true, true, 'full' FROM ui_vista v WHERE v.codigo='programacion'
  AND NOT EXISTS (SELECT 1 FROM ui_bloque x WHERE x.vista_id=v.id AND x.codigo='filtros');
INSERT INTO ui_bloque (vista_id, codigo, titulo_clave, tipo, orden, fijo, visible, ancho)
SELECT v.id, 'agenda', 'bloque.agenda', 'agenda', 2, false, true, 'full' FROM ui_vista v WHERE v.codigo='programacion'
  AND NOT EXISTS (SELECT 1 FROM ui_bloque x WHERE x.vista_id=v.id AND x.codigo='agenda');
INSERT INTO ui_bloque (vista_id, codigo, titulo_clave, tipo, orden, fijo, visible, ancho)
SELECT v.id, 'kpis', 'bloque.kpis', 'kpis', 1, true, true, 'full' FROM ui_vista v WHERE v.codigo='indicadores'
  AND NOT EXISTS (SELECT 1 FROM ui_bloque x WHERE x.vista_id=v.id AND x.codigo='kpis');
INSERT INTO ui_bloque (vista_id, codigo, titulo_clave, tipo, orden, fijo, visible, ancho)
SELECT v.id, 'graficos', NULL, 'grafico', 2, false, true, 'full' FROM ui_vista v WHERE v.codigo='indicadores'
  AND NOT EXISTS (SELECT 1 FROM ui_bloque x WHERE x.vista_id=v.id AND x.codigo='graficos');
INSERT INTO ui_bloque (vista_id, codigo, titulo_clave, tipo, orden, fijo, visible, ancho)
SELECT v.id, 'detalle', NULL, 'tabla', 3, false, true, 'full' FROM ui_vista v WHERE v.codigo='indicadores'
  AND NOT EXISTS (SELECT 1 FROM ui_bloque x WHERE x.vista_id=v.id AND x.codigo='detalle');

INSERT INTO ui_elemento (bloque_id, clave, tipo, titulo_clave, fuente_dato, orden, visible)
SELECT b.id, 'n_ie', 'kpi', 'kpi.n_ie', 'vw_resumen_jefe_territorial', 1, true
  FROM ui_bloque b JOIN ui_vista v ON v.id=b.vista_id
 WHERE v.codigo='indicadores' AND b.codigo='kpis'
   AND NOT EXISTS (SELECT 1 FROM ui_elemento x WHERE x.bloque_id=b.id AND x.clave='n_ie');
INSERT INTO ui_elemento (bloque_id, clave, tipo, titulo_clave, fuente_dato, orden, visible)
SELECT b.id, 'n_participantes', 'kpi', 'kpi.n_participantes', 'vw_resumen_jefe_territorial', 2, true
  FROM ui_bloque b JOIN ui_vista v ON v.id=b.vista_id
 WHERE v.codigo='indicadores' AND b.codigo='kpis'
   AND NOT EXISTS (SELECT 1 FROM ui_elemento x WHERE x.bloque_id=b.id AND x.clave='n_participantes');
INSERT INTO ui_elemento (bloque_id, clave, tipo, titulo_clave, fuente_dato, orden, visible)
SELECT b.id, 'n_acompanamientos', 'kpi', 'kpi.acompanamientos', 'vw_resumen_jefe_territorial', 3, true
  FROM ui_bloque b JOIN ui_vista v ON v.id=b.vista_id
 WHERE v.codigo='indicadores' AND b.codigo='kpis'
   AND NOT EXISTS (SELECT 1 FROM ui_elemento x WHERE x.bloque_id=b.id AND x.clave='n_acompanamientos');
INSERT INTO ui_elemento (bloque_id, clave, tipo, titulo_clave, fuente_dato, orden, visible)
SELECT b.id, 'n_renuncias', 'kpi', 'kpi.renuncias', 'vw_resumen_jefe_territorial', 4, true
  FROM ui_bloque b JOIN ui_vista v ON v.id=b.vista_id
 WHERE v.codigo='indicadores' AND b.codigo='kpis'
   AND NOT EXISTS (SELECT 1 FROM ui_elemento x WHERE x.bloque_id=b.id AND x.clave='n_renuncias');

COMMIT;
