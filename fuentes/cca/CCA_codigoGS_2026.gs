// ======================================================================
// CCA FORMULARIO WEBAPP - Code.gs
// "Crecemos con amor - Plataforma de ingreso de datos"
// 4 módulos: Reporte al día | Asistencias | Docentes | Familias
// ======================================================================

// --- CONSTANTES ---
var SPREADSHEET_ID = '<SPREADSHEET_ID_CCA>';
var CARPETA_RAIZ_ID = '<CARPETA_RAIZ_ID>';
var NOMBRES_HOJAS = {
  1: 'Reportes_Rapidos',
  2: 'Asistencia',
  3: 'Docentes',
  4: 'Familias'
};
var HOJA_HISTORIAL = 'Historial';

// ======================================================================
// doGet - Sirve el HTML del formulario
// ======================================================================
function doGet(e) {
  // Endpoint JSON para el dashboard
  if (e && e.parameter && e.parameter.source === 'dashboard') {
  return servirDatosDashboard();
  }
  // Formulario HTML normal
  var html = HtmlService.createHtmlOutputFromFile('Index')
    .setTitle('Crecemos con amor - Plataforma de ingreso de datos')
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
  // ERROR SIMULADO 1: Range fijo A2:N36 falla si se añaden o quitan filas.
  // CORRECCIÓN: Usar getLastRow() para rango dinámico y filtrar vacíos.
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

  for (var i = 0; i < data.length; i++) {
    var row = data[i];
    var ugt = String(row[2]).trim();       // C
    var ie  = String(row[6]).trim();       // G
    if (!ugt || !ie) continue;

    ugtSet[ugt] = true;
    if (!iePorUGT[ugt]) iePorUGT[ugt] = [];
    if (iePorUGT[ugt].indexOf(ie) === -1) iePorUGT[ugt].push(ie);

    var key = ugt + '||' + ie;
    codInstPorIE[key] = String(row[1]).trim();  // B
    provinciaPorIE[key] = String(row[3]).trim(); // D
    distritoPorIE[key]  = String(row[4]).trim(); // E
    cpPorIE[key]        = String(row[5]).trim(); // F
  }

  return {
    ugt: Object.keys(ugtSet).sort(),
    iePorUGT: iePorUGT,
    codInstPorIE: codInstPorIE,
    provinciaPorIE: provinciaPorIE,
    distritoPorIE: distritoPorIE,
    cpPorIE: cpPorIE
  };
}

