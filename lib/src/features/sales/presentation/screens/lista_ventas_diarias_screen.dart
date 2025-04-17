// lib/src/features/sales/presentation/screens/lista_ventas_diarias_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:registraap/src/core/data/models/local_database.dart';
import 'package:registraap/src/core/data/models/venta.dart' as model;
import 'package:registraap/src/features/sales/presentation/widgets/venta_list_item.dart';

class ListaVentasDiariasScreen extends StatefulWidget {
  const ListaVentasDiariasScreen({super.key});

  @override
  State<ListaVentasDiariasScreen> createState() =>
      _ListaVentasDiariasScreenState();
}

class _ListaVentasDiariasScreenState extends State<ListaVentasDiariasScreen> {
  // --- Función para obtener las ventas ---
  // ESTA FUNCIÓN DEBE ESTAR AQUÍ, AL NIVEL DE LA CLASE
  Future<List<Venta>> _fetchVentasDelDia() {
    // Devuelve directamente el Future de la base de datos
    return database.getVentasDelDia(DateTime.now());
  }

  // --- Método listener ---
  // ESTE MÉTODO DEBE ESTAR AQUÍ, AL NIVEL DE LA CLASE
  void _onVentasUpdated() {
    if (mounted) {
      print("Notifier detectó cambio, refrescando lista de ventas...");
      setState(() {
        // Forzar reconstrucción para que FutureBuilder recargue
      });
    }
  }

  // --- initState ---
  // ESTE MÉTODO DEBE ESTAR AQUÍ, AL NIVEL DE LA CLASE
  @override
  void initState() {
    super.initState();
    ventasUpdateNotifier.addListener(_onVentasUpdated);
    print("Listener añadido a ventasUpdateNotifier.");
  }

  // --- dispose ---
  // ESTE MÉTODO DEBE ESTAR AQUÍ, AL NIVEL DE LA CLASE
  @override
  void dispose() {
    ventasUpdateNotifier.removeListener(_onVentasUpdated);
    print("Listener removido de ventasUpdateNotifier.");
    super.dispose();
  }

  // --- build ---
  // SOLO DEBE HABER UNA DEFINICIÓN DEL MÉTODO build(), AL NIVEL DE LA CLASE
  @override
  Widget build(BuildContext context) {
    print("Construyendo ListaVentasDiariasScreen");
    return FutureBuilder<List<Venta>>(
      future: _fetchVentasDelDia(), // Correcto: llama a la función
      builder: (context, snapshot) {
        // 1. Mientras carga
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // 2. Si hubo un error
        else if (snapshot.hasError) {
          print('Error cargando ventas: ${snapshot.error}');
          return Center(
            child: Text('Error al cargar ventas: ${snapshot.error}'),
          );
        }
        // 3. Si los datos llegaron
        else if (snapshot.hasData) {
          final List<Venta> ventas = snapshot.data!;

          // 3.1 Si la lista está vacía
          if (ventas.isEmpty) {
            return const Center(
              child: Text('No hay ventas registradas hoy. ¡Usa el botón +!'),
            );
          }

          // 3.2 Si hay ventas, mostramos la lista
          // final double total = _calcularTotal(ventas); // TODO: Calcular total

          return RefreshIndicator(
            onRefresh: () async {
              // El setState aquí sigue siendo válido para el RefreshIndicator
              setState(() {});
            },
            child: Column(
              children: [
                // TODO: Widget para mostrar el total del día aquí
                Expanded(
                  child: ListView.builder(
                    itemCount: ventas.length,
                    itemBuilder: (context, index) {
                      final venta = ventas[index];
                      return VentaListItem(venta: venta);
                    },
                  ),
                ),
              ],
            ),
          );
        }
        // 4. Estado inesperado
        else {
          return const Center(
            child: Text('Estado inesperado al cargar ventas.'),
          );
        }
      },
    ); // Fin FutureBuilder
  } // Fin build
} // Fin _ListaVentasDiariasScreenState
