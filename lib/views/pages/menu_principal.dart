import 'package:flutter/material.dart';
import '../../rutas.dart';
import '../../tema/tema_app.dart';
import '../atoms/atoms.dart';
import '../organisms/organisms.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  // Ícono de cada ejercicio según su id
  static const _iconos = {
    '6': Icons.directions_car_rounded,
    '7': Icons.account_balance_rounded,
    '8': Icons.savings_rounded,
    '9': Icons.casino_rounded,
    '10': Icons.linear_scale_rounded,
  };

  // Diseño
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const EncabezadoTravo(
            titulo: 'Ejercicios NRC 36873',
            subtitulo: '¿Qué ejercicio quieres resolver hoy?',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              children: [
                Row(
                  children: [
                    const Expanded(child: TituloSeccion('Ejercicios')),
                    Text(
                      '${ejercicios.length} disponibles',
                      style: const TextStyle(color: TravoColores.morado, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ],
                ),
                for (var i = 0; i < ejercicios.length; i++) _tarjeta(context, i),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjeta(BuildContext context, int i) {
    final e = ejercicios[i];
    return TarjetaEjercicio(
      id: e.id,
      titulo: e.titulo,
      descripcion: e.descripcion,
      icono: _iconos[e.id] ?? Icons.calculate_rounded,
      color: TravoColores.acentos[i % TravoColores.acentos.length],
      // LOGICA: navegar con la ruta nombrada del ejercicio
      onTap: () => Navigator.pushNamed(context, e.ruta),
    );
  }
}
