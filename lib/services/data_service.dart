import 'dart:async';
import 'package:flutter/material.dart';

class TareaAsincrona {
  final String id;
  final String titulo;
  final String descripcion;
  final String categoria;
  final IconData icono;
  final String tiempoEstimado;

  const TareaAsincrona({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.icono,
    required this.tiempoEstimado,
  });
}

class DataService {
  // Servicio simulado para obtener datos asincronos con Future y async/await
  static Future<List<TareaAsincrona>> consultarTareasRemotas({bool forzarError = false}) async {
    final horaInicio = DateTime.now().toIso8601String().substring(11, 19);
    
    // 1. Log de ejecucion: ANTES de iniciar la espera asincrona
    debugPrint('-----------------------------------------------------');
    debugPrint('[1. ANTES] [$horaInicio] Iniciando peticion asincrona con Future...');
    debugPrint('[INFO] Hilo principal libre. La interfaz permanece interactiva.');

    // 2. Log de ejecucion: DURANTE el proceso asincrono
    debugPrint('[2. DURANTE] Esperando respuesta de red con Future.delayed (2500 ms)...');
    
    // Retardo simulado de red (2.5 segundos)
    await Future.delayed(const Duration(milliseconds: 2500));

    // 3. Log de ejecucion: DESPUES de finalizar la espera
    final horaFin = DateTime.now().toIso8601String().substring(11, 19);
    if (forzarError) {
      debugPrint('[3. DESPUES - ERROR] [$horaFin] Fallo la consulta remota simulada.');
      debugPrint('-----------------------------------------------------');
      throw Exception('Fallo de conexion simulado: No se pudo conectar al endpoint.');
    }

    debugPrint('[3. DESPUES - EXITO] [$horaFin] Respuesta recibida satisfactoriamente con 4 registros.');
    debugPrint('-----------------------------------------------------');

    return const [
      TareaAsincrona(
        id: 'T-01',
        titulo: 'Sincronizacion de Base de Datos',
        descripcion: 'Carga de transacciones locales pendientes en SQLite.',
        categoria: 'Base de Datos',
        icono: Icons.cloud_sync,
        tiempoEstimado: '2.5s',
      ),
      TareaAsincrona(
        id: 'T-02',
        titulo: 'Autenticacion con Token JWT',
        descripcion: 'Validacion de credenciales con refresh token activo.',
        categoria: 'Seguridad',
        icono: Icons.security,
        tiempoEstimado: '1.8s',
      ),
      TareaAsincrona(
        id: 'T-03',
        titulo: 'Descarga de Recursos Multimedia',
        descripcion: 'Obtencion de imagenes y cache de assets del taller.',
        categoria: 'Almacenamiento',
        icono: Icons.photo_library,
        tiempoEstimado: '3.1s',
      ),
      TareaAsincrona(
        id: 'T-04',
        titulo: 'Notificaciones Push Remotas',
        descripcion: 'Verificacion de eventos en cola de mensajeria.',
        categoria: 'Servicios',
        icono: Icons.mark_chat_unread,
        tiempoEstimado: '1.2s',
      ),
    ];
  }
}
