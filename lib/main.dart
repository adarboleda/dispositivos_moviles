import 'package:flutter/material.dart';

import 'views/pages/menu_principal.dart';
import 'rutas.dart';
import 'tema/tema_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ejercicios NRC 36873',
      theme: temaTravo(),
      home: const MenuPrincipal(),
      routes: rutas,
    );
  }
}
