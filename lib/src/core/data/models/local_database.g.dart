// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $UsuariosTable extends Usuarios with TableInfo<$UsuariosTable, Usuario> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsuariosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _apellidoMeta = const VerificationMeta(
    'apellido',
  );
  @override
  late final GeneratedColumn<String> apellido = GeneratedColumn<String>(
    'apellido',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _hashContrasenaMeta = const VerificationMeta(
    'hashContrasena',
  );
  @override
  late final GeneratedColumn<String> hashContrasena = GeneratedColumn<String>(
    'hash_contrasena',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RolUsuario, int> rol =
      GeneratedColumn<int>(
        'rol',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<RolUsuario>($UsuariosTable.$converterrol);
  static const VerificationMeta _dateCreatedMeta = const VerificationMeta(
    'dateCreated',
  );
  @override
  late final GeneratedColumn<DateTime> dateCreated = GeneratedColumn<DateTime>(
    'date_created',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    apellido,
    email,
    hashContrasena,
    rol,
    dateCreated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usuarios';
  @override
  VerificationContext validateIntegrity(
    Insertable<Usuario> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('apellido')) {
      context.handle(
        _apellidoMeta,
        apellido.isAcceptableOrUnknown(data['apellido']!, _apellidoMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('hash_contrasena')) {
      context.handle(
        _hashContrasenaMeta,
        hashContrasena.isAcceptableOrUnknown(
          data['hash_contrasena']!,
          _hashContrasenaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hashContrasenaMeta);
    }
    if (data.containsKey('date_created')) {
      context.handle(
        _dateCreatedMeta,
        dateCreated.isAcceptableOrUnknown(
          data['date_created']!,
          _dateCreatedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Usuario map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Usuario(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      nombre:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}nombre'],
          )!,
      apellido: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}apellido'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      hashContrasena:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}hash_contrasena'],
          )!,
      rol: $UsuariosTable.$converterrol.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}rol'],
        )!,
      ),
      dateCreated:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date_created'],
          )!,
    );
  }

  @override
  $UsuariosTable createAlias(String alias) {
    return $UsuariosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RolUsuario, int, int> $converterrol =
      const EnumIndexConverter(RolUsuario.values);
}

class Usuario extends DataClass implements Insertable<Usuario> {
  final int id;
  final String nombre;
  final String? apellido;
  final String? email;
  final String hashContrasena;
  final RolUsuario rol;
  final DateTime dateCreated;
  const Usuario({
    required this.id,
    required this.nombre,
    this.apellido,
    this.email,
    required this.hashContrasena,
    required this.rol,
    required this.dateCreated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || apellido != null) {
      map['apellido'] = Variable<String>(apellido);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['hash_contrasena'] = Variable<String>(hashContrasena);
    {
      map['rol'] = Variable<int>($UsuariosTable.$converterrol.toSql(rol));
    }
    map['date_created'] = Variable<DateTime>(dateCreated);
    return map;
  }

  UsuariosCompanion toCompanion(bool nullToAbsent) {
    return UsuariosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      apellido:
          apellido == null && nullToAbsent
              ? const Value.absent()
              : Value(apellido),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      hashContrasena: Value(hashContrasena),
      rol: Value(rol),
      dateCreated: Value(dateCreated),
    );
  }

