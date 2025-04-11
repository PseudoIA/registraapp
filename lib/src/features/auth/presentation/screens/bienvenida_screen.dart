import 'package:flutter/material.dart';
import 'package:registraap/src/features/auth/presentation/screens/login_screen.dart'; // Ajusta si es necesario
import 'package:registraap/src/features/auth/presentation/screens/registro_screen.dart';

// Usamos StatelessWidget porque esta pantalla solo mostrará contenido
// y delegará las acciones (navegación) a los botones.
class BienvenidaScreen extends StatelessWidget {
  // Constructor estándar para Widgets en Flutter
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold nos da la estructura básica de una pantalla (AppBar, Body, etc.)

    return Scaffold(
      appBar: AppBar(
        // Un título simple para la barra superior
        title: const Text('Bienvenido/a'),

        // Centra el título (opcional, estético)
        centerTitle: true,
        titleTextStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        shadowColor: const Color.fromARGB(0, 0, 81, 255),
        backgroundColor: const Color.fromARGB(0, 183, 0, 0),
      ),
      // El cuerpo principal de la pantalla
      body: Center(
        // Centra el contenido vertical y horizontalmente
        child: Padding(
          // Añade un poco de espacio alrededor de los elementos
          padding: const EdgeInsets.all(32.0),
          child: Column(
            // Organiza los elementos en una columna vertical
            mainAxisAlignment:
                MainAxisAlignment.center, // Centra verticalmente la columna
            crossAxisAlignment:
                CrossAxisAlignment
                    .stretch, // Estira los elementos horizontalmente
            children: [
              // TODO: Añadir un logo o imagen bienvenida aquí si se desea
              const Text(
                'Tu caja movil', // O el nombre final de tu app
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40), // Espacio vertical
              // Botón para ir a Iniciar Sesión
              ElevatedButton(
                // La acción que se ejecuta al presionar. Por ahora, vacía.
                // TODO: Implementar navegación a LoginScreen
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                  print('Botón Iniciar Sesión presionado'); // Mensaje temporal
                },
                child: const Text('Iniciar Sesión'),
              ),
              const SizedBox(height: 20), // Espacio vertical
              // Botón para ir a Registrar Cuenta
              ElevatedButton(
                // TODO: Implementar navegación a RegistroScreen
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistroScreen(),
                    ),
                  ); // Mensaje temporal
                },
                style: ElevatedButton.styleFrom(
                  // Opcional: Estilo diferente para el botón secundario
                  // backgroundColor: Colors.grey, // Ejemplo
                ),
                child: const Text('Registrar Cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
