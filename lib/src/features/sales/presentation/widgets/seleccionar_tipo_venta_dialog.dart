// lib/src/features/sales/presentation/widgets/seleccionar_tipo_venta_dialog.dart

import 'package:flutter/material.dart';
// Importamos el enum TipoVenta de nuestro modelo
// Usa el alias si lo configuraste antes, si no, quita 'as model'
import 'package:registraap/src/core/data/models/venta.dart';

// Un widget simple que representa el contenido del diálogo
// Un widget simple que representa el contenido del diálogo
class SeleccionarTipoVentaDialog extends StatelessWidget {
  const SeleccionarTipoVentaDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // AlertDialog es un widget estándar para diálogos
    return AlertDialog(
      title: const Text('Nueva Venta'),
      content: Column(
        // Columna para poner las opciones una debajo de otra
        mainAxisSize:
            MainAxisSize
                .min, // Hace que la columna ocupe solo el espacio necesario
        children: <Widget>[
          ListTile(
            // Una fila interactiva estándar
            leading: const Icon(Icons.money_outlined), // Icono a la izquierda
            title: const Text('Registrar Venta en Efectivo'),
            onTap: () {
              // Al tocar esta opción:
              // 1. Cierra este diálogo.
              // 2. Devuelve 'TipoVenta.efectivo' como resultado.
              Navigator.pop(context, TipoVenta.efectivo);
            },
          ),
          const Divider(), // Una línea separadora (opcional)
          ListTile(
            leading: const Icon(
              Icons.qr_code_scanner_outlined,
            ), // O Icons.camera_alt
            title: const Text('Registrar Venta Digital'),
            onTap: () {
              // Al tocar esta opción:
              // 1. Cierra este diálogo.
              // 2. Devuelve 'TipoVenta.digital' como resultado.
              Navigator.pop(context, TipoVenta.digital);
            },
          ),
        ],
      ),
      // (Opcional) Botón de cancelar en la parte inferior
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            // Cierra el diálogo sin devolver ningún tipo de venta (el resultado será null)
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
