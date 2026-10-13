/// Resultado del ejercicio 8: saldo acumulado de cada mes y total del año.
class ResultadoAhorro {
  final List<double> acumulados;
  final double total;

  const ResultadoAhorro(this.acumulados, this.total);
}

/// Ejercicio 8: ahorro anual con depósitos variables al final de cada mes.
class AhorroLogica {
  static const List<String> meses = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
  ];

  /// Recibe los 12 depósitos y devuelve el saldo acumulado por mes y el total.
  /// Lanza [ArgumentError] si no son 12 depósitos o si alguno es negativo.
  ResultadoAhorro calcular(List<double> depositos) {
    if (depositos.length != 12) {
      throw ArgumentError('Se requieren 12 depósitos');
    }
    if (depositos.any((d) => d < 0)) {
      throw ArgumentError('Los depósitos no pueden ser negativos');
    }

    final acumulados = <double>[];
    double saldo = 0.0;
    for (final d in depositos) {
      saldo += d;
      acumulados.add(saldo);
    }
    return ResultadoAhorro(acumulados, saldo);
  }
}
