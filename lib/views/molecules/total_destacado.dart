import 'package:flutter/material.dart';
import '../../tema/tema_app.dart';

/// Total grande en morado (como el precio "$245 /night").
class TotalDestacado extends StatelessWidget {
  final String etiqueta;
  final String valor;

  const TotalDestacado(this.etiqueta, this.valor, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        gradient: TravoColores.degradado,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            etiqueta,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            valor,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
