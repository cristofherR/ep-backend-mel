// ======================================================================
// MS FORMULARIO WEBAPP - Code.gs (v14-jul-2026)
// "Mente Sana - Plataforma de ingreso de datos"
// 5 módulos: Reporte al día | Asistencias | Docentes | Familias | Estudiantes
// ======================================================================

// --- CONSTANTES ---
var SPREADSHEET_ID = '<SPREADSHEET_ID_MS>';
var CARPETA_RAIZ_ID = '<CARPETA_RAIZ_ID>';
var NOMBRES_HOJAS = {
  1: 'Reportes_Rapidos',
  2: 'Asistencia',
  3: 'Docentes',
  4: 'Familias',
  5: 'Estudiantes'
};
var HOJA_HISTORIAL = 'Historial';

// ======================================================================
// doGet - Sirve el HTML del formulario
// ======================================================================
function doGet(e) {
  // Si es llamado desde el dashboard con ?source=dashboard → JSON
  if (e && e.parameter && e.parameter.source === 'dashboard') {
    return servirDatosDashboard();
  }
  // Sino → sirve el HTML del formulario
  var html = HtmlService.createHtmlOutputFromFile('Index')
    .setTitle('Mente Sana - Plataforma de ingreso de datos')
    .setXFrameOptionsMode(HtmlService.XFrameOptionsMode.ALLOWALL)
    .addMetaTag('viewport', 'width=device-width, initial-scale=1');
  return html;
}

// ======================================================================
// include - Helper para incluir archivos HTML adicionales
// ======================================================================
function include(filename) {
  return HtmlService.createHtmlOutputFromFile(filename).getContent();
}

// ======================================================================
// getBDData - Datos de hoja BD para dropdowns y auto-relleno
// Lectura: A2:N (filtra filas vacías, soporta cambios de rango)
// ======================================================================
function getBDData() {
  var ss = SpreadsheetApp.openById(SPREADSHEET_ID);
  var bd = ss.getSheetByName('BD');
  var ultimaFila = bd.getLastRow();
  if (ultimaFila < 2) return { ugt: [], iePorUGT: {}, codInstPorIE: {}, provinciaPorIE: {}, distritoPorIE: {}, cpPorIE: {} };
  var allData = bd.getRange('A2:N' + ultimaFila).getValues();

  // Filtrar filas sin N° (completamente vacías)
  var data = [];
  for (var r = 0; r < allData.length; r++) {
    if (allData[r][0] !== '' && allData[r][0] !== null) {
      data.push(allData[r]);
    }
  }

  var ugtSet = {};
  var iePorUGT = {};
  var codInstPorIE = {};
  var provinciaPorIE = {};
  var distritoPorIE = {};
  var cpPorIE = {};
  var nivelesPorIE = {};

  for (var i = 0; i < data.length; i++) {
    var row = data[i];
    var ugt = String(row[2]).trim();       // C
    var ie  = String(row[6]).trim();       // G
    var nivel = String(row[9]).trim();     // J
    if (!ugt || !ie) continue;

    ugtSet[ugt] = true;
    if (!iePorUGT[ugt]) iePorUGT[ugt] = [];
    if (iePorUGT[ugt].indexOf(ie) === -1) iePorUGT[ugt].push(ie);

    var key = ugt + '||' + ie;
    codInstPorIE[key] = String(row[1]).trim();  // B
    provinciaPorIE[key] = String(row[3]).trim(); // D
    distritoPorIE[key]  = String(row[4]).trim(); // E
    cpPorIE[key]        = String(row[5]).trim(); // F

    if (!nivelesPorIE[key]) nivelesPorIE[key] = [];
    if (nivel && nivelesPorIE[key].indexOf(nivel) === -1) {
      nivelesPorIE[key].push(nivel);
    }
  }

  return {
    ugt: Object.keys(ugtSet).sort(),
    iePorUGT: iePorUGT,
    codInstPorIE: codInstPorIE,
    provinciaPorIE: provinciaPorIE,
    distritoPorIE: distritoPorIE,
    cpPorIE: cpPorIE,
    nivelesPorIE: nivelesPorIE
  };
}

