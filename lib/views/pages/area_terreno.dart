import 'package:flutter/material.dart';
import '../../logica/area_logica.dart';
import '../../tema/tema_app.dart';
import '../atoms/atoms.dart';
import '../molecules/molecules.dart';
import '../templates/templates.dart';

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
    return PlantillaPantalla(
      titulo: 'Área de un terreno',
      subtitulo: 'Ingresar medidas del terreno',
      children: [
        TarjetaTravo(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: baseCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Base (m)',
                  prefixIcon: Icon(Icons.straighten_rounded, color: TravoColores.morado),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: alturaCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Altura (m)',
                  prefixIcon: Icon(Icons.height_rounded, color: TravoColores.morado),
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(onPressed: calcular, child: const Text('Calcular')),
            ],
          ),
        ),
        TarjetaTravo(
          child: Column(
            children: [
              FilaDato('Área', '${area.toStringAsFixed(2)} m²', color: TravoColores.verde),
              FilaDato('Perímetro', '${perimetro.toStringAsFixed(2)} m', color: TravoColores.verde),
            ],
          ),
        ),
        TotalDestacado('Valor del terreno', '\$${valor.toStringAsFixed(2)}'),
      ],
    );
  }
}
