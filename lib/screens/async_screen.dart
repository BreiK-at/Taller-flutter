import 'package:flutter/material.dart';

class AsyncScreen extends StatelessWidget {
  const AsyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asincronía (Future & async/await)'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Módulo de Asincronía en construcción'),
      ),
    );
  }
}
