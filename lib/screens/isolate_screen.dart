import 'package:flutter/material.dart';

class IsolateScreen extends StatelessWidget {
  const IsolateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolate (Tarea Pesada)'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Módulo de Isolate en construcción'),
      ),
    );
  }
}
