import 'package:flutter/material.dart';
import 'dart:async'; // Para Future
import 'package:flutter/material.dart';
import 'package:registraap/src/features/auth/presentation/screens/bienvenida_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Añadido
import 'package:registraap/src/features/auth/presentation/screens/bienvenida_screen.dart'; // Verifica ruta

import 'package:registraap/src/features/shell/presentation/screens/main_shell_screen.dart';
// Ajusta la ruta si es necesario

void main() async {
  // Asegura que los bindings de Flutter estén listos antes de usar plugins como SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

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
          return const Scaffold(
            body: Center(child: Text('Error al cargar estado de sesión')),
          );
        }
        // Si el Future completó y SÍ tiene datos (y no son null) -> Usuario logueado
        else if (snapshot.hasData && snapshot.data != null) {
          print(
            'Usuario logueado encontrado (ID: ${snapshot.data}), mostrando VentasDiariasScreen',
          );
          return const MainShellScreen(); // Ir a la pantalla principal
        }
        // Si el Future completó pero NO tiene datos o son null -> No hay sesión
        else {
          print('No se encontró sesión de usuario, mostrando BienvenidaScreen');
          return const BienvenidaScreen(); // Ir a la pantalla de bienvenida/login
        }
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          bodyMedium: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          bodySmall: TextStyle(color: Colors.white),
        ),
      ),
      home: const AuthWrapper(), // <-- CAMBIADO AQUÍ
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
