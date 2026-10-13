/// Resultado del ejercicio 10.
class ResultadoIntervalo {
  /// Suma de los números estrictamente dentro del intervalo abierto (lo, hi).
  final double suma;

  /// Cantidad de números menores que lo o mayores que hi.
  final int fuera;

  /// true si algún número fue igual a uno de los límites.
  final bool igualLimite;

  const ResultadoIntervalo(this.suma, this.fuera, this.igualLimite);
}

/// Ejercicio 10: intervalo y sumatoria.
///
/// Decisión: el 0 es el centinela que termina la entrada y NO cuenta como dato,
/// por lo que la pantalla nunca lo agrega a la lista que recibe [analizar].
class IntervaloLogica {
  /// Devuelve un mensaje de error si el límite inferior es mayor que el superior,
  /// o null si los límites son válidos.
  String? validarLimites(double lo, double hi) {
    if (lo > hi) {
      return 'El límite inferior no puede ser mayor que el superior';
    }
    return null;
  }

  /// Analiza los números ingresados (sin el 0 centinela).
  ResultadoIntervalo analizar(double lo, double hi, List<double> numeros) {
    final error = validarLimites(lo, hi);
    if (error != null) throw ArgumentError(error);

    double suma = 0.0;
    int fuera = 0;
    bool igualLimite = false;

    for (final x in numeros) {
      if (x > lo && x < hi) {
        suma += x;
      } else if (x < lo || x > hi) {
        fuera++;
      } else {
        // x == lo o x == hi: no se suma ni cuenta como fuera
        igualLimite = true;
      }
    }
    return ResultadoIntervalo(suma, fuera, igualLimite);
  }
}
