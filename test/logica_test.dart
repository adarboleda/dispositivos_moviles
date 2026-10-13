import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:tarea2_1/logica/impuesto_logica.dart';
import 'package:tarea2_1/logica/ahorro_logica.dart';
import 'package:tarea2_1/logica/adivina_logica.dart';
import 'package:tarea2_1/logica/intervalo_logica.dart';
import 'package:tarea2_1/logica/banco_logica.dart';
import 'package:tarea2_1/logica/calculadora_logica.dart';
import 'package:tarea2_1/logica/area_logica.dart';

void main() {
  group('Ej. 6 - ImpuestoLogica', () {
    test('valor 100000 con clave 1 da impuesto 10000', () {
      expect(ImpuestoLogica().impuesto(100000, 1), closeTo(10000, 1e-9));
    });

    test('tasas de clave 2 y 3', () {
      final l = ImpuestoLogica();
      expect(l.impuesto(100000, 2), closeTo(7000, 1e-9));
      expect(l.impuesto(100000, 3), closeTo(5000, 1e-9));
    });

    test('clave inválida o valor negativo se rechaza', () {
      final l = ImpuestoLogica();
      expect(() => l.impuesto(1000, 4), throwsArgumentError);
      expect(() => l.impuesto(1000, 0), throwsArgumentError);
      expect(() => l.impuesto(-1, 1), throwsArgumentError);
    });

    test('acumula subtotales por clave y total general', () {
      final l = ImpuestoLogica();
      l.registrar(100000, 1); // 10000
      l.registrar(50000, 1); // 5000
      l.registrar(100000, 2); // 7000
      l.registrar(200000, 3); // 10000
      expect(l.totalPorClave[1], closeTo(15000, 1e-9));
      expect(l.totalPorClave[2], closeTo(7000, 1e-9));
      expect(l.totalPorClave[3], closeTo(10000, 1e-9));
      expect(l.totalGeneral, closeTo(32000, 1e-9));

      l.reiniciar();
      expect(l.totalGeneral, 0);
      expect(l.totalPorClave[1], 0);
    });
  });

  group('Ej. 8 - AhorroLogica', () {
    test('depósitos del 1 al 12 dan total 78 y marzo 6', () {
      final r = AhorroLogica().calcular(List.generate(12, (i) => i + 1.0));
      expect(r.total, 78);
      expect(r.acumulados[2], 6); // marzo
      expect(r.acumulados.length, 12);
    });

    test('rechaza cantidad distinta de 12 o depósitos negativos', () {
      final l = AhorroLogica();
      expect(() => l.calcular([1, 2, 3]), throwsArgumentError);
      expect(() => l.calcular([...List.filled(11, 1.0), -5]), throwsArgumentError);
    });
  });

  group('Ej. 7 - BancoLogica', () {
    final logica = BancoLogica();
    // Moroso: pago 100 < 15% de 1000 (150)
    const moroso = Cliente(saldoAnterior: 1000, compras: 500, pagoDepositado: 100);
    // No moroso: pago 200 >= 150
    const alCorriente = Cliente(saldoAnterior: 1000, compras: 500, pagoDepositado: 200);

    test('cliente moroso', () {
      final r = logica.calcular(moroso);
      // base = 1000 - 100 + 500 = 1400; interés = 168; multa = 200
      expect(r.moroso, isTrue);
      expect(r.interes, closeTo(168, 1e-9));
      expect(r.multa, 200);
      expect(r.saldoActual, closeTo(1768, 1e-9));
      expect(r.pagoMinimo, closeTo(265.2, 1e-9));
      expect(r.pagoSinIntereses, closeTo(1502.8, 1e-9));
    });

    test('cliente no moroso', () {
      final r = logica.calcular(alCorriente);
      // base = 1000 - 200 + 500 = 1300
      expect(r.moroso, isFalse);
      expect(r.interes, 0);
      expect(r.multa, 0);
      expect(r.saldoActual, closeTo(1300, 1e-9));
      expect(r.pagoMinimo, closeTo(195, 1e-9));
      expect(r.pagoSinIntereses, closeTo(1105, 1e-9));
    });

    test('pagar exactamente el mínimo no es moroso', () {
      const c = Cliente(saldoAnterior: 1000, compras: 0, pagoDepositado: 150);
      expect(logica.calcular(c).moroso, isFalse);
    });

    test('total de intereses suma solo morosos', () {
      expect(logica.totalIntereses([moroso, alCorriente]), closeTo(168, 1e-9));
    });

    test('pago mayor que la deuda deja saldo a favor y pagos en 0', () {
      const c = Cliente(saldoAnterior: 100, compras: 0, pagoDepositado: 300);
      final r = logica.calcular(c);
      expect(r.saldoActual, closeTo(-200, 1e-9));
      expect(r.pagoMinimo, 0);
      expect(r.pagoSinIntereses, 0);
    });

    test('datos negativos se rechazan', () {
      const c = Cliente(saldoAnterior: -1, compras: 0, pagoDepositado: 0);
      expect(() => logica.calcular(c), throwsArgumentError);
    });
  });

  group('Ej. 9 - AdivinaLogica', () {
    test('responde mayor, menor y acierto', () {
      final l = AdivinaLogica(secreto: 50);
      expect(l.intentar(30), ResultadoIntento.mayor);
      expect(l.intentar(70), ResultadoIntento.menor);
      expect(l.intentar(50), ResultadoIntento.acierto);
      expect(l.intentosUsados, 3);
      expect(l.terminado, isTrue);
    });

    test('sinIntentos después de 10 intentos fallidos', () {
      final l = AdivinaLogica(secreto: 50);
      for (var i = 0; i < 9; i++) {
        expect(l.intentar(1), ResultadoIntento.mayor);
      }
      expect(l.intentosRestantes, 1);
      expect(l.intentar(1), ResultadoIntento.sinIntentos);
      expect(l.terminado, isTrue);
      expect(() => l.intentar(50), throwsStateError);
    });

    test('acertar en el intento 10 cuenta como acierto', () {
      final l = AdivinaLogica(secreto: 7);
      for (var i = 0; i < 9; i++) {
        l.intentar(100);
      }
      expect(l.intentar(7), ResultadoIntento.acierto);
    });

    test('número fuera de rango se rechaza sin gastar intento', () {
      final l = AdivinaLogica(secreto: 50);
      expect(() => l.intentar(0), throwsArgumentError);
      expect(() => l.intentar(101), throwsArgumentError);
      expect(l.intentosUsados, 0);
    });

    test('con Random con semilla el secreto es reproducible y está en 1..100', () {
      final a = AdivinaLogica(random: Random(42)).numeroSecreto;
      final b = AdivinaLogica(random: Random(42)).numeroSecreto;
      expect(a, b);
      expect(a, inInclusiveRange(1, 100));
    });
  });

  group('Ej. 10 - IntervaloLogica', () {
    test('lo=5, hi=10, [3,5,7,10,12] da suma 7, fuera 2 y límite true', () {
      final r = IntervaloLogica().analizar(5, 10, [3, 5, 7, 10, 12]);
      expect(r.suma, 7);
      expect(r.fuera, 2);
      expect(r.igualLimite, isTrue);
    });

    test('sin números iguales a los límites la bandera es false', () {
      final r = IntervaloLogica().analizar(0, 100, [1, 2, 3, 200]);
      expect(r.suma, 6);
      expect(r.fuera, 1);
      expect(r.igualLimite, isFalse);
    });

    test('lo=10, hi=5 devuelve error', () {
      final l = IntervaloLogica();
      expect(l.validarLimites(10, 5), isNotNull);
      expect(l.validarLimites(5, 10), isNull);
      expect(() => l.analizar(10, 5, [7]), throwsArgumentError);
    });
  });

  group('CalculadoraLogica', () {
    final calc = CalculadoraLogica();

    test('operaciones básicas', () {
      expect(calc.suma(10, 5), 15);
      expect(calc.resta(10, 5), 5);
      expect(calc.multiplicacion(10, 5), 50);
      expect(calc.division(10, 5), 2);
    });

    test('división entre cero devuelve null', () {
      expect(calc.division(10, 0), isNull);
      expect(calc.division(0, 0), isNull);
    });
  });

  group('AreaLogica', () {
    final l = AreaLogica();

    test('cálculo de área, perímetro y valor con precio por defecto', () {
      expect(l.calcularArea(10, 5), 50);
      expect(l.calcularPerimetro(10, 5), 30);
      expect(l.calcularValor(50), 25000); // 50 * 500
    });
  });
}
