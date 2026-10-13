import 'package:flutter/material.dart';
import '../../logica/intervalo_logica.dart';
import '../../tema/tema_app.dart';
import '../atoms/atoms.dart';
import '../molecules/molecules.dart';
import '../templates/templates.dart';

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

    return PlantillaPantalla(
      titulo: 'Intervalo y sumatoria',
      subtitulo: 'Ejercicio 10 · Suma dentro y fuera del intervalo',
      floatingActionButton: FloatingActionButton(
        onPressed: reiniciar,
        tooltip: 'Reiniciar',
        child: const Icon(Icons.cleaning_services),
      ),
      children: [
        // Paso 1: límites
        IndicadorPaso(numero: 1, texto: 'Límites del intervalo', activo: !limitesAceptados),
        TarjetaTravo(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: loCtrl,
                      enabled: !limitesAceptados,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                      decoration: const InputDecoration(labelText: 'Límite inferior'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: hiCtrl,
                      enabled: !limitesAceptados,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                      decoration: const InputDecoration(labelText: 'Límite superior'),
                    ),
                  ),
                ],
              ),
              if (!limitesAceptados) ...[
                const SizedBox(height: 14),
                ElevatedButton(onPressed: aceptarLimites, child: const Text('Aceptar')),
              ],
              if (limitesAceptados) ...[
                const SizedBox(height: 12),
                Center(
                  child: Chip(
                    avatar: const Icon(Icons.check_circle_rounded, color: TravoColores.morado, size: 18),
                    label: Text('Intervalo: (${_fmt(lo!)}, ${_fmt(hi!)})'),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (errorLimites.isNotEmpty) AvisoTravo(errorLimites),

        // Paso 2: números
        if (limitesAceptados) ...[
          const SizedBox(height: 8),
          IndicadorPaso(numero: 2, texto: 'Números (0 para terminar)', activo: r == null),
          TarjetaTravo(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (r == null) ...[
                  TextField(
                    controller: numCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    onSubmitted: (_) => agregarNumero(),
                    decoration: InputDecoration(
                      labelText: 'Número',
                      errorText: errorNumero.isEmpty ? null : errorNumero,
                      prefixIcon: const Icon(Icons.add_circle_outline_rounded, color: TravoColores.morado),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(onPressed: agregarNumero, child: const Text('Agregar')),
                  const SizedBox(height: 14),
                ],
                Text(
                  'Ingresados (${numeros.length}):',
                  style: const TextStyle(color: TravoColores.textoSuave, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [for (final x in numeros) Chip(label: Text(_fmt(x)))],
                ),
              ],
            ),
          ),
        ],

        // Resultados
        if (r != null) ...[
          const SizedBox(height: 8),
          const TituloSeccion('Resultados'),
          TotalDestacado('Suma dentro del intervalo', r.suma.toStringAsFixed(2)),
          const SizedBox(height: 14),
          TarjetaTravo(
            child: Column(
              children: [
                FilaDato('Números fuera del intervalo', '${r.fuera}', color: TravoColores.morado),
                const Divider(height: 18),
                Row(
                  children: [
                    IconoPastel(
                      icono: r.igualLimite ? Icons.check_rounded : Icons.close_rounded,
                      color: r.igualLimite ? TravoColores.verde : TravoColores.rosa,
                      tam: 34,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        r.igualLimite
                            ? 'Sí se introdujo un número igual a un límite'
                            : 'No se introdujo ningún número igual a los límites',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
