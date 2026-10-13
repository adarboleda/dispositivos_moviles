import 'package:flutter/material.dart';
import '../../tema/tema_app.dart';

/// Título de sección (como "Popular Destinations").
class TituloSeccion extends StatelessWidget {
  final String texto;

  const TituloSeccion(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Text(
        texto,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: TravoColores.texto),
      ),
    );
  }
}
