#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""gen_periodos.py — Seed de core_periodo (anualidades 2026–2027).

Genera un corte por MES y por TRIMESTRE, con fecha_corte = último día del periodo.
Idempotente (WHERE NOT EXISTS). Salida PostgreSQL (schema `efectoancash`).

Uso: python3 gen_periodos.py
"""
import calendar
import os

ROOT = os.path.dirname(os.path.abspath(__file__))
SCHEMA = "efectoancash"
OUT = os.path.join(ROOT, "seed")
YEARS = (2026, 2027)


def last_day(y, m):
    return "%04d-%02d-%02d" % (y, m, calendar.monthrange(y, m)[1])


def trim_of(m):
    return (m - 1) // 3 + 1


def insert(anio, mes, trimestre, fecha_corte):
    cond = ["anio = %d" % anio, "trimestre = %d" % trimestre]
    cond.append("mes IS NULL" if mes is None else "mes = %d" % mes)
    cond.append("quincena IS NULL")
    cond.append("semana IS NULL")
    return (
        "INSERT INTO {s}.core_periodo (anio, mes, trimestre, fecha_corte)\n"
        "SELECT {anio}, {mes}, {tri}, DATE '{fc}'\n"
        "WHERE NOT EXISTS (SELECT 1 FROM {s}.core_periodo WHERE {cond});"
    ).format(
        s=SCHEMA, anio=anio,
        mes="NULL" if mes is None else mes,
        tri=trimestre, fc=fecha_corte, cond=" AND ".join(cond),
    )


def main():
    os.makedirs(OUT, exist_ok=True)
    blocks = [
        "/* 010_periodos_seed.sql — cortes de core_periodo (Efecto Áncash MEL)",
        "   Generado por gen_periodos.py · anualidades 2026–2027.",
        "   Un corte por mes y por trimestre (fecha_corte = fin de periodo).",
        "   Idempotente. PostgreSQL · schema %s. */" % SCHEMA,
        "SET search_path TO %s, public;\n" % SCHEMA,
    ]
    n = 0
    for y in YEARS:
        blocks.append("-- ===== %d =====" % y)
        for t in range(1, 5):
            blocks.append(insert(y, None, t, last_day(y, t * 3)))
            n += 1
        for m in range(1, 13):
            blocks.append(insert(y, m, trim_of(m), last_day(y, m)))
            n += 1
    path = os.path.join(OUT, "010_periodos_seed.sql")
    with open(path, "w", encoding="utf-8") as fh:
        fh.write("\n".join(blocks) + "\n")
    print("OK · %d periodos (mes+trimestre) 2026-2027 -> %s" % (n, path))


if __name__ == "__main__":
    main()
