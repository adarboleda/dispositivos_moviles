import 'package:flutter/material.dart';
import '../../tema/tema_app.dart';

/// Aviso con fondo pastel (errores o información): ícono + texto.
class AvisoTravo extends StatelessWidget {
  final String texto;
  final Color color;
  final IconData icono;

  const AvisoTravo(
    this.texto, {
    super.key,
    this.color = TravoColores.error,
    this.icono = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icono, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(texto, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
