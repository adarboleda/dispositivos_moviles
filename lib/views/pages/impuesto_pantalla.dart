import 'package:flutter/material.dart';
import '../../logica/impuesto_logica.dart';
import '../../tema/tema_app.dart';
import '../atoms/atoms.dart';
import '../molecules/molecules.dart';
import '../organisms/organisms.dart';
import '../templates/templates.dart';

/// Fila de resultado de un vehículo (si hay error, impuesto queda en null).
class _FilaImpuesto {
  final int numero;
  final String valor;
  final String clave;
  final double? impuesto;
  final String? error;

  const _FilaImpuesto(this.numero, this.valor, this.clave, {this.impuesto, this.error});
}

// Ejercicio 6: impuesto por categoría de vehículo
class ImpuestoPantalla extends StatefulWidget {
  const ImpuestoPantalla({super.key});

  @override
  State<ImpuestoPantalla> createState() => _ImpuestoPantallaState();
}

class _ImpuestoPantallaState extends State<ImpuestoPantalla> {
  // LOGICA
  static const int maxVehiculos = 50;

  // Mapeo de datos de los campos de texto
  final nCtrl = TextEditingController();
  List<TextEditingController> valorCtrls = [];
  List<TextEditingController> claveCtrls = [];

  String mensaje = "";
  List<_FilaImpuesto> filas = [];

  // Instanciar lógica
  final logica = ImpuestoLogica();

  @override
  void dispose() {
    nCtrl.dispose();
    _liberarFormulario();
    super.dispose();
  }

  void _liberarFormulario() {
    for (final c in [...valorCtrls, ...claveCtrls]) {
      c.dispose();
    }
  }

  // Crea un formulario con N vehículos
  void generar() {
    final n = int.tryParse(nCtrl.text);
    if (n == null || n < 1 || n > maxVehiculos) {
      setState(() => mensaje = "Ingresa un número de vehículos entre 1 y $maxVehiculos");
      return;
    }
    _liberarFormulario();
    setState(() {
      valorCtrls = List.generate(n, (_) => TextEditingController());
      claveCtrls = List.generate(n, (_) => TextEditingController());
      filas = [];
      mensaje = "";
    });
  }

  // Calcula el impuesto de cada vehículo, subtotales y total
  void calcular() {
    logica.reiniciar();
    final nuevas = <_FilaImpuesto>[];

    for (var i = 0; i < valorCtrls.length; i++) {
      final textoValor = valorCtrls[i].text.trim();
      final textoClave = claveCtrls[i].text.trim();
      final valor = double.tryParse(textoValor);
      final clave = int.tryParse(textoClave);

      if (valor == null || clave == null) {
        nuevas.add(_FilaImpuesto(i + 1, textoValor, textoClave, error: "Dato vacío o no numérico"));
        continue;
      }
      try {
        final imp = logica.registrar(valor, clave);
        nuevas.add(_FilaImpuesto(i + 1, valor.toStringAsFixed(2), '$clave', impuesto: imp));
      } on ArgumentError catch (e) {
        // El error se muestra en la fila sin detener el cálculo de los demás
        nuevas.add(_FilaImpuesto(i + 1, textoValor, textoClave, error: e.message.toString()));
      }
    }

    final errores = nuevas.where((f) => f.error != null).length;
    setState(() {
      filas = nuevas;
      mensaje = errores == 0 ? "" : "$errores vehículo(s) con datos inválidos no se sumaron";
    });
  }

  void limpiar() {
    nCtrl.clear();
    _liberarFormulario();
    logica.reiniciar();
    setState(() {
      valorCtrls = [];
      claveCtrls = [];
      filas = [];
      mensaje = "";
    });
  }

  // Diseño
  @override
  Widget build(BuildContext context) {
    return PlantillaPantalla(
      titulo: 'Impuesto vehicular',
      subtitulo: 'Ejercicio 6 · Impuesto por categoría y total',
      floatingActionButton: FloatingActionButton(
        onPressed: limpiar,
        tooltip: 'Limpiar',
        child: const Icon(Icons.cleaning_services),
      ),
      children: [
        // Tasas por clave
        Row(
          children: [
            Expanded(child: TarjetaTasa(etiqueta: 'Clave 1', porcentaje: '10%', color: TravoColores.naranja)),
            const SizedBox(width: 10),
            Expanded(child: TarjetaTasa(etiqueta: 'Clave 2', porcentaje: '7%', color: TravoColores.rosa)),
            const SizedBox(width: 10),
            Expanded(child: TarjetaTasa(etiqueta: 'Clave 3', porcentaje: '5%', color: TravoColores.turquesa)),
          ],
        ),
        const SizedBox(height: 16),
        TarjetaTravo(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de vehículos (N)',
                  prefixIcon: Icon(Icons.directions_car_rounded, color: TravoColores.morado),
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(onPressed: generar, child: const Text('Generar formulario')),
            ],
          ),
        ),

        // Formulario por vehículo
        if (valorCtrls.isNotEmpty) const TituloSeccion('Vehículos'),
        for (var i = 0; i < valorCtrls.length; i++)
          TarjetaTravo(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                InsigniaNumero(i + 1),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: valorCtrls[i],
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Valor (\$)'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: claveCtrls[i],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Clave (1-3)'),
                  ),
                ),
              ],
            ),
          ),

        if (valorCtrls.isNotEmpty)
          ElevatedButton(onPressed: calcular, child: const Text('Calcular')),

        if (mensaje.isNotEmpty) AvisoTravo(mensaje),

        // Resultados
        if (filas.isNotEmpty) ...[
          const SizedBox(height: 20),
          const TituloSeccion('Resultados'),
          TablaTravo(
            tabla: DataTable(
              columns: const [
                DataColumn(label: Text('#')),
                DataColumn(label: Text('Valor')),
                DataColumn(label: Text('Clave')),
                DataColumn(label: Text('Impuesto')),
              ],
              rows: [
                for (final f in filas)
                  DataRow(cells: [
                    DataCell(Text('${f.numero}')),
                    DataCell(Text(f.valor.isEmpty ? '-' : f.valor)),
                    DataCell(Text(f.clave.isEmpty ? '-' : f.clave)),
                    DataCell(f.error == null
                        ? Text('\$${f.impuesto!.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.w700))
                        : Text(f.error!, style: const TextStyle(color: TravoColores.error))),
                  ]),
              ],
            ),
          ),
          TarjetaTravo(
            child: Column(
              children: [
                for (final clave in ImpuestoLogica.tasas.keys)
                  FilaDato(
                    'Total clave $clave',
                    '\$${logica.totalPorClave[clave]!.toStringAsFixed(2)}',
                    color: TravoColores.verde,
                  ),
              ],
            ),
          ),
          TotalDestacado('Total general', '\$${logica.totalGeneral.toStringAsFixed(2)}'),
        ],
      ],
    );
  }
}
