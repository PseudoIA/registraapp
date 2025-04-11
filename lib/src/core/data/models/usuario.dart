// Define los roles posibles para un usuario.
enum RolUsuario { supervisor, empleado }

class Usuario {
  final int id; // Identificador único (puede ser generado)
  final String nombre;
  final String? apellido;
  final String? email; // Email opcional para login/recuperación
  final String hashContrasena; // NUNCA guardar contraseña en texto plano
  final RolUsuario rol; // Rol del usuario (Supervisor o Empleado)
  final DateTime dateCreated; // <-- AÑADIDO
  // Constructor básico
  Usuario({
    this.apellido,
    required this.id,
    required this.nombre,
    this.email, // Es opcional
    required this.hashContrasena,
    required this.rol,
    required this.dateCreated,
  });

  // Aquí podríamos añadir métodos después si es necesario (ej: toJson, fromJson)
  @override
  String toString() {
    return 'Usuario(id: $id, nombre: $nombre, apellido: $apellido, email: $email, rol: $rol, dateCreated: $dateCreated)';
  }
}
