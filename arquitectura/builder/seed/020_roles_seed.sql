/* 020_roles_seed.sql — roles/alcance (Postgres, schema efectivo de ejemplo)
   Datos SINTÉTICOS de ejemplo (no corresponden a personas reales).
   Idempotente. Correr DESPUÉS de 000_core.sql. */
SET search_path TO efectoancash, public;

-- Roles de acceso
INSERT INTO efectoancash.core_rol (codigo, nombre, es_macro) VALUES
('admin_mel','Admin MEL',true),
('jefe_territorial','Jefe Territorial',true),
('ct','Coordinador Territorial',false),
('programa','Coordinador / Tutor de Programa',false),
('formacion','Formación',false),
('comunicaciones','Comunicaciones',true)
ON CONFLICT (codigo) DO NOTHING;

-- Programas (tipo='programa')
INSERT INTO efectoancash.core_proyecto (codigo, nombre, tipo) VALUES
('PDL','Programa de Liderazgo','programa'),
('QM','Qué Maestro','programa'),
('PDLD','Programa de Liderazgo para Directivos','programa'),
('LECTO','Formación docente en Lectoescritura','programa')
ON CONFLICT (codigo) DO NOTHING;

-- Personas (SINTÉTICAS)
INSERT INTO efectoancash.core_persona (apellidos, nombres, telefono)
SELECT v.ap, v.nom, NULLIF(v.tel,'')
FROM (VALUES
('Apellido1','Nombre1',''),
('Apellido2','Nombre2',''),
('Apellido3','Nombre3',''),
('Apellido4','Nombre4',''),
('Apellido5','Nombre5',''),
('Apellido6','Nombre6','')
) AS v(ap, nom, tel)
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_persona p
   WHERE coalesce(p.apellidos,'')=v.ap AND coalesce(p.nombres,'')=v.nom);

-- Usuarios (correos de ejemplo; rol fino por email)
INSERT INTO efectoancash.core_usuario (persona_id, email, rol_id, hash_clave, activo)
SELECT p.id, v.email, r.id, 'demo:demo', true
FROM (VALUES
('Apellido1','Nombre1','admin.mel@example.org','admin_mel'),
('Apellido2','Nombre2','jefe.territorial@example.org','jefe_territorial'),
('Apellido3','Nombre3','ct.huarmey@example.org','ct'),
('Apellido4','Nombre4','ct.huallanca@example.org','ct'),
('Apellido5','Nombre5','coord.pdl@example.org','programa'),
('Apellido6','Nombre6','comunicaciones@example.org','comunicaciones')
) AS v(ap, nom, email, rolcod)
JOIN efectoancash.core_persona p ON p.apellidos=v.ap AND p.nombres=v.nom
JOIN efectoancash.core_rol r ON r.codigo=v.rolcod
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_usuario u WHERE u.email=v.email);

-- CT (entidad propia; una UGT puede tener 2)
INSERT INTO efectoancash.core_ct (persona_id, nombre, ugt_id)
SELECT p.id, v.cn, g.id
FROM (VALUES
('Apellido3','Nombre3','UGT Huarmey','UGT Huarmey')
) AS v(ap, nom, cn, ugt)
JOIN efectoancash.core_persona p ON p.apellidos=v.ap AND p.nombres=v.nom
LEFT JOIN efectoancash.core_ugt g ON g.nombre=v.ugt
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_ct c WHERE c.nombre=v.cn);

-- Alcance (usuario x UGT x programa)
INSERT INTO efectoancash.core_usuario_alcance (usuario_id, ugt_id, ct_id, programa_id)
SELECT u.id, g.id, c.id, pr.id
FROM (VALUES
('ct.huarmey@example.org','UGT Huarmey',NULL,NULL),
('ct.huallanca@example.org','UGT Huallanca',NULL,NULL),
('coord.pdl@example.org','UGT Huarmey',NULL,'PDL')
) AS v(email, ugt, ct, prog)
JOIN efectoancash.core_usuario u ON u.email=v.email
LEFT JOIN efectoancash.core_ugt g ON g.nombre=v.ugt
LEFT JOIN efectoancash.core_ct c ON c.nombre=v.ct
LEFT JOIN efectoancash.core_proyecto pr ON pr.codigo=v.prog
WHERE NOT EXISTS (SELECT 1 FROM efectoancash.core_usuario_alcance a
   WHERE a.usuario_id=u.id AND coalesce(a.ugt_id,-1)=coalesce(g.id,-1) AND coalesce(a.programa_id,-1)=coalesce(pr.id,-1));
