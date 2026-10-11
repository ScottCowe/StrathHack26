// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<UserRole, String> role =
      GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<UserRole>($UsersTable.$converterrole);
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, role, username, passwordHash];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      role: $UsersTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
      ),
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<UserRole, String, String> $converterrole =
      const EnumNameConverter<UserRole>(UserRole.values);
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final UserRole role;
  final String username;
  final String passwordHash;
  const User({
    required this.id,
    required this.role,
    required this.username,
    required this.passwordHash,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['role'] = Variable<String>($UsersTable.$converterrole.toSql(role));
    }
    map['username'] = Variable<String>(username);
    map['password_hash'] = Variable<String>(passwordHash);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      role: Value(role),
      username: Value(username),
      passwordHash: Value(passwordHash),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      role: $UsersTable.$converterrole.fromJson(
        serializer.fromJson<String>(json['role']),
      ),
      username: serializer.fromJson<String>(json['username']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'role': serializer.toJson<String>(
        $UsersTable.$converterrole.toJson(role),
      ),
      'username': serializer.toJson<String>(username),
      'passwordHash': serializer.toJson<String>(passwordHash),
    };
  }

  User copyWith({
    int? id,
    UserRole? role,
    String? username,
    String? passwordHash,
  }) => User(
    id: id ?? this.id,
    role: role ?? this.role,
    username: username ?? this.username,
    passwordHash: passwordHash ?? this.passwordHash,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      role: data.role.present ? data.role.value : this.role,
      username: data.username.present ? data.username.value : this.username,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, role, username, passwordHash);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.role == this.role &&
          other.username == this.username &&
          other.passwordHash == this.passwordHash);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<UserRole> role;
  final Value<String> username;
  final Value<String> passwordHash;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.role = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordHash = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required UserRole role,
    required String username,
    required String passwordHash,
  }) : role = Value(role),
       username = Value(username),
       passwordHash = Value(passwordHash);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? role,
    Expression<String>? username,
    Expression<String>? passwordHash,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (role != null) 'role': role,
      if (username != null) 'username': username,
      if (passwordHash != null) 'password_hash': passwordHash,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<UserRole>? role,
    Value<String>? username,
    Value<String>? passwordHash,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      role: role ?? this.role,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(
        $UsersTable.$converterrole.toSql(role.value),
      );
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash')
          ..write(')'))
        .toString();
  }
}

