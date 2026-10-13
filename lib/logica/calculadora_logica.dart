class CalculadoraLogica {
  double suma(double a, double b) => a + b;
  double resta(double a, double b) => a - b;
  double multiplicacion(double a, double b) => a * b;
  double? division(double a, double b) => b == 0 ? null : a / b;
}

typedef Calculadora = CalculadoraLogica;