// ======================================================================
// getDropDownData - Dropdowns independientes
// Facilitadores (col P) | Etapas (col Q) | Actividades (col R)
// ======================================================================
function getDropDownData() {
  var ss = SpreadsheetApp.openById(SPREADSHEET_ID);

  // Facilitadores desde su propia hoja
  var facilSheet = ss.getSheetByName('Facilitadores');
  var facilitadores = [];
  if (facilSheet) {
    var ultFila = facilSheet.getLastRow();
    if (ultFila > 1) {
      var facilData = facilSheet.getRange(2, 1, ultFila - 1, 1).getValues();
      for (var i = 0; i < facilData.length; i++) {
        var val = String(facilData[i][0]).trim();
        if (val) facilitadores.push(val);
      }
    }
  }

  // Etapas y Actividades desde su propia hoja
  var etapasSet = {};
  var actividadesPorEtapa = {};
  var etapaSheet = ss.getSheetByName('Etapa');
  if (etapaSheet) {
    var ultFila = etapaSheet.getLastRow();
    if (ultFila > 1) {
      var eData = etapaSheet.getRange(2, 1, ultFila - 1, 2).getValues();
      for (var i = 0; i < eData.length; i++) {
        var etapa = String(eData[i][0]).trim();
        var actividad = String(eData[i][1]).trim();
        if (!etapa || !actividad) continue;
        etapasSet[etapa] = true;
        if (!actividadesPorEtapa[etapa]) actividadesPorEtapa[etapa] = [];
        if (actividadesPorEtapa[etapa].indexOf(actividad) === -1) {
          actividadesPorEtapa[etapa].push(actividad);
        }
      }
    }
  }
  var etapas = Object.keys(etapasSet).sort();

  return {
    facilitadores: facilitadores,
    etapas: etapas,
    actividadesPorEtapa: actividadesPorEtapa
  };
}

// ======================================================================
// enviarModulo1 - Guarda en Reportes_Rapidos + Historial
// ======================================================================
function enviarModulo1(d) {
  var lock = LockService.getScriptLock();
  if (!lock.tryLock(30000)) {
    return { exito: false, msg: 'El sistema está ocupado. Intenta de nuevo.' };
  }
  try {
    var ss = SpreadsheetApp.openById(SPREADSHEET_ID);
    var hoja = ss.getSheetByName(NOMBRES_HOJAS[1]);

    var fila = [
      new Date(),                         // A: Timestamp
      d.ugt,                              // B: UGT
      d.ie,                               // C: IE
      d.codInst,                          // D: COD_Inst
      d.nivel || '',                      // E: Nivel
      d.grado || '',                      // F: Grado
      d.codUnico || '',                   // G: Cod_unico
      d.facilitador,                      // H: Facilitador/a
      d.fechaSesion,                      // I: Fecha_Sesion
      d.etapa,                            // J: Etapa
      d.actividad,                        // K: Actividad
      d.tema,                             // L: Tema
      parseInt(d.asistEst) || 0,          // M: Asist_Estudiantes
      parseInt(d.asistFam) || 0,          // N: Asist_Familias
      parseInt(d.asistDoc) || 0,          // O: Asist_Docentes
      parseInt(d.asistOtros) || 0,        // P: Asist_Otros_Cant
      d.asistOtrosTexto || '',            // Q: Asist_Otros_Texto
      d.desarrollo,                       // R: Desarrollo
      d.incidenciasSN,                    // S: Incidencias_SN
      d.descIncidencia || '',             // T: Descripcion_Incidencia
      d.atencionAdicional,                // U: Atencion_Adicional
      d.descAtencion || '',               // V: Descripcion_Atencion_Adicional
      d.evidenciaUrl || ''                // W: Evidencia
    ];

    hoja.appendRow(fila);
    SpreadsheetApp.flush();

    // Historial
    var registros = 'Registro del reporte del día: ' + d.fechaSesion +
      ' en la IE: ' + d.ie + ' - ' + (d.centroPoblado || d.ugt);
    var detalle = d.etapa + ' - ' + d.actividad +
      '. Tema: ' + d.tema + '. Asistentes: ' + d.asistEst +
      ' estudiantes; ' + d.asistFam + ' familias; ' + d.asistDoc + ' docentes.';
    guardarHistorial('Reporte al día', d.ugt, d.ie, d.codInst,
      d.nivel, d.codInst + d.nivel, d.facilitador, registros, detalle);

    return { exito: true, msg: 'Reporte guardado correctamente.' };
  } catch (e) {
    return { exito: false, msg: 'Error al guardar: ' + e.message };
  } finally {
    lock.releaseLock();
  }
}

