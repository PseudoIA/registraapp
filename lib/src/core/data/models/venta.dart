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
