import 'package:flutter/material.dart';
import '../atoms/atoms.dart';

/// Tabla de resultados dentro de una tarjeta, con desplazamiento horizontal.
class TablaTravo extends StatelessWidget {
  final DataTable tabla;

  const TablaTravo({super.key, required this.tabla});

  @override
  Widget build(BuildContext context) {
    return TarjetaTravo(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: tabla,
        ),
      ),
    );
  }
}
