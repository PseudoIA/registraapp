// main.dart
// --- VERSIÓN COMPLETA Y MODIFICADA CON LOCALIZACIONES ---

import 'package:flutter/material.dart';
import 'dart:async'; // Para Future
// import 'package:flutter/material.dart'; // Duplicado, eliminado
import 'package:registraap/src/features/auth/presentation/screens/bienvenida_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Añadido
// import 'package:registraap/src/features/auth/presentation/screens/bienvenida_screen.dart'; // Duplicado, eliminado
import 'package:intl/date_symbol_data_local.dart'; // Para initializeDateFormatting
import 'package:registraap/src/features/shell/presentation/screens/main_shell_screen.dart'; // Asegúrate que la ruta sea correcta
import 'package:flutter_localizations/flutter_localizations.dart'; // Necesario para los delegates

Future<void> main() async {
  // Asegura que los bindings de Flutter estén listos
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa el formato de fechas para español
  await initializeDateFormatting('es_ES', null);
  print('Formato de fecha inicializado para es_ES.');
  runApp(const MyApp());
}

// AuthWrapper: Maneja el estado inicial de sesión
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // La función que comprueba SharedPreferences
  Future<int?> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // Devuelve el userId guardado, o null si no existe la clave 'userId'
    return prefs.getInt('userId');
  }

  @override
  Widget build(BuildContext context) {
    // FutureBuilder ejecuta el future y reconstruye la UI según el estado
    return FutureBuilder<int?>(
      future: _checkLoginStatus(), // El Future que queremos ejecutar
      builder: (context, snapshot) {
        // snapshot contiene el estado del Future

        // Mientras el Future está esperando (cargando SharedPreferences)
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga simple
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // Si hubo un error al leer SharedPreferences
        else if (snapshot.hasError) {
          print("Error en AuthWrapper: ${snapshot.error}"); // Log del error
          return const Scaffold(
            body: Center(child: Text('Error al cargar estado de sesión')),
          );
        }
        // Si el Future completó y SÍ tiene datos (y no son null) -> Usuario logueado
        else if (snapshot.hasData && snapshot.data != null) {
          print(
            'AuthWrapper: Usuario logueado encontrado (ID: ${snapshot.data}), mostrando MainShellScreen', // Mensaje actualizado
          );
          return const MainShellScreen(); // Ir a la pantalla principal (Shell)
        }
        // Si el Future completó pero NO tiene datos o son null -> No hay sesión
        else {
          print(
            'AuthWrapper: No se encontró sesión de usuario, mostrando BienvenidaScreen',
          );
          return const BienvenidaScreen(); // Ir a la pantalla de bienvenida/login
        }
      },
    );
  }
}

// MyApp: El widget raíz de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Definición del ColorScheme base
    final baseColorScheme = ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(184, 255, 0, 149),
      // Puedes añadir más personalizaciones al ColorScheme aquí si quieres:
      // brightness: Brightness.light,
      // primary: const Color(0xFF...),
      // secondary: const Color(0xFF...),
      // error: const Color(0xFF...),
      // background: const Color(0xFF...),
      // surface: const Color(0xFF...),
      // onPrimary: Colors.white,
      // onSecondary: Colors.black,
      // onError: Colors.white,
      // onBackground: Colors.black,
      // onSurface: Colors.black,
    );

    // Definición del ThemeData completo
    final appTheme = ThemeData(
      // 1. Activar Material 3
      useMaterial3: true,

      // 2. Usar el ColorScheme definido
      colorScheme: baseColorScheme,

      // 3. TextTheme (usando el por defecto de M3 por ahora, como lo tenías)
      // textTheme: const TextTheme( ... ), // Comentado
      // fontFamily: 'TuFuente', // Descomenta y define si usas fuente personalizada

      // 4. Temas Específicos de Componentes (tal como los tenías)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: baseColorScheme.primary,
          foregroundColor: baseColorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: baseColorScheme.primary, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        labelStyle: TextStyle(
          color: baseColorScheme.onSurface.withOpacity(0.7),
        ),
        // Podrías añadir hintStyle, errorStyle, errorBorder, etc.
      ),

      cardTheme: CardTheme(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        // color: baseColorScheme.surface, // Color de fondo de la tarjeta
        // margin: const EdgeInsets.all(8.0), // Margen exterior
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: baseColorScheme.surfaceContainerHighest,
        foregroundColor: baseColorScheme.onSurfaceVariant,
        elevation: 0.5,
        centerTitle: true,
        // titleTextStyle: TextStyle(...) // Si quieres un estilo específico para el título
        // iconTheme: IconThemeData(...) // Para los iconos del AppBar
      ),

      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: baseColorScheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
          (Set<WidgetState> states) =>
              states.contains(WidgetState.selected)
                  ? TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        baseColorScheme
                            .onSurface, // Color etiqueta seleccionada
                  )
                  : TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: baseColorScheme.onSurface.withOpacity(
                      0.7,
                    ), // Color etiqueta normal
                  ),
        ),
        // iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(...) // Para estilos de iconos
        // backgroundColor: baseColorScheme.surface, // Color de fondo de la barra
        // elevation: 3.0, // Sombra de la barra
      ),

      // Puedes añadir más temas aquí:
      // textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(...)),
      // outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(...)),
      // dialogTheme: DialogTheme(...),
      // scaffoldBackgroundColor: baseColorScheme.background, // Color de fondo por defecto
    ); // Fin ThemeData

    // Construcción del MaterialApp
    return MaterialApp(
      title: 'RegistraApp', // Título de la aplicación
      theme: appTheme, // Aplicar el tema definido
      // --- Configuración de Localización ---
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // Inglés
        Locale('es', ''), // Español
      ],
      // locale: const Locale('es'), // Descomenta para forzar español
      // --- Fin Configuración de Localización ---

      // Widget inicial que maneja la autenticación
      home: const AuthWrapper(),

      // Opcional: quitar el banner "DEBUG"
      debugShowCheckedModeBanner: false,
    );
  }
}

// --- Código de Ejemplo Inicial (MyHomePage) ---
// Si ya no utilizas esta parte, puedes eliminarla para limpiar el archivo.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
// --- Fin Código de Ejemplo Inicial ---