import 'package:flutter/material.dart';
import '../../tema/tema_app.dart';

/// Encabezado con degradado morado y esquinas inferiores redondeadas.
class EncabezadoTravo extends StatelessWidget {
  final String titulo;
  final String? subtitulo;

  const EncabezadoTravo({super.key, required this.titulo, this.subtitulo});

  @override
  Widget build(BuildContext context) {
    final puedeVolver = Navigator.of(context).canPop();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: TravoColores.degradado,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Stack(
        children: [
          // Círculos decorativos del fondo
          Positioned(right: -40, top: -30, child: _circulo(160)),
          Positioned(left: -50, bottom: -60, child: _circulo(140)),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              child: Column(
                children: [
                  SizedBox(
                    height: 44,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: puedeVolver
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.22),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const BackButton(color: Colors.white),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    titulo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitulo != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitulo!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circulo(double tam) => Container(
        width: tam,
        height: tam,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 18),
        ),
      );
}
