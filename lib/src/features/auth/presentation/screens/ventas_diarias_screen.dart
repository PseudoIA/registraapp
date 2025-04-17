// lib/src/features/home/presentation/screens/ventas_diarias_screen.dart
import 'package:flutter/material.dart';
import 'package:registraap/src/features/sales/presentation/widgets/seleccionar_tipo_venta_dialog.dart';
import 'package:registraap/src/features/sales/presentation/screens/nueva_venta_screen.dart';
import 'package:registraap/src/core/data/models/venta.dart';

class VentasDiariasScreen extends StatelessWidget {
  const VentasDiariasScreen({super.key});

  // --- Función auxiliar para mostrar el diálogo del formulario ---
  // Recibe el contexto y el tipo de venta seleccionado
  Future<void> _mostrarFormularioVenta(
    BuildContext context,
    TipoVenta tipo,
  ) async {
    // Verifica si el contexto sigue válido antes de navegar
    if (!context.mounted) return;

    // Usa Navigator.push para ir a la nueva PANTALLA
    // El <bool?> es opcional, por si NuevaVentaScreen devolviera algo con pop
    final result = await Navigator.push<bool?>(
      context,
      MaterialPageRoute(
        // Crea la instancia de la nueva pantalla, pasándole el tipo
        builder: (context) => NuevaVentaScreen(tipoVenta: tipo),
      ),
    );

    // TODO: Refrescar la lista de ventas aquí si result indica que se guardó algo
    if (result == true) {
      // Asumiendo que NuevaVentaScreen devuelve true al guardar
      print('Venta guardada, refrescando lista...');
    }
  }
  // --- Fin función auxiliar ---

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
      // --- Añadimos el Botón Flotante ---
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Convertimos onPressed a async
          // Capturamos el contexto ANTES del primer await
          final BuildContext currentContext = context;

          // 1. Muestra el diálogo de selección y espera el resultado (TipoVenta o null)
          final selectedType = await showDialog<TipoVenta>(
            context: currentContext,
            builder: (BuildContext dialogContext) {
              return const SeleccionarTipoVentaDialog();
            },
          );

          // 2. Verifica el resultado y si el widget sigue montado
          if (!currentContext.mounted)
            return; // No hagas nada si la pantalla ya no existe

          // 3. Si el usuario seleccionó un tipo (no canceló)
          if (selectedType != null) {
            print('Tipo de venta seleccionado: $selectedType');
            // Llama a la función auxiliar para mostrar el formulario principal,
            // pasándole el tipo seleccionado.
            await _mostrarFormularioVenta(currentContext, selectedType);
          } else {
            print('Selección de tipo de venta cancelada.');
          }
        },
        tooltip: 'Nueva Venta', // Texto que aparece al dejar presionado
        child: const Icon(Icons.add), // Icono del botón
      ),
      // --- Fin FloatingActionButton ---
    );
  }
}
