import 'package:flutter/material.dart';
import '../rutas.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  // Diseño
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicios NRC 36873'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: ejercicios.length,
        itemBuilder: (context, i) {
          final e = ejercicios[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                child: Text(e.id),
              ),
              title: Text(
                e.titulo,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(e.descripcion),
              trailing: const Icon(Icons.chevron_right),
              // LOGICA: navegar con la ruta nombrada del ejercicio
              onTap: () => Navigator.pushNamed(context, e.ruta),
            ),
          );
        },
      ),
    );
  }
}
