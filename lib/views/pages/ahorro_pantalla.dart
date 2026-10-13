import 'package:flutter/material.dart';
import '../../logica/ahorro_logica.dart';
import '../../tema/tema_app.dart';
import '../atoms/atoms.dart';
import '../molecules/molecules.dart';
import '../organisms/organisms.dart';
import '../templates/templates.dart';

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
    return PlantillaPantalla(
      titulo: 'Ahorro anual',
      subtitulo: 'Ejercicio 8 · Depósito al final de cada mes',
      floatingActionButton: FloatingActionButton(
        onPressed: limpiar,
        tooltip: 'Limpiar',
        child: const Icon(Icons.cleaning_services),
      ),
      children: [
        const TituloSeccion('Depósitos mensuales'),
        TarjetaTravo(
          child: Column(
            children: [
              for (var i = 0; i < 12; i++)
                Padding(
                  padding: EdgeInsets.only(bottom: i == 11 ? 0 : 10),
                  child: TextField(
                    controller: depositoCtrls[i],
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: AhorroLogica.meses[i],
                      prefixText: '\$ ',
                      errorText: errores[i],
                      prefixIcon: const Icon(Icons.calendar_month_rounded, color: TravoColores.morado),
                    ),
                  ),
                ),
            ],
          ),
        ),
        ElevatedButton(onPressed: calcular, child: const Text('Calcular')),

        if (mensaje.isNotEmpty) AvisoTravo(mensaje),

        // Resultados
        if (r != null) ...[
          const SizedBox(height: 20),
          const TituloSeccion('Saldo acumulado'),
          TablaTravo(
            tabla: DataTable(
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
                    DataCell(Text(
                      '\$${r.acumulados[i].toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: TravoColores.morado),
                    )),
                  ]),
              ],
            ),
          ),
          TotalDestacado('Total ahorrado', '\$${r.total.toStringAsFixed(2)}'),
        ],
      ],
    );
  }
}
