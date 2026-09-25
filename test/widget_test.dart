import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_flutter/main.dart';

void main() {
  testWidgets('Verificación de estados en HomePage: título inicial, cambio de título y SnackBar', (WidgetTester tester) async {
    // 1. Construir el árbol de widgets
    await tester.pumpWidget(const TallerFlutterApp());

    // 2. Comprobar estado inicial
    expect(find.text('Hola, Flutter'), findsOneWidget);
    expect(find.text('¡Título cambiado!'), findsNothing);
    expect(find.text('Michael Stiven Vasco Cárdenas'), findsOneWidget);
    expect(find.text('Código: 230231047'), findsOneWidget);

    // 3. Simular clic en el botón de alternar título
    final botonAlternar = find.byType(ElevatedButton);
    expect(botonAlternar, findsOneWidget);
    await tester.tap(botonAlternar);
    await tester.pump(); // Inicia la animación

    // 4. Comprobar que el título cambió gracias a setState()
    expect(find.text('¡Título cambiado!'), findsOneWidget);
    expect(find.text('Hola, Flutter'), findsNothing);

    // 5. Comprobar que el SnackBar se muestra
    expect(find.text('Título actualizado'), findsOneWidget);
  });
}
