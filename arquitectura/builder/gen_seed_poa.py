#!/usr/bin/env python3
"""gen_seed_poa.py — POA 2026 REAL del programa Efecto Áncash.

Fuente: `el-prototipo/POA_2026.xlsx` (hoja "query (10)", export de la
lista EA_POA de SharePoint). 18 filas, una por actividad programada del T2-2026.

Modelo (decisión D-018, "Opción B"):
  * `ActividadGrande`  -> `prog_poa_actividad_grande` (la actividad del POA)
  * cada fila          -> `prog_actividad_pequena`    (lo que se ejecuta y reporta)

Salida: `seed/050_poa_seed.sql` (idempotente: TODO lleva `where not exists`).
"""
import os
import openpyxl

HERE = os.path.dirname(os.path.abspath(__file__))
XLSX = os.path.join(HERE, "..", "..", "fuentes", "programacion", "POA_2026.xlsx")
OUT = os.path.join(HERE, "seed", "050_poa_seed.sql")

# Cod_Componente del POA -> código de core_componente
COMP_MAP = {
    "PROG-1": "PDL", "PROG-2": "QM", "PROG-3": "PDLD", "PROG-4": "LECTO",
    "PROG-5": "CCA", "PROG-6": "MS", "PROG-7": "PDLE", "PROG-8": "AJ",
    "ECO-1": "ECO", "ECO-2": "ECO", "ECO-3": "ECO",
}
# componentes nuevos (no existían en core_componente)
COMP_NEW = {
    "CCA": ("CCA — Primera infancia", "#b3261e"),
    "MS": ("Mente Sana", "#8a5000"),
    "PDLE": ("PDLE — Liderazgo estudiantil", "#5c3d8f"),
    "AJ": ("Academia Juvenil", "#0077a8"),
    "ECO": ("Ecosistema y gestión territorial", "#5c6670"),
}
# UGT del POA -> codigo de core_ugt  (Huaripampa pertenece a UGT Mina)
UGT_MAP = {
    "UGT San Marcos": "UGT-SANMARCOS", "UGT Huarmey": "UGT-HUARMEY",
    "UGT Mina": "UGT-MINA", "UGT Valle Fortaleza": "UGT-VALLEDF",
    "Huaripampa": "UGT-MINA",
}
MESES = {"Enero": 1, "Febrero": 2, "Marzo": 3, "Abril": 4, "Mayo": 5, "Junio": 6,
         "Julio": 7, "Agosto": 8, "Septiembre": 9, "Octubre": 10,
         "Noviembre": 11, "Diciembre": 12}
S = "efectoancash."


def q(v):
    if v is None:
        return "null"
    return "'" + str(v).replace("'", "''") + "'"


def resp_sql(resp):
    """responsable_id -> core_usuario.id (el nombre vive en core_persona)."""
    if not resp:
        return "null"
    return (f"(select u.id from {S}core_usuario u join {S}core_persona p on p.id = u.persona_id"
            f" where (p.nombres || ' ' || p.apellidos) = {q(resp)} limit 1)")


