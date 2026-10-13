import 'package:flutter/material.dart';

import 'pantallas/impuesto_pantalla.dart';
import 'pantallas/banco_pantalla.dart';
import 'pantallas/ahorro_pantalla.dart';
import 'pantallas/adivina_pantalla.dart';
import 'pantallas/intervalo_pantalla.dart';

/// Datos de un ejercicio para mostrarlo en el menú y registrar su ruta.
class EjercicioInfo {
  final String id;
  final String titulo;
  final String descripcion;
  final String ruta;
  final WidgetBuilder pantalla;

  const EjercicioInfo({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.ruta,
    required this.pantalla,
  });
}

/// Lista de registro: para agregar un ejercicio basta con agregar una línea aquí.
/// El menú y el mapa de rutas se generan a partir de esta lista.
final List<EjercicioInfo> ejercicios = [
  EjercicioInfo(id: '6', titulo: 'Impuesto vehicular', descripcion: 'Impuesto por vehículo, por categoría y total', ruta: '/ej06', pantalla: (_) => const ImpuestoPantalla()),
  EjercicioInfo(id: '7', titulo: 'Banco Bandido de peluche', descripcion: 'Saldo, pago mínimo, pago sin intereses e intereses', ruta: '/ej07', pantalla: (_) => const BancoPantalla()),
  EjercicioInfo(id: '8', titulo: 'Ahorro anual', descripcion: 'Saldo acumulado mes a mes con depósitos variables', ruta: '/ej08', pantalla: (_) => const AhorroPantalla()),
  EjercicioInfo(id: '9', titulo: 'Adivina el número', descripcion: 'Número secreto del 1 al 100 en 10 intentos', ruta: '/ej09', pantalla: (_) => const AdivinaPantalla()),
  EjercicioInfo(id: '10', titulo: 'Intervalo y sumatoria', descripcion: 'Suma dentro del intervalo y números fuera de él', ruta: '/ej10', pantalla: (_) => const IntervaloPantalla()),
];

/// Rutas nombradas de la aplicación.
final Map<String, WidgetBuilder> rutas = {
  for (final e in ejercicios) e.ruta: e.pantalla,
};
