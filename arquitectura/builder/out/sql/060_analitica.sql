/* 60_analitica.yaml  —  capa analitica  (Transversal)
   Capa analítica: vistas de solo lectura sobre la intranet (reportes.* y bd_intranet.*, mismo servidor, sin copiar PII) + vistas de resumen por rol (CT, programa, formación, jefe territorial). No crea tablas: solo vistas.
   Schema: efectoancash · Motor: postgres · generado por build.py — no editar a mano. */

CREATE SCHEMA IF NOT EXISTS efectoancash;
SET search_path TO efectoancash, public;

CREATE OR REPLACE VIEW efectoancash.vw_acompanamientos_2026 AS
SELECT 'PDL'::text AS programa, id_participante, participante, cordi, ugt, ugel,
       region, provincia, distrito, nom_ie, cent_pob, cod_mod, cod_local, ciclo,
       periodo, idacompanamiento, fecha, modalidad, estatus_participante
  FROM reportes.dataset_acompanamientos_2026_pdl
UNION ALL
SELECT 'QM'::text, id_participante, participante, cordi, ugt, ugel, region, provincia,
       distrito, nom_ie, cent_pob, cod_mod, cod_local, ciclo, periodo,
       idacompanamiento, fecha, modalidad, estatus_participante
  FROM reportes.dataset_acompanamientos_2026_qm
UNION ALL
SELECT 'PDLD'::text, id_participante, participante, cordi, ugt, ugel, region, provincia,
       distrito, nom_ie, cent_pob, cod_mod, cod_local, ciclo, periodo,
       idacompanamiento, fecha, modalidad, estatus_participante
  FROM reportes.dataset_acompanamientos_2026_pdld
UNION ALL
SELECT 'LECTO'::text, id_participante, participante, cordi, ugt, ugel, region, provincia,
       distrito, nom_ie, cent_pob, cod_mod, cod_local, ciclo, periodo,
       idacompanamiento, fecha, modalidad, estatus_participante
  FROM reportes.dataset_acompanamientos_2026_lecto;
CREATE OR REPLACE VIEW efectoancash.vw_renuncias_2026 AS
SELECT 'PDL'::text AS programa, fecha_renuncia, tipo_salida, motivo_salida,
       institucion_educativa, nivel, codigo_modular, region, provincia,
       distrito, centro_poblado, ugel, coordinador_nombre
  FROM reportes.renuncias_pdl_2026
UNION ALL
SELECT 'QM'::text, fecha_renuncia, tipo_salida, motivo_salida, institucion_educativa,
       nivel, codigo_modular, region, provincia, distrito, centro_poblado, ugel,
       coordinador_nombre
  FROM reportes.renuncias_qm_2026
UNION ALL
SELECT 'PDLD'::text, fecha_renuncia, tipo_salida, motivo_salida, institucion_educativa,
       nivel, codigo_modular, region, provincia, distrito, centro_poblado, ugel,
       coordinador_nombre
  FROM reportes.renuncias_pdld_2026
UNION ALL
SELECT 'LECTO'::text, fecha_renuncia, tipo_salida, motivo_salida, institucion_educativa,
       nivel, codigo_modular, region, provincia, distrito, centro_poblado, ugel,
       coordinador_nombre
  FROM reportes.renuncias_lecto_2026;
CREATE OR REPLACE VIEW efectoancash.vw_espejo_participante AS
SELECT p."ID_Participante"                      AS id_participante,
       p.anio,
       p.programa,
       p.estatus,
       p.es_enfoco,
       p.cod_mod,
       p.nom_ie,
       p.reg, p.prov, p.dist, p.cent_pob, p.ugel,
       d.ugt, d.ct,
       p.cordi_nombre,
       p.nlat, p.nlong
  FROM reportes.bd_participantes p
  LEFT JOIN reportes.dic_ie_ugt_2026 d
         ON d.cod_mod::text = p.cod_mod::text;
CREATE OR REPLACE VIEW efectoancash.vw_nucleo_participante AS
SELECT DISTINCT
       p.programa,
       p.cordi_nombre AS acompanante,
       p.ugt, p.ct,
       p.cod_mod,
       p.nom_ie,
       p.id_participante
  FROM vw_espejo_participante p
 WHERE p.cordi_nombre IS NOT NULL;
