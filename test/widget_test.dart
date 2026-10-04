import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_flutter/main.dart';
import 'package:taller_flutter/services/data_service.dart';

void main() {
  testWidgets('Navegacion entre modulos del taller y prueba de cronometro', (WidgetTester tester) async {
    await tester.pumpWidget(const TallerFlutterApp());
    await tester.pump(const Duration(milliseconds: 200));

    // 1. Verificar que inicia en la pantalla de Asincronia (tab index 1)
    expect(find.text('Asincronia (Future / await)'), findsOneWidget);
    expect(find.text('Consultar (Exito)'), findsOneWidget);

    // 2. Navegar al Cronometro mediante icono
    final cronometroIcon = find.byIcon(Icons.timer_outlined);
    expect(cronometroIcon, findsOneWidget);
    await tester.tap(cronometroIcon);
    await tester.pump(const Duration(milliseconds: 200));

    // 3. Verificar estado inicial del cronometro
    expect(find.text('00:00.0'), findsOneWidget);
    expect(find.text('Iniciar'), findsOneWidget);

    // 4. Iniciar el cronometro y avanzar el tiempo simulado
    await tester.tap(find.text('Iniciar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // El tiempo ya no debe ser 00:00.0
    expect(find.text('00:00.0'), findsNothing);
    expect(find.text('Pausar'), findsOneWidget);

    // 5. Pausar el cronometro
    await tester.tap(find.text('Pausar'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Reanudar'), findsOneWidget);

    // 6. Reiniciar el cronometro
    await tester.tap(find.text('Reiniciar'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('00:00.0'), findsOneWidget);

    // 7. Navegar a la pantalla de Isolate mediante icono
    final isolateIcon = find.byIcon(Icons.precision_manufacturing_outlined);
    expect(isolateIcon, findsOneWidget);
    await tester.tap(isolateIcon);
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Isolate (Tarea Pesada)'), findsOneWidget);
    expect(find.text('Ejecutar Tarea Pesada con Isolate.spawn()'), findsOneWidget);
  });

  test('Prueba unitaria de DataService con Future.delayed', () async {
    final tareas = await DataService.consultarTareasRemotas(forzarError: false);
    expect(tareas.isNotEmpty, true);
    expect(tareas.length, 4);
    expect(tareas.first.id, 'T-01');
  });
}