// ======================================================================
// subirEvidencia - Sube imagen/pdf a Drive en carpeta del facilitador
// ======================================================================
function subirEvidencia(d) {
  try {
    var errores = [];
    if (!d.ugt) errores.push('UGT requerida');
    if (!d.ie) errores.push('IE requerida');
    if (!d.facilitador) errores.push('Facilitador requerido');
    if (!d.archivoData && !d.archivo) errores.push('Archivo requerido');
    if (errores.length > 0) {
      return { exito: false, error: errores.join(' | ') };
    }

    var ROOT_FOLDER_ID = '1BYUneOHbh05KPZySYHLh5u4old_BQFI0';
    var rootFolder = DriveApp.getFolderById(ROOT_FOLDER_ID);

    var facName = d.facilitador.trim();
    var facFolder = null;
    var subFolders = rootFolder.getFolders();
    while (subFolders.hasNext()) {
      var f = subFolders.next();
      if (f.getName().toLowerCase() === facName.toLowerCase()) {
        facFolder = f;
        break;
      }
    }
    if (!facFolder) {
      facFolder = rootFolder.createFolder(facName);
    }

    // Crear blob desde base64 (nuevo) o desde File object (legacy)
    var blob;
    if (d.archivoData) {
      var decoded = Utilities.base64Decode(d.archivoData);
      blob = Utilities.newBlob(decoded, d.archivoMime || '', d.archivoName || 'evidencia');
    } else {
      blob = d.archivo;
    }

    var ext = blob.getName().includes('.') ? blob.getName().split('.').pop() : 'pdf';
    var fechaFormateada = (d.fecha || '').replace(/-/g, '.');
    var nombreBase = [
      d.ie || '',
      d.centroPoblado || '',
      d.actividad || '',
      fechaFormateada
    ].filter(Boolean).join('-');
    var nombreFinal = nombreBase + '.' + ext;

    var file = facFolder.createFile(blob);
    file.setName(nombreFinal);

    return {
      exito: true,
      nombre: nombreFinal,
      url: file.getUrl()
    };
  } catch (e) {
    return { exito: false, error: e.message };
  }
}

// ======================================================================
// enviarModulo2 - Guarda archivo en Drive + Asistencia + Historial
// ======================================================================
function enviarModulo2(d) {
  var lock = LockService.getScriptLock();
  if (!lock.tryLock(45000)) {
    return { exito: false, msg: 'El sistema está ocupado. Intenta de nuevo.' };
  }
  try {
    var ss = SpreadsheetApp.openById(SPREADSHEET_ID);
    var hoja = ss.getSheetByName(NOMBRES_HOJAS[2]);

    // Decodificar archivo base64
    var blob = Utilities.newBlob(
      Utilities.base64Decode(d.fileData),
      d.fileMime,
      d.fileName
    );

    // Validar extensión
    var ext = d.fileName.split('.').pop().toLowerCase();
    if (['xlsx', 'xls', 'csv'].indexOf(ext) === -1) {
      return { exito: false, msg: 'Solo se permiten archivos .xlsx, .xls y .csv.' };
    }

    // Verificar/crear carpeta del facilitador
    var carpetaRaiz = DriveApp.getFolderById(CARPETA_RAIZ_ID);
    var carpetas = carpetaRaiz.getFoldersByName(d.facilitador);
    var carpetaFacilitador;
    if (carpetas.hasNext()) {
      carpetaFacilitador = carpetas.next();
    } else {
      carpetaFacilitador = carpetaRaiz.createFolder(d.facilitador);
    }

    // Nombre: Facilitador_fechainicio_fechafin.ext
    var fechaIni = d.fechaInicio.replace(/-/g, '.');
    var fechaFin = d.fechaFin.replace(/-/g, '.');
    var nombreArchivo = d.facilitador.replace(/\s+/g, '_') +
      '-' + fechaIni + '-' + fechaFin + '.' + ext;

    // Reemplazar archivo existente con mismo nombre
    var archivosExistentes = carpetaFacilitador.getFilesByName(nombreArchivo);
    while (archivosExistentes.hasNext()) {
      var archivoViejo = archivosExistentes.next();
      archivoViejo.setTrashed(true);
    }

    var archivo = carpetaFacilitador.createFile(blob);
    archivo.setName(nombreArchivo);
    var enlace = archivo.getUrl();

    // Guardar en Asistencia
    var fila = [
      new Date(),             // A: Timestamp
      d.ugt,                  // B: UGT
      d.ie,                   // C: IE
      d.codInst,              // D: COD_Inst
      d.nivel || '',          // E: Nivel
      d.codUnico || '',       // F: Cod_unico
      d.facilitador,          // G: Facilitador/a
      d.fechaInicio,          // H: Fecha_inicio
      d.fechaFin,             // I: Fecha_fin
      enlace                  // J: Enlace
    ];
    hoja.appendRow(fila);
    SpreadsheetApp.flush();

    // Historial
    var registros = 'Registro de asistencia desde ' + d.fechaInicio +
      ' hasta ' + d.fechaFin + ' en la IE: ' + d.ie + ' - ' + (d.centroPoblado || d.ugt);
    guardarHistorial('Registro de asistencias', d.ugt, d.ie, d.codInst,
      d.nivel, d.codInst + d.nivel, d.facilitador, registros, enlace);

    return { exito: true, msg: 'Asistencia registrada y archivo subido correctamente.' };
  } catch (e) {
    return { exito: false, msg: 'Error al guardar: ' + e.message };
  } finally {
    lock.releaseLock();
  }
}

