import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../logica/adivina_logica.dart';
import '../../tema/tema_app.dart';
import '../atoms/atoms.dart';
import '../molecules/molecules.dart';
import '../templates/templates.dart';

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

    return PlantillaPantalla(
      titulo: 'Adivina el número',
      subtitulo: 'Ejercicio 9 · Número secreto del 1 al 100',
      children: [
        // Intentos restantes
        TarjetaTravo(
          child: Row(
            children: [
              const IconoPastel(icono: Icons.casino_rounded, color: TravoColores.naranja, tam: 48),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Intentos', style: TextStyle(color: TravoColores.textoSuave, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(
                      terminado ? 'Juego terminado' : 'Te quedan ${logica.intentosRestantes} intentos',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        TarjetaTravo(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                  prefixIcon: const Icon(Icons.tag_rounded, color: TravoColores.morado),
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(onPressed: terminado ? null : probar, child: const Text('Probar')),
            ],
          ),
        ),

        if (pista.isNotEmpty)
          AvisoTravo(pista, color: TravoColores.naranja, icono: Icons.lightbulb_outline_rounded),

        if (mensajeFinal.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: gano ? TravoColores.verde : TravoColores.error,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Icon(
                  gano ? Icons.emoji_events_rounded : Icons.sentiment_dissatisfied_rounded,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(height: 8),
                Text(
                  mensajeFinal,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],

        if (historial.isNotEmpty) ...[
          const SizedBox(height: 20),
          const TituloSeccion('Intentos'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
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
    );
  }
}