  factory Usuario.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Usuario(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      apellido: serializer.fromJson<String?>(json['apellido']),
      email: serializer.fromJson<String?>(json['email']),
      hashContrasena: serializer.fromJson<String>(json['hashContrasena']),
      rol: $UsuariosTable.$converterrol.fromJson(
        serializer.fromJson<int>(json['rol']),
      ),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'apellido': serializer.toJson<String?>(apellido),
      'email': serializer.toJson<String?>(email),
      'hashContrasena': serializer.toJson<String>(hashContrasena),
      'rol': serializer.toJson<int>($UsuariosTable.$converterrol.toJson(rol)),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
    };
  }

  Usuario copyWith({
    int? id,
    String? nombre,
    Value<String?> apellido = const Value.absent(),
    Value<String?> email = const Value.absent(),
    String? hashContrasena,
    RolUsuario? rol,
    DateTime? dateCreated,
  }) => Usuario(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    apellido: apellido.present ? apellido.value : this.apellido,
    email: email.present ? email.value : this.email,
    hashContrasena: hashContrasena ?? this.hashContrasena,
    rol: rol ?? this.rol,
    dateCreated: dateCreated ?? this.dateCreated,
  );
  Usuario copyWithCompanion(UsuariosCompanion data) {
    return Usuario(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      apellido: data.apellido.present ? data.apellido.value : this.apellido,
      email: data.email.present ? data.email.value : this.email,
      hashContrasena:
          data.hashContrasena.present
              ? data.hashContrasena.value
              : this.hashContrasena,
      rol: data.rol.present ? data.rol.value : this.rol,
      dateCreated:
          data.dateCreated.present ? data.dateCreated.value : this.dateCreated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Usuario(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('apellido: $apellido, ')
          ..write('email: $email, ')
          ..write('hashContrasena: $hashContrasena, ')
          ..write('rol: $rol, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    apellido,
    email,
    hashContrasena,
    rol,
    dateCreated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Usuario &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.apellido == this.apellido &&
          other.email == this.email &&
          other.hashContrasena == this.hashContrasena &&
          other.rol == this.rol &&
          other.dateCreated == this.dateCreated);
}

class UsuariosCompanion extends UpdateCompanion<Usuario> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> apellido;
  final Value<String?> email;
  final Value<String> hashContrasena;
  final Value<RolUsuario> rol;
  final Value<DateTime> dateCreated;
  const UsuariosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.apellido = const Value.absent(),
    this.email = const Value.absent(),
    this.hashContrasena = const Value.absent(),
    this.rol = const Value.absent(),
    this.dateCreated = const Value.absent(),
  });
  UsuariosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.apellido = const Value.absent(),
    this.email = const Value.absent(),
    required String hashContrasena,
    required RolUsuario rol,
    this.dateCreated = const Value.absent(),
  }) : nombre = Value(nombre),
       hashContrasena = Value(hashContrasena),
       rol = Value(rol);
  static Insertable<Usuario> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? apellido,
    Expression<String>? email,
    Expression<String>? hashContrasena,
    Expression<int>? rol,
    Expression<DateTime>? dateCreated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (apellido != null) 'apellido': apellido,
      if (email != null) 'email': email,
      if (hashContrasena != null) 'hash_contrasena': hashContrasena,
      if (rol != null) 'rol': rol,
      if (dateCreated != null) 'date_created': dateCreated,
    });
  }

  UsuariosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String?>? apellido,
    Value<String?>? email,
    Value<String>? hashContrasena,
    Value<RolUsuario>? rol,
    Value<DateTime>? dateCreated,
  }) {
    return UsuariosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      email: email ?? this.email,
      hashContrasena: hashContrasena ?? this.hashContrasena,
      rol: rol ?? this.rol,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (apellido.present) {
      map['apellido'] = Variable<String>(apellido.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (hashContrasena.present) {
      map['hash_contrasena'] = Variable<String>(hashContrasena.value);
    }
    if (rol.present) {
      map['rol'] = Variable<int>($UsuariosTable.$converterrol.toSql(rol.value));
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsuariosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('apellido: $apellido, ')
          ..write('email: $email, ')
          ..write('hashContrasena: $hashContrasena, ')
          ..write('rol: $rol, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsuariosTable usuarios = $UsuariosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [usuarios];
}

typedef $$UsuariosTableCreateCompanionBuilder =
    UsuariosCompanion Function({
      Value<int> id,
      required String nombre,
      Value<String?> apellido,
      Value<String?> email,
      required String hashContrasena,
      required RolUsuario rol,
      Value<DateTime> dateCreated,
    });
typedef $$UsuariosTableUpdateCompanionBuilder =
    UsuariosCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String?> apellido,
      Value<String?> email,
      Value<String> hashContrasena,
      Value<RolUsuario> rol,
      Value<DateTime> dateCreated,
    });

class $$UsuariosTableFilterComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apellido => $composableBuilder(
    column: $table.apellido,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hashContrasena => $composableBuilder(
    column: $table.hashContrasena,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RolUsuario, RolUsuario, int> get rol =>
      $composableBuilder(
        column: $table.rol,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get dateCreated => $composableBuilder(
    column: $table.dateCreated,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsuariosTableOrderingComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apellido => $composableBuilder(
    column: $table.apellido,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hashContrasena => $composableBuilder(
    column: $table.hashContrasena,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rol => $composableBuilder(
    column: $table.rol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateCreated => $composableBuilder(
    column: $table.dateCreated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsuariosTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get apellido =>
      $composableBuilder(column: $table.apellido, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get hashContrasena => $composableBuilder(
    column: $table.hashContrasena,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<RolUsuario, int> get rol =>
      $composableBuilder(column: $table.rol, builder: (column) => column);

  GeneratedColumn<DateTime> get dateCreated => $composableBuilder(
    column: $table.dateCreated,
    builder: (column) => column,
  );
}

class $$UsuariosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsuariosTable,
          Usuario,
          $$UsuariosTableFilterComposer,
          $$UsuariosTableOrderingComposer,
          $$UsuariosTableAnnotationComposer,
          $$UsuariosTableCreateCompanionBuilder,
          $$UsuariosTableUpdateCompanionBuilder,
          (Usuario, BaseReferences<_$AppDatabase, $UsuariosTable, Usuario>),
          Usuario,
          PrefetchHooks Function()
        > {
  $$UsuariosTableTableManager(_$AppDatabase db, $UsuariosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$UsuariosTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$UsuariosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$UsuariosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> apellido = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String> hashContrasena = const Value.absent(),
                Value<RolUsuario> rol = const Value.absent(),
                Value<DateTime> dateCreated = const Value.absent(),
              }) => UsuariosCompanion(
                id: id,
                nombre: nombre,
                apellido: apellido,
                email: email,
                hashContrasena: hashContrasena,
                rol: rol,
                dateCreated: dateCreated,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<String?> apellido = const Value.absent(),
                Value<String?> email = const Value.absent(),
                required String hashContrasena,
                required RolUsuario rol,
                Value<DateTime> dateCreated = const Value.absent(),
              }) => UsuariosCompanion.insert(
                id: id,
                nombre: nombre,
                apellido: apellido,
                email: email,
                hashContrasena: hashContrasena,
                rol: rol,
                dateCreated: dateCreated,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsuariosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsuariosTable,
      Usuario,
      $$UsuariosTableFilterComposer,
      $$UsuariosTableOrderingComposer,
      $$UsuariosTableAnnotationComposer,
      $$UsuariosTableCreateCompanionBuilder,
      $$UsuariosTableUpdateCompanionBuilder,
      (Usuario, BaseReferences<_$AppDatabase, $UsuariosTable, Usuario>),
      Usuario,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db, _db.usuarios);
}
