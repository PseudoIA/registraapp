import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Imports de las Pantallas de cada Sección ---
// --- Pantallas principales ---
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
  int _selectedIndex = 0; // Índice de la pestaña activa
  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(), // Índice 0 (antes VentasDiariasScreen)
    ListaVentasDiariasScreen(), // Índice 1 (la nueva pantalla de lista)
    ConfiguracionScreen(), // Índice 2 (el nuevo placeholder)
  ];

  static const List<String> _screenTitles = <String>[
    'Inicio', // Título para DashboardScreen
    'Ventas del Día', // Título para ListaVentasDiariasScreen
    'Ajustes', // Título para ConfiguracionScreen
  ];
  // Lista de las pantallas que se mostrarán en el body
  static const List<Widget> _screens = <Widget>[
    DashboardScreen(), // Índice 0
    ListaVentasDiariasScreen(), // Índice 1
    ConfiguracionScreen(), // Índice 2
  ];

  // Cambia el índice seleccionado al tocar la barra inferior
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // --- Lógica para mostrar diálogos de Nueva Venta ---
  Future<void> _mostrarFormularioVenta(
    BuildContext context,
    TipoVenta tipo,
  ) async {
    if (!context.mounted) return;
    // Navega a la pantalla completa del formulario
    final result = await Navigator.push<bool?>(
      context,
      MaterialPageRoute(
        builder: (context) => NuevaVentaScreen(tipoVenta: tipo),
      ),
    );
    if (result == true && context.mounted) {
      print(
        'Venta guardada, se debería refrescar la lista si estamos en esa pestaña...',
      );
      // TODO: Implementar refresco real (posiblemente usando State Management)
      // Si _selectedIndex es 1 (Ventas Hoy), forzar un refresh de ListaVentasDiariasScreen
    }
  }

  void _onAddVentaPressed() async {
    final BuildContext currentContext = context;
    final selectedType = await showDialog<TipoVenta>(
      context: currentContext,
      builder: (BuildContext dialogContext) {
        return const SeleccionarTipoVentaDialog();
      },
    );
    if (!currentContext.mounted) return;
    if (selectedType != null) {
      await _mostrarFormularioVenta(currentContext, selectedType);
    }
  }
  // --- Fin lógica Nueva Venta ---

  // --- Lógica para Cerrar Sesión ---
  Future<void> _logout() async {
    final BuildContext currentContext = context;
    final NavigatorState navigator = Navigator.of(currentContext);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    print('Sesión cerrada.');
    if (!currentContext.mounted) return;
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const BienvenidaScreen()),
      (Route<dynamic> route) => false,
    );
  }
  // --- Fin lógica Logout ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitles.elementAt(_selectedIndex)),
        // El botón de menú para el Drawer se añade automáticamente
      ),
      drawer: Drawer(
        // Menú lateral
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Text(
                'RegistraApp', // O nombre del negocio si lo tenemos
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Inicio (Dashboard)'),
              onTap: () {
                _onItemTapped(0); // Ir al índice 0
                Navigator.pop(context); // Cerrar drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: const Text('Ventas del Día'),
              onTap: () {
                _onItemTapped(1); // Ir al índice 1
                Navigator.pop(context); // Cerrar drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Ajustes'),
              onTap: () {
                _onItemTapped(2); // Ir al índice 2
                Navigator.pop(context); // Cerrar drawer
              },
            ),
            // Puedes añadir más opciones aquí (ej. Historial, Acerca de)
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
      // Usamos IndexedStack para mantener el estado de las pantallas hijas
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      // Barra de navegación inferior (Material 3)
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        indicatorColor:
            Theme.of(context).colorScheme.inversePrimary, // Ajusta colores
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.receipt_long),
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Ventas', // Etiqueta más corta
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Ajustes',
          ),
        ],
      ),
      // Botón flotante para añadir venta
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddVentaPressed,
        tooltip: 'Nueva Venta',
        child: const Icon(Icons.add),
      ),
    );
  }
} // Fin _MainShellScreenState
