import 'package:flutter/material.dart';
import '../logica/impuesto_logica.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ej. 6 - Impuesto vehicular'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Clave 1: 10%   ·   Clave 2: 7%   ·   Clave 3: 5%',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número de vehículos (N)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: generar, child: const Text('Generar formulario')),
            const SizedBox(height: 16),

            // Formulario por vehículo
            for (var i = 0; i < valorCtrls.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 36,
                      child: Text('${i + 1}.', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: valorCtrls[i],
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Valor (\$)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: claveCtrls[i],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Clave (1-3)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (valorCtrls.isNotEmpty)
              ElevatedButton(onPressed: calcular, child: const Text('Calcular')),

            if (mensaje.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(mensaje, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red, fontSize: 16)),
            ],

            // Resultados
            if (filas.isNotEmpty) ...[
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
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
                            ? Text('\$${f.impuesto!.toStringAsFixed(2)}')
                            : Text(f.error!, style: const TextStyle(color: Colors.red))),
                      ]),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              for (final clave in ImpuestoLogica.tasas.keys)
                Text(
                  'Total clave $clave: \$${logica.totalPorClave[clave]!.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 8),
              Text(
                'Total general: \$${logica.totalGeneral.toStringAsFixed(2)}',
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
