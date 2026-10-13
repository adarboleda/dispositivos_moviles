import 'package:flutter/material.dart';
import '../../logica/calculadora_logica.dart';
import '../atoms/atoms.dart';
import '../molecules/molecules.dart';
import '../templates/templates.dart';

class CalculadoraPantalla extends StatefulWidget {
  const CalculadoraPantalla({super.key});

  @override
  State<CalculadoraPantalla> createState() => _CalculadoraPantallaState();
}

class _CalculadoraPantallaState extends State<CalculadoraPantalla> {
  // Logica
  // Mapeo de datos de los campos de textos
  final num1 = TextEditingController();
  final num2 = TextEditingController();
  String resultado = "";

  // Instanciar calculadora
  Calculadora calculadora = Calculadora();

  @override
  void dispose() {
    num1.dispose();
    num2.dispose();
    super.dispose();
  }

  // Método auxiliar para leer y validar ambos números
  (double, double)? _leerNumeros() {
    final a = double.tryParse(num1.text);
    final b = double.tryParse(num2.text);
    if (a == null || b == null) {
      setState(() => resultado = "Ingresa números válidos");
      return null;
    }
    return (a, b);
  }

  // Formato para mostrar resultados numéricos con 2 decimales
  String _formatear(double val) => val.toStringAsFixed(2);

  // Calculos
  void suma() {
    final par = _leerNumeros();
    if (par == null) return;
    setState(() {
      resultado = _formatear(calculadora.suma(par.$1, par.$2));
    });
  }

  void resta() {
    final par = _leerNumeros();
    if (par == null) return;
    setState(() {
      resultado = _formatear(calculadora.resta(par.$1, par.$2));
    });
  }

  void multiplicacion() {
    final par = _leerNumeros();
    if (par == null) return;
    setState(() {
      resultado = _formatear(calculadora.multiplicacion(par.$1, par.$2));
    });
  }

  void division() {
    final par = _leerNumeros();
    if (par == null) return;
    final res = calculadora.division(par.$1, par.$2);
    setState(() {
      if (res == null) {
        resultado = "No se puede dividir por cero";
      } else {
        resultado = _formatear(res);
      }
    });
  }

  void limpiar() {
    num1.clear();
    num2.clear();
    setState(() {
      resultado = "";
    });
  }

  /// Diseño
  @override
  Widget build(BuildContext context) {
    return PlantillaPantalla(
      titulo: 'Calculadora',
      subtitulo: 'Operaciones básicas con dos números',
      floatingActionButton: FloatingActionButton(
        onPressed: limpiar,
        tooltip: 'Limpiar',
        child: const Icon(Icons.cleaning_services),
      ),
      children: [
        TarjetaTravo(
          child: Column(
            children: [
              TextField(
                controller: num1,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: "Número 1"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: num2,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: "Número 2"),
              ),
            ],
          ),
        ),
        TotalDestacado('Resultado', resultado.isEmpty ? '-' : resultado),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: ElevatedButton(onPressed: suma, child: const Text("Suma"))),
            const SizedBox(width: 10),
            Expanded(child: ElevatedButton(onPressed: resta, child: const Text("Resta"))),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: ElevatedButton(onPressed: multiplicacion, child: const Text("Multiplicación"))),
            const SizedBox(width: 10),
            Expanded(child: ElevatedButton(onPressed: division, child: const Text("División"))),
          ],
        ),
      ],
    );
  }
}