def main():
    ws = openpyxl.load_workbook(XLSX, data_only=True).worksheets[0]
    rows = list(ws.iter_rows(values_only=True))
    hdr = [str(h).strip() for h in rows[0]]
    data = [dict(zip(hdr, r)) for r in rows[1:] if any(r)]

    L = []
    L.append("-- POA 2026 REAL · generado por gen_seed_poa.py desde POA_2026.xlsx")
    L.append("-- Idempotente (where not exists). NO borra nada.")
    L.append("begin;")

    # 1) componentes faltantes
    for cod, (nom, col) in COMP_NEW.items():
        L.append(f"insert into {S}core_componente (codigo, nombre, color_hex, activo)\n"
                 f"select {q(cod)}, {q(nom)}, {q(col)}, true\n"
                 f"where not exists (select 1 from {S}core_componente where codigo={q(cod)});")

    # 2) actividades grandes del POA (una por ActividadGrande)
    grandes = {}
    for d in data:
        grandes.setdefault(str(d["ActividadGrande"]).strip(), d)
    for nombre, d in grandes.items():
        comp = COMP_MAP.get(str(d["Cod_Componente"]).strip())
        ugt_txt = str(d["UGT"]).strip()
        ugt = UGT_MAP.get(ugt_txt)
        ct = ("(select id from " + S + "core_ct where nombre like 'UGT Mina (Huaripampa%' limit 1)"
              if ugt_txt == "Huaripampa" else "null")
        if ugt == "UGT-MINA" and ugt_txt == "Huaripampa":
            pass
        alcance = "region" if ugt_txt == "Region" else ("ugt" if ugt else "programa")
        resp = str(d["Responsable"]).strip() if d["Responsable"] else None
        r = resp_sql(resp)
        L.append(
            f"insert into {S}prog_poa_actividad_grande\n"
            f" (anio, componente_id, ugt_id, ct_id, alcance_macro, nombre, meta, responsable_id,\n"
            f"  actor_externo, estado_id, visibilidad, creado_por, creado_en)\n"
            f"select 2026,\n"
            f" (select id from {S}core_componente where codigo={q(comp)} limit 1),\n"
            f" (select id from {S}core_ugt where codigo={q(ugt)} limit 1),\n"
            f" {ct},\n"
            f" {q(alcance)}, {q(nombre)}, {q(d['KRTrimestral'])}, {r},\n"
            f" {q(d['ActorExterno'])},\n"
            f" (select i.id from {S}core_catalogo_item i join {S}core_catalogo c on c.id=i.catalogo_id\n"
            f"   where c.dominio='ESTADO_ACTIVIDAD' and i.etiqueta={q(d['Estado'])} limit 1),\n"
            f" 'todos',\n"
            f" (select id from {S}core_usuario order by id limit 1), now()\n"
            f"where not exists (select 1 from {S}prog_poa_actividad_grande\n"
            f"  where anio=2026 and nombre={q(nombre)});")

    # 3) actividades específicas (cada fila del POA)
    for d in data:
        grande = str(d["ActividadGrande"]).strip()
        titulo = str(d["Título"]).strip()
        mes = MESES.get(str(d["MesProgramado"]).strip(), 1)
        fecha = f"{int(d['Anio'])}-{mes:02d}-01"
        ugt_txt = str(d["UGT"]).strip()
        cp = "Huaripampa" if ugt_txt == "Huaripampa" else None
        resp = str(d["Responsable"]).strip() if d["Responsable"] else None
        r = resp_sql(resp)
        esp = (f"{titulo} — {d['Trimestre']} · {d['MesProgramado']} {int(d['Anio'])}"
               f" · KR: {d['KRTrimestral']} · Actor: {d['ActorExterno']}")
        L.append(
            f"insert into {S}prog_actividad_pequena\n"
            f" (act_grande_id, centro_poblado, nivel, especifico, responsable_id,\n"
            f"  fecha_programada, estado_id)\n"
            f"select\n"
            f" (select id from {S}prog_poa_actividad_grande where anio=2026 and nombre={q(grande)} limit 1),\n"
            f" {q(cp)}, null, {q(esp)}, {r}, {q(fecha)},\n"
            f" (select i.id from {S}core_catalogo_item i join {S}core_catalogo c on c.id=i.catalogo_id\n"
            f"   where c.dominio='ESTADO_ACTIVIDAD' and i.etiqueta={q(d['Estado'])} limit 1)\n"
            f"where not exists (\n"
            f"  select 1 from {S}prog_actividad_pequena p\n"
            f"  join {S}prog_poa_actividad_grande g on g.id = p.act_grande_id\n"
            f"  where g.anio=2026 and g.nombre={q(grande)} and p.especifico like {q(titulo + ' —%')});")

    L.append("commit;")
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w", encoding="utf-8") as f:
        f.write("\n".join(L) + "\n")
    print(f"OK  seed/050_poa_seed.sql  ({len(grandes)} actividades del POA, {len(data)} específicas)")


if __name__ == "__main__":
    main()
