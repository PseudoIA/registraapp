// lib/src/core/data/local_database.dart

// --- Imports necesarios ---
import 'dart:io'; // Para Platform
import 'package:drift/drift.dart';
import 'package:drift/native.dart'; // Para NativeDatabase
import 'package:path_provider/path_provider.dart'; // Para rutas
import 'package:path/path.dart' as p; // Para unir rutas
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart'; // Bundler SQLite
import 'package:sqlite3/sqlite3.dart'; // Bindings SQLite
// Importar modelos
import 'package:registraap/src/core/data/models/usuario.dart'; // Asegúrate que la ruta es correcta
// 2. LUEGO va la directiva part:
part 'local_database.g.dart';

final AppDatabase database = AppDatabase();

// --- Definición de Tabla (La que ya tienes y está bien) ---
class Usuarios extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get apellido => text().nullable()();
  TextColumn get email => text().nullable().unique()();
  TextColumn get hashContrasena => text().named('hash_contrasena')();
  IntColumn get rol =>
      integer().map(const EnumIndexConverter(RolUsuario.values))();
  DateTimeColumn get dateCreated =>
      dateTime().named('date_created').clientDefault(() => DateTime.now())();
}
// --- Fin Definición de Tabla ---

// --- ¡ASEGÚRATE DE TENER ESTA ANOTACIÓN Y CLASE! ---
@DriftDatabase(tables: [Usuarios]) // Lista las tablas de tu DB
class AppDatabase extends _$AppDatabase {
  // Extiende la clase generada
  // Constructor (usaremos el helper _openConnection)
  AppDatabase() : super(_openConnection());

  // Versión del esquema (empieza en 1)
  @override
  int get schemaVersion => 1;

  // --- Métodos para interactuar (los implementaremos de verdad después) ---
  Future<int> insertUsuario(UsuariosCompanion usuarioCompanion) {
    // 'into(usuarios)' selecciona la tabla 'usuarios' (el accesor generado)
    // '.insert()' realiza la operación de inserción
    // 'usuarioCompanion' contiene los datos a insertar de forma segura
    return into(usuarios).insert(usuarioCompanion);
    // Drift se encarga de ejecutar el SQL. Esto devuelve el ID auto-generado del nuevo usuario.
  }

  Future<List<Usuario>> getAllUsuarios() async {
    // return select(usuarios).get();
    print('Placeholder: Obteniendo usuarios...');
    return [];
  }

  // TODO: Más métodos (get by id, update, delete...)
} // --- Fin Clase AppDatabase ---

// --- ¡ASEGÚRATE DE TENER ESTA FUNCIÓN HELPER! ---
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'registraapp_db.sqlite'));

    // Workaround para versiones viejas de Android y config de SQLite nativo
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
      final cachebase = (await getTemporaryDirectory()).path;
      sqlite3.tempDirectory = cachebase;
    }

    return NativeDatabase.createInBackground(file);
  });
}
// --- Fin Función Helper ---