#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""gen_ui.py — genera seed de configuración de interfaz (PostgreSQL, schema efectoancash).

Emite `seed/030_ui_seed.sql` (idempotente): idioma, tema + tokens de diseño,
diccionario de textos (labels/títulos), vistas, bloques y elementos del PWA.

Todo es DATO: editar textos, mover/fijar bloques o cambiar tipografía = re-ejecutar
este generador. No se toca código de front.
"""
import os

SCHEMA = "efectoancash"
HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "seed", "030_ui_seed.sql")

# ---------------- datos ----------------
IDIOMAS = [("es", "Español")]

# token, valor, tipo, grupo, nota
TOKENS = [
    ("--fuente-base",   "Inter, system-ui, -apple-system, Segoe UI, sans-serif", "font",    "tipografia", "Fuente del cuerpo"),
    ("--fuente-titulo", "Inter, system-ui, -apple-system, Segoe UI, sans-serif", "font",    "tipografia", "Fuente de títulos"),
    ("--fs-xs",  "12px", "size", "tipografia", None),
    ("--fs-sm",  "14px", "size", "tipografia", None),
    ("--fs-md",  "16px", "size", "tipografia", "Tamaño base"),
    ("--fs-lg",  "20px", "size", "tipografia", None),
    ("--fs-xl",  "24px", "size", "tipografia", None),
    ("--fs-xxl", "32px", "size", "tipografia", None),
    ("--fw-normal", "400", "size", "tipografia", None),
    ("--fw-bold",   "700", "size", "tipografia", None),
    ("--color-primario",   "#1f6feb", "color", "color", None),
    ("--color-secundario", "#0d9488", "color", "color", None),
    ("--color-fondo",      "#f7f8fa", "color", "color", None),
    ("--color-superficie", "#ffffff", "color", "color", None),
    ("--color-texto",      "#1b1f24", "color", "color", None),
    ("--color-muted",      "#6b7280", "color", "color", None),
    ("--color-exito",      "#16a34a", "color", "color", "semáforo OK"),
    ("--color-alerta",     "#d97706", "color", "color", "semáforo medio"),
    ("--color-peligro",    "#dc2626", "color", "color", "semáforo alto"),
    ("--radio",    "10px",  "radius",  "layout", None),
    ("--esp-1",    "4px",   "spacing", "layout", None),
    ("--esp-2",    "8px",   "spacing", "layout", None),
    ("--esp-3",    "16px",  "spacing", "layout", None),
    ("--esp-4",    "24px",  "spacing", "layout", None),
    ("--sombra-1", "0 1px 3px rgba(0,0,0,.08)", "shadow", "layout", None),
    ("--ancho-max", "1200px", "spacing", "layout", "Ancho máximo del contenido"),
]

# clave, valor, contexto
TEXTOS = [
    ("app.nombre",      "Efecto Áncash · MEL",              "app"),
    ("app.subtitulo",   "Monitoreo, Evaluación y Aprendizaje", "app"),
    ("login.titulo",    "Iniciar sesión",                   "login"),
    ("login.usuario",   "Usuario",                          "login"),
    ("login.clave",     "Clave",                            "login"),
    ("login.entrar",    "Entrar",                           "login"),
    ("login.error",     "Usuario o clave incorrectos",      "login"),
    ("nav.programacion", "Programación",                    "nav"),
    ("nav.cca",          "CCA",                             "nav"),
    ("nav.mente_sana",   "Mente Sana",                      "nav"),
    ("nav.indicadores",  "Indicadores",                     "nav"),
    ("nav.academia",     "Academia Juvenil",                "nav"),
    ("comun.dashboard",  "Panel",                           "comun"),
    ("comun.guardar",    "Guardar",                         "comun"),
    ("comun.enviar",     "Guardar y enviar",                "comun"),
    ("comun.cargando",   "Cargando…",                       "comun"),
    ("comun.sin_datos",  "Sin datos para los filtros elegidos", "comun"),
    ("kpi.n_ie",         "IE atendidas",                    "indicadores"),
    ("kpi.n_participantes", "Participantes",                "indicadores"),
    ("kpi.acompanamientos", "Acompañamientos",              "indicadores"),
    ("kpi.renuncias",    "Renuncias",                       "indicadores"),
    ("bloque.filtros",   "Filtros",                         "bloques"),
    ("bloque.agenda",    "Agenda",                          "bloques"),
    ("bloque.kpis",      "Indicadores clave",               "bloques"),
]

# codigo, ruta, titulo_clave, icono, orden
VISTAS = [
    ("programacion", "#/programacion", "nav.programacion", "calendar", 10),
    ("cca",          "#/cca",          "nav.cca",          "users",    20),
    ("mente_sana",   "#/mente-sana",   "nav.mente_sana",   "users",    30),
    ("indicadores",  "#/indicadores",  "nav.indicadores",  "bar-chart", 40),
    ("academia",     "#/academia",     "nav.academia",     "award",    50),
]

# vista_codigo, bloque_codigo, titulo_clave, tipo, orden, fijo, ancho
BLOQUES = [
    ("programacion", "filtros", "bloque.filtros", "filtros", 1, True,  "full"),
    ("programacion", "agenda",  "bloque.agenda",  "agenda",  2, False, "full"),
    ("indicadores",  "kpis",    "bloque.kpis",    "kpis",    1, True,  "full"),
    ("indicadores",  "graficos", None,            "grafico", 2, False, "full"),
    ("indicadores",  "detalle",  None,            "tabla",   3, False, "full"),
]

# vista_codigo, bloque_codigo, clave, tipo, titulo_clave, fuente_dato, orden
ELEMENTOS = [
    ("indicadores", "kpis", "n_ie", "kpi", "kpi.n_ie", "vw_resumen_jefe_territorial", 1),
    ("indicadores", "kpis", "n_participantes", "kpi", "kpi.n_participantes", "vw_resumen_jefe_territorial", 2),
    ("indicadores", "kpis", "n_acompanamientos", "kpi", "kpi.acompanamientos", "vw_resumen_jefe_territorial", 3),
    ("indicadores", "kpis", "n_renuncias", "kpi", "kpi.renuncias", "vw_resumen_jefe_territorial", 4),
]


def sq(v):
    return "NULL" if v is None else ("'%s'" % str(v).replace("'", "''"))


L = ["/* 030_ui_seed.sql — configuración de interfaz (idioma, tema, textos, vistas).",
     "   Generado por gen_ui.py. Idempotente (WHERE NOT EXISTS). */",
     "SET search_path TO %s, public;" % SCHEMA, "BEGIN;", ""]

for code, nom in IDIOMAS:
    L.append("INSERT INTO ui_idioma (codigo, nombre, activo)\n"
             "SELECT %s, %s, true WHERE NOT EXISTS (SELECT 1 FROM ui_idioma WHERE codigo=%s);"
             % (sq(code), sq(nom), sq(code)))

L.append("")
L.append("INSERT INTO ui_tema (codigo, nombre, es_default, activo)\n"
         "SELECT 'base', 'Base (claro)', true, true WHERE NOT EXISTS (SELECT 1 FROM ui_tema WHERE codigo='base');")

L.append("")
for tok, val, tipo, grupo, nota in TOKENS:
    L.append("INSERT INTO ui_tema_token (tema_id, token, valor, tipo, grupo, nota)\n"
             "SELECT t.id, %s, %s, %s, %s, %s FROM ui_tema t WHERE t.codigo='base'\n"
             "  AND NOT EXISTS (SELECT 1 FROM ui_tema_token x WHERE x.tema_id=t.id AND x.token=%s);"
             % (sq(tok), sq(val), sq(tipo), sq(grupo), sq(nota), sq(tok)))

L.append("")
for clave, valor, ctx in TEXTOS:
    L.append("INSERT INTO ui_texto (clave, idioma_id, valor, contexto)\n"
             "SELECT %s, i.id, %s, %s FROM ui_idioma i WHERE i.codigo='es'\n"
             "  AND NOT EXISTS (SELECT 1 FROM ui_texto x WHERE x.clave=%s AND x.idioma_id=i.id);"
             % (sq(clave), sq(valor), sq(ctx), sq(clave)))

L.append("")
for cod, ruta, tclave, ico, orden in VISTAS:
    L.append("INSERT INTO ui_vista (codigo, ruta, titulo_clave, icono, orden, activo)\n"
             "SELECT %s, %s, %s, %s, %d, true WHERE NOT EXISTS (SELECT 1 FROM ui_vista WHERE codigo=%s);"
             % (sq(cod), sq(ruta), sq(tclave), sq(ico), orden, sq(cod)))

L.append("")
for vcod, bcod, tclave, tipo, orden, fijo, ancho in BLOQUES:
    L.append("INSERT INTO ui_bloque (vista_id, codigo, titulo_clave, tipo, orden, fijo, visible, ancho)\n"
             "SELECT v.id, %s, %s, %s, %d, %s, true, %s FROM ui_vista v WHERE v.codigo=%s\n"
             "  AND NOT EXISTS (SELECT 1 FROM ui_bloque x WHERE x.vista_id=v.id AND x.codigo=%s);"
             % (sq(bcod), sq(tclave), sq(tipo), orden, "true" if fijo else "false", sq(ancho), sq(vcod), sq(bcod)))

L.append("")
for vcod, bcod, clave, tipo, tclave, fuente, orden in ELEMENTOS:
    L.append("INSERT INTO ui_elemento (bloque_id, clave, tipo, titulo_clave, fuente_dato, orden, visible)\n"
             "SELECT b.id, %s, %s, %s, %s, %d, true\n"
             "  FROM ui_bloque b JOIN ui_vista v ON v.id=b.vista_id\n"
             " WHERE v.codigo=%s AND b.codigo=%s\n"
             "   AND NOT EXISTS (SELECT 1 FROM ui_elemento x WHERE x.bloque_id=b.id AND x.clave=%s);"
             % (sq(clave), sq(tipo), sq(tclave), sq(fuente), orden, sq(vcod), sq(bcod), sq(clave)))

L += ["", "COMMIT;", ""]

os.makedirs(os.path.dirname(OUT), exist_ok=True)
with open(OUT, "w", encoding="utf-8") as fh:
    fh.write("\n".join(L))
print("-> %s  (%d textos, %d tokens, %d vistas, %d bloques, %d elementos)"
      % (OUT, len(TEXTOS), len(TOKENS), len(VISTAS), len(BLOQUES), len(ELEMENTOS)))
