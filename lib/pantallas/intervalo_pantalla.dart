import 'package:flutter/material.dart';
import '../logica/intervalo_logica.dart';

// Ejercicio 10: intervalo y sumatoria
class IntervaloPantalla extends StatefulWidget {
  const IntervaloPantalla({super.key});

  @override
  State<IntervaloPantalla> createState() => _IntervaloPantallaState();
}

class _IntervaloPantallaState extends State<IntervaloPantalla> {
  // LOGICA
  final loCtrl = TextEditingController();
  final hiCtrl = TextEditingController();
  final numCtrl = TextEditingController();

  // Límites aceptados (null mientras el usuario está en el paso 1)
  double? lo, hi;
  String errorLimites = "";
  String errorNumero = "";
  List<double> numeros = [];
  ResultadoIntervalo? resultado;

  // Instanciar lógica
  final logica = IntervaloLogica();

  @override
  void dispose() {
    loCtrl.dispose();
    hiCtrl.dispose();
    numCtrl.dispose();
    super.dispose();
  }

  // Muestra enteros sin decimales y decimales con 2 cifras
  String _fmt(double x) => x == x.roundToDouble() ? x.toStringAsFixed(0) : x.toStringAsFixed(2);

  // Paso 1: aceptar límites. Si lo > hi se mantiene al usuario en este paso.
  void aceptarLimites() {
    final a = double.tryParse(loCtrl.text.trim());
    final b = double.tryParse(hiCtrl.text.trim());
    if (a == null || b == null) {
      setState(() => errorLimites = "Ingresa ambos límites como números");
      return;
    }
    final error = logica.validarLimites(a, b);
    if (error != null) {
      setState(() => errorLimites = "$error. Vuelve a ingresarlos.");
      return;
    }
    setState(() {
      lo = a;
      hi = b;
      errorLimites = "";
    });
  }

  // Paso 2: agregar números. El 0 termina la entrada y no cuenta como dato.
  void agregarNumero() {
    final x = double.tryParse(numCtrl.text.trim());
    if (x == null) {
      setState(() => errorNumero = "Ingresa un número válido");
      return;
    }
    numCtrl.clear();
    setState(() {
      errorNumero = "";
      if (x == 0) {
        resultado = logica.analizar(lo!, hi!, numeros);
      } else {
        numeros.add(x);
      }
    });
  }

  void reiniciar() {
    loCtrl.clear();
    hiCtrl.clear();
    numCtrl.clear();
    setState(() {
      lo = null;
      hi = null;
      errorLimites = "";
      errorNumero = "";
      numeros = [];
      resultado = null;
    });
  }

  // Diseño
  @override
  Widget build(BuildContext context) {
    final limitesAceptados = lo != null && hi != null;
    final r = resultado;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ej. 10 - Intervalo y sumatoria'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Paso 1: límites
            const Text('1. Límites del intervalo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: loCtrl,
                    enabled: !limitesAceptados,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: const InputDecoration(labelText: 'Límite inferior', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: hiCtrl,
                    enabled: !limitesAceptados,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: const InputDecoration(labelText: 'Límite superior', border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (!limitesAceptados)
              ElevatedButton(onPressed: aceptarLimites, child: const Text('Aceptar')),
            if (errorLimites.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(errorLimites, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red, fontSize: 16)),
              ),

            // Paso 2: números
            if (limitesAceptados) ...[
              Text(
                'Intervalo: (${_fmt(lo!)}, ${_fmt(hi!)})',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('2. Números (0 para terminar)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              if (r == null) ...[
                TextField(
                  controller: numCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  onSubmitted: (_) => agregarNumero(),
                  decoration: InputDecoration(
                    labelText: 'Número',
                    errorText: errorNumero.isEmpty ? null : errorNumero,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(onPressed: agregarNumero, child: const Text('Agregar')),
              ],
              const SizedBox(height: 10),
              Text('Ingresados (${numeros.length}):'),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [for (final x in numeros) Chip(label: Text(_fmt(x)))],
              ),
            ],

            // Resultados
            if (r != null) ...[
              const SizedBox(height: 20),
              Text(
                'Suma dentro del intervalo: ${r.suma.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Números fuera del intervalo: ${r.fuera}',
                style: const TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                r.igualLimite
                    ? 'Sí se introdujo un número igual a un límite'
                    : 'No se introdujo ningún número igual a los límites',
                style: const TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: reiniciar,
        backgroundColor: Colors.green,
        tooltip: 'Reiniciar',
        child: const Icon(Icons.cleaning_services),
      ),
    );
  }
}
