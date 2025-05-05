// lib/src/settings/presentation/screens/configuracion_screen.dart
// --- VERSIÓN COMPLETA CON SCAFFOLD, APPBAR Y BOTÓN DRAWER ---

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:registraap/main.dart';

class ConfiguracionScreen extends StatefulWidget {
  // Acepta la GlobalKey pasada desde MainShellScreen
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ConfiguracionScreen({
    required this.scaffoldKey, // Asegúrate que sea requerida
    super.key,
  });

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  final _nombreController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;
  String? _nombreGuardado;

  static const String _keyNombreEstablecimiento = 'nombre_establecimiento';

  @override
  void initState() {
    super.initState();
    _cargarNombreGuardado();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  // --- Funciones _cargarNombreGuardado, _guardarNombre, _showSnackBar ---
  // (Sin cambios respecto a tu versión, las incluimos por completitud)
  Future<void> _cargarNombreGuardado() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final nombre = prefs.getString(_keyNombreEstablecimiento);
      if (mounted) {
        setState(() {
          _nombreGuardado = nombre;
          _nombreController.text = nombre ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error cargando nombre establecimiento: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar(
          'Error al cargar la configuración guardada',
          isError: true,
        );
      }
    }
  }

  Future<void> _guardarNombre() async {
    if (_isSaving) return;
    final nombreNuevo = _nombreController.text.trim();
    if (nombreNuevo.isEmpty) {
      _showSnackBar(
        'El nombre del establecimiento no puede estar vacío.',
        isError: true,
      );
      return;
    }
    setState(() {
      _isSaving = true;
    });
    FocusScope.of(context).unfocus();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyNombreEstablecimiento, nombreNuevo);
      if (mounted) {
        setState(() {
          _nombreGuardado = nombreNuevo;
          _isSaving = false;
        });
        nombreNegocioNotifier.value = nombreNuevo; // Notifica el cambio
        _showSnackBar('Nombre del establecimiento guardado exitosamente.');
      }
    } catch (e) {
      print("Error guardando nombre establecimiento: $e");
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        _showSnackBar('Error al guardar la configuración.', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    // Busca el Scaffold más cercano (el que definimos en ESTE build)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? Theme.of(context).colorScheme.error : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
  // --- Fin Funciones ---

  @override
  Widget build(BuildContext context) {
    // --- AHORA EL BUILD DEVUELVE UN SCAFFOLD ---
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'), // Título de esta pantalla
        // --- Botón para abrir el Drawer ---
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              tooltip: 'Abrir menú',
              onPressed: () {
                // Usa la llave pasada a través del widget
                widget.scaffoldKey.currentState?.openDrawer();
              },
            );
          },
        ),
        // --- Fin Botón Drawer ---
      ),
      // El body contiene la lógica de carga o el ListView
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                // El contenido que ya tenías
                padding: const EdgeInsets.all(16.0),
                children: [
                  Text(
                    'Ajustes Generales',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  if (_nombreGuardado != null && _nombreGuardado!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        'Nombre actual: $_nombreGuardado',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del Establecimiento',
                      hintText: 'Ej: Super Tienda La Esquina',
                      prefixIcon: Icon(Icons.storefront_outlined),
                    ),
                    textCapitalization: TextCapitalization.words,
                    maxLength: 50,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _isSaving ? null : _guardarNombre,
                    icon:
                        _isSaving
                            ? Container(
                              width: 18,
                              height: 18,
                              padding: const EdgeInsets.all(2.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                            : const Icon(Icons.save_alt_outlined),
                    label: Text(_isSaving ? 'Guardando...' : 'Guardar Cambios'),
                  ),
                ],
              ),
    );
    // --- FIN SCAFFOLD ---
  }
}
