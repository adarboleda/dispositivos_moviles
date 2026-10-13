import 'package:flutter/material.dart';
import '../logica/calculadora_logica.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: num1,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Número 1",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: num2,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Número 2",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              resultado.isEmpty ? "Resultado" : "Resultado: $resultado",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: suma,
                  child: const Text("Suma"),
                ),
                ElevatedButton(
                  onPressed: resta,
                  child: const Text("Resta"),
                ),
                ElevatedButton(
                  onPressed: multiplicacion,
                  child: const Text("Multiplicación"),
                ),
                ElevatedButton(
                  onPressed: division,
                  child: const Text("División"),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: limpiar,
        backgroundColor: Colors.green,
        tooltip: 'Limpiar',
        child: const Icon(Icons.cleaning_services),
      ),
    );
  }
}