import 'package:flutter/material.dart';
import '../logica/area_logica.dart';

// Definir la clase principal
class AreaPantalla extends StatefulWidget {
  const AreaPantalla({super.key});

  @override
  State<AreaPantalla> createState() => _AreaPantallaState();
}

class _AreaPantallaState extends State<AreaPantalla> {
  // LOGICA
  // Mapeo de objetos
  final baseCtrl = TextEditingController();
  final alturaCtrl = TextEditingController();
  
  // Instanciar lógica
  final logica = AreaLogica();

  // Variables de resultado
  double area = 0.0, perimetro = 0.0, valor = 0.0;

  @override
  void dispose() {
    baseCtrl.dispose();
    alturaCtrl.dispose();
    super.dispose();
  }

  // Cálculos delegados en la lógica
  void calcular() {
    // Convertir de texto a número
    final base = double.tryParse(baseCtrl.text) ?? 0.0;
    final altura = double.tryParse(alturaCtrl.text) ?? 0.0;
    setState(() {
      area = logica.calcularArea(base, altura);
      perimetro = logica.calcularPerimetro(base, altura);
      valor = logica.calcularValor(area);
    });
  }

  // Diseño
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Área de un terreno'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ingresar Medidas del Terreno',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: baseCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Base (m)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: alturaCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Altura (m)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: calcular,
              child: const Text('Calcular'),
            ),
            const SizedBox(height: 20),
            Text(
              'Área: ${area.toStringAsFixed(2)} m²',
              style: const TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Perímetro: ${perimetro.toStringAsFixed(2)} m',
              style: const TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Valor del Terreno: \$${valor.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.blue, fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}