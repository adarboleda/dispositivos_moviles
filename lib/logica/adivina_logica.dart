import 'dart:math';

/// Posibles respuestas a un intento.
enum ResultadoIntento {
  /// El número secreto es mayor que el intentado.
  mayor,

  /// El número secreto es menor que el intentado.
  menor,

  /// El usuario acertó.
  acierto,

  /// Se agotaron los intentos sin acertar.
  sinIntentos,
}

/// Ejercicio 9: adivina el número del 1 al 100 en máximo 10 intentos.
class AdivinaLogica {
  static const int minimo = 1;
  static const int maximo = 100;
  static const int maxIntentos = 10;

  final int numeroSecreto;
  int intentosUsados = 0;
  bool terminado = false;

  /// [random] es opcional para poder fijar una semilla en las pruebas.
  /// [secreto] permite forzar el número (también para pruebas).
  AdivinaLogica({Random? random, int? secreto})
      : numeroSecreto = secreto ?? (random ?? Random()).nextInt(maximo) + minimo;

  int get intentosRestantes => maxIntentos - intentosUsados;

  /// Procesa un intento y devuelve la respuesta.
  /// Lanza [ArgumentError] si n está fuera de 1..100 (no consume intento)
  /// y [StateError] si el juego ya terminó.
  ResultadoIntento intentar(int n) {
    if (terminado) throw StateError('El juego ya terminó');
    if (n < minimo || n > maximo) {
      throw ArgumentError('El número debe estar entre $minimo y $maximo');
    }

    intentosUsados++;
    if (n == numeroSecreto) {
      terminado = true;
      return ResultadoIntento.acierto;
    }
    if (intentosUsados >= maxIntentos) {
      terminado = true;
      return ResultadoIntento.sinIntentos;
    }
    return n < numeroSecreto ? ResultadoIntento.mayor : ResultadoIntento.menor;
  }
}
