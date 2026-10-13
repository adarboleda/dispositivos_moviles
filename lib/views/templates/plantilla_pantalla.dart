import 'package:flutter/material.dart';
import '../organisms/organisms.dart';

/// Estructura común de cada página: encabezado morado + contenido desplazable.
class PlantillaPantalla extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final List<Widget> children;
  final Widget? floatingActionButton;

  const PlantillaPantalla({
    super.key,
    required this.titulo,
    this.subtitulo,
    required this.children,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          EncabezadoTravo(titulo: titulo, subtitulo: subtitulo),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