class $RoomsTable extends Rooms with TableInfo<$RoomsTable, Room> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastCleanedMeta = const VerificationMeta(
    'lastCleaned',
  );
  @override
  late final GeneratedColumn<DateTime> lastCleaned = GeneratedColumn<DateTime>(
    'last_cleaned',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _buildingMeta = const VerificationMeta(
    'building',
  );
  @override
  late final GeneratedColumn<String> building = GeneratedColumn<String>(
    'building',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _floorMeta = const VerificationMeta('floor');
  @override
  late final GeneratedColumn<String> floor = GeneratedColumn<String>(
    'floor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kmlMeta = const VerificationMeta('kml');
  @override
  late final GeneratedColumn<String> kml = GeneratedColumn<String>(
    'kml',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    name,
    lastCleaned,
    notes,
    building,
    floor,
    kml,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rooms';
  @override
  VerificationContext validateIntegrity(
    Insertable<Room> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('last_cleaned')) {
      context.handle(
        _lastCleanedMeta,
        lastCleaned.isAcceptableOrUnknown(
          data['last_cleaned']!,
          _lastCleanedMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('building')) {
      context.handle(
        _buildingMeta,
        building.isAcceptableOrUnknown(data['building']!, _buildingMeta),
      );
    }
    if (data.containsKey('floor')) {
      context.handle(
        _floorMeta,
        floor.isAcceptableOrUnknown(data['floor']!, _floorMeta),
      );
    }
    if (data.containsKey('kml')) {
      context.handle(
        _kmlMeta,
        kml.isAcceptableOrUnknown(data['kml']!, _kmlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  Room map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Room(
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      lastCleaned: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_cleaned'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      building: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}building'],
      ),
      floor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}floor'],
      ),
      kml: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kml'],
      ),
    );
  }

  @override
  $RoomsTable createAlias(String alias) {
    return $RoomsTable(attachedDatabase, alias);
  }
}

class Room extends DataClass implements Insertable<Room> {
  final String name;
  final DateTime? lastCleaned;
  final String? notes;
  final String? building;
  final String? floor;
  final String? kml;
  const Room({
    required this.name,
    this.lastCleaned,
    this.notes,
    this.building,
    this.floor,
    this.kml,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || lastCleaned != null) {
      map['last_cleaned'] = Variable<DateTime>(lastCleaned);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || building != null) {
      map['building'] = Variable<String>(building);
    }
    if (!nullToAbsent || floor != null) {
      map['floor'] = Variable<String>(floor);
    }
    if (!nullToAbsent || kml != null) {
      map['kml'] = Variable<String>(kml);
    }
    return map;
  }

  RoomsCompanion toCompanion(bool nullToAbsent) {
    return RoomsCompanion(
      name: Value(name),
      lastCleaned: lastCleaned == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCleaned),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      building: building == null && nullToAbsent
          ? const Value.absent()
          : Value(building),
      floor: floor == null && nullToAbsent
          ? const Value.absent()
          : Value(floor),
      kml: kml == null && nullToAbsent ? const Value.absent() : Value(kml),
    );
  }

  factory Room.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Room(
      name: serializer.fromJson<String>(json['name']),
      lastCleaned: serializer.fromJson<DateTime?>(json['lastCleaned']),
      notes: serializer.fromJson<String?>(json['notes']),
      building: serializer.fromJson<String?>(json['building']),
      floor: serializer.fromJson<String?>(json['floor']),
      kml: serializer.fromJson<String?>(json['kml']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'lastCleaned': serializer.toJson<DateTime?>(lastCleaned),
      'notes': serializer.toJson<String?>(notes),
      'building': serializer.toJson<String?>(building),
      'floor': serializer.toJson<String?>(floor),
      'kml': serializer.toJson<String?>(kml),
    };
  }

  Room copyWith({
    String? name,
    Value<DateTime?> lastCleaned = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> building = const Value.absent(),
    Value<String?> floor = const Value.absent(),
    Value<String?> kml = const Value.absent(),
  }) => Room(
    name: name ?? this.name,
    lastCleaned: lastCleaned.present ? lastCleaned.value : this.lastCleaned,
    notes: notes.present ? notes.value : this.notes,
    building: building.present ? building.value : this.building,
    floor: floor.present ? floor.value : this.floor,
    kml: kml.present ? kml.value : this.kml,
  );
  Room copyWithCompanion(RoomsCompanion data) {
    return Room(
      name: data.name.present ? data.name.value : this.name,
      lastCleaned: data.lastCleaned.present
          ? data.lastCleaned.value
          : this.lastCleaned,
      notes: data.notes.present ? data.notes.value : this.notes,
      building: data.building.present ? data.building.value : this.building,
      floor: data.floor.present ? data.floor.value : this.floor,
      kml: data.kml.present ? data.kml.value : this.kml,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Room(')
          ..write('name: $name, ')
          ..write('lastCleaned: $lastCleaned, ')
          ..write('notes: $notes, ')
          ..write('building: $building, ')
          ..write('floor: $floor, ')
          ..write('kml: $kml')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(name, lastCleaned, notes, building, floor, kml);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Room &&
          other.name == this.name &&
          other.lastCleaned == this.lastCleaned &&
          other.notes == this.notes &&
          other.building == this.building &&
          other.floor == this.floor &&
          other.kml == this.kml);
}

class RoomsCompanion extends UpdateCompanion<Room> {
  final Value<String> name;
  final Value<DateTime?> lastCleaned;
  final Value<String?> notes;
  final Value<String?> building;
  final Value<String?> floor;
  final Value<String?> kml;
  final Value<int> rowid;
  const RoomsCompanion({
    this.name = const Value.absent(),
    this.lastCleaned = const Value.absent(),
    this.notes = const Value.absent(),
    this.building = const Value.absent(),
    this.floor = const Value.absent(),
    this.kml = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoomsCompanion.insert({
    required String name,
    this.lastCleaned = const Value.absent(),
    this.notes = const Value.absent(),
    this.building = const Value.absent(),
    this.floor = const Value.absent(),
    this.kml = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Room> custom({
    Expression<String>? name,
    Expression<DateTime>? lastCleaned,
    Expression<String>? notes,
    Expression<String>? building,
    Expression<String>? floor,
    Expression<String>? kml,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (lastCleaned != null) 'last_cleaned': lastCleaned,
      if (notes != null) 'notes': notes,
      if (building != null) 'building': building,
      if (floor != null) 'floor': floor,
      if (kml != null) 'kml': kml,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoomsCompanion copyWith({
    Value<String>? name,
    Value<DateTime?>? lastCleaned,
    Value<String?>? notes,
    Value<String?>? building,
    Value<String?>? floor,
    Value<String?>? kml,
    Value<int>? rowid,
  }) {
    return RoomsCompanion(
      name: name ?? this.name,
      lastCleaned: lastCleaned ?? this.lastCleaned,
      notes: notes ?? this.notes,
      building: building ?? this.building,
      floor: floor ?? this.floor,
      kml: kml ?? this.kml,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lastCleaned.present) {
      map['last_cleaned'] = Variable<DateTime>(lastCleaned.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (building.present) {
      map['building'] = Variable<String>(building.value);
    }
    if (floor.present) {
      map['floor'] = Variable<String>(floor.value);
    }
    if (kml.present) {
      map['kml'] = Variable<String>(kml.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomsCompanion(')
          ..write('name: $name, ')
          ..write('lastCleaned: $lastCleaned, ')
          ..write('notes: $notes, ')
          ..write('building: $building, ')
          ..write('floor: $floor, ')
          ..write('kml: $kml, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CleansTable extends Cleans with TableInfo<$CleansTable, Clean> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CleansTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _cleanedByMeta = const VerificationMeta(
    'cleanedBy',
  );
  @override
  late final GeneratedColumn<int> cleanedBy = GeneratedColumn<int>(
    'cleaned_by',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _auditedByMeta = const VerificationMeta(
    'auditedBy',
  );
  @override
  late final GeneratedColumn<int> auditedBy = GeneratedColumn<int>(
    'audited_by',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _roomMeta = const VerificationMeta('room');
  @override
  late final GeneratedColumn<int> room = GeneratedColumn<int>(
    'room',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rooms (name) ON UPDATE CASCADE',
    ),
  );
  static const VerificationMeta _auditedMeta = const VerificationMeta(
    'audited',
  );
  @override
  late final GeneratedColumn<bool> audited = GeneratedColumn<bool>(
    'audited',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _auditTimeMeta = const VerificationMeta(
    'auditTime',
  );
  @override
  late final GeneratedColumn<DateTime> auditTime = GeneratedColumn<DateTime>(
    'audit_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cleanTimeMeta = const VerificationMeta(
    'cleanTime',
  );
  @override
  late final GeneratedColumn<DateTime> cleanTime = GeneratedColumn<DateTime>(
    'clean_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cleanedBy,
    auditedBy,
    room,
    audited,
    auditTime,
    cleanTime,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cleans';
  @override
  VerificationContext validateIntegrity(
    Insertable<Clean> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cleaned_by')) {
      context.handle(
        _cleanedByMeta,
        cleanedBy.isAcceptableOrUnknown(data['cleaned_by']!, _cleanedByMeta),
      );
    } else if (isInserting) {
      context.missing(_cleanedByMeta);
    }
    if (data.containsKey('audited_by')) {
      context.handle(
        _auditedByMeta,
        auditedBy.isAcceptableOrUnknown(data['audited_by']!, _auditedByMeta),
      );
    }
    if (data.containsKey('room')) {
      context.handle(
        _roomMeta,
        room.isAcceptableOrUnknown(data['room']!, _roomMeta),
      );
    } else if (isInserting) {
      context.missing(_roomMeta);
    }
    if (data.containsKey('audited')) {
      context.handle(
        _auditedMeta,
        audited.isAcceptableOrUnknown(data['audited']!, _auditedMeta),
      );
    } else if (isInserting) {
      context.missing(_auditedMeta);
    }
    if (data.containsKey('audit_time')) {
      context.handle(
        _auditTimeMeta,
        auditTime.isAcceptableOrUnknown(data['audit_time']!, _auditTimeMeta),
      );
    }
    if (data.containsKey('clean_time')) {
      context.handle(
        _cleanTimeMeta,
        cleanTime.isAcceptableOrUnknown(data['clean_time']!, _cleanTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_cleanTimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Clean map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Clean(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cleanedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cleaned_by'],
      )!,
      auditedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}audited_by'],
      ),
      room: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}room'],
      )!,
      audited: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}audited'],
      )!,
      auditTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}audit_time'],
      ),
      cleanTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}clean_time'],
      )!,
    );
  }

  @override
  $CleansTable createAlias(String alias) {
    return $CleansTable(attachedDatabase, alias);
  }
}

class Clean extends DataClass implements Insertable<Clean> {
  final int id;
  final int cleanedBy;
  final int? auditedBy;
  final int room;
  final bool audited;
  final DateTime? auditTime;
  final DateTime cleanTime;
  const Clean({
    required this.id,
    required this.cleanedBy,
    this.auditedBy,
    required this.room,
    required this.audited,
    this.auditTime,
    required this.cleanTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cleaned_by'] = Variable<int>(cleanedBy);
    if (!nullToAbsent || auditedBy != null) {
      map['audited_by'] = Variable<int>(auditedBy);
    }
    map['room'] = Variable<int>(room);
    map['audited'] = Variable<bool>(audited);
    if (!nullToAbsent || auditTime != null) {
      map['audit_time'] = Variable<DateTime>(auditTime);
    }
    map['clean_time'] = Variable<DateTime>(cleanTime);
    return map;
  }

  CleansCompanion toCompanion(bool nullToAbsent) {
    return CleansCompanion(
      id: Value(id),
      cleanedBy: Value(cleanedBy),
      auditedBy: auditedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(auditedBy),
      room: Value(room),
      audited: Value(audited),
      auditTime: auditTime == null && nullToAbsent
          ? const Value.absent()
          : Value(auditTime),
      cleanTime: Value(cleanTime),
    );
  }

  factory Clean.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Clean(
      id: serializer.fromJson<int>(json['id']),
      cleanedBy: serializer.fromJson<int>(json['cleanedBy']),
      auditedBy: serializer.fromJson<int?>(json['auditedBy']),
      room: serializer.fromJson<int>(json['room']),
      audited: serializer.fromJson<bool>(json['audited']),
      auditTime: serializer.fromJson<DateTime?>(json['auditTime']),
      cleanTime: serializer.fromJson<DateTime>(json['cleanTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cleanedBy': serializer.toJson<int>(cleanedBy),
      'auditedBy': serializer.toJson<int?>(auditedBy),
      'room': serializer.toJson<int>(room),
      'audited': serializer.toJson<bool>(audited),
      'auditTime': serializer.toJson<DateTime?>(auditTime),
      'cleanTime': serializer.toJson<DateTime>(cleanTime),
    };
  }

  Clean copyWith({
    int? id,
    int? cleanedBy,
    Value<int?> auditedBy = const Value.absent(),
    int? room,
    bool? audited,
    Value<DateTime?> auditTime = const Value.absent(),
    DateTime? cleanTime,
  }) => Clean(
    id: id ?? this.id,
    cleanedBy: cleanedBy ?? this.cleanedBy,
    auditedBy: auditedBy.present ? auditedBy.value : this.auditedBy,
    room: room ?? this.room,
    audited: audited ?? this.audited,
    auditTime: auditTime.present ? auditTime.value : this.auditTime,
    cleanTime: cleanTime ?? this.cleanTime,
  );
  Clean copyWithCompanion(CleansCompanion data) {
    return Clean(
      id: data.id.present ? data.id.value : this.id,
      cleanedBy: data.cleanedBy.present ? data.cleanedBy.value : this.cleanedBy,
      auditedBy: data.auditedBy.present ? data.auditedBy.value : this.auditedBy,
      room: data.room.present ? data.room.value : this.room,
      audited: data.audited.present ? data.audited.value : this.audited,
      auditTime: data.auditTime.present ? data.auditTime.value : this.auditTime,
      cleanTime: data.cleanTime.present ? data.cleanTime.value : this.cleanTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Clean(')
          ..write('id: $id, ')
          ..write('cleanedBy: $cleanedBy, ')
          ..write('auditedBy: $auditedBy, ')
          ..write('room: $room, ')
          ..write('audited: $audited, ')
          ..write('auditTime: $auditTime, ')
          ..write('cleanTime: $cleanTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cleanedBy,
    auditedBy,
    room,
    audited,
    auditTime,
    cleanTime,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Clean &&
          other.id == this.id &&
          other.cleanedBy == this.cleanedBy &&
          other.auditedBy == this.auditedBy &&
          other.room == this.room &&
          other.audited == this.audited &&
          other.auditTime == this.auditTime &&
          other.cleanTime == this.cleanTime);
}

class CleansCompanion extends UpdateCompanion<Clean> {
  final Value<int> id;
  final Value<int> cleanedBy;
  final Value<int?> auditedBy;
  final Value<int> room;
  final Value<bool> audited;
  final Value<DateTime?> auditTime;
  final Value<DateTime> cleanTime;
  const CleansCompanion({
    this.id = const Value.absent(),
    this.cleanedBy = const Value.absent(),
    this.auditedBy = const Value.absent(),
    this.room = const Value.absent(),
    this.audited = const Value.absent(),
    this.auditTime = const Value.absent(),
    this.cleanTime = const Value.absent(),
  });
  CleansCompanion.insert({
    this.id = const Value.absent(),
    required int cleanedBy,
    this.auditedBy = const Value.absent(),
    required int room,
    required bool audited,
    this.auditTime = const Value.absent(),
    required DateTime cleanTime,
  }) : cleanedBy = Value(cleanedBy),
       room = Value(room),
       audited = Value(audited),
       cleanTime = Value(cleanTime);
  static Insertable<Clean> custom({
    Expression<int>? id,
    Expression<int>? cleanedBy,
    Expression<int>? auditedBy,
    Expression<int>? room,
    Expression<bool>? audited,
    Expression<DateTime>? auditTime,
    Expression<DateTime>? cleanTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cleanedBy != null) 'cleaned_by': cleanedBy,
      if (auditedBy != null) 'audited_by': auditedBy,
      if (room != null) 'room': room,
      if (audited != null) 'audited': audited,
      if (auditTime != null) 'audit_time': auditTime,
      if (cleanTime != null) 'clean_time': cleanTime,
    });
  }

  CleansCompanion copyWith({
    Value<int>? id,
    Value<int>? cleanedBy,
    Value<int?>? auditedBy,
    Value<int>? room,
    Value<bool>? audited,
    Value<DateTime?>? auditTime,
    Value<DateTime>? cleanTime,
  }) {
    return CleansCompanion(
      id: id ?? this.id,
      cleanedBy: cleanedBy ?? this.cleanedBy,
      auditedBy: auditedBy ?? this.auditedBy,
      room: room ?? this.room,
      audited: audited ?? this.audited,
      auditTime: auditTime ?? this.auditTime,
      cleanTime: cleanTime ?? this.cleanTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cleanedBy.present) {
      map['cleaned_by'] = Variable<int>(cleanedBy.value);
    }
    if (auditedBy.present) {
      map['audited_by'] = Variable<int>(auditedBy.value);
    }
    if (room.present) {
      map['room'] = Variable<int>(room.value);
    }
    if (audited.present) {
      map['audited'] = Variable<bool>(audited.value);
    }
    if (auditTime.present) {
      map['audit_time'] = Variable<DateTime>(auditTime.value);
    }
    if (cleanTime.present) {
      map['clean_time'] = Variable<DateTime>(cleanTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CleansCompanion(')
          ..write('id: $id, ')
          ..write('cleanedBy: $cleanedBy, ')
          ..write('auditedBy: $auditedBy, ')
          ..write('room: $room, ')
          ..write('audited: $audited, ')
          ..write('auditTime: $auditTime, ')
          ..write('cleanTime: $cleanTime')
          ..write(')'))
        .toString();
  }
}

class $IssuesTable extends Issues with TableInfo<$IssuesTable, Issue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IssuesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _cleanIdMeta = const VerificationMeta(
    'cleanId',
  );
  @override
  late final GeneratedColumn<int> cleanId = GeneratedColumn<int>(
    'clean_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cleans (id)',
    ),
  );
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<Uint8List> image = GeneratedColumn<Uint8List>(
    'image',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TagName, String> tag =
      GeneratedColumn<String>(
        'tag',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TagName>($IssuesTable.$convertertag);
  @override
  late final GeneratedColumnWithTypeConverter<Priority, String> priority =
      GeneratedColumn<String>(
        'priority',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Priority>($IssuesTable.$converterpriority);
  static const VerificationMeta _resolvedMeta = const VerificationMeta(
    'resolved',
  );
  @override
  late final GeneratedColumn<bool> resolved = GeneratedColumn<bool>(
    'resolved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cleanId,
    image,
    description,
    tag,
    priority,
    resolved,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'issues';
  @override
  VerificationContext validateIntegrity(
    Insertable<Issue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('clean_id')) {
      context.handle(
        _cleanIdMeta,
        cleanId.isAcceptableOrUnknown(data['clean_id']!, _cleanIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cleanIdMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('resolved')) {
      context.handle(
        _resolvedMeta,
        resolved.isAcceptableOrUnknown(data['resolved']!, _resolvedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Issue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Issue(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cleanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}clean_id'],
      )!,
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}image'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      tag: $IssuesTable.$convertertag.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tag'],
        )!,
      ),
      priority: $IssuesTable.$converterpriority.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}priority'],
        )!,
      ),
      resolved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}resolved'],
      )!,
    );
  }

  @override
  $IssuesTable createAlias(String alias) {
    return $IssuesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TagName, String, String> $convertertag =
      const EnumNameConverter<TagName>(TagName.values);
  static JsonTypeConverter2<Priority, String, String> $converterpriority =
      const EnumNameConverter<Priority>(Priority.values);
}

class Issue extends DataClass implements Insertable<Issue> {
  final int id;
  final int cleanId;
  final Uint8List? image;
  final String? description;
  final TagName tag;
  final Priority priority;
  final bool resolved;
  const Issue({
    required this.id,
    required this.cleanId,
    this.image,
    this.description,
    required this.tag,
    required this.priority,
    required this.resolved,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['clean_id'] = Variable<int>(cleanId);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<Uint8List>(image);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    {
      map['tag'] = Variable<String>($IssuesTable.$convertertag.toSql(tag));
    }
    {
      map['priority'] = Variable<String>(
        $IssuesTable.$converterpriority.toSql(priority),
      );
    }
    map['resolved'] = Variable<bool>(resolved);
    return map;
  }

  IssuesCompanion toCompanion(bool nullToAbsent) {
    return IssuesCompanion(
      id: Value(id),
      cleanId: Value(cleanId),
      image: image == null && nullToAbsent
          ? const Value.absent()
          : Value(image),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      tag: Value(tag),
      priority: Value(priority),
      resolved: Value(resolved),
    );
  }

  factory Issue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Issue(
      id: serializer.fromJson<int>(json['id']),
      cleanId: serializer.fromJson<int>(json['cleanId']),
      image: serializer.fromJson<Uint8List?>(json['image']),
      description: serializer.fromJson<String?>(json['description']),
      tag: $IssuesTable.$convertertag.fromJson(
        serializer.fromJson<String>(json['tag']),
      ),
      priority: $IssuesTable.$converterpriority.fromJson(
        serializer.fromJson<String>(json['priority']),
      ),
      resolved: serializer.fromJson<bool>(json['resolved']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cleanId': serializer.toJson<int>(cleanId),
      'image': serializer.toJson<Uint8List?>(image),
      'description': serializer.toJson<String?>(description),
      'tag': serializer.toJson<String>($IssuesTable.$convertertag.toJson(tag)),
      'priority': serializer.toJson<String>(
        $IssuesTable.$converterpriority.toJson(priority),
      ),
      'resolved': serializer.toJson<bool>(resolved),
    };
  }

  Issue copyWith({
    int? id,
    int? cleanId,
    Value<Uint8List?> image = const Value.absent(),
    Value<String?> description = const Value.absent(),
    TagName? tag,
    Priority? priority,
    bool? resolved,
  }) => Issue(
    id: id ?? this.id,
    cleanId: cleanId ?? this.cleanId,
    image: image.present ? image.value : this.image,
    description: description.present ? description.value : this.description,
    tag: tag ?? this.tag,
    priority: priority ?? this.priority,
    resolved: resolved ?? this.resolved,
  );
  Issue copyWithCompanion(IssuesCompanion data) {
    return Issue(
      id: data.id.present ? data.id.value : this.id,
      cleanId: data.cleanId.present ? data.cleanId.value : this.cleanId,
      image: data.image.present ? data.image.value : this.image,
      description: data.description.present
          ? data.description.value
          : this.description,
      tag: data.tag.present ? data.tag.value : this.tag,
      priority: data.priority.present ? data.priority.value : this.priority,
      resolved: data.resolved.present ? data.resolved.value : this.resolved,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Issue(')
          ..write('id: $id, ')
          ..write('cleanId: $cleanId, ')
          ..write('image: $image, ')
          ..write('description: $description, ')
          ..write('tag: $tag, ')
          ..write('priority: $priority, ')
          ..write('resolved: $resolved')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cleanId,
    $driftBlobEquality.hash(image),
    description,
    tag,
    priority,
    resolved,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Issue &&
          other.id == this.id &&
          other.cleanId == this.cleanId &&
          $driftBlobEquality.equals(other.image, this.image) &&
          other.description == this.description &&
          other.tag == this.tag &&
          other.priority == this.priority &&
          other.resolved == this.resolved);
}

class IssuesCompanion extends UpdateCompanion<Issue> {
  final Value<int> id;
  final Value<int> cleanId;
  final Value<Uint8List?> image;
  final Value<String?> description;
  final Value<TagName> tag;
  final Value<Priority> priority;
  final Value<bool> resolved;
  const IssuesCompanion({
    this.id = const Value.absent(),
    this.cleanId = const Value.absent(),
    this.image = const Value.absent(),
    this.description = const Value.absent(),
    this.tag = const Value.absent(),
    this.priority = const Value.absent(),
    this.resolved = const Value.absent(),
  });
  IssuesCompanion.insert({
    this.id = const Value.absent(),
    required int cleanId,
    this.image = const Value.absent(),
    this.description = const Value.absent(),
    required TagName tag,
    required Priority priority,
    this.resolved = const Value.absent(),
  }) : cleanId = Value(cleanId),
       tag = Value(tag),
       priority = Value(priority);
  static Insertable<Issue> custom({
    Expression<int>? id,
    Expression<int>? cleanId,
    Expression<Uint8List>? image,
    Expression<String>? description,
    Expression<String>? tag,
    Expression<String>? priority,
    Expression<bool>? resolved,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cleanId != null) 'clean_id': cleanId,
      if (image != null) 'image': image,
      if (description != null) 'description': description,
      if (tag != null) 'tag': tag,
      if (priority != null) 'priority': priority,
      if (resolved != null) 'resolved': resolved,
    });
  }

  IssuesCompanion copyWith({
    Value<int>? id,
    Value<int>? cleanId,
    Value<Uint8List?>? image,
    Value<String?>? description,
    Value<TagName>? tag,
    Value<Priority>? priority,
    Value<bool>? resolved,
  }) {
    return IssuesCompanion(
      id: id ?? this.id,
      cleanId: cleanId ?? this.cleanId,
      image: image ?? this.image,
      description: description ?? this.description,
      tag: tag ?? this.tag,
      priority: priority ?? this.priority,
      resolved: resolved ?? this.resolved,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cleanId.present) {
      map['clean_id'] = Variable<int>(cleanId.value);
    }
    if (image.present) {
      map['image'] = Variable<Uint8List>(image.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(
        $IssuesTable.$convertertag.toSql(tag.value),
      );
    }
    if (priority.present) {
      map['priority'] = Variable<String>(
        $IssuesTable.$converterpriority.toSql(priority.value),
      );
    }
    if (resolved.present) {
      map['resolved'] = Variable<bool>(resolved.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IssuesCompanion(')
          ..write('id: $id, ')
          ..write('cleanId: $cleanId, ')
          ..write('image: $image, ')
          ..write('description: $description, ')
          ..write('tag: $tag, ')
          ..write('priority: $priority, ')
          ..write('resolved: $resolved')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $RoomsTable rooms = $RoomsTable(this);
  late final $CleansTable cleans = $CleansTable(this);
  late final $IssuesTable issues = $IssuesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    rooms,
    cleans,
    issues,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'rooms',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('cleans', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required UserRole role,
  required String username,
  required String passwordHash,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<UserRole> role,
  Value<String> username,
  Value<String> passwordHash,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
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

  ColumnWithTypeConverterFilters<UserRole, UserRole, String> get role =>
      $composableBuilder(
        column: $table.role,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
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

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<UserRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<UserRole> role = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                role: role,
                username: username,
                passwordHash: passwordHash,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required UserRole role,
                required String username,
                required String passwordHash,
              }) => UsersCompanion.insert(
                id: id,
                role: role,
                username: username,
                passwordHash: passwordHash,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsersTable, User>(table),
                  BaseReferences<_$AppDatabase, $UsersTable, User>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$RoomsTableCreateCompanionBuilder = RoomsCompanion Function({
  required String name,
  Value<DateTime?> lastCleaned,
  Value<String?> notes,
  Value<String?> building,
  Value<String?> floor,
  Value<String?> kml,
  Value<int> rowid,
});
typedef $$RoomsTableUpdateCompanionBuilder = RoomsCompanion Function({
  Value<String> name,
  Value<DateTime?> lastCleaned,
  Value<String?> notes,
  Value<String?> building,
  Value<String?> floor,
  Value<String?> kml,
  Value<int> rowid,
});

class $$RoomsTableFilterComposer extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCleaned => $composableBuilder(
    column: $table.lastCleaned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get building => $composableBuilder(
    column: $table.building,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get floor => $composableBuilder(
    column: $table.floor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kml => $composableBuilder(
    column: $table.kml,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoomsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCleaned => $composableBuilder(
    column: $table.lastCleaned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get building => $composableBuilder(
    column: $table.building,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get floor => $composableBuilder(
    column: $table.floor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kml => $composableBuilder(
    column: $table.kml,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get lastCleaned => $composableBuilder(
    column: $table.lastCleaned,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get building =>
      $composableBuilder(column: $table.building, builder: (column) => column);

  GeneratedColumn<String> get floor =>
      $composableBuilder(column: $table.floor, builder: (column) => column);

  GeneratedColumn<String> get kml =>
      $composableBuilder(column: $table.kml, builder: (column) => column);
}

class $$RoomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoomsTable,
          Room,
          $$RoomsTableFilterComposer,
          $$RoomsTableOrderingComposer,
          $$RoomsTableAnnotationComposer,
          $$RoomsTableCreateCompanionBuilder,
          $$RoomsTableUpdateCompanionBuilder,
          (Room, BaseReferences<_$AppDatabase, $RoomsTable, Room>),
          Room,
          PrefetchHooks Function()
        > {
  $$RoomsTableTableManager(_$AppDatabase db, $RoomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> name = const Value.absent(),
                Value<DateTime?> lastCleaned = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> building = const Value.absent(),
                Value<String?> floor = const Value.absent(),
                Value<String?> kml = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoomsCompanion(
                name: name,
                lastCleaned: lastCleaned,
                notes: notes,
                building: building,
                floor: floor,
                kml: kml,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String name,
                Value<DateTime?> lastCleaned = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> building = const Value.absent(),
                Value<String?> floor = const Value.absent(),
                Value<String?> kml = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoomsCompanion.insert(
                name: name,
                lastCleaned: lastCleaned,
                notes: notes,
                building: building,
                floor: floor,
                kml: kml,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoomsTable, Room>(table),
                  BaseReferences<_$AppDatabase, $RoomsTable, Room>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoomsTable,
      Room,
      $$RoomsTableFilterComposer,
      $$RoomsTableOrderingComposer,
      $$RoomsTableAnnotationComposer,
      $$RoomsTableCreateCompanionBuilder,
      $$RoomsTableUpdateCompanionBuilder,
      (Room, BaseReferences<_$AppDatabase, $RoomsTable, Room>),
      Room,
      PrefetchHooks Function()
    >;
typedef $$CleansTableCreateCompanionBuilder = CleansCompanion Function({
  Value<int> id,
  required int cleanedBy,
  Value<int?> auditedBy,
  required int room,
  required bool audited,
  Value<DateTime?> auditTime,
  required DateTime cleanTime,
});
typedef $$CleansTableUpdateCompanionBuilder = CleansCompanion Function({
  Value<int> id,
  Value<int> cleanedBy,
  Value<int?> auditedBy,
  Value<int> room,
  Value<bool> audited,
  Value<DateTime?> auditTime,
  Value<DateTime> cleanTime,
});

final class $$CleansTableReferences
    extends BaseReferences<_$AppDatabase, $CleansTable, Clean> {
  $$CleansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _cleanedByTable(_$AppDatabase db) =>
      db.users.createAlias('cleans__cleaned_by__users__id');

  $$UsersTableProcessedTableManager get cleanedBy {
    final $_column = $_itemColumn<int>('cleaned_by')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cleanedByTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _auditedByTable(_$AppDatabase db) =>
      db.users.createAlias('cleans__audited_by__users__id');

  $$UsersTableProcessedTableManager? get auditedBy {
    final $_column = $_itemColumn<int>('audited_by');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_auditedByTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$IssuesTable, List<Issue>> _issuesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.issues,
    aliasName: 'cleans__id__issues__clean_id',
  );

  $$IssuesTableProcessedTableManager get issuesRefs {
    final manager = $$IssuesTableTableManager(
      $_db,
      $_db.issues,
    ).filter((f) => f.cleanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_issuesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CleansTableFilterComposer
    extends Composer<_$AppDatabase, $CleansTable> {
  $$CleansTableFilterComposer({
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

  ColumnFilters<bool> get audited => $composableBuilder(
    column: $table.audited,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get auditTime => $composableBuilder(
    column: $table.auditTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cleanTime => $composableBuilder(
    column: $table.cleanTime,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get cleanedBy {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cleanedBy,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get auditedBy {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.auditedBy,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> issuesRefs(
    Expression<bool> Function($$IssuesTableFilterComposer f) f,
  ) {
    final $$IssuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.issues,
      getReferencedColumn: (t) => t.cleanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IssuesTableFilterComposer(
            $db: $db,
            $table: $db.issues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CleansTableOrderingComposer
    extends Composer<_$AppDatabase, $CleansTable> {
  $$CleansTableOrderingComposer({
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

  ColumnOrderings<bool> get audited => $composableBuilder(
    column: $table.audited,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get auditTime => $composableBuilder(
    column: $table.auditTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cleanTime => $composableBuilder(
    column: $table.cleanTime,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get cleanedBy {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cleanedBy,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get auditedBy {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.auditedBy,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CleansTableAnnotationComposer
    extends Composer<_$AppDatabase, $CleansTable> {
  $$CleansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get audited =>
      $composableBuilder(column: $table.audited, builder: (column) => column);

  GeneratedColumn<DateTime> get auditTime =>
      $composableBuilder(column: $table.auditTime, builder: (column) => column);

  GeneratedColumn<DateTime> get cleanTime =>
      $composableBuilder(column: $table.cleanTime, builder: (column) => column);

  $$UsersTableAnnotationComposer get cleanedBy {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cleanedBy,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableAnnotationComposer get auditedBy {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.auditedBy,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> issuesRefs<T extends Object>(
    Expression<T> Function($$IssuesTableAnnotationComposer a) f,
  ) {
    final $$IssuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.issues,
      getReferencedColumn: (t) => t.cleanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IssuesTableAnnotationComposer(
            $db: $db,
            $table: $db.issues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CleansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CleansTable,
          Clean,
          $$CleansTableFilterComposer,
          $$CleansTableOrderingComposer,
          $$CleansTableAnnotationComposer,
          $$CleansTableCreateCompanionBuilder,
          $$CleansTableUpdateCompanionBuilder,
          (Clean, $$CleansTableReferences),
          Clean,
          PrefetchHooks Function({
            bool cleanedBy,
            bool auditedBy,
            bool issuesRefs,
          })
        > {
  $$CleansTableTableManager(_$AppDatabase db, $CleansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CleansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CleansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CleansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cleanedBy = const Value.absent(),
                Value<int?> auditedBy = const Value.absent(),
                Value<int> room = const Value.absent(),
                Value<bool> audited = const Value.absent(),
                Value<DateTime?> auditTime = const Value.absent(),
                Value<DateTime> cleanTime = const Value.absent(),
              }) => CleansCompanion(
                id: id,
                cleanedBy: cleanedBy,
                auditedBy: auditedBy,
                room: room,
                audited: audited,
                auditTime: auditTime,
                cleanTime: cleanTime,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cleanedBy,
                Value<int?> auditedBy = const Value.absent(),
                required int room,
                required bool audited,
                Value<DateTime?> auditTime = const Value.absent(),
                required DateTime cleanTime,
              }) => CleansCompanion.insert(
                id: id,
                cleanedBy: cleanedBy,
                auditedBy: auditedBy,
                room: room,
                audited: audited,
                auditTime: auditTime,
                cleanTime: cleanTime,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CleansTable, Clean>(table),
                  $$CleansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({cleanedBy = false, auditedBy = false, issuesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (issuesRefs) db.issues],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (cleanedBy) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.cleanedBy,
                            referencedTable: $$CleansTableReferences
                                ._cleanedByTable(db),
                            referencedColumn: $$CleansTableReferences
                                ._cleanedByTable(db)
                                .id,
                          ) as T;
                        }
                        if (auditedBy) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.auditedBy,
                            referencedTable: $$CleansTableReferences
                                ._auditedByTable(db),
                            referencedColumn: $$CleansTableReferences
                                ._auditedByTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (issuesRefs)
                        await $_getPrefetchedData<Clean, $CleansTable, Issue>(
                          currentTable: table,
                          referencedTable: $$CleansTableReferences
                              ._issuesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CleansTableReferences(db, table, p0).issuesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cleanId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CleansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CleansTable,
      Clean,
      $$CleansTableFilterComposer,
      $$CleansTableOrderingComposer,
      $$CleansTableAnnotationComposer,
      $$CleansTableCreateCompanionBuilder,
      $$CleansTableUpdateCompanionBuilder,
      (Clean, $$CleansTableReferences),
      Clean,
      PrefetchHooks Function({bool cleanedBy, bool auditedBy, bool issuesRefs})
    >;
typedef $$IssuesTableCreateCompanionBuilder = IssuesCompanion Function({
  Value<int> id,
  required int cleanId,
  Value<Uint8List?> image,
  Value<String?> description,
  required TagName tag,
  required Priority priority,
  Value<bool> resolved,
});
typedef $$IssuesTableUpdateCompanionBuilder = IssuesCompanion Function({
  Value<int> id,
  Value<int> cleanId,
  Value<Uint8List?> image,
  Value<String?> description,
  Value<TagName> tag,
  Value<Priority> priority,
  Value<bool> resolved,
});

final class $$IssuesTableReferences
    extends BaseReferences<_$AppDatabase, $IssuesTable, Issue> {
  $$IssuesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CleansTable _cleanIdTable(_$AppDatabase db) =>
      db.cleans.createAlias('issues__clean_id__cleans__id');

  $$CleansTableProcessedTableManager get cleanId {
    final $_column = $_itemColumn<int>('clean_id')!;

    final manager = $$CleansTableTableManager(
      $_db,
      $_db.cleans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cleanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IssuesTableFilterComposer
    extends Composer<_$AppDatabase, $IssuesTable> {
  $$IssuesTableFilterComposer({
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

  ColumnFilters<Uint8List> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TagName, TagName, String> get tag =>
      $composableBuilder(
        column: $table.tag,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Priority, Priority, String> get priority =>
      $composableBuilder(
        column: $table.priority,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get resolved => $composableBuilder(
    column: $table.resolved,
    builder: (column) => ColumnFilters(column),
  );

  $$CleansTableFilterComposer get cleanId {
    final $$CleansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cleanId,
      referencedTable: $db.cleans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CleansTableFilterComposer(
            $db: $db,
            $table: $db.cleans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IssuesTableOrderingComposer
    extends Composer<_$AppDatabase, $IssuesTable> {
  $$IssuesTableOrderingComposer({
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

  ColumnOrderings<Uint8List> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get resolved => $composableBuilder(
    column: $table.resolved,
    builder: (column) => ColumnOrderings(column),
  );

  $$CleansTableOrderingComposer get cleanId {
    final $$CleansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cleanId,
      referencedTable: $db.cleans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CleansTableOrderingComposer(
            $db: $db,
            $table: $db.cleans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IssuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IssuesTable> {
  $$IssuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<Uint8List> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TagName, String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Priority, String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get resolved =>
      $composableBuilder(column: $table.resolved, builder: (column) => column);

  $$CleansTableAnnotationComposer get cleanId {
    final $$CleansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cleanId,
      referencedTable: $db.cleans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CleansTableAnnotationComposer(
            $db: $db,
            $table: $db.cleans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IssuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IssuesTable,
          Issue,
          $$IssuesTableFilterComposer,
          $$IssuesTableOrderingComposer,
          $$IssuesTableAnnotationComposer,
          $$IssuesTableCreateCompanionBuilder,
          $$IssuesTableUpdateCompanionBuilder,
          (Issue, $$IssuesTableReferences),
          Issue,
          PrefetchHooks Function({bool cleanId})
        > {
  $$IssuesTableTableManager(_$AppDatabase db, $IssuesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IssuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IssuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IssuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cleanId = const Value.absent(),
                Value<Uint8List?> image = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<TagName> tag = const Value.absent(),
                Value<Priority> priority = const Value.absent(),
                Value<bool> resolved = const Value.absent(),
              }) => IssuesCompanion(
                id: id,
                cleanId: cleanId,
                image: image,
                description: description,
                tag: tag,
                priority: priority,
                resolved: resolved,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cleanId,
                Value<Uint8List?> image = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required TagName tag,
                required Priority priority,
                Value<bool> resolved = const Value.absent(),
              }) => IssuesCompanion.insert(
                id: id,
                cleanId: cleanId,
                image: image,
                description: description,
                tag: tag,
                priority: priority,
                resolved: resolved,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IssuesTable, Issue>(table),
                  $$IssuesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cleanId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cleanId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cleanId,
                        referencedTable: $$IssuesTableReferences._cleanIdTable(
                          db,
                        ),
                        referencedColumn: $$IssuesTableReferences
                            ._cleanIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IssuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IssuesTable,
      Issue,
      $$IssuesTableFilterComposer,
      $$IssuesTableOrderingComposer,
      $$IssuesTableAnnotationComposer,
      $$IssuesTableCreateCompanionBuilder,
      $$IssuesTableUpdateCompanionBuilder,
      (Issue, $$IssuesTableReferences),
      Issue,
      PrefetchHooks Function({bool cleanId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$RoomsTableTableManager get rooms =>
      $$RoomsTableTableManager(_db, _db.rooms);
  $$CleansTableTableManager get cleans =>
      $$CleansTableTableManager(_db, _db.cleans);
  $$IssuesTableTableManager get issues =>
      $$IssuesTableTableManager(_db, _db.issues);
}
