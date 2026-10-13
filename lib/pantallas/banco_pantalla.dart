import 'package:flutter/material.dart';
import '../logica/banco_logica.dart';

/// Controladores de los tres datos de un cliente.
class _FormCliente {
  final saldo = TextEditingController();
  final compras = TextEditingController();
  final pago = TextEditingController();

  void dispose() {
    saldo.dispose();
    compras.dispose();
    pago.dispose();
  }
}

/// Fila de resultado (si hay error, resultado queda en null).
class _FilaBanco {
  final int numero;
  final ResultadoCliente? resultado;
  final String? error;

  const _FilaBanco(this.numero, {this.resultado, this.error});
}

// Ejercicio 7: banco "Bandido de peluche"
class BancoPantalla extends StatefulWidget {
  const BancoPantalla({super.key});

  @override
  State<BancoPantalla> createState() => _BancoPantallaState();
}

class _BancoPantallaState extends State<BancoPantalla> {
  // LOGICA
  static const int maxClientes = 50;

  final nCtrl = TextEditingController();
  List<_FormCliente> formularios = [];
  List<_FilaBanco> filas = [];
  double totalIntereses = 0.0;
  String mensaje = "";

  // Instanciar lógica
  final logica = BancoLogica();

  @override
  void dispose() {
    nCtrl.dispose();
    _liberarFormularios();
    super.dispose();
  }

  void _liberarFormularios() {
    for (final f in formularios) {
      f.dispose();
    }
  }

  // Crea un formulario con N clientes
  void generar() {
    final n = int.tryParse(nCtrl.text);
    if (n == null || n < 1 || n > maxClientes) {
      setState(() => mensaje = "Ingresa un número de clientes entre 1 y $maxClientes");
      return;
    }
    _liberarFormularios();
    setState(() {
      formularios = List.generate(n, (_) => _FormCliente());
      filas = [];
      totalIntereses = 0.0;
      mensaje = "";
    });
  }

  // Calcula cada cliente y el total de intereses de los morosos
  void calcular() {
    final nuevas = <_FilaBanco>[];
    final validos = <Cliente>[];

    for (var i = 0; i < formularios.length; i++) {
      final f = formularios[i];
      final saldo = double.tryParse(f.saldo.text.trim());
      final compras = double.tryParse(f.compras.text.trim());
      final pago = double.tryParse(f.pago.text.trim());

      if (saldo == null || compras == null || pago == null) {
        nuevas.add(_FilaBanco(i + 1, error: "Dato vacío o no numérico"));
        continue;
      }
      final cliente = Cliente(saldoAnterior: saldo, compras: compras, pagoDepositado: pago);
      try {
        nuevas.add(_FilaBanco(i + 1, resultado: logica.calcular(cliente)));
        validos.add(cliente);
      } on ArgumentError catch (e) {
        nuevas.add(_FilaBanco(i + 1, error: e.message.toString()));
      }
    }

    final errores = nuevas.where((f) => f.error != null).length;
    setState(() {
      filas = nuevas;
      totalIntereses = logica.totalIntereses(validos);
      mensaje = errores == 0 ? "" : "$errores cliente(s) con datos inválidos no se calcularon";
    });
  }

  void limpiar() {
    nCtrl.clear();
    _liberarFormularios();
    setState(() {
      formularios = [];
      filas = [];
      totalIntereses = 0.0;
      mensaje = "";
    });
  }

  String _dinero(double x) => '\$${x.toStringAsFixed(2)}';

  Widget _campo(TextEditingController ctrl, String etiqueta) {
    return TextField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixText: '\$ ',
        border: const OutlineInputBorder(),
      ),
    );
  }

  // Diseño
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ej. 7 - Banco Bandido de peluche'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pago mínimo: 15%  ·  Sin intereses: 85%\n'
              'Morosos: +12% de interés y \$200 de multa',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número de clientes (N)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: generar, child: const Text('Generar formulario')),
            const SizedBox(height: 16),

            // Formulario por cliente
            for (var i = 0; i < formularios.length; i++)
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Cliente ${i + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      _campo(formularios[i].saldo, 'Saldo anterior'),
                      const SizedBox(height: 8),
                      _campo(formularios[i].compras, 'Monto de compras'),
                      const SizedBox(height: 8),
                      _campo(formularios[i].pago, 'Pago depositado (corte anterior)'),
                    ],
                  ),
                ),
              ),

            if (formularios.isNotEmpty)
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
                    DataColumn(label: Text('Saldo actual'), numeric: true),
                    DataColumn(label: Text('Pago mínimo'), numeric: true),
                    DataColumn(label: Text('Sin intereses'), numeric: true),
                    DataColumn(label: Text('Moroso')),
                    DataColumn(label: Text('Interés'), numeric: true),
                  ],
                  rows: [
                    for (final f in filas)
                      if (f.resultado case final r?)
                        DataRow(cells: [
                          DataCell(Text('${f.numero}')),
                          DataCell(Text(_dinero(r.saldoActual))),
                          DataCell(Text(_dinero(r.pagoMinimo))),
                          DataCell(Text(_dinero(r.pagoSinIntereses))),
                          DataCell(Text(
                            r.moroso ? 'Sí' : 'No',
                            style: TextStyle(color: r.moroso ? Colors.red : Colors.green, fontWeight: FontWeight.bold),
                          )),
                          DataCell(Text(_dinero(r.interes))),
                        ])
                      else
                        DataRow(cells: [
                          DataCell(Text('${f.numero}')),
                          DataCell(Text(f.error!, style: const TextStyle(color: Colors.red))),
                          const DataCell(Text('-')),
                          const DataCell(Text('-')),
                          const DataCell(Text('-')),
                          const DataCell(Text('-')),
                        ]),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Intereses ganados con morosos: ${_dinero(totalIntereses)}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),
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
