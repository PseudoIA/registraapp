// lib/src/features/sales/presentation/screens/lista_ventas_diarias_screen.dart
// --- VERSIÓN MODIFICADA CON SCAFFOLD, APPBAR, CALENDARIO Y PROGRESS INDICATOR ---

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:registraap/src/core/data/models/local_database.dart';
// Importamos VentaListItem y las definiciones de Venta si es necesario
// import 'package:registraap/src/core/data/models/venta.dart' as model; // Quitado si no se usa alias
import 'package:registraap/src/features/sales/presentation/widgets/venta_list_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaVentasDiariasScreen extends StatefulWidget {
  // Parámetros opcionales para reutilización futura (ej. desde Dashboard)
  final bool showAll;
  final DateTimeRange? initialDateRange;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ListaVentasDiariasScreen({
    required this.scaffoldKey,
    super.key,
    this.showAll = false, // Por defecto, no muestra todas
    this.initialDateRange,
  });

  @override
  State<ListaVentasDiariasScreen> createState() =>
      _ListaVentasDiariasScreenState();
}

class _ListaVentasDiariasScreenState extends State<ListaVentasDiariasScreen> {
  // --- State Variables ---
  Future<List<Venta>>? _ventasFuture; // Future para el FutureBuilder
  DateTimeRange? _selectedDateRange; // Rango de fechas seleccionado
  bool _isLoading = false; // Controla el LinearProgressIndicator
  int? _userId; // Almacena el ID del usuario logueado

  @override
  void initState() {
    super.initState();
    _selectedDateRange = widget.initialDateRange; // Usa rango inicial si existe
    // Obtiene el userId y luego carga las ventas iniciales
    _initializeAndLoadVentas();
    // Listener para actualizaciones externas (ej. nueva venta guardada)
    ventasUpdateNotifier.addListener(_onVentasUpdated);
    print("Listener añadido a ventasUpdateNotifier.");
  }

  @override
  void dispose() {
    ventasUpdateNotifier.removeListener(_onVentasUpdated);
    print("Listener removido de ventasUpdateNotifier.");
    super.dispose();
  }

  // Obtiene userId y llama a _loadVentas por primera vez
  Future<void> _initializeAndLoadVentas() async {
    final prefs = await SharedPreferences.getInstance();
    // Asegúrate de que el widget sigue montado después del await
    if (!mounted) return;
    _userId = prefs.getInt('userId');
    if (_userId == null) {
      print(
        "Error Crítico: userId no encontrado al inicializar ListaVentasDiariasScreen.",
      );
      setState(() {
        // Establece el future a un estado de error
        _ventasFuture = Future.error(Exception('Usuario no autenticado.'));
        _isLoading = false; // Asegura que no haya indicador de carga fantasma
      });
    } else {
      _loadVentas(); // Carga las ventas iniciales (hoy por defecto)
    }
  }

  // Listener para refrescar cuando hay nuevas ventas
  void _onVentasUpdated() {
    // Solo recarga si el widget está montado y tenemos un userId válido
    if (mounted && _userId != null) {
      print("Notifier detectó cambio, refrescando lista de ventas...");
      _loadVentas(); // Recarga con los parámetros de fecha actuales
    }
  }