// ======================================================================
// getDropDownData - Dropdowns independientes
// Facilitadores P1:P8 | Ciclos Q1:Q4 | Sesiones R1:R4
// ======================================================================
function getDropDownData() {
  var ss = SpreadsheetApp.openById(SPREADSHEET_ID);
  var bd = ss.getSheetByName('BD');
  var ultFila = bd.getLastRow();
  if (ultFila < 2) ultFila = 2;

  // Facilitadores: col 16 (P)
  var facilData = bd.getRange(2, 16, ultFila - 1, 1).getValues();
  var facilitadores = [];
  for (var i = 0; i < facilData.length; i++) {
    var val = String(facilData[i][0]).trim();
    if (val) facilitadores.push(val);
  }

  // Etapas (col Q) y Actividades (col R) relacionadas
  var etapasSet = {};
  var actividadesPorEtapa = {};
  var qData = bd.getRange(2, 17, ultFila - 1, 2).getValues(); // Q y R juntas
  for (var i = 0; i < qData.length; i++) {
    var etapa = String(qData[i][0]).trim();
    var actividad = String(qData[i][1]).trim();
    if (!etapa || !actividad) continue;
    etapasSet[etapa] = true;
    if (!actividadesPorEtapa[etapa]) actividadesPorEtapa[etapa] = [];
    if (actividadesPorEtapa[etapa].indexOf(actividad) === -1) {
      actividadesPorEtapa[etapa].push(actividad);
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

    // ERROR SIMULADO 2: appendRow puede desordenar columnas si la
    // estructura de la hoja cambia. CORRECCIÓN: Mapeo explícito posición a posición.
    var fila = [
      new Date(),                         // A: Timestamp
      d.ugt,                              // B: UGT
      d.ie,                               // C: IE
      d.codInst,                          // D: COD_Inst
      d.facilitador,                      // E: Facilitador
      d.fechaSesion,                      // F: Fecha_sesion
      d.etapa,                            // G: Etapa
      d.actividad,                        // H: Actividad
      d.tema,                             // I: Tema
      '',                                 // J: Publico_asistente (ya no se usa, se deja en blanco)
      parseInt(d.asistFam) || 0,          // K: Asist_Familias
      parseInt(d.asistDoc) || 0,          // L: Asist_Docentes
      parseInt(d.asistOtros) || 0,        // M: Asist_Otros_Cant
      d.asistOtrosTexto || '',            // N: Asist_Otros_Texto
      d.desarrollo,                       // O: Desarrollo
      d.incidenciasSN,                    // P: Incidencias_SN
      d.descIncidencia || '',             // Q: Descripcion_Incidencia
      d.atencionAdicional,                // R: Atencion_Adicional
      d.descAtencion || '',               // S: Descripcion_Atencion_Adicional
      d.evidenciaUrl || ''                // T: Evidencia
    ];

    hoja.appendRow(fila);
    SpreadsheetApp.flush();

    // Historial
    var registros = 'Registro del reporte del día: ' + d.fechaSesion +
      ' en la IE: ' + d.ie + ' - ' + d.ugt;
    var detalle = d.publico + '. ' + d.etapa + ' - ' + d.actividad +
      '. Tema: ' + d.tema + '. Asistentes: ' + d.asistFam +
      ' familias; ' + d.asistDoc + ' docentes.';
    guardarHistorial('Reporte al día', d.ugt, d.ie, d.codInst,
      d.facilitador, registros, detalle);

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

    var ROOT_FOLDER_ID = '1Pda0j7go2b2fvqnI7pq2rY-PMwLUIaT8';
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
  // ERROR SIMULADO 3: Archivos pueden colisionar con mismo nombre.
  // CORRECCIÓN: Verificar existencia y reemplazar (trash el anterior).
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
      d.facilitador,          // E: Facilitador
      d.fechaInicio,          // F: Fecha_inicio
      d.fechaFin,             // G: Fecha_fin
      enlace                  // H: Enlace
    ];
    hoja.appendRow(fila);
    SpreadsheetApp.flush();

    // Historial
    var registros = 'Registro de asistencia desde ' + d.fechaInicio +
      ' hasta ' + d.fechaFin + ' en la IE: ' + d.ie + ' en ' + d.ugt;
    guardarHistorial('Registro de asistencias', d.ugt, d.ie, d.codInst,
      d.facilitador, registros, enlace);

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

    // ERROR SIMULADO 4: Múltiples appendRow para muchas filas puede
    // exceder tiempo de ejecución. CORRECCIÓN: setValues por lotes.
    // ERROR SIMULADO 5: Apellidos/Nombres pueden tener espacios extra.
    // CORRECCIÓN: trim y concatenación controlada.
    for (var i = 0; i < filas.length; i++) {
      var f = filas[i];
      var apellidos = String(f.apellidos || '').trim();
      var nombres = String(f.nombres || '').trim();

      // Saltar filas completamente vacías
      if (!apellidos && !nombres) continue;

      var apellidosNombres = (apellidos + ' ' + nombres).trim();
      var fila = [new Date(), d.ugt, d.ie, d.codInst, apellidosNombres];
      fila.push(f.grado || '');
      fila.push(parseInt(f.aniosExp) || '');
      fila.push(f.lengua || '');
      fila.push(d.fechaAplicacion);
      fila.push(d.corte);

      // Preg_1 a Preg_30 (texto de opción)
      for (var p = 1; p <= 30; p++) {
        fila.push(f['preg_' + p] || '');
      }

      // Pregunta_abierta_1 a 4
      for (var o = 1; o <= 4; o++) {
        fila.push(f['abierta_' + o] || '');
      }
      fila.push(d.facilitador);

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
      ' en la IE: ' + d.ie + ' - ' + d.ugt;
    guardarHistorial('Evaluación - Docentes', d.ugt, d.ie, d.codInst,
      d.facilitador, registros, String(total));

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
      var fila = [new Date(), d.ugt, d.ie, d.codInst, apellidosNombres];
      fila.push(f.relacion || '');
      fila.push(parseInt(f.edadCuidador) || '');
      fila.push(parseInt(f.edadNino) || '');
      fila.push(f.lengua || '');
      fila.push(d.fechaAplicacion);
      fila.push(d.corte);

      // Preg_1 a Preg_24 (texto de opción)
      for (var p = 1; p <= 24; p++) {
        fila.push(f['preg_' + p] || '');
      }

      // Pregunta_abierta_1 a 2
      for (var o = 1; o <= 2; o++) {
        fila.push(f['abierta_' + o] || '');
      }
      fila.push(d.facilitador);

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
      ' en la IE: ' + d.ie + ' - ' + d.ugt;
    guardarHistorial('Evaluación - Familias', d.ugt, d.ie, d.codInst,
      d.facilitador, registros, String(total));

    return { exito: true, msg: total + ' familia(s) registrada(s) correctamente.' };
  } catch (e) {
    return { exito: false, msg: 'Error al guardar: ' + e.message };
  } finally {
    lock.releaseLock();
  }
}

// ======================================================================
// guardarHistorial - Registro en hoja Historial (no interrumpe si falla)
// ======================================================================
function guardarHistorial(modulo, ugt, ie, codInst, facilitador, registros, detalle) {
  try {
    var ss = SpreadsheetApp.openById(SPREADSHEET_ID);
    var hoja = ss.getSheetByName(HOJA_HISTORIAL);

    // ERROR SIMULADO 6: Si la hoja Historial no existe, no debe romper
    // el flujo principal. CORRECCIÓN: try-catch silencioso + validación.
    if (!hoja) return;

    hoja.appendRow([
      new Date(),       // A: Timestamp
      modulo,           // B: Módulo
      ugt,              // C: UGT
      ie,               // D: IE
      codInst,          // E: COD_Inst
      facilitador,      // F: Facilitador
      registros,        // G: Registros
      detalle           // H: Detalle
    ]);
  } catch (e) {
    // No interrumpe el flujo principal si falla el historial
    console.error('Error al guardar historial:', e.message);
  }
}

// ======================================================================
// ENDPOINT DATOS DASHBOARD — JSON con BD, Reportes_Rapidos, Programacion
// Se activa con: ?source=dashboard
// ======================================================================
function servirDatosDashboard() {
  try {
    var ss = SpreadsheetApp.openById(SPREADSHEET_ID);
    var bd = ss.getSheetByName('BD');
    var reportes = ss.getSheetByName('Reportes_Rapidos');
    var programacion = ss.getSheetByName('Programacion');
    var historial = ss.getSheetByName('Historial');
    var docentes = ss.getSheetByName('Docentes');
    var familias = ss.getSheetByName('Familias');

    if (!bd || !reportes || !programacion) {
      return ContentService
        .createTextOutput(JSON.stringify({ error: 'Faltan hojas: BD, Reportes_Rapidos o Programacion' }))
        .setMimeType(ContentService.MimeType.JSON);
    }

    var datos = {
      bd: sheetToObjects(bd),
      reportes_rapidos: sheetToObjects(reportes),
      programacion: sheetToObjects(programacion),
      docentes: sheetToObjects(docentes),
      familias: sheetToObjects(familias),
      historial: sheetToObjects(historial),
      timestamp: new Date().toISOString()
    };

    return ContentService
      .createTextOutput(JSON.stringify(datos))
      .setMimeType(ContentService.MimeType.JSON);

  } catch (e) {
    return ContentService
      .createTextOutput(JSON.stringify({ error: e.toString() }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

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

function testEndpoint() {
  var result = servirDatosDashboard();
  var json = JSON.parse(result.getContent());
  console.log('BD registros:', json.bd.length);
  console.log('Reportes registros:', json.reportes_rapidos.length);
  console.log('Docentes:', json.docentes.length);
  console.log('Familias', json.familias.length);
  console.log('Programacion registros:', json.programacion.length);
  return json;
}