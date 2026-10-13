import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../logica/adivina_logica.dart';

// Ejercicio 9: adivina el número
class AdivinaPantalla extends StatefulWidget {
  const AdivinaPantalla({super.key});

  @override
  State<AdivinaPantalla> createState() => _AdivinaPantallaState();
}

class _AdivinaPantallaState extends State<AdivinaPantalla> {
  // LOGICA
  final numCtrl = TextEditingController();
  String pista = "";
  String error = "";
  String mensajeFinal = "";
  bool gano = false;
  List<int> historial = [];

  // Instanciar lógica
  AdivinaLogica logica = AdivinaLogica();

  @override
  void dispose() {
    numCtrl.dispose();
    super.dispose();
  }

  void probar() {
    if (logica.terminado) return;

    final n = int.tryParse(numCtrl.text.trim());
    if (n == null || n < AdivinaLogica.minimo || n > AdivinaLogica.maximo) {
      setState(() => error = "Ingresa un entero del 1 al 100");
      return;
    }

    final resultado = logica.intentar(n);
    numCtrl.clear();
    setState(() {
      error = "";
      historial.add(n);
      switch (resultado) {
        case ResultadoIntento.mayor:
          pista = "El número es mayor que $n";
        case ResultadoIntento.menor:
          pista = "El número es menor que $n";
        case ResultadoIntento.acierto:
          pista = "";
          gano = true;
          mensajeFinal = "¡Acertaste! El número era ${logica.numeroSecreto}. "
              "Lo lograste en ${logica.intentosUsados} intento(s).";
        case ResultadoIntento.sinIntentos:
          pista = "";
          gano = false;
          mensajeFinal = "Se acabaron los intentos. El número secreto era ${logica.numeroSecreto}.";
      }
    });
  }

  void nuevoJuego() {
    numCtrl.clear();
    setState(() {
      logica = AdivinaLogica();
      pista = "";
      error = "";
      mensajeFinal = "";
      gano = false;
      historial = [];
    });
  }

  // Diseño
  @override
  Widget build(BuildContext context) {
    final terminado = logica.terminado;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ej. 9 - Adivina el número'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Adivina el número secreto del 1 al 100',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: numCtrl,
              enabled: !terminado,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              onSubmitted: (_) => probar(),
              decoration: InputDecoration(
                labelText: 'Tu número',
                errorText: error.isEmpty ? null : error,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: terminado ? null : probar, child: const Text('Probar')),
            const SizedBox(height: 16),

            if (pista.isNotEmpty)
              Text(
                pista,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
            if (!terminado) ...[
              const SizedBox(height: 8),
              Text(
                'Te quedan ${logica.intentosRestantes} intentos',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ],

            if (mensajeFinal.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                mensajeFinal,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: gano ? Colors.green : Colors.red,
                ),
              ),
            ],

            if (historial.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Intentos:'),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [for (final n in historial) Chip(label: Text('$n'))],
              ),
            ],

            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: nuevoJuego,
              icon: const Icon(Icons.refresh),
              label: const Text('Nuevo juego'),
            ),
          ],
        ),
      ),
    );
  }
}
