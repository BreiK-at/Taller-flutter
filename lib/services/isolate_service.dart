import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';

// Función de nivel superior (Top-level) requerida para Isolate.spawn
void _tareaPesadaTopLevel(SendPort sendPort) {
  final stopwatch = Stopwatch()..start();
  int contadorPrimos = 0;
  int sumaControl = 0;
  const int limite = 3000000; // 3 millones para carga de ~1.5 - 2.5s según CPU

  for (int i = 2; i <= limite; i++) {
    sumaControl += (i % 5);
    bool esPrimo = true;
    for (int j = 2; j * j <= i; j++) {
      if (i % j == 0) {
        esPrimo = false;
        break;
      }
    }
    if (esPrimo) {
      contadorPrimos++;
    }
  }

  stopwatch.stop();

  // Enviar mapa de resultados por el puerto de mensajería hacia el hilo principal
  sendPort.send({
    'exito': true,
    'primos': contadorPrimos,
    'sumaControl': sumaControl,
    'limite': limite,
    'tiempoMs': stopwatch.elapsedMilliseconds,
  });
}

class IsolateService {
  // 1. Ejecución con Isolate.spawn (Requisito obligatorio: Hilo secundario sin congelar UI)
  static Future<Map<String, dynamic>> ejecutarTareaEnIsolate() async {
    final receivePort = ReceivePort();
    final hora = DateTime.now().toIso8601String().substring(11, 19);

    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('⚡ [Isolate] [$hora] 1. Creando Isolate secundario con Isolate.spawn()...');

    final isolate = await Isolate.spawn(_tareaPesadaTopLevel, receivePort.sendPort);

    debugPrint('⚙️  [Isolate] [$hora] 2. Tarea CPU-bound en proceso en segundo plano.');
    debugPrint('ℹ️  Hilo principal 100% libre: Animaciones y gestos responden a 60 FPS.');

    // Esperar mensaje recibido desde el Isolate
    final dynamic datosRecibidos = await receivePort.first;
    final Map<String, dynamic> resultado = Map<String, dynamic>.from(datosRecibidos as Map);

    final horaFin = DateTime.now().toIso8601String().substring(11, 19);
    debugPrint('📩 [Isolate] [$horaFin] 3. Mensaje recibido por ReceivePort:');
    debugPrint('    • Primos encontrados: ${resultado['primos']} de ${resultado['limite']} evaluados');
    debugPrint('    • Tiempo de cálculo en Isolate: ${resultado['tiempoMs']} ms');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    // Cerrar puerto y destruir el Isolate para liberar memoria
    receivePort.close();
    isolate.kill(priority: Isolate.immediate);

    return resultado;
  }

  // 2. Ejecución síncrona en Main Thread (Demostración de bloqueo / congelamiento de UI)
  static Map<String, dynamic> ejecutarEnMainThread() {
    final stopwatch = Stopwatch()..start();
    int contadorPrimos = 0;
    int sumaControl = 0;
    const int limite = 3000000;

    for (int i = 2; i <= limite; i++) {
      sumaControl += (i % 5);
      bool esPrimo = true;
      for (int j = 2; j * j <= i; j++) {
        if (i % j == 0) {
          esPrimo = false;
          break;
        }
      }
      if (esPrimo) {
        contadorPrimos++;
      }
    }

    stopwatch.stop();

    return {
      'exito': true,
      'primos': contadorPrimos,
      'sumaControl': sumaControl,
      'limite': limite,
      'tiempoMs': stopwatch.elapsedMilliseconds,
    };
  }
}
