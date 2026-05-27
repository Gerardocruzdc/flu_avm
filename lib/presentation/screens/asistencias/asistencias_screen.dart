import 'package:flutter/material.dart';

class AsistenciasScreen extends StatelessWidget {
  const AsistenciasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Título de la pantalla'),
      ),
      body: const Center(
        child: Text('Contenido'),
      ),
    );
  }
}