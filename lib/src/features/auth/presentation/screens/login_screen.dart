import 'package:flutter/material.dart';

// Usamos StatefulWidget porque necesitamos manejar el estado de los
// campos de texto (lo que el usuario escribe) usando Controllers.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers para obtener el texto de los TextField
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Es MUY importante liberar los controllers cuando el widget se destruye
  // para evitar fugas de memoria.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        // Flutter añade automáticamente un botón de "atrás" aquí
        // porque navegaremos a esta pantalla desde otra.
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Estirar horizontalmente
          children: [
            // Campo de texto para Email o Nombre de Usuario
            TextField(
              controller: _emailController, // Vincula el controller
              decoration: const InputDecoration(
                labelText: 'Email o Nombre de Usuario',
                border: OutlineInputBorder(), // Añade un borde
              ),
              keyboardType:
                  TextInputType.emailAddress, // Sugiere teclado de email
            ),
            const SizedBox(height: 16), // Espacio
            // Campo de texto para Contraseña
            TextField(
              controller: _passwordController, // Vincula el controller
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Oculta el texto (para contraseñas)
            ),
            const SizedBox(height: 32), // Espacio más grande
            // Botón de Ingresar
            ElevatedButton(
              onPressed: () {
                // Acción al presionar Ingresar
                final email = _emailController.text;
                final password = _passwordController.text;
                print('Intentando iniciar sesión con:');
                print('Email/Usuario: $email');
                print('Contraseña: $password'); // ¡OJO! Solo para depurar ahora
                // TODO: Implementar lógica real de validación y login
              },
              child: const Text('Ingresar'),
            ),

            // TODO: Añadir opción "¿Olvidaste tu contraseña?" si se desea
          ],
        ),
      ),
    );
  }
}