// ======================================================================
// enviarModulo3 - Guarda evaluaciones de docentes + Historial
// ======================================================================
function enviarModulo3(d) {
  var lock = LockService.getScriptLock();
  if (!lock.tryLock(60000)) {
    return { exito: false, msg: 'El sistema está ocupado. Intenta de nuevo.' };
  }
  try {
    var ss = SpreadsheetApp.openById(SPREADSHEET_ID);
    var hoja = ss.getSheetByName(NOMBRES_HOJAS[3]);
    var filas = JSON.parse(d.filas);
    var total = 0;
    var outputRows = [];

    for (var i = 0; i < filas.length; i++) {
      var f = filas[i];
      var apellidos = String(f.apellidos || '').trim();
      var nombres = String(f.nombres || '').trim();

      // Saltar filas completamente vacías
      if (!apellidos && !nombres) continue;

      var apellidosNombres = (apellidos + ' ' + nombres).trim();
      // Timestamp(A), UGT(B), IE(C), COD_Inst(D), Nivel(E), Cod_unico(F), Apellidos_nombres(G)
      var fila = [new Date(), d.ugt, d.ie, d.codInst, d.nivel, d.codUnico, apellidosNombres];
      fila.push(f.grado || '');                // H: Grado
      fila.push(parseInt(f.aniosExp) || '');   // I: Anios_experiencia
      fila.push(f.lengua || '');               // J: Lengua_materna
      fila.push(d.fechaAplicacion);            // K: Fecha_aplicacion
      fila.push(d.corte);                      // L: Corte

      // Preg_1 a Preg_24 (texto de opción)
      for (var p = 1; p <= 24; p++) {
        fila.push(f['preg_' + p] || '');
      }

      // Pregunta_abierta_1 a 3
      for (var o = 1; o <= 3; o++) {
        fila.push(f['abierta_' + o] || '');
      }
      fila.push(d.facilitador);               // ?40: Facilitador/a

      outputRows.push(fila);
      total++;
    }

    if (outputRows.length === 0) {
      return { exito: false, msg: 'No hay filas con datos para guardar.' };
    }

    // Escribir en bloque
    var lastRow = hoja.getLastRow();
    var numCols = outputRows[0].length;
    hoja.getRange(lastRow + 1, 1, outputRows.length, numCols).setValues(outputRows);
    SpreadsheetApp.flush();

    // Historial
    var registros = 'Registro de respuestas de encuesta ' + d.corte +
      ' a docentes aplicado el día: ' + d.fechaAplicacion +
      ' en la IE: ' + d.ie + ' - ' + (d.centroPoblado || d.ugt);
    guardarHistorial('Evaluación - Docentes', d.ugt, d.ie, d.codInst,
      d.nivel, d.codInst + d.nivel, d.facilitador, registros, String(total));

    return { exito: true, msg: total + ' docente(s) registrado(s) correctamente.' };
  } catch (e) {
    return { exito: false, msg: 'Error al guardar: ' + e.message };
  } finally {
    lock.releaseLock();
  }
}

