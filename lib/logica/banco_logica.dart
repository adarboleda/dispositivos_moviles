/// Datos de entrada de un cliente del banco.
class Cliente {
  final double saldoAnterior;
  final double compras;
  final double pagoDepositado;

  const Cliente({
    required this.saldoAnterior,
    required this.compras,
    required this.pagoDepositado,
  });
}

/// Resultado del cálculo para un cliente.
class ResultadoCliente {
  final double saldoActual;
  final double pagoMinimo;
  final double pagoSinIntereses;
  final bool moroso;
  final double interes;
  final double multa;

  const ResultadoCliente({
    required this.saldoActual,
    required this.pagoMinimo,
    required this.pagoSinIntereses,
    required this.moroso,
    required this.interes,
    required this.multa,
  });
}

/// Ejercicio 7: banco "Bandido de peluche".
///
/// SUPUESTO (pendiente de confirmar con el docente):
///   1. pagoMinimoAnterior = 15% del saldo anterior (no hay dato del corte previo).
///   2. Es moroso si pagoDepositado < pagoMinimoAnterior.
///   3. base = saldoAnterior - pagoDepositado + compras.
///   4. Si es moroso: interes = 12% de base y multa = $200; si no, ambos son 0.
///   5. saldoActual = base + interes + multa.
///   6. pagoMinimo = 15% del saldoActual.
///   7. pagoSinIntereses = 85% del saldoActual.
///   8. El total de intereses ganados suma solo el interés de los morosos.
class BancoLogica {
  static const double tasaPagoMinimo = 0.15;
  static const double tasaSinIntereses = 0.85;
  static const double tasaInteres = 0.12;
  static const double multaMorosidad = 200.0;

  /// Calcula saldo actual, pagos e interés de un cliente.
  /// Lanza [ArgumentError] si algún dato es negativo.
  ResultadoCliente calcular(Cliente c) {
    if (c.saldoAnterior < 0 || c.compras < 0 || c.pagoDepositado < 0) {
      throw ArgumentError('Los datos del cliente no pueden ser negativos');
    }

    final pagoMinimoAnterior = tasaPagoMinimo * c.saldoAnterior; // paso 1
    final moroso = c.pagoDepositado < pagoMinimoAnterior; // paso 2
    final base = c.saldoAnterior - c.pagoDepositado + c.compras; // paso 3
    final interes = moroso ? tasaInteres * base : 0.0; // paso 4
    final multa = moroso ? multaMorosidad : 0.0;
    final saldoActual = base + interes + multa; // paso 5

    // Si el cliente pagó de más, el saldo queda a favor (negativo) y no debe nada.
    final saldoAPagar = saldoActual > 0 ? saldoActual : 0.0;

    return ResultadoCliente(
      saldoActual: saldoActual,
      pagoMinimo: tasaPagoMinimo * saldoAPagar, // paso 6
      pagoSinIntereses: tasaSinIntereses * saldoAPagar, // paso 7
      moroso: moroso,
      interes: interes,
      multa: multa,
    );
  }

  /// Total ganado por intereses con los clientes morosos (paso 8).
  double totalIntereses(List<Cliente> clientes) {
    double total = 0.0;
    for (final c in clientes) {
      total += calcular(c).interes; // interes es 0 si no es moroso
    }
    return total;
  }
}
