import 'package:flutter/material.dart';
import 'dart:convert'; // Para utf8.encode
import 'package:crypto/crypto.dart'; // Para sha256
import 'package:shared_preferences/shared_preferences.dart'; // Para guardar sesión
import 'package:registraap/src/core/data/models/local_database.dart'; // Para 'database' y 'Usuario'
// Importa la pantalla placeholder que acabamos de crear
import 'package:registraap/src/features/shell/presentation/screens/main_shell_screen.dart';

// Importa la función showErrorSnackBar que definimos en RegistroScreen (o cópiala aquí)
// Podríamos moverla a un archivo de utilidades común más adelante.
// Por ahora, la forma más fácil es copiar la función showErrorSnackBar
// desde _RegistroScreenState y pegarla DENTRO de _LoginScreenState.
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
              onPressed: () async {
                // Convertimos onPressed a async

                // --- 1. Leer Input ---
                final email = _emailController.text.trim();
                final password = _passwordController.text;
                final BuildContext currentContext = context; // Captura context
                final NavigatorState navigator = Navigator.of(
                  currentContext,
                ); // Captura Navigator
                final ScaffoldMessengerState scaffoldMessenger =
                    ScaffoldMessenger.of(
                      currentContext,
                    ); // Captura ScaffoldMessenger

                // Ocultar teclado
                FocusScope.of(currentContext).unfocus();

                // --- 2. Validación Simple ---
                if (email.isEmpty || password.isEmpty) {
                  // Usar scaffoldMessenger capturado
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('Email y contraseña son obligatorios'),
                      backgroundColor: Colors.orangeAccent,
                    ),
                  );
                  // showErrorSnackBar(currentContext, 'Email y contraseña son obligatorios'); // Si copiaste la función
                  return;
                }

                try {
                  // --- 3. Buscar Usuario en DB ---
                  print('Buscando usuario con email: $email');
                  final usuarioEncontrado = await database.getUsuarioPorEmail(
                    email,
                  );

                  // --- 4. Verificar si Existe ---
                  if (usuarioEncontrado == null) {
                    print('Usuario no encontrado');
                    if (!currentContext.mounted) return; // Re-check mounted
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text('Email o contraseña incorrectos'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    // showErrorSnackBar(currentContext, 'Email o contraseña incorrectos');
                    return;
                  }

                  print('Usuario encontrado: ${usuarioEncontrado.nombre}');

                  // --- 5. Verificar Contraseña ---

                  // Hashear la contraseña ingresada EXACTAMENTE igual que en el registro
                  var bytes = utf8.encode(password);
                  var digest = sha256.convert(bytes);
                  var hashIngresado = digest.toString();
                  print('Hash ingresado: $hashIngresado');
                  print('Hash almacenado: ${usuarioEncontrado.hashContrasena}');

                  // Comparar los hashes
                  if (hashIngresado == usuarioEncontrado.hashContrasena) {
                    // --- ¡LOGIN EXITOSO! ---
                    print(
                      '¡Login Exitoso para el usuario ID: ${usuarioEncontrado.id}!',
                    );

                    // Guardar sesión usando SharedPreferences
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt(
                      'userId',
                      usuarioEncontrado.id,
                    ); // Guardamos el ID
                    print('ID de usuario guardado en SharedPreferences.');

                    if (!currentContext.mounted) return; // Re-check mounted

                    // Navegar a la pantalla principal, REEMPLAZANDO la pila de login/bienvenida
                    navigator.pushReplacement(
                      // <-- pushReplacement
                      MaterialPageRoute(
                        builder: (context) => const MainShellScreen(),
                      ),
                    );
                  } else {
                    // --- Contraseña Incorrecta ---
                    print('Contraseña incorrecta');
                    if (!currentContext.mounted) return; // Re-check mounted
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text('Email o contraseña incorrectos'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    // showErrorSnackBar(currentContext, 'Email o contraseña incorrectos');
                    // Limpiar campo de contraseña
                    _passwordController.clear();
                  }
                } catch (e, stacktrace) {
                  // --- Manejo de Errores de DB u otros ---
                  print('Error durante el login: $e');
                  print(stacktrace);
                  if (!currentContext.mounted) return; // Re-check mounted
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Error al iniciar sesión: ${e.toString()}'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  // showErrorSnackBar(currentContext, 'Error al iniciar sesión.');
                }
              }, // Fin de onPressed async
              child: const Text('Ingresar'),
            ),
            // TODO: Añadir opción "¿Olvidaste tu contraseña?" si se desea
          ],
        ),
      ),
    );
  }
}
