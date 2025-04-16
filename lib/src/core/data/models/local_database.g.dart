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

class $VentasTable extends Ventas with TableInfo<$VentasTable, Venta> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VentasTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoVenta, int> tipo =
      GeneratedColumn<int>(
        'tipo',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TipoVenta>($VentasTable.$convertertipo);
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<double> valor = GeneratedColumn<double>(
    'valor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idUsuarioMeta = const VerificationMeta(
    'idUsuario',
  );
  @override
  late final GeneratedColumn<int> idUsuario = GeneratedColumn<int>(
    'id_usuario',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EstadoVenta, int> estado =
      GeneratedColumn<int>(
        'estado',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: Constant(EstadoVenta.normal.index),
      ).withConverter<EstadoVenta>($VentasTable.$converterestado);
  static const VerificationMeta _rutaImagenComprobanteMeta =
      const VerificationMeta('rutaImagenComprobante');
  @override
  late final GeneratedColumn<String> rutaImagenComprobante =
      GeneratedColumn<String>(
        'ruta_imagen_comprobante',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    tipo,
    valor,
    descripcion,
    idUsuario,
    estado,
    rutaImagenComprobante,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ventas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Venta> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('id_usuario')) {
      context.handle(
        _idUsuarioMeta,
        idUsuario.isAcceptableOrUnknown(data['id_usuario']!, _idUsuarioMeta),
      );
    } else if (isInserting) {
      context.missing(_idUsuarioMeta);
    }
    if (data.containsKey('ruta_imagen_comprobante')) {
      context.handle(
        _rutaImagenComprobanteMeta,
        rutaImagenComprobante.isAcceptableOrUnknown(
          data['ruta_imagen_comprobante']!,
          _rutaImagenComprobanteMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Venta map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Venta(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      timestamp:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}timestamp'],
          )!,
      tipo: $VentasTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      valor:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}valor'],
          )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      ),
      idUsuario:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id_usuario'],
          )!,
      estado: $VentasTable.$converterestado.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}estado'],
        )!,
      ),
      rutaImagenComprobante: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ruta_imagen_comprobante'],
      ),
    );
  }

  @override
  $VentasTable createAlias(String alias) {
    return $VentasTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoVenta, int, int> $convertertipo =
      const EnumIndexConverter(TipoVenta.values);
  static JsonTypeConverter2<EstadoVenta, int, int> $converterestado =
      const EnumIndexConverter(EstadoVenta.values);
}

class Venta extends DataClass implements Insertable<Venta> {
  final int id;
  final DateTime timestamp;
  final TipoVenta tipo;
  final double valor;
  final String? descripcion;
  final int idUsuario;
  final EstadoVenta estado;
  final String? rutaImagenComprobante;
  const Venta({
    required this.id,
    required this.timestamp,
    required this.tipo,
    required this.valor,
    this.descripcion,
    required this.idUsuario,
    required this.estado,
    this.rutaImagenComprobante,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    {
      map['tipo'] = Variable<int>($VentasTable.$convertertipo.toSql(tipo));
    }
    map['valor'] = Variable<double>(valor);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    map['id_usuario'] = Variable<int>(idUsuario);
    {
      map['estado'] = Variable<int>(
        $VentasTable.$converterestado.toSql(estado),
      );
    }
    if (!nullToAbsent || rutaImagenComprobante != null) {
      map['ruta_imagen_comprobante'] = Variable<String>(rutaImagenComprobante);
    }
    return map;
  }

  VentasCompanion toCompanion(bool nullToAbsent) {
    return VentasCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      tipo: Value(tipo),
      valor: Value(valor),
      descripcion:
          descripcion == null && nullToAbsent
              ? const Value.absent()
              : Value(descripcion),
      idUsuario: Value(idUsuario),
      estado: Value(estado),
      rutaImagenComprobante:
          rutaImagenComprobante == null && nullToAbsent
              ? const Value.absent()
              : Value(rutaImagenComprobante),
    );
  }

