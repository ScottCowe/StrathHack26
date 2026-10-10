import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:postgres/postgres.dart' as pg;

part 'app_database.g.dart';

@DriftDatabase(tables: [Users, Rooms, Cleans, Issues])
class AppDatabase extends _$AppDatabase {
  AppDatabase(Map<String, String> env) : super(_open(env));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onCreate: (m) async => m.createAll());

  static QueryExecutor _open(Map<String, String> env) {
    return PgDatabase(
      endpoint: pg.Endpoint(
        host: _required(env, 'DB_HOST'),
        port: int.parse(env['DB_PORT'] ?? '5432'),
        database: _required(env, 'DB_NAME'),
        username: _required(env, 'DB_USER'),
        password: _required(env, 'DB_PASSWORD'),
      ),
      settings: const pg.ConnectionSettings(sslMode: pg.SslMode.disable),
    );
  }

  static String _required(Map<String, String> env, String key) {
    final value = env[key];
    if (value == null || value.isEmpty) {
      throw StateError('Missing $key in .env');
    }
    return value;
  }
}

enum UserRole { cleaner, supervisor }

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get role => textEnum<UserRole>()();
  TextColumn get username => text().unique()();
  TextColumn get passwordHash => text()();
}

class Rooms extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get lastCleaned => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get kml => text().nullable()();
}

class Cleans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cleanedBy => integer().references(Users, #id)();
  IntColumn get auditedBy => integer().references(Users, #id).nullable()();
  IntColumn get room => integer().references(Rooms, #id)();
  BoolColumn get audited => boolean()();
  DateTimeColumn get auditTime => dateTime().nullable()();
  DateTimeColumn get cleanTime => dateTime()();
}

enum TagName { cleaners, external }

enum Priority { low, medium, high }

class Issues extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cleanId => integer().references(Cleans, #id)();
  BlobColumn get image => blob().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get tag => textEnum<TagName>()();
  //needs coords perhaps
  TextColumn get priority => textEnum<Priority>()();
}
