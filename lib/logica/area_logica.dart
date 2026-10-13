/// Lógica para cálculo de área, perímetro y valor de un terreno rectangular.
class AreaLogica {
  static const double precioPorM2 = 500.0;

  double calcularArea(double base, double altura) => base * altura;

  double calcularPerimetro(double base, double altura) => 2 * (base + altura);

  double calcularValor(double area, {double precio = precioPorM2}) => area * precio;
}
