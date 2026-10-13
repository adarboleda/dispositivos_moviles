import 'package:flutter/material.dart';
import '../../tema/tema_app.dart';

/// Círculo con un número. Activo: morado relleno; inactivo: lila con check.
class InsigniaNumero extends StatelessWidget {
  final int numero;
  final bool activo;
  final bool mostrarCheck;

  const InsigniaNumero(this.numero, {super.key, this.activo = false, this.mostrarCheck = false});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 15,
      backgroundColor: activo ? TravoColores.morado : const Color(0xFFE9E6FA),
      child: mostrarCheck && !activo
          ? const Icon(Icons.check_rounded, color: TravoColores.morado, size: 16)
          : Text(
              '$numero',
              style: TextStyle(
                color: activo ? Colors.white : TravoColores.morado,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
    );
  }
}
