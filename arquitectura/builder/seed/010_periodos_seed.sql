/* 010_periodos_seed.sql — cortes de core_periodo (Efecto Áncash MEL)
   Generado por gen_periodos.py · anualidades 2026–2027.
   Un corte por mes y por trimestre (fecha_corte = fin de periodo).
   Idempotente. PostgreSQL · schema efectoancash. */
SET search_path TO efectoancash, public;

-- ===== 2026 =====
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2026, NULL, 1, DATE '2026-03-31'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2026 AND trimestre = 1 AND mes IS NULL AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2026, NULL, 2, DATE '2026-06-30'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2026 AND trimestre = 2 AND mes IS NULL AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2026, NULL, 3, DATE '2026-09-30'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2026 AND trimestre = 3 AND mes IS NULL AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2026, NULL, 4, DATE '2026-12-31'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2026 AND trimestre = 4 AND mes IS NULL AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2026, 1, 1, DATE '2026-01-31'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2026 AND trimestre = 1 AND mes = 1 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2026, 2, 1, DATE '2026-02-28'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2026 AND trimestre = 1 AND mes = 2 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2026, 3, 1, DATE '2026-03-31'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2026 AND trimestre = 1 AND mes = 3 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2026, 4, 2, DATE '2026-04-30'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2026 AND trimestre = 2 AND mes = 4 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2026, 5, 2, DATE '2026-05-31'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2026 AND trimestre = 2 AND mes = 5 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2026, 6, 2, DATE '2026-06-30'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2026 AND trimestre = 2 AND mes = 6 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2026, 7, 3, DATE '2026-07-31'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2026 AND trimestre = 3 AND mes = 7 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2026, 8, 3, DATE '2026-08-31'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2026 AND trimestre = 3 AND mes = 8 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2026, 9, 3, DATE '2026-09-30'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2026 AND trimestre = 3 AND mes = 9 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2026, 10, 4, DATE '2026-10-31'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2026 AND trimestre = 4 AND mes = 10 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2026, 11, 4, DATE '2026-11-30'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2026 AND trimestre = 4 AND mes = 11 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2026, 12, 4, DATE '2026-12-31'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2026 AND trimestre = 4 AND mes = 12 AND quincena IS NULL AND semana IS NULL);
-- ===== 2027 =====
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2027, NULL, 1, DATE '2027-03-31'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2027 AND trimestre = 1 AND mes IS NULL AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2027, NULL, 2, DATE '2027-06-30'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2027 AND trimestre = 2 AND mes IS NULL AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2027, NULL, 3, DATE '2027-09-30'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2027 AND trimestre = 3 AND mes IS NULL AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2027, NULL, 4, DATE '2027-12-31'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2027 AND trimestre = 4 AND mes IS NULL AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2027, 1, 1, DATE '2027-01-31'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2027 AND trimestre = 1 AND mes = 1 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2027, 2, 1, DATE '2027-02-28'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2027 AND trimestre = 1 AND mes = 2 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2027, 3, 1, DATE '2027-03-31'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2027 AND trimestre = 1 AND mes = 3 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2027, 4, 2, DATE '2027-04-30'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2027 AND trimestre = 2 AND mes = 4 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2027, 5, 2, DATE '2027-05-31'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2027 AND trimestre = 2 AND mes = 5 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2027, 6, 2, DATE '2027-06-30'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2027 AND trimestre = 2 AND mes = 6 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2027, 7, 3, DATE '2027-07-31'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2027 AND trimestre = 3 AND mes = 7 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2027, 8, 3, DATE '2027-08-31'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2027 AND trimestre = 3 AND mes = 8 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2027, 9, 3, DATE '2027-09-30'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2027 AND trimestre = 3 AND mes = 9 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2027, 10, 4, DATE '2027-10-31'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2027 AND trimestre = 4 AND mes = 10 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2027, 11, 4, DATE '2027-11-30'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2027 AND trimestre = 4 AND mes = 11 AND quincena IS NULL AND semana IS NULL);
INSERT INTO efectoancash.core_periodo (anio, mes, trimestre, fecha_corte)
SELECT 2027, 12, 4, DATE '2027-12-31'
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_periodo WHERE anio = 2027 AND trimestre = 4 AND mes = 12 AND quincena IS NULL AND semana IS NULL);
