// lib/src/settings/presentation/screens/configuracion_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 1. Convertimos a StatefulWidget
class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  final _nombreController = TextEditingController();
  bool _isLoading = true; // Estado de carga inicial
  bool _isSaving = false; // Estado mientras se guarda
  String? _nombreGuardado; // Para mostrar el nombre actual cargado

  // Clave única para guardar en SharedPreferences
  static const String _keyNombreEstablecimiento = 'nombre_establecimiento';

  @override
  void initState() {
    super.initState();
    _cargarNombreGuardado(); // Cargar el nombre al iniciar el estado
  }

  @override
  void dispose() {
    _nombreController.dispose(); // ¡Importante liberar el controller!
    super.dispose();
  }

  // --- Función para Cargar el Nombre Guardado ---
  Future<void> _cargarNombreGuardado() async {
    // Indicamos que estamos cargando
    setState(() {
      _isLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      // Leemos el string, puede ser null si no se ha guardado antes
      final nombre = prefs.getString(_keyNombreEstablecimiento);

      // Verificamos si el widget sigue montado antes de actualizar estado
      if (mounted) {
        setState(() {
          _nombreGuardado = nombre;
          // Ponemos el nombre cargado (o vacío) en el TextField
          _nombreController.text = nombre ?? '';
          // Indicamos que la carga terminó
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error cargando nombre establecimiento: $e");
      if (mounted) {
        // Terminamos carga aunque haya error
        setState(() {
          _isLoading = false;
        });
        // Mostramos un error al usuario
        _showSnackBar(
          'Error al cargar la configuración guardada',
          isError: true,
        );
      }
    }
  }

  // --- Función para Guardar el Nombre ---
  Future<void> _guardarNombre() async {
    // Evitar múltiples clicks mientras se guarda
    if (_isSaving) return;

    // Obtenemos el texto del controller y quitamos espacios extra
    final nombreNuevo = _nombreController.text.trim();

    // Validación simple: no permitir nombre vacío
    if (nombreNuevo.isEmpty) {
      _showSnackBar(
        'El nombre del establecimiento no puede estar vacío.',
        isError: true,
      );
      return; // No continuar si está vacío
    }

    // Indicamos que estamos guardando
    setState(() {
      _isSaving = true;
    });
    // Ocultar teclado
    FocusScope.of(context).unfocus();

    try {
      final prefs = await SharedPreferences.getInstance();
      // Guardamos el nuevo nombre en SharedPreferences
      await prefs.setString(_keyNombreEstablecimiento, nombreNuevo);

      // Verificamos si el widget sigue montado
      if (mounted) {
        // Actualizamos el estado para reflejar el cambio y terminar guardado
        setState(() {
          _nombreGuardado =
              nombreNuevo; // Actualizar el nombre mostrado opcionalmente
          _isSaving = false;
        });
        // Feedback al usuario
        _showSnackBar('Nombre del establecimiento guardado exitosamente.');
      }
    } catch (e) {
      print("Error guardando nombre establecimiento: $e");
      if (mounted) {
        // Terminamos guardado aunque haya error
        setState(() {
          _isSaving = false;
        });
        // Mostramos error
        _showSnackBar('Error al guardar la configuración.', isError: true);
      }
    }
  }

  // --- Helper para mostrar SnackBar (puedes moverlo a un archivo de utils) ---
  void _showSnackBar(String message, {bool isError = false}) {
    // Comprobar si el contexto sigue válido es crucial aquí
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? Theme.of(context).colorScheme.error : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Esta pantalla se muestra dentro del MainShellScreen,
    // por lo que no necesita su propio Scaffold.
    // Devolvemos el contenido principal directamente.

    // Mientras carga la configuración inicial, mostramos indicador
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Una vez cargado, mostramos la UI de configuración
    // Usamos ListView para que sea scrollable si añadimos más opciones
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          'Ajustes Generales', // Título de la sección
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),

        // Mostrar el nombre actual si ya existe
        if (_nombreGuardado != null && _nombreGuardado!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              // Podríamos usar este nombre en el AppBar de MainShellScreen en el futuro
              'Nombre actual: $_nombreGuardado',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade700),
            ),
          ),

        // Campo de texto para el nombre
        TextField(
          controller: _nombreController,
          decoration: const InputDecoration(
            labelText: 'Nombre del Establecimiento',
            hintText: 'Ej: Super Tienda La Esquina',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.storefront_outlined), // Icono útil
          ),
          textCapitalization:
              TextCapitalization.words, // Poner mayúsculas iniciales
          maxLength: 50, // Limitar longitud (opcional)
        ),
        const SizedBox(height: 24),

        // Botón para guardar los cambios
        ElevatedButton.icon(
          // Deshabilitar el botón mientras se guarda
          onPressed: _isSaving ? null : _guardarNombre,
          icon:
              _isSaving
                  ? Container(
                    // Indicador de progreso dentro del botón
                    width: 18,
                    height: 18,
                    padding: const EdgeInsets.all(2.0),
                    // Usar color del tema para el indicador
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                  : const Icon(Icons.save_alt_outlined), // Icono de guardar
          label: Text(_isSaving ? 'Guardando...' : 'Guardar Cambios'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
            ), // Hacer botón más alto
          ),
        ),

        // Espacio para futuras opciones...
        // const SizedBox(height: 30),
        // const Divider(),
        // Text("Otras Configuraciones..."),
      ],
    );
  }
}
