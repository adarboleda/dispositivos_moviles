import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tarea2_1/main.dart';
import 'package:tarea2_1/rutas.dart';

void main() {
  testWidgets('El menú navega a cada ejercicio y regresa', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Ejercicios NRC 36873'), findsWidgets);

    for (final e in ejercicios) {
      // Ida: desplazarse hasta la card del ejercicio y tocarla
      await tester.ensureVisible(find.text(e.titulo));
      await tester.pumpAndSettle();
      await tester.tap(find.text(e.titulo));
      await tester.pumpAndSettle();
      expect(find.byType(BackButton), findsOneWidget);

      // Vuelta: botón atrás del AppBar
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text(e.titulo), findsOneWidget);
    }
  });
}
