#!/usr/bin/env python3
"""gen_seed_app.py — genera seed/040_app_seed.sql (catálogos + UGT + componentes + IE).

Idempotente. Fuentes:
  - UGT/componentes: catálogos oficiales del proyecto EA (fijos).
  - IE: out/padron_core_ie.csv (padrón ESCALE, 4 983 filas).
"""
import csv
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "seed", "040_app_seed.sql")
IE_CSV = os.path.abspath(os.path.join(HERE, "out", "padron_core_ie.csv"))
S = "efectoancash"

UGTS = [
    ("UGT-MINA", "UGT Mina", "#2b5f96"),
    ("UGT-HUARMEY", "UGT Huarmey", "#0e7c70"),
    ("UGT-VALLEDF", "UGT Valle Fortaleza", "#6b3293"),
    ("UGT-HUALLANCA", "UGT Huallanca", "#c05000"),
    ("UGT-SANMARCOS", "UGT San Marcos", "#8a5000"),
]

COMPONENTES = [
    ("PDL", "Programa de Liderazgo", "#2b5f96"),
    ("QM", "Qué Maestro", "#0e7c70"),
    ("PDLD", "Programa de Liderazgo para Directivos", "#6b3293"),
    ("LECTO", "Formación docente en Lectoescritura", "#c05000"),
]

CATALOGOS = {
    "ESTADO_ACTIVIDAD": [
        ("programado", "Programado", "#0077a8", 1),
        ("ejecutado", "Ejecutado", "#437a22", 2),
        ("reprogramado", "Reprogramado", "#5c3d8f", 3),
        ("postergado", "Postergado", "#8a6500", 4),
        ("cancelado", "Cancelado", "#c0392b", 5),
        ("cerrado", "Cerrado", "#5c6670", 6),
    ],
    "NIVEL_SEMAFORO": [
        ("verde", "Verde", "#2e6b1a", 1),
        ("ambar", "Ámbar", "#8a6500", 2),
        ("rojo", "Rojo", "#b3261e", 3),
    ],
    "TIPO_INCIDENCIA": [
        ("incidencia", "Incidencia", "#b3261e", 1),
        ("alerta", "Alerta", "#c05000", 2),
    ],
}


def q(s):
    if s is None or s == "":
        return "null"
    return "'" + str(s).replace("'", "''") + "'"


def num(s):
    try:
        f = float(s)
        return str(f)
    except (TypeError, ValueError):
        return "null"


def main():
    lines = [
        "-- 040_app_seed.sql — catálogos + UGT + componentes + IE (padrón ESCALE)",
        "-- Generado por gen_seed_app.py · idempotente · schema " + S,
        "begin;",
        "",
        "-- 1) catálogos",
    ]
    for dom, nombre in [("ESTADO_ACTIVIDAD", "Estado de actividad"),
                        ("NIVEL_SEMAFORO", "Nivel de semáforo"),
                        ("TIPO_INCIDENCIA", "Tipo de incidencia/alerta")]:
        lines.append(
            f"insert into {S}.core_catalogo (dominio, nombre) values ({q(dom)},{q(nombre)})"
            f" on conflict (dominio) do nothing;")
    lines.append("")
    for dom, items in CATALOGOS.items():
        for cod, et, col, orden in items:
            lines.append(
                f"insert into {S}.core_catalogo_item (catalogo_id, codigo, etiqueta, color_hex, orden)"
                f" select c.id, {q(cod)}, {q(et)}, {q(col)}, {orden} from {S}.core_catalogo c"
                f" where c.dominio = {q(dom)}"
                f" and not exists (select 1 from {S}.core_catalogo_item i where i.catalogo_id=c.id and i.codigo={q(cod)});")
    lines += ["", "-- 2) UGT"]
    for cod, nom, col in UGTS:
        lines.append(
            f"insert into {S}.core_ugt (codigo, nombre, color_hex) values ({q(cod)},{q(nom)},{q(col)})"
            f" on conflict (codigo) do update set nombre = excluded.nombre, color_hex = excluded.color_hex;")
    lines += ["", "-- 3) componentes (espejo de los programas)"]
    for cod, nom, col in COMPONENTES:
        lines.append(
            f"insert into {S}.core_componente (codigo, nombre, color_hex, proyecto_id, activo)"
            f" select {q(cod)}, {q(nom)}, {q(col)}, p.id, true from {S}.core_proyecto p"
            f" where p.codigo = {q(cod)}"
            f" and not exists (select 1 from {S}.core_componente c where c.codigo = {q(cod)});")

    lines += ["", "-- 4) IE del padrón (core_ie)"]
    n = 0
    if os.path.exists(IE_CSV):
        with open(IE_CSV, newline="", encoding="utf-8") as fh:
            rd = csv.DictReader(fh)
            for r in rd:
                cod_mod = (r.get("cod_mod") or "").strip()
                if not cod_mod:
                    continue
                ugt = (r.get("ugt") or "").strip()
                ugt = ugt if ugt.startswith("UGT ") else None
                lines.append(
                    "insert into {S}.core_ie (cod_mod, cod_inst, cod_unico, nombre, niv_mod, nivel, ugt_id,"
                    " provincia, distrito, cen_poblado, lat, lon) values ({a},{b},{c},{d},{e},{f},"
                    "(select id from {S}.core_ugt where nombre={g}),{h},{i},{j},{k},{l})"
                    " on conflict do nothing;".format(
                        S=S, a=q(cod_mod), b=q(r.get("cod_inst") or cod_mod), c=q(r.get("cod_unico") or cod_mod),
                        d=q(r.get("nombre") or cod_mod), e=q(r.get("niv_mod")), f=q(r.get("nivel")),
                        g=q(ugt), h=q(r.get("provincia")), i=q(r.get("distrito")),
                        j=q(r.get("cen_poblado")), k=num(r.get("lat")), l=num(r.get("lon"))))
                n += 1
    lines += ["", "commit;", f"-- IE cargadas: {n}"]
    with open(OUT, "w", encoding="utf-8") as fh:
        fh.write("\n".join(lines) + "\n")
    print(f"OK -> {OUT}  ({n} IE, {len(lines)} lineas)")


if __name__ == "__main__":
    main()
