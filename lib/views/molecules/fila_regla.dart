import 'package:flutter/material.dart';
import '../../tema/tema_app.dart';
import '../atoms/atoms.dart';

/// Fila con ícono pastel, descripción y valor (como las amenidades del hotel).
class FilaRegla extends StatelessWidget {
  final IconData icono;
  final Color color;
  final String texto;
  final String valor;

  const FilaRegla({
    super.key,
    required this.icono,
    required this.color,
    required this.texto,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          IconoPastel(icono: icono, color: color, tam: 34),
          const SizedBox(width: 12),
          Expanded(child: Text(texto, style: const TextStyle(color: TravoColores.textoSuave))),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