CREATE OR REPLACE VIEW efectoancash.vw_resumen_ct AS
SELECT d.ugt,
       d.ct,
       count(DISTINCT d.cod_mod)                          AS n_ie,
       count(DISTINCT p."ID_Participante")                  AS n_participantes,
       count(DISTINCT a.idacompanamiento)                 AS n_acompanamientos,
       count(DISTINCT p."ID_Participante")
         FILTER (WHERE a.idacompanamiento IS NOT NULL)    AS n_part_acompanados,
       round(100.0 * count(DISTINCT p."ID_Participante")
               FILTER (WHERE a.idacompanamiento IS NOT NULL)
             / NULLIF(count(DISTINCT p."ID_Participante"), 0), 1) AS pct_part_acompanados,
       count(DISTINCT r.fecha_renuncia::text || '|' || r.codigo_modular) AS n_renuncias
  FROM reportes.dic_ie_ugt_2026 d
  LEFT JOIN reportes.bd_participantes p
         ON p.cod_mod::text = d.cod_mod::text
  LEFT JOIN vw_acompanamientos_2026 a
         ON a.cod_mod::text = d.cod_mod::text
  LEFT JOIN vw_renuncias_2026 r
         ON r.codigo_modular::text = d.cod_mod::text
 GROUP BY d.ugt, d.ct;
CREATE OR REPLACE VIEW efectoancash.vw_resumen_programa AS
SELECT a.programa,
       count(DISTINCT a.id_participante)      AS n_participantes,
       count(DISTINCT a.cod_mod)              AS n_ie,
       count(DISTINCT a.ugt)                  AS n_ugt,
       count(DISTINCT a.idacompanamiento)     AS n_acompanamientos,
       count(DISTINCT r.fecha_renuncia::text || '|' || r.codigo_modular) AS n_renuncias
  FROM vw_acompanamientos_2026 a
  LEFT JOIN vw_renuncias_2026 r
         ON r.programa = a.programa
        AND r.codigo_modular::text = a.cod_mod::text
 GROUP BY a.programa;
CREATE OR REPLACE VIEW efectoancash.vw_resumen_formacion AS
SELECT e."Programa" AS programa,
       e."UGEL"     AS ugel,
       count(*)                                            AS n_encuestas,
       count(*) FILTER (WHERE lower(coalesce(e."Completado", ''))
                          IN ('sí','si','1','true','completado')) AS n_completadas,
       round(100.0 * count(*) FILTER (WHERE lower(coalesce(e."Completado", ''))
                          IN ('sí','si','1','true','completado'))
             / NULLIF(count(*), 0), 1)                    AS pct_completadas,
       count(*) FILTER (WHERE lower(coalesce(e."Sesgo", '')) IN ('alto','sí','si')) AS n_sesgo_alto
  FROM reportes.encuestas_enfoco_por_nucleo_master e
 GROUP BY e."Programa", e."UGEL";
CREATE OR REPLACE VIEW efectoancash.vw_resumen_jefe_territorial AS
WITH base AS (
  SELECT d.ugt,
         count(DISTINCT d.cod_mod)              AS n_ie,
         count(DISTINCT p."ID_Participante")      AS n_participantes,
         count(DISTINCT a.idacompanamiento)     AS n_acompanamientos,
         count(DISTINCT r.fecha_renuncia::text || '|' || r.codigo_modular) AS n_renuncias
    FROM reportes.dic_ie_ugt_2026 d
    LEFT JOIN reportes.bd_participantes p ON p.cod_mod::text = d.cod_mod::text
    LEFT JOIN vw_acompanamientos_2026 a   ON a.cod_mod::text = d.cod_mod::text
    LEFT JOIN vw_renuncias_2026 r         ON r.codigo_modular::text = d.cod_mod::text
   GROUP BY d.ugt
)
SELECT b.ugt,
       b.n_ie,
       b.n_participantes,
       b.n_acompanamientos,
       b.n_renuncias,
       round(100.0 * b.n_renuncias / NULLIF(b.n_participantes, 0), 1) AS pct_renuncias,
       (b.n_ie + b.n_participantes + b.n_acompanamientos) AS indice_actividad,
       CASE
         WHEN coalesce(b.n_renuncias, 0) > 5  THEN 'ALTO'
         WHEN coalesce(b.n_renuncias, 0) > 2  THEN 'MEDIO'
         ELSE 'BAJO'
       END AS semaforo_provisional
  FROM base b
 ORDER BY b.ugt;
