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
import 'package:registraap/src/core/data/models/venta.dart'; // Asegúrate que la ruta es correcta
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

class Ventas extends Table {
  // Llave primaria auto-incremental
  IntColumn get id => integer().autoIncrement()();

  // Fecha y hora exactas de la venta (la app la establecerá al guardar)
  DateTimeColumn get timestamp => dateTime()();

  // Tipo de venta (Efectivo/Digital) - Guardamos el índice del enum
  IntColumn get tipo =>
      integer().map(const EnumIndexConverter(TipoVenta.values))();

  // Monto de la venta - Usamos Real para permitir decimales (moneda)
  RealColumn get valor => real()();

  // Descripción opcional de la venta
  TextColumn get descripcion => text().nullable()();

  // ID del usuario que registró la venta (referencia a la tabla Usuarios)
  IntColumn get idUsuario => integer().named('id_usuario')();
  // Nota: Podríamos añadir una restricción formal de llave foránea aquí,
  // pero por simplicidad inicial, solo guardamos el ID.

  // Estado de la venta (Normal/Modificada) - Default a Normal
  IntColumn get estado =>
      integer()
          .map(const EnumIndexConverter(EstadoVenta.values))
          .withDefault(
            Constant(EstadoVenta.normal.index),
          )(); // Por defecto es 'Normal'

  // Ruta a la imagen del comprobante (para ventas Digitales)
  TextColumn get rutaImagenComprobante =>
      text().named('ruta_imagen_comprobante').nullable()();
}
// --- Fin Definición Tabla Ventas ---

// --- ¡ASEGÚRATE DE TENER ESTA ANOTACIÓN Y CLASE! ---
@DriftDatabase(tables: [Usuarios, Ventas]) // Lista las tablas de tu DB
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

  // --- Método para buscar un usuario por su email ---
  // Devuelve el Usuario si lo encuentra, o null si no existe.
  Future<Usuario?> getUsuarioPorEmail(String email) {
    // Construimos la consulta: SELECT * FROM usuarios WHERE email = ? LIMIT 1
    return (select(usuarios)
      ..where((tbl) => tbl.email.equals(email))).getSingleOrNull();
  }

  // Podríamos añadir otro para buscar por ID si lo necesitamos después:
  Future<Usuario?> getUsuarioPorId(int id) {
    return (select(usuarios)
      ..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // --- Método para INSERTAR una nueva venta ---
  Future<int> insertVenta(VentasCompanion ventaCompanion) {
    // Usa la tabla 'ventas' (generada) y el método 'insert'
    return into(ventas).insert(ventaCompanion);
    // Devuelve el ID auto-generado de la nueva venta
  }

  // --- Método para OBTENER todas las ventas de una fecha específica ---
  // Recibe un DateTime 'fecha' y devuelve una lista de objetos 'Venta' (generados por drift)
  Future<List<Venta>> getVentasDelDia(DateTime fecha) {
    // Calcula el inicio y fin del día para la fecha dada
    final inicioDelDia = DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
    ); // YYYY-MM-DD 00:00:00
    final finDelDia = DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
      23,
      59,
      59,
      999,
    ); // YYYY-MM-DD 23:59:59.999

    // Construye la consulta SELECT ... WHERE timestamp BETWEEN ? AND ? ORDER BY timestamp DESC
    return (select(ventas) // Selecciona de la tabla 'ventas'
          ..where(
            (tbl) => // Añade la condición WHERE
                tbl.timestamp.isBetween(
              Constant(inicioDelDia), // <-- Envuelto en Constant()
              Constant(finDelDia),
            ), // <-- Envuelto en Constant()),
          ) // La columna 'timestamp' está entre inicio y fin del día
          ..orderBy([
            // Ordena los resultados
            // Ordena por timestamp descendente (la más reciente primero)
            (tbl) => OrderingTerm(
              expression: tbl.timestamp,
              mode: OrderingMode.desc,
            ),
          ]))
        .get(); // Ejecuta la consulta y devuelve la lista de resultados (Future<List<Venta>>)
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