// ======================================================================
// enviarModulo4 - Guarda evaluaciones de familias + Historial
// ======================================================================
function enviarModulo4(d) {
  var lock = LockService.getScriptLock();
  if (!lock.tryLock(60000)) {
    return { exito: false, msg: 'El sistema está ocupado. Intenta de nuevo.' };
  }
  try {
    var ss = SpreadsheetApp.openById(SPREADSHEET_ID);
    var hoja = ss.getSheetByName(NOMBRES_HOJAS[4]);
    var filas = JSON.parse(d.filas);
    var total = 0;
    var outputRows = [];

    for (var i = 0; i < filas.length; i++) {
      var f = filas[i];
      var apellidos = String(f.apellidos || '').trim();
      var nombres = String(f.nombres || '').trim();

      if (!apellidos && !nombres) continue;

      var apellidosNombres = (apellidos + ' ' + nombres).trim();
      // Timestamp(A), UGT(B), IE(C), Nivel(D), COD_Inst(E), Cod_unico(F), Apellidos_nombres(G)
      var fila = [new Date(), d.ugt, d.ie, d.nivel, d.codInst, d.codUnico, apellidosNombres];
      fila.push(f.relacion || '');              // H: Relacion
      fila.push(parseInt(f.edadCuidador) || ''); // I: Edad_cuidador
      fila.push('');                               // J: Edad_ninio (legacy, ya no se recolecta)
      fila.push(f.lengua || '');                // K: Lengua_materna
      fila.push(d.fechaAplicacion);             // L: Fecha_aplicacion
      fila.push(d.corte);                       // M: Corte

      // Preg_1 a Preg_23 (texto de opción)
      for (var p = 1; p <= 23; p++) {
        fila.push(f['preg_' + p] || '');
      }

      // Pregunta_abierta_1 a 2
      for (var o = 1; o <= 2; o++) {
        fila.push(f['abierta_' + o] || '');
      }
      fila.push(d.facilitador);               // AM: Facilitador/a
      fila.push(f['abierta_3'] || '');        // AN: Pregunta_abierta_3

      outputRows.push(fila);
      total++;
    }

    if (outputRows.length === 0) {
      return { exito: false, msg: 'No hay filas con datos para guardar.' };
    }

    var lastRow = hoja.getLastRow();
    var numCols = outputRows[0].length;
    hoja.getRange(lastRow + 1, 1, outputRows.length, numCols).setValues(outputRows);
    SpreadsheetApp.flush();

    // Historial
    var registros = 'Registro de respuestas de encuesta ' + d.corte +
      ' a familias aplicado el día: ' + d.fechaAplicacion +
      ' en la IE: ' + d.ie + ' - ' + (d.centroPoblado || d.ugt);
    guardarHistorial('Evaluación - Familias', d.ugt, d.ie, d.codInst,
      d.nivel, d.codInst + d.nivel, d.facilitador, registros, String(total));

    return { exito: true, msg: total + ' familia(s) registrada(s) correctamente.' };
  } catch (e) {
    return { exito: false, msg: 'Error al guardar: ' + e.message };
  } finally {
    lock.releaseLock();
  }
}