  // Inicia la carga de ventas y gestiona el estado _isLoading
  void _loadVentas() {
    if (_userId == null) {
      print("Intento de cargar ventas sin userId, abortando.");
      return; // No hacer nada si no tenemos userId
    }

    setState(() {
      _isLoading = true; // Muestra el LinearProgressIndicator
      _ventasFuture = _fetchVentas(); // Obtiene el Future correcto
    });

    // Oculta el LinearProgressIndicator cuando el Future termina
    _ventasFuture?.whenComplete(() {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  // Devuelve el Future<List<Venta>> apropiado según los filtros activos
  Future<List<Venta>> _fetchVentas() async {
    // _userId ya fue validado en _loadVentas y _initializeAndLoadVentas
    if (widget.showAll) {
      // Lógica para cuando se reutilice para mostrar todas (Punto 3 futuro)
      print("Fetching TODAS las ventas para userId: $_userId");
      // ASUME que tienes database.getAllVentasUsuario(userId)
      return database.getAllVentasUsuario(_userId!);
    } else if (_selectedDateRange != null) {
      // Lógica para buscar por rango de fechas
      print(
        "Fetching ventas por rango para userId: $_userId, Rango: $_selectedDateRange",
      );
      // Usa la función getVentasPorRango (asegúrate que exista y funcione)
      return database.getVentasPorRango(_userId!, _selectedDateRange!);
    } else {
      // Lógica por defecto: buscar ventas de hoy
      print("Fetching ventas de HOY para userId: $_userId");
      return database.getVentasDelDia(DateTime.now(), userId: _userId!);
    }
  }

  // Muestra el selector de rango de fechas
  Future<void> _selectDateRange() async {
    // No permitir seleccionar fecha si no hay userId (aunque no debería pasar)
    if (_userId == null) return;

    final now = DateTime.now();
    final firstDate = DateTime(now.year - 5); // Límite inferior (ej. 5 años)
    final lastDate = now; // Límite superior (hoy)

    final pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange:
          _selectedDateRange ?? DateTimeRange(start: now, end: now),
      firstDate: firstDate,
      lastDate: lastDate,
      locale: const Locale('es', 'ES'), // Configuración regional
      // Puedes personalizar el tema del picker si quieres
      // builder: (context, child) => Theme(data: ..., child: child!),
    );

    // Si el usuario selecciona un rango y presiona "Guardar"
    if (pickedRange != null) {
      setState(() {
        _selectedDateRange = pickedRange;
        // Considera si 'showAll' debería resetearse aquí si venía de ese estado
      });
      _loadVentas(); // Recarga las ventas con el nuevo rango
    }
    // Si el usuario presiona "Cancelar", no hacemos nada (mantiene el estado actual)
  }

  // Limpia el filtro de fecha y vuelve a mostrar las ventas de hoy
  void _clearDateFilter() {
    setState(() {
      _selectedDateRange = null;
      // Asegúrate de que el estado showAll se maneje correctamente si es necesario
    });
    _loadVentas(); // Recarga las ventas para hoy
  }

  // Genera el título del AppBar dinámicamente
  String _buildAppBarTitle() {
    if (widget.showAll) {
      return 'Todas las Ventas';
    } else if (_selectedDateRange != null) {
      final formatter = DateFormat('d MMM', 'es_ES'); // Formato corto
      final start = formatter.format(_selectedDateRange!.start);
      final end = formatter.format(_selectedDateRange!.end);
      return start == end ? 'Ventas: $start' : 'Ventas: $start - $end';
    } else {
      return 'Ventas del Día';
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
      "Construyendo ListaVentasDiariasScreen (Rango: $_selectedDateRange, ShowAll: ${widget.showAll})",
    );

    // --- Envuelve todo en un Scaffold ---
    return Scaffold(
      appBar: AppBar(
        title: Text(_buildAppBarTitle()), // Título dinámico
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              tooltip: 'Abrir menú',
              onPressed: () {
                widget.scaffoldKey.currentState?.openDrawer();
              },
            );
          },
        ),
        // El botón de atrás aparece si se navega con Navigator.push
        // leading: (widget.showAll || _selectedDateRange != null) ? BackButton() : null,
        actions: [
          // Botón para seleccionar fecha/rango
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            tooltip: 'Seleccionar fecha o rango',
            // Deshabilitar si no hay userId? Podría ser buena idea.
            onPressed: _userId != null ? _selectDateRange : null,
          ),
          // Botón para limpiar filtro (solo si hay un filtro activo)
          if (!widget.showAll && _selectedDateRange != null)
            IconButton(
              icon: const Icon(Icons.today), // Icono para volver a "Hoy"
              tooltip: 'Mostrar ventas de hoy',
              onPressed: _clearDateFilter,
            ),
        ],
        // Indicador de progreso lineal que aparece debajo del AppBar mientras carga
        bottom:
            _isLoading
                ? const PreferredSize(
                  preferredSize: Size.fromHeight(4.0), // Altura estándar
                  child: LinearProgressIndicator(
                    minHeight: 4.0,
                  ), // Altura mínima
                )
                : null, // No muestra nada si no está cargando
      ),
      body: FutureBuilder<List<Venta>>(
        future: _ventasFuture, // El future que gestionamos en el estado
        builder: (context, snapshot) {
          // Estado de Carga (manejado principalmente por LinearProgressIndicator)
          // No obstante, podemos mostrar un indicador central si el future es null inicialmente
          if (snapshot.connectionState == ConnectionState.waiting &&
              _ventasFuture == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // Estado de Error
          if (snapshot.hasError) {
            print('Error en FutureBuilder: ${snapshot.error}');
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                // Muestra el mensaje de la excepción
                child: Text('Error al cargar ventas: ${snapshot.error}'),
              ),
            );
          }

          // Estado con Datos (o completado, incluso si la lista está vacía)
          // Usamos snapshot.data ?? [] para manejar el caso donde el future completa
          // pero aún no tiene datos (o si devuelve null por alguna razón).
          final ventas = snapshot.data ?? [];

          // Mensaje si no hay ventas (solo si no está cargando)
          if (!_isLoading && ventas.isEmpty) {
            String msg =
                widget.showAll
                    ? 'No hay ventas registradas.'
                    : (_selectedDateRange != null
                        ? 'No hay ventas para el rango seleccionado.'
                        : 'No hay ventas registradas hoy.');
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(msg + ' ¡Usa el botón +!'),
              ),
            );
          }

          // Muestra la lista (o un RefreshIndicator vacío si está cargando pero hay datos previos)
          return RefreshIndicator(
            onRefresh: () async {
              // Asegura recargar solo si tenemos userId
              if (_userId != null) {
                _loadVentas(); // Recarga con los filtros actuales
                await _ventasFuture; // Espera a que termine
              }
            },
            child: Column(
              // Mantenemos Column por si queremos añadir totales
              children: [
                // Podríamos añadir aquí un widget que muestre el total del periodo
                // ej: Text('Total Periodo: ${calcularTotal(ventas)}')
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
        },
      ), // Fin FutureBuilder
    ); // Fin Scaffold
  } // Fin build
} // Fin _ListaVentasDiariasScreenState
