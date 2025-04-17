// lib/src/features/home/presentation/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesitamos formatear moneda
import 'package:registraap/src/core/data/models/local_database.dart'; // Acceso a DB y Notifier

// 1. Convertimos a StatefulWidget
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // 6. Añadimos listener para el Notifier (igual que en ListaVentasDiariasScreen)
  void _onVentasUpdated() {
    if (mounted) {
      print("Notifier detectó cambio en Dashboard, refrescando resumen...");
      // Llamamos a setState para que FutureBuilder se reconstruya y recargue datos
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    // Nos suscribimos a las actualizaciones
    ventasUpdateNotifier.addListener(_onVentasUpdated);
    print("Listener de ventas añadido en DashboardScreen.");
  }

  @override
  void dispose() {
    // Nos desuscribimos para evitar fugas de memoria
    ventasUpdateNotifier.removeListener(_onVentasUpdated);
    print("Listener de ventas removido de DashboardScreen.");
    super.dispose();
  }

  // 2. Función para obtener las ventas del día (igual que en ListaVentasDiariasScreen)
  Future<List<Venta>> _fetchVentasDelDia() {
    // Podríamos añadir manejo de errores aquí si quisiéramos
    return database.getVentasDelDia(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    print("Construyendo DashboardScreen");
    // Usamos un Padding general para la pantalla
    return Padding(
      padding: const EdgeInsets.all(16.0),
      // 3. Usamos FutureBuilder para cargar los datos asíncronamente
      child: FutureBuilder<List<Venta>>(
        future: _fetchVentasDelDia(), // Llama a la función para obtener datos
        builder: (context, snapshot) {
          // --- Manejo de Estados de Carga y Error ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mientras carga, mostramos un indicador.
            // Podríamos mostrar un esqueleto de Card (Shimmer) para mejor UX.
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Si hay error, lo mostramos.
            print('Error cargando resumen: ${snapshot.error}');
            return Center(
              child: Text('Error al cargar resumen: ${snapshot.error}'),
            );
          }
          // --- Cuando los datos están listos ---
          else if (snapshot.hasData) {
            final List<Venta> ventas = snapshot.data!;
            final double totalDelDia = ventas.fold(
              0.0,
              (sum, venta) => sum + venta.valor,
            );
            final int numeroDeVentas = ventas.length;
            final formatoMoneda = NumberFormat.currency(
              locale: 'es_CO',
              symbol: '\$',
              decimalDigits: 0,
            );
            final String totalFormateado = formatoMoneda.format(totalDelDia);

            // 5. Mostramos la información en una Card
            // ¡Quitamos el 'Center' que estaba aquí!
            return Card(
              // <--- La Card ahora es retornada directamente
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumen de Hoy',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Divider(height: 24, thickness: 1),
                    Text(
                      'Total Vendido:',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                    ),
                    Text(
                      totalFormateado,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Número de Ventas:',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                    ),
                    Text(
                      '$numeroDeVentas',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ); // <--- Aquí terminaba antes el Center, ahora termina la Card
          }
          // --- Estado inesperado ---
          else {
            return const Center(
              child: Text('No se pudieron cargar los datos.'),
            );
          }
        },
      ),
    );
  }
}
