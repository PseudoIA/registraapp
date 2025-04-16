// lib/src/features/home/presentation/screens/ventas_diarias_screen.dart
import 'package:flutter/material.dart';

class VentasDiariasScreen extends StatelessWidget {
  const VentasDiariasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas del Día'),
        // Podríamos añadir un botón de cerrar sesión aquí después
      ),
      body: const Center(
        child: Text(
          '¡Bienvenido! Aquí irán las ventas.',
          style: TextStyle(fontSize: 20),
        ),
      ),
      // Aquí podríamos añadir el botón flotante para nueva venta después
    );
  }
}