  factory Venta.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Venta(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      tipo: $VentasTable.$convertertipo.fromJson(
        serializer.fromJson<int>(json['tipo']),
      ),
      valor: serializer.fromJson<double>(json['valor']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      idUsuario: serializer.fromJson<int>(json['idUsuario']),
      estado: $VentasTable.$converterestado.fromJson(
        serializer.fromJson<int>(json['estado']),
      ),
      rutaImagenComprobante: serializer.fromJson<String?>(
        json['rutaImagenComprobante'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'tipo': serializer.toJson<int>($VentasTable.$convertertipo.toJson(tipo)),
      'valor': serializer.toJson<double>(valor),
      'descripcion': serializer.toJson<String?>(descripcion),
      'idUsuario': serializer.toJson<int>(idUsuario),
      'estado': serializer.toJson<int>(
        $VentasTable.$converterestado.toJson(estado),
      ),
      'rutaImagenComprobante': serializer.toJson<String?>(
        rutaImagenComprobante,
      ),
    };
  }

  Venta copyWith({
    int? id,
    DateTime? timestamp,
    TipoVenta? tipo,
    double? valor,
    Value<String?> descripcion = const Value.absent(),
    int? idUsuario,
    EstadoVenta? estado,
    Value<String?> rutaImagenComprobante = const Value.absent(),
  }) => Venta(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    tipo: tipo ?? this.tipo,
    valor: valor ?? this.valor,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    idUsuario: idUsuario ?? this.idUsuario,
    estado: estado ?? this.estado,
    rutaImagenComprobante:
        rutaImagenComprobante.present
            ? rutaImagenComprobante.value
            : this.rutaImagenComprobante,
  );
  Venta copyWithCompanion(VentasCompanion data) {
    return Venta(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      valor: data.valor.present ? data.valor.value : this.valor,
      descripcion:
          data.descripcion.present ? data.descripcion.value : this.descripcion,
      idUsuario: data.idUsuario.present ? data.idUsuario.value : this.idUsuario,
      estado: data.estado.present ? data.estado.value : this.estado,
      rutaImagenComprobante:
          data.rutaImagenComprobante.present
              ? data.rutaImagenComprobante.value
              : this.rutaImagenComprobante,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Venta(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('tipo: $tipo, ')
          ..write('valor: $valor, ')
          ..write('descripcion: $descripcion, ')
          ..write('idUsuario: $idUsuario, ')
          ..write('estado: $estado, ')
          ..write('rutaImagenComprobante: $rutaImagenComprobante')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    timestamp,
    tipo,
    valor,
    descripcion,
    idUsuario,
    estado,
    rutaImagenComprobante,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Venta &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.tipo == this.tipo &&
          other.valor == this.valor &&
          other.descripcion == this.descripcion &&
          other.idUsuario == this.idUsuario &&
          other.estado == this.estado &&
          other.rutaImagenComprobante == this.rutaImagenComprobante);
}

class VentasCompanion extends UpdateCompanion<Venta> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<TipoVenta> tipo;
  final Value<double> valor;
  final Value<String?> descripcion;
  final Value<int> idUsuario;
  final Value<EstadoVenta> estado;
  final Value<String?> rutaImagenComprobante;
  const VentasCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.tipo = const Value.absent(),
    this.valor = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.idUsuario = const Value.absent(),
    this.estado = const Value.absent(),
    this.rutaImagenComprobante = const Value.absent(),
  });
  VentasCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required TipoVenta tipo,
    required double valor,
    this.descripcion = const Value.absent(),
    required int idUsuario,
    this.estado = const Value.absent(),
    this.rutaImagenComprobante = const Value.absent(),
  }) : timestamp = Value(timestamp),
       tipo = Value(tipo),
       valor = Value(valor),
       idUsuario = Value(idUsuario);
  static Insertable<Venta> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<int>? tipo,
    Expression<double>? valor,
    Expression<String>? descripcion,
    Expression<int>? idUsuario,
    Expression<int>? estado,
    Expression<String>? rutaImagenComprobante,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (tipo != null) 'tipo': tipo,
      if (valor != null) 'valor': valor,
      if (descripcion != null) 'descripcion': descripcion,
      if (idUsuario != null) 'id_usuario': idUsuario,
      if (estado != null) 'estado': estado,
      if (rutaImagenComprobante != null)
        'ruta_imagen_comprobante': rutaImagenComprobante,
    });
  }

  VentasCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<TipoVenta>? tipo,
    Value<double>? valor,
    Value<String?>? descripcion,
    Value<int>? idUsuario,
    Value<EstadoVenta>? estado,
    Value<String?>? rutaImagenComprobante,
  }) {
    return VentasCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      tipo: tipo ?? this.tipo,
      valor: valor ?? this.valor,
      descripcion: descripcion ?? this.descripcion,
      idUsuario: idUsuario ?? this.idUsuario,
      estado: estado ?? this.estado,
      rutaImagenComprobante:
          rutaImagenComprobante ?? this.rutaImagenComprobante,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<int>(
        $VentasTable.$convertertipo.toSql(tipo.value),
      );
    }
    if (valor.present) {
      map['valor'] = Variable<double>(valor.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (idUsuario.present) {
      map['id_usuario'] = Variable<int>(idUsuario.value);
    }
    if (estado.present) {
      map['estado'] = Variable<int>(
        $VentasTable.$converterestado.toSql(estado.value),
      );
    }
    if (rutaImagenComprobante.present) {
      map['ruta_imagen_comprobante'] = Variable<String>(
        rutaImagenComprobante.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VentasCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('tipo: $tipo, ')
          ..write('valor: $valor, ')
          ..write('descripcion: $descripcion, ')
          ..write('idUsuario: $idUsuario, ')
          ..write('estado: $estado, ')
          ..write('rutaImagenComprobante: $rutaImagenComprobante')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsuariosTable usuarios = $UsuariosTable(this);
  late final $VentasTable ventas = $VentasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [usuarios, ventas];
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
typedef $$VentasTableCreateCompanionBuilder =
    VentasCompanion Function({
      Value<int> id,
      required DateTime timestamp,
      required TipoVenta tipo,
      required double valor,
      Value<String?> descripcion,
      required int idUsuario,
      Value<EstadoVenta> estado,
      Value<String?> rutaImagenComprobante,
    });
typedef $$VentasTableUpdateCompanionBuilder =
    VentasCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<TipoVenta> tipo,
      Value<double> valor,
      Value<String?> descripcion,
      Value<int> idUsuario,
      Value<EstadoVenta> estado,
      Value<String?> rutaImagenComprobante,
    });

class $$VentasTableFilterComposer
    extends Composer<_$AppDatabase, $VentasTable> {
  $$VentasTableFilterComposer({
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

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoVenta, TipoVenta, int> get tipo =>
      $composableBuilder(
        column: $table.tipo,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get idUsuario => $composableBuilder(
    column: $table.idUsuario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EstadoVenta, EstadoVenta, int> get estado =>
      $composableBuilder(
        column: $table.estado,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get rutaImagenComprobante => $composableBuilder(
    column: $table.rutaImagenComprobante,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VentasTableOrderingComposer
    extends Composer<_$AppDatabase, $VentasTable> {
  $$VentasTableOrderingComposer({
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

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get idUsuario => $composableBuilder(
    column: $table.idUsuario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rutaImagenComprobante => $composableBuilder(
    column: $table.rutaImagenComprobante,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VentasTableAnnotationComposer
    extends Composer<_$AppDatabase, $VentasTable> {
  $$VentasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoVenta, int> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<double> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get idUsuario =>
      $composableBuilder(column: $table.idUsuario, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EstadoVenta, int> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<String> get rutaImagenComprobante => $composableBuilder(
    column: $table.rutaImagenComprobante,
    builder: (column) => column,
  );
}

class $$VentasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VentasTable,
          Venta,
          $$VentasTableFilterComposer,
          $$VentasTableOrderingComposer,
          $$VentasTableAnnotationComposer,
          $$VentasTableCreateCompanionBuilder,
          $$VentasTableUpdateCompanionBuilder,
          (Venta, BaseReferences<_$AppDatabase, $VentasTable, Venta>),
          Venta,
          PrefetchHooks Function()
        > {
  $$VentasTableTableManager(_$AppDatabase db, $VentasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$VentasTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$VentasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$VentasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<TipoVenta> tipo = const Value.absent(),
                Value<double> valor = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<int> idUsuario = const Value.absent(),
                Value<EstadoVenta> estado = const Value.absent(),
                Value<String?> rutaImagenComprobante = const Value.absent(),
              }) => VentasCompanion(
                id: id,
                timestamp: timestamp,
                tipo: tipo,
                valor: valor,
                descripcion: descripcion,
                idUsuario: idUsuario,
                estado: estado,
                rutaImagenComprobante: rutaImagenComprobante,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                required TipoVenta tipo,
                required double valor,
                Value<String?> descripcion = const Value.absent(),
                required int idUsuario,
                Value<EstadoVenta> estado = const Value.absent(),
                Value<String?> rutaImagenComprobante = const Value.absent(),
              }) => VentasCompanion.insert(
                id: id,
                timestamp: timestamp,
                tipo: tipo,
                valor: valor,
                descripcion: descripcion,
                idUsuario: idUsuario,
                estado: estado,
                rutaImagenComprobante: rutaImagenComprobante,
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

typedef $$VentasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VentasTable,
      Venta,
      $$VentasTableFilterComposer,
      $$VentasTableOrderingComposer,
      $$VentasTableAnnotationComposer,
      $$VentasTableCreateCompanionBuilder,
      $$VentasTableUpdateCompanionBuilder,
      (Venta, BaseReferences<_$AppDatabase, $VentasTable, Venta>),
      Venta,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db, _db.usuarios);
  $$VentasTableTableManager get ventas =>
      $$VentasTableTableManager(_db, _db.ventas);
}