// ======================================================================
// enviarModulo5 - Guarda evaluaciones de estudiantes + Historial
// ======================================================================
function enviarModulo5(d) {
  var lock = LockService.getScriptLock();
  if (!lock.tryLock(60000)) {
    return { exito: false, msg: 'El sistema está ocupado. Intenta de nuevo.' };
  }
  try {
    var ss = SpreadsheetApp.openById(SPREADSHEET_ID);
    var hoja = ss.getSheetByName(NOMBRES_HOJAS[5]);
    var filas = JSON.parse(d.filas);
    var total = 0;
    var outputRows = [];

    for (var i = 0; i < filas.length; i++) {
      var f = filas[i];
      var apellidos = String(f.apellidos || '').trim();
      var nombres = String(f.nombres || '').trim();

      if (!apellidos && !nombres) continue;

      var apellidosNombres = (apellidos + ' ' + nombres).trim();
      // Timestamp(A), UGT(B), IE(C), COD_Inst(D), Nivel(E), Cod_unico(F)
      var fila = [new Date(), d.ugt, d.ie, d.codInst, d.nivel, d.codUnico];
      fila.push(f.grado || '');    // G: Grado
      fila.push(f.seccion || '');  // H: Seccion
      fila.push(apellidosNombres); // I: Apellidos_nombres
      fila.push(d.fechaAplicacion); // J: Fecha_aplicacion
      fila.push(d.corte);          // K: Corte

      // Bloq_1 a Bloq_5 (L-P)
      for (var b = 1; b <= 5; b++) {
        fila.push(f['bloq_' + b] || '');
      }

      // Preg_1 a Preg_3 (Q-S)
      for (var p = 1; p <= 3; p++) {
        fila.push(f['preg_' + p] || '');
      }

      // Indicadores conductuales (T-Y)
      fila.push(f.lenguaje_corporal || '');      // T
      fila.push(f.contacto_visual || '');        // U
      fila.push(f.tono_volumen_voz || '');       // V
      fila.push(f.tiempo_reaccion || '');        // W
      fila.push(f.interaccion_material || '');   // X
      fila.push(f.conducta_social || '');        // Y

      // Comentario_adicional (Z)
      fila.push(f.comentario_adicional || '');

      fila.push(d.facilitador);  // AA: Facilitador/a

      outputRows.push(fila);
      total++;
    }

    if (outputRows.length === 0) {
      return { exito: false, msg: 'No hay filas con datos para guardar.' };
    }

    var lastRow = hoja.getLastRow();
    var numCols = outputRows[0].length;
    hoja.getRange(lastRow + 1, 1, outputRows.length, numCols).setValues(outputRows);
    SpreadsheetApp.flush();

    // Historial
    var registros = 'Registro de respuestas de evaluación ' + d.corte +
      ' a estudiantes de ' + (d.grado || d.nivel || '') + ' aplicado el día: ' + d.fechaAplicacion +
      ' en la IE: ' + d.ie + ' - ' + (d.centroPoblado || d.ugt);
    guardarHistorial('Evaluación - Estudiantes', d.ugt, d.ie, d.codInst,
      d.nivel, d.codInst + d.nivel, d.facilitador, registros, String(total));

    return { exito: true, msg: total + ' estudiante(s) registrado(s) correctamente.' };
  } catch (e) {
    return { exito: false, msg: 'Error al guardar: ' + e.message };
  } finally {
    lock.releaseLock();
  }
}

// ======================================================================
// guardarHistorial - Registro en hoja Historial
// ======================================================================
function guardarHistorial(modulo, ugt, ie, codInst, nivel, codUnico, facilitador, registros, detalle) {
  try {
    var ss = SpreadsheetApp.openById(SPREADSHEET_ID);
    var hoja = ss.getSheetByName(HOJA_HISTORIAL);
    if (!hoja) return;

    hoja.appendRow([
      new Date(),       // A: Timestamp
      modulo,           // B: Módulo
      ugt,              // C: UGT
      ie,               // D: IE
      codInst,          // E: COD_Inst
      nivel,            // F: Nivel
      codUnico,         // G: Cod_unico
      facilitador,      // H: Facilitador/a
      registros,        // I: Registros
      detalle           // J: Detalle
    ]);
  } catch (e) {
    console.error('Error al guardar historial:', e.message);
  }
}

