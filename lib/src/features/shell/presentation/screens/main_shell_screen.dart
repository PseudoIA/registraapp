// src/features/shell/presentation/screens/main_shell_screen.dart
// --- VERSIÓN CORREGIDA CON GlobalKey INTEGRADO ---

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Imports de las Pantallas de cada Sección ---
import 'package:registraap/src/features/home/presentation/screens/dashboard_screen.dart';
import 'package:registraap/src/features/sales/presentation/screens/lista_ventas_diarias_screen.dart';
import 'package:registraap/src/settings/presentation/screens/configuracion_screen.dart';

// --- Flujo de Autenticación (Logout) ---
import 'package:registraap/src/features/auth/presentation/screens/bienvenida_screen.dart';

// --- Flujo de Nueva Venta (FAB / Formulario) ---
import 'package:registraap/src/features/sales/presentation/widgets/seleccionar_tipo_venta_dialog.dart';
import 'package:registraap/src/features/sales/presentation/screens/nueva_venta_screen.dart';
import 'package:registraap/src/core/data/models/venta.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _selectedIndex = 0; // Índice de la pestaña activa (Solo una vez)

  // --- GlobalKey para el Scaffold principal ---
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Lista de widgets para el IndexedStack (inicializada en initState)
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    // Inicializamos la lista de widgets aquí, pasando la llave
    _widgetOptions = <Widget>[
      // Asegúrate de que DashboardScreen acepte 'scaffoldKey'
      DashboardScreen(scaffoldKey: _scaffoldKey),
      // --- MODIFICACIÓN AQUÍ ---
      // Ahora pasamos la llave a ListaVentasDiariasScreen
      // (Asegúrate que su constructor acepte 'required this.scaffoldKey')
      ListaVentasDiariasScreen(scaffoldKey: _scaffoldKey),

      // --- Y MODIFICACIÓN AQUÍ ---
      // Ahora pasamos la llave a ConfiguracionScreen
      // (Su constructor ya está modificado para aceptarla)
      ConfiguracionScreen(scaffoldKey: _scaffoldKey),
      // --- FIN MODIFICACIONES ---
    ];
  }

  // Cambia el índice seleccionado al tocar la barra inferior o el drawer
  void _onItemTapped(int index) {
    // Validar índice antes de actualizar estado
    if (index >= 0 && index < _widgetOptions.length) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      print("Error: Intento de navegar a índice inválido en MainShell: $index");
    }
  }

  // --- Lógica para mostrar diálogos de Nueva Venta (Sin cambios) ---
  Future<void> _mostrarFormularioVenta(
    BuildContext context,
    TipoVenta tipo,
  ) async {
    if (!context.mounted) return;
    final result = await Navigator.push<bool?>(
      context,
      MaterialPageRoute(
        builder: (context) => NuevaVentaScreen(tipoVenta: tipo),
      ),
    );

    if (result == true && context.mounted) {
      print(
        'Venta guardada. Forzando navegación a la pestaña Ventas (índice 1).',
      );
      _onItemTapped(1); // Asegura estar en la pestaña de ventas
    }
  }

  void _onAddVentaPressed() async {
    final BuildContext currentContext = context; // Captura segura
    final selectedType = await showDialog<TipoVenta>(
      context: currentContext,
      builder: (BuildContext dialogContext) {
        return const SeleccionarTipoVentaDialog();
      },
    );

    if (!currentContext.mounted) return; // Re-check mounted
    if (selectedType != null) {
      await _mostrarFormularioVenta(currentContext, selectedType);
    }
  }
  // --- Fin lógica Nueva Venta ---

  // --- Lógica para Cerrar Sesión (Incluyendo diálogo de confirmación) ---
  Future<void> _logout() async {
    final BuildContext currentContext = context;
    final NavigatorState navigator = Navigator.of(currentContext);

    // Diálogo de confirmación
    final bool? confirmLogout = await showDialog<bool>(
      context: currentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Cierre de Sesión'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            TextButton(
              child: const Text('Cerrar Sesión'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(dialogContext).colorScheme.error,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );

    if (!currentContext.mounted) return; // Re-check mounted

    if (confirmLogout == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      print('Sesión cerrada.');

      if (!currentContext.mounted) return; // Re-check mounted

      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const BienvenidaScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      print('Cierre de sesión cancelado.');
    }
  }
  // --- Fin lógica Logout ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Asignamos la llave al Scaffold principal
      key: _scaffoldKey,

      // SIN AppBar aquí

      // El Drawer sigue aquí
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Text(
                'RegistraApp', // O nombre del negocio
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Inicio'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: const Text('Ventas'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Ajustes'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                'Cerrar Sesion',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: _logout,
            ),
          ],
        ),
      ),
      // El body usa IndexedStack con la lista _widgetOptions inicializada en initState
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      // La NavigationBar sigue aquí
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        indicatorColor: Theme.of(context).colorScheme.inversePrimary,
        selectedIndex: _selectedIndex < 2 ? _selectedIndex : 0, // Ajustado
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.receipt_long),
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Ventas',
          ),
          // Sin destino de Ajustes aquí
        ],
      ),
      // El FAB sigue aquí
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddVentaPressed,
        tooltip: 'Nueva Venta',
        child: const Icon(Icons.add),
      ),
    );
  }
} // Fin _MainShellScreenState
