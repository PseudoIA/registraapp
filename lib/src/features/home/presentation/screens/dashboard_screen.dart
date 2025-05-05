// lib/src/features/home/presentation/screens/dashboard_screen.dart
// --- VERSIÓN MODIFICADA CON SCAFFOLD, APPBAR Y TARJETA DE TOTALES ---

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesitamos formatear moneda
import 'package:registraap/src/core/data/models/local_database.dart'; // Acceso a DB y Notifier
import 'package:shared_preferences/shared_preferences.dart';
// Importamos ListaVentasDiariasScreen para la navegación
import 'package:registraap/src/features/sales/presentation/screens/lista_ventas_diarias_screen.dart';
import 'package:registraap/main.dart';

class DashboardScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const DashboardScreen({
    required this.scaffoldKey, // Hacerla requerida
    super.key,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const String _keyNombreEstablecimiento = 'nombre_establecimiento';
  // --- State Variables ---
  Future<List<Venta>>? _ventasHoyFuture; // <--- Para las ventas de hoy
  Future<List<Venta>>? _ventasTotalFuture; // <--- Para el total histórico

  String? _nombreNegocio;
  int? _userId; // Para no buscarlo repetidamente

  @override
  void initState() {
    super.initState();
    // Obtener userId y cargar ambos resúmenes
    _initializeAndLoadData();
    nombreNegocioNotifier.addListener(_actualizarNombreMostrado);
    // Listener para refrescar ambos resúmenes si hay cambios
    ventasUpdateNotifier.addListener(_onVentasUpdated);
    print("Listener de ventas añadido en DashboardScreen.");
  }

  @override
  void dispose() {
    ventasUpdateNotifier.removeListener(_onVentasUpdated);
    nombreNegocioNotifier.removeListener(_actualizarNombreMostrado);
    print("Listener de ventas removido de DashboardScreen.");
    super.dispose();
  }

  // --- VUELVE A AÑADIR ESTA FUNCIÓN ---
  void _actualizarNombreMostrado() {
    if (mounted) {
      print(
        "(Dashboard) Listener: Recibido nuevo nombre: ${nombreNegocioNotifier.value}",
      );
      setState(() {
        // Actualiza estado local directamente desde el notifier
        // Asegura un valor por defecto si el notifier se vuelve null
        _nombreNegocio =
            (nombreNegocioNotifier.value != null &&
                    nombreNegocioNotifier.value!.isNotEmpty)
                ? nombreNegocioNotifier.value
                : "tu Negocio"; // O "RegistraApp"
      });
    }
  }

  // Obtiene userId y carga los datos iniciales
  Future<void> _initializeAndLoadData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return; // Check mounted after await
    _userId = prefs.getInt('userId');
    // --- NUEVO: Cargar nombre del negocio ---
    _nombreNegocio = prefs.getString(_keyNombreEstablecimiento);
    print("Nombre negocio cargado: $_nombreNegocio");
    // --- FIN NUEVO ---
    if (_userId == null) {
      print(
        "Error Crítico: userId no encontrado al inicializar DashboardScreen.",
      );
      setState(() {
        // Establecer futures a error para que FutureBuilder lo muestre
        _ventasHoyFuture = Future.error(Exception('Usuario no autenticado.'));
        _ventasTotalFuture = Future.error(Exception('Usuario no autenticado.'));
      });
    } else {
      _loadData(); // Carga los datos si userId existe
    }
  }

  // Listener que recarga los datos cuando hay actualizaciones
  void _onVentasUpdated() {
    if (mounted && _userId != null) {
      print("Notifier detectó cambio en Dashboard, refrescando resúmenes...");
      _loadData(); // Recarga ambos futures
    }
  }

  // Asigna los futures para obtener los datos de la DB
  void _loadData() {
    if (_userId == null) return; // No cargar sin userId

    // Usamos setState para que los FutureBuilders se actualicen con los nuevos Futures
    setState(() {
      print("Dashboard: Cargando resumen de hoy para userId: $_userId");
      _ventasHoyFuture = database.getVentasDelDia(
        DateTime.now(),
        userId: _userId!,
      );

      print("Dashboard: Cargando resumen total para userId: $_userId");
      // ASUME que tienes database.getAllVentasUsuario(userId) implementado
      _ventasTotalFuture = database.getAllVentasUsuario(_userId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Construyendo DashboardScreen con nombre: $_nombreNegocio");

    // --- Título dinámico ---
    // Usamos un valor por defecto más genérico si _nombreNegocio aún es null en el primer build
    String appBarTitle =
        _nombreNegocio != null && _nombreNegocio!.isNotEmpty
            ? 'Bienvenido a $_nombreNegocio'
            : 'RegistraApp'; // O 'Inicio' o 'Bienvenido'
    // --- Fin título ---

    // --- Añadimos Scaffold y AppBar ---
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: const TextStyle(fontSize: 18), // Puedes ajustar el estilo
          overflow:
              TextOverflow.ellipsis, // Evita overflow si el nombre es largo
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              tooltip: 'Abrir menú',
              onPressed: () {
                // --- PASO 5: Usar la Llave Recibida ---
                // Accedemos directamente al estado del Scaffold de MainShellScreen
                // usando la llave que nos pasaron a través del constructor.
                // Usamos '?.' (null-aware operator) por si acaso currentState fuera null.
                widget.scaffoldKey.currentState?.openDrawer();
                // --- FIN PASO 5 ---
              },
            );
          },
        ),
        // --- FIN SECCIÓN AÑADIDA ---
      ),
      // Usamos ListView para permitir scroll si hay muchas tarjetas o contenido
      body: RefreshIndicator(
        // Permite refrescar deslizando hacia abajo
        onRefresh: () async {
          if (_userId != null) {
            _loadData(); // Recarga ambos futures
            // Espera a que ambos terminen (opcional, para la animación del refresh)
            await Future.wait(
              [_ventasHoyFuture!, _ventasTotalFuture!].where((f) => f != null),
            );
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // --- Tarjeta Resumen de Hoy ---
            _buildResumenCard(
              context: context,
              title: 'Resumen de Hoy',
              ventasFuture: _ventasHoyFuture,
              onTapAction: () {
                // Navegar a la lista mostrando solo las ventas de HOY
                print("Navegando a ventas de hoy");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Instancia normal, por defecto muestra hoy
                    builder:
                        (context) => ListaVentasDiariasScreen(
                          scaffoldKey: widget.scaffoldKey, // Pasar la llave
                        ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16), // Espacio entre tarjetas
            // --- Tarjeta Resumen Total Histórico ---
            _buildResumenCard(
              context: context,
              title: 'Resumen Total Histórico',
              ventasFuture:
                  _ventasTotalFuture, // Usa el future de todas las ventas
              onTapAction: () {
                // Navegar a la lista mostrando TODAS las ventas
                print("Navegando a todas las ventas");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Pasamos showAll: true al constructor
                    // (Asegúrate que ListaVentasDiariasScreen lo acepta)
                    builder:
                        (context) => ListaVentasDiariasScreen(
                          scaffoldKey: widget.scaffoldKey, // Pasar la llave
                          showAll: true,
                        ), // Indicar que muestre todas,
                  ),
                );
              },
            ),
            // Puedes añadir más widgets al dashboard aquí si lo deseas
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER REUTILIZABLE PARA LAS TARJETAS DE RESUMEN ---
  Widget _buildResumenCard({
    required BuildContext context,
    required String title,
    required Future<List<Venta>>? ventasFuture, // Future a resolver
    required VoidCallback onTapAction, // Acción al tocar la tarjeta
  }) {
    // Formateador de moneda local a esta función
    final formatoMoneda = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );

    return FutureBuilder<List<Venta>>(
      future: ventasFuture, // El future específico para esta tarjeta
      builder: (context, snapshot) {
        Widget cardContent;

        // Estado de Carga Inicial (si el future aún no se ha asignado)
        if (ventasFuture == null &&
            snapshot.connectionState != ConnectionState.done) {
          cardContent = const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 40.0,
              ), // Más padding vertical
              child: CircularProgressIndicator(),
            ),
          );
        }
        // Estado de Error
        else if (snapshot.hasError) {
          print("Error en FutureBuilder ($title): ${snapshot.error}");
          cardContent = Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Error al cargar\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        // Estado con Datos (o completado)
        // Usamos snapshot.data ?? [] por si el future completa sin datos
        else {
          final ventas = snapshot.data ?? [];
          final double total = ventas.fold(0.0, (sum, v) => sum + v.valor);
          final int numeroVentas = ventas.length;
          final String totalFormateado = formatoMoneda.format(total);

          // Muestra "Cargando..." dentro de la tarjeta si connectionState es waiting
          // pero ya tenemos un future asignado (ej. durante un refresh)
          bool showLoadingOverlay =
              snapshot.connectionState == ConnectionState.waiting;

          cardContent = Opacity(
            // Hace el contenido un poco transparente mientras carga
            opacity: showLoadingOverlay ? 0.6 : 1.0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Divider(height: 24, thickness: 1),
                  Text(
                    'Total Vendido:',
                    style: Theme.of(context).textTheme.bodyMedium,
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
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '$numeroVentas',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  // Indicador de carga sutil dentro de la tarjeta si está refrescando
                  if (showLoadingOverlay) ...[
                    const SizedBox(height: 10),
                    const Center(
                      child: SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }

        // Devuelve la Card envuelta en InkWell
        return Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          // Usamos ClipRRect para que el InkWell respete los bordes redondeados
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap:
                snapshot.hasError
                    ? null
                    : onTapAction, // Deshabilita onTap si hay error
            child: cardContent,
          ),
        );
      },
    );
  } // Fin _buildResumenCard
} // Fin _DashboardScreenState
