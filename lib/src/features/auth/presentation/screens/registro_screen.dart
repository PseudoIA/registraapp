import 'package:flutter/material.dart';
import 'package:registraap/src/core/data/models/usuario.dart'; // Ajusta si es necesario
import 'package:registraap/src/core/data/models/local_database.dart';
import 'dart:convert'; // Para utf8.encode
import 'package:crypto/crypto.dart'; // Para sha256
import 'package:drift/drift.dart' hide Column;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:registraap/src/features/auth/presentation/screens/ventas_diarias_screen.dart';
// Importamos nuestro modelo de Usuario para usar el Enum RolUsuario

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  // Controllers para cada campo
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController(); // Opcional
  final _emailController = TextEditingController(); // Opcional
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Variable para guardar el rol seleccionado en el Dropdown
  RolUsuario? _selectedRol;

  @override
  void dispose() {
    // ¡No olvidar liberar todos los controllers!
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Función simple para convertir el enum a texto legible
  String rolUsuarioToString(RolUsuario rol) {
    switch (rol) {
      case RolUsuario.supervisor:
        return 'Supervisor';
      case RolUsuario.empleado:
        return 'Empleado';
    }
  }

  void showSuccessSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green, // Color verde para éxito
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void showErrorSnackBar(BuildContext context, String message) {
    // Verifica si el widget todavía está 'montado' (visible/activo)
    // antes de intentar mostrar el SnackBar. Evita errores si el usuario
    // navega hacia atrás justo cuando se muestra el error.
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent, // Un color distintivo para errores
        duration: const Duration(seconds: 3), // Cuánto tiempo se muestra
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Cuenta')),
      // Usamos SingleChildScrollView para evitar problemas de overflow
      // cuando aparece el teclado en pantallas pequeñas.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            // No centramos verticalmente aquí, queremos que empiece desde arriba
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Campo Nombre ---
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre(s)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
                textCapitalization:
                    TextCapitalization.words, // Pone mayúscula inicial
              ),
              const SizedBox(height: 16),

              // --- Campo Apellido (Opcional) ---
              TextField(
                controller: _apellidoController,
                decoration: const InputDecoration(
                  labelText: 'Apellido(s) (Opcional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              // --- Campo Email (Opcional) ---
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email (Opcional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // --- Selección de Rol ---
              DropdownButtonFormField<RolUsuario>(
                value: _selectedRol, // El valor actualmente seleccionado
                decoration: const InputDecoration(
                  labelText: 'Rol',
                  border: OutlineInputBorder(),
                ),
                // Generamos los items del menú a partir de los valores del Enum
                items:
                    RolUsuario.values.map((RolUsuario rol) {
                      return DropdownMenuItem<RolUsuario>(
                        value: rol,
                        child: Text(
                          rolUsuarioToString(rol),
                        ), // Muestra texto legible
                      );
                    }).toList(), // Convertimos el resultado a una Lista
                onChanged: (RolUsuario? newValue) {
                  // Actualizamos el estado cuando el usuario selecciona un rol
                  setState(() {
                    _selectedRol = newValue;
                  });
                },
                // TODO: Añadir validación (validator:) para asegurar que se seleccione un rol
              ),
              const SizedBox(height: 16),

              // --- Campo Contraseña ---
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),

              // --- Campo Confirmar Contraseña ---
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 32),

              // --- Botón Registrar ---
              ElevatedButton(
                onPressed: () async {
                  // <-- Añadido async
                  // --- 1. Leer Input ---
                  final nombre = _nombreController.text.trim();
                  final apellido = _apellidoController.text.trim();
                  final email = _emailController.text.trim();
                  final password = _passwordController.text;
                  final confirmPassword = _confirmPasswordController.text;
                  final rol = _selectedRol;
                  final BuildContext currentContext =
                      context; // Captura context ANTES de async gaps
                  FocusScope.of(currentContext).unfocus(); // Oculta teclado

                  final NavigatorState navigator = Navigator.of(
                    currentContext,
                  ); // <-- ¡Probablemente falta esta línea!

                  final ScaffoldMessengerState scaffoldMessenger =
                      ScaffoldMessenger.of(
                        currentContext,
                      ); // <-- Y esta para los SnackBars
                  // --- 2. Validación ---
                  // (La misma lógica de validación que ya tenías...)
                  if (nombre.isEmpty) {
                    showErrorSnackBar(
                      currentContext,
                      'El Nombre es obligatorio',
                    );
                    return;
                  }
                  if (rol == null) {
                    showErrorSnackBar(
                      currentContext,
                      'Debe seleccionar un Rol',
                    );
                    return;
                  }
                  if (password.isEmpty) {
                    showErrorSnackBar(
                      currentContext,
                      'La Contraseña es obligatoria',
                    );
                    _passwordController.clear();
                    _confirmPasswordController.clear();
                    return;
                  }
                  if (confirmPassword.isEmpty) {
                    showErrorSnackBar(
                      currentContext,
                      'La Confirmación de contraseña es obligatoria',
                    );
                    _confirmPasswordController.clear();
                    return;
                  }
                  if (password != confirmPassword) {
                    showErrorSnackBar(
                      currentContext,
                      'Las contraseñas no coinciden',
                    );
                    _passwordController.clear();
                    _confirmPasswordController.clear();
                    return;
                  }

                  // --- Validación Pasada ---

                  // Usamos try-catch para manejar posibles errores de la BD (ej: email duplicado)
                  try {
                    // --- 3. Hashing de Contraseña ---
                    var bytes = utf8.encode(password);
                    var digest = sha256.convert(bytes);
                    var hashContrasena = digest.toString();
                    print('Password Hasheada (SHA-256): $hashContrasena');

                    // --- 4. Preparar Datos para Insertar (Usando Companion) ---
                    // Drift usa clases "Companion" para inserciones/actualizaciones seguras.
                    // No necesitamos especificar 'id' (es autoIncrement) ni 'dateCreated' (tiene clientDefault).
                    final companion = UsuariosCompanion.insert(
                      nombre: nombre,
                      apellido:
                          apellido.isNotEmpty
                              ? Value(apellido)
                              : const Value.absent(),
                      email:
                          email.isNotEmpty
                              ? Value(email)
                              : const Value.absent(),
                      hashContrasena: hashContrasena,
                      rol: rol, // 'rol' ya sabemos que no es null aquí
                    );
                    print('Preparando Companion para insertar: $companion');

                    // --- 5. GUARDAR USUARIO EN DB (REAL) ---
                    // Usamos 'await' porque la inserción es asíncrona y devuelve un Future.
                    // Llamamos al método de nuestra instancia global 'database'.
                    final generatedId = await database.insertUsuario(companion);
                    print('¡Usuario insertado con ID real: $generatedId!');

                    print('*** REGISTRAAPP: Validación OK');
                    print(
                      '*** REGISTRAAPP: Password Hasheada: $hashContrasena',
                    );
                    print(
                      '*** REGISTRAAPP: Usuario insertado con ID real: $generatedId!',
                    );

                    // --- 6. Feedback y Navegación ---
                    // --- GUARDAR SESIÓN ---
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt(
                      'userId',
                      generatedId,
                    ); // Guardamos el ID del NUEVO usuario
                    print(
                      'ID de usuario $generatedId guardado en SharedPreferences tras registro.',
                    );

                    // --- FEEDBACK Y NAVEGACIÓN DIRECTA A HOME ---
                    if (!currentContext.mounted) return; // Re-check mounted

                    // Mostramos éxito ANTES de navegar
                    showSuccessSnackBar(
                      currentContext,
                      '¡Registro exitoso! Iniciando sesión...',
                    );

                    // Esperamos un poquito para el SnackBar y luego NAVEGAMOS REEMPLAZANDO
                    Future.delayed(const Duration(milliseconds: 1500), () {
                      // Menor espera
                      if (currentContext.mounted) {
                        // Reemplaza TODA la pila de navegación actual con la pantalla principal
                        navigator.pushAndRemoveUntil(
                          // <-- Usamos esto para limpiar la pila
                          MaterialPageRoute(
                            builder: (context) => const VentasDiariasScreen(),
                          ),
                          (Route<dynamic> route) =>
                              false, // Elimina todas las rutas anteriores
                        );
                        /* Alternativa más simple si no importa limpiar la pila:
                        navigator.pushReplacement(
                          MaterialPageRoute(builder: (context) => const VentasDiariasScreen()),
                        );
                        */
                        // YA NO USAMOS Navigator.pop(currentContext);
                      }
                    });
                    // ***** FIN CAMBIOS *****
                  } catch (e, stacktrace) {
                    // --- Manejo de Errores ---
                    print('Error al insertar usuario: $e');
                    print(stacktrace); // Útil para depuración
                    // Importante: Volver a verificar 'mounted' DESPUÉS de un 'await' o error
                    if (!currentContext.mounted) return;

                    // Mostrar un mensaje de error genérico o uno más específico si detectamos el tipo de error
                    // Por ejemplo, si el error es por email duplicado (SQLiteException con código específico)
                    if (e.toString().contains(
                      'UNIQUE constraint failed: usuarios.email',
                    )) {
                      showErrorSnackBar(
                        currentContext,
                        'El email ingresado ya está registrado.',
                      );
                    } else {
                      showErrorSnackBar(
                        currentContext,
                        'Error al registrar usuario.',
                      );
                    }
                  }
                }, // Fin de onPressed async
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
