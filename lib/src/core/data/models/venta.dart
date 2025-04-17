import 'package:flutter/material.dart'; // Necesario para usar Color

// Define los tipos posibles de venta.
enum TipoVenta { efectivo, digital }

// Define los estados posibles de una venta.
enum EstadoVenta {
  normal,
  modificada, // Cuando un supervisor la autoriza para modificación/anulación conceptual
}

class Venta {
  final String id; // Identificador único de la venta
  final DateTime timestamp; // Fecha y hora de la venta
  final TipoVenta tipo; // Efectivo o Digital
  final double valor; // Monto de la venta
  final String? descripcion; // Notas opcionales
  final String idUsuario; // ID del Usuario que registró la venta
  final EstadoVenta estado; // Estado actual de la venta
  final String?
  rutaImagenComprobante; // Ruta a la foto (solo para tipo Digital)

  // Constructor básico
  Venta({
    required this.id,
    required this.timestamp,
    required this.tipo,
    required this.valor,
    this.descripcion, // Opcional
    required this.idUsuario,
    this.estado = EstadoVenta.normal, // Valor por defecto al crear
    this.rutaImagenComprobante, // Opcional, solo para ventas digitales
  });

  // Aquí podríamos añadir métodos después (ej: toJson, fromJson)
}

extension TipoVentaHelper on TipoVenta {
  static String enumToString(TipoVenta tipo) {
    switch (tipo) {
      case TipoVenta.efectivo:
        return 'Efectivo';
      case TipoVenta.digital:
        return 'Digital';
    }
  }
}

// --- Helper para EstadoVenta ---
// Añade esta extensión al final del archivo venta.dart
extension EstadoVentaHelper on EstadoVenta {
  // SIN prefijo aquí
  static String enumToString(EstadoVenta estado) {
    // SIN prefijo aquí
    switch (estado) {
      case EstadoVenta.normal: // SIN prefijo aquí
        return 'Normal';
      case EstadoVenta.modificada: // SIN prefijo aquí
        return 'Modificada';
      // Añadir default o error si el enum crece
    }
  }

  // Helper para obtener un color representativo
  static Color getColor(EstadoVenta estado) {
    // SIN prefijo aquí
    switch (estado) {
      case EstadoVenta.normal: // SIN prefijo aquí
        return Colors.black87; // O un verde claro
      case EstadoVenta.modificada: // SIN prefijo aquí
        return Colors.orange.shade800;
    }
  }
}
