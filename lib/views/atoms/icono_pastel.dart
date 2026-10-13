import 'package:flutter/material.dart';

/// Ícono dentro de un cuadro de color pastel.
class IconoPastel extends StatelessWidget {
  final IconData icono;
  final Color color;
  final double tam;

  const IconoPastel({super.key, required this.icono, required this.color, this.tam = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tam,
      height: tam,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(tam * 0.3),
      ),
      child: Icon(icono, color: color, size: tam * 0.55),
    );
  }
}
