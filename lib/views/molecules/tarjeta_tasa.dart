import 'package:flutter/material.dart';
import '../../tema/tema_app.dart';
import '../atoms/atoms.dart';

/// Tarjeta pequeña con un porcentaje grande y su etiqueta.
class TarjetaTasa extends StatelessWidget {
  final String etiqueta;
  final String porcentaje;
  final Color color;

  const TarjetaTasa({super.key, required this.etiqueta, required this.porcentaje, required this.color});

  @override
  Widget build(BuildContext context) {
    return TarjetaTravo(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Text(porcentaje, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(etiqueta, style: const TextStyle(color: TravoColores.textoSuave, fontSize: 12)),
        ],
      ),
    );
  }
}
