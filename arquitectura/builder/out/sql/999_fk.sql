/* 999_fk  —  integridad referencial (emitida al final, idempotente). */

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_componente_proyecto_id') THEN
    ALTER TABLE efectoancash.core_componente ADD CONSTRAINT fk_core_componente_proyecto_id FOREIGN KEY (proyecto_id) REFERENCES efectoancash.core_proyecto(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_ct_persona_id') THEN
    ALTER TABLE efectoancash.core_ct ADD CONSTRAINT fk_core_ct_persona_id FOREIGN KEY (persona_id) REFERENCES efectoancash.core_persona(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_ct_ugt_id') THEN
    ALTER TABLE efectoancash.core_ct ADD CONSTRAINT fk_core_ct_ugt_id FOREIGN KEY (ugt_id) REFERENCES efectoancash.core_ugt(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_centro_poblado_ugt_id') THEN
    ALTER TABLE efectoancash.core_centro_poblado ADD CONSTRAINT fk_core_centro_poblado_ugt_id FOREIGN KEY (ugt_id) REFERENCES efectoancash.core_ugt(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_centro_poblado_ct_id') THEN
    ALTER TABLE efectoancash.core_centro_poblado ADD CONSTRAINT fk_core_centro_poblado_ct_id FOREIGN KEY (ct_id) REFERENCES efectoancash.core_ct(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_usuario_persona_id') THEN
    ALTER TABLE efectoancash.core_usuario ADD CONSTRAINT fk_core_usuario_persona_id FOREIGN KEY (persona_id) REFERENCES efectoancash.core_persona(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_usuario_rol_id') THEN
    ALTER TABLE efectoancash.core_usuario ADD CONSTRAINT fk_core_usuario_rol_id FOREIGN KEY (rol_id) REFERENCES efectoancash.core_rol(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_usuario_ugt_id') THEN
    ALTER TABLE efectoancash.core_usuario ADD CONSTRAINT fk_core_usuario_ugt_id FOREIGN KEY (ugt_id) REFERENCES efectoancash.core_ugt(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_usuario_alcance_usuario_id') THEN
    ALTER TABLE efectoancash.core_usuario_alcance ADD CONSTRAINT fk_core_usuario_alcance_usuario_id FOREIGN KEY (usuario_id) REFERENCES efectoancash.core_usuario(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_usuario_alcance_ugt_id') THEN
    ALTER TABLE efectoancash.core_usuario_alcance ADD CONSTRAINT fk_core_usuario_alcance_ugt_id FOREIGN KEY (ugt_id) REFERENCES efectoancash.core_ugt(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_usuario_alcance_ct_id') THEN
    ALTER TABLE efectoancash.core_usuario_alcance ADD CONSTRAINT fk_core_usuario_alcance_ct_id FOREIGN KEY (ct_id) REFERENCES efectoancash.core_ct(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_usuario_alcance_programa_id') THEN
    ALTER TABLE efectoancash.core_usuario_alcance ADD CONSTRAINT fk_core_usuario_alcance_programa_id FOREIGN KEY (programa_id) REFERENCES efectoancash.core_proyecto(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_ie_ugt_id') THEN
    ALTER TABLE efectoancash.core_ie ADD CONSTRAINT fk_core_ie_ugt_id FOREIGN KEY (ugt_id) REFERENCES efectoancash.core_ugt(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_catalogo_item_catalogo_id') THEN
    ALTER TABLE efectoancash.core_catalogo_item ADD CONSTRAINT fk_core_catalogo_item_catalogo_id FOREIGN KEY (catalogo_id) REFERENCES efectoancash.core_catalogo(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_actividad_proyecto_id') THEN
    ALTER TABLE efectoancash.core_actividad ADD CONSTRAINT fk_core_actividad_proyecto_id FOREIGN KEY (proyecto_id) REFERENCES efectoancash.core_proyecto(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_actividad_componente_id') THEN
    ALTER TABLE efectoancash.core_actividad ADD CONSTRAINT fk_core_actividad_componente_id FOREIGN KEY (componente_id) REFERENCES efectoancash.core_componente(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_actividad_ugt_id') THEN
    ALTER TABLE efectoancash.core_actividad ADD CONSTRAINT fk_core_actividad_ugt_id FOREIGN KEY (ugt_id) REFERENCES efectoancash.core_ugt(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_actividad_escuela_id') THEN
    ALTER TABLE efectoancash.core_actividad ADD CONSTRAINT fk_core_actividad_escuela_id FOREIGN KEY (escuela_id) REFERENCES efectoancash.core_ie(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_actividad_periodo_id') THEN
    ALTER TABLE efectoancash.core_actividad ADD CONSTRAINT fk_core_actividad_periodo_id FOREIGN KEY (periodo_id) REFERENCES efectoancash.core_periodo(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_actividad_estado_id') THEN
    ALTER TABLE efectoancash.core_actividad ADD CONSTRAINT fk_core_actividad_estado_id FOREIGN KEY (estado_id) REFERENCES efectoancash.core_catalogo_item(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_actividad_responsable_id') THEN
    ALTER TABLE efectoancash.core_actividad ADD CONSTRAINT fk_core_actividad_responsable_id FOREIGN KEY (responsable_id) REFERENCES efectoancash.core_usuario(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_sesion_actividad_id') THEN
    ALTER TABLE efectoancash.core_sesion ADD CONSTRAINT fk_core_sesion_actividad_id FOREIGN KEY (actividad_id) REFERENCES efectoancash.core_actividad(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_sesion_facilitador_id') THEN
    ALTER TABLE efectoancash.core_sesion ADD CONSTRAINT fk_core_sesion_facilitador_id FOREIGN KEY (facilitador_id) REFERENCES efectoancash.core_persona(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_evidencia_sesion_id') THEN
    ALTER TABLE efectoancash.core_evidencia ADD CONSTRAINT fk_core_evidencia_sesion_id FOREIGN KEY (sesion_id) REFERENCES efectoancash.core_sesion(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_evidencia_subido_por') THEN
    ALTER TABLE efectoancash.core_evidencia ADD CONSTRAINT fk_core_evidencia_subido_por FOREIGN KEY (subido_por) REFERENCES efectoancash.core_usuario(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_comentario_usuario_id') THEN
    ALTER TABLE efectoancash.core_comentario ADD CONSTRAINT fk_core_comentario_usuario_id FOREIGN KEY (usuario_id) REFERENCES efectoancash.core_usuario(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_core_evento_usuario_id') THEN
    ALTER TABLE efectoancash.core_evento ADD CONSTRAINT fk_core_evento_usuario_id FOREIGN KEY (usuario_id) REFERENCES efectoancash.core_usuario(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_pad_escuela_core_ie_id') THEN
    ALTER TABLE efectoancash.pad_escuela ADD CONSTRAINT fk_pad_escuela_core_ie_id FOREIGN KEY (core_ie_id) REFERENCES efectoancash.core_ie(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_pad_escuela_componente_core_ie_id') THEN
    ALTER TABLE efectoancash.pad_escuela_componente ADD CONSTRAINT fk_pad_escuela_componente_core_ie_id FOREIGN KEY (core_ie_id) REFERENCES efectoancash.core_ie(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_pad_escuela_componente_componente_id') THEN
    ALTER TABLE efectoancash.pad_escuela_componente ADD CONSTRAINT fk_pad_escuela_componente_componente_id FOREIGN KEY (componente_id) REFERENCES efectoancash.core_componente(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_poa_actividad_grande_componente_id') THEN
    ALTER TABLE efectoancash.prog_poa_actividad_grande ADD CONSTRAINT fk_prog_poa_actividad_grande_componente_id FOREIGN KEY (componente_id) REFERENCES efectoancash.core_componente(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_poa_actividad_grande_ugt_id') THEN
    ALTER TABLE efectoancash.prog_poa_actividad_grande ADD CONSTRAINT fk_prog_poa_actividad_grande_ugt_id FOREIGN KEY (ugt_id) REFERENCES efectoancash.core_ugt(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_poa_actividad_grande_ct_id') THEN
    ALTER TABLE efectoancash.prog_poa_actividad_grande ADD CONSTRAINT fk_prog_poa_actividad_grande_ct_id FOREIGN KEY (ct_id) REFERENCES efectoancash.core_ct(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_poa_actividad_grande_periodo_id') THEN
    ALTER TABLE efectoancash.prog_poa_actividad_grande ADD CONSTRAINT fk_prog_poa_actividad_grande_periodo_id FOREIGN KEY (periodo_id) REFERENCES efectoancash.core_periodo(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_poa_actividad_grande_responsable_id') THEN
    ALTER TABLE efectoancash.prog_poa_actividad_grande ADD CONSTRAINT fk_prog_poa_actividad_grande_responsable_id FOREIGN KEY (responsable_id) REFERENCES efectoancash.core_usuario(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_poa_actividad_grande_estado_id') THEN
    ALTER TABLE efectoancash.prog_poa_actividad_grande ADD CONSTRAINT fk_prog_poa_actividad_grande_estado_id FOREIGN KEY (estado_id) REFERENCES efectoancash.core_catalogo_item(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_poa_actividad_grande_creado_por') THEN
    ALTER TABLE efectoancash.prog_poa_actividad_grande ADD CONSTRAINT fk_prog_poa_actividad_grande_creado_por FOREIGN KEY (creado_por) REFERENCES efectoancash.core_usuario(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_poa_actividad_grande_actualizado_por') THEN
    ALTER TABLE efectoancash.prog_poa_actividad_grande ADD CONSTRAINT fk_prog_poa_actividad_grande_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES efectoancash.core_usuario(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_actividad_pequena_act_grande_id') THEN
    ALTER TABLE efectoancash.prog_actividad_pequena ADD CONSTRAINT fk_prog_actividad_pequena_act_grande_id FOREIGN KEY (act_grande_id) REFERENCES efectoancash.prog_poa_actividad_grande(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_actividad_pequena_ie_id') THEN
    ALTER TABLE efectoancash.prog_actividad_pequena ADD CONSTRAINT fk_prog_actividad_pequena_ie_id FOREIGN KEY (ie_id) REFERENCES efectoancash.core_ie(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_actividad_pequena_centro_poblado_id') THEN
    ALTER TABLE efectoancash.prog_actividad_pequena ADD CONSTRAINT fk_prog_actividad_pequena_centro_poblado_id FOREIGN KEY (centro_poblado_id) REFERENCES efectoancash.core_centro_poblado(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_actividad_pequena_responsable_id') THEN
    ALTER TABLE efectoancash.prog_actividad_pequena ADD CONSTRAINT fk_prog_actividad_pequena_responsable_id FOREIGN KEY (responsable_id) REFERENCES efectoancash.core_usuario(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_actividad_pequena_estado_id') THEN
    ALTER TABLE efectoancash.prog_actividad_pequena ADD CONSTRAINT fk_prog_actividad_pequena_estado_id FOREIGN KEY (estado_id) REFERENCES efectoancash.core_catalogo_item(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_reporte_act_pequena_id') THEN
    ALTER TABLE efectoancash.prog_reporte ADD CONSTRAINT fk_prog_reporte_act_pequena_id FOREIGN KEY (act_pequena_id) REFERENCES efectoancash.prog_actividad_pequena(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_incidencia_reporte_id') THEN
    ALTER TABLE efectoancash.prog_incidencia ADD CONSTRAINT fk_prog_incidencia_reporte_id FOREIGN KEY (reporte_id) REFERENCES efectoancash.prog_reporte(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_incidencia_categoria_id') THEN
    ALTER TABLE efectoancash.prog_incidencia ADD CONSTRAINT fk_prog_incidencia_categoria_id FOREIGN KEY (categoria_id) REFERENCES efectoancash.core_catalogo_item(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_incidencia_subcategoria_id') THEN
    ALTER TABLE efectoancash.prog_incidencia ADD CONSTRAINT fk_prog_incidencia_subcategoria_id FOREIGN KEY (subcategoria_id) REFERENCES efectoancash.core_catalogo_item(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_incidencia_nivel_semaforo_id') THEN
    ALTER TABLE efectoancash.prog_incidencia ADD CONSTRAINT fk_prog_incidencia_nivel_semaforo_id FOREIGN KEY (nivel_semaforo_id) REFERENCES efectoancash.core_catalogo_item(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_indicador_mes_periodo_id') THEN
    ALTER TABLE efectoancash.prog_indicador_mes ADD CONSTRAINT fk_prog_indicador_mes_periodo_id FOREIGN KEY (periodo_id) REFERENCES efectoancash.core_periodo(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_alerta_regla_nivel_semaforo_min_id') THEN
    ALTER TABLE efectoancash.prog_alerta_regla ADD CONSTRAINT fk_prog_alerta_regla_nivel_semaforo_min_id FOREIGN KEY (nivel_semaforo_min_id) REFERENCES efectoancash.core_catalogo_item(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_notificacion_incidencia_id') THEN
    ALTER TABLE efectoancash.prog_notificacion ADD CONSTRAINT fk_prog_notificacion_incidencia_id FOREIGN KEY (incidencia_id) REFERENCES efectoancash.prog_incidencia(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_notificacion_regla_id') THEN
    ALTER TABLE efectoancash.prog_notificacion ADD CONSTRAINT fk_prog_notificacion_regla_id FOREIGN KEY (regla_id) REFERENCES efectoancash.prog_alerta_regla(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_prog_notificacion_destinatario_id') THEN
    ALTER TABLE efectoancash.prog_notificacion ADD CONSTRAINT fk_prog_notificacion_destinatario_id FOREIGN KEY (destinatario_id) REFERENCES efectoancash.core_usuario(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_inst_instrumento_proyecto_id') THEN
    ALTER TABLE efectoancash.inst_instrumento ADD CONSTRAINT fk_inst_instrumento_proyecto_id FOREIGN KEY (proyecto_id) REFERENCES efectoancash.core_proyecto(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_inst_item_instrumento_id') THEN
    ALTER TABLE efectoancash.inst_item ADD CONSTRAINT fk_inst_item_instrumento_id FOREIGN KEY (instrumento_id) REFERENCES efectoancash.inst_instrumento(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_inst_intento_instrumento_id') THEN
    ALTER TABLE efectoancash.inst_intento ADD CONSTRAINT fk_inst_intento_instrumento_id FOREIGN KEY (instrumento_id) REFERENCES efectoancash.inst_instrumento(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_inst_intento_ie_id') THEN
    ALTER TABLE efectoancash.inst_intento ADD CONSTRAINT fk_inst_intento_ie_id FOREIGN KEY (ie_id) REFERENCES efectoancash.core_ie(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_inst_intento_persona_id') THEN
    ALTER TABLE efectoancash.inst_intento ADD CONSTRAINT fk_inst_intento_persona_id FOREIGN KEY (persona_id) REFERENCES efectoancash.core_persona(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_inst_intento_corte_id') THEN
    ALTER TABLE efectoancash.inst_intento ADD CONSTRAINT fk_inst_intento_corte_id FOREIGN KEY (corte_id) REFERENCES efectoancash.core_catalogo_item(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_inst_intento_facilitador_id') THEN
    ALTER TABLE efectoancash.inst_intento ADD CONSTRAINT fk_inst_intento_facilitador_id FOREIGN KEY (facilitador_id) REFERENCES efectoancash.core_persona(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_inst_respuesta_intento_id') THEN
    ALTER TABLE efectoancash.inst_respuesta ADD CONSTRAINT fk_inst_respuesta_intento_id FOREIGN KEY (intento_id) REFERENCES efectoancash.inst_intento(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_inst_respuesta_item_id') THEN
    ALTER TABLE efectoancash.inst_respuesta ADD CONSTRAINT fk_inst_respuesta_item_id FOREIGN KEY (item_id) REFERENCES efectoancash.inst_item(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cca_roster_ie_id') THEN
    ALTER TABLE efectoancash.cca_roster ADD CONSTRAINT fk_cca_roster_ie_id FOREIGN KEY (ie_id) REFERENCES efectoancash.core_ie(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cca_roster_persona_id') THEN
    ALTER TABLE efectoancash.cca_roster ADD CONSTRAINT fk_cca_roster_persona_id FOREIGN KEY (persona_id) REFERENCES efectoancash.core_persona(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cca_roster_parentesco_id') THEN
    ALTER TABLE efectoancash.cca_roster ADD CONSTRAINT fk_cca_roster_parentesco_id FOREIGN KEY (parentesco_id) REFERENCES efectoancash.core_catalogo_item(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cca_sesion_core_sesion_id') THEN
    ALTER TABLE efectoancash.cca_sesion ADD CONSTRAINT fk_cca_sesion_core_sesion_id FOREIGN KEY (core_sesion_id) REFERENCES efectoancash.core_sesion(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cca_sesion_ie_id') THEN
    ALTER TABLE efectoancash.cca_sesion ADD CONSTRAINT fk_cca_sesion_ie_id FOREIGN KEY (ie_id) REFERENCES efectoancash.core_ie(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cca_sesion_etapa_id') THEN
    ALTER TABLE efectoancash.cca_sesion ADD CONSTRAINT fk_cca_sesion_etapa_id FOREIGN KEY (etapa_id) REFERENCES efectoancash.core_etapa(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cca_sesion_publico_id') THEN
    ALTER TABLE efectoancash.cca_sesion ADD CONSTRAINT fk_cca_sesion_publico_id FOREIGN KEY (publico_id) REFERENCES efectoancash.core_catalogo_item(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cca_asistencia_cca_sesion_id') THEN
    ALTER TABLE efectoancash.cca_asistencia ADD CONSTRAINT fk_cca_asistencia_cca_sesion_id FOREIGN KEY (cca_sesion_id) REFERENCES efectoancash.cca_sesion(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cca_asistencia_roster_id') THEN
    ALTER TABLE efectoancash.cca_asistencia ADD CONSTRAINT fk_cca_asistencia_roster_id FOREIGN KEY (roster_id) REFERENCES efectoancash.cca_roster(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cca_asistencia_intento_satisfaccion_id') THEN
    ALTER TABLE efectoancash.cca_asistencia ADD CONSTRAINT fk_cca_asistencia_intento_satisfaccion_id FOREIGN KEY (intento_satisfaccion_id) REFERENCES efectoancash.inst_intento(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cca_seguimiento_ie_ie_id') THEN
    ALTER TABLE efectoancash.cca_seguimiento_ie ADD CONSTRAINT fk_cca_seguimiento_ie_ie_id FOREIGN KEY (ie_id) REFERENCES efectoancash.core_ie(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cca_seguimiento_ie_hito_id') THEN
    ALTER TABLE efectoancash.cca_seguimiento_ie ADD CONSTRAINT fk_cca_seguimiento_ie_hito_id FOREIGN KEY (hito_id) REFERENCES efectoancash.core_catalogo_item(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cca_seguimiento_ie_estado_id') THEN
    ALTER TABLE efectoancash.cca_seguimiento_ie ADD CONSTRAINT fk_cca_seguimiento_ie_estado_id FOREIGN KEY (estado_id) REFERENCES efectoancash.core_catalogo_item(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cca_seguimiento_ie_responsable_id') THEN
    ALTER TABLE efectoancash.cca_seguimiento_ie ADD CONSTRAINT fk_cca_seguimiento_ie_responsable_id FOREIGN KEY (responsable_id) REFERENCES efectoancash.core_usuario(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_ms_roster_ie_id') THEN
    ALTER TABLE efectoancash.ms_roster ADD CONSTRAINT fk_ms_roster_ie_id FOREIGN KEY (ie_id) REFERENCES efectoancash.core_ie(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_ms_roster_persona_id') THEN
    ALTER TABLE efectoancash.ms_roster ADD CONSTRAINT fk_ms_roster_persona_id FOREIGN KEY (persona_id) REFERENCES efectoancash.core_persona(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_ms_sesion_core_sesion_id') THEN
    ALTER TABLE efectoancash.ms_sesion ADD CONSTRAINT fk_ms_sesion_core_sesion_id FOREIGN KEY (core_sesion_id) REFERENCES efectoancash.core_sesion(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_ms_sesion_ie_id') THEN
    ALTER TABLE efectoancash.ms_sesion ADD CONSTRAINT fk_ms_sesion_ie_id FOREIGN KEY (ie_id) REFERENCES efectoancash.core_ie(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_ms_sesion_etapa_id') THEN
    ALTER TABLE efectoancash.ms_sesion ADD CONSTRAINT fk_ms_sesion_etapa_id FOREIGN KEY (etapa_id) REFERENCES efectoancash.core_etapa(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_ms_asistencia_ms_sesion_id') THEN
    ALTER TABLE efectoancash.ms_asistencia ADD CONSTRAINT fk_ms_asistencia_ms_sesion_id FOREIGN KEY (ms_sesion_id) REFERENCES efectoancash.ms_sesion(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_ms_asistencia_roster_id') THEN
    ALTER TABLE efectoancash.ms_asistencia ADD CONSTRAINT fk_ms_asistencia_roster_id FOREIGN KEY (roster_id) REFERENCES efectoancash.ms_roster(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_ms_evaluacion_estudiante_ie_id') THEN
    ALTER TABLE efectoancash.ms_evaluacion_estudiante ADD CONSTRAINT fk_ms_evaluacion_estudiante_ie_id FOREIGN KEY (ie_id) REFERENCES efectoancash.core_ie(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_ms_evaluacion_estudiante_persona_id') THEN
    ALTER TABLE efectoancash.ms_evaluacion_estudiante ADD CONSTRAINT fk_ms_evaluacion_estudiante_persona_id FOREIGN KEY (persona_id) REFERENCES efectoancash.core_persona(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_ms_evaluacion_estudiante_intento_id') THEN
    ALTER TABLE efectoancash.ms_evaluacion_estudiante ADD CONSTRAINT fk_ms_evaluacion_estudiante_intento_id FOREIGN KEY (intento_id) REFERENCES efectoancash.inst_intento(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_pdle_programa_sesion_core_sesion_id') THEN
    ALTER TABLE efectoancash.pdle_programa_sesion ADD CONSTRAINT fk_pdle_programa_sesion_core_sesion_id FOREIGN KEY (core_sesion_id) REFERENCES efectoancash.core_sesion(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_pdle_programa_sesion_ie_id') THEN
    ALTER TABLE efectoancash.pdle_programa_sesion ADD CONSTRAINT fk_pdle_programa_sesion_ie_id FOREIGN KEY (ie_id) REFERENCES efectoancash.core_ie(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_pdle_programa_sesion_etapa_id') THEN
    ALTER TABLE efectoancash.pdle_programa_sesion ADD CONSTRAINT fk_pdle_programa_sesion_etapa_id FOREIGN KEY (etapa_id) REFERENCES efectoancash.core_etapa(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_pdle_participante_pdle_programa_sesion_id') THEN
    ALTER TABLE efectoancash.pdle_participante ADD CONSTRAINT fk_pdle_participante_pdle_programa_sesion_id FOREIGN KEY (pdle_programa_sesion_id) REFERENCES efectoancash.pdle_programa_sesion(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_pdle_participante_persona_id') THEN
    ALTER TABLE efectoancash.pdle_participante ADD CONSTRAINT fk_pdle_participante_persona_id FOREIGN KEY (persona_id) REFERENCES efectoancash.core_persona(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_pdle_evaluacion_participante_id') THEN
    ALTER TABLE efectoancash.pdle_evaluacion ADD CONSTRAINT fk_pdle_evaluacion_participante_id FOREIGN KEY (participante_id) REFERENCES efectoancash.pdle_participante(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_pdle_evaluacion_intento_id') THEN
    ALTER TABLE efectoancash.pdle_evaluacion ADD CONSTRAINT fk_pdle_evaluacion_intento_id FOREIGN KEY (intento_id) REFERENCES efectoancash.inst_intento(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_aj_participante_ie_id') THEN
    ALTER TABLE efectoancash.aj_participante ADD CONSTRAINT fk_aj_participante_ie_id FOREIGN KEY (ie_id) REFERENCES efectoancash.core_ie(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_aj_participante_persona_id') THEN
    ALTER TABLE efectoancash.aj_participante ADD CONSTRAINT fk_aj_participante_persona_id FOREIGN KEY (persona_id) REFERENCES efectoancash.core_persona(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_aj_evaluacion_habilidad_participante_id') THEN
    ALTER TABLE efectoancash.aj_evaluacion_habilidad ADD CONSTRAINT fk_aj_evaluacion_habilidad_participante_id FOREIGN KEY (participante_id) REFERENCES efectoancash.aj_participante(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_aj_evaluacion_habilidad_habilidad_id') THEN
    ALTER TABLE efectoancash.aj_evaluacion_habilidad ADD CONSTRAINT fk_aj_evaluacion_habilidad_habilidad_id FOREIGN KEY (habilidad_id) REFERENCES efectoancash.aj_habilidad(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_aj_evaluacion_habilidad_corte_id') THEN
    ALTER TABLE efectoancash.aj_evaluacion_habilidad ADD CONSTRAINT fk_aj_evaluacion_habilidad_corte_id FOREIGN KEY (corte_id) REFERENCES efectoancash.core_catalogo_item(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_aj_cartilla_participante_id') THEN
    ALTER TABLE efectoancash.aj_cartilla ADD CONSTRAINT fk_aj_cartilla_participante_id FOREIGN KEY (participante_id) REFERENCES efectoancash.aj_participante(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_aj_cartilla_periodo_id') THEN
    ALTER TABLE efectoancash.aj_cartilla ADD CONSTRAINT fk_aj_cartilla_periodo_id FOREIGN KEY (periodo_id) REFERENCES efectoancash.core_periodo(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_aj_cartilla_semaforo_id') THEN
    ALTER TABLE efectoancash.aj_cartilla ADD CONSTRAINT fk_aj_cartilla_semaforo_id FOREIGN KEY (semaforo_id) REFERENCES efectoancash.core_catalogo_item(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_ui_texto_idioma_id') THEN
    ALTER TABLE efectoancash.ui_texto ADD CONSTRAINT fk_ui_texto_idioma_id FOREIGN KEY (idioma_id) REFERENCES efectoancash.ui_idioma(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_ui_tema_token_tema_id') THEN
    ALTER TABLE efectoancash.ui_tema_token ADD CONSTRAINT fk_ui_tema_token_tema_id FOREIGN KEY (tema_id) REFERENCES efectoancash.ui_tema(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_ui_vista_rol_id') THEN
    ALTER TABLE efectoancash.ui_vista ADD CONSTRAINT fk_ui_vista_rol_id FOREIGN KEY (rol_id) REFERENCES efectoancash.core_rol(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_ui_bloque_vista_id') THEN
    ALTER TABLE efectoancash.ui_bloque ADD CONSTRAINT fk_ui_bloque_vista_id FOREIGN KEY (vista_id) REFERENCES efectoancash.ui_vista(id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_ui_elemento_bloque_id') THEN
    ALTER TABLE efectoancash.ui_elemento ADD CONSTRAINT fk_ui_elemento_bloque_id FOREIGN KEY (bloque_id) REFERENCES efectoancash.ui_bloque(id);
  END IF;
END $$;
