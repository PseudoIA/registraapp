// lib/src/features/sales/presentation/screens/nueva_venta_screen.dart

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart'
    hide Column; // Mantenemos el hide por si acaso
import 'package:registraap/src/core/data/models/local_database.dart';
import 'package:registraap/src/core/data/models/venta.dart'; // Usamos alias

// Ahora es un StatefulWidget que representa una PANTALLA completa
class NuevaVentaScreen extends StatefulWidget {
  final TipoVenta tipoVenta;

  const NuevaVentaScreen({super.key, required this.tipoVenta});

  @override
  State<NuevaVentaScreen> createState() => _NuevaVentaScreenState();
}

class _NuevaVentaScreenState extends State<NuevaVentaScreen> {
  // Mismos Controllers y estado que antes
  String _tipoVentaToString(TipoVenta tipo) {
    switch (tipo) {
      case TipoVenta.efectivo:
        return 'Efectivo';
      case TipoVenta.digital:
        return 'Digital';
      // Añadir default o lanzar error si hubiera más tipos
    }
  }

  final _valorController = TextEditingController();
  final _descripcionController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _valorController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  // Misma función SnackBar que antes (o importada de utils)
  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Misma función _guardarVenta que antes (usa Navigator.pop para CERRAR esta pantalla)
  Future<void> _guardarVenta() async {
    if (_isSaving) return;
    setState(() {
      _isSaving = true;
    });

    final String valorStr = _valorController.text.trim();
    final String descripcion = _descripcionController.text.trim();
    final BuildContext currentContext = context;
    final NavigatorState navigator = Navigator.of(currentContext);

    // Validación
    final double? valor = double.tryParse(valorStr);
    if (valor == null || valor <= 0) {
      _showSnackBar(
        currentContext,
        'Ingrese un valor válido y positivo.',
        isError: true,
      );
      setState(() {
        _isSaving = false;
      });
      return;
    }
    // Obtener userId (Temporal)
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) {
      _showSnackBar(
        currentContext,
        'Error: No se pudo identificar al usuario.',
        isError: true,
      );
      setState(() {
        _isSaving = false;
      });
      return;
    }

    try {
      // Preparar Companion
      final companion = VentasCompanion.insert(
        timestamp: DateTime.now(),
        tipo: widget.tipoVenta,
        valor: valor,
        descripcion:
            descripcion.isNotEmpty ? Value(descripcion) : const Value.absent(),
        idUsuario: userId,
        rutaImagenComprobante: const Value.absent(), // Placeholder
      );
      // Insertar en DB
      final generatedId = await database.insertVenta(companion);
      print('Venta guardada con ID: $generatedId');
      // --- ¡NUEVA LÍNEA! ---
      // Notifica a los listeners que la lista de ventas ha cambiado.
      ventasUpdateNotifier.value++;
      // --- FIN NUEVA LÍNEA ---

      if (!currentContext.mounted) return;
      _showSnackBar(currentContext, '¡Venta guardada exitosamente!');
      // Cierra esta PANTALLA y vuelve a la anterior (VentasDiariasScreen)

      navigator.pop(true);
    } catch (e, stacktrace) {
      print('Error al guardar venta: $e');
      print(stacktrace);
      if (!currentContext.mounted) return;
      if (e.toString().contains('UNIQUE constraint failed')) {
        // Ser más específico si es necesario
        _showSnackBar(
          currentContext,
          'Error: Restricción UNIQUE falló.',
          isError: true,
        );
      } else {
        _showSnackBar(
          currentContext,
          'Error al guardar la venta.',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // --- El MÉTODO BUILD AHORA DEVUELVE SCAFFOLD ---
  @override
  Widget build(BuildContext context) {
    final String titulo =
        widget.tipoVenta == TipoVenta.efectivo
            ? 'Nueva Venta en Efectivo'
            : 'Nueva Venta Digital';

    return Scaffold(
      // <-- ¡Ya no es AlertDialog, es Scaffold!
      appBar: AppBar(
        title: Text(titulo),
        // El botón de atrás lo añade Navigator.push automáticamente
      ),
      // El body contiene el SingleChildScrollView como antes
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding general
          child: Column(
            // La misma columna de antes
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Campo Valor (igual que antes) ---
              TextField(
                controller: _valorController,
                decoration: const InputDecoration(
                  labelText: 'Valor *',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 16),

              // --- Campo Descripción (igual que antes) ---
              TextField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción (Opcional)',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 1,
              ),
              const SizedBox(height: 16),
              // ***** INICIO CÓDIGO AÑADIDO *****
              // --- Mostrar Tipo de Venta (No Editable) ---
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Tipo de Venta', // Etiqueta
                  border: const OutlineInputBorder(),
                  // Estilo visual para que parezca deshabilitado/informativo
                  enabled: false, // Lo hace no interactivo visualmente
                  // Podrías añadir un color de fondo grisáceo si quieres más énfasis
                  // filled: true,
                  // fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 16.0,
                  ), // Ajusta padding si es necesario
                ),
                // El contenido es un widget Text que muestra el tipo
                child: Text(
                  _tipoVentaToString(
                    widget.tipoVenta,
                  ), // Llama a la función helper
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    // Usa un estilo de texto apropiado
                    color: Theme.of(context).disabledColor,
                  ),
                ),
              ),

              const SizedBox(
                height: 16,
              ), // Espacio antes del área de foto o botones

              const SizedBox(height: 16),

              // --- Área Condicional para Foto (igual que antes) ---
              if (widget.tipoVenta == TipoVenta.digital) ...[
                Container(/* ... El placeholder para la foto ... */),
                const SizedBox(height: 24),
              ],

              // --- Botones (Ahora al final de la columna) ---
              ElevatedButton(
                onPressed: _isSaving ? null : _guardarVenta,
                child:
                    _isSaving
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text('Guardar Venta'),
              ),
              // Ya no necesitamos el botón "Cancelar" explícito aquí,
              // porque la AppBar tendrá el botón de "Atrás" para cerrar la pantalla.
            ],
          ),
        ),
      ),
    );
  }
} // Fin _NuevaVentaScreenState
