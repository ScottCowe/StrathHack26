import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:postgres/postgres.dart' as pg;

part 'app_database.g.dart';

@DriftDatabase(tables: [Users, Rooms, Cleans, Issues])
class AppDatabase extends _$AppDatabase {
  AppDatabase(Map<String, String> env) : super(_open(env));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onCreate: (m) async => m.createAll(),
      onUpgrade: ((m, from, to) async {
        if (from < 2) {
          await customStatement(
          'alter table cleans drop constraint cleans_room_fkey',
          );
          await customStatement(
            'alter table cleans add column room_name text',
          );
          await customStatement(
            'update cleans as c set room_name = r.name from rooms as r where c.room = r.id',
          );
          await customStatement(
            'alter table cleans alter column room_name set not null',
          );
          await customStatement('alter table cleans drop column room');
          await customStatement(
            'alter table cleans rename column room_name to room',
          );
          await customStatement(
            'alter table rooms drop constraint rooms_pkey',
          );
          await customStatement('alter table rooms drop column id');
          await customStatement(
            'alter table rooms add primary key (name)',
          );
          await customStatement(
            'alter table cleans add constraint cleans_room_fkey foreign key (room) references rooms (name)',
          );
        }
      }
    )
  );

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
  TextColumn get name => text()();
  DateTimeColumn get lastCleaned => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get kml => text().nullable()();

  @override
  Set<Column> get primaryKey => {name};
}

class Cleans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cleanedBy => integer().references(Users, #id)();
  IntColumn get auditedBy => integer().references(Users, #id).nullable()();
  IntColumn get room => integer().references(Rooms, #name)();
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
