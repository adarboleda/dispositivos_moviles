import 'package:flutter/material.dart';
import '../atoms/atoms.dart';

/// Tabla de resultados dentro de una tarjeta.
/// Ocupa todo el ancho de la tarjeta y, si no cabe, se desplaza en horizontal.
class TablaTravo extends StatelessWidget {
  final DataTable tabla;

  const TablaTravo({super.key, required this.tabla});

  @override
  Widget build(BuildContext context) {
    return TarjetaTravo(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              // Ancho mínimo = ancho de la tarjeta, para que no quede espacio vacío
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: tabla,
            ),
          ),
        ),
      ),
    );
  }
}
