import 'package:flutter/material.dart';
import '../../tema/tema_app.dart';

/// Fila "etiqueta ........ valor" para resúmenes.
class FilaDato extends StatelessWidget {
  final String etiqueta;
  final String valor;
  final Color? color;

  const FilaDato(this.etiqueta, this.valor, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(etiqueta, style: const TextStyle(color: TravoColores.textoSuave, fontSize: 14)),
          ),
          Text(
            valor,
            style: TextStyle(
              color: color ?? TravoColores.texto,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
