#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""etl_padron.py — ETL del padrón ESCALE a las capas del schema MEL.

Lee `padron_escuelas.xlsx` (4 983 filas x 69 col) y genera CSVs listos para cargar
en las tablas pad_* / core_ie del schema generado por build.py.

Salida (../arquitectura/builder/out/):
  padron_core_ie.csv      -> core_ie     (escuela x nivel)
  padron_escuela.csv      -> pad_escuela (detalle ESCALE)
  padron_componente.csv   -> pad_escuela_componente (membresías)
Uso: python3 etl_padron.py
"""
import csv, os, unicodedata
import openpyxl

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.normpath(os.path.join(HERE, "..", "..", "arquitectura", "builder", "out"))
XLSX = os.path.join(HERE, "padron_escuelas.xlsx")

# col ESCALE -> componente del catálogo PROG-x
COMP = {"PDL": "PROG-1", "QM": "PROG-2", "PDLD": "PROG-3", "LECTO": "PROG-4",
        "CCA": "PROG-5", "MS": "PROG-6", "PDLE": "PROG-7", "ACADEMIA": "PROG-8"}

# --- Reparación de mojibake del ESCALE -------------------------------------
# El xlsx viene con texto pasado por codificaciones DOS. Se detectan DOS cadenas
# distintas (algunas celdas mezclan ambas):
#   1) pares "├X" / "┴ü" / "═ì": UTF-8 leído como CP437  -> reverso directo
#   2) glifos sueltos (·, ±, ¾, Ð, ┴, Ë, ═, Ú, ┌, ╔): byte CP1252 leído como CP850
# Mapeo por par (mayor longitud primero) y por carácter suelto:
FIX_PAIRS = [("┴ü", "Á"), ("═ì", "Í"), ("├ü", "Á"), ("├ì", "Í"), ("├ô", "Ó"),
             ("├æ", "Ñ"), ("├ë", "É"), ("├Ü", "Ú"), ("├£", "Ü")]
FIX_SINGLE = {"¾": "ó", "±": "ñ", "·": "ú", "Ð": "Ñ", "┴": "Á", "Ë": "Ó",
              "═": "Í", "Ú": "é", "┌": "Ú", "╔": "É"}
# glifos que NO deben quedar tras reparar (Ú/Ü sí son válidos -> quedan fuera)
WEIRD = set("·±¾Ð┴├Ëüìôæë═£┌╔")

def fix_mojibake(s):
    """Repara el texto mal codificado del ESCALE (P·blica -> Pública, Ma±ana -> Mañana)."""
    if not isinstance(s, str):
        return s
    for a, b in FIX_PAIRS:
        s = s.replace(a, b)
    for a, b in FIX_SINGLE.items():
        s = s.replace(a, b)
    return s.strip()

def norm(s):
    if s is None:
        return None
    s = fix_mojibake(str(s))
    return s if s not in ("", "None") else None

def main():
    wb = openpyxl.load_workbook(XLSX, read_only=True, data_only=True)
    ws = wb["Hoja1"]
    it = ws.iter_rows(values_only=True)
    hdr = [str(h).strip() for h in next(it)]
    ix = {h: i for i, h in enumerate(hdr)}
    def g(r, *names):
        for n in names:
            if n in ix:
                v = r[ix[n]]
                if v not in (None, ""):
                    return norm(v)
        return None

    os.makedirs(OUT, exist_ok=True)
    f_ie = open(os.path.join(OUT, "padron_core_ie.csv"), "w", newline="", encoding="utf-8")
    f_es = open(os.path.join(OUT, "padron_escuela.csv"), "w", newline="", encoding="utf-8")
    f_co = open(os.path.join(OUT, "padron_componente.csv"), "w", newline="", encoding="utf-8")
    w_ie = csv.writer(f_ie); w_es = csv.writer(f_es); w_co = csv.writer(f_co)
    w_ie.writerow(["cod_mod", "cod_inst", "cod_unico", "nombre", "niv_mod", "nivel",
                   "ugt", "provincia", "distrito", "cen_poblado", "lat", "lon"])
    w_es.writerow(["cod_mod", "anexo", "cod_local", "forma", "des_area_censo", "tipo_gestion",
                   "director", "telefono", "email", "dreugel", "matricula_total",
                   "matricula_hombres", "matricula_mujeres", "n_docentes", "n_secciones",
                   "des_caracteristica", "es_efecto_ancash"])
    w_co.writerow(["cod_mod", "componente", "marca"])

    n_ie = n_comp = 0
    leftover = []  # celdas que aún queden con glifos corruptos
    for r in it:
        for v in r:
            fv = fix_mojibake(v) if isinstance(v, str) else v
            if isinstance(fv, str) and any(c in WEIRD for c in fv):
                leftover.append(fv)
        cod_mod = g(r, "COD_MOD")
        cod_inst = g(r, "CODINST")
        niv = g(r, "NIV_MOD")
        if not cod_mod:
            continue
        w_ie.writerow([cod_mod, cod_inst, f"{cod_inst}-{niv}", g(r, "CEN_EDU"), niv,
                       g(r, "D_NIV_MOD"), g(r, "UGT"), g(r, "D_PROV"), g(r, "D_DIST"),
                       g(r, "CEN_POB"), g(r, "NLAT_IE"), g(r, "NLONG_IE")])
        n_ie += 1
        w_es.writerow([cod_mod, g(r, "ANEXO"), g(r, "CODLOCAL"), g(r, "D_FORMA"),
                       g(r, "DAREACENSO"), g(r, "D_GESTION"), g(r, "DIRECTOR"), g(r, "TELEFONO"),
                       g(r, "EMAIL"), g(r, "D_DREUGEL"), g(r, "TALUM"), g(r, "TALUM_HOM"),
                       g(r, "TALUM_MUJ"), g(r, "TDOC"), g(r, "TSEC"), g(r, "D_COD_CAR"),
                       1 if g(r, "EA") else 0])
        for col, comp in COMP.items():
            m = g(r, col)
            if m:
                w_co.writerow([cod_mod, comp, m]); n_comp += 1
    for f in (f_ie, f_es, f_co):
        f.close()
    print(f"OK · core_ie={n_ie} · pad_escuela={n_ie} · membresías componente={n_comp}")
    print(f"   celdas con mojibake sin reparar: {len(leftover)}")
    for v in leftover[:10]:
        print("   !", repr(v))
    print("   ->", OUT)

if __name__ == "__main__":
    main()