// ======================================================================
// sheetToObjects - Convierte sheet a array de objetos
// ======================================================================
function sheetToObjects(sheet) {
  var data = sheet.getDataRange().getValues();
  var headers = data[0].map(function(h) { return h.toString().trim(); });
  var result = [];

  for (var i = 1; i < data.length; i++) {
    var row = data[i];
    var vacia = true;
    for (var j = 0; j < row.length; j++) {
      if (row[j] !== '' && row[j] !== null && row[j] !== undefined) { vacia = false; break; }
    }
    if (vacia) continue;

    var obj = {};
    for (var k = 0; k < headers.length; k++) {
      var header = headers[k];
      var val = row[k];
      if (val instanceof Date) {
        obj[header] = Utilities.formatDate(val, 'GMT-5', "yyyy-MM-dd'T'HH:mm:ss");
      } else if (typeof val === 'string') {
        obj[header] = val.trim();
      } else {
        obj[header] = val;
      }
    }
    if (obj['COD_Inst'] !== undefined) obj['COD_Inst'] = String(obj['COD_Inst']);
    result.push(obj);
  }

  return result;
}


// ENDPOINT DASHBOARD — llamado con ?source=dashboard
// ======================================================================
function servirDatosDashboard() {
  try {
    var ss = SpreadsheetApp.openById(SPREADSHEET_ID);
    var bd = ss.getSheetByName('BD');
    var facilitadores = ss.getSheetByName('Facilitadores');
    var etapa = ss.getSheetByName('Etapa');
    var programacion = ss.getSheetByName('Programacion');
    var mirror = ss.getSheetByName('Mirror');
    var reportesRapidos = ss.getSheetByName('Reportes_Rapidos');
    var familias = ss.getSheetByName('Familias');
    var docentes = ss.getSheetByName('Docentes');
    var estudiantes = ss.getSheetByName('Estudiantes');
    var asistencia = ss.getSheetByName('Asistencia');
    var historial = ss.getSheetByName('Historial');

    var datos = {
      bd: sheetToObjects(bd),
      facilitadores: sheetToObjectsFacilitadores(facilitadores),
      etapa: sheetToObjects(etapa),
      programacion: sheetToObjects(programacion),
      mirror: sheetToObjects(mirror),
      reportes_rapidos: sheetToObjects(reportesRapidos),
      familias: sheetToObjects(familias),
      docentes: sheetToObjects(docentes),
      estudiantes: sheetToObjects(estudiantes),
      asistencia: sheetToObjects(asistencia),
      historial: sheetToObjects(historial),
      timestamp: new Date().toISOString()
    };

    return ContentService
      .createTextOutput(JSON.stringify(datos))
      .setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService
      .createTextOutput(JSON.stringify({ error: err.toString() }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

function sheetToObjects(sheet) {
  if (!sheet) return [];
  var data = sheet.getDataRange().getValues();
  if (data.length < 2) return [];
  var headers = data[0].map(function(h) {
    return String(h).toLowerCase()
      .replace(/[áäàâ]/g,'a').replace(/[éëèê]/g,'e').replace(/[íïìî]/g,'i')
      .replace(/[óöòô]/g,'o').replace(/[úüùû]/g,'u').replace(/ñ/g,'n')
      .replace(/[^a-z0-9_]/g,'_').replace(/_+/g,'_').replace(/^_|_$/g,'');
  });
  var result = [];
  for (var r = 1; r < data.length; r++) {
    var obj = {};
    var hasData = false;
    for (var c = 0; c < headers.length; c++) {
      var val = data[r][c];
      if (val !== '' && val !== null && val !== undefined) hasData = true;
      if (val instanceof Date) {
        obj[headers[c]] = Utilities.formatDate(val, 'GMT-5', "yyyy-MM-dd'T'HH:mm:ss");
      } else if (typeof val === 'string') {
        obj[headers[c]] = val.trim();
      } else {
        obj[headers[c]] = val;
      }
    }
    if (hasData) result.push(obj);
  }
  return result;
}

function sheetToObjectsFacilitadores(sheet) {
  if (!sheet) return [];
  var data = sheet.getDataRange().getValues();
  if (data.length < 2) return [];
  var result = [];
  for (var r = 1; r < data.length; r++) {
    var val = String(data[r][0] || '').trim();
    if (val) result.push({ facilitador: val });
  }
  return result;
}

function testEndpoint() {
  var result = servirDatosDashboard();
  var json = JSON.parse(result.getContent());
  console.log('BD:', json.bd.length, 'Reportes:', json.reportes_rapidos.length,
    'Programacion:', json.programacion.length);
  return json;
}
