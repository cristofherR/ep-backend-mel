#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Genera los datos de ejemplo SINTÉTICOS del repositorio.

No usa ninguna fuente institucional: produce escuelas ficticias con el mismo
esquema que el padrón ESCALE (para probar el ETL) y un CSV de actividades de
ejemplo. Regenera:
    data/synthetic/padron_escuelas_ejemplo.csv
    data/synthetic/actividades_ejemplo.csv
"""
import csv
import os
import random

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.normpath(os.path.join(HERE, "..", "data", "synthetic"))

DEPARTAMENTO = ["Ancash"]
PROVINCIAS = ["Huaraz", "Aija", "Huari", "Carhuaz", "Yungay"]
DISTRITOS = ["Distrito1", "Distrito2", "Distrito3", "Distrito4"]
UGEL = ["UGEL Aija", "UGEL Huari", "UGEL Huaraz", "UGEL Carhuaz"]
FORMA = ["Escolarizada", "No escolarizada"]
AREA = ["Rural", "Urbana"]
GESTION = ["Pública de gestión directa", "Pública de gestión privada"]
CARACT = ["Polidocente Completo", "Multigrado", "Unidocente", "No aplica"]
DIRECTOR = ["Apellido1 Nombre1", "Apellido2 Nombre2", "Apellido3 Nombre3",
            "Apellido4 Nombre4", "Apellido5 Nombre5"]
COMPONENTES = ["PDL", "QM", "PDLD", "LECTO", "CCA", "MS", "PDLE", "ACADEMIA"]

PADRON_COLS = ["cod_mod", "anexo", "cod_local", "forma", "des_area_censo", "tipo_gestion",
               "director", "telefono", "email", "dreugel", "matricula_total", "matricula_hombres",
               "matricula_mujeres", "n_docentes", "n_secciones", "des_caracteristica",
               "es_efecto_ancash"]


def padron(n=24, seed=2026):
    rnd = random.Random(seed)
    filas = []
    for i in range(n):
        total = rnd.randint(10, 120)
        hom = rnd.randint(0, total)
        filas.append({
            "cod_mod": f"0{rnd.randint(100000, 999999)}",
            "anexo": "0",
            "cod_local": f"{rnd.randint(10000, 99999)}",
            "forma": rnd.choice(FORMA),
            "des_area_censo": rnd.choice(AREA),
            "tipo_gestion": rnd.choice(GESTION),
            "director": rnd.choice(DIRECTOR),
            "telefono": "",          # sin teléfonos: son datos personales
            "email": "",             # sin correos: son datos personales
            "dreugel": rnd.choice(UGEL),
            "matricula_total": total,
            "matricula_hombres": hom,
            "matricula_mujeres": total - hom,
            "n_docentes": rnd.randint(1, 8),
            "n_secciones": rnd.randint(1, 6),
            "des_caracteristica": rnd.choice(CARACT),
            "es_efecto_ancash": rnd.choice([0, 1]),
        })
    return filas


def actividades(n=12, seed=7):
    rnd = random.Random(seed)
    filas = []
    for i in range(n):
        filas.append({
            "codigo": f"EJ-{i+1:03d}",
            "componente": rnd.choice(COMPONENTES),
            "ugt": f"UGT {rnd.choice(['Mina','Huarmey','Huallanca','San Marcos'])}",
            "periodo": f"2026-T{rnd.randint(1,4)}",
            "estado": rnd.choice(["programado", "ejecutado", "reprogramado", "cancelado"]),
            "fecha_programada": f"2026-{rnd.randint(1,12):02d}-{rnd.randint(1,28):02d}",
        })
    return filas


def main():
    os.makedirs(OUT, exist_ok=True)
    p = os.path.join(OUT, "padron_escuelas_ejemplo.csv")
    with open(p, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=PADRON_COLS)
        w.writeheader()
        w.writerows(padron())
    a = os.path.join(OUT, "actividades_ejemplo.csv")
    with open(a, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=["codigo", "componente", "ugt", "periodo", "estado", "fecha_programada"])
        w.writeheader()
        w.writerows(actividades())
    print("generado:", os.path.relpath(p, os.path.dirname(HERE)))
    print("generado:", os.path.relpath(a, os.path.dirname(HERE)))


if __name__ == "__main__":
    main()
