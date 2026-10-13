import 'package:flutter/material.dart';
import '../logica/ahorro_logica.dart';

// Ejercicio 8: ahorro anual con depósitos variables
class AhorroPantalla extends StatefulWidget {
  const AhorroPantalla({super.key});

  @override
  State<AhorroPantalla> createState() => _AhorroPantallaState();
}

class _AhorroPantallaState extends State<AhorroPantalla> {
  // LOGICA
  // Un campo por mes
  final depositoCtrls = List.generate(12, (_) => TextEditingController());
  List<String?> errores = List.filled(12, null);
  List<double> depositos = [];
  ResultadoAhorro? resultado;
  String mensaje = "";

  // Instanciar lógica
  final logica = AhorroLogica();

  @override
  void dispose() {
    for (final c in depositoCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  // Lee los 12 depósitos y calcula el saldo acumulado
  void calcular() {
    final leidos = <double>[];
    final nuevosErrores = List<String?>.filled(12, null);

    for (var i = 0; i < 12; i++) {
      final d = double.tryParse(depositoCtrls[i].text.trim());
      if (d == null) {
        nuevosErrores[i] = 'Ingresa un número';
      } else if (d < 0) {
        nuevosErrores[i] = 'No puede ser negativo';
      } else {
        leidos.add(d);
      }
    }

    if (nuevosErrores.any((e) => e != null)) {
      setState(() {
        errores = nuevosErrores;
        resultado = null;
        mensaje = "Revisa los meses marcados en rojo";
      });
      return;
    }

    setState(() {
      errores = nuevosErrores;
      depositos = leidos;
      resultado = logica.calcular(leidos);
      mensaje = "";
    });
  }

  void limpiar() {
    for (final c in depositoCtrls) {
      c.clear();
    }
    setState(() {
      errores = List.filled(12, null);
      depositos = [];
      resultado = null;
      mensaje = "";
    });
  }

  // Diseño
  @override
  Widget build(BuildContext context) {
    final r = resultado;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ej. 8 - Ahorro anual'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Depósito al final de cada mes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < 12; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: depositoCtrls[i],
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: AhorroLogica.meses[i],
                    prefixText: '\$ ',
                    errorText: errores[i],
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ElevatedButton(onPressed: calcular, child: const Text('Calcular')),

            if (mensaje.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(mensaje, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red, fontSize: 16)),
            ],

            // Resultados
            if (r != null) ...[
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Mes')),
                    DataColumn(label: Text('Depósito'), numeric: true),
                    DataColumn(label: Text('Saldo acumulado'), numeric: true),
                  ],
                  rows: [
                    for (var i = 0; i < 12; i++)
                      DataRow(cells: [
                        DataCell(Text(AhorroLogica.meses[i])),
                        DataCell(Text('\$${depositos[i].toStringAsFixed(2)}')),
                        DataCell(Text('\$${r.acumulados[i].toStringAsFixed(2)}')),
                      ]),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Total ahorrado: \$${r.total.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.blue, fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ],
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
