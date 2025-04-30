// lib/src/features/sales/presentation/screens/detalle_venta_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Importamos la clase Venta de Drift y las definiciones/helpers
import 'package:registraap/src/core/data/models/local_database.dart';
import 'package:registraap/src/core/data/models/venta.dart'
    as model_definitions;

class DetalleVentaScreen extends StatelessWidget {
  final Venta venta; // La venta cuyos detalles vamos a mostrar

  const DetalleVentaScreen({super.key, required this.venta});

  // --- Helper para obtener icono/color/texto del Tipo (similar a VentaListItem) ---
  Widget _buildTipoInfo(BuildContext context) {
    final IconData icono;
    final Color color;
    final String texto = model_definitions.TipoVentaHelper.enumToString(
      venta.tipo,
    );

    if (venta.tipo == model_definitions.TipoVenta.efectivo) {
      icono = Icons.money_outlined;
      color = Colors.green.shade700;
    } else {
      icono = Icons.receipt_long_outlined;
      color = Colors.blue.shade700;
    }
    return Row(
      children: [
        Icon(icono, color: color),
        const SizedBox(width: 8),
        Text(
          texto,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // --- Helper para obtener info del Estado (¡Necesitaremos la extensión!) ---
  Widget _buildEstadoInfo(BuildContext context) {
    // Asegúrate que model_definitions.EstadoVentaHelper exista (ver nota abajo)
    final String texto = model_definitions.EstadoVentaHelper.enumToString(
      venta.estado,
    );
    final Color color = model_definitions.EstadoVentaHelper.getColor(
      venta.estado,
    ); // Asumiendo que añades getColor

    return Row(
      children: [
        // Podríamos añadir un icono para el estado también si quisiéramos
        // Icon(Icons.flag_outlined, color: color),
        // const SizedBox(width: 8),
        Text(texto, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Formateadores comunes
    final formatoMoneda = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );
    // Formato más completo para fecha y hora
    final formatoFechaHora = DateFormat(
      'EEEE d MMMM yyyy, hh:mm:ss a',
      'es_ES',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Venta')),
      body: ListView(
        // Usamos ListView para scrolling si el contenido es largo
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDetailRow(
            context,
            label: 'ID Venta:',
            value: venta.id.toString(),
            icon: Icons.tag, // Icono para ID
          ),
          const Divider(),
          _buildDetailRow(
            context,
            label: 'Tipo:',
            customWidget: _buildTipoInfo(context), // Usamos el helper para tipo
            icon: Icons.category_outlined,
          ),
          const Divider(),
          _buildDetailRow(
            context,
            label: 'Valor:',
            value: formatoMoneda.format(venta.valor),
            icon: Icons.attach_money,
            valueStyle: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(),
          _buildDetailRow(
            context,
            label: 'Fecha y Hora:',
            // Usamos el formato largo aquí
            value: formatoFechaHora.format(venta.timestamp),
            icon: Icons.calendar_today,
          ),
          const Divider(),
          _buildDetailRow(
            context,
            label: 'Descripción:',
            // Permite que la descripción ocupe más espacio si es necesario
            value:
                venta.descripcion != null && venta.descripcion!.isNotEmpty
                    ? venta.descripcion!
                    : 'N/A',
            icon: Icons.description_outlined,
            isMultiline:
                true, // Indica que puede necesitar más espacio vertical
          ),
          const Divider(),
          _buildDetailRow(
            context,
            label: 'Registrado por (ID):',
            // Mostramos ID, obtener nombre requeriría otra consulta a DB
            value: venta.idUsuario.toString(),
            icon: Icons.person_outline,
          ),
          const Divider(),
          _buildDetailRow(
            context,
            label: 'Estado:',
            customWidget: _buildEstadoInfo(
              context,
            ), // Usamos helper para estado
            icon: Icons.flag_outlined,
          ),
          // Podríamos mostrar la ruta de la imagen si es digital y existe
          if (venta.tipo == model_definitions.TipoVenta.digital &&
              venta.rutaImagenComprobante != null) ...[
            const Divider(),
            _buildDetailRow(
              context,
              label: 'Comprobante:',
              // Aquí podríamos poner un widget para mostrar la imagen
              value: venta.rutaImagenComprobante!,
              icon: Icons.image_outlined,
            ),
          ],

          // TODO: Añadir botones de acción si es necesario (Editar, Anular - con permisos)
        ],
      ),
    );
  }

  // Widget helper para crear filas de detalle consistentes
  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    String? value,
    Widget? customWidget, // Para widgets complejos como el tipo/estado
    required IconData icon,
    TextStyle? valueStyle,
    bool isMultiline = false, // Para valores largos como la descripción
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey[700], size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 2),
                if (customWidget != null)
                  customWidget
                else
                  Text(
                    value ?? 'N/A', // Mostrar N/A si el valor es null
                    style: valueStyle ?? Theme.of(context).textTheme.bodyLarge,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- ¡IMPORTANTE! Añadir Helper para EstadoVenta ---
//    Añade esta extensión al final del archivo o, mejor aún,
//    en 'lib/src/core/data/models/venta.dart' junto a TipoVentaHelper

extension EstadoVentaHelper on model_definitions.EstadoVenta {
  static String enumToString(model_definitions.EstadoVenta estado) {
    switch (estado) {
      case model_definitions.EstadoVenta.normal:
        return 'Normal';
      case model_definitions.EstadoVenta.modificada:
        return 'Modificada';
      // Añadir default o error si el enum crece
    }
  }

  // Helper para obtener un color representativo
  static Color getColor(model_definitions.EstadoVenta estado) {
    switch (estado) {
      case model_definitions.EstadoVenta.normal:
        return Colors.black87; // O un verde claro
      case model_definitions.EstadoVenta.modificada:
        return Colors.orange.shade800;
    }
  }
}
