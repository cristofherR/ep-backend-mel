#!/usr/bin/env python3
"""gen_roles.py — genera el seed de roles/alcance (Postgres, schema efectoancash)
a partir de el-prototipo/_privado/usuarios_seed.csv (lista oficial AGT/MEL).

Salidas:
  - seed/020_roles_seed.sql      (idempotente: core_rol, core_proyecto(programas),
                                  core_persona, core_usuario, core_ct, core_usuario_alcance)
  - ../el-prototipo/roles_alcance.csv   (revisión legible)

Regla confirmada por Cristofher (15-sep-2026):
  * 1 rol por usuario; N alcances por UGT.
  * Roles: admin_mel, jefe_territorial, ct, programa, formacion, comunicaciones.
  * UGT "Territorio" = macro (sin fila de alcance).
  * UGT Mina -> 2 CT: CT1 (cuenca) y CT2 (Huaripampa + Carhuayoc).
"""
import csv, os

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "..", "..", "fuentes", "programacion", "_privado", "usuarios_seed.csv")
OUT_SQL = os.path.join(HERE, "seed", "020_roles_seed.sql")
OUT_CSV = os.path.join(HERE, "..", "..", "fuentes", "programacion", "roles_alcance.csv")

# rol_fino por Cargo
def rol_fino(cargo):
    c = cargo.strip().lower()
    if c == "admin mel": return "admin_mel"
    if c == "jefe territorial": return "jefe_territorial"
    if c == "coordinador territorial": return "ct"
    if c.startswith("coord. programa") or c == "tutor lectoescritura": return "programa"
    if c == "coord. formacion": return "formacion"
    if c == "comunicaciones": return "comunicaciones"
    return "programa"

ES_MACRO = {"admin_mel": 1, "jefe_territorial": 1, "comunicaciones": 1}

PROG_COD = {"PDL": "PDL", "QM": "QM", "PDLD": "PDLD", "Lectoescritura": "LECTO"}

CT_NOMBRE = {
    "ct2@example.org": "UGT Mina (Huaripampa + Carhuayoc)",
    "ct1@example.org": "UGT Mina (cuenca)",
}

q = lambda s: "'" + s.replace("'", "''") + "'"

rows = []
with open(SRC, newline="", encoding="utf-8") as fh:
    for r in csv.DictReader(fh):
        nombre = r["NombreCompleto"].strip()
        parts = nombre.split()
        nom, ap = parts[0], " ".join(parts[1:])
        rf = rol_fino(r["Rol"])
        ugt_raw = r.get("UGT", "").strip()
        # alcance = UGTs reales (se excluye el valor macro "Territorio")
        ugts = [u.strip() for u in ugt_raw.split(";#") if u.strip() and u.strip() != "Territorio"]
        # macro: roles macro o "Territorio"; formacion es territorial con UGTs aún por definir
        macro = ES_MACRO.get(rf, 0) == 1 or (ugt_raw == "Territorio" and rf != "formacion")
        prog = PROG_COD.get(r.get("Programa", "").strip())
        rows.append(dict(nombre=nombre, nom=nom, ap=ap, email=r["Email"].strip(),
                         rf=rf, cargo=r["Rol"].strip(), macro=macro, ugts=ugts,
                         prog=prog, tel=(r.get("Telefono") or "").strip(),
                         activo=int(r.get("Activo") or 1)))

# ---- roles ----
roles = [
    ("admin_mel", "Admin MEL", 1),
    ("jefe_territorial", "Jefe Territorial", 1),
    ("ct", "Coordinador Territorial", 0),
    ("programa", "Coordinador / Tutor de Programa", 0),
    ("formacion", "Formación", 0),
    ("comunicaciones", "Comunicaciones", 1),
]
# ---- proyectos tipo programa ----
progs = [("PDL", "Programa de Liderazgo"), ("QM", "Qué Maestro"),
         ("PDLD", "Programa de Liderazgo para Directivos"),
         ("LECTO", "Formación docente en Lectoescritura")]

