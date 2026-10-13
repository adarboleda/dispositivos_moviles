/// Ejercicio 6: impuesto por categoría de vehículo.
/// Clave 1 paga 10%, clave 2 paga 7% y clave 3 paga 5% del valor.
class ImpuestoLogica {
  static const Map<int, double> tasas = {1: 0.10, 2: 0.07, 3: 0.05};

  // Acumuladores por clave y total general
  final Map<int, double> totalPorClave = {1: 0.0, 2: 0.0, 3: 0.0};
  double totalGeneral = 0.0;

  /// Calcula el impuesto de un vehículo.
  /// Lanza [ArgumentError] si la clave no es 1, 2 o 3, o si el valor es negativo.
  double impuesto(double valor, int clave) {
    final tasa = tasas[clave];
    if (tasa == null) {
      throw ArgumentError('Clave inválida: $clave (debe ser 1, 2 o 3)');
    }
    if (valor < 0) {
      throw ArgumentError('El valor no puede ser negativo');
    }
    return valor * tasa;
  }

  /// Calcula el impuesto, lo suma a los acumuladores y lo devuelve.
  double registrar(double valor, int clave) {
    final imp = impuesto(valor, clave);
    totalPorClave[clave] = totalPorClave[clave]! + imp;
    totalGeneral += imp;
    return imp;
  }

  /// Deja los acumuladores en cero para un nuevo cálculo.
  void reiniciar() {
    totalPorClave.updateAll((_, _) => 0.0);
    totalGeneral = 0.0;
  }
}
