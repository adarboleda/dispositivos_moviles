import 'package:flutter/material.dart';
import '../atoms/atoms.dart';

/// Indicador de paso (como el progreso del checkout): insignia + título.
class IndicadorPaso extends StatelessWidget {
  final int numero;
  final String texto;
  final bool activo;

  const IndicadorPaso({super.key, required this.numero, required this.texto, required this.activo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Row(
        children: [
          InsigniaNumero(numero, activo: activo, mostrarCheck: true),
          const SizedBox(width: 10),
          Expanded(child: Text(texto, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}
