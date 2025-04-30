// lib/src/features/sales/presentation/widgets/venta_list_item.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Importamos la clase Venta generada por Drift
import 'package:registraap/src/core/data/models/local_database.dart';
// Importamos las definiciones de enum y helpers (si la extensión está allí)
import 'package:registraap/src/features/sales/presentation/screens/detalle_venta_screen.dart';
import 'package:registraap/src/core/data/models/venta.dart'
    as model_definitions;

class VentaListItem extends StatelessWidget {
  final Venta venta; // Recibe el objeto Venta a mostrar

  const VentaListItem({super.key, required this.venta});

  @override
  Widget build(BuildContext context) {
    // --- Determinar icono y color según el tipo ---
    final IconData icono;
    final Color colorIcono;
    final String tipoTexto = model_definitions.TipoVentaHelper.enumToString(
      venta.tipo,
    );

    if (venta.tipo == model_definitions.TipoVenta.efectivo) {
      icono = Icons.money_outlined;
      colorIcono = Colors.green.shade700; // Un verde un poco más oscuro
    } else {
      icono = Icons.receipt_long_outlined;
      colorIcono = Colors.blue.shade700; // Un azul un poco más oscuro
    }

    // --- Formateadores ---
    final formatoMoneda = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );
    final formatoHora = DateFormat('HH:mm'); // Solo hora y minutos

    // --- Construcción del Widget ---
    return InkWell(
      onTap: () {
        // --- ¡AQUÍ VA LA NAVEGACIÓN! ---
        print('Navegando al detalle de Venta ID: ${venta.id}');
        Navigator.push(
          context,
          MaterialPageRoute(
            // Construimos la pantalla de detalle pasándole la venta actual
            builder: (context) => DetalleVentaScreen(venta: venta),
          ),
        );
        // --- FIN DE LA NAVEGACIÓN ---
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            // 1. Icono a la izquierda
            Icon(
              icono,
              color: colorIcono,
              size: 30,
            ), // Icono un poco más grande
            const SizedBox(width: 16), // Espacio
            // 2. Contenido principal (Valor y Subtítulo) - Ocupa el espacio disponible
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinear a la izquierda
                children: [
                  // Valor de la venta (más grande)
                  Text(
                    formatoMoneda.format(venta.valor),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4), // Pequeño espacio
                  // Subtítulo (Hora y Descripción)
                  Text(
                    '${formatoHora.format(venta.timestamp)} - ${venta.descripcion ?? 'Sin descripción'}',
                    style:
                        Theme.of(
                          context,
                        ).textTheme.bodyMedium, // Estilo más pequeño
                    maxLines: 1, // Mostrar solo una línea
                    overflow:
                        TextOverflow.ellipsis, // Poner '...' si es muy largo
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8), // Espacio antes del tipo (opcional)
            // 3. Texto del Tipo a la derecha (Opcional, el icono/color ya lo indican)
            // Puedes comentar o eliminar esta parte si prefieres un look más limpio
            Text(
              tipoTexto,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorIcono, // Usar el mismo color del icono
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Asegúrate que esta extensión esté definida aquí o en venta.dart y sea accesible
// Si ya la tienes en venta.dart y la importaste con 'as model_definitions', está bien.
/*
extension TipoVentaHelper on model_definitions.TipoVenta {
  static String enumToString(model_definitions.TipoVenta tipo) {
    switch (tipo) {
      case model_definitions.TipoVenta.efectivo: return 'Efectivo';
      case model_definitions.TipoVenta.digital: return 'Digital';
    }
  }
}
*/
