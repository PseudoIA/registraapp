import 'package:flutter/material.dart';
import 'package:registraap/src/features/auth/presentation/screens/login_screen.dart';
import 'package:registraap/src/features/auth/presentation/screens/registro_screen.dart';

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el tema actual para acceder a los estilos definidos
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        // El título es específico de la pantalla
        title: const Text('Bienvenido/a'),
        // Opcional: mantiene el centrado aquí, o defínelo en AppBarTheme
        centerTitle: true,
        // --- ELIMINADOS ---
        // titleTextStyle: theme.textTheme.bodyLarge, // Usará el de AppBarTheme
        // shadowColor: const Color.fromARGB(0, 0, 81, 255), // Usará el de AppBarTheme
        // backgroundColor: const Color.fromARGB(0, 183, 0, 0), // Usará el de AppBarTheme
        // --- FIN ELIMINADOS ---
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0), // Mantenemos el padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TODO: Añadir logo
              // --- Texto Principal con Estilo del Tema ---
              Text(
                'Tu caja móvil', // Corregido 'movil'
                textAlign: TextAlign.center, // El centrado está bien aquí
                // Usamos un estilo del TextTheme global
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight:
                      FontWeight
                          .bold, // Podemos añadir énfasis si el estilo base no lo tiene
                  // El color vendrá del TextTheme por defecto o del ColorScheme
                ),
                // Antes: style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              // --- FIN Texto Principal ---
              const SizedBox(height: 40),
              // --- Botón Iniciar Sesión (Sin style local, correcto) ---
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                // Sin style: hereda de elevatedButtonTheme
                child: const Text('Iniciar Sesión'),
              ),
              const SizedBox(height: 20),
              // --- Botón Registrar Cuenta (Sin style local, correcto) ---
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistroScreen(),
                    ),
                  );
                },
                // Sin style: hereda de elevatedButtonTheme
                child: const Text('Registrar Cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