L = []
L.append("/* 020_roles_seed.sql — roles/alcance (Postgres, schema efectoancash)")
L.append("   Generado por gen_roles.py · 1 rol por usuario, N alcances por UGT.")
L.append("   Idempotente. Correr DESPUÉS de 000_core.sql. */")
L.append("SET search_path TO efectoancash, public;")
L.append("")
L.append("-- Roles de acceso")
L.append("INSERT INTO efectoancash.core_rol (codigo, nombre, es_macro) VALUES")
L.append(",\n".join("(%s,%s,%s)" % (q(c), q(n), "true" if m else "false") for c, n, m in roles))
L.append("ON CONFLICT (codigo) DO NOTHING;")
L.append("")
L.append("-- Programas (tipo='programa')")
L.append("INSERT INTO efectoancash.core_proyecto (codigo, nombre, tipo) VALUES")
L.append(",\n".join("(%s,%s,'programa')" % (q(c), q(n)) for c, n in progs))
L.append("ON CONFLICT (codigo) DO NOTHING;")
L.append("")
L.append("-- Personas")
L.append("INSERT INTO efectoancash.core_persona (apellidos, nombres, telefono)")
L.append("SELECT v.ap, v.nom, NULLIF(v.tel,'')")
L.append("FROM (VALUES")
L.append(",\n".join("(%s,%s,%s)" % (q(r['ap']), q(r['nom']), q(r['tel'])) for r in rows))
L.append(") AS v(ap, nom, tel)")
L.append("WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_persona p")
L.append("   WHERE coalesce(p.apellidos,'')=v.ap AND coalesce(p.nombres,'')=v.nom);")
L.append("")
L.append("-- Usuarios (rol fino por email)")
L.append("INSERT INTO efectoancash.core_usuario (persona_id, email, rol_id, hash_clave, activo)")
L.append("SELECT p.id, v.email, r.id, 'demo:demo', v.act")
L.append("FROM (VALUES")
L.append(",\n".join("(%s,%s,%s,%s,%s)" % (q(r['ap']), q(r['nom']), q(r['email']), q(r['rf']), "true" if r['activo'] else "false") for r in rows))
L.append(") AS v(ap, nom, email, rolcod, act)")
L.append("JOIN efectoancash.core_persona p ON p.apellidos=v.ap AND p.nombres=v.nom")
L.append("JOIN efectoancash.core_rol r ON r.codigo=v.rolcod")
L.append("WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_usuario u WHERE u.email=v.email);")
L.append("")
L.append("-- CT (entidad propia; UGT Mina tiene 2)")
ctrows = [(r['ap'], r['nom'], CT_NOMBRE[r['email']], r['ugts'][0] if r['ugts'] else None)
          for r in rows if r['email'] in CT_NOMBRE]
L.append("INSERT INTO efectoancash.core_ct (persona_id, nombre, ugt_id)")
L.append("SELECT p.id, v.cn, g.id")
L.append("FROM (VALUES")
L.append(",\n".join("(%s,%s,%s,%s)" % (q(a), q(n), q(cn), q(u)) for a, n, cn, u in ctrows))
L.append(") AS v(ap, nom, cn, ugt)")
L.append("JOIN efectoancash.core_persona p ON p.apellidos=v.ap AND p.nombres=v.nom")
L.append("LEFT JOIN efectoancash.core_ugt g ON g.nombre=v.ugt")
L.append("WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_ct c WHERE c.nombre=v.cn);")
L.append("")
L.append("-- Alcance (usuario x UGT x programa; ct para el caso UGT Mina)")
alc = []
for r in rows:
    if r['macro'] or not r['ugts']:
        continue
    cn = CT_NOMBRE.get(r['email'])
    for u in r['ugts']:
        alc.append((r['email'], u, cn, r['prog']))
L.append("INSERT INTO efectoancash.core_usuario_alcance (usuario_id, ugt_id, ct_id, programa_id)")
L.append("SELECT u.id, g.id, c.id, pr.id")
L.append("FROM (VALUES")
L.append(",\n".join("(%s,%s,%s,%s)" % (q(e), q(u), q(c) if c else "NULL", q(p) if p else "NULL")
                    for e, u, c, p in alc))
L.append(") AS v(email, ugt, ct, prog)")
L.append("JOIN efectoancash.core_usuario u ON u.email=v.email")
L.append("LEFT JOIN efectoancash.core_ugt g ON g.nombre=v.ugt")
L.append("LEFT JOIN efectoancash.core_ct c ON c.nombre=v.ct")
L.append("LEFT JOIN efectoancash.core_proyecto pr ON pr.codigo=v.prog")
L.append("WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_usuario_alcance a")
L.append("   WHERE a.usuario_id=u.id AND coalesce(a.ugt_id,-1)=coalesce(g.id,-1)"
        " AND coalesce(a.programa_id,-1)=coalesce(pr.id,-1));")
L.append("")

os.makedirs(os.path.dirname(OUT_SQL), exist_ok=True)
with open(OUT_SQL, "w", encoding="utf-8") as fh:
    fh.write("\n".join(L))

with open(OUT_CSV, "w", newline="", encoding="utf-8") as fh:
    w = csv.writer(fh)
    w.writerow(["NombreCompleto", "Email", "Cargo", "Rol_fino", "Es_macro", "UGTs", "Programa"])
    for r in rows:
        w.writerow([r['nombre'], r['email'], r['cargo'], r['rf'],
                    "1" if r['macro'] else "0", "|".join(r['ugts']),
                    r['prog'] or ""])

print("OK · roles=%d · usuarios=%d · alcances=%d · CT=%d" % (len(roles), len(rows), len(alc), len(ctrows)))
print(" ->", OUT_SQL)
print(" ->", OUT_CSV)
